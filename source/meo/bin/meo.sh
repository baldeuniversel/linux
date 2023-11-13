#!/usr/bin/zsh

:   ' 
    /**
    * @overview This program allows to manage the installed packages from the git repository 
    * `https://github.com/baldeuniversel/linux.git` (First of all, this program is written for 
    *                                                the <<Ve-Quantic>> members) .
    * The program also allows to list available packages from the same git repository.
    *
    *
    *
    * @requires The only options supported are [ self-update, self-remove, install, update, upgrade, 
    *                                            remove, list, list-installed, search, show, --help, 
    *                                            --doc, --version ] 
    * && the <<meo>> command has to have at least one option .  Ex: meo self-update
    * && with the options [ install, remove, search, show ] you have to give the package(s)
    * && with the options [ self-update, self-remove, list, list-installed, update, --help, --doc, 
    *                       --version ] there is not another parameter
    * && with the option [ upgrade ], you can either upgrade all the installed packages by `meo` or
    *                                                            upgrade target installed packages 
    *                                Ex : meo upgrade    (to upgrade all the installed packages by `meo`) 
    *                                Ex : meo upgrade am-okay    (to upgrade the target installed package)    
    * && you can not call `meo` program to install it itself . Ex : meo install meo
    *
    *
    *
    * Options :
    * --------
    * @param {string} self-update // This option allows updading `meo` program
    *                                Ex : meo self-update
    * 
    * @param {string} self-remove // This option allows removing `meo` program
    *                                Ex : meo self-remove
    *
    * @param {string} install // This option allows intalling a package
    *                            Ex : meo install am-okay
    *
    * @param {string} update // This option allows listing the packages ready to upgrade
    *                           Ex : meo update
    *
    * @param {string} upgrade // This option allows upgrading the packages ready to upgrade
    *                            Ex : meo upgrade (to upgrade all the installed packages by `meo` program)
    *                            Ex : meo upgrade am-okay (to upgrade the target installed 
    *                                                      package by `meo` program)
    *   
    *
    *
    * @param {string} remove // This option allows removing a package
    *                           Ex : meo remove am-okay
    *
    * @param {string} list // This option allows listing packages of the git repository
    *                         Ex : meo list
    *                         Note: To have the updated list, you have first of all to execute the command 
    *                               `meo self-update`
    *
    * @param {string} list-installed // This option allows listing the installed packages from the git repository
    *                                   Ex : meo list-installed
    *
    * @param {string} search // This option allows to search packages from the git repository
    *                           Ex : meo search am-okay
    *
    * @param {string} show // This option allows to have information on the installed packages from the `control` 
    *                         files
    *                         Ex : meo show am-okay
    *
    * @param {string} --help // This option allows getting help on the `meo` program
    *                           Ex : meo --help
    *
    * @param {string} --doc // This option allows getting a documentation on `meo` program
    *                          Ex : meo --doc
    *
    * @param {string} --version // This option allows getting the version installed of the `meo` program
    *                              Ex : meo --version
    *
    *
    * @ensure Successfully execution if the preconditions are satisfied. That is to say, with the 
    * above options and the appropriated sequences allowed for these options.
    *
    *
    *
    * @note This program depends of some programs, these programs are required in the global `meo`
    * package .
    *
    *
    *
    * @author <Baldé Amadou> <baldeuniversel@protonmail.com>
    *
    */

    '





set -uo pipefail # To exit the script if there is an error

# Declaration variables
listOfParams=("self-update" "self-remove" "install" "update" "upgrade" "remove" "list" "list-installed" \
    "search" "show" "--help" "--doc" "--version")

counterOption=0





