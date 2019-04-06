#! perl

######################################################################
# Copyright (c) 2017 Castalia Solutions
#
# This program and the accompanying materials are made
# available under the terms of the Eclipse Public License 2.0
# which is available at https://www.eclipse.org/legal/epl-2.0/
#
# SPDX-License-Identifier: EPL-2.0
######################################################################

use strict;
use warnings;

use utf8;

use Mail::Box::Manager;
use Text::CSV;

use Data::Dumper;
use DateTime::Format::Strptime;
use File::Basename;
use Encode qw(encode decode);
use Encoding::FixLatin qw(fix_latin);


my $usage = <<EOU;
usage: $0 [-h|--help] mbox_file key

$0 retrieves emails from a mbox file and creates a CSV file.

Parameters:
* [-h|--help]             Display usage and exit
* mbox_file               The mbox file to read
* key                     The key to use for encryption, if any.

If a key is provided, then is it used for the encryption and headers are not
added to generated csv files.
 
Examples:
\$ $0 Inbox.mbox

EOU

my $file_mbox = shift or die $usage;
    
my $list = basename($file_mbox);

my $file_out = $list . ".csv";

my $stats = 0;
my $errors = 0;

print "# $0 \n";
print "# Executed on " . localtime() . "\n";

# Create object for mbox parsing. 
# For more details, see https://metacpan.org/release/Mail-Box
my $mgr    = Mail::Box::Manager->new;


# Create Text::CSV object for output
my $csv = Text::CSV->new(
    {sep_char => ',', binary => 1, quote_char => '"', auto_diag => 1}
    )
    or die "Cannot use CSV: " . Text::CSV->error_diag();

my ($csv_out, @posts);

print "# Opening list [$list] from folder [$file_mbox].\n";
my $folder = $mgr->open( folder => $file_mbox );

foreach my $message ($folder->messages) {
    if ($message->isDummy()) { print "DUMMY! \n"; next; }
#    print "  - " . ( $message->get('Subject') || '<no subject>' ) . "\n";
    &_insert_message($list, $message);
}


$folder->close();

print "\n# Writing CSV to file [$file_out].\n";
open(my $fh, '>', $file_out) or die "Could not open file '$file_out' $!";
print $fh $csv_out;
close $fh;

print "\nFinished $list. Got $stats emails in CSV and $errors errors.\n";
print "Bye. \n";

sub _insert_message {
    my ($list, $message) = @_;

    my $message_id = defined($message->messageId()) ? 
	$message->messageId() :
	'No messageId';
    my $subject = $message->subject() || 'no subject';
    my $timestamp = $message->timestamp() || 'no timestamp'; 

    my $sender_name = defined($message->sender()->phrase()) ? 
	$message->sender()->phrase() :
	''; 
    my $sender_addr = defined($message->sender()->address()) ? 
	$message->sender()->address() :
	'';
    my $body = defined($message->decoded()) ? 
	$message->decoded() :
	'No body';

    my $date = DateTime->from_epoch( epoch => $timestamp );
    my $date_fmt = $date->strftime("%Y-%m-%d %H:%M:%S");
    
    # Create CSV line
    my $insert_ok = eval {
	my @values = (
	    $list,
	    fix_latin($message_id),
            fix_latin($subject), 
            fix_latin($date_fmt), 
            fix_latin($sender_name), 
            fix_latin($sender_addr), 
	    );
        $csv->combine( @values );
	$csv_out .= $csv->string() . "\n";
    };
    if ( defined($insert_ok) ) { 
        $stats++;
    } else {
        print "######################\n";  
        print "Failed with message " . Dumper($subject);
        print "Author is " . Dumper($sender_addr);
        print $@;
        print "######################\n";  
    }

    my $post = {
	'list' => $list,
	'id' => fix_latin($message_id),
	'sub' => fix_latin($subject), 
        'sent' => fix_latin($date_fmt), 
        'name' => fix_latin($sender_name), 
        'addr' => fix_latin($sender_addr), 
        'body' => fix_latin($body), 
    };
    push( @posts, $post );
    
    return $insert_ok;
}
