alias Grid = Array(Array(Char))

class Hill
  getter hill : Grid
  @@dir = [{0, 1}, {0, -1}, {1, 0}, {-1, 0}]
  @height : Int32
  @width : Int32

  def initialize(@hill)
    @height = @hill.size
    @width = @hill[0].size
  end

  def hill_find(symbol) : ({Int32, Int32})
    @hill.each_with_index.map do |row, i|
      j = row.index symbol
      j && {i, j}
    end.reject(Nil)
      .first
  end

  def find_all(char)
    @hill.each_with_index.flat_map do |row, i|
      row.each_with_index
        .select { |c, j| c == char }
        .map { |c, j| {i, j} }
        .to_a
    end.to_a
  end

  def find_next(pos)
    x, y = pos
    elevation = get_elevation(x, y)
    ary = [] of {Int32, Int32}
    return ary if elevation.nil?
    @@dir.each { |dx, dy|
      nx, ny = x + dx, y + dy
      e = get_elevation(nx, ny)
      ary << {nx, ny} if !e.nil? && e <= elevation + 1
    }
    ary
  end

  def get_elevation(x, y)
    return unless 0 <= x && x < @height && 0 <= y && y < @width
    begin
      c = @hill[x][y]
      h = c.lowercase? ? c : c == 'S' ? 'a' : 'z'
      h.ord
    end
  end

  def climb
    start = hill_find 'S'
    finish = hill_find 'E'
    climb [start], finish
  end

  def climb(init : Array({Int32, Int32}), dest)
    queue = init.map { |i| HillPath.new i }
    visited = init.to_set
    while !queue.empty?
      track = queue.shift
      return track if track.curr == dest
      moves = find_next track.curr
      moves.each do |pos|
        unless visited.includes? pos
          visited << pos
          new_track = track.goto pos
          queue << new_track
          # queue.sort
        end
      end
    end
    HillPath.new({0, 0})
  end
end

class HillPath
  property travelled : Array({Int32, Int32})
  getter curr : {Int32, Int32}
  @@end = {0, 0}
  @manhattan : Int32 | Nil

  def initialize(@curr : Tuple(Int32, Int32))
    @travelled = [@curr]
  end

  def initialize(@curr, @travelled)
  end

  def self.end=(@@end)
  end

  def goto(pos)
    return HillPath.new(pos, @travelled + [pos])
  end

  def distance
    @travelled.size - 1
  end

  def manhattan
    return man if man = @manhattan
    x, y = @curr
    ex, ey = @@end
    man = (ex - x).abs + (ey - y).abs
    @manhattan = man
    man
  end

  def <=>(other)
    distance + manhattan - other.distance - other.manhattan
  end
end
