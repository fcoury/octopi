module Octopi
  module Self
    # Returns a list of Key objects containing all SSH Public Keys this user
    # currently has. Requires authentication.
    def keys
      raise AuthenticationRequired, "To view keys, you must be authenticated" if Api.api.read_only?
      result = Api.api.get("/user/keys", { :cache => false })
      return unless result and result["public_keys"]
      KeySet.new(result["public_keys"].inject([]) { |result, element| result << Key.new(element) })
    end
  
    # Returns a list of Email objects containing the email addresses associated with this user.
    # Requires authentication.
    def emails
      raise AuthenticationRequired, "To view emails, you must be authenticated" if Api.api.read_only?
      get("/user/emails")['emails']
    end

    # Start following a user.
    # Can only be called if you are authenticated.
    def follow!(login)
      raise AuthenticationRequired, "To begin following someone, you must be authenticated" if Api.api.read_only?
      Api.api.post("/user/follow/#{login}")
    end
    
    # Stop following a user.
    # Can only be called if you are authenticated.
    def unfollow!(login)
      raise AuthenticationRequired, "To stop following someone, you must be authenticated" if Api.api.read_only?
      Api.api.post("/user/unfollow/#{login}")
    end
  end
end