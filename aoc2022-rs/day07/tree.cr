class Tree
  property children : Array(Tree)

  def initialize(@value : Int32)
    @children = [] of Tree
  end

  def add(child : Tree)
    @children << child
  end

  def <<(child : Tree)
    self.add(child)
  end

  def each_leaf : Iterator(Int32)
    Iterator.chain [{@value}.each, @children.each.flat_map(&.each_leaf)]
  end
end

root = Tree.new 3
root << Tree.new 1
root << Tree.new 5

p root.each_leaf.to_a
p "hi"
