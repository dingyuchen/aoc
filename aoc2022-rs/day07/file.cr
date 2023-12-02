class MyFile
  getter name : String
  getter size : Int64

  def initialize(@name, @size)
  end

  def each
    # Iterator.of(self) # doesn't have a stop??
    {self}.each
  end

  def directories
    [] of Directory
  end
end
