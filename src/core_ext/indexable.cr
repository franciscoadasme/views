module Indexable(T)
  # Returns the elements at the given indexes. Raises `IndexError` if
  # any index is out of bounds.
  #
  # ```
  # arr = "0123456789".chars
  # arr[8, 3, 6]      # => ['8', '3', '6']
  # arr[[8, 3, 6]]    # => ['8', '3', '6']
  # arr[Set{8, 3, 6}] # => ['8', '3', '6']
  # arr[{8, 3, 6}]    # => {'8', '3', '6'}
  # arr[*{8, 3, 6}]   # => ['8', '3', '6']
  # arr[7, 25, 1]     # raises IndexError
  # ```
  def [](index : Int, other : Int, *indexes : Int) : self
    Array(T).new(indexes.size + 2).tap do |arr|
      arr << self[index] << self[other]
      indexes.each do |index|
        arr << self[index]
      end
    end
  end

  # :ditto:
  def [](indexes : Tuple) : Tuple
    indexes.map { |index| self[index] }
  end

  # :ditto:
  def [](indexes : Indexable(Int)) : self
    Array(T).new(indexes.size).tap do |arr|
      indexes.each do |index|
        arr << self[index]
      end
    end
  end

  # :ditto:
  def [](indexes : Enumerable(Int)) : self
    indexes.map { |index| self[index] }
  end
end
