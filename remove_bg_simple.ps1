Add-Type -AssemblyName System.Drawing

$inputFile = "c:\Users\LENOVO\OneDrive\Desktop\antigravitywork1\profile.jpg"
$outputFile = "c:\Users\LENOVO\OneDrive\Desktop\antigravitywork1\profile_transparent.png"

$bmp = [System.Drawing.Bitmap]::FromFile($inputFile)
[int]$width = $bmp.Width
[int]$height = $bmp.Height
$newBmp = New-Object System.Drawing.Bitmap($width, $height)

# Target background color (gray)
[int]$tr = 170
[int]$tg = 180
[int]$tb = 185

$threshold = 100 # Very high

for ($y = 0; $y -lt $height; $y++) {
    for ($x = 0; $x -lt $width; $x++) {
        $pixel = $bmp.GetPixel($x, $y)
        
        $dr = [Math]::Abs($pixel.R - $tr)
        $dg = [Math]::Abs($pixel.G - $tg)
        $db = [Math]::Abs($pixel.B - $tb)
        
        # If the pixel is gray-ish or very bright, make it transparent
        if (($dr -lt $threshold -and $dg -lt $threshold -and $db -lt $threshold) -or ($pixel.R -gt 200 -and $pixel.G -gt 200 -and $pixel.B -gt 200)) {
            $newBmp.SetPixel($x, $y, [System.Drawing.Color]::FromArgb(0, 0, 0, 0))
        } else {
            $newBmp.SetPixel($x, $y, $pixel)
        }
    }
}

$newBmp.Save($outputFile, [System.Drawing.Imaging.ImageFormat]::Png)
$bmp.Dispose()
$newBmp.Dispose()

Write-Host "Success: Simple aggressive $outputFile created."
