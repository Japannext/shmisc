VERSION = $(shell cat VERSION)

ALL_BINS = shproc

all: $(ALL_BINS)

clean:
	rm -f $(ALL_BINS)

tag: all
	git tag shmisc-$(VERSION) -m "Tagging $(VERSION) release"

.PHONY: clean tag

shproc: shproc.py
	cat $^ > $@
	chmod +x $@
