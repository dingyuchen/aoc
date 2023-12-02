require "../lib/*"
require "./*"
include ChallengeInput

def packets
  ChallengeInput.get_string "day13" do |content|
    content.split("\n\n").each.map do |packets|
      left, right = packets.each_line.map do |input|
        Packet.new input
      end.to_a
      {left, right}
    end.to_a
  end
end

p "part1"
p packets.each_with_index(1).select { |(left, right), i| (left <=> right) == -1 }.map(&.[1]).sum

p "part2"
decoders = [Packet.new("[[2]]"), Packet.new("[[6]]")]
all_packets = packets.flat_map(&.to_a) + decoders
all_packets.sort!

p all_packets.each_with_index(1).select { |pkt, i| decoders.includes? pkt }.map(&.[1]).product
