require 'rubygems'

require 'httparty'
require 'mechanize'
require 'nokogiri'

require 'yaml'
require 'pp'


# Octopi stuff
Dir[File.join(File.dirname(__FILE__), "octopi/*.rb")].each { |f| require f }

module Octopi
  
  # The authenticated methods are all very similar.
  # TODO: Find a way to merge them into something... better.
  
  def authenticated(*args, &block)
    begin
      opts = args.last.is_a?(Hash) ? args.last : {}
      config = read_gitconfig
      Api.authenticated = true
      Api.api = AuthApi.instance
      Api.api.login = config["github"]["user"]
      Api.api.token = config["github"]["token"]
      Api.api.trace_level = opts[:trace]
    
      puts "=> Trace on: #{api.trace_level}" if Api.api.trace_level

      yield Api.api
    ensure
      # Reset authenticated so if we were to do an anonymous call it would Just Work(tm)
      Api.authenticated = false
      Api.api = AnonymousApi.instance
    end
  end
  
  def authenticated_with(opts, &block)
    begin
      if opts[:config]
        config = File.open(opts[:config]) { |yf| YAML::load(yf) }
        raise "Missing config #{opts[:config]}" unless config
      
        opts[:login] = config["login"]
        opts[:token] = config["token"]
        trace = config["trace"]
      end
      
      Api.api.trace_level = trace if trace
      
      if opts[:token].nil? && !opts[:password].nil?
        opts[:token] = grab_token(opts[:login], opts[:password])
      end
        
    
      trace("=> Trace on: #{trace}")
    
      Api.api = AuthApi.instance
      Api.api.login = opts[:login]
      Api.api.token = opts[:token]
    
      yield Api.api
    ensure
      # Reset authenticated so if we were to do an anonymous call it would Just Work(tm)
      Api.authenticated = false
      Api.api = AnonymousApi.instance
    end
  end
    
  private
  
  def grab_token(username, password)
    a = WWW::Mechanize.new { |agent|
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