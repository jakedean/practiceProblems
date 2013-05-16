=begin

This was my try at a web crawler that could crawl the hockey database site called hockeydb.com.
It turned out that the site did not allow me to crawl the amount of links I needed so they blocked
my IP, but I figured I would still put up what I learned.  

I used 4 threads and gathered links to each college hockey player over the past 10 years.  I was
going to take these player links and then scrape their page to see if they had played at least 50
NHL games.  If they had I was going to add them to a list, so I could see how many NHL players each
school had produced and what their career stats were.  My IP was blocked right as I gathered all of 
the unique player links.

=end


require 'net/http'

pages =   ["http://www.hockeydb.com/ihdb/stats/leagues/328.html",
	         "http://www.hockeydb.com/ihdb/stats/leagues/330.html",
	         "http://www.hockeydb.com/ihdb/stats/leagues/327.html",
	         "http://www.hockeydb.com/ihdb/stats/leagues/329.html"]

threads = []

for x in 0...pages.length
	threads << Thread.new(pages[x]) { |my_page|
		uri = URI(my_page)
		puts uri
		data = Net::HTTP.get(uri)
		puts data
    sliced_table = gather_links(data, /\>1999-00/, /\<\/tbody\>/, 0, 0)
    puts sliced_table
    league_year_links_array = []
	  while sliced_table.match(/\/ihdb/)
	  	gather_links(sliced_table, /\/ihdb/, /"/, 1, league_year_links_array)
	  end
	  teams_by_year = []
	  for y in 0...league_year_links_array.length
	  	uri = URI("http://www.hockeydb.com#{league_year_links_array[y]}")
      page_of_teams = Net::HTTP.get(uri)
      while page_of_teams.match(/teams\//)
        gather_links(page_of_teams, /teams\//, /"/, 1, teams_by_year)
      end
    end
    puts teams_by_year.to_s
    player_links = []
    for z in 0...teams_by_year.length
    	uri = URI("http://www.hockeydb.com/ihdb/stats/leagues/seasons/#{teams_by_year[z]}")
      roster_page = Net::HTTP.get(uri)
      puts roster_page
      sliced_roster = gather_links(roster_page, /\<tbody\>/, /\<\/tbody\>/, 0, 0)
      while sliced_roster.match(/\/ihdb/)
      	gather_links(sliced_roster, /\/ihdb/, /"/, 1, player_links)
      end
    end
      non_dup_player_links = player_links.uniq
      
		}
end


def gather_links (input, start, finish, item_or_array, links_array)
	start_point = input.index(start)
	finish_point = input.index(finish, start_point)
	sliced_item = input.slice!(start_point...finish_point)
	if item_or_array == 0
	  return sliced_item
	else
		links_array.push(sliced_item)
	end
end

	
threads.each { |aSingleThread| aSingleThread.join }
