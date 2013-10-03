# Makefile - PlateProcessor

ifndef CFG
CFG=Debug
endif
CC=gcc
CFLAGS=-m32 -fpic
CXX=g++
CXXFLAGS=$(CFLAGS)
ifeq "$(CFG)" "Debug"
CFLAGS+=  -W  -O0 -fexceptions -g  -fno-inline   -D_DEBUG -D_CONSOLE  -I 
LD=$(CXX) $(CXXFLAGS)
LDFLAGS=
LDFLAGS+= 
LIBS+=-lstdc++ -lm
ifndef TARGET
TARGET=PlateProcessor.exe
endif
ifeq "$(CFG)" "Release"
CFLAGS+=  -W  -O2 -fexceptions -g  -fno-inline   -DNDEBUG -D_CONSOLE 
LD=$(CXX) $(CXXFLAGS)
LDFLAGS=
LDFLAGS+= 
LIBS+=-lstdc++ -lm
ifndef TARGET
TARGET=PlateProcessor.exe
endif
endif
endif
ifndef TARGET
TARGET=PlateProcessor.exe
endif
.PHONY: all
all: $(TARGET)

%.o: %.c
	$(CC) $(CFLAGS) $(CPPFLAGS) -o $@ -c $<

%.o: %.cc
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c $<

%.o: %.cpp
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c $<

%.o: %.cxx
	$(CXX) $(CXXFLAGS) $(CPPFLAGS) -c $<

%.res: %.rc
	$(RC) $(CPPFLAGS) -o $@ -i $<

SOURCE_FILES= \
	../FixDetector.cpp \
	../PlateProcessor.cpp \
	../TemplateMatchDetector.cpp

HEADER_FILES= \
	../BoundingBox.h \
	../Detector.h \
	../FixDetector.h \
	../Image.h \
	../ImageProcessor.h \
	../PlateProcessor.h \
	../Region.h \
	../TemplateMatchDetector.h

RESOURCE_FILES= \

SRCS=$(SOURCE_FILES) $(HEADER_FILES) $(RESOURCE_FILES) 

OBJS=$(patsubst %.rc,%.res,$(patsubst %.cxx,%.o,$(patsubst %.cpp,%.o,$(patsubst %.cc,%.o,$(patsubst %.c,%.o,$(filter %.c %.cc %.cpp %.cxx %.rc,$(SRCS)))))))

$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)

.PHONY: clean
clean:
	-rm -f -v $(OBJS) $(TARGET) PlateProcessor.dep

.PHONY: depends
depends:
	-$(CXX) $(CXXFLAGS) $(CPPFLAGS) -MM $(filter %.c %.cc %.cpp %.cxx,$(SRCS)) > PlateProcessor.dep

-include PlateProcessor.dep

