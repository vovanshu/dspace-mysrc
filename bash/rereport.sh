#!/bin/bash

BINEXEC='/home/dspace/bin40/bin/dspace'
PATHREPORTS='/home/dspace/bin40/reports'
PATHLOGS='/home/dspace/bin40/log'

echo cleaning $PATHREPORTS/*.html
rm $PATHREPORTS/*.html
echo $PATHLOGS/dspace-log-monthly*.dat
rm $PATHLOGS/dspace-log-monthly*.dat
# 
echo $BINEXEC stat-initial
$BINEXEC stat-initial
echo $BINEXEC stat-report-initial
$BINEXEC stat-report-initial

echo $BINEXEC stat-general
$BINEXEC stat-general
echo $BINEXEC stat-monthly
$BINEXEC stat-monthly
echo $BINEXEC stat-report-general
$BINEXEC stat-report-general
echo $BINEXEC stat-report-monthly
$BINEXEC stat-report-monthly

exit 0