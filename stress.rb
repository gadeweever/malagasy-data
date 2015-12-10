require './syllable.rb'
# our file for
results = File.open("stress-results.txt", "w")

# We establish our empty ruleset
rules = []

# First Syllable Primary
def firstPrimary(word)
  word.syllables[0].stress = StressType::PRIMARY
end

# Stressing the Final syllable
# if we do not find stress in a word
# then we put primary stress on the final syllable
def noStressFinal(word)
  word.syllables.each do |syllable|
    # if we fund stress, short circuit
    if syllable.hasStress
      return word
    end
  end

  # we found no stress, so stress the last one
  word.syllables.last.stress = StressType::PRIMARY
  return word
end

# Secondary Stress
# every other syllable should have secondary stress
# this rule applies from left to right
def secondaryOther(word)
  word.syllables.each_with_index do |syllable, index|
    #stress every other
    if index % 2 == 0 then
      syllable.stress = StressType::SECONDARY
    end
  end
end

# Clash Checking
