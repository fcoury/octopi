Learn.GitHub.com
================

This is the code and data behind [learn.github.com](http://learn.github.com). 
The page content lives in the pages/ directory and is compiled into the HTML 
output in p/. Normally, generated files like these wouldn't be checked into
source control, but it's required for the
[GitHub Pages](http://pages.github.com/) hosting.

If you edit a page, please remember to run 'rake' to recompile the site
and create a single commit including both your source and generated
files. This makes it as easy as possible for others to work with your
changes.

Dependencies, Getting Started
-----------------------------

Compiling the site requires maruku, which can be installed with:

    sudo gem install maruku

Once you've done that, just run rake to compile the site:

    rake


Contributing
-----------------------------

To contribute to the learn.github site, you can fork the repository,
push your changes into it and send a pull request to 'schacon'.  

If you want to run the site on GitHub pages for testing you can push your
changes into the 'gh-pages' branch, rather than the 'master' branch of
the remote repository.

  $ git push origin master:gh-pages

That command will push your master branch to the 'gh-pages' branch of
your fork.  Then Pages will serve the site for you under :

http://schacon.github.com/learn.github.com

(Replace 'schacon' with your username)
