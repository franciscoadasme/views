require "./spec_helper"

describe Hash::View do
  it "access to hash" do
    view = Hash::View.new({"a" => 1, "b" => 2})
    view.size.should eq 2
    view.keys.should eq %w(a b)
    view["a"]?.should eq 1
    view["c"]?.should be_nil
    view.select("a").should eq({"a" => 1})
  end

  describe "#inspect" do
    it "returns the string representation" do
      expected = %(Hash::View{"a" => 1, "b" => 2})
      Hash::View.new({"a" => 1, "b" => 2}).inspect.should eq expected
    end
  end

  describe "#to_h" do
    it "returns the wrapped hash" do
      hash = {"a" => 1, "b" => 2}
      Hash::View.new(hash).to_h.should be hash
    end
  end
end

describe Hash do
  describe "#view" do
    it "returns a view" do
      hash = {"a" => 1, "b" => 2}
      view = hash.view
      view.should be_a Hash::View(String, Int32)
      view.to_h.should be hash
    end
  end
end
