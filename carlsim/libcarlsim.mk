##----------------------------------------------------------------------------##
##
##   CARLsim3 Library
##   ----------------
##
##   Authors:   Michael Beyeler <mbeyeler@uci.edu>
##              Kristofor Carlson <kdcarlso@uci.edu>
##
##   Institute: Cognitive Anteater Robotics Lab (CARL)
##              Department of Cognitive Sciences
##              University of California, Irvine
##              Irvine, CA, 92697-5100, USA
##
##   Version:   03/31/2016
##
##----------------------------------------------------------------------------##

#------------------------------------------------------------------------------
# CARLsim3 Library Variables
#------------------------------------------------------------------------------

lib_name := lib$(SIM_LIB_NAME).a
lib_ver := $(SIM_MAJOR_NUM).$(SIM_MINOR_NUM).$(SIM_BUILD_NUM)

targets += $(lib_name)
libraries += $(lib_name).$(lib_ver)

sim_install_files += $(CARLSIM3_LIB_DIR)/$(lib_name)*


#------------------------------------------------------------------------------
# CARLsim3 Library Targets
#------------------------------------------------------------------------------

.PHONY: $(lib_name) test_env install uninstall
.PHONY: create_files welcome uninstall delete_files farewell

install: test_env create_files welcome

uninstall: test_env delete_files farewell


test_env:
ifndef CARLSIM3_LIB_DIR
	$(error CARLSIM3_LIB_DIR not set. Run with -e: $$ sudo -e make install)
else
	$(info CARLsim3 library path: $(CARLSIM3_LIB_DIR))
endif
ifndef CARLSIM3_INC_DIR
	$(error CARLSIM3_INC_DIR not set. Run with -e: $$ sudo -e make install)
else
	$(info CARLsim3 include path: $(CARLSIM3_INC_DIR))
endif
ifeq ($(CARLSIM3_NO_CUDA),1)
	$(info CARLsim3 mode: NO_CUDA. Install without GPU support.)
else
	$(info CARLSIM3 mode: NO_CUDA not set. Install with GPU support.)
endif

create_files:
ifdef CARLSIM3_INSTALL_DIR
	@test -d $(CARLSIM3_INSTALL_DIR) || mkdir $(CARLSIM3_INSTALL_DIR)
endif
	ar rcs $(lib_name).$(lib_ver) $(intf_obj_files) $(krnl_obj_files) $(grps_obj_files) $(spks_obj_files) $(conn_obj_files) $(tools_obj_files)
	@test -d $(CARLSIM3_INC_DIR) || mkdir $(CARLSIM3_INC_DIR)
	@test -d $(CARLSIM3_LIB_DIR) || mkdir $(CARLSIM3_LIB_DIR)
	@install -m 0755 $(lib_name).$(lib_ver) $(CARLSIM3_LIB_DIR)
	@ln -fs $(CARLSIM3_LIB_DIR)/$(lib_name).$(lib_ver) $(CARLSIM3_LIB_DIR)/$(lib_name).$(SIM_MAJOR_NUM).$(SIM_MINOR_NUM)
	@ln -fs $(CARLSIM3_LIB_DIR)/$(lib_name).$(SIM_MAJOR_NUM).$(SIM_MINOR_NUM) $(CARLSIM3_LIB_DIR)/$(lib_name)
	@install -m 0644 $(intf_inc_files) $(CARLSIM3_INC_DIR)
	@install -m 0644 $(krnl_inc_files) $(CARLSIM3_INC_DIR)
	@install -m 0644 $(grps_inc_files) $(CARLSIM3_INC_DIR)
	@install -m 0644 $(conn_inc_files) $(CARLSIM3_INC_DIR)
	@install -m 0644 $(spks_inc_files) $(CARLSIM3_INC_DIR)
	@install -m 0644 $(swt_inc_files) $(CARLSIM3_INC_DIR)
	@install -m 0644 $(spkgen_inc_files) $(CARLSIM3_INC_DIR)
	@install -m 0644 $(stp_inc_files) $(CARLSIM3_INC_DIR)
	@install -m 0644 $(vs_inc_files) $(CARLSIM3_INC_DIR)
	@install -m 0644 $(add_files) $(CARLSIM3_INC_DIR)

delete_files: test_env
ifeq (,$(findstring $(lib_name),$(sim_install_files)))
	$(error Something went wrong. None of the files that are about to be deleted contain the string "$(lib_name)". Delete files manually)
endif
	$(RMR) $(sim_install_files)

welcome:
	$(info CARLsim $(SIM_MAJOR_NUM).$(SIM_MINOR_NUM).$(SIM_BUILD_NUM) successfully installed.)

farewell:
	$(info CARLsim $(SIM_MAJOR_NUM).$(SIM_MINOR_NUM).$(SIM_BUILD_NUM) successfully uninstalled.)
