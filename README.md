# svxlink-usrp with DVSwitch
**<h1> SVXLink and DvSwitch </h1>**
<h2>Script build Debian Server Bookworm 64 Bit - British English Version.</h2> 
<p>While there are repositories from which to download and compile SVXLink they do require quite a bit of understanding.
This script takes only a little SSH knowledge to pull the various downloads together to create the basis of a ready-to-configure system.</p>

<p>It has to be done under conditions of research in the original source manuals found on Svxlink.org and the man files http://www.svxlink.org/doc/man/man5/svxlink.conf.</p>
<p>However this script pulls the SVXLink software from Adi DL1HRC's fork, that has the UsrpLogic necessary to drive the DVSwitch components.</p>

<p>It is NOT plug and play when all is said and done however. It does still require a little manipulation of the configuration files, 
but the compilation of the major part of the software is done for you.</p></h2>

<b>First Steps</b>
<p>Requirements: Debian 12 (bookworm) Server. A Soundcard is not required as this installation is to be designed as a bridge. Install all the software in this instance as user root. Be aware that if you require to access the server from elsewhere then you will need to adjust the permissions for ssh sshd.</p>


<h3>The programming of the server</h3>

Start with a iso download of Bookworm - Debian 12 - Use no other OS</b>  
<h3>The compilation</h3>
The first step will be the following command: <b>apt update && apt upgrade -y </b>  

Now the following command: <b>git clone https://github.com/f5vmr/svxlink_usrp </b> .


Now type <b>bash svxlink_usrp/install.sh</b> and return.

<p>The script will now update the software. You will be required to add the callsign of the node prior to the compilation of the software so watch for the prompt.</p>

<p>At the end of the script the running configuration will be compiled with the given callsign. Then the fun begins. Go and have a coffee or even lunch as the compilation will take about 15 minutes. Hopefully there should be no reported error.</p>

<p>At the end of the compilation type <b>reboot</b> to restart the unit if it hasn't already. If all is well the unit will still be only partly functional. You will need to finalise the configuration for SVXLink and DVSwitch. You may continue to leave the rest of the functionality in place, as the configuration of the UsrpLogic is now conducted in /etc/svxlink/svxlink.d/UsrpLogic.conf, that you can edit. The linking of the SimplexLogic and UsrpLogic has been done for you in the svxlink.conf</p>

<p>For further assistance in relation to setting up SVXLink, UsrpLogic and DVSwitch, I recommend you look closely at groups.io and the Svxlink and Dvswitch groups, as all the answers are there.</p>

<p>You will need to understand the svxlink.conf file and how to make adjustments for Simplex or Repeater operation. In any case you may need to refer to the svxlink.org main page, or svxlink amateur radio users page on facebook, or contact me. For further information also consult the svxlink pages on g4nab.co.uk.</p>
<p>You will need to modify the /etc/svxlink/svxlink.d/UsrpLogic.conf in respect of the callsign translation, USRP Ports and other items. Remeber that the USRP ports are to be reversed in DvSwitch (or Allstar if you use that). The file containing the USRP ports for DvSwitch are in /opt/Analog_Bridge/Analog_Bridge.ini. (The USRP Ports for Allstar are in the rpt.conf accessed from asl-menu.)</p>

<p>To stop svxlink running type in the terminal <b>systemctl stop svxlink.service</b> and to restart it type <b>systemctl restart svxlink.service</b></p>
<p>The next stage will be to modify the three files <b>node_info.json</b>, <b>svxlink.conf</b>, and <b>ModuleEchoLink.conf</b>.</p>
<p>Complete the node_info.json</b> </p>

<p>Open the terminal of the server, and type <b>cd /etc/svxlink</b> followed by return. Then type <b>nano node_info.json</b> and edit the information.</p>
<p>When the editing is complete type <b>cntrl-o</b> and return at the keyboard for the terminal followed by <b>cntrl-x</b>.
The next stage is to check and edit where necessary the <b>svxlink.conf</b> file. type <b>nano svxlink.conf</b> followed by return.</p>
<p>Check the content and complete your location information near the bottom of the file. type <b>cntrl-o</b> and return then <b>cntrl-x</b> when finished to save your changes.</p>

<p>To incorporated the changes you will need to type <b>systemctl restart svxlink.service</b> and return.</p>

<p>Everything introduced here is from the original presentation by Tobias SM0SVX, modified slightly with some additional modules from DL1HRC.</p>
<p>This new script will download and compile DVSwitch into the folder /opt/Analog_Bridge and /opt/MMDVM_Bridge. You will need to modify all three .ini files Analog_Bridge, MMDVM_Bridge and DVSwitch. You will also need to download onto an android device DVSwitch_Mobile to control the functions of DVSwitch remotely, as it cannot yet be done from SVXlink.</p>

<p>You can if you wish replace the DvSwitch with an installation of Allstar and Allmon3.</p>


