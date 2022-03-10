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
    await dynamo
      .put({
        TableName: "orders_db",
        Item: {
          UserId: requestJSON.user_id,
          Id: requestJSON.id,
          ItemName: requestJSON.item_name,
          Price: requestJSON.price,
          Quantity: requestJSON.quantity
        }
      })
      .promise();
    body = `ID ${requestJSON.id}: Successfully added item '${requestJSON.item_name}' of quantity '${requestJSON.quantity}' for UserId ${requestJSON.user_id}`;
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

