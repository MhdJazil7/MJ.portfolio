Add-Type -AssemblyName System.Drawing

$inputFile = "c:\Users\LENOVO\OneDrive\Desktop\antigravitywork1\profile.jpg"
$outputFile = "c:\Users\LENOVO\OneDrive\Desktop\antigravitywork1\profile_transparent.png"

$bmp = [System.Drawing.Bitmap]::FromFile($inputFile)
[int]$width = $bmp.Width
[int]$height = $bmp.Height
$newBmp = New-Object System.Drawing.Bitmap($width, $height)

# Average background color from samples
$avgR = (162 + 154 + 183) / 3
$avgG = (173 + 167 + 192) / 3
$avgB = (179 + 173 + 199) / 3

$maxDist = 90 # Aggressive
$visited = New-Object 'bool[,]' $width, $height
$queue = New-Object System.Collections.Generic.Queue[System.Drawing.Point]

# Start from edges
for ($x = 0; $x -lt $width; $x++) {
    $queue.Enqueue((New-Object System.Drawing.Point($x, 0)))
    $queue.Enqueue((New-Object System.Drawing.Point($x, ($height - 1))))
}
for ($y = 0; $y -lt $height; $y++) {
    $queue.Enqueue((New-Object System.Drawing.Point(0, $y)))
    $queue.Enqueue((New-Object System.Drawing.Point(($width - 1), $y)))
}

$transparent = [System.Drawing.Color]::FromArgb(0, 0, 0, 0)

while ($queue.Count -gt 0) {
    $p = $queue.Dequeue()
    $px = $p.X
    $py = $p.Y
    
    if ($px -lt 0 -or $px -ge $width -or $py -lt 0 -or $py -ge $height) { continue }
    if ($visited[$px, $py]) { continue }
    $visited[$px, $py] = $true
    
    $pixel = $bmp.GetPixel($px, $py)
    [int]$dr = $pixel.R - $avgR
    [int]$dg = $pixel.G - $avgG
    [int]$db = $pixel.B - $avgB
    $dist = [Math]::Sqrt($dr*$dr + $dg*$dg + $db*$db)
    
    # If it's close to background color OR very light (lighting hotspots)
    if ($dist -lt $maxDist -or ($pixel.R -gt 150 -and $pixel.G -gt 150 -and $pixel.B -gt 150 -and $dist -lt 120)) {
        $newBmp.SetPixel($px, $py, $transparent)
        
        $queue.Enqueue((New-Object System.Drawing.Point(($px + 1), $py)))
        $queue.Enqueue((New-Object System.Drawing.Point(($px - 1), $py)))
        $queue.Enqueue((New-Object System.Drawing.Point($px, ($py + 1))))
        $queue.Enqueue((New-Object System.Drawing.Point($px, ($py - 1))))
    } else {
        $newBmp.SetPixel($px, $py, $pixel)
    }
}

# Fill in the rest of the person
for ($y = 0; $y -lt $height; $y++) {
    for ($x = 0; $x -lt $width; $x++) {
        if (-not $visited[$x, $y]) {
            $newBmp.SetPixel($x, $y, $bmp.GetPixel($x, $y))
        }
    }
}

$newBmp.Save($outputFile, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
$newBmp.Dispose()

Write-Host "Success: Aggressively optimized $outputFile created."
