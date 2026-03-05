function webcheck {
    param([string]$Target)

    $script = "C:\Tools\webcheck.ps1"

    if ($Target -match "https?://") {
        $Target = ([uri]$Target).Host
    }

    & $script -HostName $Target
}

Set-Alias wc webcheck
