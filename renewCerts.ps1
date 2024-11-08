#Ejecutar con privilegios elevados

$certificates = @(
    "https://www.digicert.com/CACerts/DigiCertGlobalRootG2.crt",
    "https://www.digicert.com/CACerts/DigiCertGlobalRootCA.crt",
    "https://www.digicert.com/CACerts/BaltimoreCyberTrustRoot.crt"
)
$tempPath = "C:\Temp\Certs\"
if (-Not (Test-Path -Path $tempPath)) {
    New-Item -ItemType Directory -Path $tempPath
}
$store = New-Object System.Security.Cryptography.X509Certificates.X509Store("Root", "LocalMachine")
$store.Open("ReadWrite")
$certificates | ForEach-Object {
    $fileName = [System.IO.Path]::GetFileName($_)
    $filePath = "$tempPath$fileName"
    Invoke-WebRequest -Uri $_ -OutFile $filePath
    $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
    $cert.Import($filePath)
    $store.Add($cert)
}
$store.Close()

#Quitar comentario si se necesita leer el almacen raiz
#Get-ChildItem -Path Cert:\LocalMachine\Root

$intermediateCerts = @(
    "https://www.digicert.com/CACerts/DigiCertSHA2SecureServerCA.crt",
    "https://www.digicert.com/CACerts/DigiCertSHA2ExtendedValidationServerCA.crt"
)
$store = New-Object System.Security.Cryptography.X509Certificates.X509Store("CA", "LocalMachine")
$store.Open("ReadWrite")
$intermediateCerts | ForEach-Object {
    $fileName = [System.IO.Path]::GetFileName($_)
    $filePath = "$tempPath$fileName"
    Invoke-WebRequest -Uri $_ -OutFile $filePath
    $cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2
    $cert.Import($filePath)
    $store.Add($cert)
}
$store.Close()

#Quitar comentario si se necesita leer el almacen intermedio
#Get-ChildItem -Path Cert:\LocalMachine\CA 
