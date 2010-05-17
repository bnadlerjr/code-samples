module ArrayExtensions
  # Converts an array into a hash using the specified +keys+. The +keys+ will 
  # be converted into symbols. Raises an +ArgumentError+ if the array and 
  # +keys+ are not the same length.
  #
  # Example::
  # [1, 2, 3].to_hash(%w[foo bar baz]) => { :foo => 1, :bar => 2, :baz => 3 }
  def to_hash(keys)
    raise(ArgumentError, 
      'Array and key lengths do not match.') unless self.length == keys.length
    
    result = Hash.new
    self.each_with_index { |item, index| result[keys[index].to_sym] = item }
    
    result
  end
end
