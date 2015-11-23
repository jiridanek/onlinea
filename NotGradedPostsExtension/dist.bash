PUB=~/Bin/dart-sdk/bin/pub

rm -rf build

#$PUB build --mode debug
 $PUB build

rm -rf dist
mkdir dist
mkdir -p dist/packages/chrome/
mkdir -p dist/packages/is/

cp -R build/web/images dist/
cp build/web/*.html dist/
cp build/web/*.dart.js dist/
cp build/web/*.js dist/
cp build/web/manifest.json dist/

install build/web/packages/chrome/bootstrap.js dist/packages/chrome/
install build/web/packages/ismu/xpath.js dist/packages/is/