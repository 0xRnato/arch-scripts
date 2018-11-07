#!/bin/bash

function install_favs() {
	install_from_list "preferred applications" "favs" main
}

function install_favs_yaourt() {
	install_from_yaourt_list "preferred applications from yaourt" "favs-yaourt" main
}

function install_favs_dev() {
	install_from_list "preferred development tools" "favs-dev" main
}

function install_favs_utils() {
	install_from_list "preferred utilities" "favs-utils" main
}

function install_codecs() {
	install_from_list "multimedia codecs" "codecs" main
}
