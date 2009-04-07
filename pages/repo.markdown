## Repositories API ##

Creating a Repository

	repos/create

Searching a Repository

	repos/search/:q

Watching Repositories
	
	repos/unwatch/:user/:repo
	repos/watch/:user/:repo

Forking Repositories

	repos/fork/:user/:repo

Deleting your Repository

	repos/delete/:repo

Repository Values

	repos/set/:setvalue/:repo

Deploy Keys

	repos/key/:repo/remove
	repos/key/:repo/add
	repos/keys/:repo

Collaborators

	repos/collaborators/:repo/add/:user
	repos/collaborators/:repo/remove/:user
	repos/show/:user/:repo/collaborators

Network

	repos/show/:user/:repo/network

Repository Commit Tags

	repos/show/:user/:repo/tags

Repository Branches

	repos/show/:user/:repo/branches

Show Repo Info
	
	repos/show/:user/:repo

List All Repositories

	repos/show/:user
