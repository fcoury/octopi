## Commits API ##

### Listing Commits on a Branch ###

	commits/list/:user_id/:repository/:branch

An example of getting a listing of commits for a branch, we will get the latest commits on the 'master' branch of the Grit project.

	$ curl http://github.com/api/v2/yaml/commits/list/mojombo/grit/master
	--- 
	commits: 
	- message: Regenerated gemspec for version 1.1.1
	  parents: 
	  - id: 5071bf9fbfb81778c456d62e111440fdc776f76c
	  url: http://github.com/mojombo/grit/commit/4ac4acab7fd9c7fd4c0e0f4ff5794b0347baecde
	  author: 
	    name: Tom Preston-Werner
	    email: tom@mojombo.com
	  id: 4ac4acab7fd9c7fd4c0e0f4ff5794b0347baecde
	  committed_date: "2009-03-31T09:54:51-07:00"
	  authored_date: "2009-03-31T09:54:51-07:00"
	  tree: 94490563ebaf733cbb3de4ad659eb58178c2e574
	  committer: 
	    name: Tom Preston-Werner
	    email: tom@mojombo.com
	- message: Version bump to 1.1.1
	  parents: 
	  - id: 05372bffe2b60b0d1802f338551856221e0a89d2
	  url: http://github.com/mojombo/grit/commit/5071bf9fbfb81778c456d62e111440fdc776f76c
	  author: 
	    name: Tom Preston-Werner
	    email: tom@mojombo.com
	  id: 5071bf9fbfb81778c456d62e111440fdc776f76c
	  committed_date: "2009-03-31T09:54:40-07:00"
	  authored_date: "2009-03-31T09:54:40-07:00"
	  tree: e5b860cb18c5c334e480993ca4549d13e0f8b1a8
	  committer: 
	    name: Tom Preston-Werner
	    email: tom@mojombo.com

### Listing Commits for a File ###

	commits/list/:user_id/:repository/:branch/*path

An example of using this to get all the commits that modified the gemspec file for the Grit project would be:

	$ curl http://github.com/api/v2/yaml/commits/list/mojombo/grit/master/grit.gemspec
	--- 
	commits: 
	- message: Regenerated gemspec for version 1.1.1
	  parents: 
	  - id: 5071bf9fbfb81778c456d62e111440fdc776f76c
	  url: http://github.com/mojombo/grit/commit/4ac4acab7fd9c7fd4c0e0f4ff5794b0347baecde
	  author: 
	    name: Tom Preston-Werner
	    email: tom@mojombo.com
	  id: 4ac4acab7fd9c7fd4c0e0f4ff5794b0347baecde
	  committed_date: "2009-03-31T09:54:51-07:00"
	  authored_date: "2009-03-31T09:54:51-07:00"
	  tree: 94490563ebaf733cbb3de4ad659eb58178c2e574
	  committer: 
	    name: Tom Preston-Werner
	    email: tom@mojombo.com
	- message: Regenerated gemspec for version 1.1.0
	  parents: 
	  - id: 5bace1138462c9e40807ee542016fb4213eb49f8
	  url: http://github.com/mojombo/grit/commit/ac8700fe97702bc13806a5bfea7a0e28f97b5f6b
	  author: 
	    name: Tom Preston-Werner
	    email: tom@mojombo.com
	  id: ac8700fe97702bc13806a5bfea7a0e28f97b5f6b
	  committed_date: "2009-03-29T21:07:22-07:00"
	  authored_date: "2009-03-29T21:07:22-07:00"
	  tree: 57504834bb2a0cfda808223b42460fb8f806515f
	  committer: 
	    name: Tom Preston-Werner
	    email: tom@mojombo.com

### Showing a Specific Commit ###

	commits/show/:user_id/:repository/:sha

An example of using this to get a the changes introduced on a specific commit in the Grit project would be

 	$ curl http://github.com/api/v2/json/commits/show/mojombo/grit/5071bf9fbfb81778c456d62e111440fdc776f76c | jsonpretty 
	{
	  "commit": {
	    "message": "Version bump to 1.1.1",
	    "added": [

	    ],
	    "removed": [

	    ],
	    "parents": [
	      {
	        "id": "05372bffe2b60b0d1802f338551856221e0a89d2"
	      }
	    ],
	    "modified": [
	      {
	        "diff": "@@ -1,4 +1,4 @@\n --- \n :major: 1\n :minor: 1\n-:patch: 0\n+:patch: 1",
	        "filename": "VERSION.yml"
	      }
	    ],
	    "author": {
	      "name": "Tom Preston-Werner",
	      "email": "tom@mojombo.com"
	    },
	    "url": "http:\/\/github.com\/mojombo\/grit\/commit\/5071bf9fbfb81778c456d62e111440fdc776f76c",
	    "id": "5071bf9fbfb81778c456d62e111440fdc776f76c",
	    "committed_date": "2009-03-31T09:54:40-07:00",
	    "authored_date": "2009-03-31T09:54:40-07:00",
	    "tree": "e5b860cb18c5c334e480993ca4549d13e0f8b1a8",
	    "committer": {
	      "name": "Tom Preston-Werner",
	      "email": "tom@mojombo.com"
	    }
	  }
	}

