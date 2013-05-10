
=begin

*****Minesweeper*****

The minsesweeper will clear the entire area of blank cells that are adjecent
to a blank cell that is slected(up, down, left, right or any diagonal).  The 
basic implementation did not clear the entire area and rather just cleared 
in the directions up, down, left and right. This version will use recusion to
 clear the entire area.  Everything is the same except for the ripple functionality.

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
  		rippler_caller(row, column)
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
    if call_or_not == 1
      display_view(0)
      if is_game_over == true
        game_over
      else
        player_move
      end
    end
  end

#----------This is the new recursive rippler functionality!--------

   def rippler_loop
    return lambda do |x,y,z|
             if @master_view[x][y+z] == 0 && @player_view[x][y+z] == "H"
               @ripple_arr.push([x, (y+z)])
             end
            end
  end 

  def rippler_caller (row, column)
    @ripple_arr.push([row, column])
    recursive_rippler(row, column)
  end

  def return_from_rippler
    display_view(0)
    if is_game_over == true
      game_over
    else
      player_move
    end
  end

  def recursive_rippler(row, column)
    if @master_view[row][column + 1] == 0 &&
      @player_view[row][column + 1] == "H"
      @ripple_arr.push([row, (column + 1)])
    end
    if @master_view[row][column - 1] == 0 &&
      @player_view[row][column - 1] == "H"
      @ripple_arr.push([row, (column - 1)])
    end
    if @master_view[(row - 1)] != nil
      (-1..1).each { |a| rippler_loop.call((row - 1),column,a) }
    end
    if @master_view[(row + 1)] != nil
      (-1..1).each { |b| rippler_loop.call((row + 1),column,b) }
    end
    if @ripple_arr.length > 0
      for x in 0...@ripple_arr.length
        if @player_view[@ripple_arr[x][0]][@ripple_arr[x][1]] == "H"
          uncover(@ripple_arr[x][0], @ripple_arr[x][1], 0)
        end
      end
      last_one = @ripple_arr.slice!(@ripple_arr.length - 1)
      recursive_rippler(last_one[0], last_one[1])
    else
      @ripple_arr = []
      return_from_rippler
    end
  end

#----------------------------------------------------------

  def game_over 
  	puts ".... and here was the master board"
  	display_view(1)
  end

end

my_minesweeper = Minesweeper.new(10)
my_minesweeper.make_player_view
my_minesweeper.make_master_view
master_view, player_view = my_minesweeper.mine_creator
my_minesweeper.fill_in_master
my_minesweeper.display_view(0)
my_minesweeper.player_move
