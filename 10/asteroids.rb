class AsteroidField
  def initialize filename
    @field = load_field filename
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
end

af = AsteroidField.new './input'