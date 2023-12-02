require "../lib/*"
require "./*"
include ChallengeInput

def paths
  ChallengeInput.get_string "day14" do |content|
    content.each_line.map do |line|
      RockPath.new line
    end.to_a
  end
end

rocks = paths.each.reduce(Set({Int32, Int32}).new) { |acc, i| acc + i.to_set }
max_depth = rocks.max_by { |(x, y)| y }

p "part1"
sim = SandSimulator.new rocks.clone, max_depth[1]
while sim.drop_sand
end
p sim.drop_count - 1

p "part2" # issue with rocks passing by reference
sim = SandSimulator.new rocks.clone, max_depth[1]
while sim.pile_sand
end
p sim.drop_count
