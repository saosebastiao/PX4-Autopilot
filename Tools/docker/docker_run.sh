#! /bin/bash

PX4_DOCKER_REPO="px4-dev"

echo "PX4_DOCKER_REPO: $PX4_DOCKER_REPO";

SRC_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd ../../ && pwd )
ECHO $SRC_DIR

docker run -it --rm \
	--env=AWS_ACCESS_KEY_ID \
	--env=AWS_SECRET_ACCESS_KEY \
	--env=BRANCH_NAME \
	--env=CI \
	--env=CODECOV_TOKEN \
	--env=COVERALLS_REPO_TOKEN \
	--env=LOCAL_USER_ID="$(id -u)" \
	--env=PX4_ASAN \
	--env=PX4_MSAN \
	--env=PX4_TSAN \
	--env=PX4_UBSAN \
	--env=TRAVIS_BRANCH \
	--env=TRAVIS_BUILD_ID \
	--publish 14556:14556/udp \
	--mount type=volume,source=px4_venv,target=/venv \
	--mount type=volume,source=px4_ccache,target=/ccache \
	--mount type=bind,source=${SRC_DIR},target=/PX4 \
	${PX4_DOCKER_REPO} /bin/bash -c "$1 $2 $3"