### Check the input options -> start tag[p0]
#
if [[ $# -lt 1 ]]
then
    echo "~"
    echo -e "It has to be at least one parameter for the \e[32;1m$0\e[0m program \U001F9D0 "
    exit 1
fi
#
for optionUP in ${listOfParams[@]}
do
    if [[ $1 != $optionUP ]]
    then
        counterOption=$(( counterOption + 1 ))
    fi

    #
    if [[ $counterOption -eq 13  ]]
    then
        echo "~"
        echo -e "Unknown `tput setaf 3; tput bold`$1` tput sgr0 ` option \U001F9D0 "
        exit 1
    fi
done
#
if ( [[ $1 == "self-update" ]] || [[ $1 == "self-remove"  ]] || [[ $1 == "list" ]] || [[ $1 == "list-installed" ]] \
     || [[ $1 == "--doc" ]] || [[ $1 == "--help" ]] || [[ $1 == "--version" ]] ) && ( [[ $# -gt 1 ]] )
then
    echo "~"
    echo -e "There can only be one parameter when the \e[32;1m$1\e[0m option is invoked \U001F9D0 "
    exit 1
fi
#
if ( [[ $1 == "install" ]] || [[ $1 == "remove"  ]] || [[ $1 == "search"  ]] || [[ $1 == "show"  ]]  ) \
     && ( [[ $# -lt 2  ]] )
then
    echo "~"
    echo -e "There have to be at least two parameters when the \e[32;1m$1\e[0m option is invoked \U001F9D0 "
    exit 1
fi

### Check the input options -> end tag[p0]





### Creation some necessary directories or files -> start tag[c0]

# Declaration variables
getPersonalUserDir=$HOME
meoRootDir="/usr/lib/meo"
meoLibraryDir="$meoRootDir/library"
meoListInstalledPkgs="$meoLibraryDir/list-installed-packages"
meoListAvailablePkgs="$meoLibraryDir/list-available-packages"
meoTmp="/tmp/.meo"
fileCodeReturnCommand="$meoTmp/code-return-command"

### Creation some necessary directories or files -> end tag[c0]





:   '
/**
* @overview The `truncateFileData` allows to remove the data that contains a file
*
* @param {string} $1 // The file that has to be truncated
*
*/
    '
function truncateFileData
{
    # Remove the data contained in the target file
    truncate -s 0 $1 2> /dev/null
    echo "~"
}





:   '
/**
* @overview The `alertNonEffectiveAction` function allows to raise exceptions .
*
* @param {string} $1 // A file where the code of return of the `meo` program will be sent .
*/
    '
function alertNonEffectiveAction 
{
    # Declaration variables
    getPathOfFileForReturnLastCommand=$1
    getNumberOfLine=0

    if [[ $# -eq 1 ]] && [[ $getPathOfFileForReturnLastCommand != "none" ]]
    then
        if [[ -e "$getPathOfFileForReturnLastCommand" ]]
        then
            getNumberOfLine=` wc -l $getPathOfFileForReturnLastCommand | cut -d " " -f1 | tr -d "[[:space:]]" `

            #
            if [[ $getNumberOfLine -gt 0 ]]
            then
                echo "~"
                echo -en "Something wrong \U001F9D0, please make sure you have a permission to \nexecute the \e[32;1mmeo\e[0m program "

                # Call the function
                $(truncateFileData) $getPathOfFileForReturnLastCommand

                #
                setterm -cursor on
                exit 1 
            fi
        fi
    fi
}





:   '
/**
* @overview The function `colorElem` allows to color strings
*
* @param {string} $1 // The input string to color
*/
    '
function colorElem
{
    echo -e "\033[36m$1\033[0m"
}



### Creation files/dirs -> start tag[c1]

if [[ ! ( -e "$meoTmp" ) ]]
then
    mkdir -p "$meoTmp" 2> $fileCodeReturnCommand

    # Call the function
    alertNonEffectiveAction $fileCodeReturnCommand
fi
#
if [[ ! ( -e "$fileCodeReturnCommand" ) ]]
then
    #
    touch "$fileCodeReturnCommand" 2> $fileCodeReturnCommand

    # Call the function
    alertNonEffectiveAction $fileCodeReturnCommand
fi

### Creation files/dirs -> end tag[c1]





### Print some files linked to the options `--doc`, `--help` , `--version` --> start tag[io]

if [[ $1 == "--doc" ]] && [[ $# -eq 1 ]]
then
    cat /usr/lib/meo/documentation/meo-doc
    exit 0
elif [[ $1 == "--help" ]] && [[ $# -eq 1 ]]
then
    cat /usr/lib/meo/documentation/meo-help
    exit 0
elif [[ $1 == "--version" ]] && [[ $# -eq 1 ]]
then
    cat /usr/lib/meo/documentation/meo-version
    exit 0
fi

#
echo "~"
echo -e "Invalid request \U001F9D0 ."
exit 1

### Print some files linked to the options `--doc`, `--help` , `--version` --> end tag[io]

