# Using Azure AI Document Intelligence and Azure OpenAI GPT-3.5 Turbo to extract structured data from documents

This sample demonstrates [how to use the new Markdown content extraction feature of Azure AI Document Intelligence's pre-built Layout model](https://techcommunity.microsoft.com/t5/ai-azure-ai-services-blog/document-intelligence-preview-adds-more-prebuilts-support-for/ba-p/4084608) to convert documents, such as invoices, into Markdown, then use GPT-3.5 Turbo to extract structured JSON data using the [Azure OpenAI Service](https://learn.microsoft.com/en-us/azure/ai-services/openai/overview).

This approach is ideal for scenarios where you need to extract structured data from PDFs, Office file types like Word, PowerPoint, and Excel, HTML, and images by taking advantage of the pre-built Layout model in Azure AI Document Intelligence, combined with the powerful capabilities to extract relevant information using OpenAI's GPT-3.5 Turbo model without the need to train a custom extraction model. This approach provides the following advantages:

- **No requirement to train a custom model**: Combining the pre-built Layout model in Azure AI Document Intelligence with OpenAI's GPT-3.5 Turbo model allows you to extract structured data without the need to train a custom model for your specific document types using only tailored prompts. This can save time and resources, especially for organizations that need to process a wide variety of document types.
- **Freedom to define a schema**: You can define the schema of the structured data you want to extract using OpenAI's GPT-3.5 Turbo model. This allows you to extract only the information you need from the document, making it easier to integrate the extracted data into downstream systems. Additionally, the power of GPT models enables you to extract data that matches or closely matches the schema you define, even if the document layout varies.
- **Ability to understand tabular data**: Azure AI Document Intelligence's Layout model is capable of understanding tabular data in documents, making it easier to convert to Markdown, which is more easily processed by OpenAI's GPT-3.5 Turbo model. This allows you to extract structured data from tables in documents without the need for complex table extraction logic.
- **Support for multiple document types**: This approach supports a wide variety of document types, including PDFs, Office file types like Word, PowerPoint, and Excel, HTML, and images. This flexibility allows you to extract structured data from different sources without the need for custom processing logic for each document type.

> [!IMPORTANT]
> The Markdown content extraction and Office file type support features of the Azure AI Document Intelligence pre-built Layout model are currently in preview. For more information, see the [Azure AI Document Intelligence documentation](https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/whats-new?view=doc-intel-4.0.0&tabs=csharp).

## Components

- [**Azure AI Document Intelligence**](https://learn.microsoft.com/en-us/azure/ai-services/document-intelligence/overview), a managed service that provides pre-built models for document processing tasks, such as document classification and data extraction.
- [**Azure OpenAI Service**](https://learn.microsoft.com/en-us/azure/ai-services/openai/overview), a managed service for OpenAI GPT models that exposes a REST API.
- [**GPT-3.5 Turbo 16K model deployment**](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/models#gpt-35)
  - **Note**: Any GPT-3.5 Turbo model can be used with this sample. To provide a single region deployment for both the Azure AI Document Intelligence and Azure OpenAI Service, the GPT-3.5 Turbo 16K model is used in this sample in the East US region. For more information on the available GPT models, see the [Azure OpenAI Service documentation](https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/models#gpt-35).
- [**Azure Bicep**](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/overview?tabs=bicep), used to create a repeatable infrastructure deployment for the Azure resources.

## Getting Started

> [!NOTE]
> This sample comes prepared with a [Invoice_1.pdf](./Invoice_1.pdf) file that you can use to test. You can also use your own document files to test.

To deploy the infrastructure and test PDF data extraction, you need to:

### Prerequisites

- Install the latest [**.NET SDK**](https://dotnet.microsoft.com/download).
- Install [**PowerShell Core**](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell?view=powershell-7.1).
- Install the [**Azure CLI**](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli).
- Install [**Visual Studio Code**](https://code.visualstudio.com/) with the [**Polyglot Notebooks extension**](https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.dotnet-interactive-vscode).

### Run the sample notebook

The [**Sample.ipynb**](./Sample.ipynb) notebook contains all the necessary steps to deploy the infrastructure using Azure Bicep, and make requests to the deployed Azure AI Document Intelligence and Azure OpenAI APIs to test with the provided PDF file.

> [!NOTE]
> The sample uses the [**Azure CLI**](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) to deploy the infrastructure from the [**main.bicep**](./infra/main.bicep) file, and C# code to test the deployed services using Microsoft SDKs for Azure AI Document Intelligence and Azure OpenAI.

The notebook is split into multiple parts including:

1. Login to Azure and set the default subscription.
1. Deploy the Azure resources using Azure Bicep.
1. Analyze the PDF file with the deployed Azure AI Document Intelligence API to convert the document to Markdown.
1. Making requests to the deployed Azure OpenAI API to test the GPT-3.5 model with the analyzed Markdown content to return structured JSON data.

Each steps is documented in the notebook with additional information and links to the relevant documentation.

### Clean up resources

After you have finished testing, you can clean up the resources using the following steps:

1. Run the `az group delete` command to delete the resource group and all the resources within it.

```bash
az group delete --name <resource-group-name> --yes --no-wait
```

The `<resource-group-name>` is the name of the resource group that can be found as the **AZURE_RESOURCE_GROUP_NAME** environment variable in the [**config.env**](./config.env) file.

## Additional Resources

- [Using Azure OpenAI GPT-4 Vision to extract structured JSON data from PDF documents](https://github.com/Azure-Samples/azure-openai-gpt-4-vision-pdf-extraction-sample)
  - This sample provides a simplified approach to this same scenario using only Azure OpenAI GPT-4 Vision to extract structured JSON data from PDF documents directly. This specific model supports analyzing images of documents, such as PDFs, but has limitations that this sample overcomes by using Azure AI Document Intelligence to convert the document to Markdown first.
  - **Note:** GPT-4 Vision has the capability to analyze the content of images, marks, and signatures in documents, which is not possible with the Azure AI Document Intelligence pre-built Layout model when converting to Markdown.
