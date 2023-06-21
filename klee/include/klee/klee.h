/*===-- klee.h --------------------------------------------------*- C++ -*-===//
//
//                     The KLEE Symbolic Virtual Machine
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===*/

#ifndef __KLEE_H__
#define __KLEE_H__

#include "stdint.h"
#include "stddef.h"

#ifdef __cplusplus
extern "C" {
#endif
  
  /* Add an accesible memory object at a user specified location. It
   * is the users responsibility to make sure that these memory
   * objects do not overlap. These memory objects will also
   * (obviously) not correctly interact with external function
   * calls.
   */
  void klee_define_fixed_object(void *addr, size_t nbytes);

  /* klee_make_symbolic - Make the contents of the object pointer to by \arg
   * addr symbolic.
   *
   * \arg addr - The start of the object.
   * \arg nbytes - The number of bytes to make symbolic; currently this *must*
   * be the entire contents of the object.
   * \arg name - An optional name, used for identifying the object in messages,
   * output files, etc.
   */
  void klee_make_symbolic(void *addr, size_t nbytes, const char *name);

  /* klee_range - Construct a symbolic value in the signed interval
   * [begin,end).
   *
   * \arg name - An optional name, used for identifying the object in messages,
   * output files, etc.
   */
  int klee_range(int begin, int end, const char *name);

  /*  klee_int - Construct an unconstrained symbolic integer.
   *
   * \arg name - An optional name, used for identifying the object in messages,
   * output files, etc.
   */
  int klee_int(const char *name);

  /* klee_silent_exit - Terminate the current KLEE process without generating a
   * test file.
   */
  __attribute__((noreturn))
  void klee_silent_exit(int status);

  /* klee_abort - Abort the current KLEE process. */
  __attribute__((noreturn))
  void klee_abort(void);  

  /* klee_report_error - Report a user defined error and terminate the current
   * KLEE process.
   *
   * \arg file - The filename to report in the error message.
   * \arg line - The line number to report in the error message.
   * \arg message - A string to include in the error message.
   * \arg suffix - The suffix to use for error files.
   */
  __attribute__((noreturn))
  void klee_report_error(const char *file, 
			 int line, 
			 const char *message, 
			 const char *suffix);
  
  /* called by checking code to get size of memory. */
  size_t klee_get_obj_size(void *ptr);
  
  /* print the tree associated w/ a given expression. */
  void klee_print_expr(const char *msg, ...);
  
  /* NB: this *does not* fork n times and return [0,n) in children.
   * It makes n be symbolic and returns: caller must compare N times.
   */
  uintptr_t klee_choose(uintptr_t n);
  
  /* special klee assert macro. this assert should be used when path consistency
   * across platforms is desired (e.g., in tests).
   * NB: __assert_fail is a klee "special" function
   */
# define klee_assert(expr)                                              \
  ((expr)                                                               \
   ? (void) (0)                                                         \
   : __assert_fail (#expr, __FILE__, __LINE__, __PRETTY_FUNCTION__))    \

  /* Return true if the given value is symbolic (represented by an
   * expression) in the current state. This is primarily for debugging
   * and writing tests but can also be used to enable prints in replay
   * mode.
   */
  unsigned klee_is_symbolic(uintptr_t n);

  /* The following intrinsics are primarily intended for internal use
     and may have peculiar semantics. */

  void klee_assume(uintptr_t condition);
  void klee_warning(const char *message);
  void klee_warning_once(const char *message);
  void klee_prefer_cex(void *object, uintptr_t condition);
  void klee_posix_prefer_cex(void *object, uintptr_t condition);
  void klee_mark_global(void *object);

  /* Return a possible constant value for the input expression. This
     allows programs to forcibly concretize values on their own. */
#define KLEE_GET_VALUE_PROTO(suffix, type)	type klee_get_value##suffix(type expr)

  KLEE_GET_VALUE_PROTO(f, float);
  KLEE_GET_VALUE_PROTO(d, double);
  KLEE_GET_VALUE_PROTO(l, long);
  KLEE_GET_VALUE_PROTO(ll, long long);
  KLEE_GET_VALUE_PROTO(_i32, int32_t);
  KLEE_GET_VALUE_PROTO(_i64, int64_t);

#undef KLEE_GET_VALUE_PROTO

  /* Ensure that memory in the range [address, address+size) is
     accessible to the program. If some byte in the range is not
     accessible an error will be generated and the state
     terminated. 
  
     The current implementation requires both address and size to be
     constants and that the range lie within a single object. */
  void klee_check_memory_access(const void *address, size_t size);

  /* Enable/disable forking. */
  void klee_set_forking(unsigned enable);

  /* klee_alias_function("foo", "bar") will replace, at runtime (on
     the current path and all paths spawned on the current path), all
     calls to foo() by calls to bar().  foo() and bar() have to exist
     and have identical types.  Use klee_alias_function("foo", "foo")
     to undo.  Be aware that some special functions, such as exit(),
     may not always work. */
  void klee_alias_function(const char* fn_name, const char* new_fn_name);

  /* Print stack trace. */
  void klee_stack_trace(void);

  /* Print range for given argument and tagged with name */
  void klee_print_range(const char * name, int arg );

  /* Open a merge */
  void klee_open_merge();

  /* Merge all paths of the state that went through klee_open_merge */
  void klee_close_merge();

  /* Get errno value of the current state */
  int klee_get_errno(void);

  /* SYSREL extension */
  void klee_set_metadata(void *, int value);
  int klee_get_metadata(void *);
  //void klee_add_symboinput_globally(void *, int inName);//new func with regard to gate level

  void klee_record_step_trace_locally(int stepNo); //Versym
  
  void klee_check_and_record_path_condition(void *s);
  void klee_check_and_record_path_condition_with_assume(void *, uintptr_t x);
  //void klee_check_and_record_path_condition_with_assume(void *, uintptr_t condition1, uintptr_t condition2);
  //void klee_check_and_record_path_condition_with_assume(void *, uintptr_t condition1, uintptr_t condition2, uintptr_t condition3);
  //void klee_check_and_record_path_condition_with_assume(void *, int value, int dest);
  void klee_add_assume(void *, uintptr_t condition);
  

/* start of hybird fuzzing implementations */
  void klee_add_guard_signal(void *, int);
/* end of hybird fuzzing implementations */

///@{ Analyze hack@dac
void klee_check_constraint_var(void *, int, ...);
///@}

/* Ruochen */
/*void klee_get_model1(int a, int b) { printf("int, int\n"); }
void klee_get_mode2(double a, int b) { printf("double, int\n"); }
void klee_get_mode3(int a, int b, int c) { printf("int, int, int\n"); }
void klee_get_model4(void) { printf("unknown arguments\n"); }

#define klee_get_model(...) OVERLOAD(klee_get_model, (__VA_ARGS__), \
    (klee_get_model_4, (int, void *, int, void *, int, void *, int, void *)), \
    (klee_get_model_6, (int, void *, int, void *, int, void *, int, void *, int, void *, int, void *))\
)
#define OVERLOAD_ARG_TYPES (int, void *)
#define OVERLOAD_FUNCTIONS (klee_get_model)
*/
void klee_clear_pc();
void klee_get_model(int, void *, ...);
void klee_print_value(int , int , int , int);
void klee_print_value_adress(void *, void *, void *, void *);

void klee_record_initial_state(void *, int, ...);
void klee_check_reach_initial_state(void *, void *, void *);
void klee_check_reach_initial_state_reg(void *, void *, int, ...);
/* Ruochen */


  void klee_get_input_pattern(void *s, int Name1, int Name2, int Name3, int Name4, int Name5, int Name6/*, int Name7, int Name8, int Name9, int Name10, int Name11, int Name12*/);
  void klee_get_input_pattern_previous_cycle(void *s, int Name1, int Name2, int Name3, int Name4, int Name5, int Name6/*, int Name7, int Name8, int Name9, int Name10, int Name11, int Name12*/);
  void klee_clear_path_constraint(void *s);
  
  ///@{ HWDCT extension
  // DCT prediction
  void klee_add_metadata_globally(void *, int value);
  void klee_check_dontcare_transition_globally(void *, int, int, int);
  
  // Trojan prediction
  void klee_add_forward_reg_metadata_globally(void *, int state, int reg2, ...);
  void klee_add_and_check_abstract_reg_metadata_globally(void *, int state, int reg2, ...);
  
  // Trojan explanation
  void klee_add_output_metadata_globally(void *, int prevStat, int nextStat, int valueIn, int valueOut);
  void klee_add_back_output_metadata_globally(void *, int prevStat, int nextStat, int valueIn, int valueOut);
  void klee_detect_trojan_for_output(void *, void *);
  
  // DCT Aware Reachbility Analysis
  void klee_find_all_transitions_from_given_unreachable_src_one_step_globally(void *, int, int, int, void *, int);
  void klee_find_all_transitions_from_given_src_globally(void *, int depth, int srcState, int sinkState, int protectState);//for finding all transitions from a given src to a protected state.
  ///@}
  
 
  void klee_add_inter_metadata_globally(void *, int numRound, long long int interVal); //for 1 input variable transition function
  void klee_add_transition_metadata_globally(void *, int valuePrev, int valueNext, int inName); //for 1 input variable transition function
  
  
  void klee_add_one_forward_reg_metadata_globally(void *, int state, int arg2);
  void klee_add_and_check_abstract_one_reg_metadata_globally(void *, int state, int arg2);
  
  
  
  void klee_check_DCT_finish_time();//for output trojan detection function
  
  void klee_set_source_state(int srcState);//set source state
  void klee_set_dest_state(int destState);//set dest state


  void klee_add_metadata_locally(void *, int value, int inName); //for 1 input variable FSM function
  void klee_add_metadata_locally_TwoInput(void *, int value, int inName, int inNameTwo);//for 2 input variables FSM function
  void klee_add_metadata_locally_ThreeInput(void *, int value, int inName, int inNameTwo, int inNameThree);//for 3 input variables FSM function
  void klee_add_metadata_locally_FourInput(void *, int value, int inName, int inNameTwo, int inNameThree, int inNameFour);//for 4 input variables FSM function
  
  void klee_check_dontcare_transition_locally(void *, int, int, int, int);//for 1 input variable FSM function
  void klee_check_dontcare_transition_locally_TwoInput(void *, int, int, int, int, int);//for 2 input variables FSM function
  void klee_check_dontcare_transition_locally_ThreeInput(void *, int, int, int, int, int, int);//for 3 input variables FSM function
  void klee_check_dontcare_transition_locally_FourInput(void *, int, int, int, int, int, int, int);//for 4 input variables FSM function

  void klee_add_metadata_globally_on_condition(uintptr_t condition, void *set1, void *set2, const char *mesg);
  void klee_add_metadata_locally_on_condition(uintptr_t condition, void *set1, void *set2, const char *mesg);
  void klee_record_metadata_globally_on_condition(uintptr_t condition, void *set1, void *set2, const char *mesg);
  void klee_record_metadata__locally_on_condition(uintptr_t condition, void *set1, void *set2, const char *mesg);
  void klee_diff_and_check_metadata_globally(void *, void *, const char *mesg);
  void klee_diff_and_check_metadata_locally(void *, void *, const char *mesg);
  void klee_check_metadata_membership_globally(void *, int, const char *mesg);
  void klee_check_metadata_membership_locally(void *, int, const char *mesg);
  void klee_find_tuple_for_diff_locally(void *, int);

  /* SYSREL extension */
  

#ifdef __cplusplus
}
#endif

#endif /* __KLEE_H__ */
