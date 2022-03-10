const AWS = require("aws-sdk");

const dynamo = new AWS.DynamoDB.DocumentClient();

// Create an SQS service object
const sqs = new AWS.SQS({apiVersion: '2012-11-05'});

exports.handler = async (event, context) => {
  let body;
  let statusCode = 200;
  const headers = {
    "Content-Type": "application/json"
  };

  try {
    // Get all cart items for the user 
    let requestJSON = JSON.parse(event.body);
    var params = {
        KeyConditionExpression: 'UserId = :userid',
        ExpressionAttributeValues: {
            ':userid': requestJSON.user_id
        },
        TableName: "cart_db"
    };
    body = await dynamo.query(params).promise()
    // console.log(JSON.stringify(body))

    // Parse cart details into variables
    var item_names = "";
    var item_ids = "";
    var quantities = "";
    var prices = "";

    var items = body.Items;
    for (var i = 0; i < items.length; i++) { 
      var item = items[i];

      if (item_names != "") {
        item_names += "," + item.ItemName
      } else {
        item_names += item.ItemName
      }

      if (item_ids != "") {
        item_ids += "," + item.ItemId.toString()
      } else {
        item_ids += item.ItemId.toString()
      }

      if (quantities != "") {
        quantities += "," + item.Quantity.toString()
      } else {
        quantities += item.Quantity.toString()
      }

      if (prices != "") {
        prices += "," + item.Price.toString()
      } else {
        prices += item.Price.toString()
      }
    } 

    // Send details to SQS queue 

    // Queue message should include item names, item ids, quantity, individual price, total price
    var params = {
     // Remove DelaySeconds parameter and value for FIFO queues
    // DelaySeconds: 10,
     MessageAttributes: {
       "ItemNames": {
         DataType: "String",
         StringValue: item_names // "Item1,Item2"
       },
       "ItemIds": {
         DataType: "String",
         StringValue: item_ids // "1,2"
       },
       "Quantities": {
         DataType: "String",
         StringValue: quantities // "1,1"
       },
       "Prices": {
          DataType: "String",
          StringValue: prices // "99.99,59.99"
       }
     },
     MessageBody: "Information about the order",
     MessageDeduplicationId: "joke",  // Required for FIFO queues
      MessageGroupId: "jokeGroup",  // Required for FIFO queues
     QueueUrl: process.env.sqs_url
   };
   
  body["params"] = params;
  body["sqs_resp_data"] = await sqs.sendMessage(params).promise()

  } catch (err) {
    statusCode = 400;
    body = err.message;
  } finally {
    body = JSON.stringify(body);
  }

  return {
    statusCode, 
    body,
    headers
  };
};
