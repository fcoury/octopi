require File.join(File.dirname(__FILE__), "key")
class KeySet < Array
  include Octopi
  def find(title)
    key = detect { |key| key.title == title }
    raise NotFound, Key if key.nil?
    key
  end
  
  def add(opts)
    Key.add(opts)
  end
end