#!/bin/bash

DIR=`pwd`

if [ -f "$DIR/lib/core/app_config.dart" ]; then
  rm -f $DIR/lib/core/app_config.dart
fi

ln -s $DIR/lib/core/app_config-dev.dart $DIR/lib/core/app_config.dart
