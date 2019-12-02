require 'pry'

class Intcode
  attr_reader :program

  def initialize program
    @program = program
    @pointer = 0
  end

  def run
    until @program[@pointer] == 99
      case @program[@pointer]
      when 1
        opcode_one
      when 2
        opcode_two
      else
        break
      end
      @pointer += 4
    end
    @program
  end

  def get_addr index
    @program[@pointer + index]
  end

  def opcode_one
    @program[get_addr 3] = @program[get_addr 1] + @program[get_addr 2]
  end

  def opcode_two
    @program[get_addr 3] = @program[get_addr 1] * @program[get_addr 2]
  end
end

intcode_program = []

File.open './input' do |file|
  file.each do |line|
    intcode_program = line.chomp.split(',').map { |str| str.to_i }
  end
end

# intcode = Intcode.new(intcode_program)
# p intcode.run

# Brute force for part two

class BruteForce
  def initialize
    @candidates = generate_candidates
  end

  def generate_candidates
    candidates = []
    base = load_base_program
    (0..99).each do |int|
      (0..99).each do |jnt|
        base = load_base_program
        base[1] = int
        base[2] = jnt
        candidates << base
      end
    end
    candidates
  end

  def crack
    @candidates.each do |candidate|
      intcode = Intcode.new(candidate)
      result = intcode.run
      if result[0] == 19690720
        puts "Found a winner"
        puts 100 * result[1] + result[2]
      end
    end
  end

  def load_base_program
    program = []
    File.open './input' do |file|
      file.each do |line|
        program = line.chomp.split(',').map { |str| str.to_i }
      end
    end
    program
  end
end

bf = BruteForce.new
bf.crack