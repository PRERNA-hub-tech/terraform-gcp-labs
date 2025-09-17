def pubsub_handler(event, context):
    import base64
    message = base64.b64decode(event['data']).decode('utf-8')
    print(f"Received message: {message}")
