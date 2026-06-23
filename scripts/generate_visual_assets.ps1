[CmdletBinding()]
param(
  [switch]$Force
)

$ErrorActionPreference = "Stop"

$Root = Split-Path -Parent $PSScriptRoot
$Utf8NoBom = [System.Text.UTF8Encoding]::new($false)

Add-Type -AssemblyName System.Drawing

function Convert-ToSlug {
  param([string]$Text)

  $slug = [regex]::Replace($Text.ToLowerInvariant(), "[^a-z0-9]+", "-").Trim("-")
  if ([string]::IsNullOrWhiteSpace($slug)) {
    $sha1 = [System.Security.Cryptography.SHA1]::Create()
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($Text)
    $hash = -join ($sha1.ComputeHash($bytes) | ForEach-Object { $_.ToString("x2") })
    $slug = "visual-$($hash.Substring(0, 10))"
  }
  if ($slug.Length -gt 64) {
    $slug = $slug.Substring(0, 64).Trim("-")
  }
  return $slug
}

function Convert-ToRelativeAssetPath {
  param([string]$Path)
  return ($Path -replace "\\", "/")
}

function Resolve-AssetPath {
  param([string]$RelativePath)
  $native = $RelativePath -replace "/", [System.IO.Path]::DirectorySeparatorChar
  return Join-Path $Root $native
}

function Unquote-YamlValue {
  param([string]$Value)

  $v = $Value.Trim()
  if (($v.StartsWith('"') -and $v.EndsWith('"')) -or ($v.StartsWith("'") -and $v.EndsWith("'"))) {
    return $v.Substring(1, $v.Length - 2)
  }
  return $v
}

function Shorten-Text {
  param(
    [string]$Text,
    [int]$MaxLength
  )

  if ($Text.Length -le $MaxLength) {
    return $Text
  }
  return $Text.Substring(0, [Math]::Max(0, $MaxLength - 1)).TrimEnd() + "..."
}

function New-VisualAsset {
  param(
    [string]$Path,
    [string]$Title,
    [string]$Subtitle,
    [string]$Badge,
    [string]$AccentA = "#8f2d3a",
    [string]$AccentB = "#26344d"
  )

  $dir = Split-Path $Path -Parent
  New-Item -ItemType Directory -Force $dir | Out-Null

  if ((Test-Path $Path) -and -not $Force) {
    Write-Host "skip existing $Path"
    return
  }

  $w = 1200
  $h = 675
  $bmp = New-Object System.Drawing.Bitmap($w, $h)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit

  $rect = New-Object System.Drawing.Rectangle(0, 0, $w, $h)
  $c1 = [System.Drawing.ColorTranslator]::FromHtml($AccentA)
  $c2 = [System.Drawing.ColorTranslator]::FromHtml($AccentB)
  $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect, $c1, $c2, 35)
  $g.FillRectangle($brush, $rect)

  $overlay = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(150, 12, 15, 20))
  $g.FillRectangle($overlay, 0, 0, $w, $h)

  $gridPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(34, 255, 255, 255), 1)
  for ($x = 80; $x -lt $w; $x += 80) {
    $g.DrawLine($gridPen, $x, 0, $x, $h)
  }
  for ($y = 75; $y -lt $h; $y += 75) {
    $g.DrawLine($gridPen, 0, $y, $w, $y)
  }

  $shapeA = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(185, 255, 255, 255))
  $shapeB = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(120, 255, 255, 255))
  $shapeC = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(70, 255, 255, 255))
  $g.FillEllipse($shapeC, 750, 90, 300, 300)
  $g.FillRectangle($shapeB, 720, 390, 330, 58)
  $g.FillRectangle($shapeA, 800, 470, 190, 42)
  $g.FillEllipse($shapeA, 1010, 410, 68, 68)
  $g.DrawLine((New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(160, 255, 255, 255), 12)), 820, 270, 1010, 430)
  $g.DrawLine((New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(135, 255, 255, 255), 10)), 925, 190, 760, 410)

  $fontTitle = New-Object System.Drawing.Font("Segoe UI", 54, [System.Drawing.FontStyle]::Bold)
  $fontSub = New-Object System.Drawing.Font("Segoe UI", 24, [System.Drawing.FontStyle]::Regular)
  $fontBadge = New-Object System.Drawing.Font("Segoe UI", 22, [System.Drawing.FontStyle]::Bold)
  $white = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
  $muted = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(218, 255, 255, 255))
  $badgeBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(230, 255, 255, 255))
  $badgeText = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 40, 40, 46))

  $titleText = Shorten-Text $Title 28
  $subtitleText = Shorten-Text $Subtitle 46

  $g.DrawString($titleText, $fontTitle, $white, 76, 230)
  $g.DrawString($subtitleText, $fontSub, $muted, 82, 315)

  if (-not [string]::IsNullOrWhiteSpace($Badge)) {
    $badgeTextValue = Shorten-Text $Badge 18
    $badgeRect = New-Object System.Drawing.RectangleF(82, 112, 300, 48)
    $g.FillRectangle($badgeBrush, $badgeRect)
    $g.DrawString($badgeTextValue, $fontBadge, $badgeText, 102, 120)
  }

  $bmp.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
  $g.Dispose()
  $bmp.Dispose()
  Write-Host "generated $Path"
}

