#!/bin/zsh
for f in * ; do

   echo "--------------------------------------";
   echo $f;
   echo "                                      ";
   sqlite3 $f .dump | grep "snazi";
   
   echo "--------------------------------------";
   echo "                                      ";
    # do some stuff here with "$f"
    # remember to quote it or spaces may misbehave
done
