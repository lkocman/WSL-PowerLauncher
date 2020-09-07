# WSL-PowerLauncher

## Why?
ARM enablement for openSUSE. All openSUSE WSL images are currently build in Open Build Service (https://build.opensuse.org).

WSL-DistroLauncher can't be cross-compiled to Windows on ARM at this moment as ming64 cross-compiler suite is only available for x86_64.# WSL-PowerLauncher.

Having a platform agnostic DistroLauncher would solve our problems. Unfortunately Microsoft is not shipping PowreShell for ARM on Windows for ARM https://github.com/microsoft/WSL/issues/5871, therefore you have to download it from powershell's github page. 
