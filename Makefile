VERSION=$(shell git describe --tags)

CMAKE_VARS=-DCARBON_VERSION=$(VERSION)

all:
	cmake . -B build $(CMAKE_VARS)

.PHONY: all
