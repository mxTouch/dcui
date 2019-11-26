#carthage update --platform iOS --no-use-binaries --no-build
#grep -lR "codeCoverageEnabled" --include *.xcscheme --null Carthage | xargs -0 sed -i '' -e 's/codeCoverageEnabled = "YES"/codeCoverageEnabled = "NO"/g'
carthage build --platform ios
