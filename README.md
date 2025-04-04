# JTSDK64 Applications and Tools

************************************************************************************
## JTSDK Version 4.0 Stream
************************************************************************************

The **Version 4.0** stream is a learning, discovery and technique refinement experiment.

### Direction

The **JTSDK 4.0.0** matures the evolution of the kits from Windows Batch Files towards Windows 
[PowerShell][]-based scripts. [PowerShell][] is also supported in Mac and 
Linux environs, so common-adaptation for these purposes may occur as the kits evolve.

An immediate aim is to also provide Windows aarch64 kits. Please watch this space.

This started as an experiment to reduce maintenance (i.e. new package versions). 
The deployment environment **jtsdk64-setup.ps1** will always require hard-coded 
base package support. Once an environment is set up maintenance tasks are simplified.

[PowerShell][] eclipses the capabilities of Windows Batch files. [PowerShell][] 
completely removes needs for capable third-party environments such as [Python][].

### Release Notes: 4.0 Stream

As of [JTSDK64-3.4.0][] there are no longer distinctions between "Base" and "Tools" packages. There will just me "Main Releases" and "Updates".

- Under the [JTSDK64-3.2-Stream][] the "Base Package" was [JTSDK64-Base-3.2.3][]. Under the JTSDK64-4.0-Stream the former "Base" deployment package will become [JTSDK64-4.0.0][].
- Under the [JTSDK64-3.2-Stream][] the "Patch Package" was  [JTSDK64-Tools-3.2.3.3][]. Under the JTSDK64-4.0-Stream the "Update" packages will become/is [JTSDK64-4.0.0-U1][].

The Main deployment package - [JTSDK64-4.0.0][] - can be downloaded at https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-4.0-Stream/JTSDK64-4.0.0.exe

The Update deployment package - [JTSDK64-4.0.0-U1][] - can be downloaded at https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-4.0-Stream/JTSDK64-4.0.0-U1.exe

This README.md file includes deployment instructions. The very latest news - including tips 
to solve issues - can be found at https://hamlib-sdk.sourceforge.io/ .

The **JTSDK 4.0.0** walks back some of the Qt deployment automation removed in [JTSDK64-3.4.1][] . 

There are also updates to some utilities and Libraries (i.e. NSIS 3.09, Updates to Ruby, LibUSB bumped to Version 1.0.27).

Outwardly this stream will initially appear similar to past kits. Yet the **JTSDK 4.0.0** 
demonstrates significant enhancements and script redesigns.

[JTSDK64-4.0.0][] ships with with basic **[MSYS2][]** and **mingw64** compilers and tools pre-deployed.

This kit only supports the construction of 64-bit software.

Future releases will aim to deploy Windows aarch64-based kits. 

The preferred [MSYS2][] development environment for building Hamlib is now executed by typing 
**mingw64** at the [PowerShell][] prompt.

### Release Notes: Updates

Currently there are no Update packages available. The first update package for this stream would be An update package [JTSDK64-4.0.0-U1][].

************************************************************************************
**The Project needs contributors - Especially for management and to write Cross-Language Documentation !**
************************************************************************************
## Up To Date Documentation
************************************************************************************

The most up-to date documentation and bleeding-edge notes can be found at:

- https://hamlib-sdk.sourceforge.io/  <== The **Base Site** and the first place to look for information
- https://groups.io/g/JTSDK/	<== The Help Forum

### Project Status

This project is now at the **Release** phase of its life cycle. Primary objectives have 
been met (i.e. [PowerShell][] conversion, Ability to compile latest source code to 
bleeding-edge Hamlib code). 

Future kits will be much smaller in distribution size. You will be required to 
build libraries (i.e. [Boost 1.85](Boost-1.85.0) ) as part of the learning process.

Current packaging preempts known cases of proposed licence and delivery condition changes. 

************************************************************************************
Precompiled drop-in packages are no longer available as Sourceforge, our project host, are auditing space.  
************************************************************************************
The recommended development environment should be [JTSDK64-4.0.0][] with the latest update [JTSDK64-4.0.0-U1][] applied. 
************************************************************************************ 

### Conventions used in this document.

Drive paths will be referred to as x: (i.e. **x:\JTSDK64-Tools\config**) , where **x:** is the default deployment drive 

- x: as used in this guide in most cases can be replaced with c:

### Kit Construction

The kit is derived from techniques first documented by Greg KI7MT.

Most configuration is now based on either marker files in **x:\JTSDK64-Tools\config** 
or specified package versions listed in **x:\JTSDK64-Tools\config\Versions.ini** . 
See the [JTSDK Forum][] and post comments (or email main contributors found there).

### Support

