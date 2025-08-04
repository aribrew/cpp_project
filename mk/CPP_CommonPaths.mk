# Requires: System.mk

SRC									:= src

DEPS								:= deps
BUILD								:= build
OBJ									:= obj

OBJS_PATH							:= ${OBJ}/${SYSTEM}
DEPS_OBJS_PATH						:= ${DEPS}/${OBJ}/${SYSTEM}
BUILD_PATH							:= ${BUILD}/${SYSTEM}

EXEC								:= ${BUILD}/${SYSTEM}/${EXEC}
