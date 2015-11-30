# encoding: UTF-8
# data structuring
wordbatch = File.open("newwords.txt", "r")
results = File.open("results.txt", "w")

# we suppose the morphological endings
# to be the following
endings = ["ana", "ina", "u", "a"]
rules = []

# morphology consonant final
# these endings are morphologically consonant final, but the language
# does not like consonant final words. We add an a suffix
# but only if the word would be consonant final after rule application
def constFinal(word, set)
  if set >= 27 && set <= 38
      return word[0..word.length-2]
  end
  return word
end


# Rule Countour 1
# If an u is followed by an u then
# then front it. In addition if there is a
# consonant at the word boundary, apply the rule also
# u-> i / u(C)+ _
def contour1(word)
  pattern = /uu/
  index = pattern =~ word
  # nothing to do
  if index == nil
    return word
  end
  contour = word[0..(index-1)] + "ui" + word[(index+2)..word.length]
  #puts contour
  return contour
end

# Rule Contour 2
# Relative to contour 1, this just allows for an optional consonant
# we say that the contour principle spans over a single consonant
# the pattern itself is not specified for consonants
# because the data does not have tripthongs
def contour2(word)
  pattern = /(u.u|ú.u)$/
  index = pattern =~ word
  # nothing to do
  if index == nil
      return word
  end
  contour = word[0..(index+1)] + "i"
  return contour
end

# Rule Vowel Fusion 1
# if two vowels are the same then we should
# favor the first over the second
# V_1V_2 -> V_1
def fusion(word)

  pattern = /(aa|uu|oo|ii)/
  #get the vowel that was fused
  index = pattern =~ word
  match = word.match(pattern)
  # nothing to do
  if match == nil
    return word
  end
  vowel = word.match(pattern)[0][0]
  fusion = word[0..(index-1)] + vowel + word[(index+2)..word.length]
end

rules << method(:contour1)
rules << method(:contour2)
# contour must be applied before fusion
# to feed the fusion rule
rules << method(:fusion)

setnumber = 0
while word = wordbatch.gets
  word = word.chomp
  word = word.force_encoding(Encoding::UTF_8)
  results.print word + "    "

  word = constFinal(word, setnumber)
  #puts setnumber.to_s + word
  endings.each do |ending|
    modword = word + ending

    #apply each rule
    rules.each do |rule|
      modword = rule.call modword
    end

    results.print modword + "    "
  end
  results.puts
  setnumber += 1
end
