A Webmin module for managing [DNSMasq](https://thekelleys.org.uk/dnsmasq/doc.html).

# Installation
## Directly from Github
1. From the [DNSMasq module releases page](https://github.com/klugerama/webmin-dnsmasq/releases), click `Assets` under the latest release.
2. Select an installation package; right-click the link selected and copy the link address to the clipboard:
   1. For Debian-based distributions (Debian, Ubuntu, Kali, Mint, etc.): select `webmin-dnsmasq_<VERSION>_all.deb`
   2. For RPM-based distributions (Fedora, RHEL, CentOS, Oracle Linux, Scientific Linux, etc.): select `wbm-dnsmasq-<VERSION>-<RELEASE>.noarch.rpm`
   3. For all other distributions - or any distribution - select `dnsmasq.tar.gz`
3. In Webmin, under the `Webmin` menu, click on `Webmin Configuration`
4. Click on the `Webmin Modules` icon
5. Ensure the `Install` tab is selected. Under `Install from`, select `From HTTP or FTP URL`.
6. Paste the link copied in step 2
7. Click `Install Module`
8. A new entry will appear under the `Servers` menu: `DNSMasq DNS & DHCP server`
## From downloaded file
1. Download the latest build package from the [releases page](https://github.com/klugerama/webmin-dnsmasq/releases). Select and click to download an installation package:
   1. For Debian-based distributions (Debian, Ubuntu, Kali, Mint, etc.): select `webmin-dnsmasq_<VERSION>_all.deb`
   2. For RPM-based distributions (Fedora, RHEL, CentOS, Oracle Linux, Scientific Linux, etc.): select `wbm-dnsmasq-<VERSION>-<RELEASE>.noarch.rpm`
   3. For all other distributions - or any distribution - select `dnsmasq.tar.gz`
2. In Webmin, under the `Webmin` menu, click on `Webmin Configuration`
3. Click on the `Webmin Modules` icon
4. Ensure the `Install` tab is selected. Under `Install from`, ensure the option `From local file` is selected. Click the icon to open the 'select file' dialog, and navigate to (and select) the downloaded package file.
5. Click `Install Module`
6. A new entry will appear under the `Servers` menu: `DNSMasq DNS & DHCP server`

## Module settings
By default this module presumes that the configuration file is named `dnsmasq.conf` and can be found directly under `/etc/`. If your configuration file has a different name or is in a different location by default, please [report a GitHub issue](https://github.com/klugerama/webmin-dnsmasq/issues) and include your OS, distribution & distribution version, and DNSMasq version.

In order to stop/start/restart/reload the `dnsmasq` service, this module also presumes that your system has `systemd` installed.

If DNSMasq is installed and a configuration file exists but either or both are not in the default location, click on the `module configuration` link in the message (or the gear icon above the message) to go to the module configuration, where you will be able to specify the paths for the DNSMasq executable and the configuration file (among other things). The module configuration also allows you to change the commands to start, stop, and restart the dnsmasq service, as well as the commands to cause DNSMasq to reread certain configuration files (without restarting) and to dump DNSMasq logs. See the [DNSMasq documentation](https://thekelleys.org.uk/dnsmasq/doc.html) for further information about how those commands work.
# Usage

## Organization
Settings for DNSMasq are broken down into three general categories - DNS settings, DHCP settings, and BOOTP/TFTP settings. Selecting the corresponding tab will show a series of icons with more specific sections under each category.

All settings correspond to specific configuration options identified in the DNSMasq documentation. For any given option, hovering the mouse over the help icon to the right of the description will show the name of the option, a brief explanation of what it does, and how to specify parameters for that option (if any).

### Simple options
Most options are either simply enabled or disabled. Some others may have one or a few values that must be specified in order to enable them. To enable an option, click the checkbox to the left of the option and click `Save`. More than one option at a time may be enabled or disabled by checking more than one box.

For those options that require additional parameters, the form will provide some guidance as to what type of information is required before you can save.

### List options
Some options may be specified multiple times. For these, a list is presented. To add an item to the list, click the `Add *` button above or below the list. This will open a dialog, showing the corresponding values that must be specified. Added items are enabled by default.

To edit an item in the list, click on any of the values to show an edit dialog.

To enable one or more list item, click the checkbox to the left of the item and click `Enable`. More than one item at a time may be enabled or disabled by checking more than one box.

For most list values, the order is not important. However, for those configuration options for which order is important, an additional column is shown on the right-hand side showing up and down arrows. Click one of these arrows to move the corresponding item up or down, respectively. The items above or below will be reordered appropriately.

### Manual configuration file editing
Finally, you may directly edit the configuration file(s) by clicking `Edit config files` under the `DNS settings` tab.

## Errors
If any errors are found in the saved configuration, a box will show at the top of the page listing the details of the discovered issue. This contains the name of the option, the configuration file it is found in, and which line contains the offending error. If a required parameter is missing, or if there is something wrong with the specified value for that parameter, a short description will identify the issue.

To correct the error, you have three options:
### 1. Fix the value
Clicking on any text in the error row will take you to the relevant settings page for that option, and (hopefully) provide you with more information regarding how to fix the problem. For list items, the appropriate edit dialog will pop up for that item.
### 2. Disable the option
To disable the option and allow DNSMasq to use the default value, ensure the checkbox to the left of the error is checked and click `Disable`. More than one error-causing option at a time may be disabled by checking more than one box.
### 3. Delete the option
To delete the option from the configuration file and allow DNSMasq to use the default value, ensure the checkbox to the left of the error is checked and click `Delete`. More than one error-causing option at a time may be deleted by checking more than one box.

## Applying changes
Click the restart icon at the top right of the module's page to restart DNSMasq. In most cases, DNSMasq must be restarted to apply configuration changes.

The exceptions to this requirement are:

* `addn-hosts` 
  * DNS settings -> Basic DNS settings -> Additional hosts file(s)
* `hostsdir`
  * DNS settings -> Basic DNS settings -> Additional hosts file directories
* `servers-file`
  * DNS settings -> Additional Configuration Files -> "Additional configuration files (only 'server' and 'rev-server')"
* `dhcp-hostsfile`
  * DHCP settings -> Basic DHCP settings
* `dhcp-optsfile`
  * DHCP settings -> Basic DHCP settings
* `dhcp-hostsdir`
  * DHCP settings -> Basic DHCP settings
* `dhcp-optsdir`
  * DHCP settings -> Basic DHCP settings
* `read-ethers`
  * DHCP settings -> Basic DHCP settings

For the above options, DNSMasq will reread the specified files and directories upon receiving a SIGHUP. In addition, it will:

* clear its cache
* reload /etc/hosts (unless `no-hosts` is enabled)
* call the DHCP lease change script for all existing DHCP leases
* reread /etc/resolv.conf (if `no-poll` is enabled)
