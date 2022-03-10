const AWS = require("aws-sdk");
const cognitoIdentityServiceProvider = new AWS.CognitoIdentityServiceProvider();
const sqs = new AWS.SQS({apiVersion: '2012-11-05'});

// const USER_POOL_ID = "<userpool_id>";
const stripe = require("stripe")(process.env.STRIPE_SECRET);

var params = {
  AttributeNames: [
    // "All"
    "SentTimestamp"
  ],
  MaxNumberOfMessages: 10,
  MessageAttributeNames: [
    "All"
  ],
  QueueUrl: process.env.sqs_url,
  VisibilityTimeout: 20,
  WaitTimeSeconds: 0
};

// const getUserEmail = async (event) => {
//   const params = {
//     UserPoolId: USER_POOL_ID,
//     Username: event.identity.claims.username
//   };
//   const user = await cognitoIdentityServiceProvider.adminGetUser(params).promise();
//   const { Value: email } = user.UserAttributes.find((attr) => {
//     if (attr.Name === "email") {
//       return attr.Value;
//     }
//   });
//   return email;
// };

exports.handler = async (event) => {
  let body;
  let statusCode = 200;
  const headers = {
    "Content-Type": "application/json"
  };

  // Poll SQS
  try {
    body = await sqs.receiveMessage(params).promise()
    var messages = body["Messages"]
    for (var i = 0; i < messages.length; i++) {
      var message = messages[i];
      var message_attributes = message["MessageAttributes"]
      var ItemIds = message_attributes["ItemIds"]["StringValue"] // "1,2"
      var ItemNames = message_attributes["ItemNames"]["StringValue"] // "item1,item2"
      var Prices = message_attributes["Prices"]["StringValue"] // "9.99,1.99"
      var Quantities = message_attributes["Quantities"]["StringValue"] // "1,2"
      var timestamp = message["Attributes"]["SentTimestamp"] // "1646735021507"

    }
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


  // Call Stripe API
  // try {
    
  //   // const { id, cart, total, address, token } = event.arguments.input;
  //   // const { username } = event.identity.claims;
  //   // const email = await getUserEmail(event);

  //   // await stripe.charges.create({
  //   //   amount: total * 100,
  //   //   currency: "usd",
  //   //   source: token,
  //   //   description: `Order ${new Date()} by ${email}`
  //   // });
  //   return { id, cart, total, address, username, email };
  // } catch (err) {
  //   throw new Error(err);
  // }
};