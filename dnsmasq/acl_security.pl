
require 'dnsmasq-lib.pl';

# acl_security_form(&options)
# Output HTML for editing security options for the dnsmasq module
sub acl_security_form {

    print "<tr> <td><b>".$text{"acl_start"}."</b></td>\n";
    printf "<td><input type=radio name=start value=1 %s> %s\n",
        $_[0]->{'start'} ? 'checked' : '', $text{"yes"};
    printf "<input type=radio name=start value=0 %s> %s</td> </tr>\n",
        $_[0]->{'start'} ? '' : 'checked', $text{"no"};

    print "<tr> <td><b>".$text{"acl_stop"}."</b></td>\n";
    printf "<td><input type=radio name=stop value=1 %s> %s\n",
        $_[0]->{'stop'} ? 'checked' : '', $text{"yes"};
    printf "<input type=radio name=stop value=0 %s> %s</td> </tr>\n",
        $_[0]->{'stop'} ? '' : 'checked', $text{"no"};

    print "<tr> <td><b>".$text{"acl_restart"}."</b></td>\n";
    printf "<td><input type=radio name=restart value=1 %s> %s\n",
        $_[0]->{'restart'} ? 'checked' : '', $text{"yes"};
    printf "<input type=radio name=restart value=0 %s> %s</td> </tr>\n",
        $_[0]->{'restart'} ? '' : 'checked', $text{"no"};

    print "<tr> <td><b>".$text{"acl_reload"}."</b></td>\n";
    printf "<td><input type=radio name=reload value=1 %s> %s\n",
        $_[0]->{'reload'} ? 'checked' : '', $text{"yes"};
    printf "<input type=radio name=reload value=0 %s> %s</td> </tr>\n",
        $_[0]->{'reload'} ? '' : 'checked', $text{"no"};

    print "<tr> <td><b>".$text{"acl_dump_logs"}."</b></td>\n";
    printf "<td><input type=radio name=dump_logs value=1 %s> %s\n",
        $_[0]->{'dump_logs'} ? 'checked' : '', $text{"yes"};
    printf "<input type=radio name=dump_logs value=0 %s> %s</td> </tr>\n",
        $_[0]->{'dump_logs'} ? '' : 'checked', $text{"no"};

    print "<tr> <td><b>".$text{"acl_view_logs"}."</b></td>\n";
    printf "<td><input type=radio name=view_logs value=1 %s> %s\n",
        $_[0]->{'view_logs'} ? 'checked' : '', $text{"yes"};
    printf "<input type=radio name=view_logs value=0 %s> %s</td> </tr>\n",
        $_[0]->{'view_logs'} ? '' : 'checked', $text{"no"};
}

# acl_security_save(&options)
# Parse the form for security options for the dnsmasq module
sub acl_security_save {
    $_[0]->{'start'} = $in{'start'};
    $_[0]->{'stop'} = $in{'stop'};
    $_[0]->{'restart'} = $in{'restart'};
    $_[0]->{'reload'} = $in{'reload'};
    $_[0]->{'dump_logs'} = $in{'dump_logs'};
    $_[0]->{'view_logs'} = $in{'view_logs'};
}

