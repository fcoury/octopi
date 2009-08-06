HTTP/1.1 200 OK
Server: nginx/0.6.31
Date: Thu, 06 Aug 2009 05:18:56 GMT
Content-Type: application/x-yaml; charset=utf-8
Connection: keep-alive
Set-Cookie: _github_ses=BAh7BiIKZmxhc2hJQzonQWN0aW9uQ29udHJvbGxlcjo6Rmxhc2g6OkZsYXNoSGFzaHsABjoKQHVzZWR7AA%3D%3D--884981fc5aa85daf318eeff084d98e2cff92578f; path=/; expires=Wed, 01 Jan 2020 08:00:00 GMT; HttpOnly
Status: 200 OK
X-Runtime: 5065ms
ETag: "cf88713ff12c8d35789400159323613d"
Cache-Control: private, max-age=0, must-revalidate
Content-Length: 32432

--- 
commits: 
- message: Sends data in body, not as params (missed Content-Lenght)
  parents: 
  - id: 00fd8079dd423c2028a8a62e98a759c4e49258f9
  url: http://github.com/fcoury/octopi/commit/57da65035236b8603c96866f0d5876c6cfe63e46
  author: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
  id: 57da65035236b8603c96866f0d5876c6cfe63e46
  committed_date: "2009-07-20T22:29:54-07:00"
  authored_date: "2009-07-20T22:29:54-07:00"
  tree: 67cf3f067fce0bff3c5af717754259cbb0a05d02
  committer: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
- message: |-
    some git config options can have blank values (like pager)
    
    Signed-off-by: Felipe Coury <felipe.coury@gmail.com>
  parents: 
  - id: 7b33a45ad9e535d8ee27069899ed4de7d703a5f8
  url: http://github.com/fcoury/octopi/commit/ed07094122888df187a377b0739e25a5b195cc1e
  author: 
    name: David Dollar
    email: ddollar@gmail.com
  id: ed07094122888df187a377b0739e25a5b195cc1e
  committed_date: "2009-07-17T16:33:23-07:00"
  authored_date: "2009-07-14T10:27:30-07:00"
  tree: 7a73f9f4fb057759248af2aa8eaaf7e83275b0f4
  committer: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
- message: Fixes authorised calls to use https and adds api.commits
  parents: 
  - id: 2bfa90160808b4d7ed281e5858164dc8029509bc
  url: http://github.com/fcoury/octopi/commit/21678ec8571a5f4ecb847a1d93d830d09cde9b68
  author: 
    name: philnash
    email: philnash@gmail.com
  id: 21678ec8571a5f4ecb847a1d93d830d09cde9b68
  committed_date: "2009-06-01T19:30:01-07:00"
  authored_date: "2009-06-01T19:30:01-07:00"
  tree: 4212505490b89f57055fee5075a04804063c02ea
  committer: 
    name: philnash
    email: philnash@gmail.com