Heads-up advice from developers is essential. We are not 'enemies'; we are just 
inquisitive. **Nobody asked us to do this - Nobody should have to ask in the AR community**. 
Maintainers work on this to learn. We support the development of the skill base 
and hence reputation of Amateur Radio.

### Added Support and Features

The [Tests][] folder contains bleeding-edge efforts to translate and improve 
scripts. Some past scripts may not be able to be eliminated easily or in fact be 
converted at all.

Support for following technologies are **added/enhanced** in these streams:

- Hamlib support for other non-JT-software packages (will occur silently???).
- [Qt][]'s incorporated [CMAKE][] is now the recommended [CMAKE][] tool.
- The version of [Boost][] can be selected in **Version.ini** and will be compiled to the selected version of Qt (including its MinGW release).
- Greater package version self-configuration - hence **less maintenance required**.
- Upgrades to "static" apps that have no generically named latest-version sources
- Versions of Qt 5 and 6 to be deployed can be set in keys within **Version.ini** , saving considerable amounts of time maintaining respurces (i.e. when the Qt Maintainers update packages that are available to Open Sorce users)
- PowerShell by default is set a PowerShell Windows 5.1. This can be actively changed to the latest deployable package by setting a key within **Version.ini**

The versions of packages supported are now able to be edited into the kit in one 
place - the **Versions.ini** file. This makes maintenance tasks easier.

### Limitations 

[PowerShell][] scripts are managed to tight security rules. See the next section.

Operational techniques have already evolved  i.e. the need for **qt-gen-tc** has been 
eliminated. Some needed techniques to support 'familiarity' also have limits. Ways that 
processes are executed may change.

************************************************************************************
## [PowerShell][] Security Warnings
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
**$env:<env-var>** facilities that ease access into [CMAKE][], QMake and the MinGW compilers 
will remain a cornerstone concept.

************************************************************************************
## Upgrades from Versions earlier than Version 4.0.0
************************************************************************************

The [JTSDK64-4.0.0][] cannot be installed over the top of previous kits.

**A new, fresh deployment be considered with this release.**

Should you try an upgrade, you may need to back-up/re-name your **X:\JTSDK64-Tools\tools\msys64** environment if you are performing an upgrade.

i.e: 

- Close any open JTSDK64-Tools and MSYS2 Terminal Windows.
- Before starting the upgrade, open a Windows File Manager instance.
- Navigate to **X:\JTSDK64-Tools\tools\**
- Using the Windows File Manager, rename the **msys64** directory to something like **msys64-orig**

If you need to revert back to your old deployment then all you need do is rename that folder back to its original filename (i.e. **C:\JTSDK64-Tools-orig** back to **C:\JTSDK64-Tools**) 

You should, after deployment, be able to recover anything that you need from your MSYS2 user profile to your new MSYS2 deployment. 

**It is recommended that kits are deployed into Virtual machines (see "Deployment" section).** 

************************************************************************************
## Maintenance Updates
************************************************************************************

Maintenance updates will be applied in the form of **Update** packages when necessary. These packages 
are designed to be deployed to an existing deployment within the same stream.

An **Update** package can only be applied to a matching release. i.e. You cannot apply a 
[JTSDK64-3.4.1-U1][] package to a [JTSDK64-Base-3.2.1][] - based deployment without experiencing significant issues.

### Application of Maintenance **Update** packages

**Update** packages are updates to the **Main Deployments**.

**Note:** These steps assume that you have a deployed base environment.

- Download the latest **Update** packages from https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-4.0-Stream/ 

************************************************************************************
The current update deployment package - [JTSDK64-4.0.0-U1][] - can be downloaded at https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-4.0-Stream/JTSDK64-4.0.0-U1.exe
************************************************************************************

- Deploy the **Update** package [JTSDK64-4.0.0-U1][] to your JTSDK install directory.

Updates may be required for the [MSYS2][] environment. Therefore the "profile" directory for 
[MSYS2][] may be deleted and re-created.

Before any updates (manual from "[Tests][]" or from a **Tools** package) you should backup your [MSYS2][] Environment:

- Copy any folders stored under **x:\JTSDK64-Tools\tools\msys64\home** to a backup location. This should enable you to access previous work.
- Close any open [MSYS2][] environment terminal(s).
- Perform the system upgrade.
- Delete folders that exist under **x:\JTSDK64-Tools\tools\msys64\home**

i.e: [PowerShell][]: **Remove-Item "C:\JTSDK64-Tools\tools\msys64\home\*" -Recurse -Force**

- Re-open [MSYS2][] with the **[MSYS2][]** command inside the [PowerShell][] terminal

**Note:** The **src** directory in your backup should contain your previous work. It 
is safe to copy this enture folder across to your new [MSYS2][] Profile.

You will need to pull down your Hamlib repository again and/or restore any custom work 
to folders created within the [MSYS2][] environment. See Step 3b below.

