#Written by Harley Schaeffer if you have any issues please contact Harley.Schaeffer@assaabloy.com
$compsLocation = "$PSScriptRoot\comps.txt"

$Creds = Get-Credential -Message "Please enter admin credentails"
    
if(!(Test-Path $compsLocation -PathType Leaf)){ #returns true or false if false proceeds
    Write-Host "Cannot find comps.txt in location $scriptRoot. Please create a file named comps.txt and put each computer on a its own line." -fore Red
    if ($gRemote -eq "TRUE"){exit}else{
    read-host "press any key to continue"
    }
    exit
}

[string[]]$compsList = Get-Content -Path $compsLocation

foreach ($singleComp in $compsList){
    
    Write-Host "****Deleting scheduled task on $singleComp...****"

    Invoke-Command -ComputerName $singleComp -credential $Creds -Scriptblock {
    $TaskName = "NightlyReboot"
        
    $service = new-object -ComObject("Schedule.Service")
    $service.Connect()
    $rootFolder = $service.GetFolder("\")
    
    $rootFolder.DeleteTask("NightlyReboot",0)

    }
   
    
    

       
}



<# Only Works on Win 10

Invoke-Command -ComputerName $singleComp -credential $Creds -ArgumentList $cTime -Scriptblock {

        $cTime = $args[0]

        $action = New-ScheduledTaskAction -Execute 'shutdown' -Argument '/r /f /t 0'
        $trigger = New-ScheduledTaskTrigger -Daily -At $cTime
        $principal = New-ScheduledTaskPrincipal -GroupId ".\users" -RunLevel Highest

        Register-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -TaskName "NightlyRestart" -Description "Test"
    }

#>