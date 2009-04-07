## General API Information ##

### Schema ###

All API access is over HTTP and starts with 
	
	http://github.com/api/v2/:format

where `:format` is one of 'yaml', 'json' or 'xml', specifying what the response data should be formatted in.  For all of the rest of this documentation, we will be leaving off that part, since it is the same for every API call.

### Authentication ###

How to authenticate as a user, simply pass `login` and `token` to any URL.  Several of the calls will return extra data if you are authenticated as a user that owns the repository or has access to it as a collaborator.  For example, a call to get information on one of your private repositories would be:

	$ curl -F 'login=schacon' -F 'token=6ef8395fecf207165f1a82178ae1b984'
	  http://github.com/api/v2/json/user/show/schacon | jsonpretty
	{
	  "user": {
	    "company": "Logical Awesome",
	    "name": "Scott Chacon",
	    "following_count": 11,
	    "blog": "http:\/\/jointheconversation.org",
	    "public_repo_count": 52,
	    "public_gist_count": 45,
	    "disk_usage": 294392,
	    "collaborators": 3,
	    "plan": {
	      "name": "small",
	      "collaborators": 5,
	      "space": 1228800,
	      "private_repos": 10
	    },
	    "id": 70,
	    "owned_private_repo_count": 10,
	    "total_private_repo_count": 14,
	    "private_gist_count": 11,
	    "login": "schacon",
	    "followers_count": 182,
	    "created_at": "2008\/01\/27 09:19:28 -0800",
	    "email": "schacon@gmail.com",
	    "location": "Redwood City, CA"
	  }
	}

### Secure Access ###

You can access any API call over HTTPS, though public data can also be accessed over HTTP.

### Limitations ###

Currently we are limiting API calls to 60 per minute.  This may change in the future, or possibly per user at some point, but if you try to access the API more than 60 times in a minute, it will start giving you "access denied" errors.