# FUNCTIONS
get_files = $(shell find $(1) -wholename "***/$(2)*" -type f)
get_c = $(call get_files,$(1),*.c)

define get_dependencies =
	$(eval DEPS := $(dir $(patsubst $(LIB_DIR)/$(PACKAGE_DIR)/%,$(PACKAGE_DIR)/%,$(1))))
	$(eval DEPS := $(DEPS:%/=%/$(DEPENDENCIES_FILE)))
	$(eval DEPS := $(shell cat $(DEPS) | grep -P [-] | sed 's/ - //g'))
endef

define get_so_flags =
	$(call get_dependencies,$@)
	$(eval LIBS_FLAGS := $(DEPS:$(PACKAGE_DIR)/%.c=%))
	$(eval LIBS_FLAGS := $(foreach LIB,$(LIBS_FLAGS),-l$(notdir $(LIB))))	
endef

define get_so_files =
	$(call get_dependencies,$@)
	$(eval DEPS := $(DEPS:$(PACKAGE_DIR)/%.c=$(LIB_DIR)/$(SO_DIR)/%.so))
endef

define create_dir =
	$(eval directory := $(dir $(1)))
	@if [ ! -d "$(directory)" ]; then \
		echo mkdir --parents $(directory); \
		mkdir --parents $(directory); \
	fi
endef

define create_dir_as_sudo =
	$(eval directory := $(dir $(1)))
	@if [ ! -d "$(directory)" ]; then \
		echo mkdir --parents $(directory); \
		sudo mkdir --parents $(directory); \
	fi
endef

define sizeof =
	$$(du -sb \
	$(1) \
	| cut -f1)
endef

# DIRECTORIES
LIB_DIR := lib
SO_DIR := shared
CORE_DIR := core
BINARA_DIR := binara
OBJECTS_DIR := objects
PACKAGE_DIR := packages
MAIN_FILE := main
LIB_PATH := /usr/lib
ROOT_DIR := $(realpath .)

# FILES
DEPENDENCIES_FILE := dependencies.yml

# BUILD VARS
LD_LIB = -L$(LIB_PATH)/$(BINARA_DIR)
# packages/**/*.c
C_FILES := $(call get_c,$(PACKAGE_DIR))
SO_C_FILES := $(filter-out %/$(MAIN_FILE).c,$(C_FILES))
B_C_FILES := $(filter %/$(MAIN_FILE).c,$(C_FILES))

# lib/shared/**/*.so
SOFILES := $(SO_C_FILES:$(PACKAGE_DIR)/%.c=$(LIB_DIR)/$(SO_DIR)/%.so)

# lib/packages/**/*
BFILES := $(B_C_FILES:$(PACKAGE_DIR)/%.c=$(LIB_DIR)/$(PACKAGE_DIR)/%)

# BUILD
.PHONY: build
build: $(BFILES)

# $(BFILES) directive
$(LIB_DIR)/$(PACKAGE_DIR)/%: $(SOFILES)
	$(call get_so_flags)
	$(eval MAIN_FILE := $(patsubst $(LIB_DIR)/$(PACKAGE_DIR)/%,$(PACKAGE_DIR)/%.c,$@))
	$(call create_dir,$@)
	echo "$$LD_LIBRARY_PATH"
	$(CC) $(MAIN_FILE) -o $@ $(LD_LIB) $(LIBS_FLAGS) -Wall

# $(SOFILES) directive
$(LIB_DIR)/$(SO_DIR)/%.so: $(LIB_DIR)/$(OBJECTS_DIR)/%.o
	$(call create_dir,$@)
	$(CC) -shared $< -o $@
	sudo cp $@ $(LIB_PATH)/$(BINARA_DIR)/$(notdir $@) --update=all

.SECONDARY:
$(LIB_DIR)/$(OBJECTS_DIR)/%.o: $(PACKAGE_DIR)/%.c
	$(call create_dir,$@)
	$(CC) $(CFLAGS) -Werror -Wall -fPIC -c $< -o $@

# DEVELOPMENT
.PHONY: dev
dev: mkdir prepare_shared build
	@echo builded

.PHONY: dev_watch
dev_watch:
	@watch --interval 1 $(MAKE) dev

# MKDIR
.PHONY: mkdir
mkdir:
	$(call create_dir,$(LIB_DIR)/)
	$(call create_dir,$(LIB_DIR)/$(SO_DIR)/)
	$(call create_dir,$(LIB_DIR)/$(PACKAGE_DIR)/)
	$(call create_dir,$(LIB_DIR)/$(OBJECTS_DIR)/)

# PREPARE_SHARED
.PHONY: prepare_shared
prepare_shared:
	export LD_LIBRARY_PATH="$$LD_LIBRARY_PATH:$(LIB_PATH)/$(BINARA_DIR)"
	sudo mkdir -p $(LIB_PATH)/$(BINARA_DIR)

# CLEAN
.PHONY: clean
clean:
	rm -rf $(LIB_DIR)
