require 'rubygems'

require 'httparty'
require 'mechanize'
require 'nokogiri'
require 'api_cache'

require 'yaml'
require 'pp'

# Core extension stuff
Dir[File.join(File.dirname(__FILE__), "ext/*.rb")].each { |f| require f }

# Octopi stuff
# By sorting them we ensure that api and base are loaded first on all sane operating systems
Dir[File.join(File.dirname(__FILE__), "octopi/*.rb")].sort.each { |f| require f }

# Include this into your app so you can access the child classes easier.
# This is the root of all things Octopi.
module Octopi
  
  # The authenticated methods are all very similar.
  # TODO: Find a way to merge them into something... better.
  
  def authenticated(options={}, &block)
    begin
      config = config = File.open(options[:config]) { |yf| YAML::load(yf) } if options[:config]
      config = read_gitconfig
      options[:login] = config["github"]["user"]
      options[:token] = config["github"]["token"]
      
      authenticated_with(options) do
        yield 
      end
    ensure
      # Reset authenticated so if we were to do an anonymous call it would Just Work(tm)
      Api.authenticated = false
      Api.api = AnonymousApi.instance
    end
  end
  
  def authenticated_with(options, &block)
    begin

      Api.api.trace_level = options[:trace] if options[:trace]
      
      if options[:token].nil? && !options[:password].nil?
        options[:token] = grab_token(options[:login], options[:password])
      end
      begin
        User.find(options[:login])
        # If the user cannot see themselves then they are not logged in, tell them so
      rescue Octopi::NotFound
        raise Octopi::InvalidLogin
      end
    
      trace("=> Trace on: #{options[:trace]}")
    
      Api.api = AuthApi.instance
      Api.api.login = options[:login]
      Api.api.token = options[:token]
    
      yield
    ensure
      # Reset authenticated so if we were to do an anonymous call it would Just Work(tm)
      Api.authenticated = false
      Api.api = AnonymousApi.instance
    end
  end
    
  private
  
  def grab_token(username, password)
    a = Mechanize.new { |agent|
      # Fake out the agent
      agent.user_agent_alias = 'Mac Safari'
    }
    
    # Login with the provided 
    a.get('http://github.com/login') do |page|
      user_page = page.form_with(:action => '/session') do |login|
        login.login = username
        login.password = password
      end.submit


      if Api.api.trace_level
        File.open("got.html", "w+") do |f|
          f.write user_page.body
        end   
        `open got.html`
      end
      
      body = Nokogiri::HTML(user_page.body)
      error = body.xpath("//div[@class='error_box']").text
      raise error if error != ""
      
      # Should be clear to go if there is no errors.
      link = user_page.link_with(:text => "account")
      @account_page = a.click(link)
      if Api.api.trace_level
        File.open("account.html", "w+") do |f|
          f.write @account_page.body
        end
        `open account.html`
      end
      
      return Nokogiri::HTML(@account_page.body).xpath("//p").xpath("strong")[1].text
    end
  end
  
  
  def read_gitconfig
    config = {}
    group = nil
    File.foreach("#{ENV['HOME']}/.gitconfig") do |line|
      line.strip!
      if line[0] != ?# && line =~ /\S/
        if line =~ /^\[(.*)\]$/
          group = $1
          config[group] ||= {}
        else
          key, value = line.split("=").map { |v| v.strip }
          config[group][key] = value
        end
      end
    end
    config
  end
  
  def trace(text)
    if Api.api.trace_level
      puts "text"
    end
  end
end