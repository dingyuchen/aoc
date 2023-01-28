require "../lib/*"
include ChallengeInput

def eval(action)
  left, op, right = action.split(" ")
  ->(old : Int64) {
    case op
    when "*"
      return old * right.to_i unless right == "old"
      old * old
    else
      return old + right.to_i unless right == "old"
      old + old
    end
  }
end

def eval(cond, conseq, alt)
  ->(i : Int64) { (i % cond == 0) ? conseq : alt }
end

def monkeys
  ChallengeInput.get_string "day11" do |content|
    content.split("\n\n").each.map do |note|
      lines = note.lines.map &.strip
      id = lines[0]["Monkey ".size].to_i
      items = lines[1][("Starting items: ".size)..].split(", ").map &.to_i64
      op_string = lines[2]["Operation: new = ".size..]
      op = eval op_string
      div = lines[3]["Test: divisible by ".size..].to_i64
      cons = lines[4]["If true: throw to monkey ".size..]
      alt = lines[5]["If false: throw to monkey ".size..]
      test = eval div, cons.to_i64, alt.to_i64
      Monkey.new id, items, op, div, test
    end.to_a
  end
end

class Monkey
  property id : Int32
  property item_queue : Array(Int64)
  getter inspected : Int64
  getter div : Int64
  @operation : Proc(Int64, Int64)
  @test : Proc(Int64, Int64)
  @@base : Int64 = 1

  def self.base=(value)
    @@base = value
  end

  def initialize(@id, @item_queue, @operation, @div, @test)
    @inspected = 0
  end

  def catch(item)
    @item_queue << item
  end

  def take_turn(others, relief = true)
    while !@item_queue.empty?
      item = inspect relief
      throw item, others
    end
  end

  def inspect(relief)
    item = @item_queue.shift
    item = @operation.call item # inspect
    @inspected += 1
    item = item // 3 if relief # relief
    item = item.to_i64 % @@base
  end

  def throw(item, others)
    throw_target = @test.call item
    others[throw_target].catch item
  end
end

Monkey.base = monkeys.map(&.div).product

p "part1"
m = monkeys
20.times do
  m.each do |monkey|
    monkey.take_turn m
  end
end
p m.map(&.inspected).sort[-2..].product

p "part2"
m = monkeys
10_000.times do
  m.each do |monkey|
    monkey.take_turn m, false
  end
end
p m.map(&.inspected).sort[-2..].product
