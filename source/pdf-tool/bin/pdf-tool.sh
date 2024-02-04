#!/usr/bin/bash

:   ' 
/**
* @overview This program allows to execute some actions (see the precondition below)
* that can be very useful
*
*
* @requires The only actions supported are [ --extract , --number , --concat , --compress , 
*                                            --rotate , --include , --exclude , --doc , 
*                                            --stamp , --burst , --crypt , --decrypt , --help ,
*                                            --version ]
*
* && the only options supported are [ --input || -i , --from || -f , --output || -o ,  
*                                     --source || -s , --destination || -d , 
*                                     --after-page || -a , --level || -l , --cardinal || -c ]
*
* && the command pdf‐tool has to have at least one option when an action is being executed
*                     except the [ --help, --doc, --version ] actions
*                     Example : pdf‐tool ‐‐extract ‐‐input <pdf‐file.pdf> ‐‐from 1 ‐‐to 2
*                                                                  ‐‐output <new‐pdf.pdf>
*
* && the given value after the [ { --from || -f } , { --to || -t } , { --level || -l } ,  
*                                { --after-page || -a } ] options has to be a positive 
*                                integer (i > 0 : i in natural integers), and only one value or 
*                                entry is required for these options 
*
* && the given value after the [ { --cardinal || -c } ] option has to be a string
*
* && the given value after the [ { --input || -i } , { --source || -s } , { --destination || -d }  ] 
*                                                                       options has to be a pdf file
*
* && except the `--concat` action, when the `--input` option is called, only one entry (value) is required 
*                                                                                 for the `--input` option
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
* @ensure Successfully execution if the preconditions are satisfied. That is to say, with
* the above actions, options and the appropriated sequences linked to these options .
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

##### Action linked to the command <<pdf-tool>> .
#####
#####

set -uo pipefail # To exit the script if there is an error



# Declaration variables
listOfOptions=("--input" "-i" "--from" "-f" \
    "--output" "-o" "--source" "-s" "--destination" "-d" \
    "--after-page" "-a" "--level" "-l" "--cardinal" "-c")

listOfParamsAction=("--extract" "--number" "--concat" "--compress" "--rotate" \
    "--include" "--exclude" "--doc" "--help" "--version")

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
    if [[ $counterOption -eq 10 ]]
    then
        echo "~"
        echo -e "Unknown `tput setaf 3; tput bold`$1` tput sgr0 ` option \U001F9D0 ."

        exit 1
    fi
done





### Info -> start tag[wo] 

# For the `--doc` action 
if [[ $1 == "--doc" ]]
then
    if [[ $# -ne 1 ]]
    then
        echo "~"
        echo -e "When the \e[1;036m$1\e[0m action is invoked, there isn't another one 🚧 "
        
        exit 1
    else
        if [[ -e "../usr/lib/pdf-tool/documentation/pdf-tool-doc" ]]
        then
            cat "../usr/lib/pdf-tool/documentation/pdf-tool-doc" 2> /dev/null

            exit 0
        else
            echo ""
            echo -e "A dependency file is missing, please reinstall the \e[1;036mpdf-tool\e[0m ⚠️  "

            exit 1
        fi
    fi

    exit 0
fi

# For the `--help` action 
if [[ $1 == "--help" ]]
then
    if [[ $# -ne 1 ]]
    then
        echo "~"
        echo -e "When the \e[1;036m$1\e[0m action is invoked, there isn't another one 🚧 "
        
        exit 1
    else
        if [[ -e "../usr/lib/pdf-tool/documentation/pdf-tool-help" ]]
        then
            cat "../usr/lib/pdf-tool/documentation/pdf-tool-help" 2> /dev/null

            exit 0
        else
            echo ""
            echo -e "A dependency file is missing, please reinstall the \e[1;036mpdf-tool\e[0m ⚠️  "

            exit 1
        fi
    fi

    exit 0
fi

# For the `--version` action 
if [[ $1 == "--version" ]]
then
    if [[ $# -ne 1 ]]
    then
        echo "~"
        echo -e "When the \e[1;036m$1\e[0m action is invoked, there isn't another one 🚧 "
        
        exit 1
    else
        if [[ -e "../usr/lib/pdf-tool/documentation/pdf-tool-version-pure" ]]
        then
            cat "../usr/lib/pdf-tool/documentation/pdf-tool-version-pure" | \
                awk '{ gsub(/.+/, "\033[1;036m&\033[0m"); print }' 2> /dev/null

            exit 0
        else
            echo ""
            echo -e "A dependency file is missing, please reinstall the \e[1;036mpdf-tool\e[0m ⚠️  "

            exit 1
        fi
    fi

    exit 0
fi


### Info -> end tag[wo]





### Declaration variables -> start tag[d0]

getCurrentPid="$$"

tmpWorkingDir="/tmp/.$USER/pdf-tool/$getCurrentPid"

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
* @overview the `isOptionRepeat` allows to know if an option is already encoded (before)
*
* @param {string} $1 // The string containing all the already encoded options
* @param {string} $2 // The current option to check among all the encoded options
*
* @return {string} // The `true` string will be returned if the option is already encoded,
*                     otherwise a `false` string will be returned
*/
    '
