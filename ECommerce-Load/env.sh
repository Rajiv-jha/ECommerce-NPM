#! /bin/bash

# 1st param to LoadRunner call
if [ -z "${NUM_OF_USERS}" ]; then
        export NUM_OF_USERS="5";
fi

# 2nd param to LoadRunner call
if [ -z "${RAMP_TIME}" ]; then
        export RAMP_TIME="5";
fi

# 3rd param to LoadRunner call
if [ -z "${TIME_BETWEEN_RUNS}" ]; then
        export TIME_BETWEEN_RUNS="5000";
fi

# 4th param to LoadRunner call
if [ -z "${TARGET_HOST}" ]; then
	export TARGET_HOST="lbr";
fi

# 5th param to LoadRunner call
if [ -z "${TARGET_ANGULARHOST}" ]; then
	export TARGET_ANGULARHOST="angular";
fi

# 6th param to LoadRunner call
if [ -z "${TARGET_PORT}" ]; then
        export TARGET_PORT="80";
fi

# 7th param to LoadRunner call
if [ -z "${TARGET_ANGULARPORT}" ]; then
        export TARGET_ANGULARPORT="8080";
fi
# 8th param to LoadRunner call
if [ -z "${WAIT_TIME}" ]; then
        export WAIT_TIME="1000";
fi
