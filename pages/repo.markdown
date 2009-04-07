## Repositories API ##

### Searching Repositories ###

	repos/search/:q

To search for repositories that have to do with testing ruby, you could do this:

	$ curl http://github.com/api/v2/yaml/repos/search/ruby+testing
	--- 
	repositories: 
	- score: 0.32255203
	  name: synthesis
	  actions: 4653
	  size: 2048
	  language: Ruby
	  followers: 27
	  username: gmalamid
	  type: repo
	  id: repo-3555
	  forks: 1
	  fork: false
	  description: Ruby test code analysis tool employing a "Synthesized Testing" strategy, aimed to reduce the volume of slower, coupled, complex wired tests.
	  pushed: "2009-01-08T13:45:06Z"
	  created: "2008-03-11T23:38:04Z"
	- score: 0.56515217
	  name: flexmock
	  actions: 210
	  size: 928
	  language: Ruby
	  followers: 7
	  username: jimweirich
	  type: repo
	  id: repo-41100
	  forks: 0
	  fork: false
	  description: Flexible mocking for Ruby testing
	  pushed: "2009-04-01T16:23:58Z"
	  created: "2008-08-08T18:52:54Z"


### Show Repo Info ###

To look at more in-depth information for a repository, GET this

	repos/show/:user/:repo

For example, to see the information for Grit

	$ curl http://github.com/api/v2/yaml/repos/show/schacon/grit
	--- 
	repository: 
	  :description: Grit is a Ruby library for extracting information from a
	 git repository in an object oriented manner - this fork tries to
	 intergrate as much pure-ruby functionality as possible
	  :forks: 4
	  :name: grit
	  :watchers: 67
	  :private: false
	  :url: http://github.com/schacon/grit
	  :fork: true
	  :owner: schacon
	  :homepage: http://grit.rubyforge.org/

### List All Repositories ###

You can list out all the repositories for a user with

	repos/show/:user
	
For example, to see all of schacons public repos, we can GET

	$ curl http://github.com/api/v2/yaml/repos/show/schacon
	--- 
	repositories: 
	- :description: Ruby/Git is a Ruby library that can be used to 
	create, read and manipulate Git repositories by wrapping system 
	calls to the git binary.
	  :forks: 30
	  :name: ruby-git
	  :watchers: 132
	  :private: false
	  :url: http://github.com/schacon/ruby-git
	  :fork: false
	  :owner: schacon
	  :homepage: http://jointheconversation.org/rubygit/
	- :description: A quick & dirty git-powered Sinatra wiki
	  :forks: 1
	  :name: git-wiki
	  :watchers: 15
	  :private: false
	  :url: http://github.com/schacon/git-wiki
	  :fork: true
	  :owner: schacon
	  :homepage: http://atonie.org/2008/02/git-wiki

If you are authenticated as that user, you can see all the private repositories as well.

### Watching Repositories ###

You have to be authenticated for this, but you can watch and unwatch repositories with calls to
	
	repos/unwatch/:user/:repo
	repos/watch/:user/:repo

### Forking Repositories ###

You can also fork a repository with

	repos/fork/:user/:repo

Which will return data about your newly forked repository.

	curl -F 'login=schacon' -F 'token=XXX' http://github.com/api/v2/yaml/repos/fork/dim/retrospectiva
	--- 
	repository: 
	  :description: Retrospectiva is an open source, web-based, project management and bug-tracking tool. It is intended to assist the collaborative aspect of work carried out by software development teams.
	  :forks: 0
	  :name: retrospectiva
	  :watchers: 1
	  :private: false
	  :url: http://github.com/schacon/retrospectiva
	  :fork: true
	  :owner: schacon
	  :homepage: http://www.retrospectiva.org

### Creating and Deleting Repositories ###

To create a new repository, hit this url

	repos/create

with at least 'name' but it will take any of these as POST args
	
	name 		=> name of the repository
	description 	=> repo description
	homepage	=> homepage url
	public		=> 1 for public, 0 for private

You can also delete a repository with a POST to

	repos/delete/:repo

which will give you back a token in the 'delete\_token' field of the response, which you then have to post back to the same url again (in the 'delete\_token' POST var) to complete the deletion.

### Repository Visibility ###

