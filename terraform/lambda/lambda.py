import json
import os
import boto3

dynamodb = boto3.resource("dynamodb")
table = dynamodb.Table(os.environ["DYNAMODB_TABLE"])

def handler(event, context):
    try:
        request_body = json.loads(event["body"])
        item_id = int(table.scan()["Count"] + 1)

        item = {
            "id": item_id
        }

        for key, value in request_body.items():
            item[key] = value

        table.put_item(Item=item)

        response = {
            "statusCode": 200,
            "body": json.dumps({"message": "Data stored successfully", "id": item_id})
        }
    except Exception as e:
        response = {
            "statusCode": 500,
            "body": json.dumps({"message": "An error occurred", "error": str(e)})
        }

    return response
