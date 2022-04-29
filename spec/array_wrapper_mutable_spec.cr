require "./spec_helper"

private class CustomArray(T)
  include ArrayWrapper::Mutable(T)
end

describe ArrayWrapper::Mutable do
  it "accesses to array" do
    arr = CustomArray.new([1, 2, 3, 4])
    arr.size.should eq 4
    arr[0]?.should eq 1
    arr[6]?.should be_nil
    arr.select(&.even?).should eq([2, 4])
  end

  it "modifies the array" do
    arr = CustomArray.new([1, 2, 3, 4])
    arr[0] = -1
    arr[3] = -4

    arr[0]?.should eq -1
    arr[3]?.should eq -4

    arr.select!(&.<(3))
    arr.should eq [-1, 2, -4]
  end

  it "returns wrapped array" do
    arr = CustomArray.new([1, 2, 3, 4])
    arr.reject(&.itself).should be_a CustomArray(Int32)
    arr.select(&.itself).should be_a CustomArray(Int32)
    arr.sort.should be_a CustomArray(Int32)
  end

  describe "#inspect" do
    it "returns the string representation" do
      expected = %(CustomArray[1, 2, 3, 4])
      CustomArray.new([1, 2, 3, 4]).inspect.should eq expected
    end
  end

  describe "#to_a" do
    it "returns the wrapped array" do
      arr = [1, 2, 3, 4]
      CustomArray.new(arr).to_a.should be arr
    end
  end
end
