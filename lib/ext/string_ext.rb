class String
  def camel_case
    self.gsub(/(^|_)(.)/) { $2.upcase }
  end
end