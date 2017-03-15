
ifdef CONFIG_EXTERNAL_PYBIND11

# Targets provided by this project
.PHONY: pybind11 clean_pybind11

# Add this to the "external" target
external: pybind11
clean_external: clean_pybind11

MODULE_DIR_PYBIND11=external/optional/pybind11
PYBIND11_FLAGS=-DPYBIND11_TEST=OFF -DPYBIND11_INSTALL=ON

pybind11: setup $(BUILD_DIR)/include/pybind11/pybind11.h
$(BUILD_DIR)/include/pybind11/pybind11.h:
	@echo
	@echo "==== Installing pybind11 Library ($(BUILD_TYPE)) ===="
	@echo " Using GCC    : $(CC)"
	@echo " Target flags : $(TARGET_FLAGS)"
	@echo " Sysroot      : $(PLATFORM_SYSROOT)"
	@echo " BOSP Options : $(CMAKE_COMMON_OPTIONS)"
	@[ -d $(MODULE_DIR_PYBIND11)/build/$(BUILD_TYPE) ] || \
	        mkdir -p $(MODULE_DIR_PYBIND11)/build/$(BUILD_TYPE) || \
	        exit 1
	@cd $(MODULE_DIR_PYBIND11)/build/$(BUILD_TYPE) && \
		CC=$(CC) CFLAGS="$(TARGET_FLAGS)" \
		CXX=$(CXX) CXXFLAGS="$(TARGET_FLAGS)" \
	        cmake $(CMAKE_COMMON_OPTIONS) $(PYBIND11_FLAGS) ../.. || \
	        exit 1
	@cd $(MODULE_DIR_PYBIND11)/build/$(BUILD_TYPE) && \
	        make -j$(CPUS) install || \
	        exit 1

clean_pybind11:
	@echo "==== Clean-up pybind11 library ===="
	@[ ! -d $(MODULE_DIR_PYBIND11)/build ] || \
		rm -rf $(MODULE_DIR_PYBIND11)/build

else # CONFIG_EXTERNAL_PYBIND11

pybind11:
	$(warning $(MODULE_DIR_PYBIND11) module disabled by BOSP configuration)
	$(error BOSP compilation failed)

endif # CONFIG_EXTERNAL_RAPIDXML

