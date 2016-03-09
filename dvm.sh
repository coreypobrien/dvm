# Docker Version Manager wrapper for *nix
# Implemented as a POSIX-compliant function
# Should work on sh, dash, bash, ksh, zsh
# To use, source this file from your bash profile

{ # This ensures the entire script is downloaded

DVM_SCRIPT_SOURCE="$_"

__dvm_has() {
  type "$1" > /dev/null 2>&1
}

# Make zsh glob matching behave same as bash
# This fixes the "zsh: no matches found" errors
if __dvm_has "unsetopt"; then
  unsetopt nomatch 2>/dev/null
  DVM_CD_FLAGS="-q"
fi

# Auto detect the DVM_DIR when not set
if [ -z "$DVM_DIR" ]; then
  if [ -n "$BASH_SOURCE" ]; then
    DVM_SCRIPT_SOURCE="${BASH_SOURCE[0]}"
  fi
  export DVM_DIR=$(cd $DVM_CD_FLAGS $(dirname "${DVM_SCRIPT_SOURCE:-$0}") > /dev/null && \pwd)
fi
unset DVM_SCRIPT_SOURCE 2> /dev/null

dvm() {
  if [ ! -f "$DVM_DIR/dvm-helper/dvm-helper" ]; then
    echo "Installation corrupt: dvm-helper is missing. Please reinstall dvm."
    return 1
  fi

  DVM_OUTPUT="$DVM_DIR/.tmp/dvm-output.sh"
  rm -f "$DVM_OUTPUT"

  DVM_DIR=$DVM_DIR $DVM_DIR/dvm-helper/dvm-helper --shell sh $@

  if [ -e $DVM_OUTPUT ]; then
    source $DVM_OUTPUT
  fi
}

}
