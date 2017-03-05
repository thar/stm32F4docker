#!/bin/bash - 
if [ -z ${CMAKE_BUILD_TYPE+x} ]; then
    CMAKE_BUILD_TYPE="Debug"
fi

if [ -z ${MAKE_TARGET+x} ]; then
    MAKE_TARGET=all
fi

if [[ ${CMAKE_BUILD_TYPE} = "Debug" ]]; then
    BUILD_DIRECTORY=Debug
else
    BUILD_DIRECTORY=Release
fi

if [ -z ${STM32_CHIP+x} ]; then
    STM32_CHIP="STM32F405RG"
fi

mkdir -p ${BUILD_DIRECTORY}
pushd ${BUILD_DIRECTORY} > /dev/null
cmake -DSTM32_CHIP=${STM32_CHIP} -DCMAKE_TOOLCHAIN_FILE=/usr/share/cmake-3.5/Modules/gcc_stm32.cmake -DCMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE} ../
make ${MAKE_TARGET}

RESULT=$?

if [ ${RESULT} -eq 0 ]; then
    if [ -n ${FLASH} ]; then
        st-info --chipid && st-flash write `ls src/*.bin` 0x08000000
    fi
fi

popd > /dev/null
chmod -R a+rw ${BUILD_DIRECTORY}

exit ${RESULT}
