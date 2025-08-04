# Requires: CPP_CommonMacros.mk

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
