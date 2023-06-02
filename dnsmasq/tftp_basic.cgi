#!/usr/bin/perl
#
#    DNSMasq Webmin Module - # TODO tftp_basic.cgi; TFTP/Bootp config
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

require 'dnsmasq-lib.pl';

my %access=&get_module_acl;

## put in ACL checks here if needed

my $config_filename = $config{config_file};
my $config_file = &read_file_lines( $config_filename );
my %dnsmconfig = ();

&parse_config_file( \%dnsmconfig, \$config_file, $config_filename );

&header($text{"index_title"}, "", "intro", 1, 0, 0, &restart_button());

my @basic_fields = ();
foreach my $configfield ( @conft_b_p ) {
    next if ( grep { /^$configfield$/ } ( @confarrs ) );
    next if ( %dnsmconfigvals{"$configfield"}->{"mult"} ne "" );
    next if ( ( ! grep { /^$configfield$/ } ( @confbools ) ) && ( ! grep { /^$configfield$/ } ( @confsingles ) ) );
    push @basic_fields, $configfield;
}
my $l = int(@basic_fields / 2);

print &ui_form_start( 'tftp_basic_apply.cgi', "get" );
my $cbtd = 'style="width: 15px; height: 31px;"';
my $customcbtd = 'class="ui_checked_checkbox flexed" style="width: 15px; height: 31px;"';
my $td = 'style="height: 31px; white-space: normal !important; word-break: normal;"';
my $bigtd = 'style="height: 31px; white-space: normal !important; word-break: normal;" colspan=2';
my @grid = ();
my @booltds = ( $cbtd, $bigtd );
my @tds = ( $cbtd, $td, $td );
my @cbtds = ( $customcbtd, $td, $td );
foreach my $column_array ([ @basic_fields[0..$l-1] ], [ @basic_fields[$l..$#basic_fields] ]) {
	my $g = &ui_columns_start( [
            "",
            $text{'column_option'},
            $text{'column_value'}
        ], undef, 0, \@tds);

    foreach my $configfield ( @$column_array ) {
        my $inputfield = &config_to_input("$configfield");
        my $help = &ui_help($configfield . ": " . $text{"p_man_desc_$inputfield"});
        if ( grep { /^$configfield$/ } ( @confbools ) ) {
            $g .= &ui_checked_columns_row( [
                    $text{"p_label_$inputfield"} . $help,
                    ""
                ], \@booltds, "sel", $configfield, ($dnsmconfig{"$configfield"}->{"used"})?1:0
            );
        }
        elsif ( grep { /^$configfield$/ } ( @confsingles ) ) {
            # if ( $configfield eq "dhcp-scriptuser" ) {
            #     $g .= &ui_columns_row( [
            #             '<div class="wh-100p flex-wrapper flex-centered flex-start">' . &ui_checkbox("sel", $configfield, undef, ($dnsmconfig{"$configfield"}->{"used"})?1:0, ) . '</div>',
            #             $text{"p_label_$inputfield"} . $help,
            #             &ui_user_textbox( $inputfield . "val", $dnsmconfig{"$configfield"}->{"val"} )
            #         ], \@cbtds
            #     );
            # }
            # elsif ( $configfield =~ /(file|dir|script)$/ ) {
            #     $g .= &ui_columns_row( [
            #             '<div class="wh-100p flex-wrapper flex-centered flex-start">' . &ui_checkbox("sel", $configfield, undef, ($dnsmconfig{"$configfield"}->{"used"})?1:0, ) . '</div>',
            #             $text{"p_label_$inputfield"} . $help,
            #             &ui_filebox( $inputfield . "val", $dnsmconfig{"$configfield"}->{"val"} )
            #         ], \@cbtds
            #     );
            # }
            # else {
                $g .= &ui_checked_columns_row( [
                        $text{"p_label_$inputfield"} . $help,
                        &ui_textbox( $inputfield . "val", $dnsmconfig{"$configfield"}->{"val"}, 25 )
                    ], \@tds, "sel", $configfield, ($dnsmconfig{"$configfield"}->{"used"})?1:0
                );
            # }
        }
    }
	$g .= &ui_columns_end();
	push(@grid, $g);
}
print &ui_grid_table(\@grid, 2, 100, undef, undef, $text{"index_tftp_settings_basic"});

print "<br><br>".&ui_submit( $text{"save_button"} );
print &ui_form_end( );
&ui_print_footer("index.cgi?mode=tftp", $text{"index_tftp_settings"}, "index.cgi?mode=dns", $text{"index_dns_settings"});

### END of tftp_basic.cgi ###.
