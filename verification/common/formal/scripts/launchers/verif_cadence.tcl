################################ Configuration ################################

# Either include a configuration file here:
# include config.tcl
# or pass the variable values to Jasper via the command line: cds_jasper jg thisfile.tcl -define var1 val1 -define var2 val2
#
# The latter is done by our makefiles (see corename.mk in the core's directories)
###############################################################################

# trace add execution include enterstep {apply {{cmd op} {
#   regsub {\n.*} $cmd "..." cmd
#   puts "EXECUTE: $cmd"
# }}}

if {$configured == 0} {
  include ../common/formal/scripts/procs.tcl
  include ../common/formal/scripts/launchers/jasper_config.tcl
}

set configured 1

if {$clear == 0} {
    puts "CELLIFT-FORMAL ERROR: Restoring with this script alone is not supported. Use the restore make targets."
} else {

  clear -all

  ###  Analyze the design


  # Design files
  analyze -sv17  $designFile

  # Verification files
  analyze -sv17 $propertyModuleFile \
          +define+DECLASSIFICATION_ASSUMPTIONS_FILE=$declassificationAssumptionsFile \
          +define+INPUT_ASSUMPTIONS_FILE=$inputAssumptionsFile \
          +define+TAINT_ASSUMPTIONS_FILE=$taintAssumptionsFile \
          +define+PROPERTIES_FILE=$propertiesFile

  # Bind files
  analyze -sv17 $bindFile

  elaborate -top $top
  #-disable_auto_bbox
  # elaborate -top $top -disable_auto_bbox -bbox_m picorv32_pcpi_div

  save -force ${experimentDir}/design.db
}



#### Formal setup


# Specify the global clocks and reset
if {$resetSequenceFile == ""} {
  reset -none
} else {
  if {$nonResettableRegsZero == 1} {
     reset -sequence $resetSequenceFile -non_resettable_regs 0
  } else {
     reset -sequence $resetSequenceFile
  }
}

include formal/scripts/clock.tcl

#### Prove the properties (can be aborted with Ctrl+C. The following report and save commands will still be executed)

include $taskFile

#### Configure visualisation

# Save values for the full design


#### Create reports
report -file ${experimentDir}/jasper_report.txt -force

puts $errorInfo