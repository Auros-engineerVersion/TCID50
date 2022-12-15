using namespace System

#csvファイルのパス
function TCID50([string]$path, [Int32]$magn) {
    $values = Import-Csv -Path $path -Delimiter "," -Encoding Default
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
    #希釈倍率
    #一度変数を経由しないとエラーが起きる
    [double]$firstHeader = $headers[0]

    #一列目の希釈率
    [double]$firstLineRate = [Math]::Pow($magn, $firstHeader)

    <#
    Karberの式より
    #TCID50＝（1列目の希釈率）×{(希釈倍率)^(Σ－0.5)}
    この場合、Σには最初から-0.5を引いてある。
    #>
    [double]$result = $firstLineRate * [Math]::Pow($magn, $sigma)
    return ($result)
}

$samplePath = "$PSScriptRoot\sample_01.csv"
TCID50($samplePath, 10)
