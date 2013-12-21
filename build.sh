#!/bin/env bash

DUMPARGS=$@
BUILDDIR=`mktemp -d`
DBNAME=${@: -1}
WORKINGDIR=`pwd`

if [ -z $DBNAME ]; then
    echo "No database specified";
    exit;
fi

mysqldump --compact --compress --extended-insert --hex-blob --single-transaction --ignore-table=$DBNAME.Asset $DUMPARGS  > "$BUILDDIR/install.sql"
mysqldump --compact --compress --single-transaction $DUMPARGS Asset >> "$BUILDDIR/install.sql"

cp -r $WORKINGDIR/public $BUILDDIR

cd $BUILDDIR
tar -cvzf $WORKINGDIR/install.tar.gz ./*
cd $WORKINGDIR
