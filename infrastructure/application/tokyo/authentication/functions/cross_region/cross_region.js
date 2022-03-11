const AWS = require("aws-sdk");

const cognito = new AWS.CognitoIdentityServiceProvider({region:process.env.CognitoRegion});

exports.handler = async (event, context) => {
  try {
     await cognito
      .adminCreateUser({
        UserPoolId: process.env.UserPoolId, /* required */
        Username: event.userName, /* required */
        MessageAction: "SUPPRESS",
        TemporaryPassword: "qwerty",
        UserAttributes: [
          {
            Name: "email",
            Value: event.request.userAttributes.email
          },
          {
            Name: 'email_verified',
            Value: event.request.userAttributes.email_verified
          },
        ]
      })
      .promise();
    // body = await cognito
    //   .adminSetUserPassword({
    //     Password: password, /* required */
    //     UserPoolId: process.env.UserPoolId, /* required */
    //     Username: userName,
    //     Permanent: true,
    //   })
    //   .promise();
  } catch (err) {
    context.done(err.message, event);
  } 
  context.done(null, event);
};

