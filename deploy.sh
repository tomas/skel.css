#!/bin/sh

[ -z $(which csso) ] && echo "Please install csso: npm install -g csso-cli@3.5.1" && exit 1

version=$(head -5 css/skeleton.css  | grep "v[0-9]" | sed "s/.* v//")
path="dist/${version}"

base_extras="
css/extras/details.css
css/extras/alerts.css
css/extras/close-button.css
css/extras/menus.css
css/extras/dropdown.css
css/extras/dropdown-menu.css
css/extras/icons.css
css/extras/bg-cover.css
"

other_extras="
css/extras/animations.css
css/extras/bselect.css
css/extras/card-list.css
css/extras/checkboxes.css
css/extras/modal.css
css/extras/nice-select.css
css/extras/spinners.css
css/extras/toasts.css
css/extras/tooltips.css
"

build() {
  rm -Rf $path
  rm -f dist/latest
  mkdir -p $path

  cat css/normalize.css css/skeleton.css > ${path}/skel-bare.css
  cat css/normalize.css css/skeleton.css $base_extras > ${path}/skel.css
  cat ${path}/skel.css $other_extras > ${path}/skel-with-extras.css
  csso -i ${path}/skel.css -o ${path}/skel.min.css
  csso -i ${path}/skel-bare.css -o ${path}/skel-bare.min.css
  csso -i ${path}/skel-with-extras.css -o ${path}/skel-with-extras.min.css

  cd dist
  ln -sf "$version" latest
}

commit() {
  git add dist
  git commit -a -m "Updated build."
}

push() {
  git checkout gh-pages
  [ $? -ne 0 ] && echo "Stopping here." && exit 1

  # git merge --ff-only master
  git merge master
  git push origin
  git checkout master
}

build
commit
push

