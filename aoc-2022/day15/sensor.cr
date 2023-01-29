class Sensor
  getter sensor : Tuple(Int32, Int32)
  getter beacon : Tuple(Int32, Int32)
  getter range : Int32

  def initialize(@sensor, @beacon)
    sx, sy = @sensor
    bx, by = @beacon
    @range = (bx - sx).abs + (by - sy).abs
  end

  def scan(y)
    sx, sy = @sensor

    y_diff = (sy - y).abs
    return (0...-1) if y_diff > @range

    x_range = @range - y_diff
    return (sx - x_range..sx + x_range)
  end
end
