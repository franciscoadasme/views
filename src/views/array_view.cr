# An `ArrayView` is a read-only version of an `Array`. This is useful to
# give access to a non-modifiable array in a type-safe manner.
#
# The functionality of `ArrayView` is limited by design, as it just
# delegates the methods defined by the `Indexable` mixin to the
# encompassed array.
#
# ```
# arr = ArrayView.new([1, 2, 3, 4])
# arr.size            # => 4
# arr[2]              # => 3
# arr.select &.even?  # => [2, 4]
# arr.select! &.even? # does not compile
# arr.sort            # does not compile
# ```
struct ArrayView(T)
  include Indexable(T)
  include Comparable(Indexable(T))

  def initialize(@arr : Array(T))
  end

  def <=>(rhs : Indexable(T)) : Int32
    @arr <=> rhs
  end

  def inspect(io : IO) : Nil
    io << self.class.name.partition('(')[0]
    to_s io
  end

  def size : Int
    @arr.size
  end

  def to_a : Array(T)
    @arr
  end

  def to_s(io : IO) : Nil
    @arr.to_s io
  end

  def unsafe_fetch(index : Int) : T
    @arr.unsafe_fetch(index)
  end
end
