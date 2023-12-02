day = "day05"
content = File.read("#{day}/input.in")

init_stacks, moves = content.split("\n\n")

stacks = init_stacks.each_line.map { |line| line.each_char.to_a }.to_a.transpose
stacks = stacks.map { |stack| stack.reverse[1..].reject { |c| c == ' ' } }
stacks = (1...stacks.size).step(by: 4).map { |i| stacks[i] }.to_a

# p stacks

moves = moves.each_line.map do |line|
  words = line.split(' ')
  quan, start, stop = (1...words.size).step(by: 2).map { |i| words[i].to_i }.to_a
  #   p aryp
  {quan, start, stop}
end.to_a

solomover_stacks = stacks.clone
moves.each do |quan, start, stop|
  src, dest = start - 1, stop - 1
  solomover_stacks[src].pop(quan).reverse.each do |value|
    solomover_stacks[dest].push value
  end
end

msg = solomover_stacks.each.map { |stack| stack[-1] }.to_a
p "part1"
p msg.join("")

multimover_stacks = stacks.clone
moves.each do |quan, start, stop|
  src, dest = start - 1, stop - 1
  multimover_stacks[src].pop(quan).each do |value|
    multimover_stacks[dest].push value
  end
end
msg = multimover_stacks.each.map { |stack| stack[-1] }.to_a

p "part2"
p msg.join("")
