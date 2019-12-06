class Intcode
  attr_reader :program

  def initialize program
    @program = load_program
    @pointer = 0
  end

  def run input
    until @program[@pointer] == 99
      case @program[@pointer]
      when 1
        opcode_one
      when 2
        opcode_two
      when 3
        opcode_three input
      when 4
        opcode_four
      else
        puts "Invalid intcode, halting"
        break
      end
      advance_pointer
    end
    @program
  end

  def advance_pointer
    case @program[@pointer]
    when 3, 4
      @pointer += 2
    else
      @pointer += 4
    end
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

  def opcode_three 
    @program[get_addr 1] = input
  end

  def opcode_four
    puts @program[get_addr 1]
  end

  def mode_zero
  end

  def mode_one
  end

  def load_program
    program = []
    File.open './input' do |file|
      file.each do |line|
        program = line.chomp.split(',').map { |str| str.to_i }
      end
    end
    program
  end
end