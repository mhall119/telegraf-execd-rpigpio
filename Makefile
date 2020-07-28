GOOS ?= $(shell go env GOOS)
GOARCH ?= $(shell go env GOARCH)
GOARM ?= $(shell go env GOARM)

.PHONY: all
all: rpi_gpio

.PHONY: rpi_gpio
rpi_gpio:
	go build ./cmd/rpi_gpio

.PHONY: dist
dist: rpi_gpio-$(GOOS)-$(GOARCH).tar.gz

.PHONY: dist-all
dist-all: rpi_gpio-linux-amd64.tar.gz
dist-all: rpi_gpio-windows-amd64.zip

rpi_gpio-linux-amd64.tar.gz: GOOS := linux
rpi_gpio-linux-amd64.tar.gz: GOARCH := amd64
rpi_gpio-windows-amd64.zip: GOOS := windows
rpi_gpio-windows-amd64.zip: GOARCH := amd64
rpi_gpio-windows-amd64.zip: EXT := .exe
rpi_gpio-%.tar.gz:
	mkdir -p "dist/rpi_gpio-$*"
	env GOOS=$(GOOS) GOARCH=$(GOARCH) go build -o "dist/rpi_gpio-$*/rpi_gpio$(EXT)" -ldflags "-w -s" ./cmd/rpi_gpio
	cp rpi_gpio.conf "dist/rpi_gpio-$*"
	cd dist && tar czf "$@" "rpi_gpio-$*"

rpi_gpio-%.zip:
	mkdir -p "dist/rpi_gpio-$*"
	env GOOS=$(GOOS) GOARCH=$(GOARCH) go build -o "dist/rpi_gpio-$*/rpi_gpio$(EXT)" -ldflags "-w -s" ./cmd/rpi_gpio
	cp rpi_gpio.conf "dist/rpi_gpio-$*"
	cd dist && zip -r "$@" "rpi_gpio-$*"

.PHONY: clean
clean:
	rm -f rpi_gpio{,.exe}
	rm -rf dist
