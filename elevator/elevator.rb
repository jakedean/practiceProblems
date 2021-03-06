=begin

***Elevator Game***

This version just goes stright up and down, I made another version that I optimized to do the task
in fewer steps called elevator-optimized.rb.

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
		@total_floors = total_floors
		@direction = 1
		@stops = 0
		@customers_inside = []
		@customers_waiting = customers
		stop_or_not
	end

#----------The Blocks-------------

	def get_off_block
		return lambda { |x| x.finish_floor == @current_floor }
	end

	def get_on_block
		return lambda { |x| x.start_floor == @current_floor }
	end

	def on_elev_up_block
    return lambda { |x| x.finish_floor > @current_floor }
  end

  def waiting_elev_up_block 
  	return lambda { |x| x.start_floor > @current_floor }
  end

  def on_elev_down_block 
  	return lambda { |x| x.finish_floor < @current_floor }
  end
  
  def waiting_elev_down_block 
  	return lambda { |x| x.start_floor < @current_floor }
  end

#--------End of Blocks--------------

	def stop_or_not 
		if @customers_inside.index { |x| x.finish_floor == @current_floor } ||
      @customers_waiting.index { |x| x.start_floor == @current_floor }
				@customers_inside.delete_if(&get_off_block)
				@customers_inside.push(@customers_waiting.select(&get_on_block))
				@customers_inside.flatten!
				@customers_waiting.delete_if(&get_on_block)
				@stops += 1
				puts "Stoped at floor #{@current_floor} with #{@customers_inside.length} people in the elevator, #{@customers_waiting.length} waiting"
				move
		else
			move
		end
	end

	def move
		if @customers_inside.length == 0 && @customers_waiting.length == 0
      done 
		elsif @direction == 1
			higher_or_not
		else
			lower_or_not
		end
	end

	def done 
		puts "The elevator simulation is done, it took #{stops} stops to complete!"
		return
	end

#---------Continuing going eithor up or down?---------

  def higher_or_not
  	if @customers_inside.any? && @customers_inside.index(&on_elev_up_block) != nil || 
  		@customers_waiting.any? && @customers_waiting.index(&waiting_elev_up_block) != nil
  		  puts "Currently on #{@current_floor} we are going up!"
  		  go_up
  	elsif @customers_inside.length == 0 && @customers_waiting.length == 0
  		done
  	else
      @direction = 0
  		go_down
  	end
  end

  def lower_or_not 
  	if @customers_inside.any? && @customers_inside.index(&on_elev_down_block) != nil || 
  		@customers_waiting.any? && @customers_waiting.index(&waiting_elev_down_block) != nil
  		puts "Currently on #{@current_floor} we are going down!"
  		go_down
    elsif @customers_inside.length == 0 && @customers_waiting.length == 0
  		done
  	else
      @direction = 1
  		go_up
  	end
  end

#-----------The execution of moving the elevator---------
	def go_up
		@current_floor += 1
		stop_or_not
	end

	def go_down
	  @current_floor -= 1
		stop_or_not
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
