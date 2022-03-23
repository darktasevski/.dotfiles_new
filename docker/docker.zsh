#!/bin/zsh

###############################################################
# Docker Helpers
# @author https://github.com/jmervine
###############################################################
function docker_clean {
	echo "+ clean containers"
	docker ps -a | grep -v 'NAMES' | grep -v 'Up ' | awk '{ print $NF }' | xargs docker rm

	echo "+ clean images"
	docker images | grep '^<none>' | awk '{ print $3 }' | xargs docker rmi
}

function docker_killall {
	echo "+ killing all containers"
	docker ps | awk '{print $NF}' | grep -v 'NAMES' | xargs docker kill
}

function docker_stopall {
	echo "+ stopping all containers"
	docker ps | awk '{print $NF}' | grep -v 'NAMES' | xargs docker stop
}

## Run Server to serve files from a local directory
function docker_serve {
	local port="$1"
	[[ -z $port ]] && port=3000

	docker run -it --rm -p ${port}:80 -v $(pwd):/usr/share/nginx/html nginx:alpine
}

function dcex {
	local cmd="bash"
	test $1 && cmd=$1
	echo "+ docker exec -it $(docker ps | grep $(basename $(pwd))_web | awk '{ print $(NF) }') $cmd"
	docker exec -it $(docker ps | grep $(basename $(pwd))_web | awk '{ print $(NF) }') $cmd
}
