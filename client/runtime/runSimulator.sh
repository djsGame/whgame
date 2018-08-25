# $(cd `dirname $0`; pwd)
cd ..
basepath=$(cd `dirname $0`; pwd)
echo '工作空间：'$basepath

AHMJ_MAC_RUNNABLE=$basepath/runtime/mac/FishRuntime.app/Contents/MacOS/GloryProject-desktop
$AHMJ_MAC_RUNNABLE -workdir $basepath"/client/" -execution -console disable