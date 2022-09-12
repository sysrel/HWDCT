#===------------------------------------------------------------------------===#
#
#                     The KLEE Symbolic Virtual Machine
#
# This file is distributed under the University of Illinois Open Source
# License. See LICENSE.TXT for details.
#
#===------------------------------------------------------------------------===#
find_package(BISON)
BISON_TARGET(Prose Prose.y ${CMAKE_CURRENT_SOURCE_DIR}/parser.cpp
             DEFINES_FILE ${CMAKE_CURRENT_SOURCE_DIR}/parser.h)

find_package(FLEX)
FLEX_TARGET(Prose Prose.l ${CMAKE_CURRENT_SOURCE_DIR}/lexer.cpp)
ADD_FLEX_BISON_DEPENDENCY(Prose Prose)

set(KLEE_LIBS
  kleeBasic
  kleeCore
)

klee_add_component(Prose
  helper.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/lexer.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/parser.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/Prose.cpp
)

target_link_libraries(Prose PRIVATE ${KLEE_LIBS})

