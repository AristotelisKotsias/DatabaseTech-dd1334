(: Which director have the highest sum of user ratings? :)

let $path := doc("videos.xml")/result/videos/video

let $best_director :=
	for $d in distinct-values($path/director)
	let $sum := sum(
		for $v in $path
		where $v/director = $d
		return $v/user_rating)
	order by $sum descending
	return $d
return $best_director[1]

