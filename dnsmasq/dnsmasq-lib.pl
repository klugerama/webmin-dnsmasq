#
# dnsmasq-lib.pl
#
# dnsmasq webmin module library module
#

BEGIN { push(@INC, ".."); };
use WebminCore;
init_config();
require 'parse-config-lib.pl';
our %access = &get_module_acl();

# Returns HTML for a link to put in the top-right corner of every page
sub restart_button {
    return undef if ($config{'restart_pos'} == 2);
    my $args = "redir=".&urlize(&this_url());
    if (&is_dnsmasq_running()) {
        return ($access{'restart'} ?
            '<a href="restart.cgi?$args">$text{"lib_buttac"}</a><br>\n' :
                "").
            ($access{'start'} ?
            '<a href="stop.cgi?$args">$text{"lib_buttsd"}</a>\n' : "");
        # return "<a href=\"restart.cgi?$args\">$text{"lib_buttac"}</a><br>\n".
        #     "<a href=\"stop.cgi?$args\">$text{"lib_buttsd"}</a>\n";
    }
    else {
        return $access{'start'} ?
            '<a href="start.cgi?$args">$text{"lib_buttsd1"}</a>\n' : "";
        # return "<a href=\"start.cgi?$args\">$text{"lib_buttsd1"}</a>\n";
    }
}

# Returns the process ID if dnsmasq is running
sub is_dnsmasq_running {
    my $dnsmconfig = &parse_config_file();

    # Find all possible PID files
    my @pidfiles;
    my $pidstruct = &find_config("pid_filename", $dnsmconfig);
    push(@pidfiles, $pidstruct->{'values'}->[0]) if ($pidstruct);
    my $def_pidstruct = &find_config("pid_filename", $dnsmconfig);
    push(@pidfiles, $def_pidstruct->{'values'}->[0]) if ($def_pidstruct);
    push(@pidfiles, split(/\s+/, $config{'pid_file'})) if ($config{'pid_file'});
    @pidfiles = grep { $_ ne "none" } @pidfiles;

    # Try check one
    foreach my $pidfile (@pidfiles) {
        my $pid = &check_pid_file($pidfile);
        return $pid if ($pid);
    }

    if (!@pidfiles) {
        # Fall back to checking for dnsmasq process
        my ($pid) = &find_byname("dnsmasq");
        return $pid;
    }

    return 0;
}

# Returns the structure(s) with some name
# disabled mode 0 = only enabled, 1 = both, 2 = only disabled,
# 3 = disabled and tags
sub find_config {
    my ($name, %conf, $mode) = @_;
    $mode ||= 0;
    my @rv;
    my $c;
    my $k;
    while (($k,$c) = each (%conf)) {
        if ($c->{'name'} eq $name) {
            push(@rv, $c);
        }
    }
    if ($mode == 0) {
        @rv = grep { $_->{'enabled'} && !$_->{'tag'} } @rv;
    }
    elsif ($mode == 1) {
        @rv = grep { !$_->{'tag'} } @rv;
    }
    elsif ($mode == 2) {
        @rv = grep { !$_->{'enabled'} && !$_->{'tag'} } @rv;
    }
    elsif ($mode == 3) {
        @rv = grep { !$_->{'enabled'} } @rv;
    }
    return @rv ? wantarray ? @rv : $rv[0]
            : wantarray ? () : undef;
}

#
# update the config file array
#
# arguments are:
# 	$lineno - the line number (array index) to update
# 	$text   - the new contents of the line
# 	$file   - reference to the array to change
# 	$action - 0 = normal
#             1 = put a comment marker ('#') at start of line
# 	          2 = delete the line
#
sub update {
    my ($lineno, $text, $file, $action) = @_;
    my $line;

    if ($action == 2) {

    }
    else {
        $line = ( $action == 1 ) ?
            $text :
            "#" . $text;
        if ( $lineno <= 0 ) {
            push @$file, $line;
        }
        else {
            @$file[$lineno]=$line;
        }
    }
} # end of sub update

# apply_configuration()
# Activate the current dnsmasq configuration
sub apply_configuration {
    if ($config{'dnsmasq_restart'}) {
        my $out = &backquote_logged("$config{'dnsmasq_restart'} 2>&1");
        return "<pre>".&html_escape($out)."</pre>" if ($?);
    }
    else {
        my $out = &backquote_logged("$config{'dnsmasq_path'} -C $config{'config_file'} 2>&1");
        return "<pre>".&html_escape($out)."</pre>"
            if ($? && $out !~ /warning/i);
    }
    return undef;
}

sub this_url {
    my $url = $ENV{'SCRIPT_NAME'};
    if (defined($ENV{'QUERY_STRING'})) {
        $url .= "?$ENV{'QUERY_STRING'}";
    }
    return $url;
}

# list_auth_users(file)
sub list_auth_users {
    my ($file) = @_;
    my @rv;
    my $lnum = 0;
    my $fh = "USERS";
    &open_readfile($fh, $file);
    while(<$fh>) {
        if (/^(#*)([^:]+):(\S+)/) {
            push(@rv, { 'user' => $2, 'pass' => $3,
                    'enabled' => !$1, 'line' => $lnum });
            }
        $lnum++;
    }
    close($fh);
    if ($config{'sort_conf'}) {
        return sort { $a->{'user'} cmp $b->{'user'} } @rv;
    }
    else {
        return @rv;
    }
}

# can_access(file)
sub can_access {
    my ($file) = @_;
    my @f = grep { $_ ne '' } split(/\//, $file);
    return 1 if ($access{'root'} eq '/');
    my @a = grep { $_ ne '' } split(/\//, $access{'root'});
    for(my $i=0; $i<@a; $i++) {
        return 0 if ($a[$i] ne $f[$i]);
    }
    return 1;
}

1;
