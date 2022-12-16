using namespace System

#csvファイルのパス
function TCID50 {
    [CmdletBinding()]
    param (
        [string]$Path,
        [Int32]$Magn,
        [string]$Method,
        [bool]$IsLog = $false
    )

    $values = Import-Csv -Path $Path -Delimiter "," -Encoding Default
    [string[]]$headers = $values | Get-Member -MemberType 'NoteProperty' | Select-Object -ExpandProperty 'Name'

    [double]$result = 0
    switch ($Method) {
        Default {
            $result = ImprovedKarberMethod -Values $values -DilRates $headers -Magn $Magn
        }
    }

    $result = $IsLog ? [Math]::Log($result, $Magn) : $result
    return ($result)
}

function ImprovedKarberMethod {
    [CmdletBinding()]
    param (
        [Object[]]$Values,
        [string[]]$DilRates,
        [Int32]$Magn
    )

    [double]$sigma = 0
    foreach ($rate in $DilRates) {
        #50%以上顕性の数を取得
        $halfOvertNum = 0
        foreach ($v in $Values.$rate) {
            $halfOvertNum += $v
        }

        $sigma += $halfOvertNum / $values.Count
    }

    #TCID50 ＝（最も低い稀釈倍率）×{(段階稀釈した倍率)^(Σ－0.5)}
    [double]$result = [Math]::Pow($Magn, $DilRates[0]) * [Math]::Pow($Magn, $sigma - 0.5)
    return ($result)
}

$samplePath = "$PSScriptRoot\sample_03.csv"
TCID50 -Path $samplePath -Magn 10 -IsLog $true