=begin
****PALINDROMIC INTEGERS****
1. Prompt for two integers. These two integers constitute the range of integers 
(inclusive) of the integers that will be checked.
2. After the program runs, you will report the following statistics for the 
numbers examined in the given range:
a. The number of “natural” palindromes (numbers in the range that are already 
palindromes, such a 11, 121, 3553)
b. The number of non-Lychrel numbers (numbers which eventually yield a 
palindrome using the 196 algorithm)
c. The number of Lychrel numbers encountered. Assume a maximum of 60 
iterations to indicate a Lychrel number
d. Because Lychrel numbers are rare, report each Lychrel number as it occurs.	
=end

def promptUser
	puts "Can you give me two digits separated by a space?"
  two_numbers = gets.chomp
  if /^\d+\s\d+$/.match(two_numbers)
  	return two_numbers
  else
  	prompt
  end
end

def initialize_problem (numbers)
	  digits_array = numbers.split(' ')
	  first_number = digits_array[0].to_i
	  second_number = digits_array[1].to_i
	  return first_number, second_number
end

def get_range (first,second)
  my_array = []
	(first..second).each{|x| my_array.push(x)}
	return my_array
end

def get_natural_pals (range)
	natural_pals = []
	range.each do |x|
		str_x = x.to_s
	  half_length = ((str_x.length/2)-1)
			for y in 0..half_length
				if (str_x[y] != str_x[-(y+1)])
					break
				elsif (y < half_length)
					next
				else
					natural_pals.push(x)
			  end
			end
	end
	return natural_pals
end

def get_non_pals (range, natural_pals)
	return range.length - natural_pals.length
end

def splice_out_nat_pals (range, nat_pals)
	nat_pals.each do |x|
		range.delete(x)
	end
	return range
end

def is_pal (x)
	str_x = x.to_s
  half_length = ((str_x.length/2)-1)
		for y in 0..half_length
			if (str_x[y] != str_x[-(y+1)])
				return false
			elsif (y < half_length)
				next
			else
				return true
		  end
		end
end

def reverse_integer (integer)
	st_int = integer.to_s
	st_len = st_int.length
	reverse_str = ""
	for x in 1..st_len
		reverse_str.concat(st_int.slice(-x))
	end
	return reverse_str.to_i
end

def lychrel_or_not (number, counter)
	rev = reverse_integer(number)
	new_num = number + rev
	if is_pal(new_num)
    return true
	elsif counter < 60
		lychrel_or_not(new_num, counter + 1)
	else
		return false
	end
end

def get_all_lychrel (non_pals)
	lychrel = []
	non_lychrel = []
	non_pals.each do |x|
		value = lychrel_or_not(x, 0)
		if value == true
			lychrel.push(x)
		else 
			non_lychrel.push(x)
		end
	end
	return lychrel, non_lychrel
end

my_answer = {}
two_digits = promptUser
initialize_problem(two_digits)
first, second = initialize_problem(two_digits)
my_range = get_range(first, second)
nat_pals = get_natural_pals(my_range)
nat_non_pals = get_non_pals(my_range, nat_pals)
my_answer['The number of natural palindromes in the range'] = nat_pals.length
my_answer['The number of natural non palindromes in range'] = nat_non_pals
non_pal_numbers = splice_out_nat_pals(my_range, nat_pals)
my_answer['lychrels'], my_answer['non-Lychrel'] = get_all_lychrel(non_pal_numbers)
puts my_answer
