require "../lib/*"
include ChallengeInput

def trees
  ChallengeInput.get_string "day08" do |content|
    content.each_line.map do |line|
      line.split("").map &.to_i
    end.to_a
  end
end

trees = trees()

length = trees.first.size

def sight_trees(iter)
  seen = Set(Tuple(Int32, Int32)).new
  iter.reduce -1 do |tallest, (tree, row, col)|
    seen << {row, col} if tree > tallest
    [tallest, tree].max
  end
  seen
end

row_visible = trees.each.with_index.reduce Set(Tuple(Int32, Int32)).new do |acc, (row, i)|
  seen = sight_trees row.each.map_with_index { |tree, j| {tree, i, j} }
  reverse_seen = sight_trees row.reverse_each.zip((0...99).reverse_each).map { |tree, j| {tree, i, j} }
  acc + seen + reverse_seen
end

col_visible = trees.transpose.each.with_index.reduce Set(Tuple(Int32, Int32)).new do |acc, (col, j)|
  seen = sight_trees col.each.map_with_index { |tree, i| {tree, i, j} }
  reverse_seen = sight_trees col.reverse_each.zip((0...99).reverse_each).map { |tree, i| {tree, i, j} }
  acc + seen + reverse_seen
end

visible = row_visible + col_visible
p "part1"
p visible.size

def see_forest
  trees.each_with_index { |row, i|
    line = row.map_with_index do |tree, j|
      visible.includes?({i, j}) ? tree : "x"
    end.join ""
    p line
  }
end

def look_around(init, sightlines)
  sightlines.each.reduce 1 do |acc, trees|
    score = 0
    trees.each do |tree|
      score += 1 if tree <= init
      break if tree >= init
    end
    return 0 if score == 0
    acc * score
  end
end

def left_from(i, j)
  trees[i][...j].reverse_each
end

def right_from(i, j)
  trees[i][(j + 1)..]
end

def up_from(i, j)
  trees[...i].reverse_each.map &.[j]
end

def down_from(i, j)
  trees[(i + 1)..].each.map &.[j]
end

best_scene = trees.each_with_index.map do |row, i|
  row.each_with_index.map do |tree, j|
    score = look_around tree, [left_from(i, j), right_from(i, j), up_from(i, j), down_from(i, j)]
  end.max
end.max

p "part2"
p best_scene
