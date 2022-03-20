const AWS = require("aws-sdk");

const dynamo = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event, context) => {
    const req = JSON.parse(event.body)
    const headers = {
        "Content-Type": "application/json"
    };
    let statusCode = 200;
    let message;
    let data = {};
    let productId = req.product_id

    try {
        const params = {
            TableName : 'product_db',
            Key: {
              ProductId: productId,
            }
        }
        
        const result = await dynamo
                            .get(params)
                            .promise();
                    
		if (!result.Item) {
			throw new Error(`Product ID ${productId} does not exist!`)
		}
        
        await dynamo
            .delete(params)
            .promise();
                
        message = `Successfully removed product id ${productId}`;
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

