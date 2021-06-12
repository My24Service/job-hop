#!/bin/bash

DIR=`pwd`

$DIR/lib/core/app_config.dart

ln -s $DIR/lib/core/app_config-dev.dart $DIR/lib/core/app_config.dart
