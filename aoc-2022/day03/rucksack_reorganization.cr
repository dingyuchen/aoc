day = "day03"
content = File.read("#{day}/input.in")

priorities = content.each_line.map do |line|
  mid = line.size // 2
  left = line[0...mid]
  right = line[mid..]
  intersection = left.each_char.to_set & right.each_char.to_set
  repeat = intersection.first
  prioritize repeat
end

def prioritize(item)
  item.uppercase? ? item.ord - 65 + 27 : item.ord - 97 + 1
end

puts "part1"
puts priorities.sum

badges = content.each_line.to_a.in_groups_of(3, "").map do |group|
  group.map { |a| a.each_char.to_set }.reduce { |a, b| a & b }.first
end

puts "part2"
puts badges.map { |a| prioritize a }.sum
