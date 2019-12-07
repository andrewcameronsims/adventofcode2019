require 'pry'

class Wires
  def initialize filename
    @wires = load_wires filename
    @paths = get_paths @wires
    @intersections = find_intersections @paths
  end

  def get_paths wires
    paths = []
    wires.each do |wire|
      paths << trace_path wire
    end
    paths
  end

  def trace_path wire
    x, y = 0, 0
    path = Set.new
    wire.each do |instruction|
      direction = instruction[0]
      distance = instruction[1..].to_i
      distance.times do
        case direction
        when "U"
          y++
        when "R"
          x++
        when "D"
          y--
        when "L"
          x--
        else
          puts "Bad instruction"
          abort
        end
      end
      path.add [x, y]
    end
    path
  end

  def find_intersections paths
    path_one, path_two = paths
    path_one & path_two
  end

  def closest_intersection
    intersections.map do |is|
      is[0].abs + is[1].abs
    end.min
  end

  def load_wires filename
    wires = []
    File.open filename do |file|
      file.each do |line|
        wires << line.chomp
      end
    end
    wires.map { |wire| wire.split(',') }
  end
end

w = Wires.new './input'
p w.closest_intersection