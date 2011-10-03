module Octopi
  class Me < User
    def watched
      # No need to do requires_authentication! here, as Octopi::User.me calls it
      self.class.collection("/user/watched", Octopi::Repo)
    end
  end
  
end