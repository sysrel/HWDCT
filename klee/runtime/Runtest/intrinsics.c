//===-- intrinsics.c ------------------------------------------------------===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//

/* Straight C for linking simplicity */

#include <assert.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/time.h>
#include <time.h>

#include "klee/klee.h"

#include "klee/Internal/ADT/KTest.h"

static KTest *testData = 0;
static unsigned testPosition = 0;

static unsigned char rand_byte(void) {
  unsigned x = rand();
  x ^= x>>16;
  x ^= x>>8;
  return x & 0xFF;
}

static void report_internal_error(const char *msg, ...)
    __attribute__((format(printf, 1, 2)));
static void report_internal_error(const char *msg, ...) {
  fprintf(stderr, "KLEE_RUN_TEST_ERROR: ");
  va_list ap;
  va_start(ap, msg);
  vfprintf(stderr, msg, ap);
  va_end(ap);
  fprintf(stderr, "\n");
  char *testErrorsNonFatal = getenv("KLEE_RUN_TEST_ERRORS_NON_FATAL");
  if (testErrorsNonFatal) {
    fprintf(stderr, "KLEE_RUN_TEST_ERROR: Forcing execution to continue\n");
  } else {
    exit(1);
  }
}

void klee_check_metadata_membership_globally(void *set, int value, const char *mesg) {
}

void klee_check_metadata_membership_locally(void *set, int value, const char *mesg) {
}

void klee_record_metadata_globally_on_condition(uintptr_t condition, void *set1, void *set2, const char *mesg) {
}

void klee_record_metadata_locally_on_condition(uintptr_t condition, void *set1, void *set2, const char *mesg) {
}


void klee_add_metadata_globally_on_condition(uintptr_t condition, void *set1, void *set2, const char *mesg) {
}


void klee_add_metadata_locally_on_condition(uintptr_t condition, void *set1, void *set2, const char *mesg) {
}
/*
void klee_add_symboinput_globally(void *s, int inName) {
}////new func with regard to gate level */

void klee_check_and_record_path_condition(void *s) {
}

void klee_check_and_record_path_condition_with_assume(void *s, uintptr_t x) {
  if (!x) {
    report_internal_error("invalid klee_assume condition from klee_check_and_record_path_condition_with_assume");
  }
}
/*
void klee_check_and_record_path_condition_with_assume(void *s, uintptr_t x, uintptr_t y) {
  if (!x) {
    report_internal_error("invalid 1st klee_assume condition");
  }
  if (!y) {
    report_internal_error("invalid 2nd klee_assume condition");
  }
}
void klee_check_and_record_path_condition_with_assume(void *s, uintptr_t x, uintptr_t y, uintptr_t z) {
  if (!x) {
    report_internal_error("invalid 1st klee_assume condition");
  }
  if (!y) {
    report_internal_error("invalid 2nd klee_assume condition");
  }
  if (!z) {
    report_internal_error("invalid 3rd klee_assume condition");
  }
}
*/

void klee_record_step_trace_locally(int stepNo) { } //Versym

void klee_add_assume(void *s, uintptr_t x) {}

///@{ Analyze hack@dac
void klee_check_constraint_var(void *s, int sigOne, ...) {}
///@}

/* start of hybird fuzzing implementations */
void klee_add_guard_signal(void *s, int sigOne) {}
/* end of hybird fuzzing implementations */

/* Ruochen */
void klee_clear_pc() {}
void klee_get_model(int Name1, void *sName1, ...) {}
void klee_print_value(int Name1, int Name2, int Name3, int Name4) {}
void klee_print_value_adress(void *sName1, void *sName2, void *sName3, void *sName4){}

void klee_record_initial_state(void *s, int Name1, ...) {}
void klee_check_reach_initial_state(void *retval, void *init, void *cur) {}
void klee_check_reach_initial_state_reg(void *retval, void *init, int reg1, ...) {}
/* Ruochen */

