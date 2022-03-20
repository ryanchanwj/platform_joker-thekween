const AWS = require("aws-sdk");

const dynamo = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event, context) => {
  let body;

  let requestJSON = JSON.parse(event.body);
  let username = requestJSON.username
  let id = requestJSON.id
  let quantity = requestJSON.quantity

  // let username = event.username
  // let id = event.id
  // let quantity = event.quantity

  const params = {
    TableName : 'cart_db',
    Key: {
      Username: username,
      Id: id,
    }
  }
  
  body = await dynamo
        .get(params)
        .promise();
        
  await dynamo
    .put({
      TableName: "cart_db",
      Item: {
        Username: username,
        Id: id,
        ItemName: body.Item.ItemName,
        Price: body.Item.Price,
        Quantity: quantity,
        ItemId: body.Item.ItemId
      }
    })
    .promise();
  body = `ID ${id}: Successfully updated item ${body.Item.ItemName} quantity to ${quantity} for ${username}`;

  body = JSON.stringify(body);
  
  return body
};

