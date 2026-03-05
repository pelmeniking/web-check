param(
    [Parameter(Mandatory=$true)]
    [string]$HostName
)

function Write-Color {
    param(
        [string]$Text,
        [ValidateSet("Default","Red","Green","Yellow","Cyan","Gray")]$Color = "Default"
    )

    switch ($Color) {
        "Red"    { Write-Host $Text -ForegroundColor Red }
        "Green"  { Write-Host $Text -ForegroundColor Green }
        "Yellow" { Write-Host $Text -ForegroundColor Yellow }
        "Cyan"   { Write-Host $Text -ForegroundColor Cyan }
        "Gray"   { Write-Host $Text -ForegroundColor DarkGray }
        default  { Write-Host $Text }
    }
}

Write-Color "===== WEB CHECK =====" Cyan
Write-Color "Host: $HostName" Gray
Write-Color ""

# DNS
try {
    $dns = Resolve-DnsName $HostName -ErrorAction Stop
    $ip = ($dns | Where-Object {$_.Type -eq "A"} | Select-Object -First 1).IPAddress
    Write-Color "DNS: OK ($ip)" Green
    $dnsShort = "OK"
}
catch {
    Write-Color "DNS: FAIL" Red
    $dnsShort = "FAIL"
}

# TCP
$tcp = Test-NetConnection $HostName -Port 443 -WarningAction SilentlyContinue
if ($tcp.TcpTestSucceeded) {
    Write-Color "TCP 443: OK" Green
    $tcpShort = "OK"
}
else {
    Write-Color "TCP 443: FAIL" Red
    $tcpShort = "FAIL"
}

Write-Color "HTTP: probing..." Cyan

$curl = curl.exe -vkI -L "https://$HostName" 2>&1
$statusLine = ($curl | Select-String "< HTTP" | Select-Object -First 1).Line

if (-not $tcp.TcpTestSucceeded) {
    $tls = "NO TCP"
    Write-Color "TLS Handshake: $tls" Yellow
}
elseif ($statusLine) {
    $tls = "OK"
    Write-Color "TLS Handshake: OK" Green
}
else {
    $tls = "FAIL"
    Write-Color "TLS Handshake: FAIL" Red
}

if ($statusLine) {
    $status = ($statusLine -replace "^<\s*", "").Trim()
    $code = [int](($status -split " ")[1])

    if ($code -ge 200 -and $code -lt 300) { $c="Green" }
    elseif ($code -ge 300 -and $code -lt 400) { $c="Yellow" }
    else { $c="Red" }

    Write-Color $status $c
}
else {
    Write-Color "HTTP: NO RESPONSE" Red
}

Write-Color ""
Write-Color "===== SUMMARY =====" Cyan
Write-Color ("DNS {0} | TCP {1} | TLS {2}" -f $dnsShort,$tcpShort,$tls) Gray
