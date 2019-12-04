require 'pry'

class Wires
  def initialize 
    @wires = load_wires
  end

  def nearest_junction
    locations = get_locations
    junctions = get_junctions locations
    find_closest junctions
  end

  private
    def get_locations
      locations = []
      @wires.each do |wire|
        wire_locs = []
        wire.each_with_index do |mv, i|
          previous = i == 0 ? [0, 0] : wire_locs[i - 1]
          direction = mv[0]
          distance = mv[1..].to_i
          case direction
          when "U"
            wire_locs << [previous[0], previous[1] + distance]
          when "D"
            wire_locs << [previous[0], previous[1] - distance]
          when "L"
            wire_locs << [previous[0] - distance, previous[1]]
          when "R"
            wire_locs << [previous[0] + distance, previous[1]]
          else
            throw StandardError "unknown direction"
          end
        end
        wire_locs.unshift [0, 0]
        locations << wire_locs
      end
      locations
    end

    def get_junctions locations
      junctions = []
      wire_one = locations[0]
      wire_two = locations[1]
      wire_one.each_with_index do |loc, i|
        next if i == 0
        vec_one = [loc, wire_one[i - 1]]
        wire_two.each_with_index do |joc, j|
          next if i == 0
          vec_two = [joc, wire_two[j - 1]]
          junction = get_intersection vec_one, vec_two
          junctions << junction if junction
        end
      end
      junctions
    end

    def get_intersection vec_one, vec_two
      if vec_one[0][0] != vec_one[1][0] && vec_two[0][1] != vec_two[1][1]
        if (vec_one[0][0]..vec_one[1][0]).include? vec_two[0][0]
          return [vec_two[0][0], vec_one[0][1]]
        end
      end
      if vec_one[0][1] != vec_one[1][1] && vec_two[0][0] != vec_two[1][0]
        if (vec_one[0][1]..vec_one[1][1]).include? vec_two[0][1]
          return [vec_one[0][0], vec_two[0][1]]
        end
      end
      nil
    end

    def find_closest junctions
      distances = junctions.map do |junction|
        junction[0].abs + junction[1].abs
      end
      distances.min
    end

    def load_wires
      wires = []
      File.open './input' do |file|
        file.each do |line|
          wires << line.chomp
        end
      end
      wires.map { |wire| wire.split(',') }
    end
end

w = Wires.new
p w.nearest_junction