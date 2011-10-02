module Octopi
  class Base
    
    attr_accessor :attributes, :errors

    def self.all
      from_collection(get(collection_url))
    end
    
    def self.find(name)
      response = get(singular_url(name))
      if response.code.to_i == 404
        raise NotFound, not_found_error
      else
        build(response)
      end
    end
    
    def self.create(attributes)
      new(attributes).create
    end
    
    def self.collection(url, klass=self, params={})
      response = if params.empty?
        get(url)
      else
        get(url, :query => params)
      end
      
      from_collection(response, klass)
    end
    
    def initialize(attributes)
      self.attributes = attributes
    end
    
    def create
      self.class.build(self.class.post(self.class.collection_url, :body => attributes))
    end

    def update(attributes)
      Octopi.requires_authentication! do
        response = self.class.put(url, :body => attributes.to_json)
        parsed_response = self.class.parse(response)
        if response.code.to_i == 422
          self.errors = parsed_response
          return false
        else
          self.attributes = parsed_response
          self.errors = {}
          return true
        end
      end
    end

    def delete
      self.class.delete(url)
    end
    
    def reload
      initialize(self.class.get(self.class.singular_url(self.id)))
    end

    private
    
    def self.get(*args)
      Octopi.get(*args)
    end
    
    def self.post(*args)
      Octopi.post(*args)
    end

    def self.put(*args)
      Octopi.put(*args)
    end
    
    def self.delete(*args)
      Octopi.delete(*args)
    end
    
    def self.singular_url(id)
      collection_url + "/#{id}"
    end
    
    def self.collection_url
      "/#{self.name.split("::").last.downcase}s"
    end

    # Builds objects from a collection
    def self.from_collection(response, klass=self)
      parse(response).map { |e| klass.new(e) }
    end

    def self.build(response)
      new(parse(response))
    end

    def self.parse(response)
      JSON.parse(response.body)
    end
    
    def self.not_found_error
      "The #{self} you were looking for could not be found."
    end
    
    def attributes=(attributes)
      @attributes = {}
      attributes.each do |k, v|
        @attributes[k] = v 
        self.class.send(:define_method, k) do
          @attributes[k.to_sym]
        end unless respond_to?(k)
      end
      @attributes.symbolize_keys!
    end
    
    def errors=(errors)
      @errors = errors["errors"]
    end

    def url
      self.class.singular_url(self.id)
    end
  end
end
