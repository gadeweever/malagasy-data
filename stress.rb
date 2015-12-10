require './syllable.rb'
# our file for
results = File.open("stress-results.txt", "w")

# We establish our empty ruleset
rules = []

# clash check
# this determines whether or not we should
# apply the clash rule
clash = false

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

# clash Check
# asks if we should establish clash checking
# Takes a word for method hash
def clashCheck(word)
  clash = true
end

# Clash Checking
# no two syllables next to each other should have stress
# if they return false
def boundaryCheck(syllable1, syllable2)
  return checkStress(syllable1) && checkStress(syllable2)
end

# safely checks the stress of a syllable
def checkStress(syllable)
  # this catches the first syllable
  if syllable == nil
    return true
  end

  # if the previous syllable had stress
  # then we shouldn't apply the rule
  if syllable.hasStress
    return false
  end

  # return true otherwise
  return true
end

rules << method(:firstPrimary)
rules << method(:noStressFinal)
rules << method(:secondaryOther)
rules << method(:clashCheck)
