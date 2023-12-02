require "../lib/*"
require "./*"
include ChallengeInput

def hill
  ChallengeInput.get_string "day12" do |content|
    content.split("\n").each.map do |line|
      line.each_char.to_a
    end.to_a
  end
end

p "part1"
h = Hill.new hill
p h.climb.distance

p "part2"
mul = h.climb h.find_all('a'), h.hill_find('E')
puts mul.distance
