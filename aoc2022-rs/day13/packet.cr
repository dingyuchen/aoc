class Packet
  property data : Array(Int32 | Packet)

  def initialize(str : String)
    it = str.each_char
    it.next
    packet, _ = parse(it)
    @data = packet.data
  end

  def initialize(@data)
  end

  private def parse(iter)
    data = [] of Int32 | Packet
    c = iter.next
    while c != ']'
      case c
      when '['
        sub, iter = parse(iter)
        data << sub
      else
        buf = String.build { |builder|
          while !(c == ',' || c == ']')
            builder << c
            c = iter.next
          end
        }
        data << buf.to_i unless buf.empty?
        return Packet.new(data), iter if c == ']'
      end
      c = iter.next
    end
    {Packet.new(data), iter}
  end

  def to_s : String
    @data.each.map(&.to_s).join ","
  end

  def ==(other : Packet)
    @data == other.data
  end

  def <=>(other : Int32)
    self <=> Packet.new [other] of Int32 | Packet
  end

  def <=>(other : Packet)
    max_length = {@data.size, other.data.size}.max
    return -(other <=> self) if @data.size != max_length
    @data.zip?(other.data).each do |left, right|
      return 1 if right.nil?
      return -1 if left.nil?
      cmp = case left
            when Int32
              right.is_a?(Packet) ? Packet.new([left] of Int32 | Packet) <=> right : left <=> right
            else
              left <=> right
            end
      return cmp if cmp != 0
    end
    0
  end
end
