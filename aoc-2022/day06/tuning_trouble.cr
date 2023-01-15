require "../lib/*"
include ChallengeInput

def find_marker(seq_length : Int32)
  ChallengeInput.get_string "day06" do |content|
    content.size.times do |i|
      window = content[i...(i + seq_length)]
      if window.size == window.chars.to_set.size
        p window
        return i + seq_length
      end
    end
  end
end

def find_marker_w_bits(seq_length : Int32)
  # how to benchmark ?
end

p "part1"
p find_marker(4)
p "part2"
p find_marker(14)
