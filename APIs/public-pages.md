# Trace Public Pages API Documentation

## General:

* ### [DEPRICATED] Creating Public Pages:

  Description: Creates a public profile page for the given user, which is accessible using the "Getting/Viewing Public Pages" API below. If a page already exists for the given user, this API will not overwrite it.
  
  API Address: https://76gjqug5j8.execute-api.us-east-2.amazonaws.com/prod/create?username={username}
  
  Query Parameters: {username}: The username of the user for whom the public page is being created
  
  Required Headers: 'Content-Type': 'text/html'

  Body: The raw html of the desired public facing page

* ### Updating Public Pages:
 
  Description: Updates an existing public profile page, or creates one if no page exists yet for the given user. The page is accessible using the "Getting/Viewing Public Pages" API below.
 
  API Address: https://76gjqug5j8.execute-api.us-east-2.amazonaws.com/prod/update?username={username}
  
  Query Parameters: {username}: The username of the user for whom the public page is being created
  
  Required Headers: 'Content-Type': 'text/html'
  
  Body: The raw html of the desired public facing page

* ### Getting/Viewing Public Pages:

  Description: This API acts as a web server for the public facing profile page of the given user, returning html which is then rendered in browser.

  API Address: https://76gjqug5j8.execute-api.us-east-2.amazonaws.com/prod/get?username={username}
  
  Query Parameters: {username}: The username of the user to whom the public page belongs
  
  Required Headers: None
  
  Body: None

## Password Protection:

* ### Adding/Changing a Password:

  IMPORTANT: This API does not lock the user's existing public facing page.

  Description: This API creates a new page which will prompt users for a password before redirecting them to the user's actual public facing page.

  API Address: https://76gjqug5j8.execute-api.us-east-2.amazonaws.com/prod/createpassword?username={username}&password={password}
  
  Query Parameters:
  * {username}: The username of the user making the request
  * {password}: The password which will be required to access this user's public page.
  
  Required Headers: None
  
  Body: None
  
* ### Getting/Viewing Password Pages:

  IMPORTANT: The password page is superficial only, and does not provide any actual security. Please do not view the existence of a password page as a green light to post sensitive or private information on a public facing profile page. The authentication is trivial to break and once users have access to the public page, they may retain access indefinitely.

  Description: This API acts as a web server for the password page of the given user, returning html which is then rendered in browser. Upon entering a correct password, the user is then redirected to the corresponding public profile page.
  
  API Address: https://76gjqug5j8.execute-api.us-east-2.amazonaws.com/prod/getpassword?username={username}
  
  Query Parameters: {username}: The username of the user whom the desired public page belongs to
  
  Required Headers: None
  
  Body: None
  
* ### Deleting/Disabling Password Pages:

  Description: Calling this API deletes the password page for the given user.
  
  API Address: https://76gjqug5j8.execute-api.us-east-2.amazonaws.com/prod/deletepassword?username={username}
  
  Query Parameters: {username}: The username of the user whom the desired public page belongs to
  
  Required Headers: None
  
  Body: None

## Custom URLs:
  
* ### Creating/Editing a Custom URL:

  Description: Calling this API creates a custom URL which redirects to the user's primary URL.
  
  API Address: https://76gjqug5j8.execute-api.us-east-2.amazonaws.com/prod/custom/create?username={username}&customurl={customurl}
  
  Query Parameters:
  * {username}: The username of the user whom the desired public page belongs to
  * {customurl}: The new URL suffix the user would like to resolve to their public page
  
  Required Headers: None
  
  Body: None
  
* ### Navigating to a Custom URL:

  Description: This API acts as a web server which returns the corresponding user's public page.
  
  API Address: https://76gjqug5j8.execute-api.us-east-2.amazonaws.com/prod/u/{customurl}
  
  Path Parameters:
  * {customurl}: The suffix the user would like to navigate to
  
  Required Headers: None
  
  Body: None
 
