#!/usr/bin/bash

:   ' 
/**
* @overview This program allows to execute some actions (see the precondition below)
* that can be very useful (First of all, this program is written for the
* Ve‐Quantic members) .
*
*
* @requires The only options supported are [ ‐‐extract, ‐‐input, ‐i, ‐‐from, ‐f, ‐‐to, ‐t,
*                                            ‐‐output, ‐o, ‐‐doc, ‐‐help ]
* && the command pdf‐tool has to have at least one option
*                     Example : pdf‐tool ‐‐extract ‐‐input <pdf‐file.pdf> ‐‐from 1 ‐‐to 2
*                                                                  ‐‐output <new‐pdf.pdf>
* && the given parameter after the [ { --from || -f } , { --to || -t } ] options has to be 
*                                       a positive integer (i > 0 : i in natural integers)
* && the given parameter after the [ --input ] option has to be pdf files
*
*
* OPTIONS
*       ‐‐extract     type(string) // This option allows to initialize an extract action
*                           Ex : pdf‐tool ‐‐extract ‐‐input <pdf‐file.pdf> ‐‐from 1 ‐‐to 2
*                                                                   ‐‐output <new‐pdf.pdf>
*
*       ‐‐input       type(string) // This option allows to pass the target pdf files .
*
*       ‐‐from        type(string) // This option allows to indicate from which page number of the
*                           pdf file an action will affect (the given parameter after the `--from` 
*                           option has to be a positive integer) .
*
*       ‐‐to          type(String> // This option marks the stopping page number for a given action
*                           on a pdf file (the given parameter after the `--to` option has to be a 
*                           positive integer) . The [ ‐‐from, ‐‐to ] options go together .
*
*       ‐‐output      type(string) // This option allows to give a name for the output pdf file
*
*       ‐‐doc         type(string) // To see the documentation of the pdf‐tool program
*                           Ex : pdf‐tool ‐‐doc
*
*       ‐‐help        type(sting) // To get help
*                           Ex : pdf‐tool ‐‐help
*
*
* @ensure Successfully execution if the precondition is satisfied. That is to say, with
* the above options and the appropriated sequences linked to these options .
*
*
* @note This program depends of some programs, these programs are required in the global
* package of pdf‐tool .
*
* AUTHOR
*       Author    : Baldé Amadou <baldeuniversel@protonmail.com>
*
* CONTRIBUTOR
*            Contributor    : Diallo Ismaila <diallois@protonmail.com>
*/
    '

##### Action linked to the command <<am-okay>> .
#####
#####

set -uo pipefail # To exit the script if there is an error



# Declaration variables
listOfParams=("--extract" "--input" "-i" "--from" "-f" \
    "--output" "-o" "--doc" "--help")

listOfParamsAction=("--extract" "--doc" "--help")

counterOption=0