function isOptionRepeat
{
    # Declaration variables
    local getTheOptions="$1"
    local getTheCurOption="$2"
    local getTheCurOptWithoutHyphen=""
    local getTheOptionsWithoutHyphen=""
    local getTheFirstCharCurOption=""

    # Get the current option without hyphen
    getTheCurOptWithoutHyphen=` echo "$getTheCurOption" | awk '{ gsub(/[-]*/, ""); print }' `
    getTheFirstCharCurOption=${getTheCurOptWithoutHyphen:0:1}
    
    getTheOptionsWithoutHyphen=` echo "$getTheOptions" | awk '{ gsub(/[-]*/, ""); print }' `
                
    # Processing ...
    if [[ ` echo "$getTheOptionsWithoutHyphen" | \
        awk -v pattern="$getTheFirstCharCurOption" '{ for(i=1; i <=NF; i++) { if (index($i, pattern) == 1) { print $i } } }' ` ]]
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





:   '
/**
* @overview the `removeTmpWorkingDir` allows to remove the tmp working directory
*/
    '
function removeTmpWorkingDir
{
    #
    if [[ -e "$tmpWorkingDir" ]]
    then
        #
        rm -rf "$tmpWorkingDir" 2> /dev/null
    fi
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
else
    #
    rm -rf "$tmpWorkingDir" 2> /dev/null

    #
    mkdir -p "$tmpWorkingDir" 2> /dev/null

    if [[ $? -ne 0 ]]
    then
        echo "~"
        echo -e "Something is wrong, make sure your are the right to write in [/tmp] 🧐"

        exit 0
    fi

fi

#
trap 'rm -rf "$tmpWorkingDir" 2> /dev/null' SIGINT SIGTERM

#
trap 'rm -rf "$tmpWorkingDir" 2> /dev/null'  EXIT

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

            # Process to verify if the current option has already been taken, then ...
            if [[ $counterRequiredOption -gt 0 ]]
            then
                # Get the content of the array in string mode
                getInStringModeOptions=` echo ${tabEncodedOptions[@]} `

                # Call the function
                flagOptionSpotted=` isOptionRepeat "$getInStringModeOptions" "$inputParam" `
                
                # Checking ...
                if [[ "$flagOptionSpotted" == "true" ]]
                then
                    #
                    echo "~"
                    echo -e "Action not performed due to repetition of \e[1;035m$inputParam\e[0m option 📛 🔰 "

                    exit 1
                fi
            fi


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
            
            # Process to verify if the current option has already been taken, then ...
            if [[ $counterRequiredOption -gt 0 ]]
            then
                # Get the content of the array in string mode
                getInStringModeOptions=` echo ${tabEncodedOptions[@]} `

                # Call the function
                flagOptionSpotted=` isOptionRepeat "$getInStringModeOptions" "$inputParam" `
                
                # Checking ...
                if [[ "$flagOptionSpotted" == "true" ]]
                then
                    #
                    echo "~"
                    echo -e "Action not performed due to repetition of \e[1;035m$inputParam\e[0m option 📛 🔰 "

                    exit 1
                fi
            fi


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

            # Process to verify if the current option has already been taken, then ...
            if [[ $counterRequiredOption -gt 0 ]]
            then
                # Get the content of the array in string mode
                getInStringModeOptions=` echo ${tabEncodedOptions[@]} `

                # Call the function
                flagOptionSpotted=` isOptionRepeat "$getInStringModeOptions" "$inputParam" `
                
                # Checking ...
                if [[ "$flagOptionSpotted" == "true" ]]
                then
                    #
                    echo "~"
                    echo -e "Action not performed due to repetition of \e[1;035m$inputParam\e[0m option 📛 🔰 "

                    exit 1
                fi
            fi


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

            # Process to verify if the current option has already been taken, then ...
            if [[ $counterRequiredOption -gt 0 ]]
            then
                # Get the content of the array in string mode
                getInStringModeOptions=` echo "${tabEncodedOptions[@]}" `

                # Call the function
                flagOptionSpotted=` isOptionRepeat "$getInStringModeOptions" "$inputParam" `

                # Checking ...
                if [[ "$flagOptionSpotted" == "true" ]]
                then
                    #
                    echo "~"
                    echo -e "Action not performed due to repetition of \e[1;035m$inputParam\e[0m option 📛 🔰 "

                    exit 1
                fi
            fi


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

        # Call the function
        removeTmpWorkingDir

        exit 1

    elif [[ $getTheToOptionValue -lt $getTheFromOptionValue ]]
    then
        echo "~"
        echo -e "The value of the \e[1;036m--to\e[0m option has to be greater than or equal "
        echo -e "to that of the \e[1;036m--from\e[0m option 🧐 "

        # Call the function
        removeTmpWorkingDir

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
                echo -e "\e[1;031mError\e[0m ❌ during extraction, make sure you have the right to write in the target directory "
                echo -e "where the pdf file will be sent 🧐 "

                # Call the function
                removeTmpWorkingDir

                exit 1
            else
                echo "~"
                echo -e "Successfully extraction ✅ "

                # Call the function
                removeTmpWorkingDir

                exit 0
            fi
        fi

    fi

    #
    exit 0
fi

### Action `extract` -> end tag[e0] 





### Action `number` -> start tag[n0]

if [[ "$1" == "--number" ]]
then
    
    # Declaration variables
    flagIsPDF=""
    argsOption=""
    getVersionOfPDFFile=""
    getThePDFFile=""
    getNbPageOfPDFFile=0
    getTheOutputNameFile=""
    counterIterParam=1 # Shift the action `--number`
    counterRequiredOption=0

    declare -A tabInputOptionArgs=()
    declare -A tabOutputOptionArgs=()
    
    declare -a tabRequiredOptions=( "--input" "--output" )
    declare -a tabEncodedOptions=()

   

    # Save the `IFS` environmental variable
    saveIFS=$IFS

    # Change the `IFS`
    IFS=$'\n'
    
    # Shift `--number` action
    shift 1


    # 
    for inputParam in "$@"
    do
        # Check if the current parameter is `--input`, then ...
        if [[ "$inputParam" == "--input" ]] || [[ "$inputParam" == "-i" ]]
        then

            # Process to verify if the current option has already been taken, then ...
            if [[ $counterRequiredOption -gt 0 ]]
            then
                # Get the content of the array in string mode
                getInStringModeOptions=` echo ${tabEncodedOptions[@]} `

                # Call the function
                flagOptionSpotted=` isOptionRepeat "$getInStringModeOptions" "$inputParam" `
                
                # Checking ...
                if [[ "$flagOptionSpotted" == "true" ]]
                then
                    #
                    echo "~"
                    echo -e "Action not performed due to repetition of \e[1;035m$inputParam\e[0m option 📛 🔰 "

                    exit 1
                fi
            fi


            # Get the next arguments
            getNextArgs=` printf '"%s" ' "${@:$counterIterParam}" `

            # Call of function, then ...
            tabInputOptionArgs["--input"]=` getArgsOption  "$getNextArgs" "$inputParam" `

            
            # For the `--input` option with the `--number` action, only one argument is required
            if [[ ` echo "${tabInputOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -gt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--number\e[0m action , the \e[1;035m--input\e[0m option has to have one argument 🧐 "

                exit 1
            fi
            #
            if [[  ` echo "${tabInputOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -lt 1 ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--number\e[0m action , the \e[1;035m--input\e[0m option has to have one argument 🧐 "

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

        # Check if the current parameter is `--output`, then ...
        elif [[ "$inputParam" == "--output" ]] ||  [[ "$inputParam" == "-o" ]]
        then

            # Process to verify if the current option has already been taken, then ...
            if [[ $counterRequiredOption -gt 0 ]]
            then
                # Get the content of the array in string mode
                getInStringModeOptions=` echo ${tabEncodedOptions[@]} `

                # Call the function
                flagOptionSpotted=` isOptionRepeat "$getInStringModeOptions" "$inputParam" `
                
                # Checking ...
                if [[ "$flagOptionSpotted" == "true" ]]
                then
                    #
                    echo "~"
                    echo -e "Action not performed due to repetition of \e[1;035m$inputParam\e[0m option 📛 🔰 "

                    exit 1
                fi
            fi


            # Get the next arguments
            getNextArgs=` printf '"%s" ' "${@:$counterIterParam}" `

            # Call of function, then ...
            tabOutputOptionArgs["--output"]=` getArgsOption  "$getNextArgs" "$inputParam" `

            # For the `--output` option with the `--number` action, only one argument is required
            if [[ ` echo "${tabOutputOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -gt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--number\e[0m action , the \e[1;035m--output\e[0m option has to have one argument 🧐 "

                exit 1
            fi
            #
            if [[ ` echo "${tabOutputOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -lt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--number\e[0m action , the \e[1;035m--output\e[0m option has to have one argument 🧐 "

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
            && ( [[ "$inputParam" != "--output" ]] || [[ "$inputParam" != "-o" ]] )
        then
            
            #
            if [[ ` echo "$inputParam" | grep -- "^-" ` ]]
            then
                echo "~"
                echo -e "Unknown \e[1;031m$inputParam\e[0m option for the \e[1;36m--number\e[0m action 🧐 "
            
                exit 1
            fi
        fi


        # Increment the counter 
        counterIterParam=$(( counterIterParam + 1 ))
    done


    # Restore the `IFS` environmental variable  
    IFS=$saveIFS
    

    # Check to see if the required options was used 
    if [[ $counterRequiredOption -ne 2 ]]
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

    
    ### Number operating  -> start tag[o1]

    if [[ -e "$tmpWorkingDir/$getThePDFFile" ]]
    then
        #
        rm -r "$tmpWorkingDir/$getThePDFFile" 2> /dev/null
    fi

    # Copy the template file towards ...
    cp "../usr/lib/pdf-tool/library/tex/template-number-foot-page.tex" "$tmpWorkingDir"
    

    # Use the version `1.5` for the input pdf file
    gs -dCompatibilityLevel=1.5 -dNOPAUSE -dBATCH -sDEVICE=pdfwrite \
        -sOutputFile="$tmpWorkingDir/$getTheOutputNameFile" "$getThePDFFile" &> /dev/null &
    
    # Call the function
    spinnerAnimation $!
    
    tput cuu1
    tput cuu1 
    tput cuu1

    # Replace the text `replaceMe` by the "$tmpWorkingDir/$getTheOutputNameFile" in the text file 
    sed -i "s|replaceMe|"$tmpWorkingDir/$getTheOutputNameFile"|" "$tmpWorkingDir/template-number-foot-page.tex" 
   
    
    # Numbering
    pdflatex -halt-on-error -output-directory "$tmpWorkingDir" \
        "$tmpWorkingDir/template-number-foot-page.tex"  2> "$tmpWorkingDir/number-action" 1> /dev/null &

    # Call the function 
    spinnerAnimation $!
    
    #
    if [[  ` cat "$tmpWorkingDir/number-action" 2> /dev/null | wc -l ` -eq 0  ]]
    then
        rm -r "$tmpWorkingDir/$getTheOutputNameFile" 2> /dev/null
        
        mv "$tmpWorkingDir/template-number-foot-page.pdf" "$getTheOutputNameFile" 2> /dev/null

        #
        if [[ $? -eq 0 ]]
        then
            echo "~"
            echo -e "Successfully numbering ✅ "

            # Call the function
            removeTmpWorkingDir

            exit 0
        else
            echo "~"
            echo -e "\e[1;031mError\e[0m ❌ during numbering, make sure you have the right to write in the target directory "
            echo -e "where the pdf file will be sent 🧐 "
            
            # Call the function
            removeTmpWorkingDir

            exit 1
        fi 
    else
        echo "~"
        echo -e "\e[1;031mError\e[0m ❌ during numbering, make sure you have the right to write in the target directory "
        echo -e "where the pdf file will be sent 🧐 "

        # Call the function
        removeTmpWorkingDir

        exit 1
    fi


    ### Number operating  -> end tag[o1]

    #
    exit 0
fi

### Action `number` -> end tag[n0] 





### Action `concat` -> start tag[c0]
#
if [[ "$1" == "--concat"  ]]
then

    # Declaration variables
    flagIsPDF=""
    argsOption=""
    getVersionOfPDFFile=""
    getThePDFFile=""
    getNbPageOfPDFFile=0
    getTheOutputNameFile=""
    counterIterParam=1 # Shift the action `--concat`
    counterRequiredOption=0

    declare -A tabInputOptionArgs=()
    declare -A tabOutputOptionArgs=()
    
    declare -a tabRequiredOptions=( "--input" "--output" )
    declare -a tabEncodedOptions=()

   

    # Save the `IFS` environmental variable
    saveIFS=$IFS

    # Change the `IFS`
    IFS=$'\n'
    
    # Shift `--concat` action
    shift 1


    # 
    for inputParam in "$@"
    do
        # Check if the current parameter is `--input`, then ...
        if [[ "$inputParam" == "--input" ]] || [[ "$inputParam" == "-i" ]]
        then

            # Process to verify if the current option has already been taken, then ...
            if [[ $counterRequiredOption -gt 0 ]]
            then
                # Get the content of the array in string mode
                getInStringModeOptions=` echo ${tabEncodedOptions[@]} `

                # Call the function
                flagOptionSpotted=` isOptionRepeat "$getInStringModeOptions" "$inputParam" `
                
                # Checking ...
                if [[ "$flagOptionSpotted" == "true" ]]
                then
                    #
                    echo "~"
                    echo -e "Action not performed due to repetition of \e[1;035m$inputParam\e[0m option 📛 🔰 "

                    exit 1
                fi
            fi


            # Get the next arguments
            getNextArgs=` printf '"%s" ' "${@:$counterIterParam}" `

            # Call of function, then ...
            tabInputOptionArgs["--input"]=` getArgsOption  "$getNextArgs" "$inputParam" `

            
            # For the `--input` option with the `--concat` action, at least one argument
            if [[  ` echo "${tabInputOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -lt 2 ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--concat\e[0m action , the \e[1;035m--input\e[0m option has to have at least two arguments 🧐 "

                exit 1
            fi
            
            # Save `IFS`
            saveIFSInInputOpt="$IFS"
            IFS=" : "

            # Iterate to check if the arguments of the `--input` option are pdf files
            for inputArg in ${tabInputOptionArgs[@]}
            do
                # Get the input 
                getPDFFile=` echo "$inputArg" | awk '{ gsub(/^["]+|["]+$/, ""); print }' ` 

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

            done 

            # Restore `IFS`
            IFS=$saveIFSInInputOpt

            # Increment the counter
            counterRequiredOption=$(( counterRequiredOption + 1 ))

            # Append the current option 
            tabEncodedOptions+="--input "
        
        # Check if the current parameter is `--output`, then ...
        elif [[ "$inputParam" == "--output" ]] ||  [[ "$inputParam" == "-o" ]]
        then

            # Process to verify if the current option has already been taken, then ...
            if [[ $counterRequiredOption -gt 0 ]]
            then
                # Get the content of the array in string mode
                getInStringModeOptions=` echo ${tabEncodedOptions[@]} `

                # Call the function
                flagOptionSpotted=` isOptionRepeat "$getInStringModeOptions" "$inputParam" `
                
                # Checking ...
                if [[ "$flagOptionSpotted" == "true" ]]
                then
                    #
                    echo "~"
                    echo -e "Action not performed due to repetition of \e[1;035m$inputParam\e[0m option 📛 🔰 "

                    exit 1
                fi
            fi


            # Get the next arguments
            getNextArgs=` printf '"%s" ' "${@:$counterIterParam}" `

            # Call of function, then ...
            tabOutputOptionArgs["--output"]=` getArgsOption  "$getNextArgs" "$inputParam" `

            # For the `--output` option with the `--concat` action, only one argument is required
            if [[ ` echo "${tabOutputOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -gt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--concat\e[0m action , the \e[1;035m--output\e[0m option has to have one argument 🧐 "

                exit 1
            fi
            #
            if [[ ` echo "${tabOutputOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -lt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--concat\e[0m action , the \e[1;035m--output\e[0m option has to have one argument 🧐 "

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
            && ( [[ "$inputParam" != "--output" ]] || [[ "$inputParam" != "-o" ]] )
        then
            
            #
            if [[ ` echo "$inputParam" | grep -- "^-" ` ]]
            then
                echo "~"
                echo -e "Unknown \e[1;031m$inputParam\e[0m option for the \e[1;36m--concat\e[0m action 🧐 "
            
                exit 1
            fi
        fi


        # Increment the counter 
        counterIterParam=$(( counterIterParam + 1 ))
    done


    # Restore the `IFS` environmental variable  
    IFS=$saveIFS
    

    # Check to see if the required options was used 
    if [[ $counterRequiredOption -ne 2 ]]
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



    ### Concatenating operating  -> start tag[o1]

    if [[ -e "$tmpWorkingDir/$getThePDFFile" ]]
    then
        #
        rm -r "$tmpWorkingDir/$getThePDFFile" 2> /dev/null
    fi
    

    # Get input pdf files
    stringPDFFiles=` echo ${tabInputOptionArgs[@]} | awk '{gsub(/ : /, " "); print }' | awk '{gsub(/["]*/, ""); print }' `
    
    # Concatenating
    pdftk $stringPDFFiles output "$getTheOutputNameFile" 1> /dev/null 2> "$tmpWorkingDir/concat-action" &


    # Call the function
    spinnerAnimation $!
    

    #
    if [[  ` cat "$tmpWorkingDir/concat-action" 2> /dev/null | wc -l ` -eq 0  ]]
    then
        echo "~"
        echo -e "Successfully concatenating ✅ " 

        # Call the function
        removeTmpWorkingDir

        exit 0
    else
        echo "~"
        echo -e "\e[1;031mError\e[0m ❌ during concatenating, make sure you have the right to write in the target"
        echo -e "directory where the concatenated pdf file will be sent , be sure also that "
        echo -e "your input pdf files do not contain spaces 🧐 "
        
        # Call the function
        removeTmpWorkingDir

        exit 1
    fi

    ### Concatenating operating  -> end tag[o1] 

    #
    exit 0
fi


### Action `concat` -> end tag[c0]





### Action `compress` -> start tag[c1]

#
if [[ "$1" == "--compress"  ]]
then
    
    # Declaration variables
    flagIsPDF=""
    argsOption=""
    getVersionOfPDFFile=""
    getThePDFFile=""
    getNbPageOfPDFFile=0
    getTheLevelOptionValue=0
    getTheOutputNameFile=""
    counterIterParam=1 # Shift the action `--compress`
    counterRequiredOption=0

    declare -A tabInputOptionArgs=()
    declare -A tabOutputOptionArgs=()
    declare -A tabLevelOptionArgs=()

    declare -a tabRequiredOptions=( "--input" "--output" "--level" )
    declare -a tabEncodedOptions=()

   

    # Save the `IFS` environmental variable
    saveIFS=$IFS

    # Change the `IFS`
    IFS=$'\n'
    
    # Shift `--compress` action
    shift 1


    # 
    for inputParam in "$@"
    do
        # Check if the current parameter is `--input`, then ...
        if [[ "$inputParam" == "--input" ]] || [[ "$inputParam" == "-i" ]]
        then

            # Process to verify if the current option has already been taken, then ...
            if [[ $counterRequiredOption -gt 0 ]]
            then
                # Get the content of the array in string mode
                getInStringModeOptions=` echo ${tabEncodedOptions[@]} `

                # Call the function
                flagOptionSpotted=` isOptionRepeat "$getInStringModeOptions" "$inputParam" `
                
                # Checking ...
                if [[ "$flagOptionSpotted" == "true" ]]
                then
                    #
                    echo "~"
                    echo -e "Action not performed due to repetition of \e[1;035m$inputParam\e[0m option 📛 🔰 "

                    exit 1
                fi
            fi


            # Get the next arguments
            getNextArgs=` printf '"%s" ' "${@:$counterIterParam}" `

            # Call of function, then ...
            tabInputOptionArgs["--input"]=` getArgsOption  "$getNextArgs" "$inputParam" `

            
            # For the `--input` option with the `--compress` action, only one argument is required
            if [[ ` echo "${tabInputOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -gt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--compress\e[0m action , the \e[1;035m--input\e[0m option has to have one argument 🧐 "

                exit 1
            fi
            #
            if [[  ` echo "${tabInputOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -lt 1 ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--compress\e[0m action , the \e[1;035m--input\e[0m option has to have one argument 🧐 "

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
        
        # Check if the current parameter is `--level`, then ...
        elif [[ "$inputParam" == "--level" ]] ||  [[ "$inputParam" == "-l" ]]
        then

            # Process to verify if the current option has already been taken, then ...
            if [[ $counterRequiredOption -gt 0 ]]
            then
                # Get the content of the array in string mode
                getInStringModeOptions=` echo ${tabEncodedOptions[@]} `

                # Call the function
                flagOptionSpotted=` isOptionRepeat "$getInStringModeOptions" "$inputParam" `
                
                # Checking ...
                if [[ "$flagOptionSpotted" == "true" ]]
                then
                    #
                    echo "~"
                    echo -e "Action not performed due to repetition of \e[1;035m$inputParam\e[0m option 📛 🔰 "

                    exit 1
                fi
            fi


            # Get the next arguments
            getNextArgs=` printf '"%s" ' "${@:$counterIterParam}" `

            # Call of function, then ...
            tabLevelOptionArgs["--level"]=` getArgsOption  "$getNextArgs" "$inputParam" `

            # For the `--level` option with the `--compress` action, only one argument is required
            if [[ ` echo "${tabLevelOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -gt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--compress\e[0m action , the \e[1;035m--level\e[0m option has to have one argument 🧐 "

                exit 1
            fi
            #
            if [[ ` echo "${tabLevelOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -lt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--compress\e[0m action , the \e[1;035m--level\e[0m option has to have one argument 🧐 "

                exit 1
            fi

            # Get the argument for the `--level` option 
            getArgForLevelOption=` echo "${tabLevelOptionArgs[@]}" | awk '{gsub(/"+/, ""); print }' |  awk '{gsub(/^ | $/, ""); print}' `
            
            # Check if `getArgForLevelOption` is an integer, then ...
            if [[ $getArgForLevelOption =~ (^[0-9]+$) ]]
            then
                #
                if ( [[ $getArgForLevelOption -ne 1 ]] ) && ( [[ $getArgForLevelOption -ne 2 ]] ) \
                    && ( [[ $getArgForLevelOption -ne 3 ]] ) && ( [[ $getArgForLevelOption -ne 4 ]] )
                then
                    echo "~"
                    echo -e "The value of the \e[1;035m--level\e[0m option has to be either "
                    echo -e "\e[1;036m1\e[0m or \e[1;036m2\e[0m or \e[1;036m3\e[0m or \e[1;036m4\e[0m 🤗 "

                    exit 1
                else
                    # Get the value for the `--level` option 
                    getTheLevelOptionValue=$getArgForLevelOption
                fi
            else
                echo "~"
                echo -e "The \e[1;031m$getArgForLevelOption\e[0m argument does not valid for the \e[1;035m--level\e[0m option ⚠️  "
                
                echo ""
                echo -e "The value of the \e[1;035m--level\e[0m option has to be either "
                echo -e "\e[1;036m1\e[0m or \e[1;036m2\e[0m or \e[1;036m3\e[0m or \e[1;036m4\e[0m 🤗 "

                exit 1
            fi


            # Increment the counter
            counterRequiredOption=$(( counterRequiredOption + 1 ))

            # Append the current option 
            tabEncodedOptions+="--level "
    
        # Check if the current parameter is `--output`, then ...
        elif [[ "$inputParam" == "--output" ]] ||  [[ "$inputParam" == "-o" ]]
        then

            # Process to verify if the current option has already been taken, then ...
            if [[ $counterRequiredOption -gt 0 ]]
            then
                # Get the content of the array in string mode
                getInStringModeOptions=` echo ${tabEncodedOptions[@]} `

                # Call the function
                flagOptionSpotted=` isOptionRepeat "$getInStringModeOptions" "$inputParam" `
                
                # Checking ...
                if [[ "$flagOptionSpotted" == "true" ]]
                then
                    #
                    echo "~"
                    echo -e "Action not performed due to repetition of \e[1;035m$inputParam\e[0m option 📛 🔰 "

                    exit 1
                fi
            fi


            # Get the next arguments
            getNextArgs=` printf '"%s" ' "${@:$counterIterParam}" `

            # Call of function, then ...
            tabOutputOptionArgs["--output"]=` getArgsOption  "$getNextArgs" "$inputParam" `

            # For the `--output` option with the `--compress` action, only one argument is required
            if [[ ` echo "${tabOutputOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -gt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--compress\e[0m action , the \e[1;035m--output\e[0m option has to have one argument 🧐 "

                exit 1
            fi
            #
            if [[ ` echo "${tabOutputOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -lt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--compress\e[0m action , the \e[1;035m--output\e[0m option has to have one argument 🧐 "

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
            && ( [[ "$inputParam" != "--output" ]] || [[ "$inputParam" != "-o" ]] ) \
            && ( [[ "$inputParam" != "--level" ]] || [[ "$inputParam" != "-l" ]] )
        then
            
            #
            if [[ ` echo "$inputParam" | grep -- "^-" ` ]]
            then
                echo "~"
                echo -e "Unknown \e[1;031m$inputParam\e[0m option for the \e[1;36m--compress\e[0m action 🧐 "
            
                exit 1
            fi
        fi


        # Increment the counter 
        counterIterParam=$(( counterIterParam + 1 ))
    done


    # Restore the `IFS` environmental variable  
    IFS=$saveIFS
    

    # Check to see if the required options was used 
    if [[ $counterRequiredOption -ne 3 ]]
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

    
    ### Compress operating  -> start tag[o1]

    if [[ -e "$tmpWorkingDir/$getThePDFFile" ]]
    then
        #
        rm -r "$tmpWorkingDir/$getThePDFFile" 2> /dev/null
    fi


    # Compressing 
    ( 
        if [[ $getTheLevelOptionValue -eq 1 ]]
        then
            gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress \
                -sOutputFile="$tmpWorkingDir/$getTheOutputNameFile" "$getThePDFFile" &> /dev/null

        elif [[ $getTheLevelOptionValue -eq 2 ]]
        then
            gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dPDFSETTINGS=/printer \
                -sOutputFile="$tmpWorkingDir/$getTheOutputNameFile" "$getThePDFFile" &> /dev/null

        elif [[ $getTheLevelOptionValue -eq 3 ]]
        then
            gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dPDFSETTINGS=/ebook \
                -sOutputFile="$tmpWorkingDir/$getTheOutputNameFile" "$getThePDFFile" &> /dev/null

        elif [[ $getTheLevelOptionValue -eq 4 ]]
        then
            gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -dPDFSETTINGS=/screen \
                -sOutputFile="$tmpWorkingDir/$getTheOutputNameFile" "$getThePDFFile" &> /dev/null
        fi 
    ) &
    
    # Call the function
    spinnerAnimation $!
   
    # Move the compress file towards the output given name 
    mv "$tmpWorkingDir/$getTheOutputNameFile" "$getTheOutputNameFile" 2> "$tmpWorkingDir/move-action"
    
    #
    if [[  ` cat "$tmpWorkingDir/move-action" 2> /dev/null | wc -l ` -eq 0  ]]
    then
        #
        echo "~"
        echo -e "Successfully compressing ✅ "

        # Call the function
        removeTmpWorkingDir

        exit 0
    else
        echo "~"
        echo -e "\e[1;031mError\e[0m ❌ during compressing, make sure you have the right to write in the target directory "
        echo -e "where the pdf file will be sent 🧐 "

        # Call the function
        removeTmpWorkingDir

        exit 1
    fi


    ### Compress operating  -> end tag[o1]

    #
    exit 0
fi


### Action `compress` -> end tag[c1]





### Action `rotate` -> start tag[r0]

if [[ "$1" == "--rotate"  ]]
then
    
    # Declaration variables
    flagIsPDF=""
    argsOption=""
    getVersionOfPDFFile=""
    getThePDFFile=""
    getNbPageOfPDFFile=0
    getTheCardinalOptionValue=0
    getTheOutputNameFile=""
    counterIterParam=1 # Shift the action `--rotate`
    counterRequiredOption=0

    declare -A tabInputOptionArgs=()
    declare -A tabOutputOptionArgs=()
    declare -A tabCardinalOptionArgs=()

    declare -a tabRequiredOptions=( "--input" "--output" "--cardinal" )
    declare -a tabEncodedOptions=()

   

    # Save the `IFS` environmental variable
    saveIFS=$IFS

    # Change the `IFS`
    IFS=$'\n'
    
    # Shift `--rotate` action
    shift 1


    # 
    for inputParam in "$@"
    do
        # Check if the current parameter is `--input`, then ...
        if [[ "$inputParam" == "--input" ]] || [[ "$inputParam" == "-i" ]]
        then

            # Process to verify if the current option has already been taken, then ...
            if [[ $counterRequiredOption -gt 0 ]]
            then
                # Get the content of the array in string mode
                getInStringModeOptions=` echo ${tabEncodedOptions[@]} `

                # Call the function
                flagOptionSpotted=` isOptionRepeat "$getInStringModeOptions" "$inputParam" `
                
                # Checking ...
                if [[ "$flagOptionSpotted" == "true" ]]
                then
                    #
                    echo "~"
                    echo -e "Action not performed due to repetition of \e[1;035m$inputParam\e[0m option 📛 🔰 "

                    exit 1
                fi
            fi


            # Get the next arguments
            getNextArgs=` printf '"%s" ' "${@:$counterIterParam}" `

            # Call of function, then ...
            tabInputOptionArgs["--input"]=` getArgsOption  "$getNextArgs" "$inputParam" `

            
            # For the `--input` option with the `--rotate` action, only one argument is required
            if [[ ` echo "${tabInputOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -gt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--rotate\e[0m action , the \e[1;035m--input\e[0m option has to have one argument 🧐 "

                exit 1
            fi
            #
            if [[  ` echo "${tabInputOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -lt 1 ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--rotate\e[0m action , the \e[1;035m--input\e[0m option has to have one argument 🧐 "

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
        
        # Check if the current parameter is `--cardinal`, then ...
        elif [[ "$inputParam" == "--cardinal" ]] ||  [[ "$inputParam" == "-c" ]]
        then

            # Process to verify if the current option has already been taken, then ...
            if [[ $counterRequiredOption -gt 0 ]]
            then
                # Get the content of the array in string mode
                getInStringModeOptions=` echo ${tabEncodedOptions[@]} `

                # Call the function
                flagOptionSpotted=` isOptionRepeat "$getInStringModeOptions" "$inputParam" `
                
                # Checking ...
                if [[ "$flagOptionSpotted" == "true" ]]
                then
                    #
                    echo "~"
                    echo -e "Action not performed due to repetition of \e[1;035m$inputParam\e[0m option 📛 🔰 "

                    exit 1
                fi
            fi


            # Get the next arguments
            getNextArgs=` printf '"%s" ' "${@:$counterIterParam}" `

            # Call of function, then ...
            tabCardinalOptionArgs["--cardinal"]=` getArgsOption  "$getNextArgs" "$inputParam" `

            # For the `--cardinal` option with the `--rotate` action, only one argument is required
            if [[ ` echo "${tabCardinalOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -gt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--rotate\e[0m action , the \e[1;035m--cardinal\e[0m option has to have one argument 🧐 "

                exit 1
            fi
            #
            if [[ ` echo "${tabCardinalOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -lt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--rotate\e[0m action , the \e[1;035m--cardinal\e[0m option has to have one argument 🧐 "

                exit 1
            fi

            # Get the argument for the `--cardinal` option 
            getArgForCardinalOption=` echo "${tabCardinalOptionArgs[@]}" | awk '{gsub(/"+/, ""); print }' | \
                awk '{gsub(/^ | $/, ""); print}' `
            
            # Check if `getArgForCardinalOption` is string, then ...
            if [[ $getArgForCardinalOption =~ (^[a-z]+$) ]]
            then
                #
                if ( [[ $getArgForCardinalOption != "north" ]] ) && ( [[ $getArgForCardinalOption != "south" ]] ) \
                    && ( [[ $getArgForCardinalOption != "east" ]] ) && ( [[ $getArgForCardinalOption != "west" ]] )
                then
                    #
                    echo "~"
                    echo -en "The \e[1;032mvalue\e[0m of the \e[1;032m--cardinal\e[0m option has to be either "
                    echo -e "\e[1;035mnorth\e[0m for the \e[1;033mnorth\e[0m "
                    echo -en "or \e[1;035meast\e[0m for the \e[1;033meast\e[0m or " 
                    echo -e "\e[1;035msouth\e[0m for the \e[1;033msouth\e[0m or \e[1;035mwest\e[0m for the \e[1;033mwest\e[0m 🕵 "

                    exit 1
                else
                    # Get the value for the `--cardinal` option 
                    getTheCardinalOptionValue=$getArgForCardinalOption
                fi
            else
                echo "~"
                echo -e "The \e[1;031m$getArgForCardinalOption\e[0m argument does not valid for the \e[1;035m--cardinal\e[0m option ⚠️  "
                
                exit 1
            fi


            # Increment the counter
            counterRequiredOption=$(( counterRequiredOption + 1 ))

            # Append the current option 
            tabEncodedOptions+="--cardinal "
    
        # Check if the current parameter is `--output`, then ...
        elif [[ "$inputParam" == "--output" ]] ||  [[ "$inputParam" == "-o" ]]
        then

            # Process to verify if the current option has already been taken, then ...
            if [[ $counterRequiredOption -gt 0 ]]
            then
                # Get the content of the array in string mode
                getInStringModeOptions=` echo ${tabEncodedOptions[@]} `

                # Call the function
                flagOptionSpotted=` isOptionRepeat "$getInStringModeOptions" "$inputParam" `
                
                # Checking ...
                if [[ "$flagOptionSpotted" == "true" ]]
                then
                    #
                    echo "~"
                    echo -e "Action not performed due to repetition of \e[1;035m$inputParam\e[0m option 📛 🔰 "

                    exit 1
                fi
            fi


            # Get the next arguments
            getNextArgs=` printf '"%s" ' "${@:$counterIterParam}" `

            # Call of function, then ...
            tabOutputOptionArgs["--output"]=` getArgsOption  "$getNextArgs" "$inputParam" `

            # For the `--output` option with the `--rotate` action, only one argument is required
            if [[ ` echo "${tabOutputOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -gt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--rotate\e[0m action , the \e[1;035m--output\e[0m option has to have one argument 🧐 "

                exit 1
            fi
            #
            if [[ ` echo "${tabOutputOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -lt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--rotate\e[0m action , the \e[1;035m--output\e[0m option has to have one argument 🧐 "

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
            && ( [[ "$inputParam" != "--output" ]] || [[ "$inputParam" != "-o" ]] ) \
            && ( [[ "$inputParam" != "--cardinal" ]] || [[ "$inputParam" != "-c" ]] )
        then
            
            #
            if [[ ` echo "$inputParam" | grep -- "^-" ` ]]
            then
                echo "~"
                echo -e "Unknown \e[1;031m$inputParam\e[0m option for the \e[1;36m--rotate\e[0m action 🧐 "
            
                exit 1
            fi
        fi


        # Increment the counter 
        counterIterParam=$(( counterIterParam + 1 ))
    done


    # Restore the `IFS` environmental variable  
    IFS=$saveIFS
    

    # Check to see if the required options was used 
    if [[ $counterRequiredOption -ne 3 ]]
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

    
    ### Rotate operating  -> start tag[o1]

    if [[ -e "$tmpWorkingDir/$getThePDFFile" ]]
    then
        #
        rm -r "$tmpWorkingDir/$getThePDFFile" 2> /dev/null
    fi
    

    # Rotating 
    ( 
        if [[ $getTheCardinalOptionValue == "north" ]]
        then
            #
            pdftk "$getThePDFFile" cat 1-endnorth  output "$getTheOutputNameFile" 1> /dev/null 2> "$tmpWorkingDir/rotate-action"

        elif [[ $getTheCardinalOptionValue == "south" ]]
        then
            #
            pdftk "$getThePDFFile" cat 1-endsouth output "$getTheOutputNameFile" 1> /dev/null 2> "$tmpWorkingDir/rotate-action"

        elif [[ $getTheCardinalOptionValue == "east" ]]
        then
            # 
            pdftk "$getThePDFFile" cat 1-endeast output "$getTheOutputNameFile" 1> /dev/null 2> "$tmpWorkingDir/rotate-action"

        elif [[ $getTheCardinalOptionValue == "west" ]]
        then
            #
            pdftk "$getThePDFFile" cat 1-endwest output "$getTheOutputNameFile" 1> /dev/null 2> "$tmpWorkingDir/rotate-action"
        fi 
    ) &
    
    # Call the function
    spinnerAnimation $!
   
    
    #
    if [[ ` cat "$tmpWorkingDir/rotate-action" 2> /dev/null | wc -l ` -eq 0  ]]
    then
        #
        echo "~"
        echo -e "Successfully rotation ✅ "

        # Call the function
        removeTmpWorkingDir

        exit 0
    else
        echo "~"
        echo -e "\e[1;031mError\e[0m ❌ during rotating, make sure you have the right to write in the target directory "
        echo -e "where the pdf file will be sent 🧐 "

        # Call the function
        removeTmpWorkingDir

        exit 1
    fi


    ### Rotate operating  -> end tag[o1]

    #
    exit 0
fi


### Action `rotate` -> end tag[r0]





### Action `include` -> start tag[eo]

if [[ "$1" == "--include"  ]]
then
    
    # Declaration variables
    flagIsPDF=""
    argsOption=""
    getVersionOfPDFFile=""
    getThePDFFile=""
    getNbPageOfPDFFile=0
    getTheNbPageOfPDFFileDest=0
    getTheNbPageOfPDFFileSrc=0
    getTheAfterPgOptionValue=0
    getTheSrcOptionValue=""
    getTheDestOptionValue=""
    getTheOutputNameFile=""
    counterIterParam=1 # Shift the action `--include`
    counterRequiredOption=0

    declare -A tabSourceOptionArgs=()
    declare -A tabDestinationOptionArgs=()
    declare -A tabOutputOptionArgs=()
    declare -A tabAfterPgOptionArgs=()

    declare -a tabRequiredOptions=( "--source" "--destination" "--output" "--after-page" )
    declare -a tabEncodedOptions=()

   

    # Save the `IFS` environmental variable
    saveIFS=$IFS

    # Change the `IFS`
    IFS=$'\n'
    
    # Shift `--include` action
    shift 1


    # 
    for inputParam in "$@"
    do
        # Check if the current parameter is `--source`, then ...
        if [[ "$inputParam" == "--source" ]] || [[ "$inputParam" == "-s" ]]
        then

            # Process to verify if the current option has already been taken, then ...
            if [[ $counterRequiredOption -gt 0 ]]
            then
                # Get the content of the array in string mode
                getInStringModeOptions=` echo ${tabEncodedOptions[@]} `

                # Call the function
                flagOptionSpotted=` isOptionRepeat "$getInStringModeOptions" "$inputParam" `
                
                # Checking ...
                if [[ "$flagOptionSpotted" == "true" ]]
                then
                    #
                    echo "~"
                    echo -e "Action not performed due to repetition of \e[1;035m$inputParam\e[0m option 📛 🔰 "

                    exit 1
                fi
            fi


            # Get the next arguments
            getNextArgs=` printf '"%s" ' "${@:$counterIterParam}" `

            # Call of function, then ...
            tabSourceOptionArgs["--source"]=` getArgsOption  "$getNextArgs" "$inputParam" `

            
            # For the `--source` option with the `--include` action, only one argument is required
            if [[ ` echo "${tabSourceOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -gt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--include\e[0m action , the \e[1;035m--source\e[0m option has to have one argument 🧐 "

                exit 1
            fi
            #
            if [[  ` echo "${tabSourceOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -lt 1 ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--include\e[0m action , the \e[1;035m--source\e[0m option has to have one argument 🧐 "

                exit 1
            fi
            

            # Get the source 
            getPDFFile=` echo "${tabSourceOptionArgs[@]}" | awk '{gsub(/"+/, ""); print }' |  awk '{gsub(/^ | $/, ""); print}' `
            
            # Check if the given source exists
            if [[ -e "$getPDFFile" ]] && [[ ! ( -d "$getPDFFile" ) ]]
            then
                # Call the functions 
                flagIsPDF=` isPDFFile "$getPDFFile" `
                
                # Check if the file is a pdf file, then ...
                if [[ "$flagIsPDF" == "true" ]]
                then
                    # Call the functions
                    getTheNbPageOfPDFFileSrc=` getNbPagePDFFile $getPDFFile `

                    #getVersionOfPDFFile=` getVersionPDFFile $getPDFFile `

                    #
                    getThePDFFile="$getPDFFile"
                    getTheSrcOptionValue="$getPDFFile"

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
            tabEncodedOptions+="--source "


        # Check if the current parameter is `--destination`, then ...
        elif [[ "$inputParam" == "--destination" ]] || [[ "$inputParam" == "-d" ]]
        then

            # Process to verify if the current option has already been taken, then ...
            if [[ $counterRequiredOption -gt 0 ]]
            then
                # Get the content of the array in string mode
                getInStringModeOptions=` echo ${tabEncodedOptions[@]} `

                # Call the function
                flagOptionSpotted=` isOptionRepeat "$getInStringModeOptions" "$inputParam" `
                
                # Checking ...
                if [[ "$flagOptionSpotted" == "true" ]]
                then
                    #
                    echo "~"
                    echo -e "Action not performed due to repetition of \e[1;035m$inputParam\e[0m option 📛 🔰 "

                    exit 1
                fi
            fi


            # Get the next arguments
            getNextArgs=` printf '"%s" ' "${@:$counterIterParam}" `

            # Call of function, then ...
            tabDestinationOptionArgs["--destination"]=` getArgsOption  "$getNextArgs" "$inputParam" `

            
            # For the `--destination` option with the `--include` action, only one argument is required
            if [[ ` echo "${tabDestinationOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -gt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--include\e[0m action , the \e[1;035m--destination\e[0m option has to have one argument 🧐 "

                exit 1
            fi
            #
            if [[  ` echo "${tabDestinationOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -lt 1 ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--include\e[0m action , the \e[1;035m--destination\e[0m option has to have one argument 🧐 "

                exit 1
            fi
            

            # Get the destination 
            getPDFFile=` echo "${tabDestinationOptionArgs[@]}" | awk '{gsub(/"+/, ""); print }' |  awk '{gsub(/^ | $/, ""); print}' `
            
            # Check if the given destination exists
            if [[ -e "$getPDFFile" ]] && [[ ! ( -d "$getPDFFile" ) ]]
            then
                # Call the functions 
                flagIsPDF=` isPDFFile "$getPDFFile" `
                
                # Check if the file is a pdf file, then ...
                if [[ "$flagIsPDF" == "true" ]]
                then
                    # Call the functions
                    getTheNbPageOfPDFFileDest=` getNbPagePDFFile $getPDFFile `

                    #getNbPageOfPDFFile=` getNbPagePDFFile $getPDFFile `
                    #getVersionOfPDFFile=` getVersionPDFFile $getPDFFile `

                    #
                    getThePDFFile="$getPDFFile"
                    getTheDestOptionValue="$getPDFFile"

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
            tabEncodedOptions+="--destination "
        
        
        # Check if the current parameter is `--after-page`, then ...
        elif [[ "$inputParam" == "--after-page" ]] ||  [[ "$inputParam" == "-a" ]]
        then

            # Process to verify if the current option has already been taken, then ...
            if [[ $counterRequiredOption -gt 0 ]]
            then
                # Get the content of the array in string mode
                getInStringModeOptions=` echo ${tabEncodedOptions[@]} `

                # Call the function
                flagOptionSpotted=` isOptionRepeat "$getInStringModeOptions" "$inputParam" `
                
                # Checking ...
                if [[ "$flagOptionSpotted" == "true" ]]
                then
                    #
                    echo "~"
                    echo -e "Action not performed due to repetition of \e[1;035m$inputParam\e[0m option 📛 🔰 "

                    exit 1
                fi
            fi


            # Get the next arguments
            getNextArgs=` printf '"%s" ' "${@:$counterIterParam}" `

            # Call of function, then ...
            tabAfterPgOptionArgs["--after-page"]=` getArgsOption  "$getNextArgs" "$inputParam" `

            # For the `--after-page` option with the `--include` action, only one argument is required
            if [[ ` echo "${tabAfterPgOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -gt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--include\e[0m action , the \e[1;035m--after-page\e[0m option has to have one argument 🧐 "

                exit 1
            fi
            #
            if [[ ` echo "${tabAfterPgOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -lt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--include\e[0m action , the \e[1;035m--after-page\e[0m option has to have one argument 🧐 "

                exit 1
            fi

            # Get the argument for the `--after-page` option 
            getArgForAfterPgOption=` echo "${tabAfterPgOptionArgs[@]}" | awk '{gsub(/"+/, ""); print }' |  awk '{gsub(/^ | $/, ""); print}' `
            
            # Check if `getArgForAfterPgOption` is an integer, then ...
            if [[ $getArgForAfterPgOption =~ (^[0-9]+$) ]]
            then
                #
                if [[ $getArgForAfterPgOption -lt 1 ]]
                then
                    echo "~"
                    echo -e "The value of the \e[1;035m--after-page\e[0m option has to be strictly positive 🤗 "

                    exit 1
                else
                    # Get the value for the `--after-page` option 
                    getTheAfterPgOptionValue=$getArgForAfterPgOption
                fi
            else
                echo "~"
                echo -e "The \e[1;031m$getArgForAfterPgOption\e[0m argument does not valid for the \e[1;035m--after-page\e[0m option ⚠️  "
                
                echo ""
                echo -e "The value of the \e[1;035m--after-page\e[0m option has to be an integer 🤗 "

                exit 1
            fi


            # Increment the counter
            counterRequiredOption=$(( counterRequiredOption + 1 ))

            # Append the current option 
            tabEncodedOptions+="--after-page "
    
        # Check if the current parameter is `--output`, then ...
        elif [[ "$inputParam" == "--output" ]] ||  [[ "$inputParam" == "-o" ]]
        then

            # Process to verify if the current option has already been taken, then ...
            if [[ $counterRequiredOption -gt 0 ]]
            then
                # Get the content of the array in string mode
                getInStringModeOptions=` echo ${tabEncodedOptions[@]} `

                # Call the function
                flagOptionSpotted=` isOptionRepeat "$getInStringModeOptions" "$inputParam" `
                
                # Checking ...
                if [[ "$flagOptionSpotted" == "true" ]]
                then
                    #
                    echo "~"
                    echo -e "Action not performed due to repetition of \e[1;035m$inputParam\e[0m option 📛 🔰 "

                    exit 1
                fi
            fi


            # Get the next arguments
            getNextArgs=` printf '"%s" ' "${@:$counterIterParam}" `

            # Call of function, then ...
            tabOutputOptionArgs["--output"]=` getArgsOption  "$getNextArgs" "$inputParam" `

            # For the `--output` option with the `--include` action, only one argument is required
            if [[ ` echo "${tabOutputOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -gt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--include\e[0m action , the \e[1;035m--output\e[0m option has to have one argument 🧐 "

                exit 1
            fi
            #
            if [[ ` echo "${tabOutputOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -lt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--include\e[0m action , the \e[1;035m--output\e[0m option has to have one argument 🧐 "

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

        elif ( [[ "$inputParam" != "--source" ]] || [[ "$inputParam" != "-s" ]] ) \
            && ( [[ "$inputParam" != "--destination" ]] || [[ "$inputParam" != "-d" ]] ) \
            && ( [[ "$inputParam" != "--output" ]] || [[ "$inputParam" != "-o" ]] ) \
            && ( [[ "$inputParam" != "--after-page" ]] || [[ "$inputParam" != "-a" ]] )
        then
            
            #
            if [[ ` echo "$inputParam" | grep -- "^-" ` ]]
            then
                echo "~"
                echo -e "Unknown \e[1;031m$inputParam\e[0m option for the \e[1;36m--include\e[0m action 🧐 "
            
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
            # the source options parameters (encoded by the user)
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

    
    ### Include operating  -> start tag[o1]

    if [[ -e "$tmpWorkingDir/$getThePDFFile" ]]
    then
        #
        rm -r "$tmpWorkingDir/$getThePDFFile" 2> /dev/null
    fi


    # Check if the given value referring to the destination pdf file does not exceed the number of pages that the latter  
    if [[ $getTheAfterPgOptionValue -gt $getTheNbPageOfPDFFileDest ]]
    then
        #
        echo "~"
        echo -e "\e[1;093mOups !\e[0m The encoded value referring to the destination pdf file is greater than "
        echo -e "the number of pages that the latter has 🧐 "

        exit 1

    elif [[ $getTheAfterPgOptionValue -eq $getTheNbPageOfPDFFileDest ]]
    then
        #
        echo "~"
        echo -e "\e[1;093mOups !\e[0m The encoded value referring to the destination pdf file is equal to "
        echo -e "the number of pages that the latter has 🧐 "
        echo ""
        echo -e "Do a \e[1;032mconcatenation\e[0m instead "

        exit 1
    fi

    # Including
    continuePg=` echo "($getTheAfterPgOptionValue + 1)" | bc `

    pdftk A="$getTheDestOptionValue" B="$getTheSrcOptionValue" C="$getTheDestOptionValue"  \
        cat A1-$getTheAfterPgOptionValue B C$continuePg-end \
        output "$getTheOutputNameFile" 1> /dev/null 2> "$tmpWorkingDir/include-action" & 

    
    # Call the function
    spinnerAnimation $!
    
    #
    if [[  ` cat "$tmpWorkingDir/include-action" 2> /dev/null | wc -l ` -eq 0  ]]
    then
        #
        echo "~"
        echo -e "Successfully including ✅ "

        # Call the function
        removeTmpWorkingDir

        exit 0
    else
        echo "~"
        echo -e "\e[1;031mError\e[0m ❌ during including, make sure you have the right to write in the target directory "
        echo -e "where the pdf file will be sent 🧐 "

        # Call the function
        removeTmpWorkingDir

        exit 1
    fi


    ### Include operating  -> end tag[o1]

    #
    exit 0
fi


### Action `include` -> end tag[eo]





### Action `exclude` -> start tag[e0]

if [[ "$1" == "--exclude" ]]
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
    counterIterParam=1 # Shift the action `--exclude`
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
    
    # Shift `--exclude` action
    shift 1


    # 
    for inputParam in "$@"
    do
        # Check if the current parameter is `--input`, then ...
        if [[ "$inputParam" == "--input" ]] || [[ "$inputParam" == "-i" ]]
        then

            # Process to verify if the current option has already been taken, then ...
            if [[ $counterRequiredOption -gt 0 ]]
            then
                # Get the content of the array in string mode
                getInStringModeOptions=` echo ${tabEncodedOptions[@]} `

                # Call the function
                flagOptionSpotted=` isOptionRepeat "$getInStringModeOptions" "$inputParam" `
                
                # Checking ...
                if [[ "$flagOptionSpotted" == "true" ]]
                then
                    #
                    echo "~"
                    echo -e "Action not performed due to repetition of \e[1;035m$inputParam\e[0m option 📛 🔰 "

                    exit 1
                fi
            fi


            # Get the next arguments
            getNextArgs=` printf '"%s" ' "${@:$counterIterParam}" `

            # Call of function, then ...
            tabInputOptionArgs["--input"]=` getArgsOption  "$getNextArgs" "$inputParam" `

            
            # For the `--input` option with the `--exclude` action, only one argument is required
            if [[ ` echo "${tabInputOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -gt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--exclude\e[0m action , the \e[1;035m--input\e[0m option has to have one argument 🧐 "

                exit 1
            fi
            #
            if [[  ` echo "${tabInputOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -lt 1 ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--exclude\e[0m action , the \e[1;035m--input\e[0m option has to have one argument 🧐 "

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
            
            # Process to verify if the current option has already been taken, then ...
            if [[ $counterRequiredOption -gt 0 ]]
            then
                # Get the content of the array in string mode
                getInStringModeOptions=` echo ${tabEncodedOptions[@]} `

                # Call the function
                flagOptionSpotted=` isOptionRepeat "$getInStringModeOptions" "$inputParam" `
                
                # Checking ...
                if [[ "$flagOptionSpotted" == "true" ]]
                then
                    #
                    echo "~"
                    echo -e "Action not performed due to repetition of \e[1;035m$inputParam\e[0m option 📛 🔰 "

                    exit 1
                fi
            fi


            # Get the next arguments
            getNextArgs=` printf '"%s" ' "${@:$counterIterParam}" `

            # Call of function, then ...
            tabFromOptionArgs["--from"]=` getArgsOption  "$getNextArgs" "$inputParam" `

            # For the `--from` option with the `--exclude` action, only one argument is required
            if [[ ` echo "${tabFromOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -gt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--exclude\e[0m action , the \e[1;035m--from\e[0m option has to have one argument 🧐 "

                exit 1
            fi
            #
            if [[ ` echo "${tabFromOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -lt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--exclude\e[0m action , the \e[1;035m--from\e[0m option has to have one argument 🧐 "

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

            # Process to verify if the current option has already been taken, then ...
            if [[ $counterRequiredOption -gt 0 ]]
            then
                # Get the content of the array in string mode
                getInStringModeOptions=` echo ${tabEncodedOptions[@]} `

                # Call the function
                flagOptionSpotted=` isOptionRepeat "$getInStringModeOptions" "$inputParam" `
                
                # Checking ...
                if [[ "$flagOptionSpotted" == "true" ]]
                then
                    #
                    echo "~"
                    echo -e "Action not performed due to repetition of \e[1;035m$inputParam\e[0m option 📛 🔰 "

                    exit 1
                fi
            fi


            # Get the next arguments
            getNextArgs=` printf '"%s" ' "${@:$counterIterParam}" `

            # Call of function, then ...
            tabToOptionArgs["--to"]=` getArgsOption  "$getNextArgs" "$inputParam" `

            # For the `--to` option with the `--exclude` action, only one argument is required
            if [[ ` echo "${tabToOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -gt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--exclude\e[0m action , the \e[1;035m--to\e[0m option has to have one argument 🧐 "

                exit 1
            fi
            #
            if [[ ` echo "${tabToOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -lt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--exclude\e[0m action , the \e[1;035m--to\e[0m option has to have one argument 🧐 "

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

            # Process to verify if the current option has already been taken, then ...
            if [[ $counterRequiredOption -gt 0 ]]
            then
                # Get the content of the array in string mode
                getInStringModeOptions=` echo "${tabEncodedOptions[@]}" `

                # Call the function
                flagOptionSpotted=` isOptionRepeat "$getInStringModeOptions" "$inputParam" `

                # Checking ...
                if [[ "$flagOptionSpotted" == "true" ]]
                then
                    #
                    echo "~"
                    echo -e "Action not performed due to repetition of \e[1;035m$inputParam\e[0m option 📛 🔰 "

                    exit 1
                fi
            fi


            # Get the next arguments
            getNextArgs=` printf '"%s" ' "${@:$counterIterParam}" `

            # Call of function, then ...
            tabOutputOptionArgs["--output"]=` getArgsOption  "$getNextArgs" "$inputParam" `

            # For the `--output` option with the `--exclude` action, only one argument is required
            if [[ ` echo "${tabOutputOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -gt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--exclude\e[0m action , the \e[1;035m--output\e[0m option has to have one argument 🧐 "

                exit 1
            fi
            #
            if [[ ` echo "${tabOutputOptionArgs[@]}" | awk -F " : " '{ print NF }' ` -lt 1  ]]
            then
                echo "~"
                echo -e "For the \e[1;36m--exclude\e[0m action , the \e[1;035m--output\e[0m option has to have one argument 🧐 "

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
                echo -e "Unknown \e[1;031m$inputParam\e[0m option for the \e[1;36m--exclude\e[0m action 🧐 "
            
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


    # Excluding operating 
    if [[ $getTheToOptionValue -gt $getNbPageOfPDFFile ]] || [[ $getTheFromOptionValue -gt $getNbPageOfPDFFile ]]
    then
        echo "~"
        echo -e "\e[1;031mOut of bound\e[0m , the input pdf file is only $getNbPageOfPDFFile pages 📛 🚧 "

        # Call the function
        removeTmpWorkingDir

        exit 1

    elif [[ $getTheToOptionValue -lt $getTheFromOptionValue ]]
    then
        echo "~"
        echo -e "The value of the \e[1;036m--to\e[0m option has to be greater than or equal "
        echo -e "to that of the \e[1;036m--from\e[0m option 🧐 "

        # Call the function
        removeTmpWorkingDir

        exit 1
    else
        ## Excluding 
        
        #
        if [[ $getNbPageOfPDFFile -eq 1 ]]
        then
            #
            echo "~"
            echo -e "\e[1;033mOups !\e[0m Impossible to perform this request, the target pdf file has only one page 🔰 "

            # Call the function
            removeTmpWorkingDir

            exit 1
        fi

        #
        if [[ $getTheFromOptionValue -eq 1 ]] && [[ $getTheToOptionValue -eq $getNbPageOfPDFFile ]]
        then
            #
            echo "~"
            echo -e "\e[1;033mOups !\e[0m Impossible to perform this request, the output pdf file will be empty 🔰 "

            # Call the function
            removeTmpWorkingDir

            exit 1
        fi

        # Declaration variables
        targetPg=0
        beforePg=0
        continuePg=0

        
        # Action ...
        if [[ $getTheFromOptionValue -eq 1 ]] && [[ $getTheToOptionValue -eq 1 ]]
        then
            #
            pdftk A="$getThePDFFile" \
                cat A2-end output "$getTheOutputNameFile" 1> /dev/null 2> "$tmpWorkingDir/exclude-action" &

            # Call the function
            spinnerAnimation $!

        elif [[ $getTheFromOptionValue -gt 1 ]] && [[ $getTheToOptionValue -eq $getNbPageOfPDFFile ]]
        then
            #
            targetPg=` echo "$getTheFromOptionValue-1" | bc `

            #
            pdftk A="$getThePDFFile" \
                cat A1-$targetPg output "$getTheOutputNameFile" 1> /dev/null 2> "$tmpWorkingDir/exclude-action" &

            # Call the function
            spinnerAnimation $!

        elif [[ $getTheFromOptionValue -eq $getNbPageOfPDFFile ]] && [[ $getTheToOptionValue -eq $getNbPageOfPDFFile ]]
        then
            #
            targetPg=` echo "$getTheToOptionValue-1" | bc `

            #
            pdftk A="$getThePDFFile" \
                cat A1-$targetPg output "$getTheOutputNameFile" 1> /dev/null 2> "$tmpWorkingDir/exclude-action" &

            # Call the function
            spinnerAnimation $!

        elif [[ $getTheFromOptionValue -gt 1 ]] && [[ $getTheToOptionValue -lt $getNbPageOfPDFFile ]]
        then
            #
            continuePg=` echo "$getTheToOptionValue+1" | bc `
            beforePg=` echo "$getTheFromOptionValue-1" | bc `


            #
            pdftk A="$getThePDFFile" B="$getThePDFFile" \
                cat A1-$beforePg B$continuePg-end \
                output "$getTheOutputNameFile" 1> /dev/null 2> "$tmpWorkingDir/exclude-action" &

            # Call the function
            spinnerAnimation $!
        else
            #
            echo "~"
            echo -e "The request could not be carried out , due to the non-existence of the scenario 🤔 "

            # Call the function
            removeTmpWorkingDir

            exit 1
        fi

        
        #
        if [[ -e "$tmpWorkingDir/exclude-action" ]]
        then
            if [[ ` cat "$tmpWorkingDir/exclude-action" | wc -l` -gt 0 ]]
            then
                echo "~"
                echo -e "\e[1;031mError\e[0m ❌ during excluding, make sure you have the right to write in the target directory "
                echo -e "where the pdf file will be sent 🧐 "

                # Call the function
                removeTmpWorkingDir

                exit 1
            else
                echo "~"
                echo -e "Successfully excluding ✅ "

                # Call the function
                removeTmpWorkingDir

                exit 0
            fi
        fi

    fi

    #
    exit 0
fi

### Action `exclude` -> end tag[e0] 
