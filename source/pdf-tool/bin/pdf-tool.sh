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
    if [[ ` pdfinfo "$getFile"  2> /dev/null ` ]]
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
    local counterArgs=1

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
            if [[ "${#tabArgs[@]}" -gt 1 ]] && [[ "${#tabArgs[@]}" -ne $counterArgs ]]
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

        # Increment the counter
        counterArgs=$(( counterArgs + 1 ))
    done


    # Restore the `IFS` environmental variable
    IFS="$saveIFS"


    # Return the arguments linked to the given option ` "args1" : "args2" ` 
    echo "$getArgsOfOption"
}





:   '
/**
* @overview The `spinnerAnimation` function allows to make animations while a process is in progress
*
* @param {int} $1 // The pid of the process
*/
    '
function spinnerAnimation
{

    # Declaration variables
    local pidCmd=$1
    local delay=0.3
    local getRandValue=` shuf -i 1-5 -n 1 `

    local spinString=""
    local spinStringA="⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
    local spinStringB="◰◳◲◱◰◳◲◱"
    local spinStringC="☼☀☁☂☃☄☽☾"
    local spinStringD="◴◷◶◵◴◷◶◵"
    local spinStringE="♚♛♜♝♞♟"


    local infotext="\e[36;1mwait...\e[0m \U00270B \U001F449 ⏳ "
    local firstChar=""



    ### Choice the spin string -> start tag[c0]

    if [[ $getRandValue -eq 1 ]]
    then
        #
        spinString=$spinStringA

    elif [[ $getRandValue -eq 2 ]]
    then
        #
        spinString=$spinStringB

    elif [[ $getRandValue -eq 3 ]]
    then
        #
        spinString=$spinStringC

    elif [[ $getRandValue -eq 4 ]]
    then
        #
        spinString=$spinStringD

    elif [[ $getRandValue -eq 5 ]]
    then
        #
        spinString=$spinStringE
    fi

    ### Choice the spin string -> start tag[c0]



    #
    trap "setterm --cursor on" SIGINT

    #
    setterm --cursor off

    echo "~"



    # Animation
    while [[ ` ps -p "$pidCmd" | grep -- "$pidCmd" ` ]]
    do

      firstChar=${spinString#?}

      echo -en "$infotext $spinString"

      spinString=$firstChar${spinString%"$firstChar"}

      sleep $delay

      echo -ne "\r"

    done

    #
    echo -ne "\e[36;1mwait...\e[0m \U00270B \U001F449 ⌛ $spinString \r"

    #
    echo ""
    echo ""

    #
    setterm --cursor on

}





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





### Action `extract` -> start tag[e0]

if [[ "$1" == "--extract" ]]
then
    
    # Declaration variables
    flagIsPDF=""
    argsOption=""
    getVersionOfPDFFile=""
    getThePDFFile=""
    getNbPageOfPDFFile=0
    getTheFromOptionValue=0
    getTheToOptionValue=0
    getTheOutputNameFile=""
    counterIterParam=1 # Shift the action `--extract`
    counterRequiredOption=0

    declare -A tabInputOptionArgs=()
    declare -A tabFromOptionArgs=()
    declare -A tabToOptionArgs=()
    declare -A tabOutputOptionArgs=()
    
    declare -a tabRequiredOptions=( "--input" "--from" "--to" "--output" )
    declare -a tabEncodedOptions=()

   

    # Save the `IFS` environmental variable
    saveIFS=$IFS

    # Change the `IFS`
    IFS=$'\n'
    
    # Shift `--extract` action
    shift 1


    # 
    for inputParam in "$@"
    do
        # Check if the current parameter is `--input`, then ...
        if [[ "$inputParam" == "--input" ]] || [[ "$inputParam" == "-i" ]]
        then

            # Get the next arguments
            getNextArgs=` printf '"%s" ' "${@:$counterIterParam}" `

            # Call of function, then ...
            tabInputOptionArgs["--input"]=` getArgsOption  "$getNextArgs" "$inputParam" `

            
            # For the `--input` option with the `--extract` action, only one argument is required
            if [[ ` echo "${tabInputOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -gt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--extract\e[0m action , the \e[1;035m--input\e[0m option has to have one argument 🧐 "

                exit 1
            fi
            #
            if [[  ` echo "${tabInputOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -lt 1 ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--extract\e[0m action , the \e[1;035m--input\e[0m option has to have one argument 🧐 "

                exit 1
            fi
            

            # Get the input 
            getPDFFile=` echo "${tabInputOptionArgs[@]}" | awk '{gsub(/"+/, ""); print }' |  awk '{gsub(/^ | $/, ""); print}' `
            
            # Check if the given input exists
            if [[ -e "$getPDFFile" ]] && [[ ! ( -d "$getPDFFile" ) ]]
            then
                # Call the functions 
                flagIsPDF=` isPDFFile "$getPDFFile" `
                
                # Check if the file is a pdf file, then ...
                if [[ "$flagIsPDF" == "true" ]]
                then
                    # Call the functions
                    getNbPageOfPDFFile=` getNbPagePDFFile $getPDFFile `
                    getVersionOfPDFFile=` getVersionPDFFile $getPDFFile `

                    #
                    getThePDFFile="$getPDFFile"

                elif [[ "$flagIsPDF" == "false" ]]
                then
                    echo "~"
                    echo -e "This \e[1;031m$getPDFFile\e[0m file does not a pdf file 🧐 "

                    exit 1
                fi

            elif [[ -d "$getPDFFile" ]] && [[ -e "$getPDFFile" ]]
            then
                #
                echo "~"
                echo -e "The argument for the \e[1;035m--option\e[0m has to be a pdf file 🧐 "

                exit 1

            elif [[ ! ( -e "$getPDFFile" ) ]]
            then
                #
                echo "~"
                echo -e "The given pdf file \e[1;031m$getPDFFile\e[0m does not exist 🧐 "

                exit 1
            else
                #
                echo "~"
                echo -e "Either the encoded file \e[1;031m$getPDFFile\e[0m does not exist or the way the"
                echo -e "file name is written is not supported 📛 "

                exit 1
            fi


            # Increment the counter
            counterRequiredOption=$(( counterRequiredOption + 1 ))

            # Append the current option 
            tabEncodedOptions+="--input "
        
        # Check if the current parameter is `--from`, then ...
        elif [[ "$inputParam" == "--from" ]] ||  [[ "$inputParam" == "-f" ]]
        then
            # Get the next arguments
            getNextArgs=` printf '"%s" ' "${@:$counterIterParam}" `

            # Call of function, then ...
            tabFromOptionArgs["--from"]=` getArgsOption  "$getNextArgs" "$inputParam" `

            # For the `--from` option with the `--extract` action, only one argument is required
            if [[ ` echo "${tabFromOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -gt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--extract\e[0m action , the \e[1;035m--from\e[0m option has to have one argument 🧐 "

                exit 1
            fi
            #
            if [[ ` echo "${tabFromOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -lt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--extract\e[0m action , the \e[1;035m--from\e[0m option has to have one argument 🧐 "

                exit 1
            fi

            # Get the argument for the `--from` option 
            getArgForFromOption=` echo "${tabFromOptionArgs[@]}" | awk '{gsub(/"+/, ""); print }' |  awk '{gsub(/^ | $/, ""); print}' `

            # Check if `getArgForFromOption` is an integer, then ...
            if [[ $getArgForFromOption =~ (^[0-9]+$) ]]
            then
                #
                if [[ $getArgForFromOption -lt 1 ]]
                then
                    echo "~"
                    echo -e "The value of the \e[1;035m--from\e[0m option has to be strictly positive 🤗 "

                    exit 1
                else
                    # Get the value for the `--from` option 
                    getTheFromOptionValue=$getArgForFromOption
                fi
            else
                echo "~"
                echo -e "The \e[1;031m$getArgForFromOption\e[0m argument does not valid for the \e[1;035m--from\e[0m option ⚠️  "

                exit 1
            fi


            # Increment the counter
            counterRequiredOption=$(( counterRequiredOption + 1 ))

            # Append the current option 
            tabEncodedOptions+="--from "

        # Check if the current parameter is `--to`, then ...
        elif [[ "$inputParam" == "--to" ]] ||  [[ "$inputParam" == "-t" ]]
        then
            # Get the next arguments
            getNextArgs=` printf '"%s" ' "${@:$counterIterParam}" `

            # Call of function, then ...
            tabToOptionArgs["--to"]=` getArgsOption  "$getNextArgs" "$inputParam" `

            # For the `--to` option with the `--extract` action, only one argument is required
            if [[ ` echo "${tabToOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -gt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--extract\e[0m action , the \e[1;035m--to\e[0m option has to have one argument 🧐 "

                exit 1
            fi
            #
            if [[ ` echo "${tabToOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -lt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--extract\e[0m action , the \e[1;035m--to\e[0m option has to have one argument 🧐 "

                exit 1
            fi

            # Get the argument for the `--to` option 
            getArgForToOption=` echo "${tabToOptionArgs[@]}" | awk '{gsub(/"+/, ""); print }' |  awk '{gsub(/^ | $/, ""); print}' `

            # Check if `getArgForToOption` is an integer, then ...
            if [[ $getArgForToOption =~ (^[0-9]+$) ]]
            then
                #
                if [[ $getArgForToOption -lt 1 ]]
                then
                    echo "~"
                    echo -e "The value of the \e[1;035m--to\e[0m option has to be strictly positive 🤗 "

                    exit 1
                else
                    # Get the value for the `--to` option 
                    getTheToOptionValue=$getArgForToOption
                fi
            else
                echo "~"
                echo -e "The \e[1;031m$getArgForToOption\e[0m argument does not valid for the \e[1;035m--to\e[0m option ⚠️  "

                exit 1
            fi


            # Increment the counter
            counterRequiredOption=$(( counterRequiredOption + 1 ))

            # Append the current option 
            tabEncodedOptions+="--to "

        # Check if the current parameter is `--output`, then ...
        elif [[ "$inputParam" == "--output" ]] ||  [[ "$inputParam" == "-o" ]]
        then
            # Get the next arguments
            getNextArgs=` printf '"%s" ' "${@:$counterIterParam}" `

            # Call of function, then ...
            tabOutputOptionArgs["--output"]=` getArgsOption  "$getNextArgs" "$inputParam" `

            # For the `--output` option with the `--extract` action, only one argument is required
            if [[ ` echo "${tabOutputOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -gt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--extract\e[0m action , the \e[1;035m--output\e[0m option has to have one argument 🧐 "

                exit 1
            fi
            #
            if [[ ` echo "${tabOutputOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -lt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--extract\e[0m action , the \e[1;035m--output\e[0m option has to have one argument 🧐 "

                exit 1
            fi

            # Get the argument for the `--output` option 
            getArgForOutputOption=` echo "${tabOutputOptionArgs[@]}" | awk '{gsub(/"+/, ""); print }' |  awk '{gsub(/^ | $/, ""); print}' `
            

            # Check if `getArgForOutputOption` contains spaces, then ...
            if [[ $getArgForOutputOption =~ [[:space:]] ]]
            then
                #
                echo "~"
                echo -e "The given output name \e[1;031m$getArgForOutputOption\e[0m , has not to contain spaces 🤠 "

                exit 1
            
            # Check to see if the given name exists in the wrapper directory
            elif [[ -e "$getArgForOutputOption" ]]
            then
                echo "~"
                echo -e "The \e[1;031m$getArgForOutputOption\e[0m name already exists in the wrapper directory 🔰 "

                exit 1
            else
                # If the end of the name is `.pdf`, then ...
                if [[ ` echo "$getArgForOutputOption" | grep -- ".pdf$" ` ]]
                then
                    #
                    getTheOutputNameFile="$getArgForOutputOption"
                else
                    #
                    getTheOutputNameFile="$getArgForOutputOption.pdf"
                fi
            fi

            # Check if the given name output file exists, then ...
            if [[ -e "$getTheOutputNameFile" ]]
            then
                echo "~"
                echo -e "The \e[1;031m$getTheOutputNameFile\e[0m name already exists in the wrapper directory 🔰 "

                exit 1
            fi


            # Increment the counter
            counterRequiredOption=$(( counterRequiredOption + 1 ))

            # Append the current option 
            tabEncodedOptions+="--output "

        elif ( [[ "$inputParam" != "--input" ]] || [[ "$inputParam" != "-i" ]] ) \
            && ( [[ "$inputParam" != "--from" ]] || [[ "$inputParam" != "-f" ]] ) \
            && ( [[ "$inputParam" != "--to" ]] || [[ "$inputParam" != "-t" ]] ) \
            && ( [[ "$inputParam" != "--output" ]] || [[ "$inputParam" != "-o" ]] )
        then
            
            #
            if [[ ` echo "$inputParam" | grep -- "^-" ` ]]
            then
                echo "~"
                echo -e "Unknown \e[1;031m$inputParam\e[0m option for the \e[1;36m--extract\e[0m action 🧐 "
            
                exit 1
            fi
        fi


        # Increment the counter 
        counterIterParam=$(( counterIterParam + 1 ))

    done


    # Restore the `IFS` environmental variable  
    IFS=$saveIFS
    

    # Check to see if the required options was used 
    if [[ $counterRequiredOption -ne 4 ]]
    then
        #
        stringMissingOptions=""

        # From the table required options ...
        for requiredOption in ${tabRequiredOptions[@]}
        do
            # A variable allowing to se if the current required option exists among 
            # the input options parameters (encoded by the user)
            flagOptionFound="false"

            # From the table encoded options
            for encodedOptions in ${tabEncodedOptions[@]}
            do
                # Check the matching 
                if [[ "$requiredOption" == "$encodedOptions" ]]
                then
                    #
                    flagOptionFound="true"
                fi
            done

            # Verify if there is a match ...
            if [[ "$flagOptionFound" == "false" ]]
            then
                # Append this missing option (the current required option)
                stringMissingOptions+="$requiredOption "
            fi
        done

        #
        echo "~"
        echo -e "Missing  \e[1;033m$stringMissingOptions\e[0m option(s) 🧐 "

        exit 1
    fi


    # Extract operating 
    if [[ $getTheToOptionValue -gt $getNbPageOfPDFFile ]] || [[ $getTheFromOptionValue -gt $getNbPageOfPDFFile ]]
    then
        echo "~"
        echo -e "\e[1;031mOut of bound\e[0m , the input pdf file is only $getNbPageOfPDFFile pages 📛 🚧 "

        exit 1

    elif [[ $getTheToOptionValue -lt $getTheFromOptionValue ]]
    then
        echo "~"
        echo -e "The value of the \e[1;036m--to\e[0m option has to be greater than or equal "
        echo -e "to that of the \e[1;036m--from\e[0m option 🧐 "

        exit 1
    else
        # Extract
        pdftk A=$getThePDFFile cat A$getTheFromOptionValue-$getTheToOptionValue output $getTheOutputNameFile \
            2> "$tmpWorkingDir/extract-action" &
        
        # Call the function
        spinnerAnimation $!

        #
        if [[ -e "$tmpWorkingDir/extract-action" ]]
        then
            if [[ ` cat "$tmpWorkingDir/extract-action" | wc -l` -gt 0 ]]
            then
                echo "~"
                echo -e "Error ❌ during extraction, make sure you have the right to write in the target directory "
                echo -e "where the pdf file will be sent"

                exit 1
            else
                echo "~"
                echo -e "Successfully extraction ✅ "
            fi
        fi

    fi
    
    #
    exit 0
fi

### Action `extract` -> end tag[e0] 
