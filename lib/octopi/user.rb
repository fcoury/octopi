module Octopi
  class User < Base
    def self.me
      Octopi.requires_authentication! do
        self.new(self.get("/user"))
      end
    end


    # This method is really a "proxy" to Gist.for_user
    # The disadvantage is that using it will take two API calls.
    # 1) the initial find for the user (already done by this point)
    # 2) Gathering a list of gists.
    #
    # It's probably better to call Gist.for_user and pass the login manually,
    # but only if you have the login readily available already.
    def gists
      Gist.for_user(self.login)
    end
  end
end