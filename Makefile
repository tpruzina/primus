CXX      ?= g++
CXXFLAGS ?= -U_FORTIFY_SOURCE -fno-stack-protector -march=native -Os -flto=2 -std=c++11
LDFLAGS ?= -O3 -flto=2


# On multilib systems, this needs to point to distribution-specific library
# subdir like in /usr (lib or lib64 for 64-bit, lib32 or lib for 32-bit)
LIBDIR   ?= lib

BUMBLEBEE_SOCKET   ?= /var/run/bumblebee.socket
PRIMUS_SYNC        ?= 0
PRIMUS_VERBOSE     ?= 0
PRIMUS_UPLOAD      ?= 0
PRIMUS_SLEEP       ?= 90
PRIMUS_DISPLAY     ?= :8
PRIMUS_LOAD_GLOBAL ?= libglapi.so.0
PRIMUS_libGLa      ?= /usr/$$LIB/nvidia/libGL.so.1
PRIMUS_libGLd      ?= /usr/$$LIB/libGL.so.1

CXXFLAGS += -DBUMBLEBEE_SOCKET='"$(BUMBLEBEE_SOCKET)"'
CXXFLAGS += -DPRIMUS_SYNC='"$(PRIMUS_SYNC)"'
CXXFLAGS += -DPRIMUS_VERBOSE='"$(PRIMUS_VERBOSE)"'
CXXFLAGS += -DPRIMUS_UPLOAD='"$(PRIMUS_UPLOAD)"'
CXXFLAGS += -DPRIMUS_SLEEP='"$(PRIMUS_SLEEP)"'
CXXFLAGS += -DPRIMUS_DISPLAY='"$(PRIMUS_DISPLAY)"'
CXXFLAGS += -DPRIMUS_LOAD_GLOBAL='"$(PRIMUS_LOAD_GLOBAL)"'
CXXFLAGS += -DPRIMUS_libGLa='"$(PRIMUS_libGLa)"'
CXXFLAGS += -DPRIMUS_libGLd='"$(PRIMUS_libGLd)"'

$(LIBDIR)/libGL.so.1: libglfork.cpp
	mkdir -p $(LIBDIR)
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -static-libstdc++ -static-libgcc -fvisibility=hidden -fPIC -shared -Wl,-Bsymbolic -o $@ $< -lX11 -lpthread -lrt


#-lX11 -lxcb -lXau -lXdmcp -lpthread
#$(CXX) $(CPPFLAGS) $(CXXFLAGS) -fvisibility=hidden -fPIC -shared -Wl,-Bsymbolic -o $@ $< -lX11 -lpthread -lrt -lX11 -lxcb -lXau -lXdmcp -lpthread

install:
	cp lib32/libGL.so.1 /usr/lib32/primus/libGL.so.1
	cp lib/libGL.so.1 /usr/lib/primus/libGL.so.1
	chmod a+x /usr/lib32/primus/libGL.so.1 /usr/lib/primus/libGL.so.1
