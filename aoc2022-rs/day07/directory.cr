require "./file"

class Directory
  getter name : String
  getter parent : Directory | Nil
  getter contents : Array(MyFile | Directory)
  @size : Int64 | Nil

  def initialize(@name, @parent)
    @contents = [] of (MyFile | Directory)
  end

  def add(content)
    @contents << content
  end

  def enter(name) : Directory
    child = @contents.find { |f| f.name == name }
    if child.is_a? Directory
      return child
    end
    raise "No Such Folder"
  end

  def size : Int64
    if size = @size
      return size
    end
    size = @contents.each.map(&.size).sum
    @size = size
    return size
  end

  def directories
    curr_level = @contents.each.select &.is_a? Directory
    curr_level = curr_level.to_a
    curr_level + curr_level.flat_map &.directories
  end
end
