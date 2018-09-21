#!/bin/sh

[ -z $(which csso) ] && echo "Please install csso: npm install -g csso-cli" && exit 1

version=$(head -5 css/skeleton.css  | grep "v[0-9]" | sed "s/.* v//")
path="dist/${version}"

rm -Rf $path
mkdir -p $path

cat css/normalize.css css/skeleton.css css/extras.css > ${path}/skel.css
csso ${path}/skel.css ${path}/skel.min.css

ln -sf $path "dist/latest"
git add dist
git commit -a -m "Updated build."

git checkout gh-pages
[ $? -ne 0 ] && echo "Stopping here." && exit 1

git merge --ff-only master
git push origin
git checkout master
