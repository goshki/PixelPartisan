#!/bin/sh

export WORKSPACE="`pwd`/.."

#-static-link-runtime-shared-libraries

mxmlc -warnings -strict -optimize -incremental -target-player "9.0.0" -sp=src/main/actionscript src/main/actionscript/pl/vigeo/partisan/PixelPartisan.as && mv src/main/actionscript/pl/vigeo/partisan/PixelPartisan.swf bin/

