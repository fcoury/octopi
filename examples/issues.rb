require File.join(File.dirname(__FILE__), '..', 'lib', 'octopi')

include Octopi

user = User.find("bcalloway")
puts user.name

repo = user.repository("myproject")
puts repo.description

issue = Issue.find_all(user.login, repo.name).first
puts "First open issue: #{issue.number} - #{issue.title} - Created at: #{issue.created_at}"

issue2 = repo.issues.first
puts "First open issue: #{issue.number} - #{issue.title} - Created at: #{issue.created_at}"

issue3 = repo.issue(issue2.number)
puts "First open issue: #{issue.number} - #{issue.title} - Created at: #{issue.created_at}"
