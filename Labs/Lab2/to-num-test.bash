#!/bin/bash

PROG=to-num
POINTS=0
CLEANUP=1
WARNINGS=0
#DIFF_OPTIONS="-B -w -i"
DIFF_OPTIONS=""
LAB=Lab2

SDIR=.
JDIR=~rchaney/Classes/cs201/Labs/${LAB}

while getopts "xC" opt
do
    case $opt in
        x)
            # If you really, really, REALLY want to watch what is going on.
            echo "Hang on for a wild ride."
            set -x
            ;;
        C)
            # Skip removal of data files
            CLEANUP=0
            ;;
        \?)
            echo "Invalid option" >&2
            echo ""
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument." >&2
            exit 1
            ;;
    esac
done

if [ ! -e ${PROG}.c ]
then
    echo "No ${PROG}.c exists. Cannot continue."
    exit 1
fi

gcc -Wall -g -o ${PROG} ${PROG}.c 1> out.log 2> warn.log

if [ $? -ne 0 ]
then
    echo "compilation failed"
    echo "zero points"
    cat  out.log warn.log
    exit 1
else
    NUM_BYTES=`wc -c < warn.log`
    if [ ${NUM_BYTES} -ne 0 ]
    then
        WARNINGS=1
        echo "  --- You have compiler warning messages. That is -20 percent!"
    else
        echo "  +++ You have no compiler warning messages. Good job."
        ((POINTS+=5))
    fi
fi

for I in `shuf -i 1-6 -n 6`
do
    ${SDIR}/${PROG} -f < ${JDIR}/${PROG}-${I}.txt > S-tonu${I}.out
    ${JDIR}/${PROG} -f < ${JDIR}/${PROG}-${I}.txt > J-tonu${I}.out

    diff ${DIFF_OPTIONS} S-tonu${I}.out J-tonu${I}.out > /dev/null
    if [ $? -eq 0 ]
    then
        ((POINTS+=10))
        echo "  +++ ${PROG} on test file ${PROG}-${I}.txt is good +++"
    else
        echo "  --- ${PROG} on test file ${PROG}-${I}.txt is sad  ---"
        CLEANUP=0
        echo "    try this: diff ${DIFF_OPTIONS} -y S-tonu${I}.out J-tonu${I}.out"
    fi
done

echo "You have ${POINTS} points out of 65"
if [ ${WARNINGS} -ne 0 ]
then
    POINTS=$(echo ${POINTS}*.8 | bc)
    echo "But, you have compiler warnings"
    echo "  So, you get this many points ${POINTS}"
fi

if [ ${CLEANUP} -eq 1 ]
then
    rm [JS]-tonu[1-6].out out.log warn.log
    rm ${PROG}
fi
