#Run as administrator
clear
echo "+---------------------------+"
echo "|         Bitlocker         |"
echo "+---------------------------+"
echo ""
echo "What do you want to do?"
echo ""
echo "(1). Check status on remote host"
echo "(2). Enable bitlocker on remote host"
echo "(3). Disable bitlocker on remote host"
echo "(4). Enable bitlocker on local host"
echo ""
$chosenpath = Read-Host "choose"

if ($chosenpath -eq 1)
{
    clear
    echo "Who is the target?"
    $target = Read-Host -Prompt 'Input hostname'
    clear
    manage-bde -status C: -cn $target
    pause
    exit
}
if ($chosenpath -eq 2)
{
    clear
    echo "Who is the target?"
    $target = Read-Host -Prompt 'Input hostname'
    clear
    echo "Who is the user? (username)"
    $user = Read-Host -Prompt 'Input username'
    clear
    echo "Target host: " $target
    echo ""
    echo "Target user: " $user
    echo ""
    echo "----------------"
    echo "Is this correct?"
    echo ""
    $confirm = Read-Host "(Y)es / (N)o"
    if ($confirm -eq 'y' -or $confirm -eq 'yes')
    {
        clear
        echo "Enabling bitlocker on remote computer"
        sleep (1)
        echo "waiting 5 seconds"
        sleep (1)
        echo "."
        sleep (1)
        echo "."
        sleep (1)
        echo "."
        sleep (1)
        echo "."
        sleep (1)
        echo "Enabling!"
        sleep (1)
        clear
        #-----------------------------------------------
        echo "Adding key protectors ..."
        sleep (1)
        echo "."
        sleep (1)
        echo "."
        sleep (1)
        manage-bde -protectors -add C: -tpm -sid $user
        sleep (1)
        echo "."
        sleep (1)
        echo "."
        echo ""
        echo "Identity and TPM protector have been added."
        echo "Pausing to let you verify if it succeeded or failed"
        pause
        clear
        #-----------------------------------------------
        echo "Enabling bitlocker on C: ..."
        sleep (1)
        echo "."
        sleep (1)
        echo "."
        sleep (1)
        manage-bde -on C: -RecoveryKey C:\ -s -cn $target
        sleep (1)
        echo "."
        sleep (1)
        echo "."
        echo ""
        echo "Encryption and protection have been enabled."
        echo "-----------------------"
        manage-bde -status C: -cn $target
        echo "-----------------------"
        echo "Pausing to let you verify if it succeeded or failed"
        pause
        clear
        echo "DONE!"
    }
    if ($confirm -eq 'n' -or $confirm -eq 'no')
    {
        clear
        echo "Understood, goodbye."
        pause
        exit
    }
}
if ($chosenpath -eq 3)
{
    clear
    echo "Who is the target?"
    $target = Read-Host -Prompt 'Input hostname'
    clear
    echo "Who is the user? (username)"
    $user = Read-Host -Prompt 'Input username'
    clear
    echo "Target host: " $target
    echo ""
    echo "Target user: " $user
    echo ""
    echo "----------------"
    echo "Is this correct?"
    echo ""
    $confirm = Read-Host "(Y)es / (N)o"
    if ($confirm -eq 'y' -or $confirm -eq 'yes')
    {
        clear
        echo "Disabling bitlocker on remote computer"
        sleep (1)
        echo "waiting 5 seconds"
        sleep (1)
        echo "."
        sleep (1)
        echo "."
        sleep (1)
        echo "."
        sleep (1)
        echo "."
        sleep (1)
        echo "Disabling!"
        sleep (1)
        clear
        #-----------------------------------------------
        echo "Disabling bitlocker on C: ..."
        sleep (1)
        echo "."
        sleep (1)
        echo "."
        sleep (1)
        manage-bde -off C: -cn $target
        sleep (1)
        echo "."
        sleep (1)
        echo "."
        echo ""
        echo "Should have disabled encryption and protection"
        echo "-----------------------"
        manage-bde -status C: -cn $target
        echo "-----------------------"
        echo "Pausing to let you verify if it succeeded or failed"
        pause
        clear
        echo "DONE!"
    }
    if ($confirm -eq 'n' -or $confirm -eq 'no')
    {
        clear
        echo "Goodbye."
        pause
        exit
    }
}
if ($chosenpath -eq 4)
{
    #Checking if bitlocker is already enabled
    $BitlockerStatus = Get-BitlockerVolume C:
    if($BitlockerStatus.ProtectionStatus -eq 'On' -and $BitlockerStatus.EncryptionPercentage -eq '100')
    {
        echo "Bitlocker is already enabled, exiting"
        sleep(1)
        exit
    }

    #Checking if bitlocker is already in progress
    $BitlockerInprogressStatus = Get-BitlockerVolume C:
    if($BitlockerInprogressStatus.EncryptionPercentage -gt '0' -and $BitlockerInprogressStatus.EncryptionPercentage -lt '100' -and $BitlockerInprogressStatus.VolumeStatus -eq 'EncryptioninProgress')
    {
        echo "Bitlocker is already in progress, exiting"
        sleep(1)
        exit
    }
    
    #At this point only remaining scenarios are either 0% or 100% encrypted with protection off
    #which means bitlocker is either not enabled at all, or drive is encrypted but missing protectors.
    
    #Adding the TPM chip as keyprotector
    manage-bde -protectors -add C: -tpm
    sleep(1)
    #Enabling bitlocker on C:
    #If drive is already encrypted, bitlocker is instantly enabled and encryption is skipped
    manage-bde -on C: -RecoveryKey C:\ -s -used
    exit   
}
clear
echo "Invalid input."
sleep (1)
exit
