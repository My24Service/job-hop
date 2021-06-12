#!/bin/bash

DIR=`pwd`

rm -f $DIR/lib/core/app_config.dart

ln -s $DIR/lib/core/app_config-live.dart $DIR/lib/core/app_config.dart
