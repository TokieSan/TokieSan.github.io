#!/bin/sh

read -p "File name: " file_name
read -p "URL alias: " url_alias
read -p "Summary: " summ

# Get title from the first line of the file
title=$(sed -n '1s/^#\s*//p' "${file_name}")

# Old way, decided to use less stuff but left it here cuz why not
#title=$(cat "${file_name}" | head -1 | cut -c 3-) 

# Get the post header from the "head" file
headerContent=$(cat blogposts/gsoc/head)

# Get the post abstract from the second line of the file
postTitle=$(cat ${file_name} | grep --line-number \#\# | grep 2 | cut -c 6-)

# Convert markdown content to HTML
htmlContent=$(md2html "${file_name}")

# Get the current date and time in the RFC 3339 format and regular format
postDate=$(date +"%a, %d %b. %Y - %r")
xmlDate=$(date --rfc-3339=seconds | sed 's/ /T/')

remNums=$(cat atom.xml | wc -l)
remNums2=$(cat atom-gsoc.xml | wc -l)

# Write the HTML file
{
    echo "<!DOCTYPE html>"
    echo "<html lang=\"en\">"
    echo "<head>"
    echo "<meta charset=\"UTF-8\">"
    echo "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">"
    echo "<title>${title}</title>"
    echo "${headerContent}"
    echo "</head>"
    echo "<body>"
    echo "${htmlContent}"
    echo "<br/><em style='color: #333333;'>Posted at ${postDate}</em><br/><br/>"
    echo "</body>"
    echo "</html>"
    cat "blogposts/gsoc/tail"
} > "blogposts/gsoc/${url_alias}.html"

# Add RSS entry

echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<feed xmlns=\"http://www.w3.org/2005/Atom\">
<title>Tokhy's hub</title>
<link href=\"https://tokiesan.github.io/atom.xml\" rel=\"self\"/>
<updated>"${xmlDate}"</updated>
<author>
<name>Ahmed Gamal Eltokhy</name>
</author>
<id>https://tokiesan.github.io</id>
""$(sed -n 10,$(echo ${remNums}-1 | bc)p atom.xml)" > atom.xml

echo "<entry>
<title>"${title}"</title><summary>"${summ}"</summary>""
<link href=\"https://tokiesan.github.io/blogposts/gsoc/${url_alias}.html\"/>
<updated>"${xmlDate}"</updated>
<id>https://tokiesan.github.io/blogposts/gsoc/${url_alias}.html</id>
</entry>
</feed>" >> atom.xml


echo "<?xml version=\"1.0\" encoding=\"utf-8\"?>
<feed xmlns=\"http://www.w3.org/2005/Atom\">
<title>Tokhy's hub</title>
<link href=\"https://tokiesan.github.io/atom-gsoc.xml\" rel=\"self\"/>
<updated>"${xmlDate}"</updated>
<author>
<name>Ahmed Gamal Eltokhy</name>
</author>
<id>https://tokiesan.github.io</id>
""$(sed -n 10,$(echo ${remNums2}-1 | bc)p atom-gsoc.xml)" > atom-gsoc.xml

echo "<entry>
<title>"${title}"</title><summary>"${summ}"</summary>""
<link href=\"https://tokiesan.github.io/blogposts/gsoc/${url_alias}.html\"/>
<updated>"${xmlDate}"</updated>
<id>https://tokiesan.github.io/blogposts/gsoc/${url_alias}.html</id>
</entry>
</feed>" >> atom-gsoc.xml




 #Add entry to blogposts/index.html
newElem="<tr>\n<td class=\"title\"><a href=\"${url_alias}.html\">${title}</a></td>\n<td><em>$(date +"%a, %d %b. %Y")</em></td>\n</tr>"

awk -v FOO1="${newElem}" '{
    sub(/<!---->/, "<!----> " FOO1);
    print;
}' blogposts/gsoc/index.html > temporary_output
cat temporary_output > blogposts/gsoc/index.html
rm -rf temporary_output 

mv ${file_name} junk/

# Add new post to repo
git add "blogposts/gsoc/${url_alias}.html" "atom-gsoc.xml" "blogposts/gsoc/index.html"
git commit -m "Added ${title} post"
git push -u origin
