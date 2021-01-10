#!/bin/sh
title=$(cat ${1} | head -1 | cut -c 3-)
postDate=$(date +"%a, %d %b. %Y - %r")
xmlDate=$(date --rfc-3339=seconds | sed 's/ /T/')
postHead=$(cat blogposts/head)
postAbstract=$(cat ${1} | grep --line-number \#\# | grep 2 | cut -c 6-)
htmlContent=$(md2html ${1})
remNums=$(cat atom.xml | wc -l)
echo "<!DOCTYPE html> <html lang="en"> <head> <meta charset="UTF-8"> <meta name="viewport" content="width=device-width, initial-scale=1.0"> <title>"${title}"</title>"${postHead} > "blogposts/${2}.html"
echo ${htmlContent} >> "blogposts/${2}.html"
echo "</br><em style='color: #333333;'>Posted at ${postDate}</em></br></br>">>"blogposts/${2}.html"
cat "blogposts/tail" >>  "blogposts/${2}.html"

#atom ress

read -p "Summary: " summ
echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<feed xmlns=\"http://www.w3.org/2005/Atom\">
<title>Tokhy's hub</title>
<link href=\"https://tokiesan.github.io/atom.xml\" rel=\"self\"/>
<updated>"${xmlDate}"</updated>
<author>
	<name>Ahmed Gamal Eltokhy</name>
</author>
<id>https://tokiesan.github.io</id>
""$(sed -n 10,$(echo ${remNums}-1 | bc)p atom.xml)">atom.xml
echo "<entry>
<title>"${title}"</title><summary>"${summ}"</summary>""
<link href=\"https://tokiesan.github.io/blogposts/${2}.html\"/>
<updated>"${xmlDate}"</updated>
<id>https://tokiesan.github.io/blogposts/${2}.html</id>
</entry>
</feed>">>atom.xml

#add to main page
newElem="
<tr>
     <td class=\"title\"><a href=\"${2}.html\">${title}</a></td>
	 <td><em>$(date +"%a, %d %b. %Y")</em></td>
</tr>
"

awk -v FOO1="${newElem}" '{
    sub(/<!---->/, "<!----> " FOO1);
    print;
}' blogposts/main.html>tmp
cat tmp>blogposts/main.html
rm -rf tmp

mv ${1} junk/
# git commit new post
git add "blogposts/${2}.html" "atom.xml"
git commit -m "Added ${title} post"
