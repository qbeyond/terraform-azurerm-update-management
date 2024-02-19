<#
.SYNOPSIS
    Creates new Update deployment schedules based on vm tags.
.DESCRIPTION
    Creates new Update deployment schedules based on vm tags.
    The script runs as an automation runbook twice a day
.PARAMETER automationAccountName
    The name of the automation account in the management subscription that is responsible for update management.
.PARAMETER automationResourceGroupName
    The name of the resource group that contains the automation account.
.PARAMETER managementSubscriptionId
    The id of the management subscription.
.PARAMETER managementGroupId
    The Id of the managementGroup
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$automationAccountName,
    [Parameter(Mandatory = $true)]
    [string]$automationResourceGroupName,
    [Parameter(Mandatory = $true)]
    [string]$managementSubscriptionId,
    [Parameter(Mandatory = $true)]
    [string]$managementGroupId
)

$ErrorActionPreference = "Stop"

$updateOptions = @{
    "X" = "Unclassified"
    "C" = "Critical"
    "S" = "Security"
    "U" = "UpdateRollup"
    "F" = "FeaturePack"
    "E" = "ServicePack"
    "D" = "Definition"
    "T" = "Tools"
    "G" = "Updates"
}
$rebootOptions = @{
    reboot       = "IfRequired"
    alwaysreboot = "Always"
    neverreboot  = "Never"
    onlyreboot   = "RebootOnly"
}  

$resourceGraphQuery = @'
resources
|  where  ['tags'] contains "Severity Group Monthly" and tags['Update allowed'] == 'yes'
|  where  ['type'] == "microsoft.compute/virtualmachines"
|  project group=tostring(['tags'].["Severity Group Monthly"])
|  distinct group
'@

$resourceGraphQuerySubscriptions = @'
resourcecontainers
| where type == "microsoft.resources/subscriptions"
| where properties.state == "Enabled"
| project subscriptionId=strcat("/subscriptions/",subscriptionId)
'@

Connect-AzAccount -Identity

Write-Output "Starting to query Microsoft Resource Graph for subscriptions..."
$subscriptions = @()
try {
    do {
        $previousResult = Search-AzGraph -Query $resourceGraphQuerySubscriptions -ManagementGroup $managementGroupId -SkipToken $previousResult.SkipToken
        $subscriptions += $previousResult.subscriptionId
    } until (-not $previousResult.SkipToken)
    Write-Output "Finished to query Microsoft Resource Graph..."
}
catch {
    Write-Error "The script execution failed with Error `n`t $($($_.Exception).Message)"
}

Write-Output "Starting to query Microsoft Resource Graph for tags..."
$severityGroups = @()
try {
    do {
        $previousResult = Search-AzGraph -Query $resourceGraphQuery -ManagementGroup $managementGroupId -SkipToken $previousResult.SkipToken
        $severityGroups += $previousResult.group
    } until (-not $previousResult.SkipToken)
    Write-Output "Finished to query Microsoft Resource Graph..."
}
catch {
    Write-Error "The script execution failed with Error `n`t $($($_.Exception).Message)"
}

Write-Output "Following severity group tags were found $severityGroups"

Set-AzContext -Subscription $managementSubscriptionId 

Write-Output "Starting creating/ updating severity groups."
$syntaxRegex = '^(0[1-9]|[1-9][0-9])-(first|second|third|fourth|last)-(monday|tuesday|wednesday|thursday|friday|saturday|sunday)-([01]\d|2[0-3])([0-5]\d)-([XCSUFEDTG]+)-(reboot|neverreboot|alwaysreboot|onlyreboot)$'
$errorCounter = 0
foreach ($severityGroup in $severityGroups) {
    $splitSeverityGroup = $severityGroup -split "-"

    if ($splitSeverityGroup[0].Length -eq 4) {
        Write-Warning "$($severityGroup) is an emergency patch group. Create update configuration manually with the tag Severity Group Emergency."
        continue
    }

    if ($severityGroup -notmatch $syntaxRegex) {
        Write-Warning "$($severityGroup) does not match the syntax. Please review the concept and correct the tag."
        continue 
    }

    $dayInterval = [int]$splitSeverityGroup[0]
    $weekdayRepetition = $splitSeverityGroup[1]
    $weekday = $splitSeverityGroup[2]
    $startTime = (get-date ($splitSeverityGroup[3].Substring(0, 2) + ":" + $splitSeverityGroup[3].Substring(2, 2))).AddDays(1)
    $rebootSetting = $rebootOptions[$splitSeverityGroup[5]]
    $queryTags = @{
        "Severity Group Monthly" = "$($severityGroup)"
        "Update allowed"         = "yes"
    }
    $updateClassification = $splitSeverityGroup[4].ToCharArray() | ForEach-Object {
        $updateOptions["$_"]
    }
    $duration = New-TimeSpan -Hours 4
    try {
        $schedule = New-AzAutomationSchedule `
            -AutomationAccountName $automationAccountName `
            -ResourceGroupName $automationResourceGroupName `
            -Name $severityGroup `
            -MonthInterval $dayInterval `
            -DayOfWeek $weekday `
            -DayOfWeekOccurrence $weekdayRepetition `
            -Description "Schedule for update deployment group $($severityGroup)" `
            -ForUpdateConfiguration `
            -StartTime $startTime `
            -TimeZone "W. Europe Standard Time" `
    
    }
    catch {
        Write-Error -Exception ($_.Exception) -Message "Could not create schedule for $severityGroup." -ErrorAction Continue 
        $errorCounter +=1
        continue
    }

    try {
        $azureQuery = New-AzAutomationUpdateManagementAzureQuery `
            -ResourceGroupName $automationResourceGroupName `
            -AutomationAccountName $automationAccountName  `
            -Scope $subscriptions `
            -Tag $queryTags `
    
    }
    catch {
        Write-Error -Exception ($_.Exception) -Message "Could not create azure for $severityGroup." -ErrorAction Continue 
        $errorCounter +=1
        continue
    }

    try {
        New-AzAutomationSoftwareUpdateConfiguration `
            -AutomationAccountName $automationAccountName `
            -ResourceGroupName $automationResourceGroupName `
            -Schedule $schedule `
            -Windows `
            -IncludedUpdateClassification $updateClassification `
            -AzureQuery $azureQuery `
            -Duration $duration `
            -RebootSetting $rebootSetting `
   
    }
    catch {
        Write-Error -Exception ($_.Exception) -Message "Could not create Update configuration for $severityGroup" -ErrorAction Continue
        $errorCounter +=1
        continue
    }

    Write-Output "Created $severityGroup successfully."
}
if ($errorCounter -gt 0) {
    Write-Error -Message "There was an error inside the loop. Please check error messages in detailed job logs."
} 