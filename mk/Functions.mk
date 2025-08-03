
# ${1}: What to find
# ${2}: Where
define FIND
$(shell find -L ${2}/** -type f -name ${1})
endef

# ${1}: What to find
# ${2}: Excluding
# ${3}: Where
define FIND_EXCLUDING
$(shell find -L ${3}/** -type f -name ${1} -not -name ${2})
endef

# ${1}: Source file
# ${2}: Source files folder
# ${3}: Objs path
define SRC2OBJ
$(subst .c,.o,$(subst .cpp,.o,$(subst ${2},${3},${1})))
endef

# Obtains a list of all folders below this one
# ${1}: Path
define TREE
$(shell find ${1}/** -type d)
endef
