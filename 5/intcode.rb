require "pry"

class Intcode
  def initialize filename
    @program = load_program filename
    @pointer = 0
  end

  def run input
    until @program[@pointer] == 99
      modes = get_modes @program[@pointer]
      params = get_params modes
      case @program[@pointer].digits[0] # last digit of opcode
      when 1
        add params
      when 2
        mult params
      when 3
        read input
      when 4
        write modes
      when 5
        tjmp params
      when 6
        fjmp params
      when 7
        less params
      when 8
        eqls params
      else
        puts "Invalid opcode #{@program[@pointer]}, halting"
        break
      end
      advance_pointer
      # binding.pry
    end
    @program
  end

  def advance_pointer
    case @program[@pointer].digits[0]
    when 3, 4
      @pointer += 2
    when 1, 2, 7, 8
      @pointer += 4
    else
    end
  end

  def add params
    @program[params[2]] = params[0] + params[1]
  end

  def mult params
    @program[params[2]] = params[0] * params[1]
  end

  def read input
    @program[get_addr 1] = input
  end

  def write modes
    case modes[0]
    when 0
      puts @program[get_addr 1]
    when 1
      puts @program[@pointer + 1]
    else
      "Invalid parameter mode, halting"
    end
  end

  def tjmp params
    if params[0] != 0
      @pointer = params[1]
    else
      @pointer += 3
    end
  end

  def fjmp params
    if params[0] == 0
      @pointer = params[1]
    else
      @pointer += 3
    end
  end

  def less params
    @program[params[2]] = params[0] < params[1] ? 1 : 0
  end

  def eqls params
    @program[params[2]] = params[0] == params[1] ? 1 : 0
  end

  def get_addr index
    @program[@pointer + index]
  end

  def get_params modes
    first = modes[0] == 0 ? @program[get_addr 1] : @program[@pointer + 1]
    second = modes[1] == 0 ? @program[get_addr 2] : @program[@pointer + 2]
    third = modes[2] == 0 ? @program[get_addr 3] : @program[@pointer + 3]
    return [first, second, third]
  end

  def get_modes opcode
    modes = opcode.digits[2..]
    if not modes
      [0, 0]
    elsif modes.length == 1
      modes << 0
    else
      modes
    end
  end

  def load_program filename
    program = []
    File.open filename do |file|
      file.each do |line|
        program = line.chomp.split(',').map(&:to_i)
      end
    end
    program
  end
end

intcode_computer = Intcode.new './input'
intcode_computer.run 1