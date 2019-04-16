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

use Text::CSV;
use Anonymise::Utilities;

use Data::Dumper;
use DateTime::Format::Strptime;
use File::Basename;
use Encode qw(encode decode);
use Encoding::FixLatin qw(fix_latin);


my $usage = <<EOU;
usage: $0 [-h|--help] csv_file

$0 cleans a csv file and anonymises data.

Parameters:
* [-h|--help]             Display usage and exit
* csv_file                The mbox file to read

Examples:
\$ $0 dataset.csv

EOU

my $file_csv = shift or die $usage;

my $file_out; 
if ( $file_csv =~ m!^(.+)\.csv$! ) {
    $file_out = $1 . "_out.csv";
} else {
    $file_out = $file_csv . "_out.csv";
}
    
my $stats = 0;

print "# $0 \n";
print "# Executed on " . localtime() . "\n";

# Create Anonymise::Utilities object 
my $anon = Anonymise::Utilities->new();

print "# Generating key.\n";
$anon->create_keys();

# Create Text::CSV object for input
my $csv_in = Text::CSV->new(
    {sep_char => ',', binary => 1, quote_char => '"', auto_diag => 1}
    )
    or die "Cannot use CSV: " . Text::CSV->error_diag();

# Create Text::CSV object for output
my $csv_out = Text::CSV->new(
    {sep_char => ',', binary => 1, quote_char => '"', auto_diag => 1}
    )
    or die "Cannot use CSV: " . Text::CSV->error_diag();

my $csv_str;

# Initialise headers
my @fields = ('list', 'messageid', 'subject', 'sent_at', 'sender_name', 'sender_addr');
$csv_out->combine(@fields);
$csv_str = $csv_out->string() . "\n";

# Now open the file, read, anonymise, write.
open(my $fh, '<', $file_csv) or die "Could not open '$file_csv' $!\n";

# Remove first line (headers)
my $line = <$fh>;
print "Removed first line: $line.\n";

my $c = 0;
while ($line = <$fh>) {
  chomp $line; 
  eval {
      if ($csv_in->parse($line)) {
          my @fields_in = $csv_in->fields();
          my @fields_out;
          # remove '.mbox' from list
          $fields_in[0] =~ m!^(\S+)\.mbox$!;
          $fields_out[0] = $1 || 'UNKNOWN';
          # Scramble fields
          $fields_out[1] = $anon->scramble_email($fields_in[1]) || 'UNKNOWN';
          $fields_out[2] = $fields_in[2];
          $fields_out[3] = $fields_in[3];
          $fields_out[4] = $anon->scramble_string($fields_in[4]) || 'UNKNOWN';
          $fields_out[5] = $anon->scramble_email($fields_in[5]) || 'UNKNOWN';      
          $csv_out->combine(@fields_out);
          $csv_str .= $csv_out->string() . "\n";
          $stats++;
      } else {
          warn "Line could not be parsed: $line\n";
      }
      if ( ++$c % 1000 == 0) {
          print "\nProcessed $c messages.. ";
      } else {
          print "*";
      }
    };
    if ($@) {
      warn "Line could not be parsed: $line\n";
    }
}
close($fh);

print "\n# Writing to file [$file_out].\n";
open($fh, '>', $file_out) or die "Could not open file '$file_out' $!";
print $fh $csv_str;
close $fh;

print "\nFinished. Got $stats emails in CSV.\n";
print "Bye. \n";

