OBJECT=main
OUTPUTFILE=$(OBJECT).ihx
SRCFILE=$(OBJECT).c

#Which files needed for this library:
LIBRARY_SOURCES=stm8s_gpio.c
LIBRARY_SOURCES+= stm8s_adc1.c

BUILD_FOLDER=build
BUILDDIR=./$(BUILD_FOLDER)/

# The macros are to keep the header files (which want to see a specific compiler and processor) happy.
# Change -DSTM8S103 to your specific device accoriding to the target device list found 
# in app_libs/STM8S_StdPeriph_Lib/Libraries/STM8S_StdPeriph_Driver/inc/stm8s.h
MACROS= -D__CSMC__ -DSTM8S103 
PROCTYPE= -lstm8 -mstm8 -o$(BUILDDIR)

STM8FLASH=stm8flash
PROCESSOR=stm8s103f3 # Change this to your specific device as listed when you run 'stm8flash -l'
DEBUGPROBE=stlinkv2  # Change this to your specific debug probe


#Name of library
LIBNAME=projectlib
LIBRARY=$(BUILDDIR)$(LIBNAME).lib

RELS=$(LIBRARY_SOURCES:.c=.rel)


SDCC=sdcc
SDAR=sdar

# Define pathS:
LIBROOT=./app_libs/STM8S_StdPeriph_Lib/Libraries/STM8S_StdPeriph_Driver
APPROOT=./app

INCLUDES=$(LIBROOT)/inc/
#Where source files are located:
SOURCEDIR=$(LIBROOT)/src/

CFLAGS= -I$(INCLUDES)
CFLAGS+= -I$(APPROOT)/include

SDARFLAGS= -rc --output=$(BUILDDIR)

#MAKEFILE_FULL_PATH:=${abspath ${lastword ${MAKEFILE_LIST}}}
SEPARATOR_CHRS=---------------------------------------------------------------------------------------

vpath %.c $(APPROOT)/src/
vpath %.c $(SOURCEDIR)

BUILD_FILES_TO_DELETE= *.rel *.cdb *.map *.lk *.rst *.sym *.lst *.asm *.ihx *.s19 *.hex *.lib

all: $(OUTPUTFILE)
	@echo ${SEPARATOR_CHRS}
	@echo 'Successfully made all :) '
	@echo ${SEPARATOR_CHRS}

$(OUTPUTFILE): $(LIBRARY) $(SRCFILE)

$(LIBRARY): $(LIBRARY_SOURCES)

%.lib: $(RELS)  
	$(SDAR) $(SDARFLAGS)  $@ $(foreach var,$(RELS), $(BUILDDIR)$(var))  

%.rel: %.c
	$(SDCC) $(MACROS) $(PROCTYPE) $(CFLAGS) -c $(LDFLAGS) $<

%.ihx: %.c
	$(SDCC) $(MACROS) $(PROCTYPE) $(CFLAGS) --out-fmt-ihx $(LDFLAGS) $< $(LIBRARY) -L $(BUILDDIR)
	$(SDCC) $(MACROS) $(PROCTYPE) $(CFLAGS) --out-fmt-s19 $(LDFLAGS) $< $(LIBRARY) -L $(BUILDDIR)

create_hex:
	@echo ${SEPARATOR_CHRS}
	@echo 'Creating .hex file ... '
	@echo ${SEPARATOR_CHRS}
	packihx $(BUILDDIR)$(OUTPUTFILE) > $(BUILDDIR)$(OBJECT).hex
	@echo ${SEPARATOR_CHRS}

flash: $(OUTPUTFILE)
	@make create_hex
	@echo ${SEPARATOR_CHRS}
	@echo 'Flashing ... '
	@echo ${SEPARATOR_CHRS}
	sudo $(STM8FLASH) -c$(DEBUGPROBE) -p$(PROCESSOR) -w $(BUILDDIR)$(OBJECT).hex
	@echo 'Flashing Successful :) '
	@echo ${SEPARATOR_CHRS}

flash-unlock: $(OUTPUTFILE)
	@make create_hex
	@echo ${SEPARATOR_CHRS}
	@echo 'Flash with Unlocking ... '
	@echo ${SEPARATOR_CHRS}
	sudo $(STM8FLASH) -c$(DEBUGPROBE) -p$(PROCESSOR) -w $(BUILDDIR)$(OBJECT).hex -u
	@echo ${SEPARATOR_CHRS}
	@echo 'Flash with Unlocking Successful :) '
	@echo ${SEPARATOR_CHRS}

delete_build_files_:
	@rm -f $(foreach var,$(BUILD_FILES_TO_DELETE), $(BUILD_FOLDER)/$(var))

delete_build_files_Windows_NT:
	@del $(foreach var,$(BUILD_FILES_TO_DELETE), $(BUILD_FOLDER)\$(var))

clean:
	@echo ${SEPARATOR_CHRS}
	@echo 'Deleting build files ... '
	@echo ${SEPARATOR_CHRS}
	@make delete_build_files_$(OS)
	@echo ${SEPARATOR_CHRS}
	@echo 'Build files deleted! '
	@echo ${SEPARATOR_CHRS}
	make all