void klee_get_input_pattern(void *s, int Name1, int Name2, int Name3, int Name4, int Name5, int Name6/*, int Name7, int Name8, int Name9, int Name10, int Name11, int Name12*/){}
void klee_get_input_pattern_previous_cycle(void *s, int Name1, int Name2, int Name3, int Name4, int Name5, int Name6/*, int Name7, int Name8, int Name9, int Name10, int Name11, int Name12*/){}
void klee_clear_path_constraint(void *s){}

///@{ HWDCT extension
void klee_add_metadata_globally(void *s, int value) {} //for 1 input variable FSM
void klee_check_dontcare_transition_globally(void *s, int stateReg, int srcState, int destState){} //for 1 input variable FSM function

void klee_add_forward_reg_metadata_globally(void *s, int state, int argTwo, ...){} 
void klee_add_and_check_abstract_reg_metadata_globally(void *s, int state, int argTwo,...){}

void klee_add_output_metadata_globally(void *s, int valuePrevState, int valueNextStat, int valueIn, int valueOut){}
void klee_add_back_output_metadata_globally(void *s, int valuePrevState, int valueNextStat, int valueIn, int valueOut){}
void klee_detect_trojan_for_output(void *set1, void *set2){};
void klee_find_all_transitions_from_given_unreachable_src_one_step_globally(void *s, int stateReg, int srcState, int destState, void *s1, int depth){};
///@}
  
void klee_find_all_transitions_from_given_src_globally(void *s, int depth, int srcState, int sinkState, int protectState){};//for finding all transitions from a given src to a protecteState
  
void klee_add_inter_metadata_globally(void *s, int numRound, long long int interVal){}   
void klee_add_transition_metadata_globally(void *s, int valuePrev, int valueNext, int inName){}  //for 1 input variable transition


void klee_add_one_forward_reg_metadata_globally(void *s, int state, int arg2){}
void klee_add_and_check_abstract_one_reg_metadata_globally(void *s, int state, int arg2){}

void klee_check_DCT_finish_time(){};

void klee_set_source_state(int srcState){};//set source state
void klee_set_dest_state(int destState){};//set dest state

void klee_add_metadata_locally(void *s, int value, int inName) {}//for 1 input variable FSM
void klee_add_metadata_locally_TwoInput(void *s, int value, int inName, int inNameTwo) {}//for 2 input variables FSM
void klee_add_metadata_locally_ThreeInput(void *s, int value, int inName, int inNameTwo, int inNameThree) {}//for 3 input variables FSM
void klee_add_metadata_locally_FourInput(void *s, int value, int inName, int inNameTwo, int inNameThree, int inNameFour) {}//for 4 input variables FSM

void klee_check_dontcare_transition_locally(void *s, int value, int inNameOne, int inNameTwo, int inNameThree){} //for 1 input variable FSM function
void klee_check_dontcare_transition_locally_TwoInput(void *s, int value, int inNameOne, int inNameTwo, int inNameThree, int inNameFour){}//for 2 input variables FSM function
void klee_check_dontcare_transition_locally_ThreeInput(void *s, int value, int inNameOne, int inNameTwo, int inNameThree, int inNameFour, int inNameFive){}//for 3 input variables FSM function
void klee_check_dontcare_transition_locally_FourInput(void *s, int value, int inNameOne, int inNameTwo, int inNameThree, int inNameFour, int inNameFive, int inNameSix){}//for 4 input variables FSM function


void klee_diff_and_check_metadata_globally(void *s1, void *s2, const char *mesg) {}

void klee_diff_and_check_metadata_locally(void *s1, void *s2, const char *mesg) {
}

void klee_find_tuple_for_diff_locally(void *s, int v) {
}


