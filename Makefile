NAME        := tagreleaser
BUILDNAME   ?= ./bin/$(NAME)
INSTALLNAME := ${GOBIN}/$(NAME)
LINTNAME    := .linted
COVERNAME   := cover.out

CMD         := ./cmd/tagreleaser
SOURCES     := $(shell find . -name '*.go')
GOPKGS      := $(shell go list ./... | grep -v "/test")
GOTEST      := -count=1 -race -cover -covermode=atomic -coverprofile=$(COVERNAME) -v $(GOPKGS)

all: vendor lint test build
.PHONY: all

.PHONY:
clean:
	rm -rf $(BUILDNAME) $(LINTNAME) $(COVERNAME)

build: $(BUILDNAME)
install: $(INSTALLNAME)
lint: $(LINTNAME)

.PHONY:
test:
	go test $(GOTEST)

$(INSTALLNAME): $(SOURCES)
	go build -i -o $(INSTALLNAME) $(CMD)

$(BUILDNAME): $(SOURCES)
	go build -o $(BUILDNAME) $(CMD)

$(LINTNAME): $(SOURCES) .golangci.yml
	golangci-lint run --exclude-use-default=false
	@touch $@

vendor: $(SOURCES)
	go mod tidy
	go mod vendor
	@touch $@
