def handler(event, context):
    # TODO Implemente delete task logic
    return {
        "statusCode": 204,
        "headers": {
            "Content-Type": "application/json",
            "Access-Control-Allow-Origin": "*",
        },
    }
