#!/bin/sh
read -p "Title: " title
read -p "Description: " desc
postDate=$(date +"%d %b. %Y")

newElem="<div class=\"content\"><h2 style=\"font-size: 16px;\">${title} | <span style=\"color: gray;\">${postDate}</span></h2><p>${desc}</p></div>
"
awk -v FOO1="${newElem}" '{
    sub(/<!----->/, FOO1 " <!----->");
    print;
}' wishlist.html>tmp
cat tmp>wishlist.html
rm -rf tmp

# git commit new post
git add "wishlist.html"
git commit -m "Added ${title} to the wishlist"
