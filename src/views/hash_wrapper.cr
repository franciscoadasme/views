require "./wrapper"

# Wraps a `Hash` object. The including type will behave as a read-only
# hash, where objects returned by methods will be wrapped as well if the
# return type is the same as the original hash.
#
# ```
# class Table
#   include HashWrapper(String, Int32)
# end
#
# table = Table.new({"a" => 1, "b" => 2})
# table["a"]?                   # => 1
# table["b"]?                   # => 2
# table["c"]?                   # => nil
# table["c"] = 3                # does not compile
# table.select { |_, v| v > 2 } # => Table{"b" => 2}
# ```
module HashWrapper(K, V)
  include Enumerable({K, V})
  include Iterable({K, V})
  include Wrapper(Hash(K, V))

  delegate :[], :[]?, compact, dig, dig?, each, each_key, each_value,
    empty?, fetch, first_key, first_key?, first_value, first_value?,
    has_key?, has_value?, invert, key_for, key_for?, keys, last_key,
    last_key?, last_value, last_value?, pretty_print, proper_subset_of?,
    proper_superset_of?, reject, :select, size, subset_of?,
    superset_of?, to_a, to_s, transform_keys, transform_values, values,
    values_at

  def initialize(@wrapped : Hash(K, V) = {} of K => V)
  end

  def inspect(io : IO) : Nil
    io << self.class.name.partition('(')[0]
    to_s io
  end

  # Returns the wrapped hash.
  def to_h : Hash(K, V)
    @wrapped
  end
end
