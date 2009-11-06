class Hash
  def method_missing(method, *args)
    self[method] || self[method.to_s]
  end
end