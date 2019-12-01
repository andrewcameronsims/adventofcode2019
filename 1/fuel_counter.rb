class FuelCounter
  attr_reader :masses, :fuel

  def initialize masses
    @masses = masses
    @fuel = self.count
  end
  
  def count
    @masses.map { |mass| mass / 3 - 2 }.sum
  end
end

module_masses = []

File.open './input' do |file|
  file.each do |line|
    module_masses << line.chomp.to_i
  end
end

fc = FuelCounter.new(module_masses)
puts fc.count