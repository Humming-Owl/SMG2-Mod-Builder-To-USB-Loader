@ECHO off

MODE 80,30

CLS
echo.
echo ----- SMG2 Mod ISO Builder (v0.3)
echo ----- By Humming Owl
echo.

:: ================
:: mods data storage
:: ================

call .\mods_data.bat

:: =============================
:: actions before starting patch
:: =============================

if exist ".\savefiles" (rmdir /s /q ".\savefiles")

if exist ".\temp" (rmdir /s /q ".\temp")

if not exist ".\mods" (mkdir ".\mods")

for /d %%a in (".\mods\*") do rd "%%a" /q /s

:: ===================================================
:: Key command to work with variables inside variables
:: ===================================================

SETLOCAL EnableDelayedExpansion

:: =====
:: Tools
:: =====

set WGET=tools\wget.exe
set EXTRACT=tools\7z.exe
set PATCH=tools\patch.exe

:: =================
:: Pre-build process
:: =================

:select_iso

SET /P image=Enter name of disc image (e.g. SMG2.iso, SMG2.wbfs): 

if not exist ".\%image%" (

echo.
echo Disc image not found.
echo Place SMG2 disc image in the same location the "ISO-Builder.bat" file is.
echo Press any key to try again.
echo.
pause >nul

GOTO :select_iso)

echo.
echo Disc image found.
echo.

echo --- SMG2 Hacks list:
echo.
echo  1. Kaizo Mario Galaxy 2
echo  2. Super Mario Galaxy 2: Cosmic Clones Challenge
echo  3. Super Mario Galaxy 2: The New Green Stars
echo  4. Super Mario Galaxy 2: The Kaizo Green Stars
echo  5. Spinless Mario Galaxy 2 
echo  6. Super Mario Gravity (DEMO)
echo  7. Super Mayro Galaxy
echo  8. Super Mayro Galaxy Twoad
echo  9. Super Mario Galaxy 2.5 (DEMO)
echo 10. Outer Mario Galaxy
echo 11. Super Mario Galaxy Deluxe
echo 12. Super Mario Galaxy 2: BlueXD Edition (E/P/J/K/W)
echo 13. Super Mario Galaxy 2: Daredevil Challenge
echo 14. Neo Mario Galaxy (2020 Build - E/P/J)
echo 15. Super Mario Galaxy 64: Holiday Special
echo 16. Super Mario Galaxy 2: Fog Edition
echo 17. Super Mario Galaxy 2: The Green Star Festival
echo 18. Super Mario Galaxy 2: Underwater Edition
echo 19. Super Mario Galaxy 2: Master Mode
echo 20. Super Mario Galaxy 2: The Lost Levels (DEMO)
echo.

set /P apply_mod=Select Mod number to apply to ISO/WBFS image: 

if %apply_mod%==1 (set mod=KMG2)

if %apply_mod%==2 (set mod=SMG2CCC)

if %apply_mod%==3 (set mod=SMG2TNGS)

if %apply_mod%==4 (set mod=SMG2TKGS)

if %apply_mod%==5 (set mod=SpinMG2)

if %apply_mod%==6 (set mod=SMGRAV)

if %apply_mod%==7 (set mod=SMAYG1)

if %apply_mod%==8 (set mod=SMAYGT)

if %apply_mod%==9 (set mod=SMG25D)

if %apply_mod%==10 (set mod=OUTMG2)

if %apply_mod%==11 (set mod=SMG2DX)

if %apply_mod%==12 (set mod=SMG2BXDE)

if %apply_mod%==13 (set mod=SMG2DC)

if %apply_mod%==14 (set mod=NMG)

if %apply_mod%==15 (set mod=SMG64HS)

if %apply_mod%==16 (set mod=SMG2FE)

if %apply_mod%==17 (set mod=SMG2TGSF)

if %apply_mod%==18 (set mod=SMG2UE)

