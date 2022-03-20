const AWS = require("aws-sdk");

const dynamo = new AWS.DynamoDB.DocumentClient();

const ses = new AWS.SES()

const lambda = new AWS.Lambda()

const createdDate = new Date().toLocaleString()

const stripe = require("stripe")(process.env.STRIPE_SECRET);

var CUSTOMEPOCH = 1300000000000; // artificial epoch

function generateOrderId(shardId /* range 0-64 for shard/slot */) {
  var ts = new Date().getTime() - CUSTOMEPOCH; // limit to recent
  var randid = Math.floor(Math.random() * 512);
  ts = (ts * 64);   // bit-shift << 6
  ts = ts + shardId;
  return (ts * 512) + randid;
}

module.exports.handler = async (event, context) => {
  let body;

  let requestJSON = JSON.parse(event.body);
  let username = requestJSON.username
  // let username = event.username

  // Get all cart items for the user 
  var params = {
      KeyConditionExpression: 'Username = :username',
      ExpressionAttributeValues: {
          ':username': username
      },
      TableName: "cart_db"
  };
  var cart_items = await dynamo.query(params).promise()

  // Calculate total
  var items = cart_items.Items;
  var total = 0;
  for (let i = 0; i < items.length; i++) { 
    var item = items[i];
    total += item.Price * item.Quantity;
  }  

  // Call Stripe API
  var payment_resp = await stripe.paymentIntents.create({
    amount: total * 100,
    currency: 'sgd',
    payment_method: 'pm_card_visa',
  });

  // const { id, cart, total, address, token } = event.arguments.input;
  // const { username } = event.identity.claims;
  // const email = await getUserEmail(event);

  // Clear cart and update product quantity
  for (let i = 0; i < items.length; i++) { 
    var item = items[i];

    // Clear cart
    let clearCartParams = {
      TableName : 'cart_db',
      Key: {
        Username: username,
        Id: item.Id,
      }
    }
    
    await dynamo
        .delete(clearCartParams)
        .promise();

    // let cartData = { username: username, id: item.Id};

    // var clearCartParams = {
    //   FunctionName: process.env.CLEAR_CART_LAMBDA, /* required */
    //   InvocationType: "RequestResponse",
    //   Payload: JSON.stringify(cartData),
    // };
    
    // lambda.invoke(clearCartParams).promise()

    // Update product quantity
    let getProductParams = {
      KeyConditionExpression: 'ProductId = :productid',
      ExpressionAttributeValues: {
          ':productid': item.ItemId
      },
      TableName: "product_db"
    };

    let getProductResp = await dynamo.query(getProductParams).promise()
    // let getProductData = {
    //   product_id: item.ItemId,
    // }

    // var getProductParams = {
    //   FunctionName: process.env.GET_PRODUCT_LAMBDA, /* required */
    //   InvocationType: "RequestResponse",
    //   Payload: JSON.stringify(getProductData),
    // };

    // let getProductResp = await lambda.invoke(getProductParams).promise()
    
    // let payload = JSON.parse(getProductResp.Payload)
    // let product = JSON.parse(payload.body).Items

    let product = getProductResp.Items

    await dynamo
      .put({
        TableName: "product_db",
        Item: {
          ProductId: product[0].ProductId,
          ProductName: product[0].ProductName,
          Price: product[0].Price,
          Rating: product[0].Price.Rating,
          Quantity: product[0].Quantity - item.Quantity
        }
      })
    .promise();
    
    // let updateProductData = {
    //   product_id: product[0].ProductId,
    //   product_name: product[0].ProductName,
    //   price: product[0].Price,
    //   quantity: product[0].Quantity - item.Quantity
    // }

    // var updateProductParams = {
    //   FunctionName: process.env.UPDATE_PRODUCT_LAMBDA, /* required */
    //   InvocationType: "RequestResponse",
    //   Payload: JSON.stringify(updateProductData),
    // };

    // lambda.invoke(updateProductParams).promise()
  }

  // Create order
  var orderId = generateOrderId(1);

  await dynamo
  .put({
    TableName: "orders_db",
    Item: {
      Username: username,
      Id: orderId,
      TotalAmount: payment_resp.amount / 100,
      Currency: payment_resp.currency,
      CreatedAt: createdDate,
      OrderedItems: cart_items.Items
    }
  })
  .promise();

  // Send email order confirmation to customer
  var email = username
  if (username.indexOf("@") == -1) {      
    email = email.replace('-at-', '@');
  }

  var orderDetails = ``

  cart_items.Items.forEach((item,j) => {
    orderDetails += `${j+1}. ${item.ItemName}\n    Quantity: ${item.Quantity}\n    Price: ${item.Price}\n\n`
  })

  var params = {
    Destination: {
      ToAddresses: [email,],
    },
    Message: {
      Body: {
        Text: { Data: `Hi ${username},
          
  Your payment for order #${orderId} has been confirmed.

  ORDER DETAILS:

  Order Date: ${createdDate}
          
  ${orderDetails}
  Total Payment: ${payment_resp.amount / 100} ${payment_resp.currency}          
        ` },
      },

      Subject: { Data: "Your payment has been confirmed" },
    },
    Source: process.env.MAIL_SENDER,
  };

  await ses.sendEmail(params).promise()
  
  body = `ID ${orderId}: Successfully created order for ${username}`;

  // let orderData = { 
  //   username: username, 
  //   id: orderId,
  //   total_amount: payment_resp.amount / 100,
  //   currency: payment_resp.currency,
  //   items: cart_items.Items,
  // };

  // var createOrderParams = {
  //   FunctionName: process.env.CREATE_ORDER_LAMBDA, /* required */
  //   InvocationType: "RequestResponse",
  //   Payload: JSON.stringify(orderData),
  // };
  
  // body = await lambda.invoke(createOrderParams).promise()
  
  body = JSON.stringify(body);

  return body
};
