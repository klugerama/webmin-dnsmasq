# install_check.pl

# use strict;
# use warnings;
# no warnings 'redefine';
# no warnings 'uninitialized';
# our (%text, %in, %access, $squid_version, %config);
do 'dnsmasq-lib.pl';

# is_installed(mode)
# For mode 1, returns 2 if dnsmasq is installed and configured for use by
# Webmin, 1 if installed but not configured, or 0 otherwise.
# For mode 0, returns 1 if installed, 0 if not
sub is_installed {
    return 0 if (!&find_dnsmasq());
    if ($_[0]) {
        return 2 if (&find_config());
    }
    return 1;
}
