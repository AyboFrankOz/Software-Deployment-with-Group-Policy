# Software-Deployment-with-Group-Policy
In this lab, I demonstrate how to deploy software (```.msi``` and ```.exe```) using Group Policy (GPO) in an Active Directory environment. The setup simulates a real-world scenario in which different departments receive different software packages based on their roles. First, I create two groups in Active Directory: ExecPCs and UserPCs. Then I deploy Google Chrome and Notepad++ to User PCs, and Google Chrome, Firefox, and Adobe Reader to Executive PCs. To validate the deployment and ensure that Group Policy was applied correctly, I use two test user accounts representing different roles: **Hank McCoy** (Username: Beast) – Chief Technology Officer and **Bobby Drake** (Username: Iceman) – Creative Marketing Director from [Cerebro-AD-Creator]( https://github.com/AyboFrankOz/Cerebro-AD-Creator)

## Step 0 Creating PC Groups
Create 2 Windows 10 machines and join them to the domain: Exec1 > Executive workstation and PC1 > Standard user workstation. To logically differentiate these machines, create two organizational units: ExecPCs and UserPCs. 

On DC, Run CMD and type ```dsa.msc``` to shortcut your way into Active Directory Users and Computers. Right-click on the domain > New > Organizational Unit. Name it as ExecPCs. Do it again for UserPCs. Assign the computers from the default "Computers" organizational unit by dragging Exec1 to ExecPCs and  PC1 to UserPCs. 

![Executive PC Group](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/e7c48390ed88cc63ca5496289cf147b02dcca4e9/images/PC_groups%20(1).PNG)
![User PC Group](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/e7c48390ed88cc63ca5496289cf147b02dcca4e9/images/PC_groups%20(2).PNG)

If you need help joining machines to the domain, refer to [Active-Directory-Home-Lab-Setup-Guide
](https://github.com/AyboFrankOz/Active-Directory-Home-Lab-Setup-Guide/blob/95b6ff2b205077241f0697b75ed25109845dfccf/README.md)

## Step 1 Preparing Software & Shared Folder

On the Domain Controller (DC), go to Local Disk (C:) and create a folder named "Deployment" to store the installation files.
![Creating folder](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/ad9e060f5546529d22ae904cbd33f0583c7c6fe5/images/Creating%20folder%20and%20giving%20access%20(1).PNG)

To obtain the installation files, search for the enterprise/offline installers (e.g., “download Chrome MSI”).
Download the official .msi versions for Google Chrome, Firefox, Notepad++ and the .exe installer for Adobe Reader from the official website. Move the setup files in this folder.  
![Setup Files](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/ad9e060f5546529d22ae904cbd33f0583c7c6fe5/images/Creating%20folder%20and%20giving%20access%20(2).PNG)

Go back and right-click on the folder> Properties > Click on the Sharing tab > Check "Share this folder". Change the name to Deployment$. "$" at the end will hide the path.
![Giving Access](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/ad9e060f5546529d22ae904cbd33f0583c7c6fe5/images/Creating%20folder%20and%20giving%20access%20(3).PNG)

Remove the default Everyone group, as it includes all users, including unauthenticated accounts. We don't want unauthenticated users to access our files, as this is how malware and ransomware spread across the network. Instead, add "All Employees" and give them "Read" permission, ensuring that only authenticated users can access the shared folder while maintaining security.
![Giving access](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/ad9e060f5546529d22ae904cbd33f0583c7c6fe5/images/Creating%20folder%20and%20giving%20access%20(4).PNG)

We also need to give "Domain Computers" access. 
![Giving access](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/d67ecd0c587dbd57d817e7bc3750dcb13799f73f/images/Creating%20folder%20and%20giving%20access%20(7).PNG)

Since my other user, Frank, with Admin Rights, is not in the All Employees group, I gave him access as well.
![Creating folder](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/d67ecd0c587dbd57d817e7bc3750dcb13799f73f/images/Creating%20folder%20and%20giving%20access%20(6).PNG)

Copy the Network Path as we will need it soon.
![Creating folder](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/ad9e060f5546529d22ae904cbd33f0583c7c6fe5/images/Creating%20folder%20and%20giving%20access%20(5).PNG)

Here is a screenshot from our two test computers before we progress further. PC 1 is on the left and EXEC1 is on the right. They are both running freshly installed Windows 10.
![Before](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/e0949b9fec82dc4fd62e94d27ca4e6ecef47038e/images/Before.PNG)

## Step 2 Deploying an MSI file
From Server Manager Dashboard > Tools > Group  Policy Management.
![Deploying an MSI file](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/3fd33d0ad717e8cd14fceca21c2e3e43ea652166/images/Deployin%20msi%20(1).PNG)

First, we will deploy software to executives' computers. Expand lab.local to find the ExecPC group. Right-click on the ExecPC group > "Create a GPO in this domain and Link it here"
![Deploying an MSI file](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/3fd33d0ad717e8cd14fceca21c2e3e43ea652166/images/Deployin%20msi%20(2).PNG)

You can give any name; I named it "BrowserForExecutives". Click OK.
![Deploying an MSI file](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/3fd33d0ad717e8cd14fceca21c2e3e43ea652166/images/Deployin%20msi%20(3).PNG)

Right-click the GPO and click "edit" to configure it
![Deploying an MSI file](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/3fd33d0ad717e8cd14fceca21c2e3e43ea652166/images/Deployin%20msi%20(4).PNG)

Click "Policies" under Computer Configuration > Software Settings > Software Installation. Right-click on the blank window > New > Package
![Deploying an MSI file](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/3fd33d0ad717e8cd14fceca21c2e3e43ea652166/images/Deployin%20msi%20(5).PNG)

Paste the path location that we copied and click Open.
![Deploying an MSI file](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/3fd33d0ad717e8cd14fceca21c2e3e43ea652166/images/Deployin%20msi%20(6).PNG)

Select ChromeSetup.msi and click on Open
![Deploying an MSI file](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/3fd33d0ad717e8cd14fceca21c2e3e43ea652166/images/Deployin%20msi%20(7).PNG)

Click on Assigned and OK.
![Deploying an MSI file](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/3fd33d0ad717e8cd14fceca21c2e3e43ea652166/images/Deployin%20msi%20(8).PNG)

Repeat the same steps for Firefox. When it is done, close the Group Policy Managemet Editor.
![Deploying an MSI file](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/3fd33d0ad717e8cd14fceca21c2e3e43ea652166/images/Deployin%20msi%20(9).PNG)

Right-click on the User PC group > "Create a GPO in this domain and Link it here"
![Deploying an MSI file](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/3fd33d0ad717e8cd14fceca21c2e3e43ea652166/images/Deployin%20msi%20(10).PNG)

Give it a name
![Deploying an MSI file](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/3fd33d0ad717e8cd14fceca21c2e3e43ea652166/images/Deployin%20msi%20(11).PNG)

Right-click the GPO and click "edit" to configure it. Click "Policies" under Computer Configuration > Software Settings > Software Installation. Right-click on the blank window > New > Package
![Deploying an MSI file](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/3fd33d0ad717e8cd14fceca21c2e3e43ea652166/images/Deployin%20msi%20(12).PNG)

Repeat the same steps for Chrome and Notepad++ setup files. Paste the path ```\\DC01\Deployment$``` into the File Name bar, same as before, and click Open to find the setup files. 
![Deploying an MSI file](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/3fd33d0ad717e8cd14fceca21c2e3e43ea652166/images/Deployin%20msi%20(15).PNG)

Since GPOs are configured, go back to PC1 and Exec1 machines. On CMD, Type ```gpupdate /force``` to update GPOs and restart the PCs.
![Deploying an MSI file](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/3fd33d0ad717e8cd14fceca21c2e3e43ea652166/images/Deployin%20msi%20(16).PNG)

After the restart, log back in
![Deploying an MSI file](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/3fd33d0ad717e8cd14fceca21c2e3e43ea652166/images/Deployin%20msi%20(17).PNG)

Chrome and Notepad++ are installed on PC1 and Chrome and Firefox are installed on Exec1
![Deploying an MSI file](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/3fd33d0ad717e8cd14fceca21c2e3e43ea652166/images/Deployin%20msi%20(18).PNG)

## Step 3 Deploying an EXE file
Group Policy Software Deployment does not support .exe files directly. Thus, to deploy .exe applications, we will be using a PowerShell script in combination with Group Policy. Download [Adobe Reader Script](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/b2bebe9c0fa3c6705965595f36df8dd3fbbb9da0/AdobeReader.ps1) and save it to Desktop. 

Return to Group Policy Management, right-click on ExecPCs, and select "Create a GPO in this domain and Link it here. Assign an appropriate name to the policy, "AdobeReaderForExec" in our case. You should see the newly created GPO appear as the second item in the list.
![Deploying an Exe](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/1347ec1f30359925fa74bb87b1afd92ec11f3b48/images/Deploying%20Exe%20(1).PNG)

Right-click to edit. Click on Policies > Windows Settings > Scripts. Right-click on "Startup" and click Properties. Startup Properties windows will open, click on "PowerShell Scripts" tab, then "Add" button. Another window will open; click on "Browse". Copy the Adobe Reader script using Ctrl + C, then paste it using Ctrl + V into the window that opened previously when we clicked Browse. Click on the script, then click on Open.
![Deploying an Exe](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/1347ec1f30359925fa74bb87b1afd92ec11f3b48/images/Deploying%20Exe%20(2).PNG)

Return to Exec1. Open CMD and update the GPOs by typing ```gpupdate /force```. When it is done, restart the computer. 
![Deploying an Exe](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/1347ec1f30359925fa74bb87b1afd92ec11f3b48/images/Deploying%20Exe%20(3).PNG)

After waiting a couple of minutes, Adobe Reader should be installed.
![Deploying an Exe](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/1347ec1f30359925fa74bb87b1afd92ec11f3b48/images/Deploying%20Exe%20(4).PNG)

The script checks whether Adobe Reader is already installed by verifying the existence of its installation directory. If the folder is not found, it silently installs Adobe Reader using the .exe installer from a network share. This is why the specific installation path is defined in the script. If the script is to be used for another application, the installation path must be updated based on where that software is installed.
![Deploying an Exe](https://github.com/AyboFrankOz/Software-Deployment-with-Group-Policy/blob/1347ec1f30359925fa74bb87b1afd92ec11f3b48/images/Deploying%20Exe%20(5).PNG)
