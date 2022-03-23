$Date = Get-Date -DisplayHint Date -Format MM/dd/yyyy
$Time = Get-Date -DisplayHint Time -Format HH:mm:ss

while($true)
{
$DesktopPath = [Environment]::GetFolderPath("Desktop")
$fileLog = "$DesktopPath\Task.log"
if(-not(Test-path $fileLog -PathType leaf))
 {
    New-Item $fileLog
 }

$process = get-process
foreach ($pro in $process){
    $name = $pro.ProcessName
    $CpuCores = (Get-WmiObject -Class Win32_Processor).NumberOfCores
    $CpuValue = ((Get-Counter "\process($name)\% Processor Time" -ComputerName $env:computername).CounterSamples.CookedValue)/$CpuCores
    $percent = [Decimal]::Round($CpuValue, 3)
        if($percent -ge 15){
        $outPut = $Date + " " + $Time + " " + $name + " CPU: " + $percent + "%"
        $wshell = New-Object -ComObject Wscript.Shell
        Add-Content -Path $DesktopPath\Task.log $outPut
        $wshell.Popup($outPut)
    }
}
sleep 2
}