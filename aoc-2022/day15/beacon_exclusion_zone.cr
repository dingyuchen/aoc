require "../lib/*"
require "./*"
include ChallengeInput

def sensors
  ChallengeInput.get_string "day15" do |content|
    parse_sensors content
  end
end

def parse_sensors(content : String)
  content.each_line.map do |line|
    mds = line.scan /\d+/
    bx, by = mds[0][0], mds[1][0]
    sx, sy = mds[2][0], mds[3][0]
    Sensor.new ({bx.to_i, by.to_i}), ({sx.to_i, sy.to_i})
  end.to_a
end

def range_of(sensors, depth)
  ranges = sensors.each.map(&.scan depth).select { |s| !s.empty? }.to_a
  ranges.sort_by! { |r| r.begin }
  start = ranges[0].begin # first range is the leftmost
  stop = ranges[1].end
  coverage = [] of Range(Int32, Int32)
  ranges.each do |r|
    if r.begin <= stop
      stop = [r.end, stop].max
    else
      coverage << (start..stop)
      start, stop = r.begin, r.end
    end
  end
  coverage << (start..stop)
  coverage
end

def find_exclusion(sensors, scanline)
  ranges = range_of sensors, scanline
  pos = 0
  occupied = sensors.flat_map { |s| [s.beacon, s.sensor] }
  occupied_matter = occupied.select { |(x, y)| y == scanline }.map &.[0]
  occupied_matter = occupied_matter.to_set
  ranges.each do |r|
    pos += r.size
    occupied_matter.each do |known|
      pos -= 1 if r.covers? known
    end
  end
  pos
end

p "part1"
p find_exclusion sensors, 2000000

p "test"

# RANT: question doesn't state that the distress beacon should be a gap between the sensor coverages
# There are a total of 5 possible cases where the distress beacon can be found. (refer to test print out)
# Therefore question should really be explaining more regarding how the "only possible" answer is found

def find_gaps(s, bounds)
  # s = sensors
  gaps = [] of {Range(Int32, Int32), Int32}
  (0..bounds).each do |y|
    ranges = range_of s, y # ranges are naturally sorted
    start = 0
    puts "#{ranges} @ #{y}"
    ranges.each do |range|
      if range.begin > start
        gap = {(start...range.begin), y}
        gaps << gap
      end
      start = range.end + 1
      break if start >= bounds
    end
  end
  gaps
end

test = "Sensor at x=2, y=18: closest beacon is at x=-2, y=15
Sensor at x=9, y=16: closest beacon is at x=10, y=16
Sensor at x=13, y=2: closest beacon is at x=15, y=3
Sensor at x=12, y=14: closest beacon is at x=10, y=16
Sensor at x=10, y=20: closest beacon is at x=10, y=16
Sensor at x=14, y=17: closest beacon is at x=10, y=16
Sensor at x=8, y=7: closest beacon is at x=2, y=10
Sensor at x=2, y=0: closest beacon is at x=2, y=10
Sensor at x=0, y=11: closest beacon is at x=2, y=10
Sensor at x=20, y=14: closest beacon is at x=25, y=17
Sensor at x=17, y=20: closest beacon is at x=21, y=22
Sensor at x=16, y=7: closest beacon is at x=15, y=3
Sensor at x=14, y=3: closest beacon is at x=15, y=3
Sensor at x=20, y=1: closest beacon is at x=15, y=3"
tsensors = parse_sensors test
gaps = find_gaps parse_sensors(test), 20
p gaps

p "part2"
bounds = 4_000_000

def find_range_gap(s, bounds)
  candidates = [] of Tuple(Int32, Int32) # because there were multiple gaps
  (0..bounds).each do |y|
    ranges = range_of s, y # ranges are naturally sorted
    candidates << {ranges[0].end + 1, y} if ranges.size > 1 && ranges[1].begin - ranges[0].end == 2
  end
  candidates
end

gaps = find_range_gap sensors, bounds
p gaps
# p x.to_i64 * 4000000 + y
