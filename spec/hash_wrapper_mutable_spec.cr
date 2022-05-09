require "./spec_helper"

private class Table
  include Hash::MutableWrapper(String, Int32)
end

describe Hash::MutableWrapper do
  it "accesses to the hash" do
    table = Table.new({"a" => 1, "b" => 2})
    table.size.should eq 2
    table.keys.should eq %w(a b)
    table["a"]?.should eq 1
    table["c"]?.should be_nil
    table.select("a").should eq({"a" => 1})

    table["a"] = -1
    table["c"] = 3
    table["a"]?.should eq -1
    table["c"]?.should eq 3

    table.select!("a")
    table.keys.should eq ["a"]
  end
end
