@echo off
FOR %%I IN (D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (
	IF EXIST %%I:\Mig_Correo\Imp_Correo.bat SET USB=%%I:& GOTO INICIO
	)
:INICIO
SET EXPORTA=regedit /e /s %USB%\Mig_Correo\REG\%USERNAME%
CLS
echo Realizar la exportacion de datos antes de reinstalación.
echo.
echo Asumimos que el disco USB es %USB%
echo.
echo Asumimos que hemos entrado en el con el usuario a migrar. 
echo.
echo.
echo.
echo.
echo Si no,pulsar CTRL+C para abortar, cerrar sesion y empezar de nuevo.

%USB%\Mig_Correo\Utils\Sleep 3

REM Comprobamos si ya está tenemos un registro del usuario
if exist %USB%\Mig_Correo\REG\%USERNAME% RD %USB%\Mig_Correo\REG\%USERNAME% /S
MD %USB%\Mig_Correo\REG\%USERNAME%

REM Exportamos configuración del Outlook
ECHO Exportamos configuración del Outlook
%EXPORTA%\correoMod.reg "HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\Windows Messaging Subsystem\Profiles"
%EXPORTA%\exchange.reg "HKEY_CURRENT_USER\Software\Microsoft\Exchange"
Rem unificamos configuracion de Outlook en un solo fichero .REG
type %USB%\Mig_Correo\REG\%USERNAME%\exchange.reg > %USB%\Mig_Correo\REG\%USERNAME%\correu.reg
type %USB%\Mig_Correo\REG\%USERNAME%\correomod.reg >> %USB%\Mig_Correo\REG\%USERNAME%\correu.reg

:FIN
ECHO PROCESO FINALIZADO.
%USB%\Mig_Correo\Utils\Sleep 3