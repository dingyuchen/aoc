require "spec"
require "../day12/hill"

describe Hill do
  h = Hill.new ["abc", "def", "ghi", "SxE"].map &.each_char.to_a
  describe "#hill_find" do
    it "should return the coordinate of start" do
      h.hill_find('a').should eq({0, 0})
    end

    it "should throw an error if there is no coordinate" do
      expect_raises(Enumerable::EmptyError) do
        p h.hill_find('z')
      end
    end
  end

  describe "#find_all" do
    it "should return a list of coordinates" do
      hill = Hill.new ["Sabqponm", "abcryxxl", "accszExk", "acctuvwj", "abdefghi"].map &.each_char.to_a
      hill.find_all('a').should be_a Array({Int32, Int32})
    end
  end

  describe "#find_next" do
    it "should return climbable coordinates" do
      h.find_next({0, 0}).should eq [{0, 1}]
      h.find_next({1, 0}).should contain({0, 0})
      h.find_next({1, 0}).should contain({1, 1})
    end
  end

  describe "#get_elevation" do
    it "should return ord for lowercase" do
      h.get_elevation(0, 0).should eq 'a'.ord
    end
    it "should return 97 for 'S'" do
      h.get_elevation(3, 0).should eq 'a'.ord
    end

    it "should return 122 for 'E'" do
      h.get_elevation(3, 2).should eq 'z'.ord
    end
  end

  describe "#climb" do
    it "should return 31 for the sample" do
      h = Hill.new ["Sabqponm", "abcryxxl", "accszExk", "acctuvwj", "abdefghi"].map &.each_char.to_a
      path = h.climb
      path.distance.should eq 31
    end
  end
end

describe HillPath do
  describe "#goto" do
    it "should create a new Path" do
      p1 = HillPath.new({0, 0})
      p2 = p1.goto({0, 1})
      p1.travelled.should eq [{0, 0}]
      p2.travelled.should eq [{0, 0}, {0, 1}]
    end
  end
end
