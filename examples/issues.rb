require File.join(File.dirname(__FILE__), '..', 'lib', 'octopi')

include Octopi

user = User.find("bcalloway")
puts user.name

repo = user.repository("myproject")
puts repo.description

issue = Issue.find_all(user.login, repo.name).first
puts "First open issue: #{issue.number} - #{issue.title} - Created at: #{issue.created_at}"