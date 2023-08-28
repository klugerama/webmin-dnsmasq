A Webmin module for managing [dnsmasq](https://thekelleys.org.uk/dnsmasq/doc.html).

# Installation
## Directly from Github
1. From the [DNSMasq module releases page](https://github.com/klugerama/webmin-dnsmasq/releases), click `Assets` under the latest release.
2. Right-click the link for `dnsmasq.wbm.gz` and copy the link address to the clipboard
3. In Webmin, under the `Webmin` menu, click on `Webmin Configuration`
4. Click on the `Webmin Modules` icon
5. Ensure the `Install` tab is selected. Under `Install from`, select `From HTTP or FTP URL`.
6. Paste the link copied in step 2
7. Click `Install Module`
8. A new entry will appear under the `Servers` menu: `DNSMasq DNS & DHCP server`
## From downloaded file
1. Download the latest `dnsmasq.wbm.gz` file from the [releases page](https://github.com/klugerama/webmin-dnsmasq/releases)
2. In Webmin, under the `Webmin` menu, click on `Webmin Configuration`
3. Click on the `Webmin Modules` icon
4. Ensure the `Install` tab is selected. Under `Install from`, ensure the option `From local file` is selected. Click the icon to open the 'select file' dialog, and navigate to (and select) the downloaded `dnsmasq.wbm.gz` file.
5. Click `Install Module`
6. A new entry will appear under the `Servers` menu: `DNSMasq DNS & DHCP server`

# Usage

So far this module presumes that `dnsmasq.conf` can be found directly under `/etc/`. If your configuration file is in a different location by default, please [report a GitHub issue](https://github.com/klugerama/webmin-dnsmasq/issues) with your OS, distribution & distribution version, and DNSMasq version.

In order to stop/start/restart/reload the `dnsmasq` service, this module also presumes that your system has `systemd` installed.