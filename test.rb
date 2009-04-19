require 'lib/octopi'

include Octopi

# anonymous usage

# exact match
# user = User.find("fcoury")
# pp user
# 
# # partial match
# users = User.find_all("silva")
# pp users.first
# 
repos = Repository.find_all("stack")
pp repos

# connect "webbynode", "b759631557bb98fb8d656ba9df5f692f" do |github|
#   puts github.user.name
# end