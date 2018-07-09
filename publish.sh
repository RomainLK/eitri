 #!/bin/bash

 docker build -t romainlk/eitri .
 docker tag romainlk/eitri  romainlk/eitri:$1
 docker push romainlk/eitri