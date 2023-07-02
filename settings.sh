VIVADO_VERSION=2022.2

. $HOME/tools/Xilinx/Vivado/$VIVADO_VERSION/settings64.sh
. $HOME/opt/oss-cad-suite/environment

# This will redirect all Vivado log output to
# a folder called vivado_tmp located next to
# this script.
PATH_TO_SETTINGS_SH=$(readlink -f $BASH_SOURCE)
BASE_DIR=$(dirname $PATH_TO_SETTINGS_SH)
VIVADO_TMP=$BASE_DIR/vivado_tmp/
echo $VIVADO_TMP
alias start_vivado="vivado -mode tcl -tempDir $VIVADO_TMP"
