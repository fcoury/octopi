# octopi

## Description

A Ruby interface to GitHub API v2 [http://developer.github.com](http://developer.github.com)<br/>
Fork it away!

## Features

* High level interface
* Change resources a la ActiveRecord

## Examples

Choose your flavor

### DSL flavor (work in progress)

	include Octopi
	connect "username", "<<user-token>>" do |git|
	  # the contents of the key whose title is "Local Server"
	  puts git.keys.find { |k| k.title == "Local Server" }.key
      
	  # prints current user name
	  puts git.user.name

	  # sets user name to Fernanda
	  # and saves it on GitHub
	  git.user.name = "Fernanda"
	  git.user.save
	end
	
### API flavor

    # initializes the API and authenticates the user
    github = Octopi::Api.new('fcoury', '<<user-token>>')

    # the contents of the key whose title is "Local Server"
	puts github.keys.find { |k| k.title == "Local Server" }.key

	# retrieves current user information and prints the name
	user = github.user
	puts user.name

	# sets user name to Fernanda
	# and saves it on GitHub
	user.name = "Fernanda"
	user.save

## Bugs and Feedback

Drop me a line at githuby@felipecoury.com.

Copyright &copy; 2009 Felipe Coury<br/>
[http://felipecoury.com](http://felipecoury.com)