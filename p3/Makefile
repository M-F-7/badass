.PHONY: all host router clean re

all: host router

host:
	docker build -t badass-host ./srcs/host

router:
	docker build -t badass-router ./srcs/router

clean:
	-docker rmi badass-host badass-router

re: clean all
