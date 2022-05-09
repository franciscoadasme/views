# An `IndexableView` is a read-only version of any indexable type. This
# is useful to give read access to a mutable indexable type such as an
# array in a type-safe manner.
#
# The functionality of `IndexableView` is limited by design, as it just
# implements the `Indexable` mixin requirements by delegating to the
# enclosed object.
#
# ```
# arr = StaticArray[1, 2, 3, 4]
# view = IndexableView(StaticArray(Int32, 4)).new(arr)
# view.size            # => 4
# view[2]              # => 3
# view.select &.even?  # => [2, 4]
# view.select! &.even? # does not compile
# view.sort            # does not compile
# ```
struct Indexable::View(T, U)
  include Indexable(U)
  include Comparable(Indexable(U))

  def initialize(@indexable : T)
  end

  def ==(rhs : Indexable(U)) : Bool
    equals?(rhs) { |x, y| x == y }
  end

  def <=>(rhs : Indexable(U)) : Int32
    min_size = Math.min(size, rhs.size)
    0.upto(min_size - 1) do |i|
      n = unsafe_fetch(i) <=> rhs.to_unsafe[i]
      return n if n != 0
    end
    size <=> rhs.size
  end

  def <=>(rhs : self) : Int32
    @indexable <=> rhs
  end

  def inspect(io : IO) : Nil
    io << self.class.name.partition('(')[0] << '('
    to_s io
    io << ')'
  end

  def size : Int32
    @indexable.size
  end

  def to_s(io : IO) : Nil
    @indexable.to_s io
  end

  def unsafe_fetch(index : Int) : U
    @indexable.unsafe_fetch(index)
  end
end
