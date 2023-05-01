# install_check.pl

use strict;
use warnings;
no warnings 'redefine';
no warnings 'uninitialized';
our (%text, %in, %access, $squid_version, %config);
do 'dnsmasq-lib.pl';

# is_installed(mode)
# Returns 1 if installed, 0 if not
sub is_installed {
    return 0 if (!-r $config{'config_file'} || !&has_command($config{'dnsmasq_path'}));
    return 1;
}

