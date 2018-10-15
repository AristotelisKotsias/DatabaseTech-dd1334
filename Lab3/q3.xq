(: Which are the top ten recommended movies?  :)

let $path := doc("videos.xml")/result/videos/video

let $top_movies := 
	for $v in $path
	order by $v/user_rating descending
	return $v/title
return fn:subsequence($top_movies, 1, 10)