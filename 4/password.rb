require 'pry'

class PasswordCracker
  def initialize
    @range = 147981..691423
  end

  def find_passwords
    passwords = 0
    @range.each do |candidate|
      passwords += 1 if self.meets_criteria candidate
    end
    passwords
  end

  def meets_criteria candidate
    candidate = candidate.to_s.split('')
    return false unless self.never_decreases candidate
    return false unless candidate.length == 6
    return false unless self.two_adjacent_same candidate
    return false if two_plus_adjacent candidate 
    true
  end

  def two_adjacent_same candidate
    adjacent_count = 0
    candidate.each_with_index do |digit, i|
      next if i == 0
      previous = candidate[i - 1]
      if digit == previous
        adjacent_count += 1
      end
    end
    adjacent_count >= 1
  end

  def two_plus_adjacent candidate
    # binding.pry 
    adjacent_count = 0
    candidate.each_with_index do |digit, i|
      next if i == 0
      if digit == candidate[i - 1]
        adjacent_count += 1
        return true if adjacent_count > 1
      else
        adjacent_count = 0
      end
    end
  end

  def never_decreases candidate
    new_candidate = self.zeros_at_end candidate 
    new_candidate == candidate.sort
  end

  def zeros_at_end candidate
    new_candidate = []
    zeros = 0
    candidate.each do |digit|
      if digit == "0"
        zeros += 1
      end
      new_candidate << digit unless digit == "0"
    end
    zeros.times do |i|
    new_candidate << "0"
    end
    new_candidate 
  end
end

pc = PasswordCracker.new
p pc.find_passwords