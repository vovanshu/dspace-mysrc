#!/bin/bash

BINEXEC='/home/dspace/bin40/bin/dspace'

psql -U postgres dspace40 < /home/dspace/db/dspace40.sql
$BINEXEC itemcounter
$BINEXEC index-discovery
# $BINEXEC index-discovery -b

exit 0