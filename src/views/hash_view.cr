require "./hash_wrapper"

# A `HashView` is a read-only version of a `Hash`. This is useful to
# give access to a non-modifiable hash in a type-safe manner.
#
# The functionality of `HashView` is limited by design, as it just
# delegates the non-writable methods to the encompassed hash.
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
  include HashWrapper(K, V)
end
