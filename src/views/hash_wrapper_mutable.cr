require "./wrapper"

# Wraps a `Hash` object. The including type will behave as a hash, where
# objects returned by methods will be wrapped as well if the return type
# is the same as the original hash.
#
# ```
# class Table
#   include HashWrapper::Mutable(String, Int32)
# end
#
# table = Table.new {"a" => 1, "b" => 2}
# table["a"]? # => 1
# table["b"]? # => 2
# table["c"]? # => nil
# table["c"] = 3
# table.select { |_, v| v > 2 } # => Table{"b" => 2}
#
# table["a"] = -1
# table["c"] = 3
# table["a"]? # => -1
# table["c"]? # => 3
#
# table.select!("a")
# table.keys # => ["a"]
# ```
module HashWrapper::Mutable(K, V)
  include Wrapper(Hash(K, V))

  def initialize(@wrapped : Hash(K, V) = {} of K => V)
  end

  def inspect(io : IO) : Nil
    io << self.class.name.partition('(')[0]
    to_s io
  end
end