To set a public repository private, you can POST while authenticated to

	repos/set/private/:repo
	
To make a private repo public, POST while authenticated to

	repos/set/public/:repo

### Deploy Keys ###

You can use the API to list, add and remove your deploy keys.  To see which deploy keys you have setup for a specific repository, GET this URL

	repos/keys/:repo

It will give you a listing of your public keys, like so

	$ curl -F 'login=schacon' -F 'token=XXX' http://github.com/api/v2/yaml/repos/keys/retrospectiva
	--- 
	public_keys: 
	- title: my deploy key
	  id: 98748
	  key: ssh-rsa AAAAB3NzaC1cy3EAAAABIwAAAQEAqxtaIQhX9ICzxJw2ct+MuEEo8T6w
	6woAwOHGuz9tZVZ1ncIa641O+z9hHJ68g61OK508M4Z6mkVNL68bW7TCPcTEXcCmkGTbB9F
	5wCWD5uYExRgDaywamaREkEzaP0wl3CFvGADfrxUUvEzp4eKsAneCHD07FQiBXDFApqfJEm
	IcsXPaJKfl8NpyIAMLr9ge2ToKH7hDOQG5Q6UcYIfYZH0kIZFfhnf8tBp+6oIHNFkXriTRB
	OxFKoCuyauVCnX12N7GUR29L//MWmbL+bDdEg/HHnmZWkwpaZhC/rsqqylZobpZsUcAKZ7f
	0Daq6H8C1CHf1RB6JriP7CCja8pl+w==

You can also add new keys by POSTing to 

	repos/key/:repo/add

which takes the following POST variables

	title 	=> title of the key
	key	=> public key data

You can also POST to this removal URL to remove a key

	repos/key/:repo/remove

You will need to POST an 'id' variable with the key ID returned from the public listing or key creation.

### Collaborators ###

To get a list of the collaborators on your project, GET 

	repos/show/:user/:repo/collaborators

To add or remove collaborators, POST to one of these URLs

	repos/collaborators/:repo/add/:user
	repos/collaborators/:repo/remove/:user

### Network ###

We can also look at the full network with

	repos/show/:user/:repo/network

For example, to see all the forks of the ruby-git project, we can GET

	$ curl http://github.com/api/v2/yaml/repos/show/schacon/ruby-git/network
	--- 
	network: 
	- :description: Ruby/Git is a Ruby library that can be used to create,
	 read and manipulate Git repositories by wrapping system calls to the 
	 git binary.
	  :forks: 30
	  :name: ruby-git
	  :watchers: 132
	  :private: false
	  :url: http://github.com/schacon/ruby-git
	  :fork: false
	  :owner: schacon
	  :homepage: http://jointheconversation.org/rubygit/
	- :description: Ruby/Git is a Ruby library that can be used to create,
	 read and manipulate Git repositories.
	  :forks: 0
	  :name: ruby-git
	  :watchers: 2
	  :private: false
	  :url: http://github.com/ericgoodwin/ruby-git
	  :fork: true
	  :owner: ericgoodwin
	  :homepage: http://jointheconversation.org/rubygit/
	...

### Repository Refs ###

To get a list of tags on your repo

	repos/show/:user/:repo/tags

For example

	$ curl http://github.com/api/v2/yaml/repos/show/schacon/ruby-git/tags
	--- 
	tags: 
	  1.0.3: be47ad8aea4f854fc2d6773456fb28f3e9f519e7
	  1.0.5: 6c4af60f5fc5193b956a4698b604ad96ef3c51c6
	  1.0.5.1: ae106e2a3569e5ea874852c613ed060d8e232109
	  v1.0.7: 1adc5b8136c2cd6c694629947e1dbc49c8bffe6a

To get a list of remote branches

	repos/show/:user/:repo/branches

For example 

	$ curl http://github.com/api/v2/yaml/repos/show/schacon/ruby-git/branches
	--- 
	branches: 
	  master: ee90922f3da3f67ef19853a0759c1d09860fe3b3
	  internals: 6a9db968e8563bc27b8f56f9d413159a2e14cf67
	  test: 2d749e3aa69d7bfedf814f59618f964fdbc300d5
	  integrate: 10b880b418879e662feb91ce7af98560adeaa8bb

