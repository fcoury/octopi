require File.join(File.dirname(__FILE__), '..', 'lib', 'octopi')

include Octopi

# user information
user = User.find("fcoury")
puts "#{user.name} is being followed by #{user.followers.join(", ")} and following #{user.following.join(", ")}"

# the bang version of followers and following 
# fetches user object for each user, but is 
# a lot more expensive
user.followers!.each do |u|
  puts "  - #{u.name} (#{u.login}) has #{u.public_repo_count} repo(s)"
end

# search user
users = User.find_all("silva")
puts "#{users.size} users found for 'silva':"
users.each do |u|
  puts "  - #{u.name}"
end

# repository information
# to get all repos for user: user.repositories
repo = user.repository("octopi") # same as: Repository.find("fcoury", "octopi")
puts "Repository: #{repo.name} - #{repo.description} (by #{repo.owner}) - #{repo.url}"
puts "      Tags: #{repo.tags and repo.tags.map {|t| t.name}.join(", ")}"

issue = repo.issues.first
puts "Sample open issue: #{issue.number} - #{issue.title} - Created at: #{issue.created_at}"

# commits of a the repository
commit = repo.commits.first
puts "Commit: #{commit.id} - #{commit.message} - by #{commit.author['name']}"

# single commit information
# details is the same as: Commit.find(commit)
puts "Diff:"
commit.details.modified.each {|m| puts "#{m['filename']} DIFF: #{m['diff']}" }

# repository search
repos = Repository.find_all("ruby", "git")
puts "#{repos.size} repository(ies) with 'ruby' and 'git':"
repos.each do |r|
  puts "  - #{r.name}"
end

# connect "user", "<< token >>" do |github|
#   puts github.user.name
# end