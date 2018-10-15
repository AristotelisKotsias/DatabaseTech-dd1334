(: Which actors have starred in a PG-13 movie between 1997 and 2006 (including 1997 and 2006)? :)

let $path := doc("videos.xml")/result/videos/video
let $a_path := doc("videos.xml")/result/actors

let $actors_ref := 
	for $v in $path
	where $v/year >= 1997 and $v/year <= 2006 and $v/rating = "PG-13"
	return $v/actorRef

let $actors := distinct-values(
	for $a in $actors_ref
	return $a_path/actor[@id = $a])
return $actors