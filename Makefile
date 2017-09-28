-include Makefile.inc
-include version.mk

ALL_BINS = shproc

all: $(ALL_BINS)

clean:
	rm -f $(ALL_BINS)

tag: all
	$(GIT) tag $(VERSION) -m "Tagging $(VERSION) release"

.PHONY: clean tag

shproc: shproc.py
	cat $^ > $@
	chmod +x $@
