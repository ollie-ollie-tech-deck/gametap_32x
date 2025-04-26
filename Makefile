# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

OUT_ROM                    := gametap.32x
REFRESH_RATE               := 60

# ------------------------------------------------------------------------------
# Folder paths
# ------------------------------------------------------------------------------

BUILD_PATH                 := build
SRC_PATH                   := src
OBJ_PATH                   := $(BUILD_PATH)/.obj
BUILD_PATH_EXISTS          := $(wildcard $(BUILD_PATH))

# ------------------------------------------------------------------------------
# Tools
# ------------------------------------------------------------------------------

ASM68K                     := @asm68k
ASMSH                      := @asmsh
AS                         := @asw
P2BIN                      := @p2bin
MAKE_PSYLINK               := @make_psylink_file
PSYLINK                    := @psylink
MAKE_DEPEND                := @make_asm_depend
MDROMFIX                   := @mdromfix

# ------------------------------------------------------------------------------
# Flags
# ------------------------------------------------------------------------------

ASM68K_FLAGS               := /q /e REFRESH_RATE=$(REFRESH_RATE) /k /l /o l.,m+,ae-,op+,os+,ow+,oz+,oaq+,osq+,omq+
ASMSH_FLAGS                := /q /e REFRESH_RATE=$(REFRESH_RATE) /k /l /o psh2,\\\#+,l.,m+
AS_FLAGS                   := -q -xx -n -A -L -U -i ..
P2BIN_FLAGS                := -q
PSYLINK_FLAGS              := /q

# ------------------------------------------------------------------------------
# Messages
# ------------------------------------------------------------------------------

ASSEMBLE_MSG                = @echo Assembling $<
BUILD_MSG                   = @echo Building   $@
MAKING_DEPENDS              = @echo Generating $@

# ------------------------------------------------------------------------------
# Source folder paths
# ------------------------------------------------------------------------------

SRC_PATH_FRAMEWORK         := $(SRC_PATH)/framework
SRC_PATH_Z80               := $(SRC_PATH_FRAMEWORK)/z80
SRC_PATH_FRAMEWORK_MD      := $(SRC_PATH_FRAMEWORK)/md
SRC_PATH_FRAMEWORK_MARS    := $(SRC_PATH_FRAMEWORK)/mars
SRC_PATH_COMMON            := $(SRC_PATH)/common
SRC_PATH_COMMON_DATA       := $(SRC_PATH_COMMON)/data
SRC_PATH_SOUND_DATA        := $(SRC_PATH)/sound
SRC_PATH_SPLASH            := $(SRC_PATH)/splash
SRC_PATH_SPLASH_DATA       := $(SRC_PATH_SPLASH)/data
SRC_PATH_TITLE             := $(SRC_PATH)/title
SRC_PATH_TITLE_DATA        := $(SRC_PATH_TITLE)/data
SRC_PATH_TITLE_MAPS        := $(SRC_PATH_TITLE)/maps
SRC_PATH_SONIC             := $(SRC_PATH)/sonic
SRC_PATH_SONIC_OBJECTS     := $(SRC_PATH_SONIC)/objects
SRC_PATH_SONIC_DATA        := $(SRC_PATH_SONIC)/data
SRC_PATH_SONIC_MAPS        := $(SRC_PATH_SONIC)/maps
SRC_PATH_RPG               := $(SRC_PATH)/rpg
SRC_PATH_RPG_DATA          := $(SRC_PATH_RPG)/data
SRC_PATH_RPG_MAPS          := $(SRC_PATH_RPG)/maps
SRC_PATH_RPG_OBJECTS       := $(SRC_PATH_RPG)/objects
SRC_PATH_CREDITS           := $(SRC_PATH)/credits
SRC_PATH_CREDITS_DATA      := $(SRC_PATH_CREDITS)/data

OBJ_PATH_Z80               := $(subst $(SRC_PATH),$(OBJ_PATH),$(SRC_PATH_Z80))
OBJ_PATH_FRAMEWORK_MD      := $(subst $(SRC_PATH),$(OBJ_PATH),$(SRC_PATH_FRAMEWORK_MD))
OBJ_PATH_FRAMEWORK_MARS    := $(subst $(SRC_PATH),$(OBJ_PATH),$(SRC_PATH_FRAMEWORK_MARS))
OBJ_PATH_COMMON            := $(subst $(SRC_PATH),$(OBJ_PATH),$(SRC_PATH_COMMON))
OBJ_PATH_COMMON_DATA       := $(subst $(SRC_PATH),$(OBJ_PATH),$(SRC_PATH_COMMON_DATA))
OBJ_PATH_SOUND_DATA        := $(subst $(SRC_PATH),$(OBJ_PATH),$(SRC_PATH_SOUND_DATA))
OBJ_PATH_SPLASH            := $(subst $(SRC_PATH),$(OBJ_PATH),$(SRC_PATH_SPLASH))
OBJ_PATH_SPLASH_DATA       := $(subst $(SRC_PATH),$(OBJ_PATH),$(SRC_PATH_SPLASH_DATA))
OBJ_PATH_TITLE             := $(subst $(SRC_PATH),$(OBJ_PATH),$(SRC_PATH_TITLE))
OBJ_PATH_TITLE_DATA        := $(subst $(SRC_PATH),$(OBJ_PATH),$(SRC_PATH_TITLE_DATA))
OBJ_PATH_TITLE_MAPS        := $(subst $(SRC_PATH),$(OBJ_PATH),$(SRC_PATH_TITLE_MAPS))
OBJ_PATH_SONIC             := $(subst $(SRC_PATH),$(OBJ_PATH),$(SRC_PATH_SONIC))
OBJ_PATH_SONIC_OBJECTS     := $(subst $(SRC_PATH),$(OBJ_PATH),$(SRC_PATH_SONIC_OBJECTS))
OBJ_PATH_SONIC_DATA        := $(subst $(SRC_PATH),$(OBJ_PATH),$(SRC_PATH_SONIC_DATA))
OBJ_PATH_SONIC_MAPS        := $(subst $(SRC_PATH),$(OBJ_PATH),$(SRC_PATH_SONIC_MAPS))
OBJ_PATH_RPG               := $(subst $(SRC_PATH),$(OBJ_PATH),$(SRC_PATH_RPG))
OBJ_PATH_RPG_DATA          := $(subst $(SRC_PATH),$(OBJ_PATH),$(SRC_PATH_RPG_DATA))
OBJ_PATH_RPG_MAPS          := $(subst $(SRC_PATH),$(OBJ_PATH),$(SRC_PATH_RPG_MAPS))
OBJ_PATH_RPG_OBJECTS       := $(subst $(SRC_PATH),$(OBJ_PATH),$(SRC_PATH_RPG_OBJECTS))
OBJ_PATH_CREDITS           := $(subst $(SRC_PATH),$(OBJ_PATH),$(SRC_PATH_CREDITS))
OBJ_PATH_CREDITS_DATA      := $(subst $(SRC_PATH),$(OBJ_PATH),$(SRC_PATH_CREDITS_DATA))

