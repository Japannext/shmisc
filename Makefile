include Makefile.inc
include version.mk

BINS = shproc

all: $(BINS)

shproc: shproc.py
	cat $< > $@
	@chmod +x $@

clean:
	rm -f $(BINS)

tag:
	$(GIT) tag $(VERSION) -m "Tagging $(VERSION) release"

.PHONY: all clean tag
