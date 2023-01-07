day = "day04"
content = File.read("#{day}/input.in")

ranges = content.each_line.map do |pair|
  left, right = pair.split(",")
  left_range = Range.new *Tuple(Int32, Int32).from left.split("-").map { |s| s.to_i }
  right_range = Range.new *Tuple(Int32, Int32).from right.split("-").map { |s| s.to_i }
  {left_range, right_range}
end.to_a # ranges w/o to_a is an iterator, which means that it is consumable

p "part1"
p ranges.count { |left, right| right.covers?(left.begin) & right.covers?(left.end) || left.covers?(right.begin) & left.covers?(right.end) }

p "part2"
p ranges.count { |left, right| left.select(right).any? } # any? short circuits block, so speed and memory usage is ok
