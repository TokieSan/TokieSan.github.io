#!/bin/sh

# List available blog posts
echo "Available blog posts:"
ls blogposts/*.html | sed 's/blogposts\///;s/\.html//' | nl

# Get post to edit
read -p "Enter the number of the post you want to edit: " post_number
post_file=$(ls blogposts/*.html | sed -n "${post_number}p")
post_name=$(basename -s .html "${post_file}")

# Extract content between <body> and </body> tags
body_content=$(awk '/<body>/,/<\/body>/{if(!/<body>/&&!/<\/body>/)print}' "${post_file}")

# Convert HTML to Markdown
markdown_content=$(echo "${body_content}" | html2text --images-with-size -b 0)

# Save markdown to a temporary file
temp_markdown=$(mktemp)
echo "${markdown_content}" > "${temp_markdown}"

# Edit the temporary markdown file
${EDITOR:-vi} "${temp_markdown}"

# Convert edited markdown content to HTML
edited_html_content=$(md2html "${temp_markdown}")

# Replace the original post content, preserving the header and footer
header_content=$(awk '!p; /<body>/ {p=1}' "${post_file}")
footer_content=$(awk '/<\/body>/ {p=1; next} p {print}' "${post_file}")

# Write the HTML file
{
    echo "${header_content}"
    echo "<body>"
    echo "${edited_html_content}"
    echo "</body>"
    echo "${footer_content}"
} > "${post_file}"

# Clean up
rm "${temp_markdown}"

# Add changes to git
git add "${post_file}"
git commit -m "Edited ${post_name} post"
git push -u origin

echo "Post edited and changes pushed to the repository."