************************************************************************************
## Deployment
************************************************************************************
 
### Preparation: Deploy a Virtualisation Environment

It is recommended to deploy the JTSDK into a fresh Windows Virtual Machine. For those 
unfamiliar with "Virtual Machines" and "Virtualisation Technologies" you shoud refer to 
https://www.redhat.com/en/topics/virtualization/what-is-virtualization .

**Note:** Almost EVERY CPU that runs Windows x64 these days has virtualisation support.

If you have concerns please refer to https://www.technorms.com/8208/check-if-processor-supports-virtualization . 

There are lots of virtualisation environments available. Click on the links below to 
obtain details on how to deploy these systems:

- [Hyper-V][] - See https://gist.github.com/HimDek/6edde284203a620745fad3f762be603b  
- [VMWare Workstation][] - See https://blogs.vmware.com/workstation/2024/05/vmware-workstation-pro-now-available-free-for-personal-use.html
- [Virtual Box][] - See https://www.virtualbox.org/wiki/Downloads

Trial Virtual Machine images for Windows (with Microsoft's Compiler Suite) may be available from 
https://developer.microsoft.com/en-us/windows/downloads/virtual-machines/ . 
These Virtual machines should have a lifetime of at least 30 days.

### Pre-Requisite: Windows Profiles/Logins must not contain spaces

**IMPORTANT:** The Windows Login Account/Profile must **NOT HAVE SPACES IN IT**.

- Valid user logins/profiles include HAMLIBSDK and HAMLIB_SDK .
- An example of an invalid user profile is HAMLIB SDK as it contains a space.

The following procedure (supplied by Joe K0OG) can be used to fix this problem:

- Delete any previous attempts at creating the user profile under X:\JTSDK64-Tools\Tools\msys64\home
- Press Windows key + X key.
- Click on Control Panel.
- Under view, select large icons.
- Go to User Account.
- Click on Manage another account.
- Select the User Account for which you want to select the password.
- Click on Change the username.
- Click on Change Name button.
- Reboot
- Log back in under the NEW User Profile (with simplified username)
- Restart JTSDK64-Tools / mingw64

This will recreate the new profile and should permit successful builds.]

### Pre-Requisite: Ensure that the latest WSJT-X and/or JT-ware Release is deployed

Due to changes within CMake from version 3.28.0 onwards, it may be necessary to have a current deployment of WSJT-X and/or your JT-ware variant that you are working on deployed and **IN THE SEAERCH PATH**.

Obtain a current release version of your product from:

- WSJTX: https://wsjt.sourceforge.io/wsjtx.html
- JTDX: https://sourceforge.net/projects/jtdx/
- JS8Call: http://js8call.com/

**Install it so that it can be found in the search path.***

**Update**

As of **JTSDK 3.4.1** a folder **extras** now exists within **X:\JTSDK64-Tools\tools**.

- i.e. x:\JTSDK64-Tools\tools\extras

DLL's and other components thta may be missing during builds can be placed within that folder.

The most common "missing" component needed to build WSJTX is **libgfortran-4.dll** . 
This DLL may be copied and placed into that folder, negating the need for deployment of latest supplied installers.

### Step 1: Deploy the JTSDK64-4.0.0.exe Installer and any available Update Packages
 
** Note that these instructions assumes a fresh Windows 10 or 11 Virtual Machine is used **

- Deploy the **Release** installer [JTSDK64-4.0.0][] inside a FRESH, FULLY UPDATED WINDOWS 10 or 11 VM.
- Deploy the latest **update** Package to your installation i.e. [JTSDK64-4.0.0-U1][]

It is recommended to use all the initial default settings and file locations.
 
### Step 2: Launch the Installation Environment
 
- Launch the **JTSDK64-Setup** environment from the link on your desktop.

A screen similar to the following should eventually appear:

```
-------------------------------------------
          JTSDK Setup v4.0.0.1
-------------------------------------------

  Required Tools

     PowerShell ..... 5.1.22621.2506
     VC Runtimes .... Not Installed
     Git ............ Not Installed
     OmniRig ........ Not Installed

  Qt Tool Chain(s) Deployed

    Qt: none

    Tools: none

  Optional Components

     VS Code ........ Not Installed
     Boost .......... Not Installed

  Post Install / Manual Setup Commands

     Main Install ... postinstall
     MSYS2 Shell .... msys2

PS C:\JTSDK64-Tools>
```

- At the PowerShell prompt type: **postinstall**

The following information will be displayed:

