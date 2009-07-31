require File.join(File.dirname(__FILE__), 'test_helper')

class UserTest < Test::Unit::TestCase
  include Octopi
  
  def setup
    fake_everything
  end
  
  context "authenticated" do
    should "return all user information" do
      authenticated do
        user = Api.api.user
        assert_not_nil user
        fields = [:company, :name, :following_count, :blog, :public_repo_count, 
                  :public_gist_count, :id, :login, :followers_count, :created_at,
                  :email, :location, :disk_usage, :private_gist_count, :plan, 
                  :owned_private_repo_count, :total_private_repo_count]
        fields.each do |f|
          assert_not_nil user.send(f)
        end
        
        plan_fields = [:name, :collaborators, :space, :private_repos]
        plan_fields.each do |f|
          assert_not_nil user.plan.send(f)
        end
      end
    end
  end
end
