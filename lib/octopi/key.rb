module Octopi
  class Key < Base
    include Resource
    
    attr_accessor :title, :id, :key
    find_path "/user/keys"
    
    attr_reader :user
    
    def self.find_all
      Api.api.get("user/keys")
    end
    
    def self.add(options={})
      ensure_hash(options)
      Api.api.post("/user/key/add", { :title => options[:title], :key => options[:key], :cache => false })
      
    end
    
    def remove
      result = Api.api.post "/user/key/remove", { :id => id, :cache => false }
      keys = result["public_keys"].select { |k| k["title"] == title }
    end
  end
end