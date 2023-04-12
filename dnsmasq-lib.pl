#
# dnsmasq-lib.pl
#
# dnsmasq webmin module library module
#
#
# the config hash holds the parsed config file
# 
my %config = {
		errors => 0,
		mx_host => { used => 0, line => 0, host => "" },
		mx_target => { used => 0, line => 0, host => "" },
		selfmx => { used => 0, line => 0 },
		localmx => { used => 0, line => 0 },	
		domain_needed => { line => 0, used => 0 },
		bogus_priv => { line =>0, used => 0 },
		filterwin2k => { line => 0, used => 0 },
		resolv_file => { line => 0, used => 0,				
				filename => "/etc/hosts"
			       },
		strict_order => { line => 0, used => 0 },
		no_resolv => { line => 0, used => 0 },
		no_poll => { line => 0, used => 0 },
		servers => [],
		locals => [],
		forced => [],
		bogus => [],
		user => { used => 0, user =>"" },
		group => { used => 0, group => "" },
		interface =>  [],
		ex_interface =>  [],
		listen_on => 	[],
		alias => [],
		bind_interfaces => { used => 0, line => 0 },
		no_hosts => { used => 0, line => 0 },
		addn_hosts => { used => 0, line => 0, file => "" },
		expand_hosts => { used => 0, line => 0 },
 		domain => { used => 0, line => 0, domain => "" },
		cache_size => { used => 0, line =>0, size => 0 },
		neg_cache => { used => 0, line => 0 },
		local_ttl => { used => 0, line => 0, ttl => 0 },
		log_queries => { used => 0, line => 0 },	
		dhcp_range => [],
		dhcp_host => [],
		vendor_class => [],
		user_class => [],
		dhcp_option => [],
		dhcp_boot => { used => 0, line => 0, file => "",
				host => "", address => "" },
		dhcp_leasemax => { used => 0, line => 0, max => 0 },
		dhcp_leasefile => { used => 0, line => 0, file => "" },
		dhcp_ethers => { used => 0, line => 0 }
	     };
