set propertyLocation ${top}.${top}_fpv_bind
# -----------------------------------------------------------------------------
# Task instr_taint_base
# -----------------------------------------------------------------------------
# Base task for proofs related to the division instruction
# -----------------------------------------------------------------------------
# Add all no-taint assumptions for top level inputs (by default copied from environment task, which contains all assumptions,assertions etc.)
set taskName instr_taint_base

# Assumptions:
# ------------
# Add all assumptions that describe the input protocol (if any)
task -create ${taskName} -copy ${propertyLocation}.asm_di_*
# Add all input no taint assumptions
task -edit ${taskName} -copy ${propertyLocation}.asm_no_taint_top_*


# Declassification:
# -----------------
# declassify data that goes back to the register file (different signal in ibex non-/secure)
#include "declass.tcl"
include ${declassificationSigsFile}



# Sanity checks:
# --------------
task -edit ${taskName} -copy ${propertyLocation}.chk*
task -edit ${taskName} -copy ${propertyLocation}.*.as_sanity_*
task -edit ${taskName} -copy ${propertyLocation}.as_sup_*
# -----------------------------------------------------------------------------

include ../common/formal/scripts/tasks/task_creations.tcl