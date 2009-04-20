## Git Object API ##

### Trees ###

Can get the contents of a tree by tree SHA

	tree/show/:user/:repo/:tree_sha

To get a listing of the root tree for the facebox project from our commit listing, we can call this:

	$ curl http://github.com/api/v2/yaml/tree/show/defunkt/facebox/f7a5de2e224ec94182a3c2c081f4e7f4df70da4
	--- 
	tree: 
	- name: .gitignore
	  sha: e43b0f988953ae3a84b00331d0ccf5f7d51cb3cf
	  mode: "100644"
	  type: blob
	- name: README.txt
	  sha: d4fc2d5e810d9b4bc1ce67702603080e3086a4ed
	  mode: "100644"
	  type: blob
	- name: b.png
	  sha: f184e6269b343014f58694093b55558dd5dde193
	  mode: "100644"
	  type: blob
	- name: bl.png
	  sha: f6271859d51654b6fb2719df5fe192c8398ecefc
	  mode: "100644"
	  type: blob

### Blobs ###
	
Can get the data about a blob by tree SHA and path

	blob/show/:user/:repo/:tree_sha/:path

For example, to get the README.txt metadata from a specific tree in Facebox:

	$ curl http://github.com/api/v2/yaml/blob/show/defunkt/facebox/f7a5de2e224ec94182a3c2c081f4e7f4d/README.txt
	--- 
	blob: 
	  name: README.txt
	  size: 178
	  sha: d4fc2d5e810d9b4bc1ce67702603080e3086a4ed
	  mode: "100644"
	  mime_type: text/plain
	  data: |
	    Please visit http://famspam.com/facebox/ or open index.html in your favorite browser.

	    Need help?  Join our Google Groups mailing list:
	      http://groups.google.com/group/facebox/



### Raw Git Data ###

You can get the contents of a blob with the blobs s via:

	blob/show/:user/:repo/:sha

It is important to note that it doesn't matter which type you specify (yaml, xml, json), the output will simply be the raw output.

Here is an example of getting a README file from Facebox:

	$ curl http://github.com/api/v2/yaml/blob/show/defunkt/facebox/d4fc2d5e810d9b4bc1ce67702603080e3086a4ed
	Please visit http://famspam.com/facebox/ or open index.html in your favorite browser.

	Need help?  Join our Google Groups mailing list:
	  http://groups.google.com/group/facebox/

You can actually get raw trees and commits this way, too.  If you give it a tree SHA instead, you'll get this:

	$ curl http://github.com/api/v2/yaml/blob/show/defunkt/facebox/f7a5de2e224ec94182a3c2c081f4e7f4d
	100644 blob e43b0f988953ae3a84b00331d0ccf5f7d51cb3cf	.gitignore
	100644 blob d4fc2d5e810d9b4bc1ce67702603080e3086a4ed	README.txt
	100644 blob f184e6269b343014f58694093b55558dd5dde193	b.png
	100644 blob f6271859d51654b6fb2719df5fe192c8398ecefc	bl.png
	100644 blob 31f204fc451cd9dd5cfdadfad2d86ed0e1104882	br.png
	100755 blob 08f6f1fce2f6a02dcb15b6c66244470794587bb0	build_tar.sh
	100755 blob 87b4f8bd699386e3a6fcc2e50d7c61bfc4aabb8d	closelabel.gif
	100644 blob 97ebe3cab3eab76253f9cc5fc894b339456da86e	facebox.css
	100644 blob 2ea88c96ebb00d38d5ae6abad57c917f156802cc	facebox.js
	100644 blob dc61a86c3f342b930f0a0447cae33fee812e27d3	faceplant.css
	100644 blob 355442b51047a30479c21096e06e0906e4e9a4ee	index.html
	100644 blob ebe02bdd357c337e0e817fcbce2a034a54a13287	jquery.js
	100755 blob f864d5fd38b7466c76b5a36dc0e3e9455c0126e2	loading.gif
	100644 blob e41cfe5c654e8e05ad46f15af1c462a1360e9764	logo.png
	040000 tree 82e3a754b6a0fcb238b03c0e47d05219fbf9cf89	releases
	100644 blob 98d3e92373d1bc541e7f516e5e73b645a991ddc2	remote.html
	040000 tree bbf747873075ac28667d246491ffdefbd314fe4f	screenshots
	100644 blob e58b35b362ce5347bb5064e91a3bf8e4fed4f6ef	shadow.gif
	100644 blob 63459bb418f5f6d896a8eb925c01f45024933ed6	stairs.jpg
	100644 blob 38756c5ecc3ce53b8da9555a497bd9cc20b1b1c9	test.html
	100644 blob d99c8f6c6eaa12d7b49a20f41f08a5006f3ea8b7	tl.png
	100644 blob e99b6ec8310e859fd27519694f04e1babf2ab2c4	tr.png

Here is an example of a commit:

	$ curl http://github.com/api/v2/yaml/blob/show/defunkt/facebox/4bf7a39e8c4ec54f8b4cd594a3616d69004aba69
	tree f7a5de2e224ec94182a3c2c081f4e7f35f70da4d
	parent cd13d9a61288dceb0a7aa73b55ed2fd019f4f1f7
	parent 3211367cab73233af66dac2710c94682f3f3b9b2
	author Chris Wanstrath <chris@ozmm.org> 1213837237 -0700
	committer Chris Wanstrath <chris@ozmm.org> 1213837237 -0700

	Merge branch 'master' of git://github.com/webweaver/facebox into webweaver/master

