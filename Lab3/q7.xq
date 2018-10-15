(: Who have starred in the most distinct types of genre? :)

let $path := doc("videos.xml")/result/videos/video
let $a_path := doc("videos.xml")/result/actors/actor

let $actor := 
	for $actor_id in $a_path/@id
	order by count($path[actorRef = $actor_id]/genre) descending
	return distinct-values($a_path[@id = $actor_id])
return concat('actor="',$actor[1],'"')
