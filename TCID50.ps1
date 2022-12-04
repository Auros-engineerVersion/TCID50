using namespace System

function MatrixReverse($matrix){
    for($i = 0; $i -lt $matrix.length; $i++) {
        for ($j = 0; $j -lt $matrix[0].length; $j++) {

        }
    }
}


function GetCsvValue([string]$path) {
    $value = Import-Csv -Path $samplePath -Encoding utf8
    return ($value)
}

function TCID50($values) {
    foreach ($value in $values) {
        Write-Host $value | Format-Table
        $values.Address()
    }
}

$samplePath = "$PSScriptRoot\sample.csv"
Write-Host $samplePath
$values = GetCsvValue($samplePath)
TCID50($values)