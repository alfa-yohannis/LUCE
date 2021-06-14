# docker network create --subnet=111.111.0.0/24 --gateway=111.111.0.100 ubuntunet

docker run -d \
  --name myubuntu \
  --network host \
  -t ubuntu /bin/bash