function Update-ProfileVisual {
  $profilePath = Join-Path $Root "_data/profile.yml"
  if (-not (Test-Path $profilePath)) {
    return
  }

  $lines = [System.Collections.Generic.List[string]]::new()
  $lines.AddRange([System.IO.File]::ReadAllLines($profilePath, $Utf8NoBom))
  $name = "Academic Homepage"
  $bio = "Academic visual"
  $visualIndex = -1
  $avatarIndex = -1

  for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -match "^name:\s*(.+)$") {
      $name = Unquote-YamlValue $Matches[1]
    }
    elseif ($lines[$i] -match "^bio:\s*(.+)$") {
      $bio = Unquote-YamlValue $Matches[1]
    }
    elseif ($lines[$i] -match "^visual:\s*(.*)$") {
      $visualIndex = $i
    }
    elseif ($lines[$i] -match "^avatar:\s*(.*)$") {
      $avatarIndex = $i
    }
  }

  $relative = "assets/img/home/hero-visual.png"
  if ($visualIndex -ge 0) {
    $current = ($lines[$visualIndex] -replace "^visual:\s*", "").Trim()
    if (-not [string]::IsNullOrWhiteSpace($current)) {
      $relative = $current
    }
    else {
      $lines[$visualIndex] = "visual: $relative"
    }
  }
  elseif ($avatarIndex -ge 0) {
    $lines.Insert($avatarIndex + 1, "visual: $relative")
  }

  New-VisualAsset `
    -Path (Resolve-AssetPath $relative) `
    -Title $name `
    -Subtitle (Shorten-Text $bio 52) `
    -Badge "Academic"

  [System.IO.File]::WriteAllLines($profilePath, $lines, $Utf8NoBom)
}

function Update-PublicationImages {
  $path = Join-Path $Root "_data/publications.yml"
  if (-not (Test-Path $path)) {
    return
  }

  $lines = [System.Collections.Generic.List[string]]::new()
  $lines.AddRange([System.IO.File]::ReadAllLines($path, $Utf8NoBom))

  for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -notmatch "^- title:\s*(.+)$") {
      continue
    }

    $title = Unquote-YamlValue $Matches[1]
    $venue = "Publication"
    $imageIndex = -1
    $end = $lines.Count

    for ($j = $i + 1; $j -lt $lines.Count; $j++) {
      if ($lines[$j] -match "^- title:\s*") {
        $end = $j
        break
      }
      if ($lines[$j] -match "^\s+venue:\s*(.+)$") {
        $venue = Unquote-YamlValue $Matches[1]
      }
      if ($lines[$j] -match "^\s+image:\s*(.*)$") {
        $imageIndex = $j
      }
    }

    $relative = "assets/img/publications/$(Convert-ToSlug $title).png"
    if ($imageIndex -ge 0) {
      $current = ($lines[$imageIndex] -replace "^\s+image:\s*", "").Trim()
      if (-not [string]::IsNullOrWhiteSpace($current)) {
        $relative = $current
      }
      else {
        $lines[$imageIndex] = "  image: $relative"
      }
    }
    else {
      $lines.Insert($end, "  image: $relative")
    }

    New-VisualAsset `
      -Path (Resolve-AssetPath $relative) `
      -Title $title `
      -Subtitle $venue `
      -Badge "Publication" `
      -AccentA "#375a7f" `
      -AccentB "#8f2d3a"
  }

  [System.IO.File]::WriteAllLines($path, $lines, $Utf8NoBom)
}

function Update-AwardImages {
  $path = Join-Path $Root "_data/awards.yml"
  if (-not (Test-Path $path)) {
    return
  }

  $lines = [System.Collections.Generic.List[string]]::new()
  $lines.AddRange([System.IO.File]::ReadAllLines($path, $Utf8NoBom))

  for ($i = 0; $i -lt $lines.Count; $i++) {
    if ($lines[$i] -notmatch "^- year:\s*(.+)$") {
      continue
    }

    $year = Unquote-YamlValue $Matches[1]
    $title = "Award"
    $result = "Award"
    $imageIndex = -1
    $end = $lines.Count

    for ($j = $i + 1; $j -lt $lines.Count; $j++) {
      if ($lines[$j] -match "^- year:\s*") {
        $end = $j
        break
      }
      if ($lines[$j] -match "^\s+title:\s*(.+)$") {
        $title = Unquote-YamlValue $Matches[1]
      }
      if ($lines[$j] -match "^\s+result:\s*(.+)$") {
        $result = Unquote-YamlValue $Matches[1]
      }
      if ($lines[$j] -match "^\s+image:\s*(.*)$") {
        $imageIndex = $j
      }
    }

    $relative = "assets/img/awards/$(Convert-ToSlug "$year $title").png"
    if ($imageIndex -ge 0) {
      $current = ($lines[$imageIndex] -replace "^\s+image:\s*", "").Trim()
      if (-not [string]::IsNullOrWhiteSpace($current)) {
        $relative = $current
      }
      else {
        $lines[$imageIndex] = "  image: $relative"
      }
    }
    else {
      $lines.Insert($end, "  image: $relative")
    }

    New-VisualAsset `
      -Path (Resolve-AssetPath $relative) `
      -Title $title `
      -Subtitle $result `
      -Badge $year `
      -AccentA "#b88a2e" `
      -AccentB "#26344d"
  }

  [System.IO.File]::WriteAllLines($path, $lines, $Utf8NoBom)
}

Update-ProfileVisual
Update-PublicationImages
Update-AwardImages
