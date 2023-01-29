class RockPath
  property points : Array(Point)

  def initialize(@points)
  end

  def initialize(str : String)
    @points = str.split(" -> ").each.map { |s| Point.new s }.to_a
  end

  def to_set : Set({Int32, Int32})
    coords = Set({Int32, Int32}).new
    @points.each_cons(2) do |(a, b)|
      line = a.to b
      line.each do |pt|
        coords << pt
      end
    end
    coords
  end
end

class Point
  property x : Int32
  property y : Int32

  def initialize(@x, @y)
  end

  def initialize(str : String)
    x, y = str.split(",")
    initialize x.to_i, y.to_i
  end

  def to(other : Point) : Set({Int32, Int32})
    if @x == other.x
      start, finish = [@y, other.y].min, [@y, other.y].max
      (start..finish).map { |y| {@x, y} }.to_set
    elsif @y == other.y
      start, finish = [@x, other.x].min, [@x, other.x].max
      (start..finish).map { |x| {x, @y} }.to_set
    else
      raise "cannot draw diagonal line!"
    end
  end
end
