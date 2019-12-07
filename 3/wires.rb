class Wires
  def initialize filename
    @wires = load_wires filename
    @paths = get_paths @wires
    @intersections = find_intersections @paths
  end

  def get_paths wires
    paths = []
    wires.each do |wire|
      path = trace_path wire
      paths << path
    end
    paths
  end

  def trace_path wire
    x, y = 0, 0
    path = []
    wire.each do |instruction|
      direction = instruction[0]
      distance = instruction[1..].to_i
      distance.times do
        case direction
        when "U"
          y += 1
        when "R"
          x += 1
        when "D"
          y -= 1
        when "L"
          x -= 1
        else
          puts "Bad instruction"
          abort
        end
        path << [x, y]
      end
    end
    path
  end

  def find_intersections paths
    path_one, path_two = paths
    path_one & path_two
  end

  def closest_intersection
    @intersections.map do |is|
      is[0].abs + is[1].abs
    end.min
  end

  def fewest_steps
    @intersections.map do |is|
      count_steps is
    end.min
  end

  def count_steps coords
    indices = []
    @paths.each do |path|
      index = path.find_index coords
      indices << index + 1
    end
    indices.sum
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
p w.fewest_steps