if %apply_mod%==19 (set mod=SMG2MM)

if %apply_mod%==20 (set mod=SMG2TLL)


::=====================
:: Common build process
::=====================

CLS
echo.
echo ----- !%mod%[0]! Mod ISO Builder
echo ----- !%mod%[1]! !%mod%[2]!
echo.

set /P question1=Download Hack files (approx. size !%mod%[4]!)? (y/n): 
echo.

if %question1%==y GOTO :down_hack

if %question1%==n GOTO :question2

:question2

set /P question2=Already downloaded compressed hack file in the "mods" folder? (y/n): 
echo.

if %question2%==y GOTO :confirm_file

if %question2%==n GOTO :exit_1

:exit_1

echo Download Rom Hack files and try again.
echo Terminating program...
echo Press any key to close program.
echo.

pause >nul

exit

:down_hack

echo Downloading Rom Hack files...
echo.

%WGET% -t inf "https://archive.org/download/SMG_1-2_Rom_Hacks/!%mod%[3]!" -P mods >nul

echo.

:confirm_file

if exist ".\mods\!%mod%[3]!" GOTO :extract_file

echo Rom Hack file not found.
echo Press any key to close program.
echo.

pause > nul

exit

:extract_file

echo Rom Hack file found.

echo Extracting file contents...

%EXTRACT% x "mods\!%mod%[3]!" -o.\mods\!%mod%[5]!\ >nul

echo.

:build_iso

echo Building modded disc image...
echo This will take a while.
echo.

echo Extracting image contents...

wit EXTRACT ".\%image%" ".\temp" >nul

echo Copying and replacing mod files...

if exist ".\temp\DATA\" (xcopy ".\mods\!%mod%[6]!\!%mod%[7]!\*" ".\temp\DATA\files\" /E /Y >nul)

if not exist ".\temp\DATA\" (xcopy ".\mods\!%mod%[6]!\!%mod%[7]!\*" ".\temp\files\" /E /Y >nul)

:: ==================================
:: Redirector to mod's unique options
:: ==================================

if %mod%==KMG2 GOTO :KMG2_custom

if %mod%==SMG2TNGS GOTO :SMG2TNGS_custom

if %mod%==SMG2TKGS GOTO :SMG2TKGS_custom

if %mod%==NEOMG2 GOTO :NEOMG2_custom

if %mod%==SMG2BE GOTO :SMG2BE_custom

if %mod%==NMG GOTO :NMG_custom

if %mod%==SMG64HS GOTO :SMG64HS_custom

if %mod%==SMG2BXDE GOTO :SMG2BXDE_custom

if %mod%==SMG2MM GOTO :SMG2MM_custom

if %mod%==SMG2TLL GOTO :SMG2TLL_custom

:: ================================== 

:final_steps

echo Assembling game image...

wit COPY ".\temp" ".\!%mod%[0]!.wbfs" >nul

echo Removing temp folders...

rmdir /s /q ".\temp"

rmdir /s /q ".\mods\!%mod%[6]!"

echo Editing game IDs...

wit EDIT --id "!%mod%[8]!" ".\!%mod%[0]!.wbfs" >nul

wit EDIT --tt-id "!%mod%[9]!" ".\!%mod%[0]!.wbfs" >nul

wit EDIT --name "!%mod%[1]!" ".\!%mod%[0]!.wbfs" >nul

if exist ".\!%mod%[0]!.wbfs" GOTO :print-info
if not exist ".\!%mod%[0]!.wbfs" GOTO :print-error

:print-error

echo.
echo Error while modding the image.
echo Please try again.
echo Press any key to continue.
echo.

pause >nul

exit

:print-info

echo.
echo Disc image modded correctly.
echo.
echo Game ID: !%mod%[8]!
echo TMD ID: !%mod%[9]!
echo Game name: !%mod%[1]!
echo.
echo If you want to contribute (New Hack/Improve Tool) 
echo go to my GitHub repository and open an Issue.
echo Have fun^!
echo.
echo Press any key to exit.
echo.

