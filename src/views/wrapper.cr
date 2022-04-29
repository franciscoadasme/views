# Wraps an object such that missing methods in the including type are
# delegated to the wrapped object. Objects returned by methods will be
# wrapped as well if the return type is the same as the original object.
#
# ```
# struct SpecialArray
#   include Wrapper(Array(Int32))
# end
#
# arr = [1, 2, 3, 4]
# sarr = SpecialArray.new arr
# sarr[0]  # => 1
# sarr[-1] # => 4
#
# # Returned objects are wrapped if appropiate
# sarr[0..2]           # => SpecialArray[1, 2, 3]
# sarr.select(&.even?) # => SpecialArray[2, 4]
#
# # Write access the original object
# sarr.select!(&.odd?)
# sarr # => SpecialArray[1, 3]
# arr  # => [1, 3]
#
# sarr.wrapped.same? arr # => true
# ```
module Wrapper(T)
  def initialize(@wrapped : T = T.new)
  end

  macro method_missing(call)
    wrap(@wrapped.{{call}})
  end

  def ==(rhs : T) : Bool
    @wrapped == rhs
  end

  def ==(rhs : self) : Bool
    @wrapped == rhs.wrapped
  end

  def to_s(io : IO) : Nil
    @wrapped.to_s io
  end

  private def wrap(hash : T) : self
    if hash.same?(@wrapped)
      self
    else
      self.class.new(hash)
    end
  end

  private def wrap(object)
    object
  end

  # Returns the wrapped object.
  def wrapped : T
    @wrapped
  end
end
