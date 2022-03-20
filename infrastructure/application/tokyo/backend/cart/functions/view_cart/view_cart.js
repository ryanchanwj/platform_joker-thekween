const AWS = require("aws-sdk");

const dynamo = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event, context) => {
  let body;

  // let requestJSON = JSON.parse(event.body);
  // let username = requestJSON.username

  let username = event.username

  var params = {
      KeyConditionExpression: 'Username = :username',
      ExpressionAttributeValues: {
          ':username': username
      },
      TableName: "cart_db"
  };
  body = await dynamo.query(params).promise()
  console.log(JSON.stringify(body))

  body = JSON.stringify(body);
  
  return body
};

