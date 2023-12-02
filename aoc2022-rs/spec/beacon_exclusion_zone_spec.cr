require "spec"
require "../day15/sensor.cr"

describe Sensor do
  describe "#init" do
    it "should initialize manhattan properly" do
      b = Sensor.new ({0, 0}), ({1, 1})
      b.range.should eq 2

      c = Sensor.new ({-1, -1}), ({1, 1})
      c.range.should eq 4
    end
  end

  describe "#scan" do
    it "should return a range that cuts the radius" do
      b = Sensor.new ({0, 0}), ({0, 7})
      r = b.scan 5
      r.should eq((-2..2))
    end
  end
end
