# StressType:
# an enumaration system for a Syllable
module StressType
  NONE = 0
  PRIMARY = 1
  SECONDARY = 2
end

# A Syllable is a basic unit that
# holds stress
class Syllable
  attr_accessor :stress

  def initialize
    @stress = StressType::NONE
  end

  def hasStress
    @stress != StressType::NONE
end

# A word holds syllables
class Word
  attr_accessor :syllables

  # creates a word of a certain length
  def initialize(length)
    for i in 0..length
      @syllables << Syllable.new
    end
  end

  #resets a word's stress to null
  def removeStress
    @syllables.each do |syllable|
      syllable.stress = StressType::NONE
    end
  end
end

class WordSet
  attr_accessor :words

  def initialize(length)
    for i in 0..length
      @words << Word.new(i)
    end
  end
end
