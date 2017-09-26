#!/bin/sh

[ -z $(which csso) ] && echo "Please install csso: npm install -g csso" && exit 1

rm dist/skel*
cat css/normalize.css css/skeleton.css css/extras.css > dist/skel.css
csso dist/skel.css dist/skel.css

git add dist
git commit -a -m "Updated build."

git checkout gh-pages
[ $? -ne 0 ] && echo "Stopping here." && exit 1

# git merge --ff-only master
# git push -f origin gh-pages
# git checkout master
