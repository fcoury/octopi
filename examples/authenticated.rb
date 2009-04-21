require File.join(File.dirname(__FILE__), '..', 'lib', 'octopi')

include Octopi

authenticated_with :config => "github.yml" do |g|
  repo = g.repository("api-labrat")
  repo.open_issue :title => "Sample issue", 
    :body => "This issue was opened using GitHub API and Octopi"
end
