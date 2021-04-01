import json
import urllib3

def lambda_handler(event, context):
    
    print('event:', json.dumps(event))
    print('queryStringParameters:', json.dumps(event['pathParameters']))
    
    customurl = event['pathParameters']['customurl']
    
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
        username = json.loads(r1.data.decode('utf-8')).get('username')
        print(username)
        
        r2 = http.request(
            'GET',
            'http://ec2-18-219-243-170.us-east-2.compute.amazonaws.com:5984/public-pages/' + username + '/html',
            headers={
                'Authorization': 'Basic cHVibGljcGFnZXN3cml0ZXI6YjZZRTJjemZLeE5wOFMzVTJQcFFtRkgzN0pmZW10'
            }
        )
        
        return {
            'statusCode': r2.status,
            'headers': {'Content-Type': 'text/html'},
            'body': r2.data.decode('utf-8')
        }
        
    else:
        print(r1.status)
        return {
            'statusCode': 404,
            'body': json.dumps('Page could not be reached')
        }