# ------------------------------------------------------------------------------
# Z80 sound driver files
# ------------------------------------------------------------------------------

SRC_Z80                    := $(SRC_PATH_Z80)/program.asm
OBJ_Z80                    := $(patsubst $(SRC_PATH)/%.asm,$(OBJ_PATH)/%.p,$(SRC_Z80))
DEPEND_Z80                 := $(patsubst %.p,%.d,$(OBJ_Z80))

SRC_Z80_REPORT             := $(SRC_PATH_Z80)/report.asm
OBJ_Z80_REPORT             := $(patsubst $(SRC_PATH)/%.asm,$(OBJ_PATH)/%.o,$(SRC_Z80_REPORT))

# ------------------------------------------------------------------------------
# Framework files
# ------------------------------------------------------------------------------

SRC_FRAMEWORK_MD           := $(wildcard $(SRC_PATH_FRAMEWORK_MD)/*.asm)
SRC_FRAMEWORK_MD           := $(filter-out $(SRC_PATH_FRAMEWORK_MD)/report.asm, $(SRC_FRAMEWORK_MD))
OBJ_FRAMEWORK_MD           := $(patsubst $(SRC_PATH)/%.asm,$(OBJ_PATH)/%.o,$(SRC_FRAMEWORK_MD))
DEPEND_FRAMEWORK_MD        := $(patsubst %.o,%.d,$(OBJ_FRAMEWORK_MD))

SRC_MD_REPORT              := $(SRC_PATH_FRAMEWORK_MD)/report.asm
OBJ_MD_REPORT              := $(patsubst $(SRC_PATH)/%.asm,$(OBJ_PATH)/%.o,$(SRC_MD_REPORT))

SRC_FRAMEWORK_MARS         := $(wildcard $(SRC_PATH_FRAMEWORK_MARS)/*.asm)
SRC_FRAMEWORK_MARS         := $(filter-out $(SRC_PATH_FRAMEWORK_MARS)/report.asm, $(SRC_FRAMEWORK_MARS))
OBJ_FRAMEWORK_MARS         := $(patsubst $(SRC_PATH)/%.asm,$(OBJ_PATH)/%.o,$(SRC_FRAMEWORK_MARS))
DEPEND_FRAMEWORK_MARS      := $(patsubst %.o,%.d,$(OBJ_FRAMEWORK_MARS))

SRC_MARS_REPORT            := $(SRC_PATH_FRAMEWORK_MARS)/report.asm
OBJ_MARS_REPORT            := $(patsubst $(SRC_PATH)/%.asm,$(OBJ_PATH)/%.o,$(SRC_MARS_REPORT))

# ------------------------------------------------------------------------------
# Common code/data files
# ------------------------------------------------------------------------------

SRC_COMMON                 := $(wildcard $(SRC_PATH)/*.asm) \
                              $(wildcard $(SRC_PATH_COMMON)/*.asm)
OBJ_COMMON                 := $(patsubst $(SRC_PATH)/%.asm,$(OBJ_PATH)/%.o,$(SRC_COMMON))
DEPEND_COMMON              := $(patsubst %.o,%.d,$(OBJ_COMMON))

SRC_COMMON_DATA_MD         := $(SRC_PATH_COMMON_DATA)/md.asm
OBJ_COMMON_DATA_MD         := $(patsubst $(SRC_PATH)/%.asm,$(OBJ_PATH)/%.o,$(SRC_COMMON_DATA_MD))
DEPEND_COMMON_DATA_MD      := $(patsubst %.o,%.d,$(OBJ_COMMON_DATA_MD))

SRC_COMMON_DATA_MARS       := $(SRC_PATH_COMMON_DATA)/mars.asm
OBJ_COMMON_DATA_MARS       := $(patsubst $(SRC_PATH)/%.asm,$(OBJ_PATH)/%.o,$(SRC_COMMON_DATA_MARS))
DEPEND_COMMON_DATA_MARS    := $(patsubst %.o,%.d,$(OBJ_COMMON_DATA_MARS))

# ------------------------------------------------------------------------------
# Sound data files
# ------------------------------------------------------------------------------

SRC_SOUND_DATA             := $(SRC_PATH_SOUND_DATA)/sound_data.asm
OBJ_SOUND_DATA             := $(patsubst $(SRC_PATH)/%.asm,$(OBJ_PATH)/%.o,$(SRC_SOUND_DATA))
DEPEND_SOUND_DATA          := $(patsubst %.o,%.d,$(OBJ_SOUND_DATA))

SRC_PWM_SAMPLES            := $(SRC_PATH_SOUND_DATA)/pwm_samples.asm
OBJ_PWM_SAMPLES            := $(patsubst $(SRC_PATH)/%.asm,$(OBJ_PATH)/%.o,$(SRC_PWM_SAMPLES))
DEPEND_PWM_SAMPLES         := $(patsubst %.o,%.d,$(OBJ_PWM_SAMPLES))

# ------------------------------------------------------------------------------
# Splash screen files
# ------------------------------------------------------------------------------

SRC_SPLASH                 := $(wildcard $(SRC_PATH_SPLASH)/*.asm)
SRC_SPLASH                 := $(filter-out $(SRC_PATH_SPLASH)/report.asm, $(SRC_SPLASH))
OBJ_SPLASH                 := $(patsubst $(SRC_PATH)/%.asm,$(OBJ_PATH)/%.o,$(SRC_SPLASH))
DEPEND_SPLASH              := $(patsubst %.o,%.d,$(OBJ_SPLASH))

SRC_SPLASH_DATA_MD         := $(SRC_PATH_SPLASH_DATA)/md.asm
OBJ_SPLASH_DATA_MD         := $(patsubst $(SRC_PATH)/%.asm,$(OBJ_PATH)/%.o,$(SRC_SPLASH_DATA_MD))
DEPEND_SPLASH_DATA_MD      := $(patsubst %.o,%.d,$(OBJ_SPLASH_DATA_MD))

SRC_SPLASH_DATA_MARS       := $(SRC_PATH_SPLASH_DATA)/mars.asm
OBJ_SPLASH_DATA_MARS       := $(patsubst $(SRC_PATH)/%.asm,$(OBJ_PATH)/%.o,$(SRC_SPLASH_DATA_MARS))
DEPEND_SPLASH_DATA_MARS    := $(patsubst %.o,%.d,$(OBJ_SPLASH_DATA_MARS))

# ------------------------------------------------------------------------------
# Title screen files
# ------------------------------------------------------------------------------

SRC_TITLE                  := $(wildcard $(SRC_PATH_TITLE)/*.asm)
SRC_TITLE                  := $(filter-out $(SRC_PATH_TITLE)/report.asm, $(SRC_TITLE))
OBJ_TITLE                  := $(patsubst $(SRC_PATH)/%.asm,$(OBJ_PATH)/%.o,$(SRC_TITLE))
DEPEND_TITLE               := $(patsubst %.o,%.d,$(OBJ_TITLE))

SRC_TITLE_DATA_MD          := $(SRC_PATH_TITLE_DATA)/md.asm
OBJ_TITLE_DATA_MD          := $(patsubst $(SRC_PATH)/%.asm,$(OBJ_PATH)/%.o,$(SRC_TITLE_DATA_MD))
DEPEND_TITLE_DATA_MD       := $(patsubst %.o,%.d,$(OBJ_TITLE_DATA_MD))

SRC_TITLE_DATA_MARS        := $(SRC_PATH_TITLE_DATA)/mars.asm
OBJ_TITLE_DATA_MARS        := $(patsubst $(SRC_PATH)/%.asm,$(OBJ_PATH)/%.o,$(SRC_TITLE_DATA_MARS))
DEPEND_TITLE_DATA_MARS     := $(patsubst %.o,%.d,$(OBJ_TITLE_DATA_MARS))

SRC_TITLE_MAPS             := $(SRC_PATH_TITLE_MAPS)/maps.asm
OBJ_TITLE_MAPS             := $(patsubst $(SRC_PATH)/%.asm,$(OBJ_PATH)/%.o,$(SRC_TITLE_MAPS))
DEPEND_TITLE_MAPS          := $(patsubst %.o,%.d,$(OBJ_TITLE_MAPS))

# ------------------------------------------------------------------------------
# Sonic mode files
# ------------------------------------------------------------------------------

SRC_SONIC                  := $(wildcard $(SRC_PATH_SONIC)/*.asm) \
                              $(wildcard $(SRC_PATH_SONIC_OBJECTS)/*.asm) \
                              $(SRC_PATH_SONIC_MAPS)/routines.asm
SRC_SONIC                  := $(filter-out $(SRC_PATH_SONIC)/report.asm, $(SRC_SONIC))
OBJ_SONIC                  := $(patsubst $(SRC_PATH)/%.asm,$(OBJ_PATH)/%.o,$(SRC_SONIC))
DEPEND_SONIC               := $(patsubst %.o,%.d,$(OBJ_SONIC))

SRC_SONIC_DATA_MD          := $(SRC_PATH_SONIC_DATA)/md.asm
OBJ_SONIC_DATA_MD          := $(patsubst $(SRC_PATH)/%.asm,$(OBJ_PATH)/%.o,$(SRC_SONIC_DATA_MD))
DEPEND_SONIC_DATA_MD       := $(patsubst %.o,%.d,$(OBJ_SONIC_DATA_MD))

SRC_SONIC_DATA_MARS        := $(SRC_PATH_SONIC_DATA)/mars.asm
OBJ_SONIC_DATA_MARS        := $(patsubst $(SRC_PATH)/%.asm,$(OBJ_PATH)/%.o,$(SRC_SONIC_DATA_MARS))
DEPEND_SONIC_DATA_MARS     := $(patsubst %.o,%.d,$(OBJ_SONIC_DATA_MARS))

SRC_SONIC_MAPS             := $(SRC_PATH_SONIC_MAPS)/maps.asm
OBJ_SONIC_MAPS             := $(patsubst $(SRC_PATH)/%.asm,$(OBJ_PATH)/%.o,$(SRC_SONIC_MAPS))
DEPEND_SONIC_MAPS          := $(patsubst %.o,%.d,$(OBJ_SONIC_MAPS))

# ------------------------------------------------------------------------------
# RPG mode files
# ------------------------------------------------------------------------------

SRC_RPG                    := $(wildcard $(SRC_PATH_RPG)/*.asm) \
                              $(wildcard $(SRC_PATH_RPG_OBJECTS)/*.asm) \
                              $(SRC_PATH_RPG_MAPS)/routines.asm
SRC_RPG                    := $(filter-out $(SRC_PATH_RPG)/report.asm, $(SRC_RPG))
OBJ_RPG                    := $(patsubst $(SRC_PATH)/%.asm,$(OBJ_PATH)/%.o,$(SRC_RPG))
DEPEND_RPG                 := $(patsubst %.o,%.d,$(OBJ_RPG))

SRC_RPG_DATA_MD            := $(SRC_PATH_RPG_DATA)/md.asm
OBJ_RPG_DATA_MD            := $(patsubst $(SRC_PATH)/%.asm,$(OBJ_PATH)/%.o,$(SRC_RPG_DATA_MD))
DEPEND_RPG_DATA_MD         := $(patsubst %.o,%.d,$(OBJ_RPG_DATA_MD))

SRC_RPG_DATA_MARS          := $(SRC_PATH_RPG_DATA)/mars.asm
OBJ_RPG_DATA_MARS          := $(patsubst $(SRC_PATH)/%.asm,$(OBJ_PATH)/%.o,$(SRC_RPG_DATA_MARS))
DEPEND_RPG_DATA_MARS       := $(patsubst %.o,%.d,$(OBJ_RPG_DATA_MARS))

SRC_RPG_MAPS               := $(SRC_PATH_RPG_MAPS)/maps.asm
OBJ_RPG_MAPS               := $(patsubst $(SRC_PATH)/%.asm,$(OBJ_PATH)/%.o,$(SRC_RPG_MAPS))
DEPEND_RPG_MAPS            := $(patsubst %.o,%.d,$(OBJ_RPG_MAPS))

# ------------------------------------------------------------------------------
# Credits files
# ------------------------------------------------------------------------------

SRC_CREDITS                := $(wildcard $(SRC_PATH_CREDITS)/*.asm)
SRC_CREDITS                := $(filter-out $(SRC_PATH_CREDITS)/report.asm, $(SRC_CREDITS))
OBJ_CREDITS                := $(patsubst $(SRC_PATH)/%.asm,$(OBJ_PATH)/%.o,$(SRC_CREDITS))
DEPEND_CREDITS             := $(patsubst %.o,%.d,$(OBJ_CREDITS))

SRC_CREDITS_DATA_MARS      := $(SRC_PATH_CREDITS_DATA)/mars.asm
OBJ_CREDITS_DATA_MARS      := $(patsubst $(SRC_PATH)/%.asm,$(OBJ_PATH)/%.o,$(SRC_CREDITS_DATA_MARS))

# ------------------------------------------------------------------------------
# Game report files
# ------------------------------------------------------------------------------

SRC_GAME_REPORT            := $(SRC_PATH_TITLE)/report.asm \
                              $(SRC_PATH_SPLASH)/report.asm \
                              $(SRC_PATH_SONIC)/report.asm \
                              $(SRC_PATH_RPG)/report.asm \
                              $(SRC_PATH_CREDITS)/report.asm
OBJ_GAME_REPORT            := $(patsubst $(SRC_PATH)/%.asm,$(OBJ_PATH)/%.o,$(SRC_GAME_REPORT))
DEPEND_CREDITS_DATA_MARS   := $(patsubst %.o,%.d,$(OBJ_CREDITS_DATA_MARS))

# ------------------------------------------------------------------------------
# Object files
# ------------------------------------------------------------------------------

OBJ_FILES                  := $(OBJ_FRAMEWORK_MD) \
                              $(OBJ_FRAMEWORK_MARS) \
                              $(OBJ_COMMON) \
                              $(OBJ_COMMON_DATA_MD) \
                              $(OBJ_COMMON_DATA_MARS) \
                              $(OBJ_SOUND_DATA) \
                              $(OBJ_PWM_SAMPLES) \
                              $(OBJ_SPLASH) \
                              $(OBJ_SPLASH_DATA_MD) \
                              $(OBJ_SPLASH_DATA_MARS) \
                              $(OBJ_TITLE) \
                              $(OBJ_TITLE_DATA_MD) \
                              $(OBJ_TITLE_DATA_MARS) \
                              $(OBJ_TITLE_MAPS) \
                              $(OBJ_SONIC) \
                              $(OBJ_SONIC_DATA_MD) \
                              $(OBJ_SONIC_DATA_MARS) \
                              $(OBJ_SONIC_MAPS) \
                              $(OBJ_RPG) \
                              $(OBJ_RPG_DATA_MD) \
                              $(OBJ_RPG_DATA_MARS) \
                              $(OBJ_RPG_MAPS) \
                              $(OBJ_CREDITS) \
                              $(OBJ_CREDITS_DATA_MARS)

OBJ_REPORT_FILES           := $(OBJ_MD_REPORT) \
                              $(OBJ_MARS_REPORT) \
			      $(OBJ_Z80_REPORT) \
			      $(OBJ_GAME_REPORT)

# ------------------------------------------------------------------------------
# Reserved rules
# ------------------------------------------------------------------------------

.PHONY: all clean

# ------------------------------------------------------------------------------
# Compile everything together
# ------------------------------------------------------------------------------

all: $(BUILD_PATH)/$(OUT_ROM) $(OBJ_REPORT_FILES)

# ------------------------------------------------------------------------------
# Clean
# ------------------------------------------------------------------------------

clean:
ifneq ($(BUILD_PATH_EXISTS),)
	@rmdir /s /q "$(BUILD_PATH)"
endif

# ------------------------------------------------------------------------------
# Report rules
# ------------------------------------------------------------------------------

$(OBJ_MD_REPORT): $(OBJ_PATH)/%.o: $(SRC_PATH)/%.asm
	$(ASM68K) $(ASM68K_FLAGS) $<,$@
	@del "$(subst /,\,$@)"

$(OBJ_MARS_REPORT): $(OBJ_PATH)/%.o: $(SRC_PATH)/%.asm
	$(ASMSH) $(ASMSH_FLAGS) $<,$@
	@del "$(subst /,\,$@)"

$(OBJ_Z80_REPORT): $(OBJ_PATH)/%.o: $(SRC_PATH)/%.asm
	$(ASM68K) $(ASM68K_FLAGS) $<,$@
	@del "$(subst /,\,$@)"

$(OBJ_GAME_REPORT): $(OBJ_PATH)/%.o: $(SRC_PATH)/%.asm
	$(ASM68K) $(ASM68K_FLAGS) $<,$@
	@del "$(subst /,\,$@)"

# ------------------------------------------------------------------------------
# ROM rules
# ------------------------------------------------------------------------------

$(BUILD_PATH)/$(OUT_ROM): $(OBJ_FILES) | $(BUILD_PATH) $(OBJ_PATH) $(BUILD_PATH)/z80.bin
	$(BUILD_MSG)
	$(MAKE_PSYLINK) -c linker.link -o $(BUILD_PATH)/linker.link $^
	$(PSYLINK) $(PSYLINK_FLAGS) /p @$(BUILD_PATH)/linker.link,$@
	$(MDROMFIX) $@

# ------------------------------------------------------------------------------
# Z80 sound driver rules
# ------------------------------------------------------------------------------

$(BUILD_PATH)/z80.bin: $(OBJ_Z80) | $(BUILD_PATH)
	$(P2BIN) $(P2BIN_FLAGS) $< $@

$(OBJ_Z80): $(OBJ_PATH)/%.p: $(SRC_PATH)/%.asm | $(DEPEND_Z80)
	$(ASSEMBLE_MSG)
	$(AS) $(AS_FLAGS) $< -o $@ -olist $(patsubst %.p,%.lst,$@)

$(DEPEND_Z80): $(OBJ_PATH)/%.d: $(SRC_PATH)/%.asm | $(OBJ_PATH_Z80)
	$(MAKING_DEPENDS)
	$(MAKE_DEPEND) -r -o $@ $(patsubst %.d,%.p,$@) $<

# ------------------------------------------------------------------------------
# Framework rules
# ------------------------------------------------------------------------------

$(OBJ_FRAMEWORK_MD): $(OBJ_PATH)/%.o: $(SRC_PATH)/%.asm | $(BUILD_PATH)/z80.bin $(DEPEND_FRAMEWORK_MD)
	$(ASSEMBLE_MSG)
	$(ASM68K) $(ASM68K_FLAGS) $<,$@,,$(patsubst %.o,%.lst,$@)

$(DEPEND_FRAMEWORK_MD): $(OBJ_PATH)/%.d: $(SRC_PATH)/%.asm | $(OBJ_PATH_FRAMEWORK_MD)
	$(MAKING_DEPENDS)
	$(MAKE_DEPEND) -o $@ $(patsubst %.d,%.o,$@) $<

$(OBJ_FRAMEWORK_MARS): $(OBJ_PATH)/%.o: $(SRC_PATH)/%.asm | $(DEPEND_FRAMEWORK_MARS)
	$(ASSEMBLE_MSG)
	$(ASMSH) $(ASMSH_FLAGS) $<,$@,,$(patsubst %.o,%.lst,$@)

$(DEPEND_FRAMEWORK_MARS): $(OBJ_PATH)/%.d: $(SRC_PATH)/%.asm | $(OBJ_PATH_FRAMEWORK_MARS)
	$(MAKING_DEPENDS)
	$(MAKE_DEPEND) -o $@ $(patsubst %.d,%.o,$@) $<

# ------------------------------------------------------------------------------
# Common code/data rules
# ------------------------------------------------------------------------------

$(OBJ_COMMON): $(OBJ_PATH)/%.o: $(SRC_PATH)/%.asm | $(DEPEND_COMMON)
	$(ASSEMBLE_MSG)
	$(ASM68K) $(ASM68K_FLAGS) $<,$@,,$(patsubst %.o,%.lst,$@)

$(DEPEND_COMMON): $(OBJ_PATH)/%.d: $(SRC_PATH)/%.asm | $(OBJ_PATH_COMMON)
	$(MAKING_DEPENDS)
	$(MAKE_DEPEND) -o $@ $(patsubst %.d,%.o,$@) $<

$(OBJ_COMMON_DATA_MD): $(OBJ_PATH)/%.o: $(SRC_PATH)/%.asm | $(DEPEND_COMMON_DATA_MD)
	$(ASSEMBLE_MSG)
	$(ASM68K) $(ASM68K_FLAGS) $<,$@,,$(patsubst %.o,%.lst,$@)

$(DEPEND_COMMON_DATA_MD): $(OBJ_PATH)/%.d: $(SRC_PATH)/%.asm | $(OBJ_PATH_COMMON_DATA)
	$(MAKING_DEPENDS)
	$(MAKE_DEPEND) -o $@ $(patsubst %.d,%.o,$@) $<

$(OBJ_COMMON_DATA_MARS): $(OBJ_PATH)/%.o: $(SRC_PATH)/%.asm | $(DEPEND_COMMON_DATA_MARS)
	$(ASSEMBLE_MSG)
	$(ASMSH) $(ASMSH_FLAGS) $<,$@,,$(patsubst %.o,%.lst,$@)

$(DEPEND_COMMON_DATA_MARS): $(OBJ_PATH)/%.d: $(SRC_PATH)/%.asm | $(OBJ_PATH_COMMON_DATA)
	$(MAKING_DEPENDS)
	$(MAKE_DEPEND) -o $@ $(patsubst %.d,%.o,$@) $<

# ------------------------------------------------------------------------------
# Sound data rules
# ------------------------------------------------------------------------------

$(OBJ_SOUND_DATA): $(OBJ_PATH)/%.o: $(SRC_PATH)/%.asm | $(DEPEND_SOUND_DATA)
	$(ASSEMBLE_MSG)
	$(ASM68K) $(ASM68K_FLAGS) $<,$@,,$(patsubst %.o,%.lst,$@)

$(DEPEND_SOUND_DATA): $(OBJ_PATH)/%.d: $(SRC_PATH)/%.asm | $(OBJ_PATH_SOUND_DATA)
	$(MAKING_DEPENDS)
	$(MAKE_DEPEND) -o $@ $(patsubst %.d,%.o,$@) $<

$(OBJ_PWM_SAMPLES): $(OBJ_PATH)/%.o: $(SRC_PATH)/%.asm | $(DEPEND_PWM_SAMPLES)
	$(ASSEMBLE_MSG)
	$(ASMSH) $(ASMSH_FLAGS) $<,$@,,$(patsubst %.o,%.lst,$@)

$(DEPEND_PWM_SAMPLES): $(OBJ_PATH)/%.d: $(SRC_PATH)/%.asm | $(OBJ_PATH_SOUND_DATA)
	$(MAKING_DEPENDS)
	$(MAKE_DEPEND) -o $@ $(patsubst %.d,%.o,$@) $<

# ------------------------------------------------------------------------------
# Splash screens rules
# ------------------------------------------------------------------------------

$(OBJ_SPLASH): $(OBJ_PATH)/%.o: $(SRC_PATH)/%.asm | $(DEPEND_SPLASH)
	$(ASSEMBLE_MSG)
	$(ASM68K) $(ASM68K_FLAGS) $<,$@,,$(patsubst %.o,%.lst,$@)

$(DEPEND_SPLASH): $(OBJ_PATH)/%.d: $(SRC_PATH)/%.asm | $(OBJ_PATH_SPLASH)
	$(MAKING_DEPENDS)
	$(MAKE_DEPEND) -o $@ $(patsubst %.d,%.o,$@) $<

$(OBJ_SPLASH_DATA_MD): $(OBJ_PATH)/%.o: $(SRC_PATH)/%.asm | $(DEPEND_SPLASH_DATA_MD)
	$(ASSEMBLE_MSG)
	$(ASM68K) $(ASM68K_FLAGS) $<,$@,,$(patsubst %.o,%.lst,$@)

$(DEPEND_SPLASH_DATA_MD): $(OBJ_PATH)/%.d: $(SRC_PATH)/%.asm | $(OBJ_PATH_SPLASH_DATA)
	$(MAKING_DEPENDS)
	$(MAKE_DEPEND) -o $@ $(patsubst %.d,%.o,$@) $<

$(OBJ_SPLASH_DATA_MARS): $(OBJ_PATH)/%.o: $(SRC_PATH)/%.asm | $(DEPEND_SPLASH_DATA_MARS)
	$(ASSEMBLE_MSG)
	$(ASMSH) $(ASMSH_FLAGS) $<,$@,,$(patsubst %.o,%.lst,$@)

$(DEPEND_SPLASH_DATA_MARS): $(OBJ_PATH)/%.d: $(SRC_PATH)/%.asm | $(OBJ_PATH_SPLASH_DATA)
	$(MAKING_DEPENDS)
	$(MAKE_DEPEND) -o $@ $(patsubst %.d,%.o,$@) $<

# ------------------------------------------------------------------------------
# Title screen rules
# ------------------------------------------------------------------------------

$(OBJ_TITLE): $(OBJ_PATH)/%.o: $(SRC_PATH)/%.asm | $(DEPEND_TITLE)
	$(ASSEMBLE_MSG)
	$(ASM68K) $(ASM68K_FLAGS) $<,$@,,$(patsubst %.o,%.lst,$@)

$(DEPEND_TITLE): $(OBJ_PATH)/%.d: $(SRC_PATH)/%.asm | $(OBJ_PATH_TITLE)
	$(MAKING_DEPENDS)
	$(MAKE_DEPEND) -o $@ $(patsubst %.d,%.o,$@) $<

$(OBJ_TITLE_DATA_MD): $(OBJ_PATH)/%.o: $(SRC_PATH)/%.asm | $(DEPEND_TITLE_DATA_MD)
	$(ASSEMBLE_MSG)
	$(ASM68K) $(ASM68K_FLAGS) $<,$@,,$(patsubst %.o,%.lst,$@)

$(DEPEND_TITLE_DATA_MD): $(OBJ_PATH)/%.d: $(SRC_PATH)/%.asm | $(OBJ_PATH_TITLE_DATA)
	$(MAKING_DEPENDS)
	$(MAKE_DEPEND) -o $@ $(patsubst %.d,%.o,$@) $<

$(OBJ_TITLE_DATA_MARS): $(OBJ_PATH)/%.o: $(SRC_PATH)/%.asm | $(DEPEND_TITLE_DATA_MARS)
	$(ASSEMBLE_MSG)
	$(ASMSH) $(ASMSH_FLAGS) $<,$@,,$(patsubst %.o,%.lst,$@)

$(DEPEND_TITLE_DATA_MARS): $(OBJ_PATH)/%.d: $(SRC_PATH)/%.asm | $(OBJ_PATH_TITLE_DATA)
	$(MAKING_DEPENDS)
	$(MAKE_DEPEND) -o $@ $(patsubst %.d,%.o,$@) $<

$(OBJ_TITLE_MAPS): $(OBJ_PATH)/%.o: $(SRC_PATH)/%.asm | $(DEPEND_TITLE_MAPS)
	$(ASSEMBLE_MSG)
	$(ASM68K) $(ASM68K_FLAGS) $<,$@,,$(patsubst %.o,%.lst,$@)

$(DEPEND_TITLE_MAPS): $(OBJ_PATH)/%.d: $(SRC_PATH)/%.asm | $(OBJ_PATH_TITLE_MAPS)
	$(MAKING_DEPENDS)
	$(MAKE_DEPEND) -o $@ $(patsubst %.d,%.o,$@) $<

# ------------------------------------------------------------------------------
# Sonic mode rules
# ------------------------------------------------------------------------------

$(OBJ_SONIC): $(OBJ_PATH)/%.o: $(SRC_PATH)/%.asm | $(DEPEND_SONIC)
	$(ASSEMBLE_MSG)
	$(ASM68K) $(ASM68K_FLAGS) $<,$@,,$(patsubst %.o,%.lst,$@)

$(DEPEND_SONIC): $(OBJ_PATH)/%.d: $(SRC_PATH)/%.asm | $(OBJ_PATH_SONIC) $(OBJ_PATH_SONIC_OBJECTS)
	$(MAKING_DEPENDS)
	$(MAKE_DEPEND) -o $@ $(patsubst %.d,%.o,$@) $<

$(OBJ_SONIC_DATA_MD): $(OBJ_PATH)/%.o: $(SRC_PATH)/%.asm | $(DEPEND_SONIC_DATA_MD)
	$(ASSEMBLE_MSG)
	$(ASM68K) $(ASM68K_FLAGS) $<,$@,,$(patsubst %.o,%.lst,$@)

$(DEPEND_SONIC_DATA_MD): $(OBJ_PATH)/%.d: $(SRC_PATH)/%.asm | $(OBJ_PATH_SONIC_DATA)
	$(MAKING_DEPENDS)
	$(MAKE_DEPEND) -o $@ $(patsubst %.d,%.o,$@) $<

$(OBJ_SONIC_DATA_MARS): $(OBJ_PATH)/%.o: $(SRC_PATH)/%.asm | $(DEPEND_SONIC_DATA_MARS)
	$(ASSEMBLE_MSG)
	$(ASMSH) $(ASMSH_FLAGS) $<,$@,,$(patsubst %.o,%.lst,$@)

$(DEPEND_SONIC_DATA_MARS): $(OBJ_PATH)/%.d: $(SRC_PATH)/%.asm | $(OBJ_PATH_SONIC_DATA)
	$(MAKING_DEPENDS)
	$(MAKE_DEPEND) -o $@ $(patsubst %.d,%.o,$@) $<

$(OBJ_SONIC_MAPS): $(OBJ_PATH)/%.o: $(SRC_PATH)/%.asm | $(DEPEND_SONIC_MAPS)
	$(ASSEMBLE_MSG)
	$(ASM68K) $(ASM68K_FLAGS) $<,$@,,$(patsubst %.o,%.lst,$@)

$(DEPEND_SONIC_MAPS): $(OBJ_PATH)/%.d: $(SRC_PATH)/%.asm | $(OBJ_PATH_SONIC_MAPS)
	$(MAKING_DEPENDS)
	$(MAKE_DEPEND) -o $@ $(patsubst %.d,%.o,$@) $<

# ------------------------------------------------------------------------------
# RPG mode rules
# ------------------------------------------------------------------------------

$(OBJ_RPG): $(OBJ_PATH)/%.o: $(SRC_PATH)/%.asm | $(DEPEND_RPG)
	$(ASSEMBLE_MSG)
	$(ASM68K) $(ASM68K_FLAGS) $<,$@,,$(patsubst %.o,%.lst,$@)

$(DEPEND_RPG): $(OBJ_PATH)/%.d: $(SRC_PATH)/%.asm | $(OBJ_PATH_RPG) $(OBJ_PATH_RPG_OBJECTS)
	$(MAKING_DEPENDS)
	$(MAKE_DEPEND) -o $@ $(patsubst %.d,%.o,$@) $<

$(OBJ_RPG_DATA_MD): $(OBJ_PATH)/%.o: $(SRC_PATH)/%.asm | $(DEPEND_RPG_DATA_MD)
	$(ASSEMBLE_MSG)
	$(ASM68K) $(ASM68K_FLAGS) $<,$@,,$(patsubst %.o,%.lst,$@)

$(DEPEND_RPG_DATA_MD): $(OBJ_PATH)/%.d: $(SRC_PATH)/%.asm | $(OBJ_PATH_RPG_DATA)
	$(MAKING_DEPENDS)
	$(MAKE_DEPEND) -o $@ $(patsubst %.d,%.o,$@) $<

$(OBJ_RPG_DATA_MARS): $(OBJ_PATH)/%.o: $(SRC_PATH)/%.asm | $(DEPEND_RPG_DATA_MARS)
	$(ASSEMBLE_MSG)
	$(ASMSH) $(ASMSH_FLAGS) $<,$@,,$(patsubst %.o,%.lst,$@)

$(DEPEND_RPG_DATA_MARS): $(OBJ_PATH)/%.d: $(SRC_PATH)/%.asm | $(OBJ_PATH_RPG_DATA)
	$(MAKING_DEPENDS)
	$(MAKE_DEPEND) -o $@ $(patsubst %.d,%.o,$@) $<

$(OBJ_RPG_MAPS): $(OBJ_PATH)/%.o: $(SRC_PATH)/%.asm | $(DEPEND_RPG_MAPS)
	$(ASSEMBLE_MSG)
	$(ASM68K) $(ASM68K_FLAGS) $<,$@,,$(patsubst %.o,%.lst,$@)

$(DEPEND_RPG_MAPS): $(OBJ_PATH)/%.d: $(SRC_PATH)/%.asm | $(OBJ_PATH_RPG_MAPS)
	$(MAKING_DEPENDS)
	$(MAKE_DEPEND) -o $@ $(patsubst %.d,%.o,$@) $<

# ------------------------------------------------------------------------------
# Credits rules
# ------------------------------------------------------------------------------

$(OBJ_CREDITS): $(OBJ_PATH)/%.o: $(SRC_PATH)/%.asm | $(DEPEND_CREDITS)
	$(ASSEMBLE_MSG)
	$(ASM68K) $(ASM68K_FLAGS) $<,$@,,$(patsubst %.o,%.lst,$@)

$(DEPEND_CREDITS): $(OBJ_PATH)/%.d: $(SRC_PATH)/%.asm | $(OBJ_PATH_CREDITS)
	$(MAKING_DEPENDS)
	$(MAKE_DEPEND) -o $@ $(patsubst %.d,%.o,$@) $<

$(OBJ_CREDITS_DATA_MARS): $(OBJ_PATH)/%.o: $(SRC_PATH)/%.asm | $(DEPEND_CREDITS_DATA_MARS)
	$(ASSEMBLE_MSG)
	$(ASMSH) $(ASMSH_FLAGS) $<,$@,,$(patsubst %.o,%.lst,$@)

$(DEPEND_CREDITS_DATA_MARS): $(OBJ_PATH)/%.d: $(SRC_PATH)/%.asm | $(OBJ_PATH_CREDITS_DATA)
	$(MAKING_DEPENDS)
	$(MAKE_DEPEND) -o $@ $(patsubst %.d,%.o,$@) $<

# ------------------------------------------------------------------------------
# Create folders
# ------------------------------------------------------------------------------

$(BUILD_PATH):
	@mkdir "$@"

$(OBJ_PATH):
	@mkdir "$@"

$(OBJ_PATH_Z80):
	@mkdir "$@"

$(OBJ_PATH_FRAMEWORK_MD):
	@mkdir "$@"

$(OBJ_PATH_FRAMEWORK_MARS):
	@mkdir "$@"

$(OBJ_PATH_COMMON):
	@mkdir "$@"

$(OBJ_PATH_COMMON_DATA):
	@mkdir "$@"

$(OBJ_PATH_SOUND_DATA):
	@mkdir "$@"

$(OBJ_PATH_SPLASH):
	@mkdir "$@"

$(OBJ_PATH_SPLASH_DATA):
	@mkdir "$@"

$(OBJ_PATH_TITLE):
	@mkdir "$@"

$(OBJ_PATH_TITLE_DATA):
	@mkdir "$@"

$(OBJ_PATH_TITLE_MAPS):
	@mkdir "$@"

$(OBJ_PATH_SONIC):
	@mkdir "$@"

$(OBJ_PATH_SONIC_OBJECTS):
	@mkdir "$@"

$(OBJ_PATH_SONIC_DATA):
	@mkdir "$@"

$(OBJ_PATH_SONIC_MAPS):
	@mkdir "$@"

$(OBJ_PATH_RPG):
	@mkdir "$@"

$(OBJ_PATH_RPG_OBJECTS):
	@mkdir "$@"

$(OBJ_PATH_RPG_DATA):
	@mkdir "$@"

$(OBJ_PATH_RPG_MAPS):
	@mkdir "$@"

$(OBJ_PATH_CREDITS):
	@mkdir "$@"

$(OBJ_PATH_CREDITS_DATA):
	@mkdir "$@"

# ------------------------------------------------------------------------------
# Include dependencies
# ------------------------------------------------------------------------------

ifneq (clean,$(filter clean,$(MAKECMDGOALS)))
-include $(DEPEND_Z80)
-include $(DEPEND_FRAMEWORK_MD)
-include $(DEPEND_FRAMEWORK_MARS)
-include $(DEPEND_COMMON)
-include $(DEPEND_COMMON_DATA_MD)
-include $(DEPEND_COMMON_DATA_MARS)
-include $(DEPEND_SOUND_DATA)
-include $(DEPEND_PWM_SAMPLES)
-include $(DEPEND_SPLASH)
-include $(DEPEND_SPLASH_DATA_MD)
-include $(DEPEND_SPLASH_DATA_MARS)
-include $(DEPEND_TITLE)
-include $(DEPEND_TITLE_DATA_MD)
-include $(DEPEND_TITLE_DATA_MARS)
-include $(DEPEND_TITLE_MAPS)
-include $(DEPEND_SONIC)
-include $(DEPEND_SONIC_DATA_MD)
-include $(DEPEND_SONIC_DATA_MARS)
-include $(DEPEND_SONIC_MAPS)
-include $(DEPEND_RPG)
-include $(DEPEND_RPG_DATA_MD)
-include $(DEPEND_RPG_DATA_MARS)
-include $(DEPEND_RPG_MAPS)
-include $(DEPEND_CREDITS)
-include $(DEPEND_CREDITS_DATA_MARS)
endif

# ------------------------------------------------------------------------------