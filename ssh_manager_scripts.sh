#!/bin/bash
function getSSHData()
{
local tabPosition=0
local isFirst=1
local input="./AdressFile"
    while IFS= read -r line
    do
    local tabPosition=$((tabPosition+1))
        for i in $line
        do
            if [ $isFirst -gt 0 ]
            then
            arrayForLink[$tabPosition]=$i
           local isFirst=0
            else
            arrayForPassword[$tabPosition]=$i
          local  isFirst=1
            fi
        done
    done <"$input"
}
function generateKeysForLinks()
{
    if [ $@ -eq 0 ]
        then
        ssh-keygen -t rsa -f ./id_rsa
        fi
    sshpass -p ${arrayForPassword[$@]} ssh-copy-id ${arrayForLink[$@]}
}
function validateInput()
{
    if ! [[ ${arrayForLink[$@]} =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$ ]]
     then
        echo "ERROR ONE OF SSH LINK IS WRONG PROGRAM WILL END"
        exit 1
     fi
}
echo "Make a text file in script folder, with: "
echo "Name - 'AdressFile' and inside it make each line like: "
echo "#SSHLINK# #SSHPASSWORD#"
echo "Remember about spaces between link and pass"
echo "If you finished click enter"
echo "AFTER CLICKING ENTER SCRIPT WILL INSTALL SSHPASS! IF YOU DONT WONT TO INSTALL IT JUST QUIT SCRIPT"
read enter
sudo apt-get install sshpass
getSSHData

    if [ ${#arrayForPassword[*]} -eq 0 ] 
    then
        echo "ERROR FILE IS EMPTY"
        else
         increment=1
        for valueInArray in ${arrayForPassword[*]}
         do
            validateInput $increment 
            generateKeysForLinks $increment 
            increment=$((increment+1))
        done
    fi
