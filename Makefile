-include Makefile.inc
-include version.mk

BINS = shproc

all: $(BINS)

clean:
	rm -f $(BINS)

tag: all
	$(GIT) tag $(VERSION) -m "Tagging $(VERSION) release"

shproc: shproc.py
	cat $^ > $@
	chmod +x $@

.PHONY: all clean tag
