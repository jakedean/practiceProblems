=begin

***Elevator Game***

***I realize this version is not realistic I just wanted to try it to learn.****

This is a more optimized version.  I tried to optimize it for the least number of stops not
nessesarily for the least distance between stops.  That is abviously not lifelike but it is useful
for the simulation.  ****It is not realistic in the fact that the elevator knows which floor the people 
want to go to (in reality an elivator only knows if people wan tto go up or down) but for a simulation it
taught me quite a bit.****

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
	attr_accessor :total_floors, :stops, :current_floor, :direction, :customers_inside, :customers_waiting

	def initialize(total_floors, customers)
		@current_floor = 0
		@floor_counter = 0
		@total_floors = total_floors
		@direction = 1
		@stops = 0
		@customers_inside = []
		@que = []
		@customers_waiting = customers
		check_destinatons
	end

#----------The Blocks-------------

	def get_off_block
		return lambda { |x| x.finish_floor == @current_floor }
	end

	def get_on_block
		return lambda { |x| x.start_floor == @current_floor }
	end

  def que_up_block
  	return lambda { |x| x.finish_floor == @floor_counter }
  end

#--------End of Blocks--------------

	def check_destinatons
    if @customers_waiting.index { |x| x.finish_floor == @floor_counter } != nil
    	puts @customers_waiting.to_s
    	@que.push(@customers_waiting.select { |x| x.finish_floor == @floor_counter })
    	@que.flatten!
	    @que.uniq! { |x| x.start_floor }
      @que.each { |x| go_to_floor(x.start_floor) }
      go_to_floor(@floor_counter)
      @que = []
      @floor_counter += 1
      check_destinatons
    elsif @floor_counter < @total_floors
    	@floor_counter += 1
    	check_destinatons
    elsif @customers_inside.length != 0
      deliver_straglers
      check_destinatons
    else
    	done
    end
  end

  def go_to_floor (finish_floor)
  	@current_floor = finish_floor
  	@customers_inside.delete_if(&get_off_block)
		@customers_inside.push(@customers_waiting.select(&get_on_block))
		@customers_inside.flatten!
		@customers_waiting.delete_if(&get_on_block)
		@stops += 1
		puts "Stoped at floor #{@current_floor} with #{@customers_inside.length} people in the elevator, #{@customers_waiting.length} waiting"
    
  end

	def deliver_straglers
		@customers_inside.sort! { |x,y| y.finish_floor <=> x.finish_floor }
		@customers_inside.each { |x| go_to_floor(x.finish_floor) }
	end

	def done 
		puts "The elevator simulation is done, it took #{stops} stops to complete!"
		return
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
		@start_floor = get_start_floor(num_floors)
		@finish_floor = get_finish_floor(num_floors)
		@@customers.push(self)
	end

	def get_start_floor (num_floors)
	  return rand(num_floors)
	end

	def get_finish_floor (num_floors)
	floor = rand(num_floors)
	  if floor == @start_floor
	  	get_finish_floor(num_floors)
	  else
	  	return floor
	  end
	end

	def self.all_customers
		@@customers
	end

end

#------------------------Other Functions----------------------------

def setup_the_building
	puts "Can I have the number of floors you would like in your building followed by the number of customers with a space separating the values?"
	response = gets.chomp.split(' ').map {|x| x.to_i}
	counter = 0
	response.each do |x|
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
	for x in 0...num_customers
		Customer.new(num_floors)
	end
end

building = setup_the_building
customers = setup_the_customers(building.num_floors, building.num_customers)
puts Customer.all_customers.to_s
elevator = Elevator.new(building.num_floors, Customer.all_customers)
