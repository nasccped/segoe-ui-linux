#!/bin/bash
# mrbvrz - https://hasansuryaman.com

# Colours Variables
RESTORE='\033[0m'
RED='\033[00;31m'
GREEN='\033[00;32m'
YELLOW='\033[00;33m'
BLUE='\033[00;34m'
PURPLE='\033[00;35m'
CYAN='\033[00;36m'
LBLACK='\033[01;90m'
LIGHTGRAY='\033[00;37m'
LRED='\033[01;31m'
LGREEN='\033[01;32m'
LYELLOW='\033[01;33m'
LBLUE='\033[01;34m'
LPURPLE='\033[01;35m'
LCYAN='\033[01;36m'
WHITE='\033[01;37m'

# Cursor Movement
MOVE_CURSOR_UP='\033[1A'

# Erase content
ERASER='\r                                                                      \r'

# Destination directory
ROOT_UID=0
if [ "$UID" -eq "$ROOT_UID" ]; then
  DEST_DIR="/usr/share/fonts/Microsoft/TrueType/SegoeUI/"
else
  DEST_DIR="$HOME/.local/share/fonts/Microsoft/TrueType/SegoeUI/"
fi
WINE_FONT_DIR="$HOME/.wine/drive_c/windows/Fonts/"

# Check Internet Conection
function cekkoneksi(){
    # For this function, I'm using carriage returning (\r) to erase
    # an already printed line

    # print section title
    echo -ne " ${WHITE}[ .... ] Checking ${LBLACK}for internet connection...${RESTORE}"
    sleep 1

    # List all network interfaces
    interfaces=$(ip -o link show | awk -F': ' '{print $2}')

    # Flag to track internet connection status
    internet_connected=0

    # Iterate over each network interface and check internet connectivity
    for interface in $interfaces; do
        # erase section title
        echo -ne "${ERASER}"
        echo -ne " ${WHITE}[ .... ] Checking \`${LCYAN}$interface${WHITE}\`${LBLACK} interface${RESTORE}"
        sleep 0.5
        if ping -c 1 -w 2 -I  $interface google.com &> /dev/null; then
            echo -ne "${ERASER}"
            echo -e " ${WHITE}[${GREEN}  OK  ${WHITE}] Interface \`${LCYAN}$interface${WHITE}\`${LBLACK} is connected${RESTORE}"
            internet_connected=1
            break  # If connected on any interface, no need to continue testing
        # This block is no longer necessary. The fail alert will be overwrited by the connection error bellow vvv
        # else
        #    echo -ne "\r ${WHITE}[${RED}  FAIL  ${WHITE}] Interface${LBLACK} \`${LRED}$interface${LBLACK}\` isn't connected"
        fi
    done

    # Check overall connection status
    if [ $internet_connected -eq 0 ]; then
        echo -e " ${WHITE}[${RED} FAIL ${WHITE}] Internet connection is required to proceed with"
        echo -e "          this scripts...${RESTORE}\n"
        exit 0
    fi
}

function cekwget(){
    # print section title
    echo -ne " ${WHITE}[ .... ] Checking${LBLACK} for Wget...${RESTORE}"
    sleep 1.5
    which wget > /dev/null 2>&1
    status=$?

    echo -ne "${ERASER}"

    if [ "$status" -eq "0" ]; then
        echo -e " ${WHITE}[${GREEN}  OK  ${WHITE}] Program \`${LCYAN}wget${WHITE}\`${LBLACK} was found${RESTORE}"
    else
        echo -e " ${WHITE}[${LYELLOW} WARN ${WHITE}]${RESTORE} The \`${LCYAN}wget${RESTORE}\` program may be necessary to proceed"
        echo -e "          with the script!";
        continueWget
    fi
}

