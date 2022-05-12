require "./spec_helper"

describe Indexable do
  describe "#[]" do
    it "returns the elements at the given indexes" do
      (10..19).to_a[1, 5, 3].should eq [11, 15, 13]
      (10..19).to_a[[1, 5, 3]].should eq [11, 15, 13]
      (10..19).to_a[Set{1, 5, 3}].should eq [11, 15, 13]
      (10..19).to_a[{1, 5, 3}].should eq({11, 15, 13})
      (10..19).to_a[*{1, 5, 3}].should eq [11, 15, 13]
    end

    it "raises if any index is out of bounds" do
      expect_raises IndexError do
        (0..1).to_a[1, 15, 3]
      end
    end
  end
end
