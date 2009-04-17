## Issues API ##

The API for GitHub Issues.
  
### List a Projects Issues ###

To see a list of issues for a project,

	issues/list/:user/:repo/:state

where :state is either 'open' or 'closed'.

For example, to see all the open issues I have on the schacon/simplegit project, we can run

	$ curl http://dev.github.com/api/v2/yaml/issues/list/schacon/simplegit/open
	--- 
	issues: 
	- position: 1.0
	  number: 1
	  votes: 0
	  created_at: 2009-04-17 14:55:33 -07:00
	  body: my sweet, sweet issue
	  title: new issue
	  updated_at: 2009-04-17 14:55:33 -07:00
	  user: schacon
	  state: open
	- position: 2.0
	  number: 2
	  votes: 0
	  created_at: 2009-04-17 15:16:47 -07:00
	  body: the body of a second issue
	  title: another issue
	  updated_at: 2009-04-17 15:16:47 -07:00
	  user: schacon
	  state: open


### View an Issue ###

To get data on an individual issue by number, run 

	issues/show/:user/:repo/:number

So to get all the data for a issue #1 in our repo, we can run something like this:

	$ curl http://github.com/api/v2/yaml/issues/show/schacon/simplegit/1
	--- 
	issue: 
	  position: 1.0
	  number: 1
	  votes: 0
	  created_at: 2009-04-17 14:55:33 -07:00
	  body: my sweet, sweet issue
	  title: new issue
	  updated_at: 2009-04-17 14:55:33 -07:00
	  user: schacon
	  state: open

	
### Search Issues ###

You can search through a projects issues as well with

	issues/search/:user/:repo/:state/:q


### Open and Close Issues ###

To open a new issue on a project, make a POST to

	issues/open/:user/:repo

Where you can provide POST variables:

	title 
	body

It will return the data for the newly created ticket if it is successful.

To close or reopen an issue, you just need to supply the issue number

	issues/close/:user/:repo/:number

	issues/reopen/:user/:repo/:number

### Edit Existing Issues ###

For the final three calls (edit, label add and label delete) you have to be authorized a collaborator on the project.

To edit an existing issue, you can POST to

	issues/edit/:user/:repo/:number

Where you can provide POST variables:

	title 
	body

This will overwrite the title or body of the issue, if you are authorized member of the project.

### Add and Remove Labels ###

To add a label, run

	issues/label/add/:user/:repo/:label/:number

This will return a list of the labels currently on that issue, your new one included. If the label is not yet in the system, it will be created.  

To remove a label, run:

	issues/label/remove/:user/:repo/:label/:number

Again, it will return a list of the labels currently on the issue.