function cekfont(){
    echo -ne " ${WHITE}[ .... ] Checking${LBLACK} for Segoe UI font${RESTORE}"
    sleep 1
    fc-list | grep -i "Segoe UI" >/dev/null 2>&1
    status=$?
    echo -ne "${ERASER}";
    if [ "$status" -eq "0" ]; then
        echo -e " ${WHITE}[  ${LGREEN}OK${WHITE}  ] Segoe-UI Font ${LBLACK}is already installed${RESTORE}\n"
    else
        echo -e " ${WHITE}[ ${LYELLOW}WARN${WHITE} ] Segoe-UI Font ${LBLACK}isn't installed${RESTORE}"
        continueFont
    fi
}

function continueFont(){
    echo -e "$LGREEN Do you want to install Segoe-UI Font? (y)es, (n)o :"
    read  -p ' ' INPUT
    case $INPUT in
    [Yy]* ) fontinstall;;
    [Nn]* ) end;;
    * ) echo -e "$RED\n Sorry, try again."; continueFont;;
  esac
}

function fontinstall(){
    echo -ne " ${WHITE}[ .... ] Checking ${LBLACK}all necessary fonts${RESTORE}"
    sleep 1
    get_from_github=0
    font_files=(        \
        "segoeui.ttf"   \
        "segoeuib.ttf"  \
        "segoeuii.ttf"  \
        "segoeuiz.ttf"  \
        "segoeuil.ttf"  \
        "seguili.ttf"   \
        "segoeuisl.ttf" \
        "seguisli.ttf"  \
        "seguisb.ttf"   \
        "seguisbi.ttf"  \
        "seguibl.ttf"   \
        "seguibli.ttf"  \
        "seguiemj.ttf"  \
        "seguisym.ttf"  \
    )

    for fnt in "${font_files[@]}"; do
        if [ ! -f "font/$fnt" ]; then
            get_from_github=1
        break
        fi
    done
    # TODO: this will be resumed
    exit 0

    mkdir -p "$DEST_DIR"
    if [ -d font ]; then
        cp font/segoeui.ttf "$DEST_DIR"/segoeui.ttf > /dev/null 2>&1 # regular
        cp font/segoeuib.ttf "$DEST_DIR"/segoeuib.ttf > /dev/null 2>&1 # bold
        cp font/segoeuii.ttf "$DEST_DIR"/segoeuii.ttf > /dev/null 2>&1 # italic
        cp font/segoeuiz.ttf "$DEST_DIR"/segoeuiz.ttf > /dev/null 2>&1 # bold italic
        cp font/segoeuil.ttf "$DEST_DIR"/segoeuil.ttf > /dev/null 2>&1 # light
        cp font/seguili.ttf "$DEST_DIR"/seguili.ttf > /dev/null 2>&1 # light italic
        cp font/segoeuisl.ttf "$DEST_DIR"/segoeuisl.ttf > /dev/null 2>&1 # semilight
        cp font/seguisli.ttf "$DEST_DIR"/seguisli.ttf > /dev/null 2>&1 # semilight italic
        cp font/seguisb.ttf "$DEST_DIR"/seguisb.ttf > /dev/null 2>&1 # semibold
        cp font/seguisbi.ttf "$DEST_DIR"/seguisbi.ttf > /dev/null 2>&1 # semibold italic
        cp font/seguibl.ttf "$DEST_DIR"/seguibl.ttf > /dev/null 2>&1 # bold light
        cp font/seguibli.ttf "$DEST_DIR"/seguibli.ttf > /dev/null 2>&1 # bold light italic
        cp font/seguiemj.ttf "$DEST_DIR"/seguiemj.ttf > /dev/null 2>&1 # emoji
        cp font/seguisym.ttf "$DEST_DIR"/seguisym.ttf > /dev/null 2>&1 # symbol
        cp font/seguihis.ttf "$DEST_DIR"/seguihis.ttf > /dev/null 2>&1 # historic

        if [ -d $WINE_FONT_DIR ]; then
            cp font/segoeui.ttf "$WINE_FONT_DIR"/segoeui.ttf > /dev/null 2>&1 # regular
            cp font/segoeuib.ttf "$WINE_FONT_DIR"/segoeuib.ttf > /dev/null 2>&1 # bold
            cp font/segoeuii.ttf "$WINE_FONT_DIR"/segoeuii.ttf > /dev/null 2>&1 # italic
            cp font/segoeuiz.ttf "$WINE_FONT_DIR"/segoeuiz.ttf > /dev/null 2>&1 # bold italic
            cp font/segoeuil.ttf "$WINE_FONT_DIR"/segoeuil.ttf > /dev/null 2>&1 # light
            cp font/seguili.ttf "$WINE_FONT_DIR"/seguili.ttf > /dev/null 2>&1 # light italic
            cp font/segoeuisl.ttf "$WINE_FONT_DIR"/segoeuisl.ttf > /dev/null 2>&1 # semilight
            cp font/seguisli.ttf "$WINE_FONT_DIR"/seguisli.ttf > /dev/null 2>&1 # semilight italic
            cp font/seguisb.ttf "$WINE_FONT_DIR"/seguisb.ttf > /dev/null 2>&1 # semibold
            cp font/seguisbi.ttf "$WINE_FONT_DIR"/seguisbi.ttf > /dev/null 2>&1 # semibold italic
            cp font/seguibl.ttf "$WINE_FONT_DIR"/seguibl.ttf > /dev/null 2>&1 # bold light
            cp font/seguibli.ttf "$WINE_FONT_DIR"/seguibli.ttf > /dev/null 2>&1 # bold light italic
            cp font/seguiemj.ttf "$WINE_FONT_DIR"/seguiemj.ttf > /dev/null 2>&1 # emoji
            cp font/seguisym.ttf "$WINE_FONT_DIR"/seguisym.ttf > /dev/null 2>&1 # symbol
            cp font/seguihis.ttf "$WINE_FONT_DIR"/seguihis.ttf > /dev/null 2>&1 # historic
            echo -e "$GREEN\n Font installed to WINE $LBLUE'$WINE_FONT_DIR'"
        fi

    else
        # Download font from github static link code
        wget -q https://github.com/mrbvrz/segoe-ui/raw/master/font/segoeui.ttf?raw=true -O "$DEST_DIR"/segoeui.ttf > /dev/null 2>&1 # regular
        wget -q https://github.com/mrbvrz/segoe-ui/raw/master/font/segoeuib.ttf?raw=true -O "$DEST_DIR"/segoeuib.ttf > /dev/null 2>&1 # bold
        wget -q https://github.com/mrbvrz/segoe-ui/raw/master/font/segoeuii.ttf?raw=true -O "$DEST_DIR"/segoeuii.ttf > /dev/null 2>&1 # italic
        wget -q https://github.com/mrbvrz/segoe-ui/raw/master/font/segoeuiz.ttf?raw=true -O "$DEST_DIR"/segoeuiz.ttf > /dev/null 2>&1 # bold italic
        wget -q https://github.com/mrbvrz/segoe-ui/raw/master/font/segoeuil.ttf?raw=true -O "$DEST_DIR"/segoeuil.ttf > /dev/null 2>&1 # light
        wget -q https://github.com/mrbvrz/segoe-ui/raw/master/font/seguili.ttf?raw=true -O "$DEST_DIR"/seguili.ttf > /dev/null 2>&1 # light italic
        wget -q https://github.com/mrbvrz/segoe-ui/raw/master/font/segoeuisl.ttf?raw=true -O "$DEST_DIR"/segoeuisl.ttf > /dev/null 2>&1 # semilight
        wget -q https://github.com/mrbvrz/segoe-ui/raw/master/font/seguisli.ttf?raw=true -O "$DEST_DIR"/seguisli.ttf > /dev/null 2>&1 # semilight italic
        wget -q https://github.com/mrbvrz/segoe-ui/raw/master/font/seguisb.ttf?raw=true -O "$DEST_DIR"/seguisb.ttf > /dev/null 2>&1 # semibold
        wget -q https://github.com/mrbvrz/segoe-ui/raw/master/font/seguisbi.ttf?raw=true -O "$DEST_DIR"/seguisbi.ttf > /dev/null 2>&1 # semibold italic
        wget -q https://github.com/mrbvrz/segoe-ui/raw/master/font/seguibl.ttf?raw=true -O "$DEST_DIR"/seguibl.ttf > /dev/null 2>&1 # bold light
        wget -q https://github.com/mrbvrz/segoe-ui/raw/master/font/seguibli.ttf?raw=true -O "$DEST_DIR"/seguibli.ttf > /dev/null 2>&1 # bold light italic
        wget -q https://github.com/mrbvrz/segoe-ui/raw/master/font/seguiemj.ttf?raw=true -O "$DEST_DIR"/seguiemj.ttf > /dev/null 2>&1 # emoji
        wget -q https://github.com/mrbvrz/segoe-ui/raw/master/font/seguisym.ttf?raw=true -O "$DEST_DIR"/seguisym.ttf > /dev/null 2>&1 # symbol
        wget -q https://github.com/mrbvrz/segoe-ui/raw/master/font/seguihis.ttf?raw=true -O "$DEST_DIR"/seguihis.ttf > /dev/null 2>&1 # historic
    fi

    fc-cache -f "$DEST_DIR"
    echo -e "$GREEN\n Font installed on $LBLUE'$DEST_DIR'"
}

