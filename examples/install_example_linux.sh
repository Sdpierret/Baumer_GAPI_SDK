#!/bin/bash

# enable build directory for custumer
# for using set set string to true
# for disable clear the string
ENABLE_DIR_MAKE_DEBUG=true
ENABLE_DIR_MAKE_RELEASE=true
ENABLE_DIR_ECLIPSE_DEBUG=true
ENABLE_DIR_ECLIPSE_RELEASE=true

# use CC or CXX environment variable and use default value if not set
if [ -z "$CC" ]; then
    CC=gcc
fi
if [ -z "$CXX" ]; then
    CC=g++
fi

# check if all required tools are available
REQUIRED_TOOLS="$CC $CXX make cmake"
for TOOL in REQUIRED_TOOLS
do
    which $TOOL
    if [ ! $? ] ; then
        echo "###### missing $TOOL ######"
        echo "$TOOL not available, install $TOOL with your prefered method e.g. apt-get install $TOOL"
        exit 1
    fi
done

# check for write permissions in the current directory
if [ ! -w $PWD ]
then
    echo "###### No write permission at current location! ($PWD) ######"
    echo "###### Please copy this folder to a location with write permission. ######"
    exit 1
fi

case `$CC -dumpmachine` in
    *x86*)
    CMAKE_OPTIONS="-DMMX_SUPPORT=ON $CMAKE_OPTIONS"
    ;;
esac
CMAKE_OPTIONS="-DCMAKE_VERBOSE_MAKEFILE:BOOL=ON $CMAKE_OPTIONS"

SRC=../src

DEST=build_linux_

if [ $ENABLE_DIR_ECLIPSE_DEBUG ]; then
    GENERATOR_TYPE="Eclipse CDT4 - Unix Makefiles"
elif [ $ENABLE_DIR_MAKE_DEBUG ]; then
    GENERATOR_TYPE="Unix Makefiles"
else
    GENERATOR_TYPE= 
fi

echo "#################################################################################"
echo "#                                                                               #"
if [ ! -z "$GENERATOR_TYPE" ]
then
    echo "#  ENABLE DEBUG VERSION for \`Unix Makefiles\`                                    #"
else
    echo "#  DISABLE DEBUG VERSION for \`Unix Makefiles\`                                   #"
fi
echo "#                                                                               #"
echo "#################################################################################"
if [ ! -z "$GENERATOR_TYPE" ]; then
    B_TYPE=debug
    rm -rf $DEST$B_TYPE
    mkdir $DEST$B_TYPE
    pushd $DEST$B_TYPE
    echo "generate cmake build directory "$PWD
    cmake -G "$GENERATOR_TYPE" $CMAKE_OPTIONS -DCMAKE_BUILD_TYPE=$B_TYPE $SRC
    popd
fi

if [ $ENABLE_DIR_ECLIPSE_RELEASE ]; then
    GENERATOR_TYPE="Eclipse CDT4 - Unix Makefiles"
elif [ $ENABLE_DIR_MAKE_RELEASE ]; then
    GENERATOR_TYPE="Unix Makefiles"
else
    GENERATOR_TYPE= 
fi

echo "#################################################################################"
echo "#                                                                               #"
if [ ! -z "$GENERATOR_TYPE" ]
then
    echo "#  ENABLE RELEASE VERSION for \`Unix Makefiles\`                                  #"
else
    echo "#  DISABLE RELEASE VERSION for \`Unix Makefiles\`                                 #"
fi
echo "#                                                                               #"
echo "#################################################################################"
if [ ! -z "$GENERATOR_TYPE" ]; then
    B_TYPE=release
    rm -rf $DEST$B_TYPE
    mkdir $DEST$B_TYPE
    pushd $DEST$B_TYPE
    echo "generate cmake build directory "$PWD
    cmake -G "$GENERATOR_TYPE" $CMAKE_OPTIONS -DCMAKE_BUILD_TYPE=$B_TYPE $SRC
    popd
fi

