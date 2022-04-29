require "./spec_helper"

describe HashView do
  it "access to hash" do
    view = HashView.new({"a" => 1, "b" => 2})
    view.size.should eq 2
    view.keys.should eq %w(a b)
    view["a"]?.should eq 1
    view["c"]?.should be_nil
    view.select("a").should eq({"a" => 1})
  end

  describe "#inspect" do
    it "returns the string representation" do
      expected = %(HashView{"a" => 1, "b" => 2})
      HashView.new({"a" => 1, "b" => 2}).inspect.should eq expected
    end
  end

  describe "#to_h" do
    it "returns the wrapped hash" do
      hash = {"a" => 1, "b" => 2}
      HashView.new(hash).to_h.should be hash
    end
  end
end
