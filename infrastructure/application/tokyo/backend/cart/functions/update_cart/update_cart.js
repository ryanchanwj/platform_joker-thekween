const AWS = require("aws-sdk");

const dynamo = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event, context) => {
  let body;
  let statusCode = 200;
  const headers = {
    "Content-Type": "application/json"
  };

  try {
    let requestJSON = JSON.parse(event.body);
    const params = {
      TableName : 'cart_db',
      Key: {
        UserId: requestJSON.user_id,
        Id: requestJSON.id,
      }
    }
    
    body = await dynamo
          .get(params)
          .promise();
          
    await dynamo
      .put({
        TableName: "cart_db",
        Item: {
          UserId: requestJSON.user_id,
          Id: requestJSON.id,
          ItemName: body.Item.ItemName,
          Price: body.Item.Price,
          Quantity: requestJSON.quantity
        }
      })
      .promise();
    body = `ID ${requestJSON.id}: Successfully updated item ${body.Item.ItemName} quantity to ${requestJSON.quantity} for userid ${requestJSON.user_id}`;
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

