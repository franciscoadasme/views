require "./hash_wrapper"

# A `HashView` is a read-only version of a `Hash`. This is useful to
# give access to a non-modifiable hash in a type-safe manner.
#
# The functionality of `HashView` is limited by design, as it just
# delegates the non-writable methods to the enclosed hash.
#
# ```
# arr = HashView.new({"a" => 1, "b" => 2})
# arr.size        # => 2
# arr["a"]        # => 1
# arr.select "b"  # => {"b" => 2}
# arr.select! "b" # does not compile
# arr["c"] = 3    # does not compile
# ```
struct HashView(K, V)
  include Enumerable({K, V})
  include Iterable({K, V})

  delegate :[], :[]?, compact, dig, dig?, each, each_key, each_value,
    empty?, fetch, first_key, first_key?, first_value, first_value?,
    has_key?, has_value?, invert, key_for, key_for?, keys, last_key,
    last_key?, last_value, last_value?, merge, pretty_print,
    proper_subset_of?, proper_superset_of?, reject, :select, size,
    subset_of?, superset_of?, to_a, to_h, to_s, transform_keys,
    transform_values, values, values_at,
    to: @hash

  def initialize(@hash : Hash(K, V) = {} of K => V)
  end

  def ==(rhs : Hash(K, V)) : Bool
    @hash == rhs
  end

  def ==(rhs : self) : Bool
    @hash == rhs.to_h
  end

  def inspect(io : IO) : Nil
    io << self.class.name.partition('(')[0]
    to_s io
  end
end
