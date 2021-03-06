#JTSDK 3.2.0

##Better instructions are on their way

Once final structures are in place to house and support all this work - and to prevent duplication of work - instructions will follow.

##Kit Deployment

**Note that this assumes a fresh Windows 10 Virtual Machine**

- Deploy the installer JTSDK64-Base-3.2.0.exe inside a FRESH VM.
- Execute the JTSDK64-Setup environment from the link on your desktop
- In this environment type postinstall
- inside postinstall It is best at this stage just to select "y" for everything.
- During this phase some tools will require some interaction at the keyboard (especially the Qt deployment as one MUST now have their own account and agree to their licensing terms).
- Follow on-screen prompts carefully.

A MSYS2 environment window will open. 

- Type menu
- Select Option 2 to (Update MSYS2) update the msys2 environment. Note that the window may close if there are updates. 

If the MSYS2 Window closes reopen it within the JTSDK64-Setup environment with "msys2".

- Back at menu, select Option 3 to Deploy the Hamlib Dependencies.

Once complete you can exit the "Deployment" environment (i.e. close the JTSDK64-Setup and any msys2 terminal shells) and head to the JTSDK64-Tools environment. Note that you have a base Qt deployment pegged at Qt 5.12.10.

If you want to update Qt to the more contemporary 5.15.2 version you should do so now 

i.e. 

- Navigate to the Qt Deployment directory
- Run the Qt Maintenance Tool from your Qt deployment directory (i.e. C:\JTASK64-Tools\tools\Qt)
- To add Qt 5.15.2
- Add Qt 5.15.2 MinGW.
- Add Developer and Designer Tools / MinGW 8.1.0 64-bit
- Optional: Add the OpenSSL 1.1.1j toolkit (it helps with a WSJTX download).
- Adjust the C:\JTSDK64-Tools\config marker file to match the Qt version that you want to use (i.e. rename qt5.12.10 to qt5.15.2)

Now we must deploy Hamlib for our selected Qt Version.

In JTSDK64-Tools:

- Launch msys2
- Type menu
- Select 5. Build Hamlib - Static Libraries

This will take time as it pulls from the master repository for Hamlib. Repositories can be changed. by changing the marker files in C:\JTSDK64-Tools\config (i.e. from .. hlmaster to hlw4mdb or hlg4wjs or hlnone for no default pull and update).

Now its time to build Boost. Now I warn you THIS IS SLOW. There are "dropins" available on the Sourceforge and GitHub sites if you are lazy. Yet the best procedure is to build your own.

In JTSDK64-Tools:

- Type: Deploy-Boost

Around 90 minutes later you should now have a deployment of Boost (based at v 1.74.0 but also configurable in C:\JTSDK64-Tools\config\Versions.ini) that is suitable to build JT-software under your selected Qt version on your machine.

Now that seemed a lot of work. Please dissect these scripts to see what actually took place !

Now we are ready to BUILD a JT-release. The default-source pulled is for the latest WSJT-X release. The JT-source that you pull is configurable from C:\JTSDK64-Tools\config. Rename the file src-wsjtx from a default pull of WSJT-X to either src-jtdx or src-js8call. We support the "major" used distros (and this will increase) without discrimination or political comment.

In JTSDK64-Tools:
- Type: jtbuild <option>     <== Options preferred are package (a WIndows Installer package - the preferred "clean" way) and rinstall (just a static directory full of "runnable" files).
