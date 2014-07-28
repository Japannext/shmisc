ALL_BINS = shproc

all: $(ALL_BINS)

clean:
	rm -f $(ALL_BINS)

.PHONY: clean

shproc: shproc.py
	cat $^ > $@
	chmod +x $@
