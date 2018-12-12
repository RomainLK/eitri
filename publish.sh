 #!/bin/bash

git add .
git commit -m "Version $1"
git tag $1
 docker build -t sebhomeloop/eitri .
 docker tag sebhomeloop/eitri  sebhomeloop/eitri:$1
 docker push sebhomeloop/eitri