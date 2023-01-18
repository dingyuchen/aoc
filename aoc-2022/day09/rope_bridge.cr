require "../lib/*"
include ChallengeInput

moves = ChallengeInput.get_string "day09" do |content|
  content.each_line.map do |line|
    dir, count = line.split(" ")
    count = count.to_i
    {dir, count}
  end.to_a
end

class RopeSimulation
  property knots : Array({Int32, Int32})
  property visited : Set({Int32, Int32})

  def initialize(knots)
    @knots = Array({Int32, Int32}).new(knots, {0, 0})
    @visited = Set({Int32, Int32}).new
    @visited << {0, 0}
  end

  def move(direction : String, count : Int32)
    count.times {
      @knots[0] = move direction, @knots[0]
      (0..).each.zip((1..).each).first(@knots.size - 1).each do |id1, id2|
        front, back = @knots[id1], @knots[id2]
        @knots[id2] = update_tail front, back
      end
      @visited << @knots[-1]
    }
  end

  private def move(direction : String, head : {Int32, Int32})
    x, y = head
    case direction
    when "U"
      {x, y + 1}
    when "D"
      {x, y - 1}
    when "L"
      {x - 1, y}
    when "R"
      {x + 1, y}
    else
      raise "unknown direction"
    end
  end

  private def update_tail(front, back)
    hx, hy = front
    tx, ty = back
    x = (hx - tx)
    y = (hy - ty)
    return back if x.abs + y.abs < 2 || {x.abs, y.abs} == {1, 1}
    absceil = ->(i : Int32) { i < 0 ? i // 2 : -(i // -2) }
    absfloor = ->(i : Int32) { -absceil.call(-i) }
    dx, dy = {x, y}.map { |coord| x.abs + y.abs == 3 ? absceil.call(coord) : absfloor.call(coord) }
    {tx + dx, ty + dy}
  end

  def state
    ["head", @knots.first 1, "tail", @knots.last 1].join(",")
  end
end

p "part1"
sim = RopeSimulation.new 2
moves.each { |move| sim.move *move }
p sim.visited.size

p "part2"
sim = RopeSimulation.new 10
moves.each { |move| sim.move *move }
p sim.visited.size
