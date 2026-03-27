$folder = 'C:\Program Files (x86)\Adobe\Acrobat Reader DC'

if (-not (Test-Path -Path $folder)) {
    Start-Process "\\DC01\Deployment$\AdobeReaderSetup.exe" -ArgumentList '/S' -Wait
}