```
------------------------------------------------------
  JTSDK64 Tools Post Install/Redeployment Selections
------------------------------------------------------

At the prompts indicate which components you want to
 install or redeploy.

 For VC Runtimes, OmniRig, Git, MSYS2 and VS Code use
 --> Y/Yes or N/No

 For Qt Installations:

   Y = Default ( 6.6.3 )
   N = Skip Installation

   Qt 5.15.2 must be deployed from Archive using the
   Qt Maintenance Tool.

 NOTES: VC Runtimes, Git, Qt & MSYS2 are mandatory to
 build JT-software.

 The Latest PowerShell is highly recommended for
 improved performance.

* Enter Your Install/Redeployment Selection(s):

 (required) Latest PowerShell (Y|N) .: 
```
- The latest PowerShell (i.e. PowerShell 7) is highly recommended as it has considerable performance benefits. Select 'Y' even if you already have it deployed. 

**Note:** PowerShell 7 and PowerShell 5.1 (as supplied with WIndows 10/11) are not necessarily backwardly compatible.

--> PowerShell should be updated to the latest available version (quietly).
```
(required) VC/C++ Runtimes (Y|N) ..: 
```
- The VC Runtimes are required. Select 'Y'

```
(required) OmniRig (Y|N) ..........:
```
- The OmniRig is required. Select 'Y'
```
(required) Git-SCM (Y|N) ..........: 
```
- The Git-SCM is required. Select 'Y'

The display in the next option is dependent upon the version of Qt that you have configured to be script deployed in **Versions.ini**:
```
(required) Qt 6.6.3 (Y|N) ..........:
```
************************************************************************************
**Since initial release Qt 5.15.2 is not avaialble except through "Archive"** 

As a result Qt deployments are no longer scripted. This means that, as a minimum, you will need to deploy the Qt toolchain and its recommended MinGW support packages.

i.e. [Qt][]5.15.2 requires the [MinGW][]8.1 toolchain.

There is a document at https://hamlib-sdk.sourceforge.io/Qt/ADQT.html that is intended to be used 
as a guide for Qt 5.15.2 from Archive Repos.
************************************************************************************
**If you select "Y" the deployment is scripted.** Some user input is required.

**Deployments typically are made to x:\Qt** . 

A Junction is now placed into the Toolkit in **x:\JTSDK64-Tools\tools** to allow seamless access to the Qt toolkit from the JTSDK.

If "N" is selected then an additional option is made available:

```
 (required) Qt 6.6.3 (Y|N) ..........: n
 --> Create link to Qt (Y|N) ........:
```

If "Y" is selected the system will search for Qt deployments and allow you to set up a link to a
custom Qt deployment.

************************************************************************************

The kit will not function if a Qt toolchain and MinGW environment is not deployed.

- Select 'Y'
```
(required) MSYS2 Setup (Y|N) ......:
```
- You are required to set up the [MSYS2][] environment. Select 'Y'
```
(optional) VS Code (Y|N) ..........:
```
This is the only optional component. VS Code is an excellent tool for working with 
[PowerShell][] scripts (if you need to customise these yourself).

Note that deploying VS Code is not mandatory for JTSDK operation.

- Select 'Y' or 'N'

You are then presented with the selections you have made:
```
* Your Installation Selections:

  --> Latest PowerShell .............: Y
  --> VC Runtimes ...................: Y
  --> OmniRig .......................: Y
  --> Git ...........................: Y
  --> Qt ............................: Y
  --> MSYS2 .........................: Y
  --> VS Code .......................: Y
```

During this phase some tools will require some interaction at the keyboard or via the 
mouse (especially the Qt deployment as one MUST now have their own account and agree 
to their licensing terms).
************************************************************************************
Follow on-screen prompts carefully.
************************************************************************************ 
**Step 2a: Prepare the [MSYS2][] Environment**
 
A [MSYS2][] environment window will open as part of the **postinstall** process. 
```
JTSDK64 Tools MSYS2 (MSYS)

For main menu, type ..: menu
For Help Menu, type ..: jthelp

Copyright (C) 2013-2025, GPLv3, Greg Beam, KI7MT and Contributors.
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

 1. Set MSYS2 path to find Qt compilers
 2. Update MSYS2
 3. Install Hamlib dependencies
 4. Install msys64 GNU Compilers
 5. Install FL-app dependencies
 6. Update MSYS2 Keyring (Deprecated)
 7. Build Hamlib - Static Libraries
 8. Build Hamlib - Dynamic Package
 9. Add Hamlib to pkgconfig
 a. Clear Hamlib Source
 b. Select HAMLIB Repository
 h. List help commands
 v. List version information

 e. Enter 'e' or 'q' to exit

Enter your selection, then hit <return>:
```
 
**Step 2b: Update the [MSYS2][] Environment**
 
- Select **2. Update MSYS2** to update the [MSYS2][] environment. 

The window may close on completion if there are updates. 

