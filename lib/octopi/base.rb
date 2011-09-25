module Octopi
  class Base
    
    attr_accessor :attributes

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
    
    def self.collection(url, klass=self)
      from_collection(get(url), klass)
    end
    
    def initialize(attributes)
      @attributes = {}
      attributes.each do |k, v|
        @attributes[k] = v 
        self.class.send(:define_method, k) do
          @attributes[k.to_sym]
        end unless respond_to?(k)
      end
      @attributes.symbolize_keys!
    end
    
    def create
      self.class.build(self.class.post(self.class.collection_url, :body => attributes))
    end

    def update(json)
      self.class.post(url, :body => json)
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

    def url
      self.class.singular_url(self.id)
    end
  end
end
