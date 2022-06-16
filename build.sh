#!/bin/sh

set -e

# Lambda layer version will depends on canvas version
CANVAS_VERSION="2.9.1"
FABRIC_VERSION="3.6.2"

echo '-----'
echo 'Step 1: Cleanup'
echo '-----'

echo 'Removing old archive...'
rm -rf dist/

echo 'Removing old built layers'
rm -rf build/

echo '-----'
echo 'Step 2: Build'
echo '-----'

mkdir -p build
cd build

mkdir -p nodejs
cd nodejs

echo 'Initializing npm package...'
npm init --yes

jq --arg LAYER_NAME "lambda-layer-canvas-fabric-arm64" --arg LAYER_DESCRIPTION "AWS Lambda Layer with node-canvas, and Fabric included for ARM64 runtime" --arg LAYER_VERSION "$CANVAS_VERSION" --arg LAYER_AUTHOR "Phumrapee Limpianchop" '.name = $LAYER_NAME | .description = $LAYER_DESCRIPTION | .version = $LAYER_VERSION | .license = "MIT" | .author = $LAYER_AUTHOR' package.json > package-tmp.json
mv -f package-tmp.json package.json

echo 'Installing dependencies...'

npm i canvas@$CANVAS_VERSION --build-from-source
npm i fabric@$FABRIC_VERSION

cd ..
mkdir -p lib

echo 'Copying native runtime binaries...'
find nodejs/node_modules -type f -name '*.node' 2>/dev/null | grep -v 'obj\.target' | xargs ldd | awk 'NF == 4 { system("cp " $3 " lib") }'

echo '-----'
echo 'Step 3: Packaging'
echo '-----'

cd ..

echo 'Creating archive...'
mkdir -p dist
zip -q -r dist/layer.zip build/lib build/nodejs

echo 'Done!'
