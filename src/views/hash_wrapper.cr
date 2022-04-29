# Wraps a `Hash` object. The including type will behave as a read-only
# hash, where ojects returned by methods will be wrapped as well if the
# return type is the same as the original hash.
#
# ```
# class Table
#   include HashWrapper(String, Int32)
# end
#
# table = Table.new {"a" => 1, "b" => 2}
# table["a"]? # => 1
# table["b"]? # => 2
# table["c"]? # => nil
# table["c"] = 3 # does not compile
# table.select { |_, v| v > 2 } # => Table{"b" => 2}
# ```
module HashWrapper(K, V)
  include Enumerable({K, V})
  include Iterable({K, V})

  delegate :[], :[]?, compact, dig, dig?, each, each_key, each_value,
    empty?, fetch, first_key, first_key?, first_value, first_value?,
    has_key?, has_value?, invert, key_for, key_for?, keys, last_key,
    last_key?, last_value, last_value?, pretty_print, proper_subset_of?,
    proper_superset_of?, size, subset_of?, superset_of?, to_a, to_h,
    to_s, transform_keys, transform_values, values, values_at,
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

  # Returns the wrapped result of calling `Hash#reject(keys)`.
  def reject(keys : Enumerable(K)) : self
    wrap @hash.reject(keys)
  end

  # Returns the wrapped result of calling `Hash#reject(*keys)`.
  def reject(*keys : K) : self
    wrap @hash.reject(*keys)
  end

  # Returns the wrapped result of calling `Hash#reject(&)`.
  def reject(& : K, V -> _) : self
    wrap @hash.reject { |k, v| yield k, v }
  end

  # Returns the wrapped result of calling `Hash#select(keys)`.
  def select(keys : Enumerable(K)) : self
    wrap @hash.select(keys)
  end

  # Returns the wrapped result of calling `Hash#select(*keys)`.
  def select(*keys : K) : self
    wrap @hash.select(*keys)
  end

  # Returns the wrapped result of calling `Hash#select(&)`.
  def select(& : K, V -> _) : self
    wrap @hash.select { |k, v| yield k, v }
  end

  # Returns the wrapped hash.
  def to_h : Hash(K, V)
    @hash
  end

  private def wrap(hash : Hash(K, V)) : self
    self.class.new hash
  end
end
