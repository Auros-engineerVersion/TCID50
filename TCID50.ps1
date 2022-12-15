using namespace System

#csvファイルのパス
function TCID50 {
    [CmdletBinding()]
    param (
        [string]$Path,
        [Int32]$Magn
    )

    $values = Import-Csv -Path $Path -Delimiter "," -Encoding Default
    [string[]]$headers = $values | Get-Member -MemberType 'NoteProperty' | Select-Object -ExpandProperty 'Name'

    [double]$sigma = -0.5
    foreach ($header in $headers) {
        #50%以上顕性の数を取得
        $halfOvertNum = 0
        foreach ($v in $values.$header) {
            $halfOvertNum += $v
        }
        $sigma += $halfOvertNum / $values.Count
    }

    Write-Host "sigam is $sigma"

    #一列目の希釈倍率
    [double]$firstLineRate = [Math]::Pow($Magn, $headers[0])

    <#
    Karberの式より
    TCID50＝（1列目の希釈率）×{(希釈倍率)^(Σ－0.5)}
    この場合、Σには最初から-0.5を引いてある。
    #>
    [double]$result = $firstLineRate * [Math]::Pow($Magn, $sigma)
    return ($result)
}

$samplePath = "$PSScriptRoot\sample_01.csv"
TCID50 -Path $samplePath -Magn 10