- If the [MSYS2][] Window closes reopen it within the **JTSDK64-Setup** environment by typing **[MSYS2][]** at the [PowerShell][] environment prompt.

- If the update process requests that you close the open **[MSYS2][]** terminal then close the window. Re-open the environment by typing **[MSYS2][]** at the [PowerShell][] environment prompt.

- Repeat these steps if neceessary until there are no more updates available.
 
**Step 2c: Update the [MSYS2][] Environment (again)**
 
***As of [JTSDK64-Base-3.2.3][] these steps are now already performed for you. It is still recommended that you go through these steps just in case any dependencies have changed. ***
 
- If the [MSYS2][] Window closes reopen it within the **JTSDK64-Setup** environment with **[MSYS2][]**

- Back at menu, select **3. Install Hamlib Dependencies** to deploy the tools and libraries needed to build Hamlib.

- When Option 3 has completed, Select ** 4. Install msys64 GNU Compilers ** so that a msys64 POSIX-compliant build environment can be launched.

- (optional) - Select Option Select ** 5. Install FL-app dependiencies (Experimental) ** so that a tools that can be used to experiment with the construction of [Fl-Apps][] can be deployed..
 
**Step 2d: Basic Deployment Complete**

Once complete you can exit the **JTSDK64-Setup** environment (i.e. close the **JTSDK64-Setup** and any [MSYS2][] terminal shells) 
 
### Step 3: Set Up The Main Tools Environment
 
- Launch the **JTSDK64-Tools** environment from the icon on your desktop.
 
**Step 3a: Upgrade your Qt Deployment**
 
A Minimum Qt installation pegs at [Qt][] at version 5.15.2. If you did not use the "F" Full option for [Qt][] deployment or you 
want to add additional Qt versions - i.e. test Qt 6.7.2 - you should do so now. 

**The use of Qt 5.15.2 is the Qt deployment for JT-ware. Qt6 streams are not yet supported for mainstream JT-ware compiles.**

**It is not recommended that versions of Qt below Qt 6.3.2 / MinGW 11.2 be used in this JTSDK**

To Deploy Qt 5.15.2 from the "Archive" repository:

- For the latest documentation please refer to: https://sourceforge.net/projects/hamlib-sdk/files/JTware-Deployment/Deploying-Archived-Versions-of-Qt-via-Maintenance-Tool.docx

To add an additional version of Qt to the default Qt 5.15.2 version:

- Navigate to the Qt Deployment directory
- Run the Qt Maintenance Tool from your Qt deployment directory (i.e. **C:\JTASK64-Tools\tools\Qt**)

To add Qt 6.7.2 manually:

- Add Qt 6.7.2 MinGW
- Ensure that components Qt 6.7.2/MinGW 13.1.0 64 bit and Qt 6.7.2/Qt5 Compatability Module are added.
- Select Qt 6.7.2/All Additional Libraries .
- Add Developer and Designer Tools / MinGW 13.1.0 64-bit
- (Recommended) Add the OpenSSL 1.1.1x toolkit (it helps with a WSJTX download - if it is still available).
- (Recommended) Add the OpenSSL 3.x.1x toolkit (Future Enhancement).

On Completion:

- Adjust the maker file in **x:\JTSDK64-Tools\config** marker file to match the Qt version that you want to use 
- i.e. rename **qt5.15.2** to **qt6.7.2**

************************************************************************************
There must only be ONE marker file for Qt in **x:\JTSDK64-Tools\config**

If the system abends with a warning check the **x:\JTSDK64-Tools\config** directory and remove the unwanted item with the prefix 'qt'
************************************************************************************

**Step 3b: Deploy Hamlib for our selected Qt Version.**
 
In **JTSDK64-Tools**:

- Launch the [MSYS2][] environment with: **mingw64**
- Type: **menu**
- Select **8. Build Hamlib - Dynamic Libraries**

************************************************************************************
**Note:** If you have difficulties packaging [Hamlib][] with [JTDX][] and/or [JS8CALL][] you may need to use the The **build-hamlib.sh** script from the [MSYS2][] mingw64 terminal as follows:

- **build-hamlib.sh -nlibusb -static**
************************************************************************************

This will take time as it pulls from the master repository for Hamlib. 

Source distribution repositories can be changed by changing the marker file in **x:\JTSDK64-Tools\config** 

- Valid options are: **hlmaster** (default and recommended), **hlw4mdb** (legacy) or **hlnone** for no default pull and update.

**Step 3c: Deploy Boost for our selected Qt/MinGW Version.**
 
***THIS IS SLOW***. There are "dropins" available on the Sourceforge and GitHub sites if you are lazy. Yet the best procedure is to build your own.

************************************************************************************
**Note:** Using PowerShell 7 instead of the default PowerShell Windows 5.1 can speed up the download and decompress stages considerably. 

