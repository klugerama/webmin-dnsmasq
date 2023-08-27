A Webmin module for managing [dnsmasq](https://thekelleys.org.uk/dnsmasq/doc.html).

# Installation
1. Download the latest `dnsmasq.wbm.gz` file from the [releases page](https://github.com/klugerama/webmin-dnsmasq/releases)
2. In Webmin, under the `Webmin` menu, click on `Webmin Configuration`
3. Click on the `Webmin Modules` icon
4. Ensure the `Install` tab is selected. Under `Install from`, ensure the option `From local file` is selected. Click the icon to open the 'select file' dialog, and navigate to (and select) the downloaded `dnsmasq.wbm.gz` file.
5. Click `Install Module`
6. A new entry will appear under the `Servers` menu: `DNSMasq DNS & DHCP server`

# Usage

So far this module presumes that `dnsmasq.conf` can be found directly under `/etc/`. In order to stop/start/restart/reload the `dnsmasq` service, it also presumes that your system has `systemd` installed.