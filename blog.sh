#!/bin/sh
title=$(cat ${1} | head -1 | cut -c 3-)
postDate=$(date +"%a, %b. %Y - %r")
xmlDate=$(date +"%Y-%M-%dT%T+2:00")
postHead=$(cat blogposts/head)
postAbstract=$(cat ${1} | grep --line-number \#\# | grep 2 | cut -c 6-)
htmlContent=$(md2html ${1})
remNums=$(cat atom.xml | wc -l)
echo "<!DOCTYPE html> <html lang="en"> <head> <meta charset="UTF-8"> <meta name="viewport" content="width=device-width, initial-scale=1.0"> <title>"${title}"</title>"${postHead} > "blogposts/${2}.html"
echo ${htmlContent} >> "blogposts/${2}.html"
echo "</br><em style='color: #333333;'>Posted at ${postDate}</em></br></br>">>"blogposts/${2}.html"
cat "blogposts/tail" >>  "blogposts/${2}.html"
#atom ress
echo "<feed>
<title>Tokhy's hub</title>
<link href=\"atom.xml\" rel=\"self\"/>
<updated>"${xmlDate}"</updated>
""$(sed -n 5,$(echo ${remNums}-1 | bc)p atom.xml)">atom.xml
echo "<entry>
<title>"${title}"</title><content type=\"html\">"${htmlContent}"</content>
<link href=\"blogposts/${2}.html\"/>
<id>tag:tokhy.com:posts/"${2}".html</id>
<published>"${xmlDate}"</published>
</entry>
</feed>">>atom.xml

# git add "blogposts/${2}.html" "atom.xml"
# git commit -m "Added ${title} post"
