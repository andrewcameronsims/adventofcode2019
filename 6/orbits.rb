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
        oer = @orbits[oer]
        indirects += 1
      end
    end
    indirects
  end

  def get_distance from, to
    # trace paths from both locations to the COM
    from_path = trace_path from
    to_path = trace_path to
    # find the first location that exists in both paths
    intersections = from_path & to_path
    intersection = intersections.first
    # add the indices
    from_index = from_path.find_index(intersection)
    to_index = to_path.find_index(intersection)
    from_index + to_index
  end

  def trace_path location
    path = []
    until location == "COM"
      path << @orbits[location]
      location = @orbits[location]
    end
    path
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
p om.get_distance "YOU", "SAN"
