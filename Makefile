NAME     = vitasdk
REGISTRY = local
VERSION  = 1.0.0

.PHONY: build clean

all: build

clean-all: clean

build:
	@docker build --rm=true -t $(REGISTRY)/$(NAME):$(VERSION) .
	@docker images $(REGISTRY)/$(NAME)

clean:
	@docker rmi $(REGISTRY)/$(NAME):$(VERSION)

default: build
