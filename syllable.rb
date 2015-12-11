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

  # just output a value for the syllable
  def to_s
    if @stress == StressType::NONE
      return "N"
    elsif @stress == StressType::PRIMARY
      return "P"
    else
      return "S"
    end
  end

end

# A word holds syllables
class Word
  attr_accessor :syllables

  # creates a word of a certain length
  def initialize(length)
    @syllables = []
    for i in 1..length
      @syllables << Syllable.new
    end
  end

  #resets a word's stress to null
  def removeStress
    @syllables.each do |syllable|
      syllable.stress = StressType::NONE
    end
  end

  # reads each syllable and returns its stress
  def to_s
    out = ""
    @syllables.reverse.each do |syllable|
      out << syllable.to_s << " "
    end
    return out.strip
  end

end


# WordSet: a list of words
class WordSet
  attr_accessor :words

  def initialize(length)
    @words = []
    for i in 1..length
      @words << Word.new(i)
    end
  end

  # takes in a file as input and writes each word in the wordset
  def output(file)
    # write each word to the file
    @words.each do |word|
      file.puts word
    end
    file.puts ""
  end

end
