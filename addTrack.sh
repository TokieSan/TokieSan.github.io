#!/bin/sh
read -p "Title: " title
read -p "Description: " desc
postDate=$(date +"%a, %d %b. %Y")

newElem="<div class=\"content\"><h2>${title} | <span style=\"color: gray; font-size: 22px;font-weight: 200;\">${postDate}</span></h2><p>${desc}</p></div>
"
awk -v FOO1="${newElem}" '{
    sub(/<!----->/, FOO1 " <!----->");
    print;
}' track.html>tmp
cat tmp>track.html
rm -rf tmp

git add "track.html"
git commit -m "Added ${title} to the track"
