#!/usr/bin/perl
#
#    DNSMasq Webmin Module - tftp.cgi; TFTP, bootp, & pxe config     
#    Copyright (C) 2023 by Loren Cress
#    
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    This module based on the DNSMasq Webmin module by Neil Fisher

sub show_tftp_settings {
    # &header( "DNSMasq settings", "" );
    # &parse_config_file( \%dnsmconfig, \$config_file, \$config_filename );
    print &ui_form_start( 'basic_apply.cgi', "post" );
    # print "<br>\n";
    # print "<h2>$text{"index_dns_settings"}</h2>";
    # print "<br><br>\n";
    print $text{"local_domain"};
    print &ui_textbox( "local_domain", $dnsmconfig{"domain"}->{domain}, 32 );
    print "<br><br>\n";
    print $text{"domain_needed"};
    print &ui_yesno_radio( "domain_needed", ($dnsmconfig{"domain-needed"}->{used})?1:0 );
    print "<br><br>\n";
    print $text{"expand_hosts"};
    print &ui_yesno_radio( "expand_hosts", ($dnsmconfig{"expand-hosts"}->{used})?1:0 );
    print "<br><br>\n";
    print $text{"bogus_priv"};
    print &ui_yesno_radio( "bogus_priv", ($dnsmconfig{"bogus-priv"}->{used})?0:1 );
    print "<br><br>\n";
    print $text{"filterwin2k"};
    print &ui_yesno_radio( "filterwin2k", ($dnsmconfig->{'filterwin2k'}->{used})?1:0 );
    print "<br><br>\n";
    print $text{"hosts"};
    print &ui_yesno_radio( "hosts", ($dnsmconfig{"no-hosts"}->{used}?0:1) );
    # print "<br>\n";
    # print $text{"xhosts"};
    # print &ui_yesno_radio( "xhosts", ($dnsmconfig{"addn-hosts"}->{used}?1:0) );
    # print "<br>\n";
    # print $text{"xhostsfile"};
    # print &ui_textbox( "addn_hosts", $dnsmconfig{"addn-hosts"}->{file}, 40 );
    print "<br><br>\n";
    print $text{"no_negcache"};
    print &ui_yesno_radio( "no-negcache", ($dnsmconfig{"no-negcache"}->{used}?0:1) );
    print "<br><br>\n";
    print $text{"cache_size"};
    print &ui_yesno_radio( "cache_size", ($dnsmconfig{"cache-size"}->{used}?1:0) );
    print "<br>\n";
    print $text{"cust_cache_size"};
    print &ui_textbox( "cust_cache_size", $dnsmconfig{"cache-size"}->{size}, 40 );
    print "<br><br>\n";
    print $text{"log_queries"};
    print &ui_yesno_radio( "log_queries", ($dnsmconfig{"log-queries"}->{used}?1:0) );
    print "<br><br>\n";
    print $text{"local_ttl"};
    print &ui_yesno_radio( "local_ttl", ($dnsmconfig{"local-ttl"}->{used}?1:0) );
    print "<br>\n";
    print $text{"ttl"};
    print &ui_textbox( "ttl", $dnsmconfig{"local-ttl"}->{ttl}, 40 );
    print "<br><br>\n";
    print $text{"p_desc_sh_conf_file"};
    print &ui_textbox( "conf_file", $dnsmconfig{"conf-file"}[0]{filename}, 40 );
    print "<br><br>\n";
    print $text{"p_desc_sh_conf_dir"};
    print &ui_textbox( "conf_dir", $dnsmconfig{"conf-dir"}[2]{dirname}, 40 );
    print "<br>\n";
    print $text{"p_desc_sh_conf_dir_filter"};
    print &ui_textbox( "conf_dir_filter", $dnsmconfig{"conf-dir"}[2]{filter}, 40 );
    print "<br>\n";
    print $text{"p_desc_sh_conf_dir_exceptions"};
    print &ui_textbox( "conf_dir_exceptions", $dnsmconfig{"conf-dir"}[2]{exceptions}, 40 );
    print "<br><br>\n";
    print &ui_submit( $text{"save_button"} );
    print &ui_form_end( );
    print "<hr>";
    print "<a href=\"dns_servers.cgi\">";
    print $text{"dns_servers_config"};
    print "</a><br>";
    print "<a href=\"dns_iface.cgi\">";
    print $text{"dns_iface_config"};
    print "</a><br>";
    print "<a href=\"dns_alias.cgi\">";
    print $text{"dns_alias_config"};
    print "</a><br>";
    print "<hr>";
    print "<a href=\"dhcp.cgi\">";
    print $text{"dhcp_config"};
    print "</a><br>";
    print "<hr>";
    print "<a href=\"restart.cgi\">";
    print $text{"restart"};
    print "</a><br>";
    # &footer("/", $text{"index"});
}
1;
# uses the index entry in /lang/en



## if subroutines are not in an extra file put them here


### END of index.cgi ###.
