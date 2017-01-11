cd css
rm -f all.css
cat normalize.css skeleton.css extras.css > all.css

mv css build
git checkout gh-pages
[ $? -ne 0 ] && echo "Stopping here." && exit 1

rm -Rf dist/css
mv build dist/css
git commit -a -m "Updated build."
git push -f origin gh-pages
git checkout master
