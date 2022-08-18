#!/bin/sh

[ -z $(which csso) ] && echo "Please install csso: npm install -g csso-cli@3.5.1" && exit 1

version=$(head -5 css/skeleton.css  | grep "v[0-9]" | sed "s/.* v//")
path="dist/${version}"

rm -Rf $path
rm -f dist/latest
mkdir -p $path

cat css/normalize.css css/skeleton.css css/extras.css > ${path}/skel.css
cat css/normalize.css css/skeleton.css css/extras.css css/plugins.css > ${path}/skel-with-plugins.css
csso -i ${path}/skel.css -o ${path}/skel.min.css
csso -i ${path}/skel-with-plugins.css -o ${path}/skel-with-plugins.min.css

cd dist
ln -sf "$version" latest
git add dist
git commit -a -m "Updated build."

git checkout gh-pages
[ $? -ne 0 ] && echo "Stopping here." && exit 1

# git merge --ff-only master
git merge master
git push origin
git checkout master
