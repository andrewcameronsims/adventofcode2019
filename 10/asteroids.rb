class AsteroidField
  attr_reader :candidates, :field

  def initialize filename
    @field = load_field filename
    @candidates = generate_stations
  end

  def generate_stations
    stations = []
    rows = @field.length
    cols = @field[0].length # assuming equal row lengths
    (1...rows).each do |row|
      (1...cols).each do |col|
        stations << Station.new(row, col) if asteroid? row, col
      end
    end
    stations
  end

  def asteroid? row, col
    @field[row][col] == "#"
  end

  def most_asteroids_detectable
    detectable = stations.map { |station| station.detect_asteroids }
    detectable.max
  end

  def load_field filename
    field = []
    File.open filename do |file|
      file.each do |line|
        field << line
      end
    end
    field
  end
end

class Station
  def initialize row, col
    @row = row
    @col = col
  end

  def detect_asteroids field
  end
end

af = AsteroidField.new './input'
puts af.field
puts af.candidates.length