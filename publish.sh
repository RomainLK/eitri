 #!/bin/bash

git add .
git commit -m "Version $1"
git tag $1
 docker build -t romainlk/eitri .
 docker tag romainlk/eitri  romainlk/eitri:$1
 docker push romainlk/eitri