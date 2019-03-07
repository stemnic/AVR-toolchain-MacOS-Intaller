# Title: AVR toolchain installer macOS
# Author: Ole Sivert Aarhaug aka OS aka root 2019
# The toolchainurl might not last. Latest version can be found under https://www.microchip.com/mplab/avr-support/avr-and-arm-toolchains-c-compilers
TOOLCHAINURL="http://ww1.microchip.com/downloads/en/DeviceDoc/avr8-gnu-toolchain-osx-3.6.2.503-darwin.any.x86_64.tar.gz"
ATPACK="http://packs.download.atmel.com/Atmel.ATmega_DFP.1.3.300.atpack"
CURRENTDIR=$PWD
function downloadAvr {
    if [ -d "$TMPDIR/avrkurs" ]; then
        rm -R $TMPDIR/avrkurs
    fi
    mkdir $TMPDIR/avrkurs/
    echo "Downloading...."
    curl $TOOLCHAINURL > $TMPDIR/avrkurs/toolchain.tar.gz
    cd $TMPDIR/avrkurs
    curl $ATPACK > atpack.zip
    gunzip -c toolchain.tar.gz | tar xopf -
    echo "Installing....."
    if [ -d "$HOME/Library/avr-toolchain" ]; then
        rm -R $HOME/Library/avr-toolchain
    fi
    if [ -d "$HOME/Library/avr-atpack" ]; then
        rm -R $HOME/Library/avr-atpack
    fi
    mkdir $HOME/Library/avr-atpack
    unzip $TMPDIR/avrkurs/atpack.zip -d $HOME/Library/avr-atpack/
    mv avr8-gnu-toolchain-darwin_x86_64/ $HOME/Library/avr-toolchain
    echo "export PATH="$HOME/Library/avr-toolchain/bin:\$PATH"" >> $HOME/.bash_profile
    rm -R $TMPDIR/avrkurs
    echo "Done!"
}

echo "  ___  _   _______       _   __                            "
echo " / _ \| | | | ___ \     | | / /                            "
echo "/ /_\ \ | | | |_/ /_____| |/ / _   _ _ __ ___              "
echo "|  _  | | | |    /______|    \| | | | '__/ __|             "
echo "| | | \ \_/ / |\ \      | |\  \ |_| | |  \__ \             "
echo "\_| |_/\___/\_| \_|     \_| \_/\__,_|_|  |___/             "
echo "                                                           "
echo "                                                           "
echo "___  ___             _____          _        _ _           "
echo "|  \/  |            |_   _|        | |      | | |          "
echo "|      | __ _  ___    | | _ __  ___| |_ __ _| | | ___ _ __ "
echo "| |\/| |/ _  |/ __|   | || '_ \/ __| __/ _  | | |/ _ \ '__|"
echo "| |  | | (_| | (__   _| || | | \__ \ || (_| | | |  __/ |   "
echo "\_|  |_/\__,_|\___|  \___/_| |_|___/\__\__,_|_|_|\___|_|   "
echo "-----------------------------------------------------------"
echo "This installer will download, install and add to path the AVR-8bit toolchain for MacOS 64-bit"
printf "Do you want to continue? [Y/n] "
read ANS
if [ "$ANS" == 'Y' ] || [ "$ANS" == '' ]; then
    downloadAvr
else
    exit 0
fi
