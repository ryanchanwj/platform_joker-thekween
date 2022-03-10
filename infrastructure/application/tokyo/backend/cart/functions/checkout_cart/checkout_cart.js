const AWS = require("aws-sdk");

const dynamo = new AWS.DynamoDB.DocumentClient();

const stripe = require("stripe")(process.env.STRIPE_SECRET);

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
   
    // Call Stripe API
    try {
      const { id, cart, total, address, token } = event.arguments.input;
      const { username } = event.identity.claims;
      const email = await getUserEmail(event);

      await stripe.charges.create({
        amount: total * 100,
        currency: "usd",
        source: token,
        description: `Order ${new Date()} by ${email}`
      });
      return { id, cart, total, address, username, email };
    } catch (err) {
      throw new Error(err);
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
};
