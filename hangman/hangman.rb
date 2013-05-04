=begin
***HANGMAN!***
1) Output a brief description of the game of hangman and how to play
2) Ask the user to enter the word or phrase that will be guessed 
(have a friend enter the phrase for you if you want to be surprised)
3) Output the appropriate number of dashes and spaces to represent 
the phrase (make sure it’s clear how many letters are in each word and
how many words there are)
4) Continuously read guesses of a letter from the user and fill in the 
corresponding blanks if the letter is in the word, otherwise report that
the user has made an incorrect guess.
5) Each turn you will display the phrase as dashes but with any already 
guessed letters filled in, as well as which letters have been incorrectly guessed so far and how many guesses 
the user has remaining.
6) Your program should allow the user to make a total of k=6 guesses.
7) You MUST use at least 3 string methods or operators in a useful manner
 (several examples that I used are given in the notes below).  If you wish
to use lists in your project that is fine, as long as you meet this 
requirement.
=end


def description
	puts 'Welcome to hangman, I will be using the normal rules.'
	puts 'You guess aletter if it is there I fill it in, if not it counts against you'
  puts 'You can get up to 6 wrong'
end

def prompt_for_input 
	puts 'Can you enter a word or phrase to start the game?'
	word = gets.chomp.downcase
	if /^(([a-z]+)|(([a-z]+\s)+[a-z]+))$/.match(word)
		puts "Ok that word works for us, let's play"
		return word
	else
		puts "Make sure it is only letters, no numbers or special characters please."
		prompt_for_word
	end
end

def underscore_word (word)
  secret_word = ''
  word_length = (word.length - 1)
  for x in 0..word_length
    if word[x] != " "
    	secret_word.concat('_')
    else
    	secret_word.concat(' ')
    end
  end
  return secret_word
end

def prompt_for_guess (word, secret_word, counter, index_array) 
	puts 'can you give me a letter to guess'
	guess = gets.chomp.downcase
  check_the_word(guess, word, secret_word, counter)
end

def get_next_index (guess, word, secret_word, counter, first_index, index_array)
	if word.index(guess, first_index + 1) != nil
		next_index = word.index(guess, first_index + 1)
		index_array.push(next_index)
		get_next_index(guess, word, secret_word, counter, next_index, index_array)
	else
		swap_letters(guess, word, secret_word, counter, index_array)
	end
end

def check_the_word (guess, word, secret_word, counter)
	index_array = []
	if word.index(guess) != nil
  	first_index = word.index(guess)
    index_array.push(first_index)
  	get_next_index(guess, word, secret_word, counter, first_index, index_array)
  else
  	counter += 1
  	puts "No there was no #{guess} in the word"
  	puts "#{secret_word}"
  	if counter <= 6 
  		prompt_for_guess(word, secret_word, counter, index_array)
  	else
  		puts 'Thanks for trying'
  		puts 'The phrase was #{word}'
  	end
  end
end

def swap_letters (guess, word, secret_word, counter, index_array)
	array_length = (index_array.length - 1)
  for x in 0..array_length
  	secret_word[index_array[x]] = guess
  end
  puts "#{secret_word}"
  next_move(guess, word, secret_word, counter, index_array)
end

def next_move (guess, word, secret_word, counter, index_array)
  if secret_word.index("_") && counter <= 6
  	prompt_for_guess(word, secret_word, counter, index_array)
  elsif secret_word.index("_") && counter > 6
  	puts 'Thanks for trying'
  	puts "The phrase was #{word}"
  else
  	puts "Congrats you got the word"
  	puts "It was #{word}"
  end
end


description
word = prompt_for_input
secret_word = underscore_word(word)
prompt_for_guess(word, secret_word, 0, [])
