# octopi

Octopi is a Ruby interface to GitHub API v2 (http://develop.github.com).

To install it as a Gem, just run:

    $ sudo gem install octopi

Get notifications via Twitter, following @octopi_gem:
http://twitter.com/octopi_gem
  
## Authenticated Usage

### Seamless authentication using .gitconfig defaults

If you have your <tt>~/.gitconfig</tt> file in place, and you have a [github] section (if you don't, take a look at this [GitHub Guides entry][http://github.com/guides/tell-git-your-user-name-and-email-address], you can use seamless authentication using this method:

    authenticated do 
      repo = Repository.find(:name => "api-labrat", :user => "fcoury")
    end
  
### Explicit authentication

Sometimes, you may not want to get authentication data from _~/.gitconfig_. You want to use GitHub API authenticated as a third party. For this use case, you have a couple of options too.

**1. Providing login and token inline:**

    authenticated_with :login => "mylogin", :token => "mytoken" do 
      repo = Repository.find(:name => "api-labrat", :user => "fcoury")
      issue = repo.open_issue :title => "Sample issue", 
        :body => "This issue was opened using GitHub API and Octopi"
      puts issue.number
    end

**2. Providing login and password inline:**

    authenticated_with :login => "mylogin", :password => "password" do 
      repo = Repository.find(:name => "api-labrat", :user => "fcoury")
      issue = repo.open_issue :title => "Sample issue", 
        :body => "This issue was opened using GitHub API and Octopi"
      puts issue.number
    end

**3. Providing a YAML file with authentication information:**

Use the following format:

    #
    # Octopi GitHub API configuration file
    #

    # GitHub user login and token
    login: github-username
    token: github-token

    # Trace level
    # Possible values:
    #   false - no tracing, same as if the param is ommited
    #   true  - will output each POST or GET operation to the stdout
    #   curl  - same as true, but in addition will output the curl equivalent of each command (for debugging)
    trace: curl
  
  And change the way you connect to:

    authenticated_with :config => "github.yml" do
      (...)
    end
  
## Anonymous Usage

This reflects the usage of the API to retrieve information on a read-only fashion, where the user doesn't have to be authenticated.

### Users API

Getting user information

    user = User.find("fcoury")
    puts "#{user.name} is being followed by #{user.followers.join(", ")} and following #{user.following.join(", ")}"

The bang methods `followers!` and `following!` retrieves a full User object for each user login returned, so it has to be used carefully.

    user.followers!.each do |u|
      puts "  - #{u.name} (#{u.login}) has #{u.public_repo_count} repo(s)"
    end
  
Searching for user

    users = User.find_all("silva")
    puts "#{users.size} users found for 'silva':"
    users.each do |u|
      puts "  - #{u.name}"
    end

### Repositories API

    repo = user.repository("octopi") # same as: Repository.find("fcoury", "octopi")
    puts "Repository: #{repo.name} - #{repo.description} (by #{repo.owner}) - #{repo.url}"
    puts "      Tags: #{repo.tags and repo.tags.map {|t| t.name}.join(", ")}"
  
Search:

    repos = Repository.find_all("ruby", "git")
    puts "#{repos.size} repository(ies) with 'ruby' and 'git':"
    repos.each do |r|
      puts "  - #{r.name}"
    end
  
Issues API integrated into the Repository object:

    issue = repo.issues.first
    puts "First open issue: #{issue.number} - #{issue.title} - Created at: #{issue.created_at}"

Single issue information:

    issue = repo.issue(11)

Commits API information from a Repository object:

    first_commit = repo.commits.first
    puts "First commit: #{first_commit.id} - #{first_commit.message} - by #{first_commit.author['name']}"
  
Single commit information:

    puts "Diff:"
    first_commit.details.modified.each {|m| puts "#{m['filename']} DIFF: #{m['diff']}" }

## Author

* Felipe Coury - http://felipecoury.com
* HasMany.info blog - http://hasmany.info

## Contributors

In alphabetical order:

* Ryan Bigg - http://ryanbigg.net
* Brandon Calloway - http://github.com/bcalloway
* runpaint - http://github.com/runpaint

Thanks guys!

## Copyright

Copyright (c) 2009 Felipe Coury. See LICENSE for details.
