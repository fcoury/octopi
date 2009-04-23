## Users API ##

API for accessing and modifying user information.

### Searching for Users ###

The method for user searching is:

	User.find_all(query)

For instance, you would search for users with <i>chacon</i> in their name like this:

	User.find_all('chacon')

### Getting User Information ###

You can then get extended information on users by their username.  The method is:

	User.find(username)

so the following command

	User.find('runpaint')

will return something like this:

    #<Octopi::User:0xb7812c40
     @api=#<Octopi::Api:0xb7bb8174>,
     @blog=nil,
     @company=nil,
     @created_at=Sun Apr 05 22:57:13 +0100 2009,
     @email="",
     @followers_count=0,
     @following_count=1,
     @id=70802,
     @keys=
      ["company",
       "name",
       "created_at",
       "location",
       "blog",
       "public_repo_count",
       "public_gist_count",
       "following_count",
       "id",
       "followers_count",
       "login",
       "email"],
     @location=nil,
     @login="runpaint",
     @name=nil,
     @public_gist_count=2,
     @public_repo_count=4>

You can get additional information if you're authenticated as that user. 

    include Octopi
    
    authenticated do |g|
      g.user
    end

This will return an object like the following:


     #<Octopi::User:0xb7762b88
     @api=
      #<Octopi::Api:0xb7765f68
       @format="yaml",
       @login="runpaint",
       @read_only=false,
       @token="555b9a27c1b7bc99cd16c0f812fce307",
       @trace_level=nil>,
     @blog=nil,
     @collaborators=0,
     @company=nil,
     @created_at=Sun Apr 05 22:57:13 +0100 2009,
     @disk_usage=1636,
     @email="",
     @followers_count=0,
     @following_count=1,
     @id=70802,
     @keys=
      ["plan",
       "company",
       "name",
       "created_at",
       "location",
       "blog",
       "public_repo_count",
       "public_gist_count",
       "disk_usage",
       "collaborators",
       "following_count",
       "id",
       "private_gist_count",
       "owned_private_repo_count",
       "followers_count",
       "total_private_repo_count",
       "login",
       "email"],
     @location=nil,
     @login="runpaint",
     @name=nil,
     @owned_private_repo_count=0,
     @plan=
      {"name"=>"free", "collaborators"=>0, "space"=>307200, "private_repos"=>0},
     @private_gist_count=0,
     @public_gist_count=2,
     @public_repo_count=4,
     @total_private_repo_count=0>

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

If you want to look at the <i>following</i> network on GitHub, you can request the users that a specific user is following with:

	User.find(username).followers

or the users following a specific user with:

	User.find(username).following

For example, if you want to see which users are following 'defunkt', you can
use this:

	User.find('defunkt').followers

If you are authenticated as a user, you can also follow or unfollow users with:

	/user/follow/:user [POST]

	/user/unfollow/:user [POST]


#### Public Key Management ####

If you're authenticated you can retrieve your public keys with

  
    include Octopi
    
    authenticated do |g|
      g.keys
    end

This will return something like:

      [{"title"=>"runpaint@github.com",
        "id"=>97842,
        "key"=>
         "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAFEAs/lCz6aT4b0wnJQXZZ9JBLLNZcF6POtaE
         D/bsFWshvVCaUIs7NzdAvzJYus06r0S/Cvr1g1RTSQm35Ub44ZHbfhCfGq5Akh42OnYeF9
         HjuAehGsjGsqElheoQCHGOdGPcSf3lo/1m8JlD8XRJfu8xvtAhUzwa9EqLoCx8ba31olyV
         SxRANvVIfeW9Rb1hT44HcnZgJ8NHOxRthlODcFkjstOidpCvswAJtMvUZx08gmeCgornF3
         pRs4Y4E1dtrsgWn6hOb48bNDNo8lDaN0E6i31K0j4BjVZk8VTrXipBZXwebYwmKYkJrNbJ
         EdMvlKL4p9MUhckWMA2nPloz9gfr7Me8dEQEpzN2xJ2Q0Zm60vCA5aFKCPMmWU57YSIn9x
         QWyy5xplLOr0aOPcZLZ38/Qjxz3NOAgbrjnzWKCHDVxmDw8V9iEQQAygPMW3l8sOmlJDHB
         eWra9OjyhRgSDONE3BFQBMC96r4Wi7wDYurWAvO21YAmbk5j5bDHDd1kr5bW2K51G0GYnI
         Xgpaif+4uYHfLVWj8QDMFgnsdkXQOTa6oV4HkXdHBvWf+PeKuZgodmvNysorOos73p9eQm
         3UFTNYbGrO7e+0QhzsKDQwI5oNrIRtke4IH5KiL017xE0RCPVK/55XudRakCvpVcH8LW0V
         jsyi1aFYjHjRtDxDMcSM="
      }]

You can edit your public keys with:

    /user/key/add [POST]
        :name
        :key

    /user/key/remove [POST]
        :id

#### Email Address Management ####

If you're authenticated you can retrieve your e-mail addresses with

  
    include Octopi
    
    authenticated do |g|
      g.emails
    end

This will return something like:

    ["runpaint@example.org", "runrun@runpaint.org"]

You can edit your e-mail addresses with:

      /user/email/add [POST]

      /user/email/remove [POST]
