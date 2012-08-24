class String
  def demodulize
    path = self
    if i = path.rindex('::')
      path[(i+2)..-1]
    else
      path
    end
  end

  def demodulize!
    self.replace(demodulize)
  end
end

