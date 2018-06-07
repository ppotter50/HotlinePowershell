<#

.SYNOPSIS
This is a script used to determine if a computer has access to the Adobe CC Suite

.DESCRIPTION
This script will either tell you wheter or not a computer has access to the Adobe CC Suite or it will generate a list of computers that do have access to the Adobe CC Suite based on a wildcard search.

This script acheives this by pulling all active directory computers with the identity "CAEN CLSE 2017 ADOBE CC" and sorts them based on a string input

If a hostname is entered the script will look for an exact match and give a true or false response as to whether the computer has access to Adobe CC
If a hostname is not provided, and instead a wildcard search is entered the script will display a list of all of the hostnames matching that search

.NOTES
Currently this function is being updated to be parameterized to make it a single line command without the interactive text interface.
	
#>

function hasAdobe {
	#Ask if user has hostname
	$hasHost = Read-Host -Prompt "Do you have a hostname? (Y/N)"
	if ($hasHost -eq "y") {
		#get hostname
		$hostnm = Read-Host -Prompt "Enter the hostname"
	
		#test if there is a computer with this hostname with access to Adobe CC
		$result = Get-ADGroupMember -Identity "CAEN CLSE 2017 ADOBE CC" | Where-Object{$_.name -eq $hostnm} | Select-Object -property "name"
		if (-not $result -eq ""){
			Write-Host "This machine has access to Adobe CC."
		}
		else {Write-Host "This machine does not have access to Adobe CC"}
	}

	elseif ($hasHost -eq "n") {
		#get search with wildcard
		$hostApprx = Read-Host -Prompt "Enter a string with a wildcard to guide search (to get all hostname enter only a wildcard)"
	
		#generate list of computers matching that wildcard search with access to Adobe CC
		$result = Get-ADGroupMember -Identity "CAEN CLSE 2017 ADOBE CC" | Where-Object{$_.name -like $hostApprx} | Select-Object -property "name"
	
		#output result
		if ($hostApprx -eq "*") {
			Write-Host "Here is a list of all hostnames with access to Adobe CC"
			echo $result
		}
		elseif (-not $result -eq ""){
			Write-Host "Here is a list of hostnames matching your search with access to Adobe CC"
			echo $result
		}
		elseif ($result -eq $null) {
			Write-Host "Your wildcard matched no hostnames with access to Adobe CC."
		}
	
	else {Write-Host "Please enter just ""y"" or""n"""}
}
