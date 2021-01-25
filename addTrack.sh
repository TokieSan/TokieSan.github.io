#!/bin/sh
read -p "Title: " title
read -p "Description: " desc
postDate=$(date +"%d %b. %Y")

newElem="<div class=\"content\"><h2 style=\"font-size: 16px;\">${title} | <span style=\"color: gray;\">${postDate}</span></h2><p>${desc}</p></div>
"
awk -v FOO1="${newElem}" '{
    sub(/<!----->/, FOO1 " <!----->");
    print;
}' track.html>tmp
cat tmp>track.html
rm -rf tmp

git add "track.html"
git commit -m "Added ${title} to the track"
