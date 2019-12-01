require 'pry'

class FuelCounter
  attr_reader :fuel

  def initialize modules
    @modules = modules
    @fuel = self.count
  end
  
  def count
    @fuel = @modules.map { |module_mass| calculate_module module_mass }.sum
  end

  def calculate_module module_mass
    total = 0
    until module_mass < 1
      module_mass = mass_to_fuel module_mass
      total += module_mass if module_mass > 0
    end
    total
  end

  def mass_to_fuel mass
    mass / 3 - 2
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