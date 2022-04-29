require "./spec_helper"

private class CustomHash(K, V)
  include HashWrapper(K, V)
end

describe HashWrapper do
  it "access to hash" do
    view = CustomHash.new({"a" => 1, "b" => 2})
    view.size.should eq 2
    view.keys.should eq %w(a b)
    view["a"]?.should eq 1
    view["c"]?.should be_nil
    view.select("a").should eq({"a" => 1})
  end

  it "returns wrapped hash" do
    view = CustomHash.new({"a" => 1, "b" => 2})
    view.reject(&.itself).should be_a CustomHash(String, Int32)
    view.select(&.itself).should be_a CustomHash(String, Int32)
  end

  describe "#inspect" do
    it "returns the string representation" do
      expected = %(CustomHash{"a" => 1, "b" => 2})
      CustomHash.new({"a" => 1, "b" => 2}).inspect.should eq expected
    end
  end

  describe "#to_h" do
    it "returns the wrapped hash" do
      hash = {"a" => 1, "b" => 2}
      CustomHash.new(hash).to_h.should be hash
    end
  end
end
