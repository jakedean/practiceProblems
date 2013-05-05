=begin
***************File Searcher******************************
Program Operation:
1. Prompt the user for a query to be examined
2. Remove stopwords from the query
3. For every file with the suffix .txt, do the following
  a. remove stopwords from the document
  b. look for an exact match (the exact non-stopword words in sequence) in the 
  document
  c. If no such sequence is found, report so for that document
  d. If the sequence if found, report the line in the document where it was found	
	
=end

def prompt_for_query 
	puts 'What would you like to search for?'
	query = gets.chomp.downcase.split(' ')
	return query
end

def create_stop_word_array
	stop_word_array = []
  File.open('stopwords.csv', 'r') do |f|
    while (line = f.gets)
    	stop_word_array.push(line.split(','))
    end
  end
  return stop_word_array.flatten!
end

def strip_punctuation (target)
  target_len = (target.length - 1)
  for x in 0..target_len
    target[x].gsub!(/(\.|\,|\;|\")/, '')
  end
  if target.kind_of?(String)
     return target
  else
    return target.join(' ')
  end
end

def remove_stop_words (query, stop_word_array)
  query_len = (query.length - 1)
  index_array = []
  for x in 0..query_len
    if stop_word_array.include?(query[x])
    	index_array.push(x)
    else
    	next
    end
  end
  index_len = (index_array.length - 1)
  index_len.downto(0) do |x|
    query.slice!(index_array[x].to_i)
  end
  return query
end 


def search_documents (stripped_query, stop_words)
	all_text_files = Dir.glob "*.txt"
  text_file_len = (all_text_files.length - 1)
  matches = []
  number_found = 0
  for x in 0..text_file_len
    File.open(all_text_files[x], 'r') do |f|
      line_counter = 1
      while (line = f.gets)
        no_stop = remove_stop_words(line.downcase.split(' '), stop_words)
        good_to_go = strip_punctuation(no_stop)
        line_counter += 1
        if /#{stripped_query}/.match(good_to_go)
          number_found += 1
          matches.push("Match # #{number_found}, File: #{all_text_files[x]}, Line: #{line_counter}")
        end
      end
    end
  end
  if matches.length != 0
    puts matches
  else
    puts "There were no matches for that search query, try again please"
    protocal
  end
end

def protocal
  query = prompt_for_query
  stop_words = create_stop_word_array
  sliced_query = remove_stop_words(query, stop_words)
  stripped_query = strip_punctuation(sliced_query)
  matches = search_documents(stripped_query, stop_words)
end

protocal
      