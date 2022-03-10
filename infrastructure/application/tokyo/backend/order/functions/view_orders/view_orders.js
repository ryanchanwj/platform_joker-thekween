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
    var params = {
        KeyConditionExpression: 'UserId = :userid',
        ExpressionAttributeValues: {
            ':userid': requestJSON.user_id
        },
        TableName: "orders_db"
    };
    body = await dynamo.query(params).promise()
    console.log(JSON.stringify(body))

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

