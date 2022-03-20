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
                    
		if (!result.Count) {
			throw new Error(`Product ID ${req.product_id} does not exist!`)
		}
                
        const updateDao = {
            ProductId: req.product_id,
            ProductName: req.product_name,
            Price: req.price,
            Rating: result.Item.Rating,
            Quantity: req.quantity,
            ImageUrl: req.image_url
        }
        await dynamo
            .put({
                TableName: "product_db",
                Item: updateDao
            })
            .promise();
        
        message = `ID ${updateDao.ProductId}: Successfully updated product ${updateDao.ProductName} of quantity ${updateDao.Quantity} and price ${updateDao.Price}`;
        data = updateDao;
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

