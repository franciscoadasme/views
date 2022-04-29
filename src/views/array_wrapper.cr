require "./wrapper"

# Wraps an `Array` object. The including type will behave as a read-only
# array, where objects returned by methods will be wrapped as well if
# the return type is the same as the original array.
#
# ```
# class CustomArray(T)
#   include ArrayWrapper(T)
# end
#
# arr = CustomArray.new([1, 2, 3, 4])
# arr.size                  # => 4
# arr[0]?                   # => 1
# arr[6]?                   # => nil
# arr.select(&.even?)       # => [2, 4]
# arr.select(&.even?).class # => CustomArray(Int32)
# arr.select!(&.even?)      # does not compile
# ```
module ArrayWrapper(T)
  include Comparable(Indexable(T))
  include Indexable(T)
  include Wrapper(Array(T))

  delegate :|, :&, :+, :-, :*, :<=>, :[], :[]?, compact,
    each_repeated_permutation, first, flatten, index, last, map,
    map_with_index, reject, remaining_capacity, repeated_permutations,
    reverse, rotate, sample, :select, shuffle, size, skip, skip_while,
    sort, sort_by, take_while, uniq, unsafe_fetch, unstable_sort,
    unstable_sort_by, to_s, transpose

  def initialize(@wrapped : Array(T) = [] of T)
  end

  def <=>(rhs : self) : Int32
    @wrapped <=> rhs.to_a
  end

  # Invokes `Array#[]each_slice(n, reuse)` on the enclosed array,
  # yielding a wrapped array each time.
  def each_slice(n : Int, reuse : Array(T) | Bool = false, & : self ->) : Nil
    @wrapped.each_slice(n, reuse) do |slice|
      yield wrap(slice)
    end
  end

  # Returns the result of calling `Array#group_by(&)` on the enclosed
  # array with the hash's values wrapped.
  def group_by(& : T -> U) : Hash(U, self) forall U
    @wrapped.group_by { |ele| yield ele }.transform_values { |ary| wrap(ary) }
  end

  def inspect(io : IO) : Nil
    io << self.class.name.partition('(')[0]
    to_s io
  end

  # Returns the wrapped result of calling `Array#partition(&)` on the
  # enclosed array.
  def partition(& : T -> _) : Tuple(self, self)
    @wrapped.partition { |ele| yield ele }.map { |ary| wrap(ary) }
  end

  # Returns the wrapped array.
  def to_a : Array(T)
    @wrapped
  end
end