#
# parse the configuration file and populate the %config structure
# 
sub parse_config_file
{
	
my $lineno;
my $config = shift;
my $config_file = shift;
$IPADDR = "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}";
$NAME = "[a-zA-Z\_\.][0-9a-zA-Z\_\.]*";
$TIME = "[0-9}+[h|m]*";
$FILE = "[0-9a-zA-Z\_\-\.\/]+";
$NUMBER="[0-9]+";

$lineno=-1;
foreach my $line (@$$config_file)
{
	my $subline;
	my %temp;
	
	$lineno++;
	if (defined ($line))
	{
		#
		# we always use regexp starting with 
		# ^[\#]*[\s]*
		# because that allows for a commented out line with
		#  possibly space(s) between the comment marker and keyword
		# while rejecting any comments that carry our keyword
		#
		# reject lines blank at start!
		next if ($line !~ /^[0-9a-zA-Z\_\-\#]/);
		# MX records server?
		if ( $line =~ /(^[\#]*[\s]*mx-host)\=([0-9a-zA-Z\.\-]*)/ )
		{
		}
		elsif ($line =~ /(^[\#]*[\s]*mx-target)\=([0-9a-zA-Z\.\-]*)/ )
		{
		}
		elsif ($line =~ /^[\#]*[\s]*selfmx/ )
		{
			$$config{selfmx}{line}=$lineno;
			$$config{selfmx}{used}=($line !~ /^\#/);
		}
		elsif ($line =~ /^[\#]*[\s]*localmx/ )
		{
			$$config{localmx}{line}=$lineno;
			$$config{localmx}{used}=($line !~ /^\#/);
		}
		# forward names witout a domain?
		elsif ($line =~ /^[\#]*[\s]*domain-needed/ )
		{
			$$config{domain_needed}{used}=($line!~/^\#/);
			$$config{domain_needed}{line}=$lineno;
		}
		#forward names in nonrouted address space?
		elsif ($line =~ /^[\#]*[\s]*bogus-priv/ )
		{
			$$config{bogus_priv}{used}=($line!~/^\#/);
			$$config{bogus_priv}{line}=$lineno;
		}
		# filter windows wierdo names?
		elsif ($line =~ /^[\#]*[\s]*filterwin2k/ )
		{
			$$config{filterwin2k}{used}=($line!~/^\#/);
			$$config{filterwin2k}{line}=$lineno;
		}
		# resolv.conf file
		elsif ($line =~ /(^[\#]*[\s]*resolv-file\=)([0-9a-zA-Z\/\.\-]*)/ )
		{
			$$config{resolv_file}{filename}=$2;
			$$config{resolv_file}{line}=$lineno;
			$$config{resolv_file}{used}=($line!~/^\#/);
		}
		# any resolv.conf file at all?
		elsif ($line =~ /^[\#]*[\s]*no-resolv/ )
		{
			$$config{no_resolv}{used}=($line!~/^\#/);
			$$config{no_resolv}{line}=$lineno;
		}
		# upstream servers in order?
		elsif ($line =~ /^[\#]*[\s]*strict-order/ )
		{
			$$config{strict_order}{used}=($line!~/^\#/);
			$$config{strict_order}{line}=$lineno;
		}
		# check resolv. conf regularly?
		elsif ($line =~ /^[\#]*[\s]*no-poll/ )
		{
			$$config{no_poll}{used}=($line!~/^\#/);
			$$config{no_poll}{line}=$lineno;
		}
		# extra name servers?
		elsif ($line =~ /(^[\#]*[\s]*server\=)([0-9a-zA-Z\.\-\/]*)/ )
		{
			$subline=$2;
			%temp = {};
			if( $subline =~ /\/($NAME)\/($IPADDR)/ )
			{
				$temp{domain}=$1;
				$temp{domain_used}=1;
				$temp{address}=$2;
				$temp{line}=$lineno;
				$temp{used}= ($line !~ /^\#/);
				push @{ $$config{servers} }, { %temp };
			}
			elsif( $subline =~ /($IPADDR)/ )
			{
				$temp{domain}="";
				$temp{domain_used}=0;
				$temp{address}=$1;
				$temp{line}=$lineno;
				$temp{used}= ($line !~ /^\#/);
				push @{ $$config{servers} }, { %temp };
			}
			else
			{
				print "Error in line $lineno!";
				$$config{errors}++;
			}
		}
		# local-only domains
		elsif ($line =~ /(^[\#]*[\s]*local\=)([0-9a-zA-Z\.\-\/]*)/ )
		{
			$subline=$2;
			%temp={};
			if( $subline =~ /\/($NAME)\// )
			{
				$temp{domain}=$1;
				$temp{lineno}=$lineno;
				$temp{used}=($line !~ /^\#/);
				push @{ $$config{locals} }, { %temp };
			}
			else
			{
				print "Error in line $lineno!";
				$$config{errors}++;
			}
		}
		# force lookups to addresses
		elsif ($line =~ /(^[\#]*[\s]*address\=)([0-9a-zA-Z\.\-\/]*)/ )
		{
			$subline=$2;
			%temp = {};
			if( $subline =~ /\/($NAME)\/($IPADDR)/ )
			{
				$temp{line}=$lineno;
				$temp{domain}=$1;
				$temp{addr}=$2;
				$temp{used}=($line !~ /^\#/);
				push @{ $$config{forced} }, { %temp };
			}
			else
			{
				print "Error in line $lineno!";
				$$config{errors}++;
			}
		}
		# deprecated /etc/ppp/resolv.conf permissions
		elsif ($line =~ /(^[\#]*[\s]*user\=)([0-9a-zA-Z\.\-\/]*)/ )
		{
		}
		elsif ($line =~ /(^[\#]*[\s]*group\=)([0-9a-zA-Z\.\-\/]*)/ )
		{
		}
		# where and how do we listen?
		elsif ($line =~ /(^[\#]*[\s]*listen-address\=)([0-9\.]*)/ )
		{
			$subline=$2;
			%temp = {};
			if( $subline =~ /($IPADDR)/ )
			{
				$temp{line}=$lineno;
				$temp{address}=$1;
				$temp{used}= ($line !~ /^\#/);
				push @{ $$config{listen_on} }, { %temp };
			}
			else
			{
				print "Error in line $lineno!";
				$$config{errors}++;
			}
		}
		elsif ($line =~ /(^[\#]*[\s]*except-interface\=)([0-9a-zA-Z\.\-\/]*)/ )
		{
			$subline=$2;
			%temp = {};
			if( $subline =~ /($NAME)/ )
			{
				$temp{line}=$lineno;
				$temp{iface}=$1;
				$temp{used}= ($line !~ /^\#/);
				push @{ $$config{ex_interface} }, { %temp };
			}
			else
			{
				print "Error in line $lineno!";
				$$config{errors}++;
			}
		}
		elsif ($line =~ /(^[\#]*[\s]*interface\=)([0-9a-zA-Z\.\-\/]*)/ )
		{
			$subline=$2;
			%temp = {};
			if( $subline =~ /($NAME)/ )
			{
				$temp{line}=$lineno;
				$temp{iface}=$1;
				$temp{used}= ($line !~ /^\#/);
				push @{ $$config{interface} }, { %temp };
			}
			else
			{
				print "Error in line $lineno!";
				$$config{errors}++;
			}
		}
		elsif ($line =~ /^[\#]*[\s]*bind-interfaces/ )
		{
			$$config{bind_interfaces}{used}=($line!~/^\#/);
			$$config{bind_interfaces}{line}=$lineno;
		}
		# hosts file
		elsif ($line =~ /^[\#]*[\s]*no-hosts/ )
		{
			$$config{no_hosts}{used}=($line!~/^\#/);
			$$config{no_hosts}{line}=$lineno;
		}
		elsif ($line =~ /(^[\#]*[\s]*addn-hosts\=)([0-9a-zA-Z\_\.\-\/]*)/ )
		{
			$$config{addn_hosts}{line}=$lineno;
			$$config{addn_hosts}{file}=$2;
			$$config{addn_hosts}{used}=($line!~/^\#/);
		}
		# add domain to hosts file?
		elsif ($line =~ /^[\#]*[\s]*expand-hosts/ )
		{
			$$config{expand_hosts}{used}=($line!~/^\#/);
			$$config{expand_hosts}{line}=$lineno;
		} 
		# translate wild-card responses to NXDOMAIN
		elsif ($line =~ /(^[\#]*[\s]*bogus-nxdomain\=)([0-9\.]*)/ )
		{
			$subline=$2;
			%temp = {};
			if( $subline =~ /($IPADDR)/ )
			{
				$temp{line}=$lineno;
				$temp{addr}=$1;
				$temp{used}= ($line !~ /^\#/);
				push @{ $$config{bogus} }, { %temp };
			}
			else
			{
				print "Error in line $lineno!";
				$$config{errors}++;
			}
		}
		# local domain
		elsif ($line =~ /(^[\#]*[\s]*domain\=)([0-9a-zA-Z\.\-\/]*)/ )
		{
			$$config{domain}{line}=$lineno;
			$$config{domain}{domain}=$2;
			$$config{domain}{used}=($line!~/^\#/);
		}
		# cache size
		elsif ($line =~ /(^[\#]*[\s]*cache-size\=)([0-9]*)/ )
		{
			$$config{cache_size}{line}=$lineno;
			$$config{cache_size}{size}=$2;
			$$config{cache_size}{used}=($line !~/^\#/);
		}
		# negative cache 
		elsif ($line =~ /(^[\#]*[\s]*no-negcache)/ )
		{
			$$config{neg_cache}{line}=$lineno;
			$$config{neg_cache}{used}=($line !~/^\#/);
		}
		# local ttl
		elsif ($line =~ /(^[\#]*[\s]*local-ttl\=)([0-9]*)/ )
		{
			$$config{local_ttl}{line}=$lineno;
			$$config{local_ttl}{ttl}=$2;
			$$config{local_ttl}{used}=($line !~/^\#/);
		}
		# log requests? 
		elsif ($line =~ /(^[\#]*[\s]*log-queries)/ )
		{
			$$config{log_queries}{line}=$lineno;
			$$config{log_queries}{used}=($line !~/^\#/);
		}
		# alias IP addresses
		elsif ($line =~ /(^[\#]*[\s]*alias\=)([0-9\.\,]*)/ )
		{
			$subline=$2;
			%temp = {};
			if( $subline =~ /($IPADDR)\,($IPADDR)\,($IPADDR)/ )
			{ # with netmask
				$temp{line}=$lineno;
				$temp{from}=$1;
				$temp{to}=$2;
				$temp{netmask}=$3;
				$temp{netmask_used}=1;
				$temp{used}= ($line !~ /^\#/);
				push @{ $$config{alias} }, { %temp };
			}
			elsif( $subline =~ /($IPADDR)\,($IPADDR)/ )
			{ # no netmask
				$temp{line}=$lineno;
				$temp{from}=$1;
				$temp{to}=$2;
				$temp{netmask}=0;
				$temp{netmask_used}=0;
				$temp{used}= ($line !~ /^\#/);
				push @{ $$config{alias} }, { %temp };
			}
			else
			{
				print "Error in line $lineno!";
				$$config{errors}++;
			}
		}
		# DHCP
		# address range to use
		elsif ($line =~ /(^[\#]*[\s]*dhcp-range\=)([0-9a-zA-Z\.\,\-\_]*)/ )
		{
			%temp={};
			$subline=$2;
			$temp{line}=$lineno;
			$temp{used}=($line !~/^\#/);
			if ($subline =~ /^($NAME)\,($IPADDR)\,($IPADDR)\,($IPADDR)(\,*)(\d*[mh]*)/ )
			{
				# network id, start, end, netmask, time (optionally)
				$temp{id}=$1;
				$temp{id_used}=1;
				$temp{start}=$2;
				$temp{end}=$3;
				$temp{mask}=$4;
				$temp{mask_used}=1;
				$temp{leasetime}=$6;
				$temp{time_used}=($6 =~ /^\d/);
				$temp{used} =( $line !~ /^\#/ );
				push @{ $$config{dhcp_range} }, { %temp };
			}
			elsif ($subline =~ /^($NAME)\,($IPADDR)\,($IPADDR)(\,*)(\d*[mh]*)/ )
			{
				# network id, start, end, time (optionally)
				$temp{id}=$1;
				$temp{id_used}=1;
				$temp{start}=$2;
				$temp{end}=$3;
				$temp{mask}="";
				$temp{mask_used}=0;
				$temp{leasetime}=$5;
				$temp{time_used}=($5 =~ /^\d/);
				$temp{used} =( $line !~ /^\#/ );
				push @{ $$config{dhcp_range} }, { %temp };
			}
			elsif ($subline =~ /^($IPADDR)\,($IPADDR)\,($IPADDR)(\,*)(\d*[mh]*)/ )
			{
				# start, end, netmask, time (optionally)
				$temp{id}="";
				$temp{id_used}=0;
				$temp{start}=$1;
				$temp{end}=$2;
				$temp{mask}=$3;
				$temp{mask_used}=1;
				$temp{leasetime}=$5;
				$temp{time_used}=($5 =~ /^\d/);
				$temp{used} =( $line !~ /^\#/ );
				push @{ $$config{dhcp_range} }, { %temp };
			}
			elsif ($subline =~ /^($IPADDR)\,($IPADDR)(\,*)(\d*[mh]*)/ )
			{
				# start, end, time (optionally)
				$temp{id}="";
				$temp{id_used}=0;
				$temp{start}=$1;
				$temp{end}=$2;
				$temp{mask}="";
				$temp{mask_used}=0;
				$temp{leasetime}=$4;
				$temp{time_used}=($4 =~ /^\d/);
				$temp{used} =( $line !~ /^\#/ );
				push @{ $$config{dhcp_range} }, { %temp };
			}
			else
			{
				print "Error in line $lineno!";
				$$config{errors}++;
			}
		}
		# specify hosts
		elsif ($line =~ /(^[\#]*[\s]*dhcp-host\=)([0-9a-zA-Z\.\:\,\*]*)/)
		{
			# too many to classify - all as string!
			%temp = {};
			$temp{line}=$lineno;
			$temp{option}=$2;
			$temp{used}=($line !~/^\#/);
			push @{ $$config{dhcp_host} }, { %temp };
		}
		# vendor class
		elsif ($line =~ /(^[\#]*[\s]*dhcp-vendorclass\=)($NAME)\,($NAME)/ )
		{
			%temp = {};
			$temp{line}=$lineno;
			$temp{class}=$2;
			$temp{vendor}=$3;
			$temp{used}=($line !~/^\#/);
			push @{ $$config{vendor_class} }, { %temp };
		}
		# user class
		elsif ($line =~ /(^[\#]*[\s]*dhcp-userclass\=)($NAME)\,($NAME)/ )
		{
			%temp = {};
			$temp{line}=$lineno;
			$temp{class}=$2;
			$temp{user}=$3;
			$temp{used}=($line !~/^\#/);
			push @{ $$config{user_class} }, { %temp };
		}
		# /etc/ethers?
		elsif ($line =~ /(^[\#]*[\s]*read-ethers)/ )
		{
			$$config{dhcp_ethers}{line}=$lineno;
			$$config{dhcp_ethers}{used}=($line !~/^\#/);
		}
		# dchp options
		elsif ($line =~ /(^[\#]*[\s]*dhcp-option\=)([0-9a-zA-Z\,\_\.]*)/ )
		{
			# too many to classify - all as string!
			%temp = {};
			$temp{line}=$lineno;
			$temp{option}=$2;
			$temp{used}=($line !~/^\#/);
			push @{ $$config{dhcp_option} }, { %temp };
		}
		# lease time
		elsif ($line =~ /(^[\#]*[\s]*dhcp-lease-max\=)([0-9]*)/ )
		{
			$$config{dhcp_leasemax}{line}=$lineno;
			$$config{dhcp_leasemax}{max}=$2;
			$$config{dhcp_leasemax}{used}=($line !~/^\#/);
		}
		# bootp host & file
		elsif ($line =~ /(^[\#]*[\s]*dhcp-boot\=)([0-9a-zA-Z0-9\,\_\.\/]*)/ )
		{
			$subline=$2;
			if( $subline =~ /([0-9a-zA-Z\.\-\_\/]+)\,($NAME)\,($IPADDR)/ )
			{
				$$config{dhcp_boot}{line}=$lineno;
				$$config{dhcp_boot}{file}=$1;
				$$config{dhcp_boot}{host}=$2;
				$$config{dhcp_boot}{address}=$3;
				$$config{dhcp_boot}{used}=($line !~/^\#/);
			}
		}
		#  leases file
		elsif ($line =~ /(^[\#]*[\s]*dhcp-leasefile\=)([0-9a-zA-Z0-9\_\.\/]*)/ )
		{
			$$config{dhcp_leasefile}{line}=$lineno;
			$$config{dhcp_leasefile}{file}=$2;
			$$config{dhcp_leasefile}{used}=($line !~/^\#/);
		}
		else
		{
			# everything else that's not a comment 
			# we don't understand so it may be an error!
			if( $line !~ /^#/ )
			{
				$config{errors}++;
			}
		}
	}
}

} #end of sub read_config_file
#
# update the config file array
#
# arguments are:
# 	$lineno - the line number (array index) to update
# 	$text   - the new contents of the line
# 	$file   - reference to the array to change
# 	$comm   - put a comment marker ('#') at start of line?
# 	          false (0) means comment the line
#
sub update
{
	my $lineno = shift;
	my $text = shift;
	my $file = shift;
	my $comm = shift;
	my $line;

	$line = ( $comm != 0 ) ?
		$text :
		"#" . $text;
	if( $lineno == 0 )
	{
		push @$file, $line;
	}
	else
	{
		@$file[$lineno]=$line;
	}
} # end of sub update
1;
