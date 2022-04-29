require "./spec_helper"

private struct CustomArray
  include Wrapper(Array(Int32))
end

describe Wrapper do
  it "delegates to wrapped object" do
    arr = [1, 2, 3, 4]
    carr = CustomArray.new arr
    carr[0]?.should eq 1
    carr[-1]?.should eq 4

    carr[0..2].should be_a CustomArray
    carr[0..2].should eq CustomArray{1, 2, 3}
    carr.select(&.even?).should be_a CustomArray
    carr.select(&.even?).should eq CustomArray{2, 4}

    carr.select!(&.odd?)
    carr.should eq CustomArray{1, 3}
    arr.should eq [1, 3]

    carr.wrapped.should be arr
  end

  describe "#==" do
    it "compares with the wrapped type" do
      (CustomArray{1, 2, 3, 4} == [1, 2, 3, 4]).should be_true
    end

    it "compares with the same type" do
      (CustomArray{1, 2, 3, 4} == CustomArray{1, 2, 3, 4}).should be_true
    end
  end

  describe "#to_s" do
    it "returns the string representation of the wrapped object" do
      CustomArray{1, 2, 3, 4}.to_s.should eq "[1, 2, 3, 4]"
    end
  end
end