void klee_make_symbolic(void *array, size_t nbytes, const char *name) {
  static int rand_init = -1;

  if (rand_init == -1) {
    if (getenv("KLEE_RANDOM")) {
      struct timeval tv;
      gettimeofday(&tv, 0);
      rand_init = 1;
      srand(tv.tv_sec ^ tv.tv_usec);
    } else {
      rand_init = 0;
    }
  }

  if (rand_init) {
    if (!strcmp(name,"syscall_a0")) {
      unsigned long long *v = array;
      assert(nbytes == 8);
      *v = rand() % 69;
    } else {
      char *c = array;
      size_t i;
      for (i=0; i<nbytes; i++)
        c[i] = rand_byte();
    }
    return;
  }

  if (!testData) {
    char tmp[256];
    char *name = getenv("KTEST_FILE");

    if (!name) {
      fprintf(stdout, "KLEE-RUNTIME: KTEST_FILE not set, please enter .ktest path: ");
      fflush(stdout);
      name = tmp;
      if (!fgets(tmp, sizeof tmp, stdin) || !strlen(tmp)) {
        fprintf(stderr, "KLEE-RUNTIME: cannot replay, no KTEST_FILE or user input\n");
        exit(1);
      }
      tmp[strlen(tmp)-1] = '\0'; /* kill newline */
    }
    testData = kTest_fromFile(name);
    if (!testData) {
      fprintf(stderr, "KLEE-RUNTIME: unable to open .ktest file\n");
      exit(1);
    }
  }

  for (;; ++testPosition) {
    if (testPosition >= testData->numObjects) {
      report_internal_error("out of inputs. Will use zero if continuing.");
      memset(array, 0, nbytes);
      break;
    } else {
      KTestObject *o = &testData->objects[testPosition];
      if (strcmp("model_version", o->name) == 0 &&
          strcmp("model_version", name) != 0) {
        // Skip over this KTestObject because we've hit
        // `model_version` which is from the POSIX runtime
        // and the caller didn't ask for it.
        continue;
      }
      if (strcmp(name, o->name) != 0) {
        report_internal_error(
            "object name mismatch. Requesting \"%s\" but returning \"%s\"",
            name, o->name);
      }
      memcpy(array, o->bytes, nbytes < o->numBytes ? nbytes : o->numBytes);
      if (nbytes != o->numBytes) {
        report_internal_error("object sizes differ. Expected %zu but got %u",
                              nbytes, o->numBytes);
        if (o->numBytes < nbytes)
          memset((char *)array + o->numBytes, 0, nbytes - o->numBytes);
      }
      ++testPosition;
      break;
    }
  }
}

void klee_silent_exit(int x) {
  exit(x);
}

uintptr_t klee_choose(uintptr_t n) {
  uintptr_t x;
  klee_make_symbolic(&x, sizeof x, "klee_choose");
  if(x >= n)
    report_internal_error("klee_choose failure. max = %ld, got = %ld\n", n, x);
  return x;
}

void klee_assume(uintptr_t x) {
  if (!x) {
    report_internal_error("invalid klee_assume");
  }
}

#define KLEE_GET_VALUE_STUB(suffix, type)	\
	type klee_get_value##suffix(type x) { \
		return x; \
	}

KLEE_GET_VALUE_STUB(f, float)
KLEE_GET_VALUE_STUB(d, double)
KLEE_GET_VALUE_STUB(l, long)
KLEE_GET_VALUE_STUB(ll, long long)
KLEE_GET_VALUE_STUB(_i32, int32_t)
KLEE_GET_VALUE_STUB(_i64, int64_t)

#undef KLEE_GET_VALUE_STUB

int klee_range(int begin, int end, const char* name) {
  int x;
  klee_make_symbolic(&x, sizeof x, name);
  if (x<begin || x>=end) {
    report_internal_error("invalid klee_range(%u,%u,%s) value, got: %u\n",
                          begin, end, name, x);
  }
  return x;
}

void klee_prefer_cex(void *object, uintptr_t condition) { }

void klee_abort() {
  abort();
}

/* not sure we should even define.  is for debugging. */
void klee_print_expr(const char *msg, ...) { }

void klee_set_forking(unsigned enable) { }