This is adjusted using the key *pss* inside *X:\JTSDDK64-Tools\config\Versions.ini*

The section of the **Versions.ini** file where the appropriate key can be found is shown below:

**File:** Versions.ini
```
...
# # next can be pwsh (PS 7+) or powershell (PS Windows 5.1)
pss=powershell
```
- Change *powershell* to *pwsh*
- Save **Versions.ini**
- Close and re-open the JTSDK64-Tools environment if you make any changes.
************************************************************************************

In the JTSDK64-Tools environment:

- Type: **Deploy-Boost**

Around 90 minutes later you should now have a deployment of Boost based at the recommended v1.82.0 (configurable in **C:\JTSDK64-Tools\config\Versions.ini**) that is suitable to build JT-software under your selected Qt version on your machine.

************************************************************************************
Pre-compiled drop-in Packages for [Boost-1.74.0][], [Boost-1.82.0][], [Boost-1.83.0][], [Boost-1.84.0][] and [Boost-1.85.0][] are available at the time of writing.

Each “drop-in” package has folders i.e. 1.74.0-7.3 for [MinGW 7.3](MinGW) (pre-Qt 5.15) and 1.74.0-8.1 (for post-Qt 5.15 including the 6.x.x streams). 
 
The drop-in packages since [Boost-1.79.0][] now supports [MinGW 8.1](MinGW).
  
- Extract the folder for the Boost version-package that you want to use into **C:\JTSDK64-Tools\tools\boost** (create the directory if it does not exist) and then remove the -7.3 or -8.1 suffix ! 

A Windows symbolic link will work too: i.e.: Assume that both the 1.85.0-8.1 and 1.85.0-11.2 distributions have been unpacked from [Boost-1.85.0](**Boost-1.85.0-MinGW-v8.1.7z**) to **C:\JTSDK64-Tools\tools\boost** . Assume that the command shell or [PowerShell][] windows are positioned at **C:\JTSDK64-Tools\tools\boost**

Examples:

- Cmd:** mklink /D 1.85.0 1.85.0-8.1 **
- [PowerShell][]:** New-Item -ItemType SymbolicLink -Path C:\JTSDK64-Tools\tools\boost\boost-1.85.0 -Value C:\JTSDK64-Tools\tools\boost\boost-1.85.0-8.1 **
 
The preference is to build your own Boost package and NOT use these ! ** Warning: Boost does not build 100% properly and to full capability under MinGW/[MSYS2][] environments that we use – yet its good enough for our purposes !**
************************************************************************************
A script **Reset-Boost.ps1** is available to reset any failed attempts at building Boost.
************************************************************************************
**Environments should now be complete for building JT-ware**
************************************************************************************

Now that seemed a lot of work. Please dissect these scripts to see what actually took place !
 
### Step 4: Build your JT-Software
 
Now we are ready to BUILD a JT-release. 

The release-source-code pulled is for the latest JT-software release. The JT-source that you pull is configurable from **C:\JTSDK64-Tools\config**. Rename the file **src-wsjtx** from a default pull of WSJT-X to either **src-jtdx** or **src-js8call** if desired. 

The "major" used JT-ware distributions are supported without discrimination or political comment.

In JTSDK64-Tools:

- Type: **jtbuild** <option>     i.e. **jtbuild package**
 
Options preferred are package (a Windows Installer package - the preferred "clean" way) and rinstall (just a static directory full of "runnable" files).

************************************************************************************
## Additional Options for Developers
************************************************************************************

Both the **jtbuild** and **build-hamlib-** scripts now contain a number of switches that can be used to disable default features of the scripts.

Use the embedded **help** facilities to discover the currently available set of switches:

i.e. 1:  In The **[PowerShell][]** Environment:

```
PS C:\JTSDK64-Tools> jtbuild -h

--------------------------------------------
 Default Build Commands
--------------------------------------------

 Usage .....: jtbuild [ OPTION ] [[ SWITCH ]]

 Examples...: jtbuild rinstall
            : jtbuild rinstall -ng

 Options:

    rconfig    Release, Config Only
    dconfig    Debug, Config Only
    rinstall   Release, Non-packaged Install
    dinstall   Debug, Non-packaged Install
    package    Release, Windows Package
    docs       Release, User Guide

 Switches:

    Switches only work if an [ OPTION ] is supplied.

    -nc        Do not run configure
    -ng        Do not check/pull source

 * To Display this message, type .....: jtbuild -h

PS C:\JTSDK64-Tools>
```

i.e. 2:  In The **[MSYS2][]** Environment (i.e. **mingw64** at the [PowerShell][] prompt):

