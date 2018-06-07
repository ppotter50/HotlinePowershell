<#

.SYNOPSIS
	This is a script used to determine if a computer has access to the Adobe CC Suite

.DESCRIPTION
	This script will either tell you whether or not a computer has access to the Adobe CC Suite or it will generate a list of computers that do have access to the Adobe CC Suite based on a search.

	This script acheives this by pulling all active directory computers with the identity "CAEN CLSE 2017 ADOBE CC" and sorts them based on a string input

	If a hostname is entered the script will look for an exact match and give a true or false response as to whether the computer has access to Adobe CC
	If a search is entered the script will display a list of all of the hostnames matching that search

.SYNTAX
	hasAdobe [-Hostname] <string>

	hasAdobe -Search [<string>]

.PARAMETERS
	-Hostname <string>
		Enter the hostname you would like to check for Adobe CC access

	-Search <string>
		Searches for hostnames that contain the entered string
		If no string is entered all hosts with Adobe CC access will be listed

.EXAMPLE
	#Test if hostname CAEN-HOTLINEP05 has Adobe CC access
	hasAdobe -Hostname "CAEN-HOTLINEP05"

.EXAMPLE
	#Get all computers with Adobe CC access whose uniquename contains "dc"
	hasAdobe -Search "DC"

.NOTES
	Future development: get hostname parameter to take multiple inputs and input from a file
	
#>

function hasAdobe {

	#define parameters
	[CmdletBinding(DefaultParameterName='Hostname')]
	param (
		[Parameter(Mandatory,ParameterSetName='Hostname')]
		[string]$Hostname,

		[Parameter(Mandatory,ParameterSetName='Search')]
		[string]$Search
	)

	#Determine which parameter is defined
	if (-not $Hostname -eq "") {

		#test if there is a computer with this hostname with access to Adobe CC
		$result = Get-ADGroupMember -Identity "CAEN CLSE 2017 ADOBE CC" | Where-Object{$_.name -eq $Hostname} | Select-Object -property "name"
		if (-not $result -eq ""){
			Write-Host "This machine has access to Adobe CC."
		}
		else {Write-Host "This machine does not have access to Adobe CC"}
	}

	elseif (-not $Search -eq "") {
		#Surround search in wildcards
		$Search=$Search.PadRight($search.length + 1,'*')
		$Search=$Search.PadLeft($search.length + 1,'*')

		#generate list of computers matching that wildcard search with access to Adobe CC
		$result = Get-ADGroupMember -Identity "CAEN CLSE 2017 ADOBE CC" | Where-Object{$_.name -like $Search} | Select-Object -property "name" | Sort-Object -Property "name"
	
		#output result
		if ($Search -eq "**") {
			Write-Host "Here is a list of all hostnames with access to Adobe CC"
			echo $result
		}
		elseif (-not $result -eq ""){
			Write-Host "Here is a list of hostnames matching your search with access to Adobe CC"
			echo $result
		}
		elseif ($result -eq "") {
			Write-Host "Your wildcard matched no hostnames with access to Adobe CC."
		}
	}
}
