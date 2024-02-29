
require 'dnsmasq-lib.pl';

# acl_security_form(&options)
# Output HTML for editing security options for the dnsmasq module
sub acl_security_form {

    print "<tr> <td><b>".$dnsmasq::text{"acl_start"}."</b></td>\n";
    printf "<td><input type=radio name=start value=1 %s> %s\n",
        $_[0]->{'start'} ? 'checked' : '', $dnsmasq::text{"yes"};
    printf "<input type=radio name=start value=0 %s> %s</td> </tr>\n",
        $_[0]->{'start'} ? '' : 'checked', $dnsmasq::text{"no"};

    print "<tr> <td><b>".$dnsmasq::text{"acl_stop"}."</b></td>\n";
    printf "<td><input type=radio name=stop value=1 %s> %s\n",
        $_[0]->{'stop'} ? 'checked' : '', $dnsmasq::text{"yes"};
    printf "<input type=radio name=stop value=0 %s> %s</td> </tr>\n",
        $_[0]->{'stop'} ? '' : 'checked', $dnsmasq::text{"no"};

    print "<tr> <td><b>".$dnsmasq::text{"acl_restart"}."</b></td>\n";
    printf "<td><input type=radio name=restart value=1 %s> %s\n",
        $_[0]->{'restart'} ? 'checked' : '', $dnsmasq::text{"yes"};
    printf "<input type=radio name=restart value=0 %s> %s</td> </tr>\n",
        $_[0]->{'restart'} ? '' : 'checked', $dnsmasq::text{"no"};

    print "<tr> <td><b>".$dnsmasq::text{"acl_reload"}."</b></td>\n";
    printf "<td><input type=radio name=reload value=1 %s> %s\n",
        $_[0]->{'reload'} ? 'checked' : '', $dnsmasq::text{"yes"};
    printf "<input type=radio name=reload value=0 %s> %s</td> </tr>\n",
        $_[0]->{'reload'} ? '' : 'checked', $dnsmasq::text{"no"};

    print "<tr> <td><b>".$dnsmasq::text{"acl_dump_logs"}."</b></td>\n";
    printf "<td><input type=radio name=dump_logs value=1 %s> %s\n",
        $_[0]->{'dump_logs'} ? 'checked' : '', $dnsmasq::text{"yes"};
    printf "<input type=radio name=dump_logs value=0 %s> %s</td> </tr>\n",
        $_[0]->{'dump_logs'} ? '' : 'checked', $dnsmasq::text{"no"};

    print "<tr> <td><b>".$dnsmasq::text{"acl_view_logs"}."</b></td>\n";
    printf "<td><input type=radio name=view_logs value=1 %s> %s\n",
        $_[0]->{'view_logs'} ? 'checked' : '', $dnsmasq::text{"yes"};
    printf "<input type=radio name=view_logs value=0 %s> %s</td> </tr>\n",
        $_[0]->{'view_logs'} ? '' : 'checked', $dnsmasq::text{"no"};

    print "<tr> <td><b>".$dnsmasq::text{"acl_edit_hosts"}."</b></td>\n";
    printf "<td><input type=radio name=edit_hosts value=1 %s> %s\n",
        $_[0]->{'edit_hosts'} ? 'checked' : '', $dnsmasq::text{"yes"};
    printf "<input type=radio name=edit_hosts value=0 %s> %s</td> </tr>\n",
        $_[0]->{'edit_hosts'} ? '' : 'checked', $dnsmasq::text{"no"};

    print "<tr> <td><b>".$dnsmasq::text{"acl_edit_scripts"}."</b></td>\n";
    printf "<td><input type=radio name=edit_scripts value=1 %s> %s\n",
        $_[0]->{'edit_scripts'} ? 'checked' : '', $dnsmasq::text{"yes"};
    printf "<input type=radio name=edit_scripts value=0 %s> %s</td> </tr>\n",
        $_[0]->{'edit_scripts'} ? '' : 'checked', $dnsmasq::text{"no"};

    print "<tr> <td><b>".$dnsmasq::text{"acl_manual_edit"}."</b></td>\n";
    printf "<td><input type=radio name=manual_edit value=1 %s> %s\n",
        $_[0]->{'manual_edit'} ? 'checked' : '', $dnsmasq::text{"yes"};
    printf "<input type=radio name=manual_edit value=0 %s> %s</td> </tr>\n",
        $_[0]->{'manual_edit'} ? '' : 'checked', $dnsmasq::text{"no"};

    print "<tr> <td><b>".$dnsmasq::text{"acl_change_perms"}."</b></td>\n";
    printf "<td><input type=radio name=change_perms value=1 %s> %s\n",
        $_[0]->{'change_perms'} ? 'checked' : '', $dnsmasq::text{"yes"};
    printf "<input type=radio name=change_perms value=0 %s> %s</td> </tr>\n",
        $_[0]->{'change_perms'} ? '' : 'checked', $dnsmasq::text{"no"};
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
    $_[0]->{'edit_hosts'} = $in{'edit_hosts'};
    $_[0]->{'edit_scripts'} = $in{'edit_scripts'};
    $_[0]->{'manual_edit'} = $in{'manual_edit'};
    $_[0]->{'change_perms'} = $in{'change_perms'};
}

