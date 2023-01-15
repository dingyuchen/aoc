require "../lib/*"
require "./*"
include ChallengeInput

def directories
  root = Directory.new("/", nil)
  curr_loc = root
  ChallengeInput.get_string "day07" do |content|
    content.each_line do |line|
      if line[0] == '$'
        # command
        cmd = line[2..3]
        if cmd == "cd"
          target = line[5..]
          if target == "/"
            curr_loc = root
          elsif target == ".."
            curr_loc = curr_loc.parent || curr_loc
          else
            curr_loc = curr_loc.enter target
          end
        end
      else
        # listing
        info, name = line.split(" ")
        if info == "dir"
          curr_loc.add Directory.new(name, curr_loc)
        else
          curr_loc.add MyFile.new(name, info.to_i)
        end
      end
    end
  end
  root
end

p "part1"
p "contents"
root = directories
all_dirs = [root] + root.directories
p all_dirs.each.select { |d| d.size < 100000 }.map(&.size).sum
p "part2"
total_space = 70000000
free_space = total_space - root.size
to_delete = 30_000_000 - free_space
p all_dirs.each.select { |d| d.size > to_delete }.to_a.sort_by(&.size).first.size
