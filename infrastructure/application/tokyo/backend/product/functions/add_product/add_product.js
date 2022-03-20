const AWS = require("aws-sdk");

const dynamo = new AWS.DynamoDB.DocumentClient();

exports.handler = async (event, context) => {
    const req = JSON.parse(event.body)
    const headers = {
        "Content-Type": "application/json"
    };
    let statusCode = 200;
    let message;
    let data;
    let createDao;

    try {
        const params = {
            TableName : 'product_db',
            Key: {
              ProductId: req.product_id,
            }
        }
        
        const result = await dynamo
                            .get(params)
                            .promise();
                    
    		if (result.Item) {
    			throw new Error(`Product ID ${req.product_id} already exist!`)
    		}

        createDao = {
            ProductId: req.product_id,
            ProductName: req.product_name,
            Price: req.price,
            Rating: req.rating ? req.rating : 0,
            Quantity: req.quantity,
            ImageUrl: req.image_url ? req.rating : ""
        }
        await dynamo
            .put({
                TableName: "product_db",
                Item: createDao
            })
            .promise();
    
        message = `Successfully added product '${req.product_name}' of id '${req.product_id}'`;
    } catch (err) {
        statusCode = 406;
        message = err.message;
        data = err;
    }

    let body = JSON.stringify({
        statusCode: statusCode,
        message: message,
        data: createDao
    });

    return {
        headers,
        statusCode,
        body
    }
};

