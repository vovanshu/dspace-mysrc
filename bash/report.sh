#!/bin/bash

BINEXEC='/home/dspace/bin40/bin/dspace'

echo $BINEXEC stat-general
$BINEXEC stat-general
echo $BINEXEC stat-monthly
$BINEXEC stat-monthly
echo $BINEXEC stat-report-general
$BINEXEC stat-report-general
echo $BINEXEC stat-report-monthly
$BINEXEC stat-report-monthly

exit 0