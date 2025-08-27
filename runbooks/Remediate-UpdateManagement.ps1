#Requires -Modules Az.Accounts, Az.PolicyInsights

<#
.SYNOPSIS
    Starts update management policy remediations based on policy assignments and references.
.DESCRIPTION
    Starts update management policy remediations based on policy assignments and references.
.PARAMETER managementGroupId
    The Id of the management group where the update management policies are assigned.
.PARAMETER policyAssignmentId
    The Id of the policy assignment that governs the update management policy.
.PARAMETER policyReferenceIdLinux
    The Id of the policy reference specifically for Linux update management.
.PARAMETER PolicyReferenceIdWindows
    The Id of the policy reference specifically for Windows update management.
#>

param (
    [Parameter(Mandatory = $true)]
    [string]$managementGroupId,
    [Parameter(Mandatory = $true)]
    [string]$policyAssignmentId,
    [Parameter(Mandatory = $true)]
    [string]$policyReferenceIdLinux,
    [Parameter(Mandatory = $true)]
    [string]$policyReferenceIdWindows
)

$ErrorActionPreference = "Stop"

try {
    Connect-AzAccount -Identity | Out-Null
}
catch {
    throw "The script execution failed with Error `n`t $($($_.Exception).Message)"
}

Write-Output "Start remediation job for Linux Update Management Policy....."
try {
    Start-AzPolicyRemediation -ManagementGroupName $managementGroupId -PolicyDefinitionReferenceId  $policyReferenceIdLinux -PolicyAssignmentId $policyAssignmentId -Name "LinuxRemediation" 
    Write-Output "Started remediation job for Linux Update Management Policy successfully"
}
catch {
    throw "The script execution failed with Error `n`t $($($_.Exception).Message)"
}

Write-Output "Start remediation job for Windows Update Management Policy....."
try {
    Start-AzPolicyRemediation -ManagementGroupName $managementGroupId -PolicyDefinitionReferenceId  $policyReferenceIdWindows -PolicyAssignmentId $policyAssignmentId -Name "WindowsRemediation"
    Write-Output "Started remediation job for Windows Update Management Policy successfully"
}
catch {
    throw "The script execution failed with Error `n`t $($($_.Exception).Message)"
}