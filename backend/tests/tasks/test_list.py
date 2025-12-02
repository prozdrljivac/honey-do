from src.tasks.list_tasks import handler as list_tasks


def test_list_tasks_on_success_returns_200():
    event = {}
    context = {}

    response = list_tasks(event, context)

    assert response["statusCode"] == 200


def test_list_tasks_on_success_returns_apropriate_headers():
    event = {}
    context = {}

    response = list_tasks(event, context)

    assert response["headers"]["Content-Type"] == "application/json"
    assert response["headers"]["Access-Control-Allow-Origin"] == "*"
