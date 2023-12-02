class SandSimulator
  getter drop_count : Int32
  getter blocks : Set({Int32, Int32})
  @init : {Int32, Int32}
  @boundary : Int32

  def initialize(@blocks, @boundary)
    @init = {500, 0}
    @drop_count = 0
  end

  def drop_sand : Bool
    @drop_count += 1
    curr = @init
    while curr[1] < @boundary
      x, y = curr
      curr = {x, y + 1} # try down
      next unless @blocks.includes? curr
      # down is blocked, try left
      curr = {x - 1, y + 1}
      next unless @blocks.includes? curr
      # left is blocked, try right
      curr = {x + 1, y + 1}
      next unless @blocks.includes? curr
      # right is blocked
      @blocks << {x, y} # the sand is stuck in the "past" position
      return true
    end
    false
  end

  def pile_sand : Bool
    return false if @blocks.includes? @init
    floor = @boundary + 2
    @drop_count += 1
    curr = @init
    while curr[1] < floor - 1 # not on the floor
      x, y = curr
      curr = {x, y + 1} # try down
      next unless @blocks.includes? curr
      # down is blocked, try left
      curr = {x - 1, y + 1}
      next unless @blocks.includes? curr
      # left is blocked, try right
      curr = {x + 1, y + 1}
      next unless @blocks.includes? curr
      # right is blocked
      @blocks << {x, y} # the sand is stuck in the "past" position
      return true
    end
    @blocks << curr
    true
  end

  def print_screen
    left = @blocks.min_by { |(x, y)| x }[0]
    right = @blocks.max_by { |(x, y)| x }[0]
    String.build do |builder|
      (0..@boundary + 2).each do |height|
        (left..right).each do |x|
          if @blocks.includes?({x, height})
            builder << "#"
          else
            builder << "."
          end
        end
        builder << '\n'
      end
    end
  end
end
