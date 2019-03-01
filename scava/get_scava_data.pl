#! /usr/bin/env perl

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

use Mojo::UserAgent;
use Mojo::JSON qw(decode_json encode_json);
use Data::Dumper;

# Prepare for http requests
my $ua  = Mojo::UserAgent->new;

sub get_url() {
    my $url_in = shift;

    my $res = $ua->get($url_in)->result;

    if (not $res->is_success) {
        print "Error: Could not get resource $url_in.\n";
        print $res->message . "\n";
        exit;
    }

    # Decode JSON from server
    my $data = decode_json($res->body);

    return $data
}


# Send GET request

print "\n\n";
print "# FACTOIDS:\n";

my $f = &get_url("http://ci4.castalia.camp:8182/factoids/");
my %factoids;
for my $factoid (@{$f}) {
    $factoids{ $factoid->{'id'} }->{'name'} = $factoid->{'name'};
    $factoids{ $factoid->{'id'} }->{'description'} = $factoid->{'description'};
}

print Dumper(%factoids);

#for my $f (@factoids) {
#    print "  - " .  . ": " . $f->{'summary'} . "\n";
#}

print "\n\n";
print "# METRICS:\n";

my $m = &get_url("http://ci4.castalia.camp:8182/metrics/");
my %metrics; 
for my $metric (@{$m}) {
    $metrics{ $metric->{'id'} }->{'name'} = $metric->{'name'};
    $metrics{ $metric->{'id'} }->{'description'} = $metric->{'description'};
}

print Dumper(%metrics);
print "\n\n";


print "# Retrieving list of projects.";
my $p = &get_url("http://ci4.castalia.camp:8086/administration/projects/");
my @projects = map { $_->{'shortName'} } @$p;

for my $project (@projects) {

    print "# Metrics for project $project\n";
    for my $metric (keys %metrics) {
        print "   - $metric [http://ci4.castalia.camp:8182/projects/p/$project/m/$metric].\n";
        my $m = &get_url("http://ci4.castalia.camp:8182/projects/p/$project/m/$metric");
        print "     " . Dumper($m) . "\n";
    }

    print "# Retrieving similar projects for $project.";
    my $s = &get_url("http://ci4.castalia.camp:8080/api/recommendation/similar/p/$project/m/Compound/n/3");
    print Dumper($s);

}






























