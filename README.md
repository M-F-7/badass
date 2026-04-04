docker pull frrouting/frr
docker run --name routing -d frrouting/frr
docker exec -it routing bash