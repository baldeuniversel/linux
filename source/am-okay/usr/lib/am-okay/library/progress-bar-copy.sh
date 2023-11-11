#!/bin/bash

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
# @version 3.0.5 (8 sept 2023)
    '
#####


set -euo pipefail


# Declaration variables
a_source_data=$1
a_destination_dir_target_embed=$2
a_length_ongoing_data=0
a_size_source=0
a_percent_stat=0
a_new_percent=0
a_old_percent=0
a_terminate_process="TRUE"
declare -a a_character_bar_front_list=("▊" "▉" "█")
a_character_bar_back="-"

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
# :param <$@> type(str) // The file or directory whom the size has to be calculated
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
    local target_elem=$@

    # Get the size of target dir/file
    if [[ -e "$target_elem" ]]
    then
        v_total_size=`du -sb "$target_elem" | tr -s "[[:space:]]" ":" | cut -d ":" -f1`
    fi

    # print the total size of the directory
    printf "%d" $v_total_size
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

    local source_dir_file=` echo $a_source_data | awk -F '/' '{ print $NF }' `
    local destination_dir_file=$a_destination_dir_target_embed


    # Call the constructor <<__init__>>
    __init__


    # Get the size of the source data -> call the function <<get_size>>
    a_size_source=$(get_size $a_source_data)




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
    echo -e "   $source_dir_file      -->     $destination_dir_file"

    # Print backward char in white color
    echo -en "\033[37m|"
    #
    for counter in {1..50}
    do
        echo -en "$a_character_bar_back"
    done

    # Reset the white color
    echo -en "|  $a_percent_stat % \033[0m"
 
    #
    while [[ $a_terminate_process == "TRUE" ]]
    do
        # Get the size of the ongoing data
        a_length_ongoing_data=$(get_size $a_destination_dir_target_embed)

        # Get send percentage
        if [[ $a_size_source -gt 0 ]]
        then
            a_percent_stat=` echo  "($a_length_ongoing_data / $a_size_source) * 50" | bc -l `

            # Take only the part of integer
            a_percent_stat=` echo "$a_percent_stat" | cut -d "." -f1 `

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
        if [[ $a_length_ongoing_data -eq $a_size_source  ]] || [[ $a_size_source -eq 0 ]]
        then
            #
            a_terminate_process="FALSE"
            
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
    done

    # Call the destructor <<__del__>>
    __del__

}

# Call the <<display_progress_bar>> method
display_progress_bar $1 $2
