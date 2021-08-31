shmisc
======

Helper utility (processor) to provide standard command line to work with daemonized processes.

Usage:
------

    shproc [-Idir...] [-Dmacro=defn...] file [output]

The contents of file will be processed and output to either the output file or
standard output.

The following directives are recognized:

- `%%:macro%%` - this will be replaced by the macro definition provided with the `-D` option.
- `%%<file%%` - this will be replaced by the contents of `file`, where `file`
  is searched for in the directories specified with `-I`.
