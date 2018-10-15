(: Which movies have the genre “special”? :)

(: doc("videos.xml")/result/videos/video[genre = "special"]/title -> XPATH:)

let $path := doc("videos.xml")/result/videos/video
for $v in $path
where $v/genre = "special"
return $v/title