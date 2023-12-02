require "../lib/*"
include ChallengeInput

struct Addx
  property command : String
  property value : Int32

  def initialize(@command, @value)
  end

  def cycles
    2
  end

  def action
    ->(value : Int32) { value + @value }
  end
end

struct Noop
  def cycles
    1
  end

  def action
    ->(value : Int32) { value }
  end
end

alias Instruction = Addx | Noop

instructions = ChallengeInput.get_string "day10" do |content|
  content.each_line.map { |line|
    words = line.split(" ")
    case words[0]
    when "addx"
      Addx.new words[0], words[1].to_i
    when "noop"
      Noop.new
    else
      raise "No such instruction:" + words[0]
    end
  }.to_a
end

class CPU
  property cycle : Int32
  property register : Int32
  getter signal_strengh : Array(Int32)
  @drawing : String
  @action_queue : Array(Array(Proc(Int32, Int32)))

  def initialize(longest_cycle)
    @cycle = 1
    @register = 1
    @action_queue = Array(Array(Proc(Int32, Int32))).new
    longest_cycle.times {
      @action_queue << [] of Proc(Int32, Int32)
    }
    @signal_strengh = Array(Int32).new
    @drawing = ""
  end

  def exe_no_overlap(instructions)
    @drawing = String.build do |builder|
      instructions.each do |inst|
        no_overlap inst, builder
      end
    end
  end

  def no_overlap(inst, builder)
    (inst.cycles - 1).times do
      @signal_strengh << @cycle * @register
      builder << print_dot
      @cycle += 1
    end
    @signal_strengh << @cycle * @register
    builder << print_dot
    @register = inst.action.call(@register)
    @cycle += 1
  end

  def print_dot
    idx = @cycle - 1
    idx = idx % 40
    sprite_pos.includes?(idx) ? "#" : "."
  end

  def sprite_pos
    (@register - 1..@register + 1)
  end

  def print
    @drawing.each_char.in_groups_of(40).map(&.join).join('\n')
  end

  def exe(instructions : Array(Instruction))
    instructions.each do |inst|
      load inst
      exe
    end
    @action_queue.size.times { exe }
  end

  def exe
    @signal_strengh << @cycle * @register

    procs = @action_queue.shift
    @action_queue << [] of Proc(Int32, Int32)
    procs.each do |proc|
      @register = proc.call(@register)
    end

    @cycle += 1
  end

  def load(inst : Instruction)
    @action_queue[inst.cycles - 1] << inst.action
  end
end

p "part1"
cpu = CPU.new 2
cpu.exe_no_overlap instructions
p (0..5).each.map(&.*(40).+(19)).take_while { |idx| idx < cpu.signal_strengh.size }.map { |idx| cpu.signal_strengh[idx] }.sum

p "part2"
puts cpu.print
p "RFZEKBFA"
