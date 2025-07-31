ifndef NO_MAIN
	include Project.mk
endif

EXEC								:= ${PROJECT_NAME}

ifneq (${WINDIR},)
	SYSTEM							:= windows
	EXEC							:= ${EXEC}.exe
else
	UNAME							:= $(shell uname)

	ifeq (${UNAME},Darwin)
		SYSTEM						:= macos
	else ifeq (${UNAME},Linux)
		SYSTEM						:= linux
	else
		SYSTEM						:= other
	endif
endif


ifndef NO_MAIN
	SRC								:= src
else
	SRC								:= .
endif

DEPS								:= deps
BUILD								:= build
OBJ									:= obj

OBJS_PATH							:= ${OBJ}/${SYSTEM}
DEPS_OBJS_PATH						:= ${DEPS}/${OBJ}/${SYSTEM}
BUILD_PATH							:= ${BUILD}/${SYSTEM}

EXEC								:= ${BUILD}/${SYSTEM}/${EXEC}


ifndef NO_MAIN
	include mk/Commands.mk
	include mk/Functions.mk
	include mk/Helpers.mk
else
	include ../mk/Commands.mk
	include ../mk/Functions.mk
	include ../mk/Helpers.mk
endif


ifndef NO_MAIN
	C_MAIN					:= $(call FIND,"main.c",${SRC})
	CPP_MAIN				:= $(call FIND,"main.cpp",${SRC})

	ifneq (${C_MAIN},)
		MAIN				:= ${C_MAIN}
	else
		MAIN				:= ${CPP_MAIN}
	endif

	MAIN_FILE				:= $(notdir ${MAIN})
	MAIN_OBJ				:= ${OBJS_PATH}/$(call SRC2OBJ,${MAIN_FILE})
endif

SRCS					:= $(call FIND_ALL_SRCS,${SRC})
HEADERS					:= $(call FIND_ALL_HEADERS,${SRC})
OBJS					:= $(foreach src,${SRCS},$(call SRC2OBJ,${src}))
INCLUDE_PATHS			:= $(call PATHS_OF,${HEADERS})

INCLUDE					:= $(call INCLUDE_FLAGS_FROM,${INCLUDE_PATHS})
LIBS					:= $(call LIB_FLAGS_FROM,${LIBS})

ifndef NO_DEPS
DEPS_SRCS				:= $(call FIND_ALL_DEPS_SRCS,deps)
DEPS_HEADERS			:= $(call FIND_ALL_DEPS_HEADERS,deps)
DEPS_INCLUDE_PATHS		:= $(call PATHS_OF,${DEPS_HEADERS})

DEPS_INCLUDE			:= $(call INCLUDE_FLAGS_FROM,${DEPS_INCLUDE_PATHS})
DEPS_OBJS				:= $(call FIND,"*.o",deps/${SYSTEM})
endif


ifeq (${C},)
	C								:= clang
endif

ifeq (${CXX},)
	CXX								:= clang++
endif

GLOBAL_FLAGS						:= -Wall -pedantic

CFLAGS								+= ${GLOBAL_FLAGS}
CXXFLAGS							+= ${GLOBAL_FLAGS}

ifdef $(RELEASE)
	CFLAGS							+= -O3
	CXXFLAGS						+= -O3
else
	CFLAGS							+= -g
	CXXFLAGS						+= -g
endif




.PHONY: all cleandeps deps clean info run


ifndef NO_MAIN
all: ${OBJS_PATH} ${BUILD_PATH} ${EXEC}
else
all: ${OBJS_PATH} ${BUILD_PATH}
endif


clean:
	$(shell ${RMTREE} ${OBJ})
	$(shell ${RMTREE} ${BUILD})


cleandeps:
	${MAKE} -C ${DEPS} clean


deps:
	${MAKE} -C ${DEPS}


${BUILD_PATH}:
	$(shell ${MKTREE} ${BUILD_PATH})


${OBJS_PATH}:
	$(shell ${MKTREE} ${OBJS_PATH})


ifndef NO_MAIN
# Builds the executable
${EXEC}: ${OBJS} ${MAIN_OBJ}
ifeq (${MAIN_FILE},main.c)
	${C} ${DEPS_OBJS} ${OBJS} ${MAIN_OBJ} -o ${EXEC} ${LIBS} ${LDFLAGS}
else
	${CXX} ${DEPS_OBJS} ${OBJS} ${MAIN_OBJ} -o ${EXEC} ${LIBS} ${LDFLAGS}
endif


# Builds the main object
${MAIN_OBJ}: ${MAIN}
ifeq (${MAIN_FILE},main.c)
	${C} -c ${MAIN} -o ${MAIN_OBJ} ${DEPS_INCLUDE} ${INCLUDE} ${CFLAGS}
else
	${CXX} -c ${MAIN} -o ${MAIN_OBJ} ${DEPS_INCLUDE} ${INCLUDE} ${CXXFLAGS}
endif
endif


# Builds all C files mirroring their folder tree
${OBJS_PATH}/%.o: ${SRC}/%.c
	$(shell ${MKTREE} $(dir $@))
	${C} -c $< -o $@ ${DEPS_INCLUDE} ${INCLUDE} ${CFLAGS}


# Builds all CPP files mirroring their folder tree
${OBJS_PATH}/%.o: ${SRC}/%.cpp
	$(shell ${MKTREE} $(dir $@))
	${CXX} -c $< -o $@ ${DEPS_INCLUDE} ${INCLUDE} ${CXXFLAGS}


info:
	$(info PROJECT_NAME: ${PROJECT_NAME})
	$(info EXEC: ${EXEC})
	$(info SYSTEM: ${SYSTEM})

ifndef NO_MAIN
	$(info MAIN: ${MAIN})
	$(info MAIN_FILE: ${MAIN_FILE})
	$(info MAIN_OBJ: ${MAIN_OBJ})
endif
	$(info SRCS: ${SRCS})
	$(info HEADERS: ${HEADERS})
	$(info OBJS: ${OBJS})
	$(info INCLUDED_PATHS: ${INCLUDE})
	$(info LIBS: ${LIBS})

ifndef NO_DEPS
	$(info DEPS_SRCS: ${DEPS_SRCS})
	$(info DEPS_HEADERS: ${DEPS_HEADERS})
	$(info DEPS_INCLUDE: ${DEPS_INCLUDE})
	$(info DEPS_OBJS: ${DEPS_OBJS})
endif


run:
ifeq (${SYSTEM},windows)
	${EXEC}
else
	./${EXEC}
endif
