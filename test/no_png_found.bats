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
@test "Test where no png file found" {

  # verify $KEPLER_SH is in path if not skip this test
  skipIfKeplerNotInPath

  mkdir -p "$THE_TMP/empty/data"
  # Run kepler.sh
  run $KEPLER_SH -runwf -redirectgui $THE_TMP -CWS_jobname jname -CWS_user joe -CWS_jobid 123 -imagedataset "$THE_TMP/empty" -CWS_outputdir $THE_TMP $WF

  # Check exit code
  [ "$status" -eq 0 ]

  # will only see this if kepler fails
  echoArray "${lines[@]}"
  

  # Check output from kepler.sh
  [[ "${lines[0]}" == "The base dir is"* ]]

  # Will be output if anything below fails
  cat "$THE_TMP/$README_TXT"

  # Verify we did not get a WORKFLOW.FAILED.txt file
  [  -e "$THE_TMP/$WORKFLOW_FAILED_TXT" ]
  cat "$THE_TMP/$WORKFLOW_FAILED_TXT"
  run cat "$THE_TMP/$WORKFLOW_FAILED_TXT"
  [ "${lines[0]}" == "simple.error.message=No image found" ]
  [ "${lines[1]}" == "detailed.error.message=No image matching (png) filter exists in $THE_TMP/empty/data" ]

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
 
