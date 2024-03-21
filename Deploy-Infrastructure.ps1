<#
.SYNOPSIS
    Deploy the core infrastructure for the Document Intelligence Markdown to OpenAI Data Extraction Sample to an Azure subscription.
.DESCRIPTION
    This script initiates the deployment of the main.bicep template to the current default Azure subscription,
    determined by the Azure CLI. The deployment name and location are required parameters.
.PARAMETER DeploymentName
    The name of the deployment to create in an Azure subscription.
.PARAMETER Location
    The location to deploy the Azure resources to.
.EXAMPLE
    .\Deploy-Infrastructure.ps1 -DeploymentName 'my-deployment' -Location 'westeurope'
.NOTES
    Author: James Croft
    Date: 2024-03-21
#>

param
(
    [Parameter(Mandatory = $true)]
    [string]$DeploymentName,
    [Parameter(Mandatory = $true)]
    [string]$Location
)

Write-Host "Deploying infrastructure..."

Set-Location -Path $PSScriptRoot

az --version

$deploymentOutputs = (az deployment sub create --name $DeploymentName --location $Location --template-file './infra/main.bicep' --parameters './infra/main.parameters.json' --parameters workloadName=$DeploymentName --parameters location=$Location --query 'properties.outputs' -o json) | ConvertFrom-Json
$deploymentOutputs | ConvertTo-Json | Out-File -FilePath './InfrastructureOutputs.json' -Encoding utf8

$resourceGroupName = $deploymentOutputs.resourceGroupInfo.value.name
$documentIntelligenceName = $deploymentOutputs.documentIntelligenceInfo.value.name
$documentIntelligenceEndpoint = $deploymentOutputs.documentIntelligenceInfo.value.endpoint
$documentIntelligencePrimaryKey = (az cognitiveservices account keys list --name $documentIntelligenceName --resource-group $resourceGroupName --query 'key1' -o tsv)
$openAIName = $deploymentOutputs.openAIInfo.value.name
$openAIEndpoint = $deploymentOutputs.openAIInfo.value.endpoint
$openAIModelDeploymentName = $deploymentOutputs.openAIInfo.value.modelDeploymentName
$openAIKey = (az cognitiveservices account keys list --name $openAIName --resource-group $resourceGroupName --query key1 -o tsv)

# Save the deployment outputs to a .env file
Write-Host "Saving the deployment outputs to a config.env file..."

function Set-ConfigurationFileVariable($configurationFile, $variableName, $variableValue) {
    if (Select-String -Path $configurationFile -Pattern $variableName) {
        (Get-Content $configurationFile) | Foreach-Object {
            $_ -replace "$variableName = .*", "$variableName = $variableValue"
        } | Set-Content $configurationFile
    }
    else {
        Add-Content -Path $configurationFile -value "$variableName = $variableValue"
    }
}

$configurationFile = "config.env"

if (-not (Test-Path $configurationFile)) {
    New-Item -Path $configurationFile -ItemType "file" -Value ""
}

Set-ConfigurationFileVariable $configurationFile "AZURE_RESOURCE_GROUP_NAME" $resourceGroupName
Set-ConfigurationFileVariable $configurationFile "AZURE_DOCUMENT_INTELLIGENCE_ENDPOINT" $documentIntelligenceEndpoint
Set-ConfigurationFileVariable $configurationFile "AZURE_DOCUMENT_INTELLIGENCE_KEY" $documentIntelligencePrimaryKey
Set-ConfigurationFileVariable $configurationFile "AZURE_OPENAI_ENDPOINT" $openAIEndpoint
Set-ConfigurationFileVariable $configurationFile "AZURE_OPENAI_API_KEY" $openAIKey
Set-ConfigurationFileVariable $configurationFile "AZURE_OPENAI_MODEL_DEPLOYMENT_NAME" $openAIModelDeploymentName

return $deploymentOutputs