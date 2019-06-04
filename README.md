# Created by Harley Schaeffer. Please email Harley.Schaeffer@assaabloy.com if you have any issues.

TScheduler is a powershell script that creates a task within Task Scheduler to reboot a computer for a time you specify. Multiple computers may be put into the comps.txt file to setup tasks for each computer.

How to use TScheduler.ps1

1. Fill comps.txt with the computers you would like to schedule a daily reboot for.

2. Run TScheduler.ps1 with powershell

  a. Enter credentials that provide admin access to the remote machines.

  b. Enter a time for them to reboot daily eg. 22:00 or 10:00pm

  c. confirm the time is correct.


How to use DeleteTasks.ps1

1. Fill comps.txt with the computers you would like to remove the scheduled daily reboot for.

2. Run DeleteTasks.ps1 with powershell
  a. Enter credentials that provide admin access to the remote machines.
  
  
