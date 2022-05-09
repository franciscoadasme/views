require "./spec_helper"

describe Indexable::View do
  it "views into an array" do
    view = Indexable::View(StaticArray(Int32, 4), Int32).new StaticArray[1, 2, 3, 4]
    view.size.should eq 4
    view[0].should eq 1
    view[1].should eq 2
    view[2].should eq 3
    view[3].should eq 4
  end

  describe "#<=>" do
    it "compares with an indexable" do
      arr = Indexable::View(StaticArray(Int32, 4), Int32).new StaticArray[1, 2, 3, 4]
      (arr <=> [1, 2, 3, 4]).should eq 0
      (arr <=> [4, 3, 2, 1]).should eq -1
      (arr <=> [-1, -2, -3, -4]).should eq 1
    end
  end

  describe "#inspect" do
    it "returns the string representation" do
      arr = Indexable::View(StaticArray(Int32, 4), Int32).new StaticArray[1, 2, 3, 4]
      arr.inspect.should eq "Indexable::View(StaticArray[1, 2, 3, 4])"
    end
  end

  describe "#to_s" do
    it "returns the string representation of the array" do
      arr = Indexable::View(StaticArray(Int32, 4), Int32).new StaticArray[1, 2, 3, 4]
      arr.to_s.should eq "StaticArray[1, 2, 3, 4]"
    end
  end
end