- message: |-
    Sleep between retries (because they are caused by github's rate limit)
    
    Signed-off-by: Felipe Coury <felipe.coury@gmail.com>
  parents: 
  - id: fb5ba554b2d147f8dd62c12ac1dfce1608c2a850
  url: http://github.com/fcoury/octopi/commit/2bfa90160808b4d7ed281e5858164dc8029509bc
  author: 
    name: Nat Budin
    email: natbudin@gmail.com
  id: 2bfa90160808b4d7ed281e5858164dc8029509bc
  committed_date: "2009-05-23T09:57:44-07:00"
  authored_date: "2009-05-13T11:40:47-07:00"
  tree: f4da08ee7e177aa86ec0438ebc00d1f192670221
  committer: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
- message: |-
    Allow retry on post as well as get
    
    Signed-off-by: Felipe Coury <felipe.coury@gmail.com>
  parents: 
  - id: 3283fa78014bf066c36e5c1dea1a5dae18fec157
  url: http://github.com/fcoury/octopi/commit/fb5ba554b2d147f8dd62c12ac1dfce1608c2a850
  author: 
    name: Nat Budin
    email: natbudin@gmail.com
  id: fb5ba554b2d147f8dd62c12ac1dfce1608c2a850
  committed_date: "2009-05-23T09:57:32-07:00"
  authored_date: "2009-05-13T11:31:55-07:00"
  tree: a097806b41c3110597b9f902e447b838fd3f3a58
  committer: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
- message: |-
    Added Public Key Management API hooks.
    
    Added methods add_key and keys to user.
    Added new Key resource to add and remove keys.
  parents: 
  - id: 845fa497497e211944b13485fa596bf46f8f182a
  url: http://github.com/fcoury/octopi/commit/0a3417a353961c61a7f56818e566d04570c92600
  author: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
  id: 0a3417a353961c61a7f56818e566d04570c92600
  committed_date: "2009-04-25T20:02:08-07:00"
  authored_date: "2009-04-25T20:00:31-07:00"
  tree: a4fb1b35429d1241e6853c6c275dfb9caff12122
  committer: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
- message: Missing end on octopi.rb, changed authenticated sample, renamed issue to Sample Issue
  parents: 
  - id: d2617707a52f678dd8992a0a5c79f9ce305f24df
  url: http://github.com/fcoury/octopi/commit/845fa497497e211944b13485fa596bf46f8f182a
  author: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
  id: 845fa497497e211944b13485fa596bf46f8f182a
  committed_date: "2009-04-25T15:03:10-07:00"
  authored_date: "2009-04-25T15:03:10-07:00"
  tree: e83df2c4cf0265ddc08167f30b6c0b23b4bbd332
  committer: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
- message: |-
    Limit number of repetitions for retryable requests
    
    If a RetryableAPIError exception is raised, we only repeat the request
    MAX_RETRIES number of times before raising an APIError. This guards against
    infinite loops, while still allowing most 403 errors to be worked around.
    
    As I explained in the commit message for
    6cae2e317b2e4301200b62654e57a0394c9f8b46, this logic is still pretty vague
    because GitHub hasn't documented their rate limiting policy yet.
  parents: 
  - id: 6cae2e317b2e4301200b62654e57a0394c9f8b46
  url: http://github.com/fcoury/octopi/commit/a26df884ed2ecfab18da7ec25c563b38467b84a6
  author: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
  id: a26df884ed2ecfab18da7ec25c563b38467b84a6
  committed_date: "2009-04-25T13:18:39-07:00"
  authored_date: "2009-04-25T13:18:39-07:00"
  tree: b800c0319d7d2423e5f3dda9d890b4f69f30e1fe
  committer: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
- message: |-
    Retry 403s and Net::HTTPBadResponse errors.
    
    My testing strongly suggests that when GitHub returns status code 403 the
    request can be retried. This may be how they implement rate limiting. So, if
    we get a 403 we simply repeat the request. We don't wait between requests
    because there is not yet any evidence that it would benefit us. Hopefully,
    once the rate limiting is documented, we can revisit this issue.
    
    We also retry on Net::HTTPBadResponse exceptions. These are typically raised
    when something between the client and the server clobbers the response, so
    repeating the request is the most sensible approach.
    
    We don't limit the number of retries which means this code could end up
    looping forever. I'm loath to specify some arbitrary limit, however, without
    documentation on what to expect. For example, in the case of 403 errors, my
    testing reveals that sometimes we succeed after retrying twice, and other
    times it may take nearly ten retries.
  parents: 
  - id: 7b3b8fc98339bd0f47f574ecd7e24f1f141b070e
  url: http://github.com/fcoury/octopi/commit/6cae2e317b2e4301200b62654e57a0394c9f8b46
  author: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
  id: 6cae2e317b2e4301200b62654e57a0394c9f8b46
  committed_date: "2009-04-24T22:05:35-07:00"
  authored_date: "2009-04-24T22:05:35-07:00"
  tree: dd6cf18e7832cb3b5c4eeb60a4aa131a49629e53
  committer: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
- message: Add .branches method to Repository object.
  parents: 
  - id: 385ce1d6989adae200b10c416e4ea614d24746c0
  url: http://github.com/fcoury/octopi/commit/a37a352bd11b6859aa95419cbd0698f510051028
  author: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
  id: a37a352bd11b6859aa95419cbd0698f510051028
  committed_date: "2009-04-23T19:42:53-07:00"
  authored_date: "2009-04-23T19:42:53-07:00"
  tree: 9c4547fb3fa88948322cc3f0bfed1f450c4ce330
  committer: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
- message: |-
    Make .keys and .emails return Arrays.
    
    The .keys and .emails methods were returning HTTParty responses which were
    confusing to the caller, and contained an unnecessary level of depth. We now
    index the response with the appropriate hash key, thus returning its Array
    value.
  parents: 
  - id: 03da49d56da895ee0750e256dfb1845bc4003260
  url: http://github.com/fcoury/octopi/commit/3221a7f870af4126087451725f152411653f776e
  author: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
  id: 3221a7f870af4126087451725f152411653f776e
  committed_date: "2009-04-22T20:48:27-07:00"
  authored_date: "2009-04-22T20:48:27-07:00"
  tree: 3f6ee5d9c06eabd29d267e6f407023557f25b2c2
  committer: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
- message: |-
    Removing superfluous yield.
    
    The `submit` method yields to the block it's been passed, prints out a trace,
    then makes almost the same yield again. I assume that this is in error, and
    could have been caused by my previous merge.
  parents: 
  - id: b13f6787c935b72dfc2d5bcd8e1debd9c3080719
  url: http://github.com/fcoury/octopi/commit/03da49d56da895ee0750e256dfb1845bc4003260
  author: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
  id: 03da49d56da895ee0750e256dfb1845bc4003260
  committed_date: "2009-04-22T20:12:54-07:00"
  authored_date: "2009-04-22T20:12:54-07:00"
  tree: 9714482c07679b5e0e7223f7342980ea60a6973d
  committer: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
- message: |-
    Undo 3cb8fbddb6cbd0c9ef2d23e65363d48c42917a68.
    
    Commit 3cb8fbddb6cbd0c9ef2d23e65363d48c42917a68 has been made obsolete by
    commit 67320c5c3e09a23813367ff772d607d4a64642e5. Now we're appending the
    credentials to GET requests, .keys and .emails can return to using the correct
    request type.
  parents: 
  - id: 67320c5c3e09a23813367ff772d607d4a64642e5
  url: http://github.com/fcoury/octopi/commit/b13f6787c935b72dfc2d5bcd8e1debd9c3080719
  author: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
  id: b13f6787c935b72dfc2d5bcd8e1debd9c3080719
  committed_date: "2009-04-22T20:09:18-07:00"
  authored_date: "2009-04-22T20:09:18-07:00"
  tree: 92df231e4fd73c19da9d8b0e68161ddb84f08225
  committer: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
- message: |-
    Add credentials to `default_params` for auth'd GET.
    
    We want the token and login to be sent for all authenticated queries. They
    were being sent for POST requests, but, seemingly, not for GETs, causing
    methods relying on the latter to fail. HTTParty's `default_params` method
    causes parameters so set to be sent on every request. We specify `login` and
    `token` as default parameters if the request is authenticated.
  parents: 
  - id: 3cb8fbddb6cbd0c9ef2d23e65363d48c42917a68
  url: http://github.com/fcoury/octopi/commit/67320c5c3e09a23813367ff772d607d4a64642e5
  author: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
  id: 67320c5c3e09a23813367ff772d607d4a64642e5
  committed_date: "2009-04-22T20:02:51-07:00"
  authored_date: "2009-04-22T20:02:51-07:00"
  tree: d08a11ff5f253e97fad4faec681b6a69c4a97ae7
  committer: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
- message: |-
    POST is required for /user/keys and /user/emails.
    
    The .keys and .emails methods returned a "not authenticated" error because
    they were fetched via GET and thus the credentials were not sent. Using POST
    fixes this bug.
  parents: 
  - id: 1b8113663544a2a4998b3da051b8c91878362e37
  url: http://github.com/fcoury/octopi/commit/3cb8fbddb6cbd0c9ef2d23e65363d48c42917a68
  author: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
  id: 3cb8fbddb6cbd0c9ef2d23e65363d48c42917a68
  committed_date: "2009-04-22T19:37:26-07:00"
  authored_date: "2009-04-22T19:37:26-07:00"
  tree: a5118d94496564dbd41855c59595c232da761412
  committer: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
- message: |-
    Merge branch 'master' of git://github.com/fcoury/octopi
    
    Conflicts:
    	lib/octopi.rb
  parents: 
  - id: 7fe95e3ea33d31f56a9d5aa73655b1e42407da07
  - id: 0f92396690d15dc4f5704b0f1a6f80d60f6956ca
  url: http://github.com/fcoury/octopi/commit/006ecb2bc3fd3fa57b13bb870f76b72070770e52
  author: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
  id: 006ecb2bc3fd3fa57b13bb870f76b72070770e52
  committed_date: "2009-04-22T06:33:59-07:00"
  authored_date: "2009-04-22T06:33:59-07:00"
  tree: 5c6a0b9bac417516197ae710765481f915d2a8c3
  committer: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
- message: "Seamless authentication using .gitconfig. Closes #15."
  parents: 
  - id: 69e57cd8ea6ea782a75734f86dafc49e226b652f
  url: http://github.com/fcoury/octopi/commit/b425c53e7556387bf741aefa37e25ef829dccaf5
  author: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
  id: b425c53e7556387bf741aefa37e25ef829dccaf5
  committed_date: "2009-04-22T05:20:17-07:00"
  authored_date: "2009-04-22T05:20:17-07:00"
  tree: bd8079ddcebc81163162692e5d8b3b74d40f9bb6
  committer: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
- message: |-
    Improved issues handing
    Added cURL and regular tracing options
    Improved documentation on README
    Renamed github.yml.default to example
  parents: 
  - id: 7ae30402d1485da572c70cca2879241505dc64ba
  url: http://github.com/fcoury/octopi/commit/885694b7bbec122f5dd69cd7bbbcecef49ae6e41
  author: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
  id: 885694b7bbec122f5dd69cd7bbbcecef49ae6e41
  committed_date: "2009-04-21T07:43:13-07:00"
  authored_date: "2009-04-21T07:42:35-07:00"
  tree: a608b20022b019fdb9307b6f61482c227473c5f4
  committer: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
- message: |-
    Complain about status code before content type.
    
    GitHub currently returns 500 errors as HTML. When we encountered this, the
    error message referred to the content type rather than the status code. Now we
    check the status code first, so errors are more informative.
    
    Signed-off-by: Felipe Coury <felipe.coury@gmail.com>
  parents: 
  - id: 24f982454a9857eabc546ae807a1ea6501c4db48
  url: http://github.com/fcoury/octopi/commit/cbcda568351da278fa9c028265d4e3f35e8bacde
  author: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
  id: cbcda568351da278fa9c028265d4e3f35e8bacde
  committed_date: "2009-04-21T05:53:05-07:00"
  authored_date: "2009-04-21T04:23:55-07:00"
  tree: 800618a23020d8fbbd788d750b363bb230b5872a
  committer: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
- message: |-
    Complain about status code before content type.
    
    GitHub currently returns 500 errors as HTML. When we encountered this, the
    error message referred to the content type rather than the status code. Now we
    check the status code first, so errors are more informative.
  parents: 
  - id: e7928010f2cc0e019afdacf9e94aae501a743e93
  url: http://github.com/fcoury/octopi/commit/7fe95e3ea33d31f56a9d5aa73655b1e42407da07
  author: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
  id: 7fe95e3ea33d31f56a9d5aa73655b1e42407da07
  committed_date: "2009-04-21T04:23:55-07:00"
  authored_date: "2009-04-21T04:23:55-07:00"
  tree: 800618a23020d8fbbd788d750b363bb230b5872a
  committer: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
- message: Added authenticated commands, but GitHub API is giving 500 errors for opening issues.
  parents: 
  - id: 917b6ea8f221e47263bbb56317821b75a0f4bc07
  url: http://github.com/fcoury/octopi/commit/545fff17a6c2a5f35e91352b5d75da47b7b05d41
  author: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
  id: 545fff17a6c2a5f35e91352b5d75da47b7b05d41
  committed_date: "2009-04-20T19:15:13-07:00"
  authored_date: "2009-04-20T19:15:13-07:00"
  tree: cbf1c98bbc6331521650c968d5a20a37990de989
  committer: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
- message: |-
    Add Base.validate_args, refactored error classes.
    
    Children of Base can now call self.validate_args with a hash containing
    arguments as keys and a corresponding specification symbol as the key. If any
    arguments are invalidated, an informative ArgumentError is raised.
  parents: 
  - id: ac42162a507f4eaa74a42168b2f0290fae233d68
  url: http://github.com/fcoury/octopi/commit/9fbc19ce4f897e9f7b787d910ed66d84dcc18682
  author: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
  id: 9fbc19ce4f897e9f7b787d910ed66d84dcc18682
  committed_date: "2009-04-20T16:24:30-07:00"
  authored_date: "2009-04-20T16:24:30-07:00"
  tree: 369bafd01c6389ad0731d752c11ff2ab42517031
  committer: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
- message: |-
    Added issues API integration
    Refactoring on the way parameters are passed to commits and issues
  parents: 
  - id: a6b6edaa0ce7e2c49ca6156523a33fbad2b2a4e9
  url: http://github.com/fcoury/octopi/commit/8bcc40d2b5accc592b814f84ab960fc2b7cbf05f
  author: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
  id: 8bcc40d2b5accc592b814f84ab960fc2b7cbf05f
  committed_date: "2009-04-20T11:32:08-07:00"
  authored_date: "2009-04-20T11:32:08-07:00"
  tree: 98548123cdd1fb2d7a0c63e8f57dc87c87fde537
  committer: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
- message: Updated overall.rb example and minor fixes on API interfaces
  parents: 
  - id: 6882a99d4e43d394d14f7363ee2a0c40f16c0d3f
  url: http://github.com/fcoury/octopi/commit/107f3c9b7f1fa859bc990763e5858d63f971ddc9
  author: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
  id: 107f3c9b7f1fa859bc990763e5858d63f971ddc9
  committed_date: "2009-04-20T07:26:52-07:00"
  authored_date: "2009-04-20T07:26:52-07:00"
  tree: 20349d6b5f178328333ab4871d52af8591c6b5ea
  committer: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
- message: |-
    Sanity check for response content type.
    
    The API should respond with data in the same format as we requested. If the
    Content-Type disagrees with what we expected, we raise an exception.
    
    This is currently broken for raw Git data as the API call returns the wrong
    content type. Reported as develop/develop.github.com#13
  parents: 
  - id: 060655bac4d9a6da8d763e6cc3bd1aef5037d351
  url: http://github.com/fcoury/octopi/commit/6882a99d4e43d394d14f7363ee2a0c40f16c0d3f
  author: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
  id: 6882a99d4e43d394d14f7363ee2a0c40f16c0d3f
  committed_date: "2009-04-20T03:56:25-07:00"
  authored_date: "2009-04-20T03:56:25-07:00"
  tree: 6d69d0f09972675de7cf00a720b12ab49001b5ff
  committer: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
- message: Split source over several files.
  parents: 
  - id: edbd4df94ab578266ec966a7f90d7018bccec4e8
  url: http://github.com/fcoury/octopi/commit/060655bac4d9a6da8d763e6cc3bd1aef5037d351
  author: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
  id: 060655bac4d9a6da8d763e6cc3bd1aef5037d351
  committed_date: "2009-04-20T03:08:55-07:00"
  authored_date: "2009-04-20T03:08:55-07:00"
  tree: 75033d55c59abfd07517dfb47815d217b929f5d6
  committer: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
- message: |-
    Add .clone_url method to Repository objects.
    
    Repository objects have a .clone_url method which returns their public clone
    URL.
  parents: 
  - id: 102cc1bf2580e2864cc4fb86b405701cf6c43c9c
  url: http://github.com/fcoury/octopi/commit/edbd4df94ab578266ec966a7f90d7018bccec4e8
  author: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
  id: edbd4df94ab578266ec966a7f90d7018bccec4e8
  committed_date: "2009-04-19T19:02:15-07:00"
  authored_date: "2009-04-19T19:02:15-07:00"
  tree: f1de27f0584929594634c29013dfdbca6e00d998
  committer: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
- message: |-
    Let find/find_all methods accept objects.
    
    Initial draft of letting the user-facing methods, find/find_all, mostly,
    accept an object corresponding to the argument type instead of a string.
  parents: 
  - id: d6a8242378a77161ba66634efac8c406487dbd59
  url: http://github.com/fcoury/octopi/commit/102cc1bf2580e2864cc4fb86b405701cf6c43c9c
  author: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
  id: 102cc1bf2580e2864cc4fb86b405701cf6c43c9c
  committed_date: "2009-04-19T18:45:20-07:00"
  authored_date: "2009-04-19T18:45:20-07:00"
  tree: 2e12b79c7f64acad00b4e81d19a74f4370a1769e
  committer: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
- message: |-
    Tweaked Repository.find_all's argument handling.
    
    Repository.find_all accepted an array of 'words', which it concatenated with
    '+'. It now also accepts a single space-separated String, or any combination
    of the two.
    
    This method is still buggy, however, in that the query is not URI escaped;
    it's simply interpolated as-is into the URI. Peculiarly, the API doesn't
    accept URI-escaped space-separated queries, e.g. 'ruby%20spec'. This is
    non-standard enough to put off escaping until I know exactly what the API
    expects.
  parents: 
  - id: f47cc6505cc816fa4f5cd6dde5adc20b0d9029be
  url: http://github.com/fcoury/octopi/commit/d6a8242378a77161ba66634efac8c406487dbd59
  author: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
  id: d6a8242378a77161ba66634efac8c406487dbd59
  committed_date: "2009-04-19T18:18:55-07:00"
  authored_date: "2009-04-19T18:18:55-07:00"
  tree: dbf4e9576dab1e8b25e0175c51498c62821e0243
  committer: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
- message: |-
    Tag.find accepts User a/o Repository object args.
    
    Tag.find(user,repo) assumed user and repo were Strings; now it does the right
    thing if one or both arguments are User or Repository objects, respectively.
  parents: 
  - id: 6dcc3ee64fbe5a09e978b4a8c5397a16bab4ccd2
  url: http://github.com/fcoury/octopi/commit/f47cc6505cc816fa4f5cd6dde5adc20b0d9029be
  author: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
  id: f47cc6505cc816fa4f5cd6dde5adc20b0d9029be
  committed_date: "2009-04-19T17:47:59-07:00"
  authored_date: "2009-04-19T17:47:59-07:00"
  tree: f59b86c124be86f65af001ab8f4a9f56a7d9dba0
  committer: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
- message: Tweaked .find_all method; no func. changes.
  parents: 
  - id: c6ac8abb00862dd9f70ea4376f4d37075f9764b1
  url: http://github.com/fcoury/octopi/commit/6dcc3ee64fbe5a09e978b4a8c5397a16bab4ccd2
  author: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
  id: 6dcc3ee64fbe5a09e978b4a8c5397a16bab4ccd2
  committed_date: "2009-04-19T17:04:48-07:00"
  authored_date: "2009-04-19T17:04:48-07:00"
  tree: 322adc3d7c86606374d24b87f649bbde6659befd
  committer: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
- message: |-
    find/find_all join Array arg with '/'.
    
    A number of callers were joining their arguments with '/' before passing them
    to find/find_all. Now these methods automatically do this if passed an array.
    There's still duplicate code, but it's better than it was.
  parents: 
  - id: bb15be320cfaf1ab12740751d59650491d942c67
  url: http://github.com/fcoury/octopi/commit/c6ac8abb00862dd9f70ea4376f4d37075f9764b1
  author: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
  id: c6ac8abb00862dd9f70ea4376f4d37075f9764b1
  committed_date: "2009-04-19T16:56:24-07:00"
  authored_date: "2009-04-19T16:56:24-07:00"
  tree: 744d7dd84430747aafe511319c8eff63c20a1d70
  committer: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
- message: |-
    Initial implementation of the Object API.
    
    * The `tree/show/:user/:repo/:tree_sha` call returns an array of objects in
    the given tree. This is exposed by the FileObject class. The name is
    convoluted because Object is a reserved word. 'Tree' is awkward because
    although the argument describes a tree, the returned objects aren't trees...
    We should probably call this Tree, and have it return an array of FileObject
    objects...
    * The `blob/show/:user/:repo/:tree_sha/:path` call is supported by
    Blob.find(user, repo, sha, path).
    * The `blob/show/:user/:repo/:sha` call returns raw Git data irrespective of
    caller's format preference. To handle this a get_raw method has been defined
    which simply requests a given path and returns the raw body without attempting
    to coerce it into a data structure. The right way to handle this is to format
    based on the Content-Type header in the response, but that is always set to
    text/html, so is useless. Blob.find(user, repo, sha) returns said raw data.
    * The .find method is now intelligent about arrays. If yaml[key] is an array,
    each element is assumed to be a hash constituting a new object. I still don't
    claim to understand all the magic of this module, so this enchantment may very
    well be unnecessary, but it enabled some hairy code to be factored out, so it
    stays for now.
    * The .find_all method now accepts a block, to which it passes the data it
    intends to construct a new object with. This is to allow callers to massage
    an arbitrary data structure into a simple hash. This is used for Tag.find
    because GitHub returns a single hash of tags, rather than one hash per tag.
    
    (Yes, I realise that this is a ridiculously long commit, and, yes, I have
    heard of cherry-pick...)
  parents: 
  - id: 6fc1c143559b2434c19acb2980e93c5dd7290327
  url: http://github.com/fcoury/octopi/commit/bb15be320cfaf1ab12740751d59650491d942c67
  author: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
  id: bb15be320cfaf1ab12740751d59650491d942c67
  committed_date: "2009-04-19T16:47:30-07:00"
  authored_date: "2009-04-19T16:14:53-07:00"
  tree: 6190fbfefdeb71b465fcaec228312202ac49e3ba
  committer: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
- message: |-
    Improved handling of API errors.
    
    GitHub API errors aren't reported consistently yet. Sometimes they return
    reams of HTML and a non-200 status code, other times they return a 200 status
    code and an error message. We now handle both of these cases by raising an
    APIError with an appropriate message. This will need to be updated as the API
    standardises. When it does, we want to interpret 404s, for example, as the
    object not being found, and thus provide an informative error message.
  parents: 
  - id: 3763caf0e49c519710303f28635eb76f40e34e9e
  url: http://github.com/fcoury/octopi/commit/6fc1c143559b2434c19acb2980e93c5dd7290327
  author: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
  id: 6fc1c143559b2434c19acb2980e93c5dd7290327
  committed_date: "2009-04-19T13:22:58-07:00"
  authored_date: "2009-04-19T13:22:58-07:00"
  tree: 200a49489514b676a9e9f6887149eee517c4bb9f
  committer: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
- message: |-
    Support for viewing a repository's tags.
    
    There's now a Tag class so you can ask for the tags of user's repo with
    Tag.find(user, repo). Plus, all repository objects respond to .tags, which
    returns an array of Tag objects. This isn't the pretties code but it works,
    and that's enough for now.
  parents: 
  - id: 773c939a5ca6b3a4f2ed903df04369caa2a0c536
  url: http://github.com/fcoury/octopi/commit/3763caf0e49c519710303f28635eb76f40e34e9e
  author: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
  id: 3763caf0e49c519710303f28635eb76f40e34e9e
  committed_date: "2009-04-19T12:55:57-07:00"
  authored_date: "2009-04-19T12:55:57-07:00"
  tree: d8b6450cd634d4df077e6ec9328d9449cf33d90c
  committer: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
- message: Added integration between user and repositories
  parents: 
  - id: 38db7cc13b4728e628194fb56f95af04ba3b1a01
  - id: 3dca3c53474643eb843f87b45d2c2df62ce828df
  url: http://github.com/fcoury/octopi/commit/8077ca332e44bf89bb93a9785673c477915bf4ea
  author: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
  id: 8077ca332e44bf89bb93a9785673c477915bf4ea
  committed_date: "2009-04-19T09:43:14-07:00"
  authored_date: "2009-04-19T09:43:14-07:00"
  tree: 47532c6d6a8f86e4bf4ad4323fbfb933e40d0836
  committer: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
- message: Added commits suport and integration between repositories and commits
  parents: 
  - id: e515ea648fc4b0a852531e312563243a817811b5
  url: http://github.com/fcoury/octopi/commit/38db7cc13b4728e628194fb56f95af04ba3b1a01
  author: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
  id: 38db7cc13b4728e628194fb56f95af04ba3b1a01
  committed_date: "2009-04-19T09:26:27-07:00"
  authored_date: "2009-04-19T09:26:27-07:00"
  tree: b846cfbedcd53ddc4360b30bc52a8a12428bbdaf
  committer: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
- message: |-
    Raise APIError if GitHub returns bad status code.
    
    If GitHub.com can't handle the API request, either due to user error or server
    error, it returns an utterly useless chunk of HTML. This confuses the library,
    so we now raise an APIError if the status code is anything other than 200.
    Better error handling will have to wait until the API supports it.
  parents: 
  - id: 1e9e54acd4936644131dae6839995b4ef2bccd81
  url: http://github.com/fcoury/octopi/commit/3dca3c53474643eb843f87b45d2c2df62ce828df
  author: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
  id: 3dca3c53474643eb843f87b45d2c2df62ce828df
  committed_date: "2009-04-19T09:15:04-07:00"
  authored_date: "2009-04-19T09:15:04-07:00"
  tree: 49e2764200c5a9982f8d48e5e8947968991da654
  committer: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
- message: |-
    Let Repository.find(user) show user's repositories
    
    Hacked Repository.find so if called with a single argument, assumes it to be a
    user name, and returns an array of Repository objects corresponding to the
    user's repositories.
    
    I don't completely understand this library's architecture, so it's likely my
    implementation is Wrong. ;-) Works for me, though.
  parents: 
  - id: 63c533fc7883efdd9717ed0a3be1bc033a471e00
  url: http://github.com/fcoury/octopi/commit/1e9e54acd4936644131dae6839995b4ef2bccd81
  author: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
  id: 1e9e54acd4936644131dae6839995b4ef2bccd81
  committed_date: "2009-04-19T05:45:37-07:00"
  authored_date: "2009-04-19T05:45:37-07:00"
  tree: b74a6ee903fb261434e9336751ed6c563db26247
  committer: 
    name: Run Paint Run Run
    email: runrun@runpaint.org
