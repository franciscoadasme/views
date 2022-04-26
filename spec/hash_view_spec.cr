require "./spec_helper"

describe HashView do
  it "views into a hash" do
    view = HashView.new({"a" => 1, "b" => 2})
    view.size.should eq 2
    view.keys.should eq %w(a b)
    view["a"]?.should eq 1
    view["c"]?.should be_nil
    view.select("a").should eq({"a" => 1})
  end

  describe "#inspect" do
    it "returns the string representation" do
      HashView.new({"a" => 1, "b" => 2}).inspect.should eq %(HashView{"a" => 1, "b" => 2})
    end
  end

  describe "#to_h" do
    it "returns the viewed hash" do
      hash = {"a" => 1, "b" => 2}
      HashView.new(hash).to_h.should be hash
    end
  end
end
