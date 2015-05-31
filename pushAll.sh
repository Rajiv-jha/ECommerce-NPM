#! /bin/bash
if [ -z "$1" ]; then
  read -e -p "Version: " TAG_VERSION;
else
        export TAG_VERSION=$1;
fi
for i in $(docker images | grep $TAG_VERSION | awk {'print $1'}); do
	docker push $i:$TAG_VERSION
done
