# DIRECTORIES
LIB_DIR := lib
DEV_DIR := dev
SO_DIR := shared
CORE_DIR := core
PACKAGE_DIR := packages

# CHECK-ARGUMENTS
SO_FILES_TO_SEARCH := $(shell find $() -type f)

# BUILD VARS
# packages/**/*.c
CFILES := $(shell find $(PACKAGE_DIR) -wholename "***/*.c*" -type f)

# lib/shared/**/*.so
SOFILES := $(CFILES:$(PACKAGE_DIR)/%.c=$(LIB_DIR)/$(SO_DIR)/%.so)

# lib/packages/**/*

BFILES := $(CFILES:$(PACKAGE_DIR)/%.c=$(LIB_DIR)/$(PACKAGE_DIR)/%)

.PHONY: dev
dev: mkdir build
	@echo builded

.PHONY: dev_watch
dev_watch:
	@watch --interval 1 $(MAKE) dev

.PHONY: build
build:
	@echo $(CFILES)
	@echo
	@echo $(SOFILES)
	@echo
	@echo $(BFILES)

.PHONY: mkdir
mkdir:
	mkdir --parents $(LIB_DIR)
	mkdir --parents $(LIB_DIR)/$(DEV_DIR)
	mkdir --parents $(LIB_DIR)/$(SO_DIR)
	mkdir --parents $(LIB_DIR)/$(PACKAGE_DIR)

.PHONY: checkLibs
checkLibs:
ifeq ($(SO_FILES_TO_SEARCH),)
	@echo "error: no shared object file has provided"
	@echo "Usage: make checkLibs SO_FILES_TO_SEARCH=\"FILE FILE...\""
	@echo
	@exit 1
endif
	@echo "$(SO_FILES_TO_SEARCH)"
