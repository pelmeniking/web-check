<h2 id="bkmrk-web-check">web-check</h2>
<p id="bkmrk-simple-website-check">Simple Website Check for use in PowerShell</p>
<h3 id="bkmrk-usage">Usage</h3>
<p id="bkmrk-copy-wc.ps1-to-an-lo">Copy <code>wc.ps1</code> to an location of your choice</p>
<p id="bkmrk-example"><em>Example</em></p>
<pre id="bkmrk-c%3A%5Ctools"><code class="language-shell">C:\Tools</code></pre>
<p id="bkmrk-copy-function-to-you">Copy function to your PowerShell Profile</p>
<p id="bkmrk-example-1"><em>Example</em></p>
<p id="bkmrk-microsoft.powershell"><code>Microsoft.PowerShell_profile.ps1</code></p>

```powershell
function webcheck {
    param(
        [string]$Target
    )

    $script = "C:\Tools\webcheck.ps1"

    if ($Target -match "https?://") {
        $Target = ([uri]$Target).Host
    }

    & $script -HostName $Target
}

Set-Alias wc webcheck
```

Set-Alias wc webcheck</code></pre>
<p id="bkmrk-save-the-profile.">Save the profile.</p>
<p id="bkmrk-%C2%A0"></p>
<p id="bkmrk-after-adding-everyth">After adding everything you can use the command <code>wc</code> or <code>webcheck</code> followed by an adress to check the webseite.</p>
<p id="bkmrk-example-2"><em>Example</em></p>
<p id="bkmrk-%3E_-wc-https%3A%2F%2Fexampl">&gt;_ wc https://example.com<br>===== WEB CHECK =====<br>Host: example.com</p>
<p id="bkmrk-dns%3A-ok-%28104.18.26.1">DNS: OK (104.18.26.120)<br>TCP 443: OK<br>HTTP: probing...<br>TLS Handshake: OK<br>HTTP/1.1 200 OK</p>
<p id="bkmrk-%3D%3D%3D%3D%3D-summary-%3D%3D%3D%3D%3Dd">===== SUMMARY =====<br>DNS OK | TCP OK | TLS OK</p>
