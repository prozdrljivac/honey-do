import json


def handler(event, context):
    tasks = [
        {"id": 1, "title": "Buy groceries", "completed": False},
        {"id": 2, "title": "Walk the dog", "completed": True},
    ]

    return {
        "statusCode": 200,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
        },
        "body": json.dumps(tasks),
    }
