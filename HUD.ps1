param([switch]$SmokeTest)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.IO.Compression.FileSystem
Add-Type -AssemblyName System.Speech

function Read-SaveMetadata([string]$Path) {
    $file = Get-Item -LiteralPath $Path
    if ($file.Length -gt 256MB) { throw 'Save exceeds the starter 256 MB limit.' }
    $zip = [IO.Compression.ZipFile]::OpenRead($file.FullName)
    try {
        $entry = $zip.GetEntry('meta')
        if (!$entry -or $entry.Length -gt 2MB) { throw 'Missing or oversized meta entry. This save format is unsupported.' }
        $reader = New-Object IO.StreamReader($entry.Open())
        try { $raw = $reader.ReadToEnd() } finally { $reader.Dispose() }
        $facts = @()
        foreach ($key in @('name','date','version')) {
            $match = [regex]::Match($raw, '(?m)^\s*' + $key + '\s*=\s*("[^"\r\n]*"|[^\s{}]+)')
            if ($match.Success) { $facts += "$key = $($match.Groups[1].Value)" }
        }
        if (!$facts.Count) { throw 'No supported metadata fields found.' }
        return "SAVE METADATA ONLY`r`n$($facts -join "`r`n")`r`nSource: $($file.Name)`r`nModified: $($file.LastWriteTime.ToString('u'))`r`nRead: $([DateTime]::Now.ToString('u'))`r`n`r`nEconomy, fleets, player identity and wars are NOT parsed. No campaign-specific advice is available. Reload after saving."
    } finally { $zip.Dispose() }
}