pause >nul

exit


:: ===============================
:: Unique options/commands per mod
:: ===============================

:: ====
:: KMG2
:: ====

:KMG2_custom

echo.
echo This mod works with a txt file (Gecko Codes).
echo The file named "KG2E01.txt" is in the "codes" folder.
echo Put it in the "codes" folder of your SD card to get
echo the full patch on the game.
echo.

GOTO :final_steps

:: ========
:: SMG2TNGS
:: ========

:SMG2TNGS_custom

echo.
echo This hack works with a 120 star savefile and a txt file.
echo The savefiles need to be applied manually and the txt file
echo "NGSE01.txt" needs to be placed in the "codes" folder of your
echo SD card. In the "instructions" folder read the "savefiles.txt" 
echo file to know how to apply the savefiles to the game.
echo.
echo Copying savefiles to "safefiles" folder...
echo.

xcopy ".\mods\SMG2 The New Green Stars\SMG2 The New Green Stars\SaveGame\SB4E01\*" ".\savefiles\" /E /Y >nul

GOTO :final_steps

:: ========
:: SMG2TKGS
:: ========

:SMG2TKGS_custom

echo.
echo This hack works with a 120 stars savefile.
echo The savefiles need to be applied manually.
echo In the "instructions" folder read the "savefiles.txt" 
echo file to know how to apply them.
echo.
echo Copying savefiles to "safefiles" folder...
echo.

xcopy ".\mods\TKGS 1.1.0\SMG2 The Kaizo Green Stars\SaveGame\SB4E01\*" ".\savefiles\" /E /Y >nul

GOTO :final_steps

:: ===
:: NMG
:: ===

:NMG_custom

echo.

set /P nmgdd=Play in Daredevil mode? (y/n): 

set /P nmgreg=Region? (Supported: e=USA, p=PAL, j=JAP): 

echo Applying hex patches... 

if %nmgdd%==y (set ddpatch=Daredevil.patch)

if %nmgdd%==n (set ddpatch=noDaredevil.patch)

if %nmgreg%==e (set NMG[8]=NMGE01)

if %nmgreg%==p (set NMG[8]=NMGP01)

if %nmgreg%==j (set NMG[8]=NMGJ01)

if exist ".\temp\DATA" (%PATCH% ".\temp\DATA\sys\main.dol" < ".\patches\%NMG[8]%_%ddpatch%" >nul)

if not exist ".\temp\DATA" (%PATCH% ".\temp\sys\main.dol" < ".\patches\%NMG[8]%_%ddpatch%" >nul)

echo.

GOTO :final_steps

:: =======
:: SMG64HS
:: =======

:SMG64HS_custom

echo.
echo This mod works with a txt file (Gecko Codes).
echo The file named "M64E01.txt" is in the "codes" folder.
echo Put it in the "codes" folder of your SD card to get
echo the full patch on the game.
echo.

GOTO :final_steps

:: ========
:: SMG2BXDE
:: ========

:SMG2BXDE_custom

echo.

set /P bxdreg=Region? (Supported: e, p, j, k, w): 

echo Applying hex patches... 

if %bxdreg%==e (set SMG2BXDE[8]=BXDE01)

if %bxdreg%==p (set SMG2BXDE[8]=BXDP01)

if %bxdreg%==j (set SMG2BXDE[8]=BXDJ01)

if %bxdreg%==k (set SMG2BXDE[8]=BXDK01)

if %bxdreg%==w (set SMG2BXDE[8]=BXDW01)

if exist ".\temp\DATA\" (%PATCH% ".\temp\DATA\sys\main.dol" < ".\patches\!%mod%[8]!.patch" >nul)

if not exist ".\temp\DATA\" (%PATCH% ".\temp\sys\main.dol" < ".\patches\!%mod%[8]!.patch" >nul)

