require 'pry'

class OrbitMap
  attr_reader :orbits

  def initialize filename
    @data = load_data filename
    @orbits = direct_orbits @data
  end

  def direct_orbits data
    orbits = {}
    data.each do |orbit|
      oed, oer = orbit.split(")")
      orbits[oer] = oed
    end
    orbits
  end

  def count_orbits
    indirects = 0
    @orbits.each do |oer, oed|
      while @orbits[oer]
        # binding.pry
        oer = @orbits[oer]
        indirects += 1
      end
    end
    indirects
  end

  def load_data filename
    data = []
    File.open filename do |file|
      file.each do |line|
        data << line.chomp
      end
    end
    data
  end
end

om = OrbitMap.new './input'
p om.count_orbits
