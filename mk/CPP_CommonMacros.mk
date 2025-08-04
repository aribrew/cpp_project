
################# Compilers for C/C++ #################
C								:= clang
CXX								:= clang++

########### The global flags applies always ###########
GLOBAL_FLAGS					:= -Wall -pedantic

### Final flags that will be passed to the compiler ###
CFLAGS							+= ${GLOBAL_FLAGS}
CXXFLAGS						+= ${GLOBAL_FLAGS}

##### If RELEASE is defined, apply optimizations #####
######### If not, generate debugging symbols #########

ifdef $(RELEASE)
	CFLAGS							+= -O3
	CXXFLAGS						+= -O3
else
	CFLAGS							+= -g
	CXXFLAGS						+= -g
endif
