##############################################################################
# Project name   :
# File name      : Makefile
# Last modified  : Wed 16 Aug 2017 01:06:42 AM ICT
# Guide          :
###############################################################################
.PHONY: all run clean cleanall tags syntatic

LANG	:= cpp
CC		:= gcc
CXX 	:= g++
OPENCV  :=
CFLAGS  += -Wall -g -std=c++11 $(OPENCV)
LIBS	:= $(OPENCV)
INC     := -I./inc
LFLAGS 	+= -s -lm
TARGET 	:= ann
CLEAR_SCREEN := clear

vpath %.cpp src
vpath %.h   inc

SUB_DIR := .obj
CREATE_SUB_DIR := $(shell mkdir -p $(SUB_DIR))
vpath %.o $(SUB_DIR)
vpath %.d $(SUB_DIR)

SRCS := $(wildcard src/*.$(LANG))
INCS := $(wildcard inc/*.h)
OBJS := $(addprefix $(SUB_DIR)/,$(notdir $(SRCS:.$(LANG)=.o)))
DEPS := $(addprefix $(SUB_DIR)/,$(notdir $(SRCS:.$(LANG)=.d)))

all: $(TARGET)
$(TARGET): $(OBJS)
	@$(CXX) $(LFLAGS) $(INC) $(OBJS) -o $@ -lm $(LIBS)

$(SUB_DIR)/%.o: %.$(LANG) $(INCS) $(SRCS)
	@$(CXX) -c $(CFLAGS) $(INC) -MMD -MP $< -o $@ $(LIBS)


run: $(TARGET)
	@$(CLEAR_SCREEN)
	./$(TARGET)

clean:
	@$(CLEAR_SCREEN)
	@-rm -rf $(SUB_DIR)

cleanall:
	@$(CLEAR_SCREEN)
	@-rm -rf $(SUB_DIR) $(TARGET)

tags : $(SRCS) $(INCS)
	ctags -f ./.tags --c-kinds=+p --fields=+iaS --extra=+fq ./inc

syntatic:
	  echo "$(INC)" > .syntastic_$(LANG)_config
	  echo "$(CFLAGS)" >> .syntastic_$(LANG)_config
	  echo "$(LFLAGS)" >> .syntastic_$(LANG)_config
	  sed -i 's/ -/\n-/g' .syntastic_$(LANG)_config


