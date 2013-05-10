=begin

*****Minesweeper*****

This is a simple implemetation of minesweeper.  You are able to sleect the size of 
your game board.  It is text based, the board will start out with an "H" in each spot
and as the player plays numbers will be uncovered and if mines are hit the game will 
be over and the board will be showed.

=end



class Minesweeper

  attr_accessor :size, :mines, :player_view, :master_view, :make_player_view, 
  :make_master_view, :mine_creator, :both_views, :display_view, :player_move
  
  def initialize(size)
  	@size = size
  	@mines = size
  	@both_views = []
  	@counter = 0
  	@ripple_arr = []
  	@neg_ripple_counter = -1
  	@pos_ripple_counter = 1
  end

  def make_player_view
    @player_view = {}
    for x in 1..@size
    	each_row = {}
    	for y in 1..@size 
    	  each_row[y] = "H"
    	end
    	@player_view[x] = each_row
    end
    @both_views.push(@player_view)
  end
 
  def make_master_view
    @master_view = {}
    for x in 1..@size
    	each_row = {}
    	for y in 1..@size
    		each_row[y] = 0
     	end
     	@master_view[x] = each_row
    end
    @both_views.push(@master_view)
  end

  def mine_creator
  	for x in 1..@mines
      row = Random.new.rand(1..@size)
      column = Random.new.rand(1..@size)
      @master_view[row][column] = "M"
  	end
  	return @master_view
  end

  def display_view (index)
  	full_array = []
    for x in 1..@size
    	line_arr = []
    	for y in 1..@size
    		if y < @size
    	    line_arr.push(@both_views[index][x][y])
    	  else
    	  	line_arr.push(@both_views[index][x][y])
    	  	full_array.push(line_arr)
    	  end
    	end
    end
    full_array.each { |x| p x.join(' ') }
  end

  def looper
  	return lambda do |x,y,z|
             if @master_view[x][y+z] == "M"
             	 @counter += 1
             end
            end
  end

  def fill_in_master
  	for x in 1..@size
  		for y in 1..@size
  			if @master_view[x][y] != "M"
  				@counter = 0
					if @master_view[x][y+1] == "M"
						@counter += 1
					end
					if @master_view[x][y-1] == "M"
						@counter += 1
					end
					if @master_view[x-1] != nil
						(-1..1).each { |a| looper.call((x-1),y,a) }
					end
          if @master_view[x+1] != nil
          	(-1..1).each { |b| looper.call((x+1),y,b) }
          end
           @master_view[x][y] = @counter
           @counter = 0	
		    end
		  end
		end
		return @master_view
  end

  def player_move
    row = validate_row 
  	column = validate_column
  	if @master_view[row][column] == "M"
      uncover(row, column, 0)
      puts "Oh no you have hit a mine, here is your board"
      display_view(0)
  		game_over
  	elsif @master_view[row][column] != 0
  		uncover(row, column, 1)
  	else
  		ripple(row, column)
  	end
  end

  def validate_column
  	puts "Can you give me the number of a column you would like to explore from 1 to #{@size}"
  	column = gets.chomp.to_i
  	if column.is_a?(Integer) && (1..@size).include?(column)
  		return column
  	else
  		puts "Not going to work, let's try again"
  		validate_column
  	end
  end

  def validate_row
  	puts "Can you give me a number of the row you would like to explore from 1 to #{@size}"
  	row = gets.chomp.to_i
  	if row.is_a?(Integer) && (1..@size).include?(row)
  		return row
  	else
  		validate_row
  	end
  end

  def is_game_over
    for x in 1..@size
      for y in 1..@size
        return
        if @player_view[x][y] == "H"
          next
        else
          return true
        end
      end
      if x == @size 
        return false
      else
        next
      end
    end
  end

  def uncover (row, column, call_or_not)
    holder = @master_view[row][column]
    @player_view[row][column] = holder
    puts 'call or not'
    puts call_or_not
    if call_or_not == 1
      display_view(0)
      if is_game_over == true
        game_over
      else
        player_move
      end
    end
  end

  def ripple_checker (row, column)
    puts 'in the ripple checker'
    if @master_view[row] == nil
      return false
    elsif @master_view[row][column] == nil
      return false 
		elsif @master_view[row][column] == 0
      return true
    else
      return false
    end  
  end

  def ripple_adder (row, column)
    @ripple_arr.push([row,column])
  end

  def ripple (row, column)
    @ripple_arr = []
    @ripple_arr.push([row, column])
    if @master_view[(row + @neg_ripple_counter)] != nil &&
      @master_view[(row + @neg_ripple_counter)][column] == 0
      puts 'in the first one'
    	until ripple_checker((row + @neg_ripple_counter), column) == false do
    		puts 'got here 1'
        ripple_adder((row + @neg_ripple_counter), column)
        @neg_ripple_counter -= 1
      end
      @neg_ripple_counter = -1
    end
    if @master_view[(row + @pos_ripple_counter)] != nil &&
      @master_view[(row + @pos_ripple_counter)][column] == 0
        puts 'in the second one' 
      until ripple_checker((row + @pos_ripple_counter), column) == false do
        puts 'got here2'
    		ripple_adder((row + @pos_ripple_counter), column)
        @pos_ripple_counter += 1
      end
      @pos_ripple_counter = 1
    end
    if @master_view[row] != nil &&
      @master_view[row][(column + @neg_ripple_counter)] == 0
      puts 'in the hthird one'
    	until ripple_checker(row, (column + @neg_ripple_counter)) == false do
    		puts 'got here 3'
        ripple_adder(row, (column + @neg_ripple_counter))
        @neg_ripple_counter -= 1
      end
      @neg_ripple_counter = -1
    end
    if @master_view[row] != nil && 
      @master_view[row][(column + @pos_ripple_counter)] == 0
      puts 'in the forth one'
    	until ripple_checker(row, (column + @pos_ripple_counter)) == false do
    		puts 'got here 4'
        ripple_adder(row, (column + @pos_ripple_counter))
        @pos_ripple_counter += 1
      end
      @pos_ripple_counter = 1
    end
    for x in 0...@ripple_arr.length
      puts @ripple_arr.to_s
    	if x < (@ripple_arr.length - 1)
    		uncover(@ripple_arr[x][0], @ripple_arr[x][1], 0)
    	else
    		uncover(@ripple_arr[x][0], @ripple_arr[x][1], 1)
    	end
    end
  end

  def game_over 
  	puts ".... and here was the master board"
  	display_view(1)
  end

end

my_minesweeper = Minesweeper.new(10)
my_minesweeper.make_player_view
my_minesweeper.make_master_view
master_view, player_view = my_minesweeper.mine_creator
my_minesweeper.display_view(0)
my_minesweeper.fill_in_master
my_minesweeper.display_view(1)
my_minesweeper.player_move
