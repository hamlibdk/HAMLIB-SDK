# JTSDK64 Applications and Tools

************************************************************************************
## JTSDK Version 3.2 Stream
************************************************************************************

The Version 3.2 Stream of the JTSDK will perhaps the last 'JT-dedicated JTSDK'.

### Direction

The **JTSDK 3.2.0** evolves the kits from Windows Batch Files towards Windows 
[POWERSHELL][PowerShell]-based scripts. [PowerShell][] is also supported in Mac and 
Linux environs, so common-adaptation for these purposes may occur as the kits evolve. 

This started as an experiment to reduce maintenance (i.e. new package versions). 
The deployment environment ** jtsdk64-setup.ps1** will always require hard-coded 
base package support. Once an environment is set up maintenance tasks are simplified.

[PowerShell][] eclipses the capabilities of Windows Batch files. [PowerShell][] 
completely removes needs for capable third-party environments such as [Python][].

### The Version 3.2.0 Base Stream

The **Version 3.2** stream is a learning, discovery and technique refinement experiment.
This README.md file will transition towards deployment instructions. 

************************************************************************************
**The Project now needs contributors - Especially to write Cross-Language Documentation !**
************************************************************************************

### Project Status

This project is now at the **Release** phase of its life cycle. Primary objectives have 
been met (i.e. [PowerShell][] conversion, Ability to compile latest source code to 
bleeding-edge Hamlib code). 

Future kits will be much smaller in distribution size. You will be required to 
build libraries (i.e. Boost [1.76](Boost-1.76.0)] ) as part of the learning process.
Current packaging preempts known cases of proposed licence and delivery condition changes. 

************************************************************************************
Precompiled drop-in packages for [Boost-1.74.0][], [Boost-1.75.0][] and [Boost-1.76.0][] 
built under Qt's [MinGW][] 7.3 and [MinGW][] 8.1 environs are available (saving 3+ hours). 
************************************************************************************
************************************************************************************
The recommended mainstream development environments are [Qt][] 5.15.2 and [Boost-1.74.0][] working with [MinGW][] 8.1.
************************************************************************************ 

** Note that [WSJT-X 2.3.0][] and [WSJT-X 2.4.0 rc2][] will compile but not package to [Boost-1.75.0][] **

### The Next Steps

Version 4 of the JTSDK will involve strategic re-think. Watch the [JTSDK Forum][] for updates.

### Kit Construction

Most configuration is now based on either marker files in **C:\JTSDK64-Tools\config** 
or specified package versions listed in **C:\JTSDK64-Tools\config\Versions.ini** . 
See the [JTSDK Forum][] and post comments (or email main contributors found there).

### Support

Heads-up advice from developers is essential. We are not 'enemies'; we are just 
inquisitive. **Nobody asked us to do this - Nobody should have to ask in the AR community**. 
Maintainers work on this to learn. We support the development of the skill base 
and hence reputation of Amateur Radio.

### Added Support and Features

The [Tests][] folder  contains bleeding-edge  efforts to translate and improve 
scripts. Some past scripts may not be able to be eliminated easily or in fact be 
converted at all.

Support for following technologies are **added/enhanced** in these streams:

- Hamlib support for other non-JT- software packages (will occur silently???).
- [Qt][]'s incorporated CMAKE
- The version of [Boost][] can be selected in **Version.inf** and will be compiled to the selected version of Qt (including its MinGW release).
- Greater package version self-configuration - hence **less maintenance required**.
- Upgrades to "static" apps that have no generically named latest-version sources

The versions of packages supported are now able to be edited into the kit in one 
place - the **Versions.ini** file. This makes maintenance tasks easier.

### Removed Support 

Support for following technologies are **removed** in these streams:

- [Java][Java Open JDK] (no longer needed)
- Legacies from previous kits such as [Ant][], [Gradle][] and [Maven][].
- [Python][] - hence [Anaconda][], [Miniconda][] and [PyPy][] dependence

### Limitations 

