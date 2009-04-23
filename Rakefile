require 'rubygems'
require 'erb'
require 'maruku'

def generate_page(page)

  @pcontent = ''
  
  # render markdown from page, if present
  mpage = "pages/#{page}.markdown"
  if File.exists?(mpage)
    content = File.read(mpage)
    doc = Maruku.new(content)
    @pcontent += doc.to_html
    @pcontent += '<br/><br/><hr/>'
  end
    
  @pcontent += '<div class="span-21 last">&nbsp;</div><hr/>'
    
  pname = "p/#{page}.html"
  out = ERB.new(File.read('template/page.erb.html')).result
  File.open(pname, 'w') { |f| f.write(out) }
end

# generate the site
desc "Generate the html files for the site"
task :gensite do

  Dir["pages/*"].entries.each do |p|
    (ignore, page) = p.split('/')
    (pname, ignore) = page.split('.')
    puts pname
    generate_page(pname)
  end
  
end

task :default => [:gensite]
