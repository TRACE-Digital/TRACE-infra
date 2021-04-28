# Trace Public Pages API Documentation
## Table of Contents:
* [General Public Pages APIs]()
* [Password Protection APIs]()
* [Custom URL APIs]()
* [Public Page Status API]()

## General Public Pages APIs:

* ### Creating/Updating Public Pages:
 
  Description: Updates an existing public profile page, or creates one if no page exists yet for the given user. The page is accessible using the "Getting/Viewing Public Pages" API below.
 
  API Address: https://76gjqug5j8.execute-api.us-east-2.amazonaws.com/prod/update?username={username}
  
  Query Parameters: {username}: The username of the user for whom the public page is being created
  
  Required Headers: 'Content-Type': 'text/html'
  
  Body: The raw html of the desired public facing page

* ### Getting/Viewing Public Pages:

  Description: This API acts as a web server for the public facing profile page of the given user, returning html which is then rendered in browser. If a password is configured for the public page, a page requesting a password will be served first, with the actual public page being served upon successful authentication.

  API Address: https://76gjqug5j8.execute-api.us-east-2.amazonaws.com/prod/get?username={username}&password={password}
  
  Query Parameters: {username}: The username of the user to whom the public page belongs
  
  Optional Query Parameter: {password} may be included with the correct value to directly bypass the password page.
  
  Required Headers: None
  
  Body: None

* ### Unpublishing Public Pages

  Description: This API unpublishes the specified user's public page, making it inaccessible from the shareable link. It also deletes any password assets the user has. It does not delete custom URLs claimed by the user, since the user may wish to take their page offline temporarily but still keep their domain claimed. This API does not affect the page settings in the editor; only the copy stored for public consumption.
  
  API Address: https://76gjqug5j8.execute-api.us-east-2.amazonaws.com/prod/unpublish?username={username}
  
  Query Paramters: {username}: The username of the user to whom the public page belongs
  
  Required Headers: None
  
  Body: None

## Password Protection APIs:

* ### Adding/Changing a Password:

  Description: This API allows a user to set a password for their public page. After configuration, when the user navigates to their public page, they will be prompted to enter the password before they are served the public page itself.

  API Address: https://76gjqug5j8.execute-api.us-east-2.amazonaws.com/prod/createpassword?username={username}&password={password}
  
  Query Parameters:
  * {username}: The username of the user making the request
  * {password}: The password which will be required to access this user's public page.
  
  Required Headers: None
  
  Body: None
  
* ### Getting/Viewing Password Pages:

  [DEPRICATED]
  
  The password page is now integrated with the standard public page endpoint, and is no longer served independently. Please refer to the above API for getting/viewing public pages to view the password page for a password-protected page.
  
* ### Deleting/Disabling Password:

  Description: Calling this API removes the password requirement to access the public page of the specified user.
  
  API Address: https://76gjqug5j8.execute-api.us-east-2.amazonaws.com/prod/removepassword?username={username}
  
  Query Parameters: {username}: The username of the user whom the desired public page belongs to
  
  Required Headers: None
  
  Body: None

## Custom URL APIs:
  
* ### Creating/Editing a Custom URL:

  Description: Calling this API creates a custom URL which also serves the user's public page. If the user already has a custom URL, it deletes the old one as well.
  
  API Address: https://76gjqug5j8.execute-api.us-east-2.amazonaws.com/prod/custom/create?username={username}&customurl={customurl}
  
  Query Parameters:
  * {username}: The username of the user whom the desired public page belongs to
  * {customurl}: The new URL suffix the user would like to resolve to their public page
  
  Required Headers: None
  
  Body: None
  
* ### Navigating to a Custom URL:

  Description: This API acts as a web server which returns the corresponding user's public page.
  
  API Address: https://public.tracedigital.tk/u/{customurl}
  
  Path Parameters:
  * {customurl}: The suffix the user would like to navigate to
  
  Required Headers: None
  
  Body: None
 
* ### Deleting a Custom URL:
  
  Description: This API deletes the custom URL for the specified user, if the user has a custom URL configured.
  
  API Address: https://76gjqug5j8.execute-api.us-east-2.amazonaws.com/prod/custom/delete?username={username}
  
  Path Parameters:
  * {username}: The username of the user for which the delete request is being made

  Required Headers: None
  
  Body: None

## Public Page Status API

* ### Status
  
  Description: Provides a summary of the public page assets currently deployed by a user, including whether the user has a published public page, password, and custom URL configured. This is used primarily, but not necessarily exclusively, for rendering the web client.
  
  API Address: https://76gjqug5j8.execute-api.us-east-2.amazonaws.com/prod/status?username={username}
  
  Path Parameters: {username}: The username of the user for which the status query is being made.
  
  Required Headers: None
  
  Body: None
