import boto3

client = boto3.client('dynamodb')

def generate_report_handler(event, context):
    try:
        requestJSON = JSON.parse(event.body)
        data = client.put_item(
        TableName='cart_db',
        Item={
            'UserId': {
                'N': requestJSON.user_id
            },
            'Id': {
                'N': requestJSON.id
            },
            'ItemName': {
                'S': requestJSON.item_name
            },
            'Price': {
                'N': requestJSON.price
            },
            'Quantity': {
                'N': requestJSON.quantity
            }
        }
        )

        body = f"ID ${requestJSON.id}: Successfully added item '${requestJSON.item_name}' of quantity '${requestJSON.quantity}' for UserId ${requestJSON.user_id}"

        response = {
            'statusCode': 200,
            'body': body,
            'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
            },
        }
    except ClientError as e:
        response = {
            'statusCode': 200,
            'body': e.response['Error']['Message'],
            'headers': {
            'Content-Type': 'application/json',
            'Access-Control-Allow-Origin': '*'
            },
        }
    return response
