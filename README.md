# JTSDK 3.2.0

## Better instructions are on their way

Once final structures are in place to house and support all this work - and to prevent duplication of work - instructions will follow.

## Kit Deployment

### Step 1: Deploy the JTSDK64-Base-3.2.0.exe Installer

** Note that this assumes a fresh Windows 10 Virtual Machine **

- Deploy the installer JTSDK64-Base-3.2.0.exe inside a FRESH VM.

### Step 2: Launch the Installation Environment

- Execute the JTSDK64-Setup environment from the link on your desktop
- In this environment type: ** postinstall **

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

(required) VC/C++ Runtimes (Y|N) : Y
(required) OmniRig (Y|N)         : Y
(required) Git-SCM (Y|N)         : Y
(required) Default Qt (D/Y|F|N)  : Y
(required) MSYS2 Setup (Y|N)     : Y
(optional) VS Code (Y|N)         : Y

* Your Installation Selections:

  --> VC Runtimes .: Y
  --> OmniRig .....: Y
  --> Git .........: Y
  --> Qt ..........: Y
  --> MSYS2 .......: Y
  --> VS Code .....: Y
  ```
inside postinstall It is best at this stage just to select "y" for everything - especially the (required) components !

During this phase some tools will require some interaction at the keyboard (especially the Qt deployment as one MUST now have their own account and agree to their licensing terms).

Follow on-screen prompts carefully.

#### Step 2a: Prepare the MSYS2 Environment

A MSYS2 environment window will open. 
```
JTSDK64 Tools MSYS2 using QT v

For main menu, type ..: menu
For Help Menu, type ..: jthelp

Copyright (C) 2013-2021, GPLv3, Greg Beam, KI7MT and Contributors.
This is free software; There is NO warranty; not even
for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

stepheni@LAPTOP-I7 ~
$ menu
```
- Type: menu
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

- Select Option 2 to (Update MSYS2) update the msys2 environment. 

Note that the window may close if there are updates. 

#### Step 2c: Update the  MSYS2 Environment

If the MSYS2 Window closes reopen it within the JTSDK64-Setup environment with "msys2".

- Back at menu, select Option 3 to Deploy the Hamlib Dependencies.

#### Step 2d: Basic Deployment Complete

Once complete you can exit the "Deployment" environment (i.e. close the JTSDK64-Setup and any msys2 terminal shells) 

### Step 3: Set Up The Main Tools Environment

- Launch JTSDK64-Tools environment. 

#### Step 3a: (Optional) Upgrade your Qt Deployment

The bare Qt installer script pegs at Qt at version 5.12.10. If you want to update Qt to the more contemporary 5.15.2 version you should do so now 

i.e. 

- Navigate to the Qt Deployment directory
- Run the Qt Maintenance Tool from your Qt deployment directory (i.e. C:\JTASK64-Tools\tools\Qt)
- To add Qt 5.15.2
- Add Qt 5.15.2 MinGW.
- Add Developer and Designer Tools / MinGW 8.1.0 64-bit
- Optional: Add the OpenSSL 1.1.1j toolkit (it helps with a WSJTX download).
- Adjust the C:\JTSDK64-Tools\config marker file to match the Qt version that you want to use (i.e. rename qt5.12.10 to qt5.15.2)

#### Step 3b: Deploy Hamlib for our selected Qt Version.

In JTSDK64-Tools:

- Launch msys2
- Type menu
- Select 5. Build Hamlib - Static Libraries

This will take time as it pulls from the master repository for Hamlib. Repositories can be changed. by changing the marker files in C:\JTSDK64-Tools\config (i.e. from .. hlmaster to hlw4mdb or hlg4wjs or hlnone for no default pull and update).

#### Step 3c: Deploy Boost for our selected Qt/MinGW Version.

THIS IS SLOW. There are "dropins" available on the Sourceforge and GitHub sites if you are lazy. Yet the best procedure is to build your own.

In JTSDK64-Tools:

- Type: Deploy-Boost

Around 90 minutes later you should now have a deployment of Boost (based at v 1.74.0 but also configurable in C:\JTSDK64-Tools\config\Versions.ini) that is suitable to build JT-software under your selected Qt version on your machine.

#### Step 3d: Environments should now be complete for building JT- software

Now that seemed a lot of work. Please dissect these scripts to see what actually took place !

### Step 4: Build your JT- Software

Now we are ready to BUILD a JT-release. 

The default-source pulled is for the latest WSJT-X release. The JT-source that you pull is configurable from C:\JTSDK64-Tools\config. Rename the file src-wsjtx from a default pull of WSJT-X to either src-jtdx or src-js8call. 

The "major" used distros are supported without discrimination or political comment.

In JTSDK64-Tools:

- Type: jtbuild <option>     i.e. jtbuild package
 
Options preferred are package (a Windows Installer package - the preferred "clean" way) and rinstall (just a static directory full of "runnable" files).
