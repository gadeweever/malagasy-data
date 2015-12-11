require './syllable.rb'

maxlength = ARGV[0].chomp.to_i

# our file for
results = File.open("stress-results.txt", "w")

# We establish our empty ruleset
rules = []

# clash check
# this determines whether or not we should
# apply the clash rule
$clash = 0

# First Syllable Primary
def firstPrimary(word)
  current_stress =  word.syllables[0].stress
  word.syllables[0].stress = StressType::PRIMARY
  if $clash == 1 then
    if boundaryCheck(word.syllables[1], nil)
        word.syllables[0].stress = current_stress
    end
  end
  return word
end

# Stressing the Final syllable
# if we do not find stress in a word
# then we put primary stress on the final syllable
def noStressFinal(word)
  word.syllables.each do |syllable|
    # if we find stress, short circuit
    if syllable.hasStress
      return word
    end
  end

  if $clash == 1
    then if !boundaryCheck(word.syllables[word.syllables.count-1], nil)
  # we found no stress, so stress the last one
    return word
    end
  end
  word.syllables.last.stress = StressType::PRIMARY
  return word
end

# Secondary Stress
# every other syllable should have secondary stress
# this rule applies from left to right
def secondaryOther(word)
    puts word
  word.syllables.each_with_index do |syllable, index|

    #stress every other
    if index % 2 == 0 then
      current_stress = syllable.stress
        if !syllable.hasStress
          syllable.stress = StressType::SECONDARY
          if $clash == 1 then
            if !boundaryCheck(word.syllables[index-1], word.syllables[index+1])
              syllable.stress = current_stress
            end
          end
        end
      end
    end
    return word
end


# clash Check
# asks if we should establish clash checking
# Takes a word for method hash
def clashCheck(word)
  $clash = 1
  return word
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

# register each rule
rules << method(:firstPrimary)
rules << method(:noStressFinal)
rules << method(:secondaryOther)
rules << method(:clashCheck)


# we establish the permutations here so we
# can mix up all the rules. Super cool!
permutes = rules.permutation.to_a

# we want to generate our word sets now. this will store all
# of our word values
wordsets = []

# we generate the number of word sets per permutes
for i in 0..permutes.length
  # maxlength words, j amount of
  wordsets << WordSet.new(maxlength)
end

# ask for each permute
permutes.each_with_index do |permute, index|
  #puts "the value of this is: " << $clash.to_s
  #we keep trach of each permuation
  results.print index.to_s << ". "
  permute.each_with_index do |m, index|
    results.print m.name.to_s << " "
  end
    #puts "the value of this is: " << $clash.to_s
  results.puts ""
  # choose a word set that corresponds to what this
  # permute will do. Select all the words in this set
  wordsets[index].words.each do |word|

    # call each rule on the word
    permute.each do |rule|
      word = rule.call word
    end

    # reset clash for next word
    $clash = 0
  end
  wordsets[index].output(results)
end
