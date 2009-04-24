## Repositories API ##

### Searching Repositories ###

	Repository.find_all(query)

To search for repositories that have to do with testing ruby, you could do this:

	Repository.find_all('testing',ruby')

You will get back an Array of Repository objects

    [#<Octopi::Repository:0xb76a0308
      @actions=4656,
      @api=#<Octopi::Api:0xb76c05cc>,
      @created="2008-03-11T23:38:04Z",
      @description=
       "Ruby test code analysis tool employing a \"Synthesized Testing\" strategy, aimed to reduce the volume of slower, coupled, complex wired tests.",
      @followers=26,
      @fork=false,
      @forks=1,
      @id="repo-3555",
      @keys=
       ["actions",
        "name",
        "size",
        "followers",
        "fork",
        "username",
        "language",
        "id",
        "type",
        "pushed",
        "description",
        "forks",
        "score",
        "created"],
      @language="Ruby",
      @name="synthesis",
      @pushed="2009-01-08T13:45:06Z",
      @score=0.31965524,
      @size=2048,
      @type="repo",
      @username="gmalamid">,
      #...
    ]

### Show Repo Info ###

To look at more in-depth information for a repository use this:

	Repository.find(user, repository)

For example, to see the information for Grit

	Repository.find('schacon', 'grit')

This returns the following Repository object:

    #<Octopi::Repository:0xb78b204c
     @api=#<Octopi::Api:0xb7c85494>,
     @description=
      "Grit is a Ruby library for extracting information from a git repository in an object oriented manner - this fork tries to intergrate as much pure-ruby functionality as possible",
     @fork=true,
     @forks=4,
     @homepage="http://grit.rubyforge.org/",
     @keys=
      [:homepage,
       :fork,
       :url,
       :watchers,
       :description,
       :forks,
       :private,
       :owner,
       :name],
     @name="grit",
     @owner="schacon",
     @private=false,
     @url="http://github.com/schacon/grit",
     @watchers=68>

### List All Repositories ###

You can list out all the repositories for a user with

    Repository.find_by_user(user)
	
For example, to see all of <i>schacon</i>'s public repositories:

    Repository.find_by_user('schacon')

This returns an Array of Repository objects:

    [#<Octopi::Repository:0xb7898ffc
      @api=#<Octopi::Api:0xb7c7d834>,
      @description=
       "Ruby/Git is a Ruby library that can be used to create, read and manipulate Git repositories by w
    rapping system calls to the git binary.",
      @fork=false,
      @forks=31,
      @homepage="http://jointheconversation.org/rubygit/",
      @keys=
       [:homepage,
        :fork,
        :forks,
        :watchers,
        :url,
        :private,
        :description,
        :owner,
        :name],
      @name="ruby-git",
      @owner="schacon",
      @private=false,
      @url="http://github.com/schacon/ruby-git",
      @watchers=136>,
      #...
    ]
  
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

To get a list of the collaborators on a repository call the `.collaborators`
method on a Repository object. 

	repository.collaborators

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

To get a list of tags for a Repository object call the `.tags` instance method:

	repository.tags

For example, to get the tags attached to <i>fcoury</i>'s <i>octopi</i> repository:

    Repository.find('fcoury','octopi').tags

This returns an Array of Tag objects:

    [#<Octopi::Tag:0xb78f5a90
      @api=#<Octopi::Api:0xb7ccc3bc>,
      @hash="cfe042b889211ba2f878047736fa2bfb5ad60157",
      @keys=[:hash, :name],
      @name="v0.0.1">,
     #<Octopi::Tag:0xb78f5734
      @api=#<Octopi::Api:0xb7ccc3bc>,
      @hash="33b92f7005d7b9a0e8667a3006e57cda9d8a2ea4",
      @keys=[:hash, :name],
      @name="v0.0.3">,
     #<Octopi::Tag:0xb78f53d8
      @api=#<Octopi::Api:0xb7ccc3bc>,
      @hash="a6b6edaa0ce7e2c49ca6156523a33fbad2b2a4e9",
      @keys=[:hash, :name],
      @name="v0.0.4">,
     #<Octopi::Tag:0xb78f507c
      @api=#<Octopi::Api:0xb7ccc3bc>,
      @hash="db1d9c01bfb366ca25a0190a333e69e4a2c6524e",
      @keys=[:hash, :name],
      @name="v0.0.5">,
     #<Octopi::Tag:0xb78f4d20
      @api=#<Octopi::Api:0xb7ccc3bc>,
      @hash="d157b0f71c2671557c97319acd2a20a2dcf68425",
      @keys=[:hash, :name],
      @name="v0.0.6">,
     #<Octopi::Tag:0xb78f49c4
      @api=#<Octopi::Api:0xb7ccc3bc>,
      @hash="3344a5a2bf141089b4cdfba8f9d37e2104f123b6",
      @keys=[:hash, :name],
      @name="v0.0.7">]


To get a list of remote branches call the `.branches` method on a Repository
object.

	repository.branches

This will return an Array of Branch objects, each of which has `.name` and
`.hash` methods, corresponding to the branch's name and SHA1 hash of its HEAD,
respectively.

For example; 

    Repository.find('schacon', 'ruby-git').branches.each do |branch|
      puts "#{branch.name} is at #{branch.hash}"
    end

This prints something like:
	
    internals is at 6a9db968e8563bc27b8f56f9d413159a2e14cf67
    master is at ee90922f3da3f67ef19853a0759c1d09860fe3b3
    integrate is at 10b880b418879e662feb91ce7af98560adeaa8bb
    test is at 2d749e3aa69d7bfedf814f59618f964fdbc300d5

