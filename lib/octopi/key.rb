module Octopi
  class Key < Base
    include Resource
    
    attr_accessor :title, :id, :key
    find_path "/user/keys"
    
    attr_reader :user
    
    def self.find_all
      Api.api.get("user/keys")
    end
    
    def self.add(opts)
      Api.api.post("/user/key/add", { :title => opts[:title], :key => opts[:key] })
      
    end
    
    def remove
      result = Api.api.post "/user/key/remove", :id => id
      keys = result["public_keys"].select { |k| k["title"] == title }
    end
  end
end