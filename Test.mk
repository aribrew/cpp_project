############################################
# Makefile for library test programs
############################################

include mk/System.mk
include mk/CPP_CommonPaths.mk
include mk/Commands.mk
include mk/Functions.mk
include mk/Helpers.mk

TEST_PATH			:= /home/javier/github/aribrew/cpp_libs

MAIN				:= ${TEST_PATH}/TerminalTest.cpp
SRCS				:= 
HEADERS				:= ${TEST_PATH}/Terminal.hpp

BUILD_PATH			:= .

MAIN_OBJ			:= $(call OBJS_FROM,${MAIN},${OBJS_PATH})
OBJS				:= $(call OBJS_FROM,${MAIN},${OBJS_PATH})

ifneq (${SRCS},)
	OBJS			+= $(call OBJS_FROM,${SRC},${OBJS_PATH})
endif

INCLUDE_PATHS		:= 


include mk/CPP_CommonMacros.mk




.PHONY: all info


all: ${OBJS_PATH} ${BUILD_PATH} ${EXEC}



${BUILD_PATH}:
	$(shell ${MKTREE} ${BUILD_PATH})


${OBJS_PATH}:
	$(shell ${MKTREE} ${OBJS_PATH})


include mk/CPP_CommonRecipes.mk


# Builds the executable
#${EXEC}: ${OBJS} ${MAIN_OBJ}
#ifeq (${MAIN_FILE},main.c)
#	${C} ${DEPS_OBJS} ${OBJS} ${MAIN_OBJ} -o ${EXEC} ${LIBS} ${LDFLAGS}
#else
#	${CXX} ${DEPS_OBJS} ${OBJS} ${MAIN_OBJ} -o ${EXEC} ${LIBS} ${LDFLAGS}
#endif


# Builds the main object
#${MAIN_OBJ}: ${MAIN}
#ifeq (${MAIN_FILE},main.c)
#	${C} -c ${MAIN} -o ${MAIN_OBJ} ${DEPS_INCLUDE} ${INCLUDE} ${CFLAGS}
#else
#	${CXX} -c ${MAIN} -o ${MAIN_OBJ} ${DEPS_INCLUDE} ${INCLUDE} ${CXXFLAGS}
#endif
#endif


# Builds all C files mirroring their folder tree
#${OBJS_PATH}/%.o: ${SRC}/%.c
#	$(shell ${MKTREE} $(dir $@))
#	${C} -c $< -o $@ ${DEPS_INCLUDE} ${INCLUDE} ${CFLAGS}


# Builds all CPP files mirroring their folder tree
#${OBJS_PATH}/%.o: ${SRC}/%.cpp
#	$(shell ${MKTREE} $(dir $@))
#	${CXX} -c $< -o $@ ${DEPS_INCLUDE} ${INCLUDE} ${CXXFLAGS}


info:
	$(info MAIN: ${MAIN})
	$(info SRCS: ${SRCS})
	$(info HEADERS: ${HEADERS})
	$(info INCLUDE_PATHS: ${INCLUDE_PATHS})

	$(info OBJS: ${OBJS})
	$(info INCLUDE_FLAGS: ${INCLUDE_FLAGS})
	
