############################################
# Makefile for library test programs
############################################

include mk/System.mk
include mk/Common.mk
include mk/Commands.mk
include mk/Functions.mk
include mk/Helpers.mk

MAIN				:= TerminalTest.cpp
SRCS				:= 
HEADERS				:= Terminal.hpp

BUILD_PATH			:= .

#MAIN_OBJ			:= $(call OBJS_FROM,${MAIN},${OBJS_PATH})
OBJS				:= $(call OBJS_FROM,${MAIN},${OBJS_PATH})

ifneq (${SRCS},)
	OBJS			+= $(call OBJS_FROM,${SRC},${OBJS_PATH})
endif

INCLUDE_PATHS		:= 

.PHONY: all info


all: ${OBJS_PATH} ${BUILD_PATH} objs exec



${BUILD_PATH}:
	$(shell ${MKTREE} ${BUILD_PATH})


${OBJS_PATH}:
	$(shell ${MKTREE} ${OBJS_PATH})


# Builds the executable
${EXEC}: ${OBJS} ${MAIN_OBJ}
ifeq (${MAIN_FILE},main.c)
	${C} ${DEPS_OBJS} ${OBJS} ${MAIN_OBJ} -o ${EXEC} ${LIBS} ${LDFLAGS}
else
	${CXX} ${DEPS_OBJS} ${OBJS} ${MAIN_OBJ} -o ${EXEC} ${LIBS} ${LDFLAGS}
endif
		

info:
	$(info MAIN: ${MAIN})
	$(info SRCS: ${SRCS})
	$(info HEADERS: ${HEADERS})
	$(info INCLUDE_PATHS: ${INCLUDE_PATHS})

	$(info OBJS: ${OBJS})
	$(info INCLUDE_FLAGS: ${INCLUDE_FLAGS})
	
