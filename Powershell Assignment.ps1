<#
    Get-CommonTimeZone function is used to get the information about the different Timezones with offset between 12 and -12
#>
function Get-CommonTimeZone()
{
    param(
        [String]$Name,
        [float]$Offset
    )
    begin
    {
        $jsonPath = 'https://raw.githubusercontent.com/dmfilipenko/timezones.json/master/timezones.json'
    }
    process
    {
        $timeZoneDetails = (New-Object System.Net.WebClient).DownloadString($jsonPath) | ConvertFrom-Json 
        if($Name -ne "" -and $Offset -eq "")  #When Name is passed in the function call
        {
            if(($timeZoneDetails|Select-String -Pattern $Name).Count -ne 0) #Condition to check if the Name exists or not
            {  
                for($i=0; $i -le $timeZoneDetails.count; $i++)
                {               
                    if($timeZoneDetails[$i].utc -match $Name)
                    {                
                        $timeZoneDetails[$i] 
                    }
               
                }
            }
            else
            {
                Write-Host "The specified Name does not exist"
            }
        }
        elseif($Offset -ne "" -and $Name -eq "") #when Offset is passed in the function call
        {
            
            if($Offset -le 12 -and $Offset -ge -12) #validating the offset to be equal to or in between 12 and -12
            {
                if(($timeZoneDetails|Select-String -Pattern $Offset).Count -ne 0) #Condition to check if the offset exists or not
                {
                    for($j=0; $j -le $timeZoneDetails.count; $j++)
                    {
                        if($timeZoneDetails[$j].offset -eq $Offset)
                        {
                            $timeZoneDetails[$j]
                        }
                    
                    }
                }
                else
                {
                    Write-Host "The specified Offset does not exist"
                }
               
            }
            else
            {
                write-Host "Please provide a valid Offset number (i.e. -12 to 12)"
            }
        }
        elseif($Name -ne "" -and $Offset -ne "") #When both Name and Offset are passed in the function call
        {
            Write-host "Cannot pass Name and Offset value together while calling the function"
        }
        else
        {
            $timeZoneDetails
        }
        
    }

}


#Test Conditions


Get-CommonTimeZone |Format-Table
Get-CommonTimeZone -Offset 5.5|Format-Table
Get-CommonTimeZone -Name "Pacific" |Format-Table
Get-CommonTimeZone -Offset 2|Format-Table
Get-CommonTimeZone -Name "Asia" -Offset -5  |Format-Table
Get-CommonTimeZone -Offset -5.5|Format-Table
Get-CommonTimeZone -Name "Bangalore" |Format-Table
Get-CommonTimeZone -Offset -15|Format-Table
Get-CommonTimeZone -Offset 23|Format-Table