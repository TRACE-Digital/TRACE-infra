import json
import urllib3

def lambda_handler(event, context):
    
    username = event['queryStringParameters']['username']
    customurl = event['queryStringParameters']['customurl']
    
    couchUrl = 'http://ec2-18-219-243-170.us-east-2.compute.amazonaws.com:5984/custom-link-map/' + customurl
    http = urllib3.PoolManager()
    
    r1 = http.request(
        'GET',
        couchUrl,
        headers={
            'Authorization': 'Basic cHVibGljcGFnZXN3cml0ZXI6YjZZRTJjemZLeE5wOFMzVTJQcFFtRkgzN0pmZW10'
        }
    )
    
    if r1.status == 200:
        rev = json.loads(r1.data.decode('utf-8')).get('_rev')
        
        r2 = http.request(
            'PUT',
            couchUrl,
            body=json.dumps({ 'username': username }).encode(),
            headers={
                'Authorization': 'Basic cHVibGljcGFnZXN3cml0ZXI6YjZZRTJjemZLeE5wOFMzVTJQcFFtRkgzN0pmZW10',
                'If-Match': rev,
                'Content-Type': 'text/plain'
            }
        )
    else:
        r2 = http.request(
            'PUT',
            couchUrl,
            body=json.dumps({ 'username': username }).encode(),
            headers={
                'Authorization': 'Basic cHVibGljcGFnZXN3cml0ZXI6YjZZRTJjemZLeE5wOFMzVTJQcFFtRkgzN0pmZW10',
                'Content-Type': 'text/plain'
            }
        )
        print('Done')
    
    
    return {
        'statusCode': r2.status,
        'body': json.dumps('Entry successfully updated')
    }

