
# Locate ALL source files below ${1}
# ${1}: SRC path
define FIND_ALL_SRCS
$(strip $(call FIND_EXCLUDING,"*.c","main.c",${1}) \ 
		$(call FIND_EXCLUDING,"*.cpp","main.cpp",${1}))
endef


# ${1}: Path where local dependencies are
define FIND_ALL_DEPS_SRCS
$(strip $(call FIND,"*.c",${1}) \ 
		$(call FIND,"*.cpp",${1}))
endef


# Locate ALL header files below ${1}
# ${1}: SRC path
define FIND_ALL_HEADERS
$(strip $(call FIND,"*.h",${1}) \ 
		$(call FIND,"*.hpp",${1}))
endef


# ${1}: Path where local dependencies are
define FIND_ALL_DEPS_HEADERS
$(strip $(call FIND,"*.h",${1}) \ 
		$(call FIND,"*.hpp",${1}))
endef


# ${1}: A list of paths with headers
define INCLUDE_FLAGS_FROM
$(strip $(foreach inc,${1},-I ${inc}))
endef


# ${1}: A list of dynamic library names
define LIB_FLAGS_FROM
$(strip $(foreach lib,${1},-l${lib}))
endef


# Obtains the paths of all provided files.
# The sort function also removes duplicates.
#${1}: File list
define PATHS_OF
$(sort $(foreach file,${1},$(dir ${file})))
endef

