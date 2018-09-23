SOURCES = ./src/
OUTPUT = ./build/
OUTPUT2 = .\\build\\
TOOLPATH = ./tools/
INCPATH  = $(SOURCES)/syslibs/

MAKE     = $(TOOLPATH)make.exe -r
NASK     = $(TOOLPATH)nask.exe
CC1      = $(TOOLPATH)cc1.exe -I $(INCPATH) -Os -Wall -quiet
GAS2NASK = $(TOOLPATH)gas2nask.exe -a
OBJ2BIM  = $(TOOLPATH)obj2bim.exe
BIM2HRB  = $(TOOLPATH)bim2hrb.exe
RULEFILE = $(INCPATH)haribote.rul
EDIMG    = $(TOOLPATH)edimg.exe
IMGTOL   = $(TOOLPATH)imgtol.com
COPY     = copy
DEL      = del

default : 
	$(MAKE) $(OUTPUT)longos.img

$(OUTPUT)ipl.bin : $(SOURCES)ipl10.nas Makefile
	$(NASK) $(SOURCES)ipl10.nas $(OUTPUT)ipl.bin $(OUTPUT)ipl.lst

$(OUTPUT)asmhead.bin : $(SOURCES)asmhead.nas Makefile
	$(NASK) $(SOURCES)asmhead.nas $(OUTPUT)asmhead.bin $(OUTPUT)asmhead.lst

$(OUTPUT)bootpack.gas : $(SOURCES)bootpack.c Makefile
	$(CC1) -o $(OUTPUT)bootpack.gas $(SOURCES)bootpack.c

$(OUTPUT)bootpack.nas : $(OUTPUT)bootpack.gas Makefile
	$(GAS2NASK) $(OUTPUT)bootpack.gas $(OUTPUT)bootpack.nas
	

$(OUTPUT)bootpack.obj : $(OUTPUT)bootpack.nas Makefile
	$(NASK) $(OUTPUT)bootpack.nas $(OUTPUT)bootpack.obj $(OUTPUT)bootpack.lst
	
$(OUTPUT)naskfunc.obj : $(SOURCES)naskfunc.nas Makefile
	$(NASK) $(SOURCES)naskfunc.nas $(OUTPUT)naskfunc.obj $(OUTPUT)naskfunc.lst

$(OUTPUT)bootpack.bim : $(OUTPUT)bootpack.obj $(OUTPUT)naskfunc.obj Makefile
	$(OBJ2BIM) @$(RULEFILE) out:$(OUTPUT)bootpack.bim stack:3136k map:$(OUTPUT)bootpack.map \
		$(OUTPUT)bootpack.obj $(OUTPUT)naskfunc.obj
# 3MB+64KB=3136KB

$(OUTPUT)bootpack.hrb : $(OUTPUT)bootpack.bim Makefile
	$(BIM2HRB) $(OUTPUT)bootpack.bim $(OUTPUT)bootpack.hrb 0

$(OUTPUT)haribote.sys : $(OUTPUT)asmhead.bin $(OUTPUT)bootpack.hrb Makefile
	copy /b $(OUTPUT2)asmhead.bin+$(OUTPUT2)bootpack.hrb $(OUTPUT2)haribote.sys

$(OUTPUT)longos.img : $(OUTPUT)ipl.bin $(OUTPUT)haribote.sys Makefile
	edimg imgin:$(SOURCES)template.img wbinimg src:$(OUTPUT)ipl.bin len:512 from:0 to:0 copy from:$(OUTPUT)haribote.sys to:@: imgout:$(OUTPUT)longos.img
	
	
clean :
	-$(DEL) $(OUTPUT2)*.*