@echo off
SETLOCAL EnableExtensions EnableDelayedExpansion
FOR %%I IN (D E F G H I J K L M N O P Q R S T U V W X Y Z) DO (
	IF EXIST %%I:\Mig_Correo\Mig_Correo.bat SET USB=%%I:& GOTO INICIO
	)
:INICIO
REM Solicitamos la unidad de la memoria USB (Es igual tanto para migracion como para renombrado)
CLS
SET LOGFILE=%USB%\Mig_Correo\REG\%USERNAME%\%USERNAME%.txt
IF NOT EXIST %USB%\Mig_Correo\REG\%USERNAME% CALL :MENSAJE2 & CALL :MENSAJE NO_SALVARVIEJO & CALL :MENSAJE2 & PAUSE & GOTO INICIO

:MIGRACION
CLS
echo.
echo ++++++++++++++++++++ IMPORTACIÓN +++++++++++++++++++++
echo.
echo Asumimos que el disco USB tiene la unidad %USB%
echo.
echo Asumimos que hemos entrado con el usuario a migrar: %USERNAME%
echo. 
echo Asumimos que hemos ejecutado el Exp_Correo.bat antes de la reinstalación.
echo.
echo.
echo.
echo.
echo.
GOTO ELIGE

:PARAM
REM Definimos variables de entorno en funcion de la acción a realizar
SET PRF=C:\USERS\%USERNAME%

:COPIAPERFIL
REM COPIAMOS CARPETAS DE Appdata\Roaming\Microsoft DEL PERFIL DE USUARIO *************************************
TASKKILL /S Localhost /FI "IMAGENAME eq outlook.exe"

REM Templates Plantillas Signatures Firmas UProof Proof Outlook "Sticky Notes"
FOR %%A IN (Templates Plantillas Signatures Firmas UProof Proof Sticky~1 Outlook) DO (
	CALL :COPIADO \Appdata\Roaming\Microsoft\%%A
	)

:CORREO
if not exist %USB%\Mig_Correo\REG\%USERNAME%\correu.reg CALL :MENSAJE2 & CALL :MENSAJE CORREU & CALL :MENSAJE2 & PAUSE & GOTO BARRA
TASKKILL /S Localhost /FI "IMAGENAME eq outlook.exe"
rem regedit /i /s %USB%\Mig_Correo\REG\%USERNAME%\correoMod.reg
rem regedit /i /s %USB%\Mig_Correo\REG\%USERNAME%\exchange.reg
regedit /i /s %USB%\Mig_Correo\REG\%USERNAME%\correu.reg
	
REM Verificamos si existe carpeta Firmas y si no existe cambiamos Templates a Plantillas
IF EXIST %PRF%\AppData\Roaming\Microsoft\Plantillas GOTO FIRMAS
IF EXIST %PRF%\AppData\Roaming\Microsoft\Templates move %PRF%\AppData\Roaming\Microsoft\Templates %PRF%\AppData\Roaming\Microsoft\Plantillas

:FIRMAS
REM Verificamos si existe carpeta Firmas y si no existe cambiamos Signatures a Firmas
IF EXIST %PRF%\AppData\Roaming\Microsoft\Firmas GOTO CORREO2
IF EXIST %PRF%\AppData\Roaming\Microsoft\Signatures move %PRF%\AppData\Roaming\Microsoft\Signatures %PRF%\AppData\Roaming\Microsoft\Firmas

:CORREO2
%USB%\Mig_Correo\Utils\Sleep 3
start outlook.exe
	
	
REM ********************************* MENSAJES VARIOS *****************************************************************************

:MENSAJE
IF "%1"=="" GOTO :EOF
IF "%1"=="DISCO_IGUAL" ECHO ERROR: LA UNIDAD USB Y EL DISCO ESCLAVO NO PUEDEN TENER LA MISMA LETRA
IF "%1"=="NO_USB" ECHO LA UNIDAD USB NO ES CORRECTA, VERIFICARLA
IF "%1"=="NO_EXPORT" ECHO NO SE HA REALIZADO PREVIAMENTE LA EXPORTACIÓN DE CONFIGURACIONES
IF "%1"=="YA_DATOS" ECHO YA EXISTE LA CARPETA DATOS EN C:
IF "%1"=="YA_DATOS" ECHO NO SE HA COPIADO LA CARPETA DEL DISCO VIEJO AL NUEVO
IF "%1"=="NO_DATOS" ECHO NO EXISTE CARPETA DATOS EN DISCO DURO VIEJO
IF "%1"=="NO_DATOS" ECHO NO SE HA COPIADO LA CARPETA DEL DISCO VIEJO AL NUEVO
IF "%1"=="CORREU" ECHO No existe el fichero correu.reg en la carpeta REG\%USERNAME% & ECHO Verifique que ha realizado la exportacion en el equipo viejo
IF "%2"=="COPIAPERFIL" ECHO ERROR ******************************************************  >>%LOGFILE%
IF "%1"=="YA_DATOS" ECHO ERROR ***********	*******************************************  >>%LOGFILE%
IF "%1"=="YA_DATOS" ECHO YA EXISTE LA CARPETA DATOS EN C:  >>%LOGFILE%
IF "%1"=="YA_DATOS" ECHO ERROR ******************************************************  >>%LOGFILE%
IF "%1"=="NO_DATOS" ECHO NO EXISTE CARPETA DATOS EN DISCO DURO VIEJO  >>%LOGFILE%
IF "%2"=="COPIAPERFIL" ECHO NO SE HA COPIADO LA CARPETA DEL DISCO VIEJO AL NUEVO  >>%LOGFILE%
IF "%2"=="COPIAPERFIL" ECHO ERROR ******************************************************  >>%LOGFILE%
IF "%2"=="COPIAPERFIL" ECHO GdeFua 1: Carpeta "Datos" ********************** >>%LOGFILE%
GOTO :EOF

:MENSAJE2
echo.
echo.
echo.
ECHO ERROR ******************************************************
echo.
echo.
echo.
GOTO :EOF
REM ****************************************** FIN MENSAJES ***********************************************************************

:SALIR
ENDLOCAL