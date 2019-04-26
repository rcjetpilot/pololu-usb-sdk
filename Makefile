# Pololu USB Software Development Kit Makefile
# For compiling C# USB code under Linux with Mono as the compiler.

#### Configuration ##############################################################

# CSC: Command for invoking the C# compiler.
CSC:=mcs

# CSCFLAGS: The default compilation options to the C# compiler.
CSCFLAGS:=-unsafe -debug

CS:=$(CSC) $(CSCFLAGS)

#### List of modules ############################################################
# A module is a directory that contains some files to be compiled by this
# Makefile.  Feel free to add your own modules or edit the existing ones.
#
# Every module must:
# 1) Have a variable $([module_name]) defined below whose value is its directory.
# 2) Have that variable included in the list in $(Modules).
# 3) Have a file $([module_name])/module.mk which must:
#     a) Add the names of all the files it compiles to Targets.
#        (typically just a list of all targets).
#     b) If the module compiles to a library, define a variable called
#        $([module_name]_lib) which has a list of all the files needed at runtime
#        to use this module (if the module can be used as a library).
#     c) If the module creates any files that aren't targets (e.g. copied
#        library files), add them to $(Byproducts).  The only exception is
#        mdb files: you don't need to add them to Byproducts.

# List of modules directories.
UsbWrapper ?= UsbWrapper_Linux
Bytecode ?= Maestro/Bytecode
Sequencer ?= Maestro/Sequencer
Usc ?= Maestro/Usc
UscCmd ?= Maestro/UscCmd
MaestroAdvancedExample ?= Maestro/MaestroAdvancedExample
MaestroEasyExample ?= Maestro/MaestroEasyExample
Programmer ?= UsbAvrProgrammer/Programmer
PgmCmd ?= UsbAvrProgrammer/PgmCmd
Jrk ?= Jrk/Jrk
JrkCmd ?= Jrk/JrkCmd
JrkExample ?= Jrk/JrkExample
Smc ?= SimpleMotorController/Smc
SmcCmd ?= SimpleMotorController/SmcCmd
SmcExample1 ?= SimpleMotorController/SmcExample1
SmcExample2 ?= SimpleMotorController/SmcExample2
SmcG2 ?= SimpleMotorControllerG2/SmcG2
SmcG2Cmd ?= SimpleMotorControllerG2/SmcG2Cmd
SmcG2Example1 ?= SimpleMotorControllerG2/SmcG2Example1
SmcG2Example2 ?= SimpleMotorControllerG2/SmcG2Example2

# List of modules.  This list should be in dependency order:
# every module should appear after all of the modules it depends on.
# Otherwise, variables like UsbWrapper_lib will not be defined yet
# in modules that depend on UsbWrapper, like Usc.
Modules ?= $(UsbWrapper) $(Bytecode) $(Sequencer) $(Usc) $(UscCmd) $(MaestroAdvancedExample) $(MaestroEasyExample) $(Programmer) $(PgmCmd) $(Jrk) $(JrkCmd) $(JrkExample) $(Smc) $(SmcCmd) $(SmcExample1) $(SmcExample2) $(SmcG2) $(SmcG2Cmd) $(SmcG2Example1) $(SmcG2Example2)

# Standard library arguments needed to compile GUIs with Mono.
Mono_StandardLibs := \
	-r:System \
	-r:System.Core \
	-r:System.Data \
	-r:System.Drawing \
	-r:System.Windows.Forms

#### Standard targets ###########################################################

# Type `make clean` to remove all the files generated by make.
clean:
	@rm -fv `find -iname *.mdb`
	@rm -Rfv $(Byproducts)
	@rm -fv $(Targets)

# A generic rule for creating .resources files from .resx files.
%.resources: %.resx
	MONO_IOMAP=all resgen2 -usesourcepath $< $@

#### Load modules ###############################################################

# The modules will append to these lists.
Targets :=
Byproducts :=

# Include the module.mk files in to this make file.
include $(foreach module, $(Modules), $(module)/module.mk)

# Make a target that depends on all targets defined in each module, so you can
# type "make" or "make all" to make everything.
.DEFAULT_GOAL = all
all: $(Targets)
