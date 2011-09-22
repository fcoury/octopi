module Octopi
  class Base
    include HTTParty
    
    attr_accessor :attributes
    
    def self.find(name)
      build(get(singular_url(name)))
    end
    
    def self.create(attributes)
      new(attributes).create
    end
    
    def self.collection(url)
      from_collection(get(Octopi.base_url + url))
    end
    
    def initialize(attributes)
      @attributes = {}
      attributes.each do |k, v|
        @attributes[k] = v 
        self.class.send(:define_method, k) do
          @attributes[k]
        end unless respond_to?(k)
      end
    end
    
    def create
      self.class.new(self.class.post(self.class.plural_url, :body => attributes))
    end
    
    private
    
    def self.singular_url(name)
      plural_url + "/#{name}"
    end
    
    def self.plural_url
      Octopi.base_url + "/#{self.name.split("::").last.downcase}s"
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
  end
end