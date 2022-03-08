$UserNames = Get-ADUser -Filter * -SearchBase "OU=NAME_OF_OU_WITH_USERS3,OU=NAME_OF_OU_WITH_USERS2,OU=NAME_OF_OU_WITH_USERS1,DC=DOMAIN_NAME,DC=COUNTRY_CODE" | 
Select -ExpandProperty samaccountname

$UserRegex = ($UserNames | ForEach{[RegEx]::Escape($_)}) -join "|"

$myArray = (Get-ChildItem -Path "\\file2\Felles\Home\*" -Directory | Where{$_.Name -notmatch $UserRegex})

#$myArray

foreach ($mapper in $myArray) {
    #Param ($mapper = $(Throw "no folder name specified"))

    # calculate folder size and recurse as needed
    $size = 0
    Foreach ($file in $(ls $mapper -recurse)){
    If (-not ($file.psiscontainer)) {
        $size += $file.length
        }
    }

    # return the value and go back to caller
    echo $size
}
