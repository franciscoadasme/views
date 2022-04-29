require "./array_wrapper"

# Wraps an `Array` object. The including type will behave as an array,
# where objects returned by methods will be wrapped as well if the
# return type is the same as the original array.
#
# ```
# class CustomArray(T)
#   include ArrayWrapper::Mutable(T)
# end
#
# arr = CustomArray.new([1, 2, 3, 4])
# arr.size                  # => 4
# arr[0]?                   # => 1
# arr[6]?                   # => nil
# arr.select(&.even?)       # => [2, 4]
# arr.select(&.even?).class # => CustomArray(Int32)
#
# arr[0] = -1
# arr[3] = -4
# arr[0]? # => -1
# arr[3]? # => -4
#
# arr.select!(&.<(3))
# arr # => [-1, 2, -4]
# ```
module ArrayWrapper::Mutable(T)
  include Indexable::Mutable(T)
  include ArrayWrapper(T)

  delegate :<<, :[]=, clear, compact!, concat, delete,
    delete_at, fill, insert, map!, map_with_index!, pop, push, reject!,
    replace, reverse!, rotate!, select!, shift, shuffle!, sort!,
    sort_by!, swap, truncate, uniq!, unsafe_put, unshift,
    unstable_sort!, unstable_sort_by!, update
end
