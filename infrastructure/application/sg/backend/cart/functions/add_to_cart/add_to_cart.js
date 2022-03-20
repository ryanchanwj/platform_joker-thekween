const AWS = require("aws-sdk");

const dynamo = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event, context) => {
  let body;

  let requestJSON = JSON.parse(event.body);
  let username = requestJSON.username
  let id = requestJSON.id
  let itemname = requestJSON.item_name
  let price = requestJSON.price
  let quantity = requestJSON.quantity
  let itemid = requestJSON.item_id

  // let username = event.username
  // let id = event.id
  // let itemname = event.item_name
  // let price = event.price
  // let quantity = event.quantity
  // let itemid = event.item_id

  await dynamo
    .put({
      TableName: "cart_db",
      Item: {
        Username: username,
        Id: id,
        ItemName: itemname,
        Price: price,
        Quantity: quantity,
        ItemId: itemid
      }
    })
    .promise();
    
  body = `ID ${id}: Successfully added item '${itemname}' of quantity '${quantity}' for ${username}`;
  
  body = JSON.stringify(body);

  return body
};

