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
      TableName : 'orders_db',
      Key: {
        UserId: requestJSON.user_id,
        Id: requestJSON.id,
      }
    }
    
    await dynamo
        .delete(params)
        .promise();
          
    body = `Successfully removed id ${requestJSON.id} for userid ${requestJSON.user_id}`;
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

