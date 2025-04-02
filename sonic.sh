#!/bin/sh
#Sonic The Hedgehog Setup Script

name="SonicTheHedgehog"
Game=SonicTheHedgehog
game=sonicthehedgehog
configdir="/home/$USER/.config/$Game"
Sysdir=/usr/share/games/$Game
binname=sonic1
image_path="/usr/share/games/$Game/sonic-title.png"
icon_path="/usr/share/games/$Game/sonic.png"
 
if [ -d "$configdir" ]; then
  ### Take action if $configdir exists ###
  echo "Starting game"
  cd $configdir 
  ./sonic1
else
  ###  Control will jump here if $configdir does NOT exists ###
  echo "Welcome to the $name setup, we will begin setting the game up for you."
  yad --width=750 --height=100 --info --title="$name Installation" --window-icon="$icon_path" --image="$image_path" --text="Welcome to the $name setup, we will begin setting the game up for you." --button="OK:1" --button="Cancel:0"
  if [ $? -eq 0 ]; then
  echo "Script exited by user"
  exit 0
fi
(
echo "10" ; sleep 1
echo "# Setting game files" ; sleep 1
echo "50" ; sleep 1
echo "# Creating config folder" ; sleep 1
mkdir $configdir
echo "# Select $name Apk or data file"
echo "60" ; sleep 1
yad --width=750 --height=100 --info --title="$name Installation" --window-icon="$icon_path" --image="$image_path" --text="Select $name apk or already extracted data file, make sure it is not he xapk file. The is needed for the game to work." --button="OK:1" --button="Cancel:0"
  if [ $? -eq 0 ]; then
  echo "Script exited by user"
  exit 0
fi
selected_file=$(zenity --file-selection --title="Select a File" \
    --file-filter="APK Files | *.apk" \
    --file-filter="RSDK XMF Files | *.rsdk.xmf" \
    --file-filter="RSDK Files | *.rsdk")

# Check if a file was selected
if [ -z "$selected_file" ]; then
    echo "No file selected."
else
    # Get the file extension
    file_extension="${selected_file##*.}"

    # Echo a different message based on the file type
    case "$file_extension" in
        apk)
            echo "# Extracting game file from APK"
            echo "65" ; sleep 1
            mkdir /tmp/$game
            unzip -o "$selected_file" -d "/tmp/$game"
            cp "/tmp/$game/assets/Data.rsdk.xmf" "$configdir/Data.rsdk"
            ;;
        xmf)
            echo "# Moving and renaming game file"
            echo "65" ; sleep 1        
            cp $selected_file "$configdir/Data.rsdk"
            ;;
        rsdk)
            echo "# Moving game file"
            echo "65" ; sleep 1          
            cp $selected_file "$configdir"
            ;;
    esac
fi
echo "90" ; sleep 1
echo "# Creating symlink the RSDK binary.." ; sleep 1
ln -s /bin/RSDKv4 "$configdir/$binname"
echo "100" ; sleep 1
cd $configdir
./sonic
) |
yad --progress \
  --width=550 \
  --height=100 \
  --title="Setting up $name" \
  --text="Preparing to setup game..." \
   --window-icon="$icon_path" \
  --percentage=0 \
  --auto-close

if [ "$?" = -1 ] ; then
        yad --error \
          --text="Update canceled."
fi
fi

