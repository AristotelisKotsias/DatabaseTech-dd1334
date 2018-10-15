(: Which movie should you recommend to a customer if they want to see a horror movie and do not have a laserdisk? :)

let $path := doc("videos.xml")/result/videos/video

let $suggested_movie := 
	for $movie in $path
	where $movie/genre = "horror" and not($movie/LaserDisk)
	order by $movie/user_rating descending
	return $movie/title
return $suggested_movie[1]