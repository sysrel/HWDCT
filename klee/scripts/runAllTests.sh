#!/bin/bash
# usage: full-path-to-top-dir-of-tests [testdescfilename]
# it will visit all subdirectories at all levels
topdir=$1
if [ -z "$2" ]; then
  test="testcheck.txt"
else
  test=$2
fi
if [ -z "$PROMPT" ]; then
  echo "ABORT: PROMPT environment variable not set!"
  exit 2
fi
# Format of the test description
# numtests (number of expected .ktest files)
# errortype,expected,lineno  (errortype can be assert or ptr, expected yes or no, 
#                                       lineno is line number in the source file)
#
# first check if test numbers match
if [ ! -d $topdir ]; then
   echo "ABORT: Test directory "$dir" does not exist!"
   exit 2
fi
cd $topdir
totaltests=0
numExec=0
numOK=0
numFailed=0
numAbort=0
tests=`find . -type d -print`
for dir in $tests; 
do
   if [[ $dir  == "." ]]; then
      continue
   elif [[ $dir == ".." ]]; then
      continue
   fi
   echo "processing "$dir
   fdir=${dir/\./"$topdir"}
   cd $fdir
   if [ ! -f run.sh ]; then
      continue
   fi
   if [ -f testresults.txt ]; then
      rm testresults.txt
   fi
   if [ ! -f $test ]; then
      ((numAbort++))
      echo "ABORT: test "$dir":  Test file "$test" does not exist!"  >> testresults.txt
      continue
   fi
   if [ -d klee-out* ]; then
      rm -r klee-out*
   fi
   sutl=$(ls *.bc)
   if [[ ${#sutl[@]} -gt 1 ]]; then
      if [ -f main.bc ]; then
         sut=main.bc
         echo "WARNING: test "$dir": Using main.bc as the main bitcode"
      else
         echo "SKIP: test "$dir": Multiple bitcode files and no main.bc!" 
         ((numAbort++))
         continue
      fi
   elif [[ ${#sutl[@]} = 1 ]]; then
      sut=${sutl[0]} 
   else 
      echo "SKIP: test "$dir": No bitcode file!" 
   fi
   ((totaltests++))
   echo "Executing test under "$dir
   ./run.sh $sut 2>/dev/null 1>/dev/null
   if [ ! -d klee-out* ]; then
      echo "WARNING: Incomplete execution, skipping"  >> testresults.txt
      ((numAbort++))
      continue
   fi
   ((numExec++))
   i=0
   echo "Reading and checking the test description file "$dir/$test
   while read line;
   do
      ((status=0))
      if [[ $i = 0 ]];
      then
            numtests=$(ls -l klee-last/*.ktest 2> /dev/null | wc -l)
            if [[ $numtests = $line ]];
            then
               echo "OK: test "$dir":  Number of expected tests "$line" match" >> testresults.txt
            else  
               echo "FAIL: test "$dir":  Expected "$line" tests, found "$numtests >> testresults.txt
               status=1
            fi
      else
         IFS=',' 
         tokens=( $line )
         numerrors=$(ls -l klee-last/*.${tokens[0]}.err 2> /dev/null | wc -l)
         if [[ ${tokens[1]} = "yes" ]];
         then
            if [[ $numerrors = 0 ]];
            then
               echo "FAIL: test "$dir":  Expected "${tokens[0]}" error at line "${tokens[2]}", error not generated!"  >> testresults.txt
               status=1
            else
               result=$(grep Line klee-last/*.${tokens[0]}.err | grep -c ${tokens[2]})
               if [[ $result -gt 0 ]];
               then
                  echo "OK: test "$dir":  Found expected "${tokens[0]}" error at line "${tokens[2]} >> testresults.txt
               else
                  echo "FAIL: test "$dir":  Expected "${tokens[0]}" error at line "${tokens[2]}", error not generated!" >> testresults.txt
                  status=1
               fi
            fi
         elif [[ ${tokens[1]} = "no" ]];
         then
            if [[ $numerrors = 0 ]];
            then
               echo "OK: test "$dir":  "${tokens[0]}" at line "${tokens[2]}" error not triggered as expected" >> testresults.txt
            else 
               result=$(grep Line klee-last/*.${tokens[0]}.err | grep -c ${tokens[2]})
               if [[ $result -gt 0 ]];
               then          
                  echo "FAIL: test "$dir":  Expected not triggering of "${tokens[0]}" error at line "${tokens[2]}", but found it!" >> testresults.txt
                  status=1
               else
                  echo "OK: test "$dir":  "${tokens[0]}" at line "${tokens[2]}" error not triggered as expected"  >> testresults.txt
               fi
            fi
         else 
            echo "ABORT:  test "$dir": Unknown token"${tokens[1]}
            echo "ABORT:  test "$dir": Unknown token"${tokens[1]} >> testresults.txt
            status=2
         fi
     fi
     ((i++))
   done < "$test"
   echo "status="$status 
   if [[ $status = 0 ]]; then
      ((numOK++))
      echo "OK: test "$dir
   elif [[ $status = 1 ]]; then
      ((numFailed++))
      echo "FAIL: test "$dir
   else
      ((numAbort++))
      echo "ABORT: test "$dir 
   fi
   rm -r klee-out*
   cd $topdir
done
echo "#tests= "$totaltests
echo "#exec= "$numExec
echo "#abort= "$numAbort
echo "#fail= "$numFailed
echo "#OK= "$numOK
