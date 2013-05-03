=begin
*************************************************

This could have been quite a bit easier if I had made an array that had
a place holder for each letter.  The first thing I would have done was put the 
special characters in their places, then scrambled the remaining letters then put
them in the remaining slots in the array. For example.....
for the word "can't,"
I would make an array [0,0,0,0,0]
Then I would put the special chars in their respective slots.......
[0,0,0,',0,,']
Then I would take the first and last letters and add them to the array to get
[c,0,0,',t,,']
Then I would scramble the 'a' and the 'n' and then put them in the remaining slots.

I think this would make for code that would be easier to maintain than the method 
that I used.

***************************************************

The code outline is:
1. Open a file for reading.
2. Read that file, a line at a time.
3. Use the string split method to extract a list of words, all
the words in a line
4. Process each word such that
  a. Each word maintains its first and last letter in the correct position
  b. For every word larger than three letters long, the middle letters
  (between the first and last letter) should be randomly scrambled (re-ordered).
  c. Capitalization and punctuation must be preserved.
5. Output the revised text file to a new file. Prompt the user for the new file name.
=end

def larger_than_three (state, line_index)
	if state['word'].length > 3 
	  has_punc(state, line_index)
	else 
	  state['new_line'].push(state['word'])
	  word_by_word(state, line_index)
	end
end


def has_punc (state, line_index)
	my_regex = state['my_regex']
  if my_regex.match(state['word'])
    get_index_of_punc(state, line_index)
  else
    no_punc_scrambler(state, line_index)
  end
end

def get_index_of_punc (state, line_index)
  my_regex = state['my_regex']
	state['first_index'] = state['word'].index(my_regex)
	first_index = state['first_index']
  state['spec_char_index'].push(first_index)
  state['spec_char'].push(state['word'][first_index])
  get_next_index(state, line_index)
end

def get_next_index (state, line_index)
	my_regex = state['my_regex']
	first_index = state['first_index']
	word = state['word']
	if state['word'].index(my_regex, first_index + 1) != nil
    next_index = state['word'].index(my_regex, first_index + 1)
    state['spec_char_index'].push(next_index)
    state['spec_char'].push(word[next_index])
    state['first_index'] = next_index
    get_next_index(state, line_index)
  else
  	punc_scrambler(state, line_index)
  end
end

def no_punc_scrambler (state, line_index)
	letters_array = []
	word_len = (state['word'].length - 1)
	word = state['word']
  for x in 1...word_len
    letters_array.push(word[x])
  end
  letters_array.shuffle!
  word.slice!(1...(word.length - 1))
  arr_len = (letters_array.length - 1)
  for y in 0..arr_len
  	word.insert(-2, letters_array[y])
  end
  state['new_line'].push(word)
  word_by_word(state, line_index) 
end

def punc_scrambler (state, line_index)
	word_len = (state['word'].length - 1)
	word = state['word']
	spec_char_index = state['spec_char_index']
	spec_char = state['spec_char']
	sc_len = (state['spec_char_index'].length - 1)
	letters_array = []
  sc_len.downto(0) do |x|
    word.slice!(spec_char_index[x])
  end
  for y in 1...(word.length - 1)
    letters_array.push(word[y])
  end
  letters_array.shuffle!
  word.slice!(1...(word.length - 1))
  arr_len = (letters_array.length - 1)
  for z in 0..arr_len
  	word.insert(-2, letters_array[z])
  end
  for i in 0..sc_len
  	if word[spec_char_index[i]]
      word.insert spec_char_index[i], spec_char[i]
    else
      word << spec_char[i]
    end
  end
  state['new_line'].push(word)
  word_by_word(state, line_index)
end

def word_by_word (state, line_index)
	if state['new_line'].length != 0 && state['new_line'].length != state['read_line'].length
		state['word_index'] += 1
		state['spec_char'] = []
		state['spec_char_index'] = []
		state['word'] = state['read_line'][state['word_index']]
    larger_than_three(state, line_index)
  elsif state['new_line'].length == 0
  	state['word_index'] += 1
		state['word'] = state['read_line'][state['word_index']]
    larger_than_three(state, line_index)
  else
  	state['new_line'] = state['new_line'].join(' ')
  	finished(state, line_index)
  end
end

def counter (state, line_index)
	word_by_word(state, line_index)
end

def init 
	state = {
		'read_line' => [],
		'new_line' => [],
		'word' => 0,
		'spec_char_index' => [],
		'spec_char' => [],
		'final_array' => [],
		'word_index' => -1,
		'first_index' => 0,
		'my_regex' => my_regex = /(([0-9]|\,|\.|\!|\@|\$|\%|\&|\*|\-|\\|\#|\(|\)|\_|\'|\"|\:|\;|\?)+)/
	}
	line_index = 0
	read_the_file(state, line_index)
end

#I still have to read a lot more about IO, this was my first try at it.

def read_the_file (state, line_index)
	File.open('reader.txt') do |file|
		line_counter = 0
		file.each_line do |line|
			if line_counter == line_index
	      state['read_line'] = line.chomp.split(' ') 
	      counter(state, line_index)
	    else
	      line_counter += 1
	    end  
		end
	end
end

def finished (state, line_index)
	File.open('writer.txt', 'a') do |f|
		f << state['new_line']
	end
  line_index += 1
  state = {
		'read_line' => [],
		'new_line' => [],
		'word' => 0,
		'spec_char_index' => [],
		'spec_char' => [],
		'final_array' => [],
		'word_index' => -1,
		'first_index' => 0,
		'my_regex' => my_regex = /(([0-9]+|\,|\.|\!|\@|\$|\%|\&|\*|\-|\\|\#|\(|\)|\_|\'|\"|\:|\;|\?)+)/
	}
  read_the_file(state, line_index)
end

init
