#!/bin/sh
read -p "Title: " title
postDate=$(date +"%d %b. %Y")
desc=$(sed ':a;N;$!ba;s/\n/<br>/g' ${1})
remNums=$(cat atom.xml | wc -l)
xmlDate=$(date --rfc-3339=seconds | sed 's/ /T/')
summ=$(cat ${1})
newElem="<div class=\"content\"><h2 style=\"font-size: 16px;\">${title} | <span style=\"color: gray;\">${postDate}</span></h2><p>${desc}</p></div>
"
awk -v FOO1="${newElem}" '{
    sub(/<!---->/, "<!----> " FOO1);
    print;
}' shorts.html>tmp
cat tmp>shorts.html
rm -rf tmp

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
<link href=\"https://tokiesan.github.io/shorts.html\"/>
<updated>"${xmlDate}"</updated>
<id>https://tokiesan.github.io/shorts.html</id>
</entry>
</feed>">>atom.xml

mv ${1} junk/
# git commit new post
git add "shorts.html"
git add "atom.xml"
git commit -m "Added ${title} to the shorts"
