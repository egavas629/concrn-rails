class NumberSanitizer
  def self.sanitize(number)
    number.gsub(/[^0-9]/,'')[-10..-1]
  end
end
