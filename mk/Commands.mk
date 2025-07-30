ifeq (${SYSTEM},windows)
	MKTREE						:= mkdir
	RM							:= del
	RMTREE						:= deltree
else
	MKTREE						:= mkdir -p
	RM							:= rm
	RMTREE						:= rm -r
endif

