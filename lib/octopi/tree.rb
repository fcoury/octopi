module Octopi
  class Tree < Base
    attr_accessor :name, :size, :sha, :mode, :mime_type, :type, :user, :repository
    
    def self.find(options)
      ensure_hash(options)
      user, repo = gather_details(options)
      route = "/tree/show/#{user}/#{repo}/#{options[:sha]}"
      trees = Api.api.get(route)["tree"].map do |tree| 
        Tree.new(tree.merge(:user => user, :repository => repo))
      end
      TreeSet.new(trees)
    end
  end
end