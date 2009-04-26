require File.join(File.dirname(__FILE__), '..', 'lib', 'octopi')

include Octopi

authenticated :trace => "curl" do |g|
  repo = g.repository("api-labrat")
  
  issue = repo.open_issue :title => "Sample issue", 
    :body => "This issue was opened using GitHub API and Octopi"
  puts "Successfully opened issue \##{issue.number}"
  
  # # labels = issue.add_label "Working", "Todo"
  # # puts "Labels: #{labels.inspect}"
  
  issue.close
  puts "Successfully closed issue \##{issue.number}"
  
  # labels = issue.remove_label "Todo"
  # puts "Successfully removed label Todo. Current labels: #{labels.inspect}"
end
