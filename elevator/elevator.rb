=begin

***Elevator Game***

1. Create three classes: Building, Elevator, and Customer.
2. Equip the building with an elevator. Ask user to customize the number of floors and the 
number of customers.
3. Program should have error checking to make sure the user inputs are valid. For example, 
if a user gives non-integer inputs, notify the user that the inputs are incorrect and prompt
again.
4. Each customer starts from a random floor, and has a random destination floor.
5. Each customer will use the elevator only once, i.e., when a customer moves out of the 
elevator, he/she will never use it again.
6. When all customers have reached their destination floor, the simulation is finished.

=end

#------------------------My Elevator Class----------------------------

class Elevator
	attr_accessor :total_floors, :stops, :customers_in_elevator

	@@stops = 0

	@@customers_in_elevator = []

	def initialize(total_floors)
		@current_floor = 0
		@total_floors = total_floors
	end

	def go_up (number_to_move)
		if @current_floor + number_to_move < @total_floors
		  @current_floor += number_to_move
		  @@stops += 1
		else
			puts 'We can not move up that high'
		end
	end

	def go_down(number_to_move)
		if @current_floor - number_to_move > 0
			@current_floor += number_to_move
			@@stops += 1
		else
			puts 'We can not move past the bottom floor, please try again'
		end
	end

end

#------------------------My Building Class----------------------------

class Building

	attr_accessor :num_customers, :num_floors

	def initialize(num_floors, num_custs)
		@num_floors = num_floors
		@num_customers = num_custs
	end

end

#------------------------My Customer Class----------------------------

class Customer

  attr_accessor :customers, :start_floor, :finish_floor, :setup_the_customers

	@@customers = []

	def initialize(num_floors)
		@start_floor = give_random_floor(num_floors)
		@finish_floor = give_random_floor(num_floors)
		@@customers.push(self)
	end

	def give_random_floor (num_floors)
	  rand(num_floors)
	end

	def self.all_offspring
		@@customers
	end

	def get_off_elevator (customer, current_floor)
		@@customers.delete {|x| x.finish_floor == current_floor}
		return @@customers
	end

end

#------------------------Other Functions----------------------------

def setup_the_building
	puts "Can I have the number of floors you would like in your building followed by
	the number of customers with a space separating the values?"
	response = gets.chomp.split(' ').map {|x| x.to_i}
	counter = 0
	response.each do |x|
	puts x.class 
		if (1..100).include?(x) && /^\d+$/.match(x.to_s)
		  counter += 1
		else
		  next
		end
	end  
	if counter == 2
		num_floors = response[0]
		num_customers = response[1] 
	  my_building = Building.new(num_floors, num_customers)
	else
		puts 'Sorry that was not a format we can accept, please try again'
		prompt_for_setup
	end
end


def setup_the_customers (num_floors, num_customers)
	for x in 0..num_customers
		Customer.new(num_floors)
	end
	setup_the_elevator(num_floors)
end

def setup_the_elevator (num_floors)
  our_elevator = Elevator.new(num_floors)
  start_elevator(our_elevator)
end

def start_elevator (our_elevator)
  
end

building = setup_the_building
elevator = setup_the_elevator(building.num_floors)
customers = setup_the_customers(building.num_floors, building.num_customers)
#move_the_elevator(building.num_floors)




