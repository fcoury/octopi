  class Base
    def initialize(api, hash)
      @api = api
      @keys = []
      
      raise "Missing data for #{@resource}" unless hash
      
      hash.each_pair do |k,v|
        @keys << k
        next if k =~ /\./
        instance_variable_set("@#{k}", v)
        
        self.class.send :define_method, "#{k}=" do |v|
          instance_variable_set("@#{k}", v)
        end

        self.class.send :define_method, k do
          instance_variable_get("@#{k}")
        end
      end
    end
    
    def property(p, v)
      path = "#{self.class.path_for(:resource)}/#{p}"
      @api.find(path, self.class.resource_name(:singular), v)
    end
    def save
      hash = {}
      @keys.each { |k| hash[k] = send(k) }
      @api.save(self.path_for(:resource), hash)
    end
  end
