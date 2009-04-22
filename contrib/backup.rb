require File.join(File.dirname(__FILE__), '..', 'lib', 'octopi')

USAGE_MSG = <<EOF
Usage: #{$0} <user> [<directory>]

Performs a backup of the named user's GitHub.com data.

This script will fetch the repositories, along with their metadata and
associated issues, for the named user. It will also retrieve the user's
profile, and those of his followers. This data will be stored in
<directory>/<user>. If a directory is not supplied, ~/.github-backup will be
used instead.
EOF
# TODO: Accept list of targets as argument. The main use case is somebody
# wanting all of their repositories checked out, without the performane hit
# and clutter of the extraneous metadata,
include Octopi

class Object
  def to_yaml_file(file)
    File.open("#{file}.yaml", 'w') do |f|
      YAML.dump(self, f)
    end
  end
end

TARGETS = [:user, :followers, :repositories, :issues]

@user, @basedir = ARGV
raise ArgumentError, USAGE_MSG unless @user
@basedir ||= File.expand_path("~/.github-backup")
@basedir = File.join(@basedir,@user)
TARGETS.map{|k| k.to_s}.each do |dir|
  dir = File.join(@basedir,dir)
  FileUtils.mkdir_p(dir) unless File.exists? dir
end  

@user = User.find(@user)

def user
  puts "* Saving profile"
  @user.to_yaml_file(@user.login)
end

def followers
  @user.followers!.each do |follower|
    puts "* #{follower.login} (#{follower.name})"
    follower.to_yaml_file(follower.login)
  end  
end

def repositories
  @user.repositories.each do |repo|
    puts "* #{repo.name} (#{repo.description})\n---"
    
    git_dir = File.join(repo.name,'.git')
    # FIXME: Instead of just checking for a Git directory, we could try `git
    # pull`, and if that indicates that the repository doesn't exist, `git
    # clone`
    if File.exists? git_dir
      Dir.chdir repo.name do
        # FIXME: If this fails, try deleting the clone and re-cloning?
        # FIXME: Confirm this is the best solution as opposed to re-cloning
        # every time, using `git fetch` or `git clone --mirror`.
        system("git pull")
      end
    else  
      system("git clone #{repo.clone_url}")
    end
    repo.to_yaml_file(repo.name)
    puts
  end
end

# TODO: For forked repositories whose parents have issue trackers, get their
# issues instead.
def issues
  FileUtils.mkdir_p @user.repositories.map{|r| r.name}
  @user.repositories.each do |repo|
    puts "#{repo.name}"
    Dir.chdir(repo.name) do
      repo.all_issues.each do |issue|
        puts "* #{issue.title} [#{issue.state}]"
        issue.to_yaml_file(issue.number)
      end
    end  
  end    
end

TARGETS.each do |target|
  target.to_s.each do |title|
    puts title.capitalize
    title.length.times {print '#'}
  end  
  puts
  Dir.chdir(File.join(@basedir, target.to_s)) do
    send(target)
  end
  puts
end  