function wgetinstall(){
    echo -ne " ${WHITE}[ .... ] Installing \`${LCYAN}wget${WHITE}\` ${LBLACK}with ${LGREEN}apt ${LBLACK}package manager${RESTORE}"
    sleep 1.5
    echo -ne "${ERASER}"
    if [ ! "$UID" -eq "$ROOT_UID" ]; then
        echo -e " ${WHITE}[ ${LRED}FAIL${WHITE} ] You need to run as ${LGREEN}sudo${WHITE} to install \`${LCYAN}wget${WHITE}\`."
        echo -e "          Consider using \`${LGREEN}sudo ./install.sh${WHITE}\`${RESTORE}\n"
        exit 0
    fi
    # use 'and' operator (better approach). Install wget only if the 'apt update' returns success
    apt update > /dev/null 2>&1 && apt install -y wget > /dev/null 2>&1
    if [ ! $? -eq 0 ]; then
        echo -e " ${WHITE}[ ${LRED}FAIL${WHITE} ] Couldn't run ${LGREEN}apt update ${WHITE}+ ${LGREEN}apt install -y wget${WHITE}."
        echo -e "          Consider installing \`${LCYAN}wget${WHITE}\` manually by your OS"
        echo -e "          package manager!${RESTORE}\n"
        exit 0
    fi
}

