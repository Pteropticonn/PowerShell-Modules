using namespace System.Web
using namespace System.API


$queryString = [System.Web.HttpUtility]::ParseQueryString('')
$queryString.Add('q', 'Get-Content language:powershell repo:powershell/powershell')
Invoke-RestMethod ('https://api.github.com/search/code?{0}' -f $queryString)