```
$ build-hamlib.sh -h

---------------------------------------------------------------
 BUILD-HAMLIB - HELP
---------------------------------------------------------------

* Available Command Line Options:

  --> -h ........: Help
  --> -b/-nb ....: Process / Do not process bootstrap
  --> -c/-nc ....: Process / Do not process configure
  --> -g/-ng ....: Process / Do not pull/check source from GIT repository
  --> -libusb ...: Configure with LibUSB support
  --> -nlibusb ..: Do not configure with LibUSB support
  --> -static ...: Statically Linked Libraries built
       or ..
  --> -dynamic ..: Shared/Dynamically Linked Libraries built

* Note: You cannot select -static with -dynamic

  If using switches you may need to combine options to over-ride default build behaviour:

  i.e.: build-hamlib -nb reverts to Hamlib default STATIC build behaviour
        build-hamlib -nb -dynamic over-rides this behaviour

radio@jtsdk ~
$
```

************************************************************************************
## Contributions
************************************************************************************

### How Can I Help?

Please test these scripts and those in the [Tests][] folder. Report observations either 
via the [JTSDK Forum][] or the email address where most most messages come from (if 
you cannot post). The [JTSDK Forum][] is used somewhat as as 'blog' as information in 
there is too valuable for the general IT community.

***The 'core team' behind this are not [PowerShell][] gurus.*** This is a learning effort. 
If you are a [PowerShell][] guru PLEASE PLEASE PLEASE jump in and comment to assist. Send 
back BETTER SCRIPT. **Teach us all**. 

We especially require people to make these README.md scripts better !

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

Base ref: https://sourceforge.net/projects/jtsdk/files/win64/3.1.0/README.md Date: 2023-08-31

