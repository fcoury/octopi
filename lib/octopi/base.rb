#stdlib
require 'pathname'

#gems
require 'httparty'
require 'json'

module Octopi
  class Base
    include HTTParty
    
    attr_accessor :attributes
    
    def self.collection(url)
      from_collection(get(base_url + url))
    end
    
    def initialize(attributes)
      @attributes = {}
      attributes.each do |k, v|
        if respond_to?("#{k}=")
          @attributes[k] = v 
          self.send("#{k}=", v)
        else
          @attributes << k
        end
      end
    end
    
    private

    # Builds objects from a collection
    def self.from_collection(response)
      JSON.parse(response.body).map { |e| new(e) }
    end
    
    def self.base_url
      "https://api.github.com"
    end
  end
end