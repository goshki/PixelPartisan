#!/bin/sh

export WORKSPACE="`pwd`/.."

mxmlc -debug -warnings -strict -optimize -incremental -static-link-runtime-shared-libraries -target-player "9.0.0" -sp=src/main/actionscript src/main/actionscript/pl/vigeo/partisan/PixelPartisan.as && mv src/main/actionscript/pl/vigeo/partisan/PixelPartisan.swf bin/

