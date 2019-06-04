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

$cTime = Read-Host "Please enter a time for the computers in comps.txt to restart: (eg. 21:30 or 9:30pm)"
$sureTime = Read-Host "Are you sure you want to schedule reboots for" $cTime "?(type 'yes' to proceed)"
if($sureTime -ne "yes"){
    Write-Host "exiting..."
    Read-Host "Press enter to exit"
    exit
}


[string[]]$compsList = Get-Content -Path $compsLocation

foreach ($singleComp in $compsList){
    
    Write-Host "****Creating scheduled task on $singleComp for $cTime...****"

    Invoke-Command -ComputerName $singleComp -credential $Creds -ArgumentList $cTime -Scriptblock {
    $cTime = $args[0]
    $TaskName = "NightlyReboot"
    $TaskDescription = "Reboot Nightly"
    $TaskCommand = "shutdown"
    $TaskArg = "/r /f /t 0"
    $TaskStartTime = [datetime]$cTime
    $service = new-object -ComObject("Schedule.Service")
    $service.Connect()
    $rootFolder = $service.GetFolder("\")
    $TaskDefinition = $service.NewTask(0)
    $TaskDefinition.RegistrationInfo.Description = "$TaskDescription"
    $TaskDefinition.Settings.Enabled = $true
    $TaskDefinition.Settings.AllowDemandStart = $true
    $triggers = $TaskDefinition.Triggers

    
    $trigger = $triggers.Create(2)
    $trigger.StartBoundary = $TaskStartTime.ToString("yyyy-MM-dd'T'HH:mm:ss")
    $trigger.Enabled = $true

    
    $Action = $TaskDefinition.Actions.Create(0)
    $action.Path = "$TaskCommand"
    $action.Arguments = "$TaskArg"
            
    $rootFolder.RegisterTaskDefinition("$TaskName",$TaskDefinition,6,"System",$null,5)

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