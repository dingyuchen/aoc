day = "day01"
content = File.read("#{day}/input.in")

elf_calories = content.split("\n\n").to_a.map do |elf|
  calories = elf.each_line.to_a.map do |calorie|
    calorie.to_i
  end
  calories.sum
end

puts "part1"
puts elf_calories.max

puts "part2"
puts elf_calories.sort { |a, b| b <=> a }[0..2].sum