- message: Repository search allows multiple query words for AND searching
  parents: 
  - id: f76482a8ec00dffd750cb8bc0937d466763aeddb
  url: http://github.com/fcoury/octopi/commit/83276d9a68f2590749749bfd40eebc1846219b13
  author: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
  id: 83276d9a68f2590749749bfd40eebc1846219b13
  committed_date: "2009-04-18T20:32:10-07:00"
  authored_date: "2009-04-18T20:32:10-07:00"
  tree: 0b735b6939b1943960c306d5553f7b5a08ffc37f
  committer: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
- message: "More development on the anonymous API: user and repositories"
  parents: 
  - id: f7effc366276ab1615185bdbdc3c98515ce41594
  url: http://github.com/fcoury/octopi/commit/6d6fec76209b961d68341a1e026b19111a041c8b
  author: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
  id: 6d6fec76209b961d68341a1e026b19111a041c8b
  committed_date: "2009-04-18T20:11:04-07:00"
  authored_date: "2009-04-18T20:11:04-07:00"
  tree: a1ced58523b733130c2c10d6cec754b61b7ec503
  committer: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
- message: Metaprogramming experimentation
  parents: 
  - id: 5739978397271f146047c98ac314c12c439d7670
  url: http://github.com/fcoury/octopi/commit/f7effc366276ab1615185bdbdc3c98515ce41594
  author: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
  id: f7effc366276ab1615185bdbdc3c98515ce41594
  committed_date: "2009-04-18T17:29:56-07:00"
  authored_date: "2009-04-18T17:29:43-07:00"
  tree: 6efec2f4c25786a8f725d919ed553d3e4d069380
  committer: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
- message: Minor bug fixing, posting data still doesn't work
  parents: 
  - id: 036e73f9ccc8daa375ed01b2fa4ab762b558d3d6
  url: http://github.com/fcoury/octopi/commit/5739978397271f146047c98ac314c12c439d7670
  author: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
  id: 5739978397271f146047c98ac314c12c439d7670
  committed_date: "2009-04-18T01:03:30-07:00"
  authored_date: "2009-04-18T01:03:30-07:00"
  tree: 2d2c307c50e040c9bce473a889f06a2a91d2ac19
  committer: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
- message: Initial commit
  parents: []

  url: http://github.com/fcoury/octopi/commit/036e73f9ccc8daa375ed01b2fa4ab762b558d3d6
  author: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
  id: 036e73f9ccc8daa375ed01b2fa4ab762b558d3d6
  committed_date: "2009-04-17T21:26:41-07:00"
  authored_date: "2009-04-17T21:26:41-07:00"
  tree: 43e6c11e3fd7af31bb1c4bc03f56f29e8b608908
  committer: 
    name: Felipe Coury
    email: felipe.coury@gmail.com