function Get-SteamInventory {
    $roots = @()
    try { $roots += (Get-ItemProperty 'HKCU:\Software\Valve\Steam').SteamPath } catch {}
    $roots += "${env:ProgramFiles(x86)}\Steam"
    foreach ($root in @($roots)) {
        $libraries = Join-Path $root 'steamapps\libraryfolders.vdf'
        if (Test-Path -LiteralPath $libraries) {
            $raw = Get-Content -LiteralPath $libraries -Raw
            foreach ($m in [regex]::Matches($raw, '"path"\s+"([^"]+)"')) { $roots += $m.Groups[1].Value.Replace('\\','\') }
        }
    }
    $found = @()
    foreach ($root in ($roots | Where-Object { $_ } | Select-Object -Unique)) {
        $manifest = Join-Path $root 'steamapps\appmanifest_281990.acf'
        if (!(Test-Path -LiteralPath $manifest)) { continue }
        $raw = Get-Content -LiteralPath $manifest -Raw
        $match = [regex]::Match($raw, '"installdir"\s+"([^"]+)"')
        if (!$match.Success) { continue }
        $install = Join-Path $root ('steamapps\common\' + $match.Groups[1].Value)
        $found += "Stellaris install: $install"
        $dlc = Join-Path $install 'dlc'
        if (Test-Path -LiteralPath $dlc) {
            $found += @(Get-ChildItem -LiteralPath $dlc -Directory | ForEach-Object { 'Local content: ' + $_.Name })
        }
    }
    if (!$found.Count) { $found += 'No Stellaris install found in the checked Steam libraries.' }
    return ($found -join "`r`n") + "`r`n`r`nLocal content is NOT proof of ownership or activation. Owned / enabled / save-active status: UNKNOWN. No purchase recommendations are generated."
}

$form = New-Object Windows.Forms.Form
$form.Text = 'Stellaris Command Buddy | Admiral S.A.S.S. | Starter'
$form.Size = New-Object Drawing.Size(540,650)
$form.MinimumSize = New-Object Drawing.Size(480,500)
$form.TopMost = $true
$form.BackColor = [Drawing.Color]::FromArgb(18,24,35)
$form.ForeColor = [Drawing.Color]::WhiteSmoke
$form.Font = New-Object Drawing.Font('Segoe UI',10)
$layout = New-Object Windows.Forms.FlowLayoutPanel
$layout.Dock = 'Fill'
$layout.FlowDirection = 'TopDown'
$layout.WrapContents = $false
$layout.AutoScroll = $true
$layout.Padding = New-Object Windows.Forms.Padding(12)
$form.Controls.Add($layout)
$title = New-Object Windows.Forms.Label
$title.Text = "ADMIRAL S.A.S.S.  |  Offline starter`r`nMetadata and planning tools. Full AI coach pending."
$title.Size = New-Object Drawing.Size(480,48)
$layout.Controls.Add($title)
$output = New-Object Windows.Forms.TextBox
$output.Multiline = $true
$output.ReadOnly = $true
$output.ScrollBars = 'Vertical'
$output.Size = New-Object Drawing.Size(480,265)
$output.BackColor = [Drawing.Color]::FromArgb(28,36,50)
$output.ForeColor = [Drawing.Color]::WhiteSmoke
$output.Text = 'Welcome, Captain. Your empire deserves a plan. A suspiciously rare luxury. Load a save to inspect metadata, scan Steam, or start planning below.'
$speech = New-Object Speech.Synthesis.SpeechSynthesizer
function Add-Button($text, $action) {
    $button = New-Object Windows.Forms.Button
    $button.Text = $text
    $button.Size = New-Object Drawing.Size(480,32)
    $button.FlatStyle = 'Flat'
    $button.Add_Click($action)
    $layout.Controls.Add($button)
}
Add-Button 'Load .sav metadata (read-only)' {
    $dialog = New-Object Windows.Forms.OpenFileDialog
    $dialog.Filter = 'Stellaris saves (*.sav)|*.sav'
    $dialog.InitialDirectory = Join-Path ([Environment]::GetFolderPath('MyDocuments')) 'Paradox Interactive\Stellaris\save games'
    try { if ($dialog.ShowDialog() -eq 'OK') { $output.Text = Read-SaveMetadata $dialog.FileName } }
    catch { $output.Text = 'Save could not be read: ' + $_.Exception.Message }
    finally { $dialog.Dispose() }
}
Add-Button 'Scan local Steam / DLC content' {
    try { $output.Text = Get-SteamInventory } catch { $output.Text = 'Steam scan failed: ' + $_.Exception.Message }
}
$style = New-Object Windows.Forms.ComboBox
$style.DropDownStyle = 'DropDownList'
$style.Width = 480
[void]$style.Items.AddRange(@('Exploration and discovery','Diplomacy and trade','Conquest and fleet command','Roleplay and storytelling'))
$style.SelectedIndex = 0
$layout.Controls.Add($style)
Add-Button 'Pre-game planning checklist' {
    $output.Text = "PREFERRED PLAY: $($style.SelectedItem)`r`n`r`n1. Decide your fantasy: who are your people and what do they want?`r`n2. Choose relaxed learning or a demanding campaign.`r`n3. Confirm owned and enabled DLC in the launcher.`r`n4. Review species, traits, ethics, authority, civics and origin in-game; availability and costs depend on your patch and DLC.`r`n5. Review galaxy size, AI count, difficulty, scaling, crisis and victory dates before starting.`r`n6. Record one learning goal for this campaign.`r`n`r`nCoaching path: Captain -> Commodore -> Admiral -> Grand Admiral. Advance when you can explain and repeat your decisions, not just survive.`r`n`r`nThis is a checklist, not a validated empire build. Interactive questions and legal-build validation are pending."
}
Add-Button 'Speak displayed text / interrupt previous speech' {
    $speech.SpeakAsyncCancelAll()
    [void]$speech.SpeakAsync($output.Text)
}
Add-Button 'Stop speech' { $speech.SpeakAsyncCancelAll() }
Add-Button 'Toggle always-on-top' { $form.TopMost = !$form.TopMost; $title.Text = "ADMIRAL S.A.S.S. | Always-on-top: $($form.TopMost)`r`nOffline starter; full AI coach pending." }
$layout.Controls.Add($output)
$form.Add_FormClosed({ $speech.SpeakAsyncCancelAll(); $speech.Dispose() })
if ($SmokeTest) {
    $form.Show()
    [Windows.Forms.Application]::DoEvents()
    if (!$form.Visible -or !$form.TopMost) { throw 'HUD did not open as a topmost window.' }
    $form.Close()
    Write-Output 'PASS: HUD constructed, displayed, topmost, and closed.'
} else { [void]$form.ShowDialog() }
