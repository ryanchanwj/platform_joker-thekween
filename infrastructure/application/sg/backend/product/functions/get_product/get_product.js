const AWS = require("aws-sdk");

const dynamo = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event, context) => {
    const product_id = event.queryStringParameters.product_id
	const headers = {
		"Content-Type": "application/json"
	};
	let statusCode = 200;
	let message;
	let data; 

	try {
		var params = {
		KeyConditionExpression: 'ProductId = :productid',
		ExpressionAttributeValues: {
			':productid': +product_id
		},
			TableName: "product_db"
		};

		data = await dynamo.query(params).promise();

		if (!data.Count) {
			throw new Error(`Product ID ${product_id} does not exist!`)
		}

		message = `Product ID ${product_id}`
	} catch (err) {
		statusCode = 406;
		data = err;
		message = err.message;
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

