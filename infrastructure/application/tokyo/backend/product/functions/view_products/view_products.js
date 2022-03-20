const AWS = require("aws-sdk");

const dynamo = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event, context) => {
    const headers = {
        "Content-Type": "application/json"
    };
    let statusCode = 200;
    let message;
    let data; 
    try {
        const params = {
            // Set the projection expression, which are the attributes that you want.
            ProjectionExpression: "ProductId, ProductName, Price, Rating, Quantity, ImageURL",
            TableName: "product_db",
        };
    
        data = await dynamo.scan(params).promise()
        message = 'Products retrieved successfully!'
    } catch (err) {
        statusCode = 406;
        message = err.message;
        data = err;
    }

    let body = JSON.stringify({
        statusCode: statusCode,
        message: message,
        data: data
    });

    return {
        headers,
        statusCode,
        body
    }
};

