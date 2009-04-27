module Octopi
  class Key < Base
    include Resource
    
    attr_reader :user

    def initialize(api, data, user = nil)
      super api, data
      @user = user
    end
    
    def remove!
      result = @api.post "/user/key/remove", :id => id
      keys = result["public_keys"].select { |k| k["title"] == title }
      keys.empty?
    end
  end
end