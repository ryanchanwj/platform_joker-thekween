const AWS = require("aws-sdk");

const dynamo = new AWS.DynamoDB.DocumentClient();
const ses = new AWS.SES()

const createdDate = new Date().toLocaleString()

exports.handler = async (event, context) => {
  let body;

  // let requestJSON = JSON.parse(event.body);
  await dynamo
    .put({
      TableName: "orders_db",
      Item: {
        Username: event.username,
        Id: event.id,
        TotalAmount: event.total_amount,
        Currency: event.currency,
        CreatedAt: createdDate,
        OrderedItems: event.items
      }
    })
    .promise();
  body = `ID ${event.id}: Successfully created order for ${event.username}`;

  // Send email order confirmation to customer
  var email = event.username
  if (event.username.indexOf("@") == -1) {      
    email = email.replace('-at-', '@');
  }

  var orderDetails = ``
  
  event.items.forEach((item,j) => {
    orderDetails += `${j+1}. ${item.ItemName}\n    Quantity: ${item.Quantity}\n    Price: ${item.Price}\n\n`
  })
  
  var params = {
    Destination: {
      ToAddresses: [email,],
    },
    Message: {
      Body: {
        Text: { Data: `Hi ${event.username},
          
Your payment for order #${event.id} has been confirmed.

ORDER DETAILS:

Order Date: ${createdDate}
          
${orderDetails}
Total Payment: ${event.total_amount} ${event.currency}          
        ` },
      },

      Subject: { Data: "Your payment has been confirmed" },
    },
    Source: process.env.MAIL_SENDER,
  };
  
  await ses.sendEmail(params).promise()

  body = JSON.stringify(body);

  return body
};

