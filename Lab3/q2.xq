(: Which  director  has  directed  at  least  two  movies,  and  which  movies  has  he directed? :)

let $path := doc("videos.xml")/result/videos/video

for $dir in distinct-values($path/director)
let $movies_title := $path[director = $dir]/title 	
where count($path/director[. = $dir]) >= 2	
return <movie director = "{$dir}">{$movies_title}</movie>
