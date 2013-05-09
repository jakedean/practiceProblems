=begin

**********Markov Chain**********

This is a very basic Markov chain script. If it completes it will write to a file, and
if it does not get all the way through it will output the partial string to the console.
It could be made better if I looked back in the sequence farther than 2 words, but this
was my first crack at it.   

=end

def prompt_for_file
  puts "Can I have the name of a file in your CWD to perform the Markov Chain on?"
  read_file = gets.chomp.downcase
  all_text_files = Dir.glob "*.txt"
  if all_text_files.include? read_file
  	prompt_for_write_file(read_file)
  else
  	puts "Nope, that is not going to work for us, try again please."
  	prompt_for_file
  end
end

def prompt_for_write_file (read_file)
  puts "Ok we can work with is file, can I have a name for a file to write to with
  	no spaces?"
	write_file = gets.chomp.downcase
	if write_file !~ /\s|\./
		 write_file = write_file + '.txt'
		 puts write_file
		 read_and_put_in_table(read_file, write_file)
	else
		prompt_for_write_file (read_file)
	end
end

def read_and_put_in_table (read_file, write_file)
	file_string = ""
  File.open("#{read_file}", 'r') do |file|
  	while line = file.gets
      file_string += line
    end
  end
  split_string = file_string.split(' ')
  puts "the origional file was #{split_string.length} words long"
  markov_chain = {}
  for x in 0...split_string.length
  	if split_string[x + 2] != nil && markov_chain["#{split_string[x]} #{split_string[x+1]}"] == nil
      markov_chain["#{split_string[x]} #{split_string[x+1]}"] = [split_string[x+2]]
    elsif split_string[x + 2] == nil
    	break
    elsif markov_chain["#{split_string[x]} #{split_string[x+1]}"] != nil && 
    	markov_chain["#{split_string[x]} #{split_string[x+1]}"] != [split_string[x+2]]
    	markov_chain["#{split_string[x]} #{split_string[x+1]}"].push([split_string[x+2]]).flatten!
    else
    	next
    end
  end
  write_new_file(markov_chain, split_string, write_file)
end

def write_new_file (markov_chain, split_string, write_file)
	final_string_arr = []
	final_string_arr.push(split_string.first(2))
	for x in 2...split_string.length
    key = final_string_arr.last(2).join(' ')
    if markov_chain.has_key?(key)
    	final_string_arr.push(markov_chain[key].shuffle[0])
    	final_string_arr.flatten!
    else
    	shuffled_split_string = split_string.clone.shuffle
    	shuffled_len = shuffled_split_string.length
      for y in 0...shuffled_len
      	new_x = shuffled_split_string[y]
      	new_key = "#{final_string_arr[x-2]} #{new_x}"
      	if markov_chain.has_key?(new_key)
    	    final_string_arr.push(markov_chain[new_key].shuffle[0])
    	    break
    	  elsif y < shuffled_len
    	  	next
    	  else
    	  	partial_string = final_string_arr.join(' ')
    	  	could_not_finish(partial_string)
    	  end
    	next
      end
    end
  end
  puts "The final file was #{final_string_arr.length} words long"
  full_string = final_string_arr.join(' ')
  success(full_string, write_file)
end

def could_not_finish(partial_string)
	puts "A match could not be found!  Our dictionary is quite small, sorry."
	puts "However this is the string we constructed so far...."
	puts partial_string
end


def success(final_string, write_file)
	puts 'publishing this'
  File.open("#{write_file}", 'w') do |file|
  	file.write(final_string)
  end
end


prompt_for_file
