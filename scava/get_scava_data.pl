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

sub write_file() {
    my $json = shift;
    my $file_out = shift;

    open my $fh, '>', $file_out or die "Cannot open file $file_out.\n";
    print $fh $json;
    close $fh;
}

# Send GET request

print "\n\n";
print "# FACTOIDS:\n";

my $f = &get_url("http://ci4.castalia.camp:8182/factoids/"); 
my %factoids;
for my $factoid (@{$f}) {
    $factoids{ $factoid->{'id'} }->{'name'} = $factoid->{'name'};
    $factoids{ $factoid->{'id'} }->{'description'} = $factoid->{'summary'};
}
my $factoids_json = encode_json(\%factoids);
&write_file($factoids_json, "factoids.json");

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

#print Dumper(%metrics);
#print "\n\n";

my $metrics_json = encode_json(\%metrics);
&write_file($metrics_json, "metrics.json");

print "# Retrieving list of projects.";
my $p = &get_url("http://ci4.castalia.camp:8086/administration/projects/");
my @projects = map { $_->{'shortName'} } @$p;

print Dumper(@projects);

my %projects;
for my $project (@projects) {

    print "# Metrics for project $project\n";
    for my $metric (keys %metrics) {
        print "   - $metric [http://ci4.castalia.camp:8182/projects/p/$project/m/$metric].\n";
        my $m = &get_url("http://ci4.castalia.camp:8182/projects/p/$project/m/$metric");
	$projects{$project} = $m;
#        print "     " . Dumper($m) . "\n";
    }

    print "# Retrieving similar projects for $project.\n";
    my $s = &get_url("http://ci4.castalia.camp:8080/api/recommendation/similar/p/$project/m/Compound/n/3");
#    print Dumper($s);

}

my $projects_json = encode_json(\%projects);
&write_file($projects_json, "projects.json");






























