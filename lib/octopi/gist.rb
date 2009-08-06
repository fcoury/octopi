module Octopi
  # Gist API is... lacking at the moment.
  # This class serves only as a reminder to implement it later
  class Gist < Base
    include HTTParty
    attr_accessor :description, :repo, :public, :created_at
    
    include Resource
    set_resource_name "tree"
    resource_path ":id"
    
    def self.base_uri
      "http://gist.github.com/api/v1/yaml"
    end
    
    def self.find(id)
      result = get("#{base_uri}/#{id}")
      # This returns an array of Gists, rather than a single record.
      new(result["gists"].first)
    end
    
    # def files
    #   gists_folder = File.join(ENV['HOME'], ".octopi", "gists")
    #   File.mkdir_p(gists_folder)
    #   `git clone git://`
    # end
  end
end
