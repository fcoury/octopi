#stdlib
require 'pathname'

#gems
require 'httparty'
require 'json'

module Octopi
  class Base
    include HTTParty
    
    attr_accessor :attributes
    
    def self.find(name)
      build(get(singular_url(name)))
    end
    
    def self.collection(url)
      from_collection(get(base_url + url))
    end
    
    def initialize(attributes)
      @attributes = {}
      attributes.each do |k, v|
        @attributes[k] = v 
        self.class.send(:define_method, k) do
          @attributes[k]
        end unless respond_to?(k)
      end

      setup if respond_to?(:setup)
    end
    
    private
    
    def self.singular_url(name)
      base_url + "/#{self.name.split("::").last.downcase}s/#{name}"
    end

    # Builds objects from a collection
    def self.from_collection(response)
      parse(response).map { |e| new(e) }
    end

    def self.build(response)
      new(parse(response))
    end

    def self.parse(response)
      JSON.parse(response.body)
    end
    
    def self.base_url
      "https://api.github.com"
    end
  end
end