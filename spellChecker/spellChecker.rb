=begin

*****************SpellChecker************************

The spell checking tool will perform three tasks:
1- Spot the misspelled words in a file by checking each word in the file against a provided 
dictionary. 
2- Provide the user with a list of alternative words to replace any misspelled word.  
3- Write a new file with the corrected words as selected by the user

1. Prompt the user for the name of the file to spell check. The program will spell check each 
word and then write a new file with the name of the original file plus the text “-chk”. 
Thus if the file being checked is “file.txt”, the spell checked output will be “file-chk.txt”. 
Note that the file suffix is preserved!
3. Create a function that will read the reference list words from a file and save them in an 
appropriate data structure.
4. Create a function that checks a word of the user file against a word from the reference list. 
The rules mentioned above are to be implemented in this function. This function either 
returns False, meaning that the word was in the reference list, a list of candidate 
replacements or an empty list if it could not find a candidate.
5. If the word does not exist in the reference list, print a list of all candidate words for the 
user with an index for each candidate. If the user enters the index of a candidate word, the 
original word is replaced in the output file with the candidate. If the user enters a -1, then 
the word is not replaced. If the user enters -2, then the user will type in a replacement and 
that replacement will be used in the new output file. 
6. You must provide error checking for the user if they enter an improper index (bigger than 
the list of candidates, smaller than -2).
7. Output the updated spell-checked file.

=end


def prompt_for_file
	puts 'Which text file would you like to spell check?'
	file = gets.chomp.downcase
	all_text_files = Dir.glob "*.txt"
	if all_text_files.include? "#{file}"
		puts 'ok awesome, I will spell check that file for you'
	else
		puts "I can not find that file in this working directory, let's try again."
		prompt_for_file
  end
end

def strip_punc (line)
  line.gsub!(/\.|\,|\"|\;|\:/, '')
	return line
end

def read_desired_file (dictionary_array)
	final_array = []
	File.open('sample.txt', 'r') do |f|
		while (line = f.gets)
			line_array = []
			stripped_line = strip_punc(line)
			separated_line = stripped_line.split(' ')
			sep_line_len = (separated_line.length - 1)
			for x in 0..sep_line_len
				if /\'/.match(separated_line[x])
					next
	      elsif dictionary_array.index(separated_line[x].downcase) != nil
	        line_array.push(separated_line[x])
	      else
	        choices = get_choices(dictionary_array, separated_line[x])
	        new_word = user_want_to_change(separated_line, separated_line[x], choices)
	        line_array.push(new_word)
	      end
	    end
	    final_array.push(line_array.join(' ') + "\n")
	  end 
  end
  put_data_in_string(final_array)
end

def put_data_in_string (final_array)
	final_arr_len = (final_array.length - 1)
	final_str = ""
	for x in 0..final_arr_len
		final_str.concat(final_array[x])
	end
	write_desired_file(final_str)
end


def write_desired_file (final_str)
	File.open("sample-chk.txt", "w") do |f|
		f.write(final_str)
	end
end

def get_choices (dictionary_array, word)
	word_len_min = (word.length - 1)
	word_len = word.length
	choices = {}
	first_letter_array = []
	length_array = []
	enough_common_array = []
	choice_counter = 0
	dic_len = (dictionary_array.length - 1)
  for x in 0..dic_len
  	counter = 0
  	if first_letter(dictionary_array[x], word) == false
  		next
    else
    	first_letter_array.push(dictionary_array[x])
  	end
  end
  first_letter_arr_len = (first_letter_array.length - 1) 
  for y in 0..first_letter_arr_len
  	if test_length(first_letter_array[y], word_len) == false
  		next
    else
      length_array.push(first_letter_array[y])
  	end
  end
  length_arr_len = (length_array.length - 1)
  for z in 0..length_arr_len
    if enough_common_letters(length_array[z], word) == false
    	next
    else
    	choice_counter += 1
      choices["#{choice_counter}"] = length_array[z]
    end
  end
  return choices
end

def test_length (dictionary_word, word_len)
	if (dictionary_word.length < (word_len - 1)) || (dictionary_word.length > (word_len + 1))
	  return false
	else 
		return true
	end
end

def first_letter (dictionary_word, word)
	if dictionary_word[0] == word[0]
		return true
	else
		return false
	end
end

def enough_common_letters (dictionary_word, word)
	counter = 0
	dictionary_word_copy = dictionary_word.clone
	word_len = (word.length - 1)
  for x in 0..(word_len)
  	if dictionary_word_copy.include?(word[x])
  		dictionary_word_copy.slice!(word[x])
  	  counter += 1
  	else
  		next
  	end
  end
  if counter < (4.to_f/5.to_f)*(word.length)
    return false
  else
  	return true
  end
end


def user_want_to_change (line, word, choices)
	puts "it looks like the word => '#{word}' was misspelled on the folllowing line"
	puts line.join(' ')
	puts "Here are the choices you have to switch the word to"
  puts choices
  puts "You can select one of these choices by typing in the corresponding number or you can type 
  -1 to leave it unchanged and last you can type a -2 to give a new spelling"
  response = gets.chomp
  if response.kind_of?(Integer)
  	response = response.to_s
  end
  if choices.has_key?("#{response}")
    edit = choices[response]
  elsif response == '-1'
    edit = word
  elsif response == '-2'
  	puts 'Print the spelling you would like to use below please.'
  	edit = gets.chomp
  else
  	user_want_to_change(line, word, choices)
  end
  return edit
end
   	 

def read_dictionary_into_array
	File.open('dictionary.txt', 'r') do |f|
		word_array = []
		while (line = f.gets)
			word_array.push(line.chomp)
		end
		return word_array
	end
end


dictionary_array = read_dictionary_into_array
final_array = read_desired_file(dictionary_array)
puts final_array
