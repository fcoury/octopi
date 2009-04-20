module Octopi
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
    
    private
    def self.extract_user_repository(*args)
      opts = args.last.is_a?(Hash) ? args.pop : {}
      if opts.empty?
        user, repo = *args
      else
        opts[:repo] = opts[:repository] if opts[:repository]
        repo = args.pop || opts[:repo]
        user = opts[:user]
      end
      
      user ||= repo.owner if repo.is_a? Repository
      
      if repo.is_a?(String) and !user
        raise "Need user argument when repository is identified by name"
      end
      
      ret = extract_names(user, repo)
      ret << opts
      ret
    end

    def self.extract_names(*args)
      args.map do |v|
        v = v.name  if v.is_a? Repository
        v = v.login if v.is_a? User
        v
      end
    end
  end
end