class Intcode
  attr_reader :program

  def initialize program
    @program = load_program
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