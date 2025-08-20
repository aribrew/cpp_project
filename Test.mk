
# If defined, the resulting binary will be named this.
# Otherwise, it will be named as ${MAIN}.
# So, if we have no main, THIS MUST BE SET.
PROJECT_NAME					:= HelloWorld

# If set, this path will be seached for source files (excluding MAIN)
# 
# This is intended for the case we have a src folder with all the sources
# below it. The object paths for each one will have this folder
# (for example 'src') replaced by ${OBJS_PATH}.
SRC_PATH 						:= src

# Also you can add here more source files to build.
#
# This is intended for the case we have a bunch of source files,
# with or without sub-folders, and want to add them to the build.
#
# The object paths of each one will be ${OBJS_PATH}/{SRCS.entry}
MORE_SRCS 						:= 

# The main source file, if any. If none, we assume this is a library.
MAIN_SRC						:= ${SRC_PATH}/main.cpp

# If 1, and if we have no main, a dynamic library will be built
IS_DYNAMIC_LIBRARY				:= 0

# Dependencies (Must have their own Makefile)
DEPS							:= 

# Header paths to include in headers search
INCLUDE							:= 

# Libs paths to include in libraries search
LIBS_PATHS 						:= 

# Dynamic libraries to link
LIBS							:= 

# Where to build things
BUILD_PATH						:= build
OBJS_PATH						:= obj

# User flags for ar and both the C and the C++ compiler
C_FLAGS							:= 
CXX_FLAGS						:=
AR_FLAGS						:=








##############################################################################
############################ D A N G E R  Z O N E ############################
##############################################################################
AR								:= ar
C								:= gcc
CXX								:= g++


# Global ar flags
AR_FLAGS						+= -crs

# Global C/C++ flags
C_CXX_FLAGS						:= -pedantic
C_CXX_FLAGS 					+= -Wall

ifdef $(RELEASE)
	C_CXX_FLAGS 				+= -O3
else
	C_CXX_FLAGS 				+= -g
endif




