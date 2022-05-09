require "./spec_helper"

describe Array::View do
  it "views into an array" do
    view = Array::View.new([1, 2, 3, 4])
    view.size.should eq 4
    view[0].should eq 1
    view[1].should eq 2
    view[2].should eq 3
    view[3].should eq 4
  end

  describe "#<=>" do
    it "compares with an indexable" do
      (Array::View.new([1, 2, 3, 4]) <=> [1, 2, 3, 4]).should eq 0
      (Array::View.new([1, 2, 3, 4]) <=> [4, 3, 2, 1]).should eq -1
      (Array::View.new([1, 2, 3, 4]) <=> [-1, -2, -3, -4]).should eq 1
    end
  end

  describe "#inspect" do
    it "returns the string representation" do
      Array::View.new([1, 2, 3, 4]).inspect.should eq "Array::View[1, 2, 3, 4]"
    end
  end

  describe "#to_a" do
    it "returns the viewed array" do
      arr = [1, 2, 3, 4]
      Array::View.new(arr).to_a.should be arr
    end
  end

  describe "#to_s" do
    it "returns the string representation of the array" do
      Array::View.new([1, 2, 3, 4]).to_s.should eq "[1, 2, 3, 4]"
    end
  end
end
