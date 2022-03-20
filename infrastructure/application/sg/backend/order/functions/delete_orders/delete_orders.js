const AWS = require("aws-sdk");

const dynamo = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event, context) => {
  let body;  

  let requestJSON = JSON.parse(event.body);
  let username = requestJSON.username
  let id = requestJSON.id

  // let username = event.username
  // let id = event.id

  const params = {
    TableName : 'orders_db',
    Key: {
      Username: username,
      Id: id,
    }
  }
  
  await dynamo
      .delete(params)
      .promise();
        
  body = `Successfully removed order id ${id} for ${username}`;
  
  body = JSON.stringify(body);

  return body
};

