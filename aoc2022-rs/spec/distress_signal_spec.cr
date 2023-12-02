require "spec"
require "../day13/packet"

describe Packet do
  describe "#parse" do
    it "should be able to parse flat arrays" do
      pkt = Packet.new "[1,1,3,1,1]"
      pkt.data.should eq [1, 1, 3, 1, 1]
    end

    it "should be able to parse empty arrays" do
      pkt = Packet.new "[]"
      pkt.data.should eq [] of Int32
    end

    it "should be able to parse nested arrays" do
      pkt = Packet.new "[1,2,[3,[4]]]"
      pkt.data.should eq [1, 2, Packet.new [3, Packet.new [4] of Int32 | Packet]]
    end

    it "should be able to parse nested empty arrays" do
      pkt = Packet.new "[[]]"
      pkt.data.should eq [Packet.new [] of Int32 | Packet]
    end

    it "should be able to parse nested arrays" do
      b = Packet.new "[[1],4]"
      b.data.should eq [Packet.new([1] of Int32 | Packet), 4]
    end
  end

  describe "#<=>" do
    it "should do lexicographical comparison for equal length packets" do
      a = Packet.new "[1,1,3,1,1]"
      b = Packet.new "[1,1,5,1,1]"
      (a <=> b).should eq -1
    end

    it "should do lexicographical comparison for nested packets" do
      a = Packet.new "[[1],[2,3,4]]"
      b = Packet.new "[[1],4]"
      (a <=> b).should eq -1
    end

    it "should correctly order shorter packet if value is larger" do
      a = Packet.new "[9]"
      b = Packet.new "[[8, 7, 6]]"
      (a <=> b).should eq 1
    end

    it "should correctly order shorter packet if all value are equal" do
      a = Packet.new "[[4, 4], 4, 4]"
      b = Packet.new "[[4, 4], 4, 4, 4]"
      (a <=> b).should eq -1
    end

    it "should return out of order for pair 7" do
      a = Packet.new "[[[]]]"
      b = Packet.new "[[]]"
      (a <=> b).should eq 1
    end
  end
end