if exist ".\temp\DATA" (

xcopy ".\mods\!%mod%[6]!\Regions\NTSC (USA)\*" ".\temp\DATA\files\" /E /Y >nul

xcopy ".\mods\!%mod%[6]!\Regions\PAL (Europe)\*" ".\temp\DATA\files\" /E /Y >nul)

if not exist ".\temp\DATA" (

xcopy ".\mods\!%mod%[6]!\Regions\NTSC (USA)\*" ".\temp\files\" /E /Y >nul

xcopy ".\mods\!%mod%[6]!\Regions\PAL (Europe)\*" ".\temp\files\" /E /Y >nul)

echo.

GOTO :final_steps

:: ======
:: SMG2MM
:: ======

:SMG2MM_custom

echo.

set /P mmreg=Region? (Supported: e, p, j, k, w): 

echo Applying hex patches... 

if %mmreg%==e (set SMG2MM[8]=SB4MME)

if %mmreg%==p (set SMG2MM[8]=SB4MMP)

if %mmreg%==j (set SMG2MM[8]=SB4MMJ)

if %mmreg%==k (set SMG2MM[8]=SB4MMK)

if %mmreg%==w (set SMG2MM[8]=SB4MMW)

if exist ".\temp\DATA\" (%PATCH% ".\temp\DATA\sys\main.dol" < ".\patches\!%mod%[8]!.patch" >nul)

if not exist ".\temp\DATA\" (%PATCH% ".\temp\sys\main.dol" < ".\patches\!%mod%[8]!.patch" >nul)

echo.

GOTO :final_steps

:: =======
:: SMG2TLL
:: =======

:SMG2TLL_custom

echo.

set /P tllreg=Region? (Supported: e, p, j): 

set /P tlldd=Play in Daredevil mode? (y/n): 

set /P bluestar=Play with Blue Launch stars? (y/n): 

echo Applying hex patches... 

if %tlldd%==y (set ddpatch=Daredevil.patch)
if %tlldd%==n (set ddpatch=noDaredevil.patch)

if %tllreg%==e (set SMG2TLL[8]=TLLE01)
if %tllreg%==p (set SMG2TLL[8]=TLLP01)
if %tllreg%==j (set SMG2TLL[8]=TLLJ01)

if %bluestar%==y (

if exist ".\temp\DATA" (

xcopy ".\mods\!%mod%[6]!\!%mod%[7]!\SystemData\SuperSpinDriver.arc" ".\temp\DATA\files\ObjectData\" /E /Y >nul
xcopy ".\mods\!%mod%[6]!\!%mod%[7]!\SystemData\SpinDriver.arc" ".\temp\DATA\files\ObjectData\" /E /Y >nul
xcopy ".\mods\!%mod%[6]!\!%mod%[7]!\SystemData\YellowChip.arc" ".\temp\DATA\files\ObjectData\" /E /Y >nul)

if not exist ".\temp\DATA" (

xcopy ".\mods\!%mod%[6]!\!%mod%[7]!\SystemData\SuperSpinDriver.arc" ".\temp\files\SystemData\" /E /Y >nul
xcopy ".\mods\!%mod%[6]!\!%mod%[7]!\SystemData\SpinDriver.arc" ".\temp\files\ObjectData\" /E /Y >nul
xcopy ".\mods\!%mod%[6]!\!%mod%[7]!\SystemData\YellowChip.arc" ".\temp\files\ObjectData\" /E /Y >nul)

)

if exist ".\temp\DATA" (%PATCH% ".\temp\DATA\sys\main.dol" < ".\patches\%SMG2TLL[8]%_%ddpatch%" >nul)

if not exist ".\temp\DATA" (%PATCH% ".\temp\sys\main.dol" < ".\patches\%SMG2TLL[8]%_%ddpatch%" >nul)

GOTO :final_steps