function end(){
    echo -e "\n${LPURPLE}          Bye....   ;)${RESTORE}\n"
    exit 0
}

continueWget() {
  echo -ne "\r          Do you want to install Wget? [(y)es/(n)o]"
  read  -p ' ' INPUT
  case $INPUT in
    [Yy]* ) echo -ne "${ERASER}${MOVE_CURSOR_UP}${ERASER}${MOVE_CURSOR_UP}${ERASER}${MOVE_CURSOR_UP}${ERASER}"; wgetinstall;;
    [Nn]* ) end;;
    # Move the cursor 1 row up, overwrite the line and call the question again
    * ) echo -ne "${MOVE_CURSOR_UP}${ERASER}"; continueWget;;
  esac
}

function banner(){
    echo -e "$LYELLOW"
    echo    "                                         _    __            _   "
    echo    "                                        (_)  / _|          | |  "
    echo    "  ___  ___  __ _  ___   ___        _   _ _  | |_ ___  _ __ | |_ "
    echo    " / __|/ _ \/ _  |/ _ \ / _ \  __  | | | | | |  _/ _ \|  _ \| __|"
    echo    " \__ \  __/ (_| | (_) |  __/ (__) | |_| | | | || (_) | | | | |_ "
    echo    " |___/\___|\__, |\___/ \___|       \__,_|_| |_| \___/|_| |_|\__|"
    echo    "            __/ |                                               "
    echo -e "           |___/             $LPURPLE mrbvrz$WHITE -$LRED https://hasansuryaman.com"
    echo    ""
    echo -e "$WHITE ---------------------------------------------------------------"
    echo -e "$RESTORE"
}

main(){
    clear
    banner
    cekkoneksi
    cekwget
    cekfont
}

main
