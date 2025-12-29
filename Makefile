OBJECT=main
OUTPUTFORMAT=s19   # s19, ihx
OUTPUTFILE=$(OBJECT).$(OUTPUTFORMAT)
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
OUTPUTTYPE=--out-fmt-$(OUTPUTFORMAT)

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



vpath %.c $(APPROOT)/src/
vpath %.c $(SOURCEDIR)

FILES_TO_CLEAN= *.rel *.cdb *.map *.lk *.rst *.sym *.lst *.asm *.ihx *.s19 *.hex *.lib

all: $(OUTPUTFILE)
	@echo "\nSuccessfully made all :) \n"

$(OUTPUTFILE): $(LIBRARY) $(SRCFILE)

$(LIBRARY): $(LIBRARY_SOURCES)

%.lib: $(RELS)  
	$(SDAR) $(SDARFLAGS)  $@ $(foreach var,$(RELS), $(BUILDDIR)$(var))  

%.rel: %.c
	$(SDCC) $(MACROS) $(PROCTYPE) $(CFLAGS) -c $(LDFLAGS) $<

%.$(OUTPUTFORMAT): %.c
	$(SDCC) $(MACROS) $(PROCTYPE) $(CFLAGS) $(OUTPUTTYPE) $(LDFLAGS) $< $(LIBRARY) -L $(BUILDDIR)

flash: $(OUTPUTFILE)
	@echo "\nCreating .hex file ...\n"
	packihx $(BUILDDIR)$(OUTPUTFILE) > $(BUILDDIR)$(OBJECT).hex
	@echo "\nFlashing ...\n"
	sudo $(STM8FLASH) -c$(DEBUGPROBE) -p$(PROCESSOR) -w $(BUILDDIR)$(OBJECT).hex
	@echo "\nFlashing Successful :) \n"

flash-unlock: $(OUTPUTFILE)
	@echo "\nCreating .hex file ...\n"
	packihx $(BUILDDIR)$(OUTPUTFILE) > $(BUILDDIR)$(OBJECT).hex
	@echo "\nUnlocking ...\n"
	$(STM8FLASH) -c$(DEBUGPROBE) -p$(PROCESSOR) -w $(BUILDDIR)$(OBJECT).hex -u
	@echo "\nUnlocking Successful :) \n"

clean:
	@echo "\nCleaning ..."
	@rm -f $(foreach var,$(FILES_TO_CLEAN), $(BUILD_FOLDER)/$(var))
	@echo "Cleaning Done :) \n"
	make all

clean_ms:
	@echo "\nCleaning ..."
	@del $(foreach var,$(FILES_TO_CLEAN), $(BUILD_FOLDER)\$(var))
	@echo "Cleaning Done :) \n"
	make all

