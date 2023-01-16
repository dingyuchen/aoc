require "../lib/*"
include ChallengeInput

moves = ChallengeInput.get_string "day09" do |content|
  content.each_line.map do |line|
    dir, count = line.split(" ")
    count = count.to_i
    {dir, count}
  end.to_a
end

p moves
