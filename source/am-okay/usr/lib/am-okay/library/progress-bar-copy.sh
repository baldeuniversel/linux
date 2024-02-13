#!/usr/bin/bash

#####
:   '
# Overview :
# ---------
# @overview The module (progress-bar-copy.sh) is a module that is composed a certain number 
# of methods allowing to display the status of transfer of a file or directory.
#
# Author :
# -------
# @author Baldé Amadou (baldeuniversel@protonmail.com)
#
# Version :
# --------
# @version 3.1.0 (12 January 2024)
    '
#####


set -uo pipefail


# Declaration variables
a_source_data=$1
a_destination_dir_target_embed=$2
a_length_ongoing_data=0
a_size_source=0
a_percent_stat=0
a_new_percent=0
a_old_percent=0
flagSIGTERM="FALSE"
a_terminate_process="TRUE"
declare -a a_character_bar_front_list=("▊" "▉" "█")
a_character_bar_back="-"
a_filePidCommandCp="$HOME/.local/share/am-okay/classic/classic-pid-cp"

#
a_getThePidCommandCp=` cat $a_filePidCommandCp 2> /dev/null | tr -d "[[:space:]]" `





:   '
@constructor
# 
# Author :
# -------
# @author Baldé Amadou (baldeuniversel@protonmail.com)
    '
function __init__ 
{
    #
    echo -ne ""
}





:   '
# @destructor
# 
# Author :
# -------
# @author Baldé Amadou (baldeuniversel@protonmail.com)
    '
function __del__ 
{
    echo -e "\n"
}





:   '
# @method
# 
# Parameter :
# ----------
# :param <$1> type(str) // The file or directory whom the size has to be calculated
# 
# Return : 
# -------
# :return The size of the file or directory
# 
# Author :
# -------
# @author Baldé Amadou (baldeuniversel@protonmail.com)
    '
function get_size 
{
    # Declaration local variables
    local v_total_size=0
    local target_elem="$1"

    # Get the size of target dir/file
    if [[ -e "$target_elem" ]]
    then
        v_total_size=`du -sk "$target_elem" | tr -s "[[:space:]]" ":" | cut -d ":" -f1`
    fi

    # print the total size of the directory
    printf "%d" $v_total_size
}





:   '
/**
* @overview The function `setFlagSIGINT` allows to change the value of the variable `flagSIGTERM` , 
* in this sense with the `trap` command there will be a control at the level of the progress bar 
*/
    '
function setFlagSIGINT
{
    # Change the value of the variable `flagSIGTERM` to `TRUE`
    flagSIGTERM="TRUE"
   

    #
    kill -9 $a_getThePidCommandCp &> /dev/null

    #
    rm -rf $a_filePidCommandCp &> /dev/null

    #
    exit 1
}





:   '
# @method
# 
# Overview :
# ---------
# @overview Display the progress bar by using in part the methods of the module <<progress-bar-copy.sh>>
# 
# Author :
# -------
# @author Baldé Amadou (baldeuniversel@protonmail.com)
    '
function display_progress_bar
{
    # Declaration variables
    local decrement_bar_back=0
    local counter=0

    local getPidCommandCp=` cat $a_filePidCommandCp 2> /dev/null `

    local source_dir_file=` echo $a_source_data | awk -F '/' '{ print $NF }' `
    local destination_dir_file=$a_destination_dir_target_embed


    # Call the constructor <<__init__>>
    __init__
 


    # Action to get the two last directories if there is more than three directories
    for (( i=0; i < ${#destination_dir_file}; i++ ))
    do
        if [[ ${destination_dir_file:i:1} == "/" ]]
        then
            counter=$(( counter + 1 ))
        fi

        #
        if [[ $counter -gt 3 ]]
        then

            destination_dir_file=` echo $destination_dir_file \
                | awk -F'/' '{ split($0, arr, "/"); print arr[length(arr)-1] "/" arr[length(arr)] }' `

            destination_dir_file=` echo "...$destination_dir_file" `

            break # Stop loop
        fi
    done



    #
    echo -e "\e[1;036m Copy ~ \e[0m   $source_dir_file    -->    $destination_dir_file"

    # Print backward char in white color
    echo -en "\033[37m|"
    #
    for counter in {1..50}
    do
        echo -en "$a_character_bar_back"
    done

    # Reset the white color
    echo -en "|  $a_percent_stat  \033[0m"



    # Get the size of the source data -> call the function <<get_size>>
    a_size_source=$(get_size $a_source_data)


 
    #
    while [[ $a_terminate_process == "TRUE" ]]
    do  
        # Get the size of the ongoing data
        a_length_ongoing_data=$(get_size $a_destination_dir_target_embed)

        # Get send percentage
        if [[ $a_size_source -gt 0 ]]
        then
            a_percent_stat=` echo  "( ($a_length_ongoing_data / $a_size_source) * 50 )" | bc -l `

            # Take only the part of integer
            a_percent_stat=` echo "$a_percent_stat" | cut -d "." -f1 `

            #
            if [[ $a_percent_stat -gt 0 ]]
            then
                a_percent_stat=$(( a_percent_stat - 1  ))
            fi

            # Update <$a_new_percent>
            a_new_percent=$a_percent_stat
        fi 

        
        #
        if [[ $a_new_percent -ne $a_old_percent ]]
        then

            # Set the color to white then to cyan
            echo -en "\033[37m\r|"
            echo -en "\033[0m\033[36m"
            
            # Display the front character according the index and ..
            for counter in `seq 1 $a_percent_stat`
            do
                echo -en "${a_character_bar_front_list[2]}" 
            done

            # Set the color to white
            echo -en "\033[37m"

            #
            decrement_bar_back=$(( 50 - a_percent_stat ))
                
            # Decrement the backward bar
            for counter2 in `seq 1 $decrement_bar_back`
            do
                echo -en "$a_character_bar_back"
            done
            
            #
            printf "|  %d" $(( 2 * a_percent_stat ))
            echo -en "%"

            # Update <$a_old_percent>
            a_old_percent=$a_new_percent
        fi


        #
        if [[ ! ` ps -p "$getPidCommandCp" | grep -w -- "$getPidCommandCp" ` ]]
        then

            #
            a_terminate_process="FALSE"
           
            # Remove the file containing the `pid`
            if [[ -e "$a_filePidCommandCp" ]]
            then
                rm -rf "$a_filePidCommandCp" 2> /dev/null
            fi
            
            #
            if [[ $flagSIGTERM == "FALSE" ]]
            then
                # Set the color to white then to green
                echo -en "\033[37m\r|"
                echo -en "\033[0m\033[32m"
                
                # Display the front character according the index and ..
                for counter in {1..50}
                do
                    echo -en "${a_character_bar_front_list[2]}"
                done
    
                # Set the color to white
                echo -en "\033[37m"
                
                #
                printf "|  %d" $(( 2 * 50 ))
                echo -en " %"
            fi

        fi

    done

    # Call the destructor <<__del__>>
    __del__

}


trap setFlagSIGINT SIGINT

# Call the <<display_progress_bar>> method
display_progress_bar $1 $2   
