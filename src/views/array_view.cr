# An `ArrayView` is a read-only version of an `Array`. This is useful to
# give access to a non-modifiable array in a type-safe manner.
#
# The functionality of `ArrayView` is limited by design, as it just
# delegates the methods defined by the `Indexable` mixin to the enclosed
# array.
#
# ```
# arr = ArrayView.new([1, 2, 3, 4])
# arr.size            # => 4
# arr[2]              # => 3
# arr.select &.even?  # => [2, 4]
# arr.select! &.even? # does not compile
# arr.sort            # does not compile
# ```
struct Array::View(T)
  include Indexable(T)
  include Comparable(Indexable(T))

  delegate :|, :&, :+, :-, :*, :<=>, :[], :[]?, compact,
    each_repeated_permutation, first, flatten, index, last, map,
    map_with_index, reject, remaining_capacity, repeated_permutations,
    reverse, rotate, sample, :select, shuffle, size, skip, skip_while,
    sort, sort_by, take_while, uniq, unsafe_fetch, unstable_sort,
    unstable_sort_by, to_a, to_s, transpose,
    to: @arr

  def initialize(@arr : Array(T))
  end

  def <=>(rhs : self) : Int32
    @arr <=> rhs.to_a
  end

  def inspect(io : IO) : Nil
    io << self.class.name.partition('(')[0]
    to_s io
  end
end
