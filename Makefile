PACKAGES_DIR := packages
BUILD_DIR := build
HEADER_DIR := header
BIN_DIR := bin
CORE_DIR := core

LIB_DEPS := -lcurl
DEPENDENCIES_FILE := dependencies.txt
DEPENDENCIES_SHELL_SCRIPT := scripts/dependencies.sh

SOURCE_FILES := $(shell find $(PACKAGES_DIR) -wholename "**.c*" -type f)
BUILD_FILES := $(SOURCE_FILES:$(PACKAGES_DIR)/%.c=$(BUILD_DIR)/%.o)
BIN_FILES := $(BUILD_FILES:$(BUILD_DIR)/%.o=$(BIN_DIR)/%)
FILTERED_BIN_FILES := $(filter-out $(BIN_DIR)/$(CORE_DIR)/%,$(BIN_FILES))

all: folders compile binary

folders: $(PACKAGES_DIR) $(BUILD_DIR) $(BIN_DIR)

compile: $(BUILD_FILES)

binary: $(FILTERED_BIN_FILES)

$(BIN_DIR)/%: $(BUILD_DIR)/%.o $(DEPENDENCIES_FILE)
	$(eval TEMP := $(shell $(DEPENDENCIES_SHELL_SCRIPT) $(DEPENDENCIES_FILE) $@ $(BUILD_DIR) $(shell find $(BUILD_DIR) -wholename "**.o*" -type f)))
	mkdir -p $(dir $@)
	gcc $(TEMP) $< -o $@ $(LIB_DEPS)
	@echo
	@ls -lhs $@

$(PACKAGES_DIR) $(BUILD_DIR) $(BIN_DIR):
	mkdir -p $@

$(BUILD_DIR)/%.o: $(PACKAGES_DIR)/%.c
	mkdir -p $(dir $@)
	gcc $(CFLAGS) -c $< -o $@

clean:
	rm -rf $(BUILD_DIR) $(BIN_DIR)

.PHONY: all folders compile binary