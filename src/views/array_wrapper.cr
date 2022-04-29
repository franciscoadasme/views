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

  delegate compact, each_repeated_permutation, flatten, index,
    remaining_capacity, repeated_permutations, size, unsafe_fetch, to_a,
    to_s, transpose,
    to: @arr

  def initialize(@arr : Array(T) = [] of T)
  end

  {% for op in %w(| & + - *) %}
    # Returns the wrapped result of calling `Array#{{op}}(rhs)` on the
    # encompassed array.
    def {{op.id}}(rhs : Indexable(T) | self) : self
      wrap @arr {{op.id}} rhs.to_a
    end
  {% end %}

  def <=>(rhs : Indexable(T)) : Int32
    @arr <=> rhs
  end

  def <=>(rhs : self) : Int32
    @arr <=> rhs.to_a
  end

  # Returns the wrapped result of calling `Array#[](start, count)` on
  # the encompassed array.
  def [](start : Int, count : Int) : self
    wrap @arr[start, count]
  end

  # Returns the wrapped result of calling `Array#[](range)` on the
  # encompassed array.
  def [](range : Range(Int, Int)) : self
    wrap @arr[range]
  end

  # Returns the wrapped result of calling `Array#[]?(start, count)` on
  # the encompassed array.
  def []?(start : Int, count : Int) : self?
    wrap @arr[start, count]?
  end

  # Returns the wrapped result of calling `Array#[]?(range)` on the
  # encompassed array.
  def []?(range : Range(Int, Int)) : self?
    wrap @arr[range]?
  end

  # Invokes `Array#[]each_slice(n, reuse)` on the encompassed array,
  # yielding a wrapped array each time.
  def each_slice(n : Int, reuse : Array(T) | Bool = false, & : self ->) : Nil
    @arr.each_slice(n, reuse) do |slice|
      yield wrap(slice)
    end
  end

  # Returns the wrapped result of calling `Array#first(count)` on the
  # encompassed array.
  def first(count : Int) : self
    wrap @arr.first(count)
  end

  # Returns the result of calling `Array#group_by(&)` on the encompassed
  # array with the hash's values wrapped.
  def group_by(& : T -> U) : Hash(U, self) forall U
    @arr.group_by { |ele| yield ele }.transform_values { |ary| wrap(ary) }
  end

  def inspect(io : IO) : Nil
    io << self.class.name.partition('(')[0]
    to_s io
  end

  # Returns the wrapped result of calling `Array#last(count)` on the
  # encompassed array.
  def last(count : Int) : self
    wrap @arr.last(count)
  end

  # Returns the result of calling `Array#map(&)` on the encompassed
  # array, wrapping the result if it's of the same type.
  def map(& : T -> U) : Array(U) forall U
    wrap @arr.map { |ele| yield ele }
  end

  # Returns the result of calling `Array#map_with_index(offset, &)` on
  # the encompassed array, wrapping the result if it's of the same type.
  def map_with_index(offset : Int = 0, & : T -> U) : Array(U) forall U
    wrap @arr.map_with_index { |ele, i| yield ele, i }
  end

  # Returns the wrapped result of calling `Array#partition(&)` on the
  # encompassed array.
  def partition(& : T -> _) : Tuple(self, self)
    @arr.partition { |ele| yield ele }.map { |ary| wrap(ary) }
  end

  # Returns the wrapped result of calling `Array#reject(&)` on the
  # encompassed array.
  def reject(& : T -> _) : self
    wrap @arr.reject { |ele| yield ele }
  end

  # Returns the wrapped result of calling `Array#reject(value)` on the
  # encompassed array.
  def reject(value) : self
    wrap @arr.reject(value)
  end

  # Returns the wrapped result of calling `Array#reverse` on the
  # encompassed array.
  def reverse : self
    wrap @arr.reverse
  end

  # Returns the wrapped result of calling `Array#rotate(n)` on the
  # encompassed array.
  def rotate(n : Int = 1) : self
    wrap @arr.rotate(n)
  end

  # Returns the wrapped result of calling `Array#sample(n, random)` on
  # the encompassed array.
  def sample(n : Int, random = Random::DEFAULT) : self
    wrap @arr.sample(n, random)
  end

  # Returns the wrapped result of calling `Array#select(&)` on the
  # encompassed array.
  def select(& : T -> _) : self
    wrap @arr.select { |ele| yield ele }
  end

  # Returns the wrapped result of calling `Array#select(value)` on the
  # encompassed array.
  def select(value) : self
    wrap @arr.select(value)
  end

  # Returns the wrapped result of calling `Array#shuffle(random)` on the
  # encompassed array.
  def shuffle(random : Random = Random::DEFAULT) : self
    wrap @arr.shuffle(random)
  end

  # Returns the wrapped result of calling `Array#skip(count)` on the
  # encompassed array.
  def skip(count : Int) : self
    wrap @arr.skip(count)
  end

  # Returns the wrapped result of calling `Array#skip_while(&)` on the
  # encompassed array.
  def skip_while(& : T -> _) : self
    wrap @arr.skip_while { |ele| yield ele }
  end

  # Returns the wrapped result of calling `Array#sort` on the
  # encompassed array.
  def sort : self
    wrap @arr.sort
  end

  # Returns the wrapped result of calling `Array#sort(&)` on the
  # encompassed array.
  def sort(& : T, T -> U) : self forall U
    wrap @arr.sort { |a, b| yield a, b }
  end

  # Returns the wrapped result of calling `Array#sort_by(&)` on the
  # encompassed array.
  def sort_by(& : T -> U) : self forall U
    wrap @arr.sort_by { |ele| yield ele }
  end

  # Returns the wrapped result of calling `Array#take_while(&)` on the
  # encompassed array.
  def take_while(& : T -> _) : self
    wrap @arr.take_while { |ele| yield ele }
  end

  # Returns the wrapped result of calling `Array#uniq` on the
  # encompassed array.
  def uniq : self
    wrap @arr.uniq
  end

  # Returns the wrapped result of calling `Array#uniq(&)` on the
  # encompassed array.
  def uniq(& : T ->) : self
    wrap @arr.uniq { |ele| yield ele }
  end

  # Returns the wrapped result of calling `Array#unstable_sort` on the
  # encompassed array.
  def unstable_sort : self
    wrap @arr.unstable_sort
  end

  # Returns the wrapped result of calling `Array#unstable_sort(&)` on
  # the encompassed array.
  def unstable_sort(& : T, T -> U) : self forall U
    wrap @arr.unstable_sort { |a, b| yield a, b }
  end

  # Returns the wrapped result of calling `Array#unstable_sort_by(&)` on
  # the encompassed array.
  def unstable_sort_by(& : T -> U) : self forall U
    wrap @arr.unstable_sort_by { |ele| yield ele }
  end

  private def wrap(obj : Array(T)) : self
    self.class.new obj
  end

  private def wrap(obj)
    obj
  end
end