# Return an error when the number of parameters is lower than one 
if [[ $# -lt 1 ]]
then
    echo "~"
    echo -e "There is at least one parameter \U001F914"

    exit 1
fi

# Check the inputs parameters
for optionUP in ${listOfParamsAction[@]}
do
    if [[ $1 != $optionUP ]]
    then
        counterOption=$(( counterOption + 1 ))
    fi

    #
    if [[ $counterOption -eq 3  ]]
    then
        echo "~"
        echo -e "Unknown `tput setaf 3; tput bold`$1` tput sgr0 ` option \U001F9D0 ."

        exit 1
    fi
done





### Declaration variables -> start tag[d0]

tmpWorkingDir="/tmp/.$USER/pdf-tool"

### Declaration variables -> end tag[d0]





:   '
/**
* @overview The function `isPDFFile` allows to know if a given file if a pdf file or not
*
*
* @param {string} $1 // The pdf file
*
*
* @return {string} // A `true` string value will be returned if the file is a pdf, otherwise
*                     a `false` string value that will be returned
*/
    '
function isPDFFile
{
    # Declaration variables
    local getFile="$1"



    # Return `true` if the file is a `pdf`, otherwise return `false`
    if [[ ` pdfinfo "$getFile" ` ]]
    then
        #
        echo "true"
    else
        #
        echo "false"
    fi
}





:   '
/**
* @overview The function `getVersionPDFFile` allows to get the version of a pdf file
*
*
* @param {string} $1 // The pdf file
*
*
* @return {string} // A version of the pdf file will be returned
*/
    '
function getVersionPDFFile
{
    # Declaration variables
    local getFile=$1
    local getVersion=""



    # The version of the pdf file will be returned if the file exists
    if [[ -e "$getFile" ]]
    then
        #
        getVersion=` pdfinfo "$getFile" | grep -w -- "^PDF version" | awk -F ':' '{print $2}' | awk '{$1=$1}; 1' `

        echo "$getVersion"
    fi
}




:   '
/**
* @overview The function `getNbPagePDFFile` allows to get the number of pages of a pdf file
*
*
* @param {string} $1 // The pdf file
*
*
* @return {int} // The number of pages of the pdf file will be returned
*/
    '
function getNbPagePDFFile
{
    # Declaration variables
    local getFile=$1
    local getNb=""



    # The version of the pdf file will be returned if the file exists
    if [[ -e "$getFile" ]]
    then
        #
        getNb=` pdfinfo "$getFile" | grep -w -- "^Pages" | awk -F ":" '{print $2}' | awk '{$1=$1}; 1' ` 

        echo "$getNb"
    fi
}





:   '
/**
* @overview The function `getArgsOption` allows to get arguments (to get the input parameters 
* without hyphens, the target option has to be included)
*
*
* @param {string} $1 // The string containing the input arguments (the target option included)
*
*
* @return {string} // The arguments linked to the option will be returned ( "args1" : "args2" )
*/
    '
function getArgsOption
{
    # Declaration variables
    local getArgsWithOption="$1"

    local getArgsOfOption=""
    local getArgsOnly=""

    declare -a tabArgs=()



    # Remove the given option 
    getArgsOnly=` echo "$getArgsWithOption" | awk -F " " '{$1=""; sub(/^[ \t]+/, ""); print}' | \
        awk '{ gsub(/""+/, ":"); print }' | awk -F ':' '{ for (i=1; i<=NF; i++) { if (i%2 == 0) \
        { gsub(/"+/, "", $i); printf "\"%s\"", $i; } else { printf "%s", $i; } } }' | awk '{ gsub(/ [^a-zA-Z]/, "|\""); print }' `
    
    # Save the `IFS` environment variable 
    saveIFS="$IFS"

    # Change the `IFS` environmental variable
    IFS="|" 
    
    # Load the content of the string `$getArgsOnly` in an array
    read -r -a tabArgs <<< $getArgsOnly

    
    # Get the arguments linked to the given option (shift the given option 
    for argsInputOption in "${tabArgs[@]}"
    do
        # If the string/argument does not start by a hyphen "-"
        if [[ ${argsInputOption:1:1} != "-" ]]
        then
            #
            if [[ "${#tabArgs[@]}" -gt 1 ]]
            then
                #
                getArgsOfOption+="$argsInputOption : "
            else
                #
                getArgsOfOption+="$argsInputOption"
            fi
        else
            # Save the arguments for the input 
            getArgsOfOption=` echo "$getArgsOfOption" | awk '{ $NF=""; sub(/$/, "") }; 1' `

            #
            break
        fi
    done


    # Restore the `IFS` environmental variable
    IFS="$saveIFS"


    # Return the arguments linked to the given option ` "args1" : "args2" ` 
    echo "$getArgsOfOption"
}






### Action `extract` -> start tag[e0]

if [[ "$1" == "--extract" ]]
then
    
    # Declaration variables
    flagIsPDF=""
    getVersionPDF=""
    counterIterParam=1 # Shift the action `--extract`
    argsOption=""

    declare -A tabInputOptionArgs=()
    declare -A tabFromOptionArgs=()
    declare -A tabToOptionArgs=()
    declare -A tabOutputOptionArgs=()

   

    # Save the `IFS` environmental variable
    saveIFS=$IFS

    # Change the `IFS`
    IFS=$'\n'
    
    # Shift `--extract` action
    shift 1


    # 
    for inputParam in "$@"
    do
        # Check if the current parameter is `--input`
        if [[ "$inputParam" == "--input" ]]
        then

            # Get the next arguments
            getNextArgs=` printf '"%s" ' "${@:$counterIterParam}" `

            
            # Call of function, then ...
            tabInputOptionArgs["--input"]=` getArgsOption  "$getNextArgs" "$inputParam" `
            
            #
            if [[ ` echo "${tabInputOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -gt 1  ]]
            then
                echo "~"
                echo -e "For the action \e[1;36m--extract\e[0m , the option \e[1;035m--input\e[0m has to have one argument 🧐"

                exit 1
            fi

            echo "${tabInputOptionArgs[*]}"
        fi

        # Increment the counter 
        counterIterParam=$(( counterIterParam + 1 ))

    done


    # Restore the `IFS` environmental variable  
    IFS=$saveIFS


fi

### Action `extract` -> end tag[e0]




### Creation some necessary directories -> start tag[c0] 

#
if [[ ! ( -e "$tmpWorkingDir" ) ]]
then
    #
    mkdir -p "$tmpWorkingDir" 2> /dev/null

    if [[ $? -ne 0 ]]
    then
        echo "~"
        echo -e "Something is wrong, make sure your are the right to write in [/tmp] 🧐"

        exit 0
    fi
fi

### Creation some necessary directories -> end tag[c0] 
