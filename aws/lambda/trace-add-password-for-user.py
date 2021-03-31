import json
import urllib3

def lambda_handler(event, context):
    
    username = event['queryStringParameters']['username']
    password = event['queryStringParameters']['password']
    
    couchUrl = 'http://ec2-18-219-243-170.us-east-2.compute.amazonaws.com:5984/public-pages/' + username
    http = urllib3.PoolManager()
    
    r1 = http.request(
        'GET',
        couchUrl,
        headers={
            'Authorization': 'Basic cHVibGljcGFnZXN3cml0ZXI6YjZZRTJjemZLeE5wOFMzVTJQcFFtRkgzN0pmZW10'
        }
    )
    
    requestbody = """<!DOCTYPE html>
        <html>
        <head>
        
        <link href="https://cdn.rawgit.com/mdehoog/Semantic-UI/6e6d051d47b598ebab05857545f242caf2b4b48c/dist/semantic.min.css" rel="stylesheet" type="text/css" />
        <script src="https://code.jquery.com/jquery-2.1.4.js"></script>
        <script src="https://cdn.rawgit.com/mdehoog/Semantic-UI/6e6d051d47b598ebab05857545f242caf2b4b48c/dist/semantic.min.js"></script>
        
        <style>
        .container {
          height: 200px;
          position: relative;
          border: 3px solid green;
        }
        
        .center {
          margin: 0;
          position: absolute;
          top: 30%;
          left: 50%;
          width: 50%;
          -ms-transform: translate(-50%, -50%);
          transform: translate(-50%, -50%);
        }
        </style>
        
        </head>
        
        <body style="background-color:#1e1e2f">
        
        <script>
            function maybeRedirect(){
        	var x = document.forms["passwordform"]["password"].value;     
        
        	if(x == \"""" + password + """\"){
        	        const urlParams = new URLSearchParams(window.location.search);
                    const passuser = urlParams.get('username');
                    window.location.replace('https://76gjqug5j8.execute-api.us-east-2.amazonaws.com/prod/get?username=' + passuser);
                } else {
        	    alert('The password you provided was incorrect');
        	}
                return false;
            }
        </script>
        
        <form class="ui form center" name="passwordform" onsubmit="return maybeRedirect()">
          <div class="field">
            <label style="color:white">Please enter the password to view this page:</label>
            <input type="text" name="password" placeholder="Password">
          </div>
          <button class="ui button" type="submit">Submit</button>
        </form>
        </body>
        </html>"""
    
    if r1.status == 200:
        rev = json.loads(r1.data.decode('utf-8')).get('_rev')
        
        r2 = http.request(
            'PUT',
            couchUrl + '/password',
            body=requestbody,
            headers={
                'Authorization': 'Basic cHVibGljcGFnZXN3cml0ZXI6YjZZRTJjemZLeE5wOFMzVTJQcFFtRkgzN0pmZW10',
                'If-Match': rev,
                'Content-Type': 'text/html'
            }
        )
    else:
        r2 = http.request(
            'PUT',
            couchUrl + '/password',
            body=requestbody,
            headers={
                'Authorization': 'Basic cHVibGljcGFnZXN3cml0ZXI6YjZZRTJjemZLeE5wOFMzVTJQcFFtRkgzN0pmZW10',
                'Content-Type': 'text/html'
            }
        )
    
    
    return {
        'statusCode': r2.status,
        'body': json.dumps('Entry successfully updated')
    }
