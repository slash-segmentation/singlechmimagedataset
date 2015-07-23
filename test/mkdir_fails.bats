#!/usr/bin/env bats


# 
# Load the helper functions in test_helper.bash 
# Note the .bash suffix is omitted intentionally
# 
load test_helper

#
# Test to run is denoted with at symbol test like below
# the string after is the test name and will be displayed
# when the test is run
#
# This test is as the test name states a check when everythin
# is peachy.
#
@test "Test where mkdir of data directory fails" {

  # verify $KEPLER_SH is in path if not skip this test
  skipIfKeplerNotInPath

  echo "0,640x480,," > "$THE_TMP/bin/command.tasks"
  mkdir -p "$THE_TMP/empty/data"
  echo "hi" > "$THE_TMP/data"
  echo "hi" > "$THE_TMP/empty/data/yo.001.png"
  echo "hi" > "$THE_TMP/empty/data/yo.002.png"

  # Run kepler.sh
  run $KEPLER_SH -runwf -redirectgui $THE_TMP -CWS_jobname jname -CWS_user joe -CWS_jobid 123 -identifyCmd "$THE_TMP/bin/command" -imagedataset "$THE_TMP/empty" -filter 1 -CWS_outputdir $THE_TMP $WF

  # Check exit code
  [ "$status" -eq 0 ]

  # will only see this if kepler fails
  echoArray "${lines[@]}"
  
  # Check output from kepler.sh
  [[ "${lines[0]}" == "The base dir is"* ]]

  # Will be output if anything below fails
  cat "$THE_TMP/$README_TXT"


  [ -s "$THE_TMP/slice.info" ]

  run cat "$THE_TMP/slice.info"

  [ "${lines[0]}" == "x=640" ]
  [ "${lines[1]}" == "y=480" ]
  [ "${lines[2]}" == "original.name=yo.001.png" ]


  # Verify we did not get a WORKFLOW.FAILED.txt file
  [  -e "$THE_TMP/$WORKFLOW_FAILED_TXT" ]
  cat "$THE_TMP/$WORKFLOW_FAILED_TXT"
  run cat "$THE_TMP/$WORKFLOW_FAILED_TXT"
  [ "${lines[0]}" == "simple.error.message=Unable to create output directory" ]
  [[ "${lines[1]}" == "detailed.error.message=Unable to create $THE_TMP/data directory : "* ]]

  # Verify we got a README.txt
  [ -s "$THE_TMP/$README_TXT" ]

  # Check read me header
  run cat "$THE_TMP/$README_TXT"
  [ "$status" -eq 0 ]
  [ "${lines[0]}" == "Single Slice CHM image dataset" ]
  [ "${lines[1]}" == "Job Name: jname" ]
  [ "${lines[2]}" == "User: joe" ]
  [ "${lines[3]}" == "Notify Email: " ]
  [ "${lines[4]}" == "Workflow Job Id: 123" ]
  
  # Check we got a workflow.status file
  [ -s "$THE_TMP/$WORKFLOW_STATUS" ]

}
 
