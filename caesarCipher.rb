=begin

Program Specifications
Your task is to write a program that can decrypt a message that has been encoded using a Caesar 
cipher.  Stated another way, you need to find the “shift” for the cipher.  Once you have the 
shift, you know the mapping so you can decrypt the message.

Your high level algorithm will be:
1. Read the cipher-text (explained below)
2. Get a count of each character in the entire cipher-text (ignore spaces)
3. Find the most common character
4. Find the shift from “E” to that most common character.
5. Check that the shift also works for the next most common.
6. Using the shift, decode each character of the cipher-text and print

=end

def read_cipher_text
	letter_collection = ""
	File.open('cipherText.txt', 'r') do |f|
		while (line = f.gets)
      letter_collection += line
    end
  end
  return letter_collection
end

def get_sorted_letter_hash (letter_collection)
	letter_len = (letter_collection.length - 1)
	letter_hash = {}
	for x in 0..(letter_len)
		if /\s/.match(letter_collection[x])
			next
		elsif letter_hash[letter_collection[x]] == nil
      letter_hash[letter_collection[x]] = 1
    else
    	letter_hash[letter_collection[x]] += 1
    end
  end
  sorted_array = letter_hash.sort_by {|key, value| value}
  sorted_array_len = (sorted_array.length - 1)
  sorted_hash = {}
  for y in 0..(sorted_array_len)
    sorted_hash[sorted_array[y][0]] = sorted_array[y][1]
  end
  return sorted_hash.keys[sorted_hash.length - 1]
end

def make_alpha_hash
  alpha_hash = {}
  counter = 1 
  ('a'..'z').each do |letter|
    alpha_hash[letter] = counter
    counter += 1
  end
  return alpha_hash
end

def find_offset (most_common, alpha_hash, letter_collection)
  puts most_common
  puts alpha_hash
  most_com_off = (alpha_hash[most_common] - alpha_hash['e']).abs
  make_offset_hash(most_com_off, alpha_hash, letter_collection)
end

def make_offset_hash (most_com_off, alpha_hash, letter_collection)
  new_alpha_hash = Hash[alpha_hash]
  new_alpha_hash.each {|k,v| new_alpha_hash[k] = v += 10}
  new_alpha_hash.each do |k,v|
    if new_alpha_hash[k] > 26
      new_alpha_hash[k] = v - 26
    end
  end
  inverted_alpha = new_alpha_hash.invert
  return inverted_alpha
end

def decipher (alpha_hash, inverted_alpha, letter_collection)
  puts 'alpha'
  puts alpha_hash
  puts inverted_alpha
  letter_col_len = (letter_collection.length - 1)
  first_arr = []
  for x in 0..letter_col_len
    if /\s/.match(letter_collection[x])
      first_arr.push(" ")
    else
      first_arr.push(alpha_hash[letter_collection[x]])
    end
  end
  first_arr_len = (first_arr.length - 1)
  final_str = ""
  for y in 0..first_arr_len
    if /\s/.match(first_arr[y].to_s)
      final_str += " "
    else
    final_str += inverted_alpha[first_arr[y]].to_s
    end
  end
  return final_str
end
    
letter_collection = read_cipher_text
most_common = get_sorted_letter_hash(letter_collection)
alpha_hash = make_alpha_hash
inverted_alpha = find_offset(most_common, alpha_hash, letter_collection)
puts 'down below'
puts alpha_hash
deciphered_text = decipher(alpha_hash, inverted_alpha, letter_collection)
puts deciphered_text
