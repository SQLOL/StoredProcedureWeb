#!/bin/env bash

DUMPARGS=$@
BUILDDIR=`mktemp -d`
DBNAME=${@: -1}
WORKINGDIR=`pwd`

mysqldump --compact --compress --extended-insert --hex-blob --skip-lock-tables --single-transaction --ignore-table=$DBNAME.Asset $DUMPARGS  > "$BUILDDIR/install.sql"
mysqldump --compact --compress --skip-lock-tables --single-transaction --no-data $DUMPARGS Asset >> "$BUILDDIR/install.sql"
mysqldump --compact --compress --skip-lock-tables --single-transaction --no-create-info $DUMPARGS Asset >> "$BUILDDIR/install.sql"

cp -r $WORKINGDIR/public $BUILDDIR

cd $BUILDDIR
tar -cvzf $WORKINGDIR/install.tar.gz ./*
cd $WORKINGDIR