############################### Functions ####################################
# ${1}: What to find
# ${2}: Where
define FIND
$(shell find -L ${2}/** -type f -name ${1})
endef


# ${1}: What to find
# ${2}: Where
# ${3}: Excluding
define FIND_EXCLUDING
$(shell find -L ${2}/** -type f -name ${1} -not -name ${3})
endef


# ${1}: A list of paths with headers
define INCLUDE_FLAGS_FROM
$(strip $(foreach path,${1},-I ${path}))
endef


# ${1}: A list of dynamic library names
define LIBS_FLAGS_FROM
$(strip $(foreach lib,${1},-l${lib}))
endef


# ${1}: A list of paths with libraries
define LIBS_PATHS_FLAGS_FROM
$(strip $(foreach path,${1},-L ${path}))
endef


# Obtains the paths of all provided files.
# The sort function also removes duplicates.
# ${1}: File list
define PATHS_OF
$(sort $(foreach file,${1},$(dir ${file})))
endef


# Obtains the .o file path from the given source file
# ${1}: Source file
define SRC2OBJ
$(subst .c,.o,$(subst .cpp,.o,${1}))
endef


# Obtains a list of all folders below this one
# ${1}: Path
define TREE
$(shell find ${1}/** -type d)
endef
##############################################################################


################################## Helpers ###################################
# Locate ALL source files below ${1} (excluding ${MAIN_SRC}).
# If MAIN_SRC is defined, it filename will be ommited from the search.
# If not, the standard main.c and main.cpp will be checked when filtering.
#
# ${1}: The path where the source files are located
ifneq (${MAIN},)
define FIND_SOURCES
$(strip $(call FIND_EXCLUDING,"*.c",${1},${MAIN_SRC})$\
		$(call FIND_EXCLUDING,"*.cpp",${1},${MAIN_SRC}))
endef

else

define FIND_SOURCES
$(strip $(call FIND_EXCLUDING,"*.c",${1},"main.c")$\
		$(call FIND_EXCLUDING,"*.cpp",${1},"main.cpp"))
endef
endif

# ${1}: Path where local dependencies are
define FIND_DEPS_SOURCES
$(strip $(call FIND,"*.c",${1})$\
		$(call FIND,"*.cpp",${1}))
endef


# ${1}: Source files list
define OBJSFROM
$(foreach src,${1},$(call SRC2OBJ,${src}))
endef
##############################################################################




ifneq (${WINDIR},)
	SYSTEM						:= windows
else
	UNAME						:= $(shell uname)

	ifeq (${UNAME},Darwin)
		SYSTEM					:= macos
	else ifeq (${UNAME},Linux)
		SYSTEM					:= linux
	else
		SYSTEM					:= other
	endif
endif


BUILD_PATH						:= ${BUILD_PATH}/${SYSTEM}
OBJS_PATH						:= ${OBJS_PATH}/${SYSTEM}


# If MAIN has been set
ifneq (${MAIN_SRC},)
	EXEC						:= ${BUILD_PATH}
	
	ifeq (${PROJECT_NAME},)
		# The executable will be named as ${MAIN}
		EXEC					+= /$(basename $(notdir ${MAIN_SRC}))
	else
		# The executable will be named as ${PROJECT_NAME}
		EXEC					:= ${BUILD_PATH}/${PROJECT_NAME}
	endif

	ifeq (${SYSTEM},windows)
		# Name the excutable to be a Windows executable
		EXEC					+= .exe
	endif
else
	# If we have no MAIN, we need a PROJECT_NAME for the binary
    ifneq (${PROJECT_NAME},)
    	ifeq (${IS_DYNAMIC_LIBRARY},0)
    		LIBRARY				:= lib${PROJECT_NAME}.a
    	else
    		LIBRARY				:= lib${PROJECT_NAME}.so
    	endif
    else
    	$(info If you have no MAIN_SRC you MUST specify a PROJECT_NAME)
    	exit 1
    endif
endif


ifneq (${MAIN_SRC},)
	MAIN_OBJ					:= $(call SRC2OBJ,${MAIN_SRC})
	MAIN_OBJ					:= ${OBJS_PATH}/$(notdir ${MAIN_OBJ})
endif

ifneq (${SRC_PATH},)
	SRCS						:= $(call FIND_SOURCES,${SRC_PATH})
	OBJS						:= $(foreach o,${OBJS},$(subst ${SRC_PATH},${OBJS_PATH},${o}))
endif

ifneq (${MORE_SRCS},)
	MORE_OBJS					:= $(call OBJSFROM,${MORE_SRCS})
	MORE_OBJS					:= $(foreach o,${MORE_OBJS},${OBJS_PATH}/${o})
endif

INCLUDE_FLAGS					:= $(call INCLUDE_FLAGS_FROM,${INCLUDE})

LINK_FLAGS						:= $(call LIBS_PATHS_FLAGS_FROM,${LIBS_PATHS})
LINK_FLAGS						+= $(call LIBS_FLAGS_FROM,${LIBS})

C_FLAGS 						:= ${C_CXX_FLAGS} ${C_FLAGS}
CXX_FLAGS 						:= ${C_CXX_FLAGS} ${CXX_FLAGS}




# All objetives, that aren't files, must have an entry here
.PHONY: all clean info obj run


# Special objetive. Always called when making.
all: ${OBJS_PATH} ${BUILD_PATH} ${EXEC} ${LIBRARY}


clean:
	rm -rf $(dir ${BUILD_PATH})
	rm -rf $(dir ${OBJS_PATH})


${OBJS_PATH}:
	mkdir -p $@


${BUILD_PATH}:
	mkdir -p $@


# Builds the MAIN_OBJ
${MAIN_OBJ}: ${OBJS_PATH} ${MAIN_SRC}
ifeq ($(suffix ${MAIN_SRC}),.c)
	${C} -c ${MAIN_SRC} -o $@ ${INCLUDE_FLAGS} ${C_FLAGS}
else
	${CXX} -c ${MAIN_SRC} -o $@ ${INCLUDE_FLAGS} ${CXX_FLAGS}
endif


# Builds the executable when building a program
${EXEC}: ${BUILD_PATH} ${MAIN_OBJ} ${OBJS} ${MORE_OBJS}
ifeq ($(suffix ${MAIN_SRC}),.c)
	${C} ${OBJS} ${MORE_OBJS} ${MAIN_OBJ} \
		 -o $@ ${LINK_FLAGS} ${C_FLAGS}
else
	${CXX} ${OBJS} ${MORE_OBJS} ${MAIN_OBJ} \
		   -o $@ ${LINK_FLAGS} ${CXX_FLAGS}
endif


# Builds the library
${BUILD_PATH}/${LIBRARY}: ${BUILD_PATH} ${OBJS} ${MORE_OBJS}
	${AR} ${AR_FLAGS} $@ ${OBJS} ${MORE_OBJS}


ifneq (${SRC_PATH},)
# Builds the .cpp source files below SRC_PATH
${OBJS_PATH}/%.o: ${SRC_PATH}/%.c ${OBJS_PATH}
	$(info DEBUG: ${C} -c $< -o $@)


# Builds the .cpp source files below SRC_PATH
${OBJS_PATH}/%.o: ${SRC_PATH}/%.cpp ${OBJS_PATH}
	$(info DEBUG: ${CXX} -c $< -o $@ ${INCLUDE_FLAGS} ${CXX_FLAGS})
endif


# Builds the .c source files added in MORE_SRCS}
${OBJS_PATH}/%.o: %.c ${OBJS_PATH}
#	$(info DEBUG: ${C} -c $^ -o $@ ${INCLUDE_FLAGS} ${C_FLAGS})
	${C} -c $< -o $@ ${INCLUDE_FLAGS} ${C_FLAGS}


# Builds the .cpp source files added in MORE_SRCS}
${OBJS_PATH}/%.o: %.cpp ${OBJS_PATH}
#	$(info DEBUG: ${CXX} -c $^ -o $@ ${INCLUDE_FLAGS} ${CXX_FLAGS})
	${CXX} -c $< -o $@ ${INCLUDE_FLAGS} ${CXX_FLAGS}

# What to build
/tmp/touched: # What is needed
	# Steps to build
	touch $@


# A recommended objetive for checking vars (pardon, macros)
info:
	$(info PROJECT_NAME: ${PROJECT_NAME})
	$(info EXEC: ${EXEC})
	$(info LIBRARY: ${LIBRARY})
	$(info SRC_PATH: ${SRC_PATH})
	$(info OBJS_PATH: ${OBJS_PATH})
	$(info BUILD_PATH: ${BUILD_PATH})
	
	$(info AR binary: ${AR})
	$(info C compiler: ${C})
	$(info C++ compiler: ${CXX})
	
	$(info C_FLAGS: ${C_FLAGS})
	$(info CXX_FLAGS: ${CXX_FLAGS})
	$(info AR_FLAGS: ${AR_FLAGS})

	$(info MAIN_SRC: ${MAIN_SRC})
	$(info MAIN_OBJ: ${MAIN_OBJ})

	$(info SRCS: ${SRCS})
	$(info OBJS: ${OBJS})

	$(info MORE_SRCS: ${MORE_SRCS})
	$(info MORE_OBJS: ${MORE_OBJS})

	$(info INCLUDE: ${INCLUDE})
	$(info INCLUDE_FLAGS: ${INCLUDE_FLAGS})

	$(info LIBS_PATHS: ${LIBS_PATHS})
	$(info LIBS: ${LIBS})
	
	$(info LINK_FLAGS: ${LINK_FLAGS})
	
	$(info DEPS: ${DEPS})

run:
	chmod +x "${EXEC}"
	${EXEC}
	
