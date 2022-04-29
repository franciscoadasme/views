# Wraps an object such that methods are delegated to the wrapped object.
# The return values of the methods will be wrapped as well if the return
# type is the same as the wrapped object.
#
# ```
# struct SpecialArray
#   include Wrapper(Array(Int32))
#   fully_delegate
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

  # Delegates missing methods to the wrapped object using the
  # `method_missing` hook.
  macro fully_delegate
    macro method_missing(call)
      wrap(@wrapped.\{{call}})
    end
  end

  # Delegates *methods* to the enclosed object, wrapping the return
  # value if it is of the same type as the enclosed object.
  #
  # ```
  # struct CustomInt
  #   include Wrapper(Int32)
  #
  #   delegate :+
  # end
  #
  # val = CustomInt.new(5) + 10
  # val.class # => CustomInt
  # val       # => 15
  # ```
  macro delegate(*methods)
    {% for method in methods %}
      {% if method.id.ends_with?('=') && method.id != "[]=" %}
        def {{method.id}}(arg)
          wrap @wrapped.{{method.id}}(arg)
        end
      {% else %}
        def {{method.id}}(*args, **options)
          wrap @wrapped.{{method.id}}(*args, **options)
        end

        {% if method.id != "[]=" %}
          def {{method.id}}(*args, **options)
            wrap @wrapped.{{method.id}}(*args, **options) { |*yield_args|
              yield *yield_args
            }
          end
        {% end %}
      {% end %}
    {% end %}
  end

  delegate pretty_print, to_s

  def ==(rhs : T) : Bool
    @wrapped == rhs
  end

  def ==(rhs : self) : Bool
    @wrapped == rhs.wrapped
  end

  private def wrap(obj : T) : self
    if obj.responds_to?(:same) && obj.same?(@wrapped)
      self
    else
      self.class.new(obj)
    end
  end

  private def wrap(obj)
    obj
  end

  # Returns the wrapped object.
  def wrapped : T
    @wrapped
  end
end
