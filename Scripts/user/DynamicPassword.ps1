Clear-Host
Set-Location C:\Users\Joffton\Documents\Programming\PowerShell\Training\CLI

$PasswordLength = 50

$UpperCaseLetters = (65..90)
$LowerCaseLetters = (97..122)
$NumbersZeroThroughNine = (48..57)
$SpecialCharacters = (33..47)
$MoreSpecialCharacters = (58..64)
$CurlyBrackets = (123..126)

$a = -join ($UpperCaseLetters + $LowerCaseLetters + $NumbersZeroThroughNine + 
$SpecialCharacters + $MoreSpecialCharacters + $CurlyBrackets  |
Get-Random -Count $PasswordLength | % {[char]$_})
$a
$a | clip