[PowerShell][] has VERY LIMITED support for 'doskeys' deployed in earlier kits. The 
focus will be around [PowerShell][] **commandlets**.

[PowerShell][] scripts are managed to tight security rules. See the section [PowerShell][].

The kits may never be able to move away from CMD Batch files to compile JT- software.

Operational techniques have already evolved  i.e. the need for **qt-gen-tc** has been 
eliminated. Some needed techniques to support 'familiarity' also have limits. Ways that 
processes are executed may change.

************************************************************************************
## PowerShell Security Warnings
************************************************************************************

You may receive the following **security notification**:

```
Execution Policy Change
The execution policy helps protect you from scripts that you do not trust. Changing 
the execution policy might expose you to the security risks described in the 
about_Execution_Policies help topic at https:/go.microsoft.com/fwlink/?LinkID=135170. 
Do you want to change the execution policy?
[Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "N"):
```

It is safe to select **Y**. These scripts are not any processor flaw tests. Remember
that developing these scripts is also a learning exercise for the Development Team.

### Windows Environment Variables 

The basic concept of supporting **Windows Environment Variables** through [PowerShell][] 
**$env:<env-var>** facilities that ease access into CMake, QMake and the MinGW compilers 
will remain a cornerstone concept.

************************************************************************************
## Upgrades
************************************************************************************

The [JTSDK64-Base-3.2.0][] has been reported to work satisfactorily when deployed 
over the top of earlier kits. 

**It is recommended that this kit is deployed into Virtual machines (see "Deployment" section).** 

**It is recommended that new kits be new, fresh installations.** 

************************************************************************************
## Maintenance Updates: "Tools" Packages
************************************************************************************

Maintenance updates will be applied in the form of "Tools" packages. These packages 
are designed to be deployed to existing "Base" packages.

### Application of Maintenance "Tools" packages

"Tools" packages are updates to the "Base" environments.

*These steps assume that you have a deployed base environment*

- Download any "Tools" packages from https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/ 
i.e. Current version: [JTSDK64-Tools-3.2.0.2][]
- Deploy the tools package to your JTSDK install directory.

Updates may apply to the MSYS2 environment. Therefore the "profile" directory for 
MSYS2 should be deleted and re-created.

- (Optional) Back-up any files and folders stored under **C:\JTSDK64-Tools\tools\msys64\home**
- Close any open MSYS2 environment terminal(s).
- Delete folders that exist under **C:\JTSDK64-Tools\tools\msys64\home**
- Re-open MSYS2 with the **msys2** command inside the PowerShell terminal

i.e: PowerShell: ** Remove-Item "C:\JTSDK64-Tools\tools\msys64\home\*" -Recurse -Force **

You will need to pull down your Hamlib repository again and/or restore any custom work 
to folders created within the MSYS2 environment. See Step 3b below.

************************************************************************************
## Deployment
************************************************************************************
 
### Preparation: Deploy a Virtualisation Environment

It is recommended to deploy the JTSDK into a fresh Windows Virtual Machine. For those 
unfamiliar with "Virtual Machines" and "Virtualisation Technologies" you shoud refer to  https://www.redhat.com/en/topics/virtualization/what-is-virtualization .

** Note:** Almost EVERY CPU that Runs Windows x64 these days has virtualisation support.

If you have concerns please refer to https://www.technorms.com/8208/check-if-processor-supports-virtualization . 

There are lots of virtualisation environments available. Click on the links below to 
obtain details on how to deploy these systems:

- [Hyper-V][]
- [VMWare Workstation][] 
- [VMware Player][]
- [Virtual Box][]

