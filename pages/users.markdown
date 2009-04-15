## Users API ##

API for accessing and modifying user information.

### Searching for Users ###

The route for user searching is:

	  /user/search/:search

For instance, you would search for users with 'chacon' in their name like this:

	$ curl -i http://github.com/api/v2/xml/user/search/chacon

### Getting User Information ###

You can then get extended information on users by their username.  The url format is:

	  /user/show/:username [GET]

so the following command

	$ curl -i http://github.com/api/v2/yaml/user/show/defunkt

will return the something like this:

	user: 
	  id: 23
	  login: defunkt
	  name: Kristopher Walken Wanstrath
	  company: LA
	  location: SF
	  email: me@email.com
	  blog: http://myblog.com
	  following_count: 13
	  followers_count: 63
	  public_gist_count: 0
	  public_repo_count: 2

If you authenticated as that user, you will also get this information:
	
	  total_private_repo_count: 1
	  collaborators: 3
	  disk_usage: 50384
	  owned_private_repo_count: 1
	  private_gist_count: 0
	  plan: 
	    name: mega
	    collaborators: 60
	    space: 20971520
	    private_repos: 125

	
### Authenticated User Management ###

If you are authenticating, you can update your users information in a few different ways.

	  /user/:username [POST]
	      :values[key] = value

Where the key values are of :

	name
	email
	blog
	company
	location

### Following Network ###

If you want to look at the following network on GitHub, you can request the users that a specific user is following with:

	/user/show/:user/followers

or the users following a specific user with:

	/user/show/:user/following

For example, if you want to see which users are following 'defunkt', you can run this:

	$ curl -i http://github.com/api/v2/yaml/user/show/defunkt/followers

If you are authenticated as a user, you can also follow or unfollow users with:

	/user/follow/:user [POST]

	/user/unfollow/:user [POST]


#### Public Key Management ####

	  /user/keys

	  /user/key/add [POST]
	      :name
	      :key

	  /user/key/remove [POST]
	      :id

#### Email Address Management ####

	  /user/emails [GET]

	  /user/email/add [POST]

	  /user/email/remove [POST]
