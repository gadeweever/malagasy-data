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
# does not like consonant final words. We add an 'a' suffix
# because the incoming data stem data is not the underlying form
# we are positing in our analysis. This, thus stem function is applied before
# any of the rules are applied.
def stemSet(word, set)
  if set >= 27 && set <= 38
      return word[0..word.length-2]
    elsif set >=37 && set <=43
      return word[0..-3] + "h"
    elsif set >=44 && set <= 46
      return word[0..-3] + "f"
    elsif set >=55 && set <= 57
      return word + "s"
    elsif set >=58 && set <= 63
      return word + "z"
    elsif set >=64 && set <= 67
      return word + "v"
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

# Rule Word Final Consonant Deletion
# if a word is consonant final s/v/z, delete it
# this is unfortunately inconsistent with the epenthetic 'a',
# and it begs the question, "why not an epenthetic 'a' on these stems?"
# However it does make sense in the context of the language not
# favoring consonant final words
# s/v/z -> null / _#
def constFinalDel(word)
  pattern = /(s|z|v)$/
  match = word.match(pattern)
  if match == nil
    return word
  end
  constFinal = word[0..-2]
end

# consonant Final Fricative Change
# in our analysis, we posit the preference for a non fricative consonant 'k'
# rather than an "h" or an "f"
# h/f -> k / _#
def constFinalFric(word)
  pattern = /(h|f)$/
  match = word.match(pattern)
  if match == nil
    return word
  end
  finalFric = word[0..-2] + "k"
end

# Epenthetic 'a'
# in the case that we have a word final consonant, we insert
# an 'a' to keep the language consistent
def epentheticA(word)
  pattern = /[^(a|i|u|o)]$/
  match = word.match(pattern)
  if match == nil
    return word
  end
  epiA = word + "a"
end

rules << method(:contour1)
rules << method(:contour2)
# contour must be applied before fusion
# to feed the fusion rule
rules << method(:fusion)
rules << method(:constFinalFric)
rules << method(:constFinalDel)
rules << method(:epiA)

setnumber = 0
while word = wordbatch.gets
  word = word.chomp
  word = word.force_encoding(Encoding::UTF_8)
  results.print word + "    "

  word = stemSet(word, setnumber)
  #puts word
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
