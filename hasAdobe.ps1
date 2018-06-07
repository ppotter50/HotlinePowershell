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
}