Trial Virtual Machine images for Windows 10 (with Microsoft's Compiler Suite) can 
be downloaded from https://developer.microsoft.com/en-us/windows/downloads/virtual-machines/ . 
These Virtual machines should have a lifetime of at least 30 days.
 
### Step 1: Deploy the JTSDK64-Base-3.2.0.exe Installer and any "Tools" packages if they exist
 
** Note that these instructions assumes a fresh Windows 10 Virtual Machine is used **

- Deploy the installer [JTSDK64-Base-3.2.0][] inside a FRESH VM.
- Deploy any "Tools" Packages ( currently [JTSDK64-Tools-3.2.0.2][] ) to your Base Dep,oyment.

It is recommended to use all the initial default settings and file locations.
 
### Step 2: Launch the Installation Environment
 
- Launch the **JTSDK64-Setup** environment from the link on your desktop
- In this environment type: **postinstall**

The following information will be displayed:

```
------------------------------------------------------
  JTSDK64 Tools Post Install/Redeployment Selections
------------------------------------------------------

 At the prompts indicate which components you want to
 install or redeploy.

 For VC Runtimes, OmniRig, Git, MSYS2 and VS Code use
 --> Y/Yes or N/No

 For the Qt Install Selection:

   D / Y = Default ( minimal set of tools )
   F = Full ( full set of tools )
   N = Skip Installation

 NOTE: VC Runtimes, Git, Qt and MSYS2 are mandatory
 to build JT-software.

 Enter Your Install/Redeployment Selection(s):

(required) VC/C++ Runtimes (Y|N) : 
```
- The VC Runtimes are required. Select 'Y'

```
(required) OmniRig (Y|N)         :
```
- The OmniRig is required. Select 'Y'
```
(required) Git-SCM (Y|N)         : 
```
- The Git-SCM is required. Select 'Y'
```
(required) Default Qt (D/Y|F|N)  :
```
Qt Presents a number of options. 'D' or 'Y' Selects a scripted "Default" 
deployment being Qt 5.12.10 as the base. 'F' Deployes Qt 5.10.12, 5.14.2 
and 5.15.2. 

- Qt is required. Select 'Y'/'D' or 'F' (note:'Y' or 'D' is recommended)
```
(required) MSYS2 Setup (Y|N)     :
```
- You are required to set up the MSYS2 environment. Select 'Y'
```
(optional) VS Code (Y|N)         :
```
This is the only optional component. VS Code is an excellent tool for working with 
PowerShell scripts (if you need to customise these yourself).

Note that deploying VS Code is not mandatory for JTSDK operation.

- Select 'Y' or 'N'

You are then presented with the selections you have made:
```
* Your Installation Selections:

  --> VC Runtimes .: Y
  --> OmniRig .....: Y
  --> Git .........: Y
  --> Qt ..........: Y
  --> MSYS2 .......: Y
  --> VS Code .....: Y
```

During this phase some tools will require some interaction at the keyboard or via the 
mouse (especially the Qt deployment as one MUST now have their own account and agree 
to their licensing terms).
************************************************************************************
Follow on-screen prompts carefully.
************************************************************************************ 
#### Step 2a: Prepare the MSYS2 Environment
 
A MSYS2 environment window will open as part of the **postinstall** process. 
```
JTSDK64 Tools MSYS2 using QT v

For main menu, type ..: menu
For Help Menu, type ..: jthelp

Copyright (C) 2013-2021, GPLv3, Greg Beam, KI7MT and Contributors.
This is free software; There is NO warranty; not even
for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

hamlibdk@jtsdk ~
$ menu
```
- Type: **menu**
```
-------------------------------------
JTSKD64 Tools Main Menu
------------------------------------

 1. List help commands
 2. Update MSYS2
 3. Install Hamlib dependencies
 4. Update MSYS2 Keyring
 5. Build Hamlib - Static Libraries
 6. Build Hamlib - Dynamic Package
 7. Clear Hamlib Source
 8. Select HAMLIB Repository
 9. Print version information

 e. Enter 'e' or 'q' to exit

Enter your selection, then hit <return>:
```
 
#### Step 2b: Update the  MSYS2 Environment
 
- Select **2. Update MSYS2** to update the MSYS2 environment. 

Note that the window may close on completion if there are updates. 

- If the MSYS2 Window closes reopen it within the **JTSDK64-Setup** environment with **msys2**

- Repeat this step until there are no more updates available.
 
#### Step 2c: Update the  MSYS2 Environment
 
- If the MSYS2 Window closes reopen it within the **JTSDK64-Setup** environment with **msys2**

- Back at menu, **3. Install Hamlib Dependencies** to deploy the tools and libraries needed to build Hamlib.
 
#### Step 2d: Basic Deployment Complete

Once complete you can exit the **JTSDK64-Setup** environment (i.e. close the **JTSDK64-Setup** and any MSYS2 terminal shells) 
 
### Step 3: Set Up The Main Tools Environment
 
- Launch the **JTSDK64-Tools** environment from the icon on your desktop.
 
#### Step 3a: (Optional) Upgrade your Qt Deployment
 
The Minimal Qt installer script pegs at Qt at version 5.12.10. If you did not use the "F" Full option for QT deployment or you 
want to update Qt to the more contemporary 5.15.2 version you should do so now. Note that using Qt 5.15.2 is highly recommended.

i.e. 

- Navigate to the Qt Deployment directory
- Run the Qt Maintenance Tool from your Qt deployment directory (i.e. **C:\JTASK64-Tools\tools\Qt**)

To add Qt 5.15.2:

- Add Qt 5.15.2 MinGW.
- Add Developer and Designer Tools / MinGW 8.1.0 64-bit
- (Optional) Add the OpenSSL 1.1.1x toolkit (it helps with a WSJTX download).

On Completion:

- Adjust the maker file in **C:\JTSDK64-Tools\config** marker file to match the Qt version that you want to use 
- i.e. rename **qt5.12.10** to **qt5.15.2**

************************************************************************************
There must only be ONE marker file for QT in **C:\JTSDK64-Tools\config**

If the system abends with a warning check the **C:\JTSDK64-Tools\config** directory and remove the unwanted item with the prefix 'qt'
************************************************************************************

#### Step 3b: Deploy Hamlib for our selected Qt Version.
 
In **JTSDK64-Tools**:

- Launch the MSYS2 environment with: **msys2**
- Type: **menu**
- Select **5. Build Hamlib - Static Libraries**

This will take time as it pulls from the master repository for Hamlib. Repositories can be changed. by changing the marker files in **C:\JTSDK64-Tools\config** (i.e. from .. **hlmaster** to **hlw4mdb**, **hlg4wjs** or **hlnone** for no default pull and update).

#### Step 3c: Deploy Boost for our selected Qt/MinGW Version.
 
***THIS IS SLOW***. There are "dropins" available on the Sourceforge and GitHub sites if you are lazy. Yet the best procedure is to build your own.

In JTSDK64-Tools:

- Type: **Deploy-Boost**

Around 90 minutes later you should now have a deployment of Boost based at the recommended v1.74.0 (configurable in **C:\JTSDK64-Tools\config\Versions.ini**) that is suitable to build JT-software under your selected Qt version on your machine.

************************************************************************************
Pre-compiled drop-in Packages for [Boost-1.74.0][], [Boost-1.75.0][] and [Boost-1.76.0] are available at the time of writing.

Each “drop-in” package has folders i.e. 1.74.0-7.3 for [MinGW][] 7.3 (pre-Qt 5.15) and 1.74.0-8.1 (for post-Qt 5.15 including the 6.x.x streams). 
 
- Extract the folder for the Boost version-package that you want to use into **C:\JTSDK64-Tools\tools\boost** (create the directory if it does not exist) and then remove the -7.3 or -8.1 suffix ! 

A Windows symbolic link will work too: i.e.: Assume that both the 1.74.0-7.3 and 1.74.0-8.1 distributions have been unpacked from **Boost-1.74.0-MinGW-v7.3-v8.1.7z** to **C:\JTSDK64-Tools\tools\boost** . Assume that the command shell or powershell windows are positioned at **C:\JTSDK64-Tools\tools\boost**
 
- Cmd:** mklink /D 1.74.0 1.74.0-8.1 **
- PowerShell:** New-Item -ItemType SymbolicLink -Path C:\JTSDK64-Tools\tools\boost\boost-1.74.0 -Value C:\JTSDK64-Tools\tools\boost\boost-1.74.0-8.1 **
 
The preference is to build your own Boost package and NOT use these ! ** Warning: Boost does not build 100% properly and to full capability under MinGW/MSYS2 environments that we use – yet its good enough for our purposes !**
************************************************************************************
A script **Reset-Boost.ps1** is available in the [Tests][] folder (and from [Tools 3.2.0.3][JTSDK64-Tools-3.2.0.3] onwards) to reset any failed attempts at building Boost.
************************************************************************************

#### Step 3d: Environments should now be complete for building JT- software
 
Now that seemed a lot of work. Please dissect these scripts to see what actually took place !
 
### Step 4: Build your JT- Software
 
Now we are ready to BUILD a JT-release. 

The release-source-code pulled is for the latest JT-software release. The JT-source that you pull is configurable from **C:\JTSDK64-Tools\config**. Rename the file **src-wsjtx** from a default pull of WSJT-X to either **src-jtdx** or **src-js8call** if desired. 

The "major" used distros are supported without discrimination or political comment.

In JTSDK64-Tools:

- Type: **jtbuild** <option>     i.e. **jtbuild package**
 
Options preferred are package (a Windows Installer package - the preferred "clean" way) and rinstall (just a static directory full of "runnable" files).

************************************************************************************
## Contributions
************************************************************************************

### How Can I Help?

Please test these scripts and those in the [Tests][] folder. Report observations either 
via the [JTSDK Forum][] or the email address where most most messages come from (if 
you cannot post). The [JTSDK Forum][] is used somewhat as as 'blog' as information in 
there is too valuable for the general IT community.

***The 'core team' behind this are not PowerShell gurus.*** This is a learning effort. 
If you are a PowerShell Guru PLEASE PLEASE PLEASE jump in and comment to assist. Send 
back BETTER SCRIPT. **Teach us all**. 

We especially require people to make these README.MD scripts better !

** ALL CONTRIBUTIONS AND COMMENTS ARE GRATEFULLY WELCOMED ** !

### Bug Reports

For submitting bug reports and feature requests, use the [Issue Tracker][]. 

Reports, suggestions and comments via the [JTSDK Forum][] - or via the email addresses 
from main contributors there of late if you do not have post access - are essential.

************************************************************************************
## Conclusion and Further References
************************************************************************************

The aim of **JTSDK64-Tools** is to use an Agile delivery approach to create a
high-quality, yet flexible build system. 

Base ref: https://sourceforge.net/projects/jtsdk/files/win64/3.1.0/README.md

[Open Source]: https://opensource.com/resources/what-open-source
[WSJT]: http://physics.princeton.edu/pulsar/K1JT/
[WSJT-X]: http://physics.princeton.edu/pulsar/K1JT/wsjtx.html
[JTDX]: https://jtdx.tech/en/
[JS8CALL]: http://js8call.com/ 
[OmniRig]: http://dxatlas.com/OmniRig/Files/OmniRig.zip 
[MAP65]: http://physics.princeton.edu/pulsar/K1JT/map65.html
[WSPR]: http://physics.princeton.edu/pulsar/K1JT/wspr.html
[MSYS2]: https://www.msys2.org/
[MinGW]: http://www.mingw.org/
[Qt]: https://www.qt.io/download-open-source 
[PowerShell]: https://docs.microsoft.com/en-us/powershell/
[Ant]: https://ant.apache.org/
[Gradle]: https://gradle.org/
[Maven]: https://maven.apache.org/
[PostgreSQL]: https://www.postgresql.org/
[Python]: https://www.python.org/
[Anaconda]: https://www.anaconda.com/products/individual
[PyPy]: https://www.pypy.org/
[Miniconda]: https://docs.conda.io/en/latest/miniconda.html
[Dotnet Core SDK]: https://docs.microsoft.com/en-us/dotnet/core/sdk
[Java]: https://www.java.com/en/
[Java Open JDK]: https://adoptopenjdk.net/
[InnoSetup]: http://www.jrsoftware.org/isinfo.php
[Hamlib]: https://hamlib.github.io/
[JTSDK Sourceforge]: https://sourceforge.net/projects/jtsdk/files/win64/3.1.0/
[JTSDK Forum]: https://groups.io/g/JTSDK/messages
[JTSDK64-Tools-3.1.0]: https://sourceforge.net/projects/jtsdk/files/win64/3.1.0/jtsdk64-tools-3.1.0.exe
[JTSDK64-Apps-3.1.0.2]: https://sourceforge.net/projects/jtsdk/files/win64/3.1.0/jtsdk64-apps-3.1.0.2.exe
[JTSDK64-Tools-3.1.1.2]:https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.1.1-x64-Stream/JTSDK64-Tools-3.1.1.2.exe
[JTSDK64-Apps-3.1.1]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.1.1-x64-Stream/JTSDK64-Apps-3.1.1.exe
[JTSDK64-Base-3.2.0]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/JTSDK64-Base-3.2.0.exe
[JTSDK64-Tools-3.2.0.1]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/JTSDK64-Tools-3.2.0.1.exe
[JTSDK64-Tools-3.2.0.2]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/JTSDK64-Tools-3.2.0.2.exe
[JTSDK64-Tools-3.2.0.3]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/JTSDK64-Tools-3.2.0.3.exe
[Git]: https://git-scm.com/
[VS Code]: https://code.visualstudio.com/Download
[Issue Tracker]: https://sourceforge.net/p/hamlib-sdk/tickets/
[Package Updates]:https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.1.1-x64-Stream/Package-Updates/
[Boost]: https://www.boost.org/
[Boost-1.74.0]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/Boost-1.74.0-MinGW-v7.3-v8.1.7z
[Boost-1.75.0]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/Boost-1.75.0-MinGW-v7.3-v8.1.7z
[Boost-1.76.0]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/Boost-1.76.0-MinGW-v7.3-v8.1.7z
[JTSDK64-Apps-3.1.1-Boost-1.74-MinGW-8.1x64]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.1.1-x64-Stream/JTSDK64-Apps-3.1.1-Boost-1.74-MinGW-8.1x64.exe
[WSJT-X Support Forum]: mailto://wsjt-devel@lists.sourceforge.net
[Tests]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/Tests/
[WSJT-X 2.2.2]:https://physics.princeton.edu/pulsar/k1jt/wsjtx-2.2.2.tgz
[WSJT-X 2.3.0]: http://physics.princeton.edu/pulsar/K1JT/wsjtx-2.3.0.tgz 
[WSJT-X 2.4.0 rc2]: https://physics.princeton.edu/pulsar/k1jt/wsjtx-2.4.0-rc2.tgz
[JTSDK-Tools-3.1.1.3b2.exe]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.1.1-x64-Stream/Deprecated/JTSDK64-Tools-3.1.1.3b2.exe
[JTSDK64-All-3.2.0a7.exe]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/Archive/JTSDK64-All-3.2.0a7.exe
[Archive]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/Archive/
[Fl-Apps]: https://sourceforge.net/projects/fldigi/files/
[DotNET SDK]: https://dotnet.microsoft.com/download
[Powershell Section]: https://sourceforge.net/projects/hamlib-sdk/files/Programming/PowerShell/
[Windows VM]: https://developer.microsoft.com/en-us/windows/downloads/virtual-machines/
[Hyper-V]: https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v
[VMWare Workstation]: https://kb.vmware.com/s/article/2057907
[VMware Player]: https://kb.vmware.com/s/article/2053973
[Virtual Box]: https://www.virtualbox.org/wiki/Downloads
[QEmu]: https://www.qemu.org/download/