# Makefile generated by starthdlproject

SHELL := /bin/bash

vhd_files = $(shell find ../hdl/src/ ../hdl/tb/ \
	-regex .*\/[a-zA-Z0-9_\.]+\.vhd[l]? 	\
	-not -regex .*\/[a-zA-Z0-9_\.]+\.cpp\.vhd[l]?)
preproc_files = $(shell find ../hdl/src/ ../hdl/tb/ \
	-regex .*\/[a-zA-Z0-9_\.]+\.cpp\.vhd[l]?)
preproc_basenames = $(shell find ../hdl/src/ ../hdl/tb/ \
	-regex .*\/[a-zA-Z0-9_\.]+\.cpp\.vhd[l]? -exec basename '{}' ';')
postproc_files := $(patsubst %.cpp.vhdl,%.vhdl,$(preproc_basenames))
postproc_files := $(patsubst %.cpp.vhd,%.vhd,$(postproc_files))

current_pwd = $(shell pwd)

simfile ?= $(shell find . -regex \.\/[a-zA-Z0-9_\.]+_tb.vhd[l]? -exec basename '{}' ';')
simname = $(patsubst %.vhd,%,$(patsubst %.vhdl,%,$(simfile)))

testdata_files ?= $(shell find ../hdl/utils/ \
	-regex .*\/[a-zA-Z0-9_\.]+.in)
testout_files ?= $(shell find ../hdl/utils/ \
	-regex .*\/[a-zA-Z0-9_\.]+.out)

WF ?= vcd

.phony: update clean syntax preproc


update:
	@for f in ${vhd_files} ${testdata_files} ${testout_files}; do 	\
		bn=`basename $$f` ; \
		if [ ! -f $$bn ] ; then \
			ln -s $$f $$bn ; \
		fi ; \
	 done
	 @make preproc


clean:
	rm -rf $(shell find . -not -iname makefile -not -type d) ;


syntax: preproc update
	ghdl -s $(vhd_files) $(postproc_files)


preproc:
	@for f in $(preproc_files) ; do \
		bn=`basename $$f` ; \
		cpp -P $$f -o $(current_pwd)/$${bn/".cpp"/""}; \
	done


analyze: syntax
	ghdl -a $(vhd_files) $(postproc_files)


elaborate: analyze
	@for sname in $(simname) ; do \
		ghdl -e $$sname ; \
	done


build: elaborate $(simfile)
	@for sname in $(simname) ; do \
		ghdl -r $$sname --$(WF)=$${sname}.$(WF) ;\
	done
