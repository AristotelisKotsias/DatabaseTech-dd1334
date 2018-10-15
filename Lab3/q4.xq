(: Which actors have starred in the most movies?  :)

let $v_path := doc("videos.xml")/result/videos/video
let $a_path := doc("videos.xml")/result/actors/actor

let $max := max(
	for $ref in distinct-values($v_path/actorRef)
	return count($v_path/actorRef[. eq $ref])
)

for $ref in distinct-values($v_path/actorRef)
let $actor := $a_path[@id eq $ref]
let $count := count(($v_path/actorRef[. eq $ref]))
where $count = $max
return concat('actor="',$actor,'"')
