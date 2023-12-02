require "spec"
require "../day14/rock_path.cr"

describe Point do
  describe "#init" do
    it "should initialize on a valid input" do
      pt = Point.new "476,71"
      pt.x.should eq 476
      pt.y.should eq 71
    end
  end

  describe "#to" do
    it "should return a set of all points in a horizonal line from a to b" do
      a = Point.new "476,71"
      b = Point.new "481,71"
      line = a.to b
      line.should eq (476..481).map { |x| {x, 71} }.to_set
    end

    it "should return a set of all points in a vertical line from a to b" do
      a = Point.new "498,4"
      b = Point.new "498,6"
      line = a.to b
      line.should eq Set.new [{498, 4}, {498, 5}, {498, 6}]
    end
  end
end

describe RockPath do
  describe "#init" do
    it "should parse input into list of points" do
      path = RockPath.new "476,71 -> 481,71"
      path.points.size.should eq 2
      pt1 = path.points[0]
      pt1.x.should eq 476
      pt1.y.should eq 71
      pt2 = path.points[1]
      pt2.x.should eq 481
      pt2.y.should eq 71
    end
  end

  describe "#to_set" do
    it "should return a set of points by joining points in a line" do
      path = RockPath.new "487,48 -> 487,49 -> 490,49 -> 490,48"
      path.to_set.should eq Set.new [{487, 48}, {487, 49}, {488, 49}, {489, 49}, {490, 49}, {490, 48}]
    end
  end
end
