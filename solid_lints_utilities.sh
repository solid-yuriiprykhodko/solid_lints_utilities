# Private functions
function _ensureInDartPackage() {
    if [ ! -f ./pubspec.yaml ]; then
        echo "pubspec.yaml not found in pwd, aborting."
        exit 1
    fi
}

# Export a function without printing it to stdout
function _exportFunctionQuietly() {
    fn=$1

    export -f $fn >/dev/null
}

# solid_lints: ^0.0.10 --> solid_lints: 0.0.10
function _removeVersionCaret() {
    pubspec=$1
    dependency=$2

    sed -i '' -e "s/${dependency}: ^/${dependency}: /g" $pubspec
}

# -----------------------------------------------------------------------------
# Public functions

# add solid_lints dependency and all necessary configuration
# files
function addsolidlints() {
    _ensureInDartPackage
    # Add dependency
    dart pub add solid_lints --dev
    _removeVersionCaret pubspec.yaml solid_lints

    # Add main analysis_options
    echo 'include: package:solid_lints/analysis_options.yaml' >analysis_options.yaml

    # If `test` dir exists, add test analysis_options
    if [ -d "test" ]; then
        echo 'include: package:solid_lints/analysis_options_test.yaml' >test/analysis_options.yaml
    fi
}

# -----------------------------------------------------------------------------
# Exports

_exportFunctionQuietly addsolidlints
alias dcm='dart run dart_code_metrics:metrics'
