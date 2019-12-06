class Intcode
  def initialize filename
    @program = load_program filename
    @pointer = 0
  end

  def run input
    until @program[@pointer] == 99
      modes = get_modes @program[@pointer]
      case @program[@pointer].digits[0] # last digit of opcode
      when 1
        opcode_one modes
      when 2
        opcode_two modes
      when 3
        opcode_three input
      when 4
        opcode_four modes
      else
        puts "Invalid opcode #{@program[@pointer]}, halting"
        break
      end
      advance_pointer
    end
    @program
  end

  def advance_pointer
    case @program[@pointer].digits[0]
    when 3, 4
      @pointer += 2
    else
      @pointer += 4
    end
  end

  def opcode_one modes
    params = get_params modes
    @program[get_addr 3] = params[0] + params[1]
  end

  def opcode_two modes
    params = get_params modes
    @program[get_addr 3] = params[0] * params[1]
  end

  def opcode_three input
    @program[get_addr 1] = input
  end

  def opcode_four modes
    case modes[0]
    when 0
      puts @program[get_addr 1]
    when 1
      puts @program[@pointer + 1]
    else
      "Invalid parameter mode, halting"
    end
  end

  def get_addr index
    @program[@pointer + index]
  end

  def get_params modes
    first = modes[0] == 0 ? @program[get_addr 1] : @program[@pointer + 1]
    second = modes[1] == 0 ? @program[get_addr 2] : @program[@pointer + 2]
    return [first, second]
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
        program = line.chomp.split(',').map { |str| str.to_i }
      end
    end
    program
  end
end

intcode_computer = Intcode.new './input'
intcode_computer.run 1