[Open Source]: https://opensource.com/resources/what-open-source
[WSJT]: http://physics.princeton.edu/pulsar/K1JT/
[WSJT-X]: http://physics.princeton.edu/pulsar/K1JT/wsjtx.html
[JTDX]: https://jtdx.tech/en/
[JS8CALL]: http://js8call.com/ 
[OmniRig]: http://dxatlas.com/OmniRig/Files/OmniRig.zip 
[MAP65]: http://physics.princeton.edu/pulsar/K1JT/map65.html
[WSPR]: http://physics.princeton.edu/pulsar/K1JT/wspr.html
[CMAKE]: https://CMAKE.org/
[MSYS2]: https://www.msys2.org/
[MinGW]: http://www.mingw.org/
[Qt]: https://www.qt.io/download-open-source 
[PowerShell]: https://docs.microsoft.com/en-us/[PowerShell][]/
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
[LibUSB]: https://libusb.info/
[JTSDK Sourceforge]: https://sourceforge.net/projects/jtsdk/files/win64/3.1.0/
[JTSDK Forum]: https://groups.io/g/JTSDK/messages
[32bit-compile]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-x86-Patches/ 
[JTSDK64-Tools-3.1.0]: https://sourceforge.net/projects/jtsdk/files/win64/3.1.0/jtsdk64-tools-3.1.0.exe
[JTSDK64-Apps-3.1.0.2]: https://sourceforge.net/projects/jtsdk/files/win64/3.1.0/jtsdk64-apps-3.1.0.2.exe
[JTSDK64-Tools-3.1.1.4]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.1-Stream/JTSDK64-Tools-3.1.1.4.exe
[JTSDK64-Tools-3.2.0.7]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/JTSDK64-Tools-3.2.0.7.exe
[JTSDK64-Apps-3.1.1]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.1-Stream/JTSDK64-Apps-3.1.1.exe
[JTSDK64-Base-3.2.0]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/JTSDK64-Base-3.2.0.exe
[JTSDK64-Base-3.2.0a7]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/Tests-3.2.3/JTSDK64-Base-3.2.0a7.exe
[JTSDK64-Base-3.2.1]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/JTSDK64-Base-3.2.1.exe
[JTSDK64-Tools-3.2.1.1]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/JTSDK64-Tools-3.2.1.1.exe
[JTSDK64-Base-3.2.2]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/Archive/JTSDK64-Base-3.2.2.exe
[JTSDK64-Tools-3.2.2.2]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/Archive/JTSDK64-Tools-3.2.2.2.exe
[JTSDK64-Tools-3.2.2.3]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/Archive/JTSDK64-Tools-3.2.2.3.exe
[JTSDK64-Tools-3.2.2.4]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/Archive/JTSDK64-Tools-3.2.2.4.exe
[JTSDK64-Tools-3.2.2.5]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/Archive/JTSDK64-Tools-3.2.2.5.exe
[JTSDK64-Tools-3.2.2.6]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/Archive/JTSDK64-Tools-3.2.2.6.exe
[JTSDK64-3.2-Stream]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/
[JTSDK64-Base-3.2.3]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/JTSDK64-Base-3.2.3.exe
[JTSDK64-Tools-3.2.3.1]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/JTSDK64-Tools-3.2.3.1.exe
[JTSDK64-Tools-3.2.3.2]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/JTSDK64-Tools-3.2.3.2.exe
[JTSDK64-Tools-3.2.3.3]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/JTSDK64-Tools-3.2.3.3.exe
[JTSDK64-3.4-Stream]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.4-Stream/
[JTSDK64-3.4.0]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.4-Stream/JTSDK64-3.4.0.exe
[JTSDK64-3.4.1]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.4-Stream/JTSDK64-3.4.1.exe
[JTSDK64-3.4.1-U1]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.4-Stream/JTSDK64-3.4.1-U1.exe
[JTSDK64-3.4.1-U2]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.4-Stream/JTSDK64-3.4.1-U2.exe
[JTSDK64-4.0.0]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-4.0-Stream/JTSDK64-4.0.0.exe
[JTSDK64-4.0.0-U1]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-4.0-Stream/JTSDK64-4.0.0-U1.exe
[Git]: https://git-scm.com/
[VS Code]: https://code.visualstudio.com/Download
[Issue Tracker]: https://sourceforge.net/p/hamlib-sdk/tickets/
[Package Updates]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.1.1-x64-Stream/Package-Updates/
[Boost]: https://www.boost.org/
[Boost-1.74.0]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/Boost-1.74.0-MinGW-v7.3-v8.1.7z
[Boost-1.75.0]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/Boost-1.75.0-MinGW-v7.3-v8.1.7z
[Boost-1.76.0]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/Boost-1.76.0-MinGW-v7.3-v8.1.7z
[Boost-1.77.0]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/Boost-1.77.0-MinGW-v7.3-v8.1.7z
[Boost-1.78.0]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/Boost-1.78.0-MinGW-v7.3-v8.1.7z
[Boost-1.79.0]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/Boost-1.79.0-MinGW-v8.1-v11.2.7z
[Boost-1.80.0]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/Boost-1.80.0-MinGW-v8.1-v11.2.7z
[Boost-1.81.0]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/Boost-1.81.0-MinGW-v8.1-v11.2.7z
[Boost-1.82.0]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/Boost-1.82.0-MinGW-v8.1-v11.2.7z
[Boost-1.83.0]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/Boost-1.83.0-MinGW-v8.1-v11.2.7z
[Boost-1.84.0]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/Boost-1.84.0-MinGW-v8.1-v11.2.7z
[Boost-1.85.0]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.4-Stream/Boost-1.85.0-MinGW-v8.1.7z
[Boost-1.86.0]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.4-Stream/Boost-1.86.0-MinGW-v13.1.7z
[WSJT-X Support Forum]: mailto://wsjt-devel@lists.sourceforge.net
[Tests]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/Tests/
[WSJT-X 2.2.3]: https://physics.princeton.edu/pulsar/k1jt/wsjtx-2.2.3.tgz
[WSJT-X 2.3.0]: http://physics.princeton.edu/pulsar/K1JT/wsjtx-2.3.0.tgz 
[WSJT-X 2.4.0]: https://physics.princeton.edu/pulsar/k1jt/wsjtx-2.4.0.tgz
[WSJT-X 2.5.0 rc6]: https://physics.princeton.edu/pulsar/k1jt/wsjtx-2.5.0-rc6.tgz
[WSJT-X 2.5.4]: https://physics.princeton.edu/pulsar/k1jt/wsjtx-2.5.4.tgz
[WSJT-X 2.6.0]: https://physics.princeton.edu/pulsar/k1jt/wsjtx-2.6.0.tgz
[WSJT-X 2.6.1]: https://sourceforge.net/projects/wsjt/files/wsjtx-2.6.1/wsjtx-2.6.1.tgz
[Archive]: https://sourceforge.net/projects/hamlib-sdk/files/Windows/JTSDK-3.2-Stream/Archive/
[Fl-Apps]: https://sourceforge.net/projects/fldigi/files/
[DotNET SDK]: https://dotnet.microsoft.com/download
[PowerShell]: https://docs.microsoft.com/en-us/powershell/scripting/overview?view=powershell-7.2
[PowerShell Section]: https://sourceforge.net/projects/hamlib-sdk/files/Programming/PowerShell/
[Windows VM]: https://developer.microsoft.com/en-us/windows/downloads/virtual-machines/
[Hyper-V]: https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v
[VMWare Workstation]: https://kb.vmware.com/s/article/2057907
[VMware Player]: https://kb.vmware.com/s/article/2053973
[Virtual Box]: https://www.virtualbox.org/wiki/Downloads
[QEmu]: https://www.qemu.org/download/
[VC Runtime]: https://docs.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist?view=msvc-170
[Visual Studio]: https://visualstudio.microsoft.com/
