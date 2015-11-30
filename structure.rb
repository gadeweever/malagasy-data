# encoding: UTF-8
# data structuring
wordbatch = File.open("words.txt", "r")
words = File.open("newwords.txt", "w")

# match only the stem
pattern = /\d*\. \p{Word}+/
# match the word not the digit
wordpattern = /\p{Word}+/

while line = wordbatch.gets
  # force the encoding to be correct
  data = line.force_encoding(Encoding::UTF_8)

  #puts data
  matches = data.scan(pattern)
  # find each match on the line
  matches.each do |matche|
     #puts matche.scan(wordpattern).last

     # write the word to the file
     words.puts matche.scan(wordpattern).last
  end
end
