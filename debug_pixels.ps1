Add-Type -AssemblyName System.Drawing
$bmp = [System.Drawing.Bitmap]::FromFile("c:\Users\LENOVO\OneDrive\Desktop\antigravitywork1\profile.jpg")
Write-Host "Top-Left (0,0): $($bmp.GetPixel(0,0))"
Write-Host "Top-Right (width-1, 0): $($bmp.GetPixel($($bmp.Width-1), 0))"
Write-Host "Center Top (width/2, 10): $($bmp.GetPixel($($bmp.Width/2), 10))"
$bmp.Dispose()
