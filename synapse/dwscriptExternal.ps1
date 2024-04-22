param(
    [Parameter(Mandatory=$True)]
    [string]$appshortcodename,
    [Parameter(Mandatory=$True)]
    [string]$spnclientid,
    [Parameter(Mandatory=$True)]
    [string]$spnclientsecret,
    [Parameter(Mandatory=$True)]
    [string]$datalakename,
    [Parameter(Mandatory=$True)]
    [string]$datalakecontainername,
    # Parameter help description
    [Parameter(Mandatory=$True)]
    [validateset('JSON','PARQUET','ORC','DELIMITEDTEXT')]
    [string]
    $fileformat
   
)
$datalakename = $datalakename.ToLower()


[string]$script1_Ext_CreateSPN = "
GO
CREATE DATABASE SCOPED CREDENTIAL [$($appshortcodename)_ServicePrincipal] 
WITH 
    IDENTITY = N'$($spnclientid)@https://login.microsoftonline.com/8e41bacc-baba-48d6-9fcb-708bd1208e38/oauth2/token', 
    SECRET ='$($spnclientsecret)'
GO
"
Write-Host $script1_Ext_CreateSPN

Write-Host ############

[string]$script2_create_extDatasource ="

GO
CREATE EXTERNAL DATA SOURCE [ADLS_$($datalakecontainername)] 
WITH (
    TYPE = HADOOP, 
    LOCATION = N'abfss://$($datalakecontainername)@$($datalakename).dfs.core.windows.net/', 
    CREDENTIAL = [$($appshortcodename)_ServicePrincipal])
GO
"
Write-Host $script2_create_extDatasource

Write-Host ############

switch ($fileformat) {
    "JSON" { 
            
            $script3_createFileformat = "
            GO
            CREATE EXTERNAL FILE FORMAT [$($appshortcodename)_JSON]
            WITH (
                FORMAT_TYPE = JSON,
                
                DATA_COMPRESSION = 'org.apache.hadoop.io.compress.GzipCodec'
            );
            GO
            "
     }
    "PARQUET" { 
        $script3_createFileformat = "

            GO
            CREATE EXTERNAL FILE FORMAT [$($appshortcodename)_PARQUET]
            WITH (
                FORMAT_TYPE = PARQUET,
                
                DATA_COMPRESSION = 'org.apache.hadoop.io.compress.GzipCodec'
            );
            GO
            "
     }
    "ORC" {  
        $script3_createFileformat = "
        GO
        CREATE EXTERNAL FILE FORMAT [$($appshortcodename)_ORC]
        WITH (
            FORMAT_TYPE = ORC,
    
            DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
        );
        GO
        "
    }
    "DELIMITEDTEXT" {  
        $script3_createFileformat = "
        GO
        CREATE EXTERNAL FILE FORMAT [$($appshortcodename)_DELIMITEDTEXT]
        WITH (
            FORMAT_TYPE = DELIMITEDTEXT,
            FORMAT_OPTIONS(FIELD_TERMINATOR = ',', STRING_DELIMITER = '0x22', FIRST_ROW = 2, USE_TYPE_DEFAULT = True, ENCODING = 'UTF8', DATE_FORMAT = 'yyyy-MM-dd'),
            DATA_COMPRESSION = 'org.apache.hadoop.io.compress.GzipCodec'
        );
        GO
        "
    }
    Default {}
}


Write-Host $script3_createFileformat
Write-Host ############


## Generating SQL files
 $script1_Ext_CreateSPN >> "syndw_4CreateSPN_ext.sql"

$script2_create_extDatasource >> "syndw_5CreateDLDatasource_ext.sql"

 $script3_createFileformat >> "syndw_6CreateFileformat_ext.sql"
