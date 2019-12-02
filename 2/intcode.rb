class Intcode
  attr_reader :program

  def initialize program
    @program = chunk program
  end

  def chunk program
    chunked_program = []
    chunk = []
    program.each_with_index do |code, index|
      if index % 4 == 0 && code == 99
        chunked_program << [99]
        program.delete_at(index)
      elsif index % 4 == 0
        chunked_program << chunk
        chunk = []
        chunk << code
      else
        chunk << code
      end
    end
    chunked_program
  end

  def run
    @program.each do |chunk|
      case chunk[0]
      when 99
        return @program
      when 1
        opcode_one chunk
      when 2
        opcode_two chunk
      else
        throw "Invalid program"
      end
    end
  end

  def opcode_one chunk
    @program[chunk[3]] = chunk[1] + chunk[2]
  end

  def opcode_two chunk
    @program[chunk[3]] = chunk[1] * chunk[2]
  end
end

intcode_program = []

File.open './input' do |file|
  file.each do |line|
    intcode_program = line.chomp.split(',').map { |str| str.to_i }
  end
end

intcode = Intcode.new(intcode_program)
p intcode.program