




# All objetives, that aren't files, must have an entry here
.PHONY: all info


# Special objetive. Always called when making.
all:
	$(info Objetive all done)


# What to build
/tmp/touched: # What is needed
	# Steps to build
	touch $@


# A recommended objetive for checking vars (pardon, macros)
info:
	# Similar to 'echo' in scripting
	$(info Debugging something)
