@echo off
setlocal

:: Définir les variables
set REP_LOCAL=C:\Users\dar\Desktop\CODES\CCLOUD\QUESTA\questa_frontend\build\web\*
set ARCHIVE=archive_via_ssh.zip
set SERVEUR=julizha@ssh.web23.us.cloudlogin.co
:: set CHEMIN_DISTANT=/home/www/api_sys_assainissement.collecta.top/
set CHEMIN_DISTANT=/home/www/myquesta.net/public/app/
set PORT=2222

:: Compresser le répertoire en ZIP
powershell Compress-Archive -Path "%REP_LOCAL%" -DestinationPath "%ARCHIVE%" -Force

:: Envoyer le ZIP vers le serveur via SCP
scp -P %PORT% %ARCHIVE% %SERVEUR%:%CHEMIN_DISTANT%

:: Se connecter au serveur et décompresser le ZIP
ssh -p %PORT% %SERVEUR% "unzip -o %CHEMIN_DISTANT%%ARCHIVE% -d %CHEMIN_DISTANT% && rm %CHEMIN_DISTANT%%ARCHIVE%"

:: Supprimer le fichier archive cree.
del %ARCHIVE%

:: Fin du script
echo TRANSFERT ET EXTRACTION TERMINERS !
endlocal
