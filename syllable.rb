# StressType:
# an enumaration system for a Syllable
module StressType
  NONE = 0
  PRIMARY = 1
  SECONDARY = 2
end

class Syllable
  attr_accessor :stress

  def initialize
    @stress = NONE
  end

  def hasStress
    @stress != StressType::NONE
end


class Word
  attr_access :syllables

  #resets a word's stress to null
  def removeStress
    @syllables.each do |syllable|
      syllable.stress = StressType::NONE
    end
  end
end
