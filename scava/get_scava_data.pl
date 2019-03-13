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

my $base_url = 'http://ci4.castalia.camp';
#my $base_url = 'http://scava-dev.ow2.org';

# Prepare for http requests
my $ua  = Mojo::UserAgent->new;

sub get_url() {
    my $url_in = shift;

    print "* Fetching ${url_in}.\n";
    my $res = $ua->get($url_in)->result;

    if (not $res->is_success) {
        print "Error: Could not get resource $url_in.\n";
        print $res->message . "\n";
        exit;
    }

    # Decode JSON from server
    my $file_in = $url_in;
    $file_in =~ s!/!_!g;
#    &write_file($res->body, $file_in . '.json');
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

my $f = &get_url($base_url . ":8182/factoids/"); 
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

my $m = &get_url($base_url . ":8182/metrics/");
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
my $p = &get_url($base_url . ":8086/administration/projects/");
my @projects = map { $_->{'shortName'} } @$p;

print Dumper(@projects);

my %projects;
my $projects_csv = "project,id,name,type,x,y,value_x,value_y\n";

for my $project (@projects) {

    my $project_csv = "project,id,name,type,x,y,value_x,value_y\n";
    my $project_csv_1 = "project,id,name,type,x,y,value_x,value_y\n";

    print "# Metrics for project $project\n";
    for my $metric (keys %metrics) {
        print "   - $metric [" . $base_url . ":8182/projects/p/$project/m/$metric].\n";
        my $m = &get_url($base_url . ":8182/projects/p/$project/m/$metric");
	# populate out json
	$projects{$project} = $m;
	# populate out csv
#	print "DBG " . Dumper($m) . "\n";
	if ( scalar( @{$m->{'datatable'}} ) > 0 ) {
	    for my $d ( @{$m->{'datatable'}} ) {
		if (ref($m->{'y'}) !~ m!ARRAY!) {
		    my $i = 1;
		    print "DBG " . $m->{'x'} . " " . $m->{'y'} . " "
			. $d->{ $m->{'x'} } . ' ' . $d->{ $m->{'y'} } . "\n";
		    $project_csv .= "$project,\"";
		    $project_csv .= $m->{'id'} . '","';
		    $project_csv .= $m->{'name'} . '","';
		    $project_csv .= $m->{'type'} . '","';
		    $project_csv .= $m->{'x'} . '","';
		    $project_csv .= $m->{'y'} . '","';
		    $project_csv .= $d->{ $m->{'x'} } . '","';
		    $project_csv .= $d->{ $m->{'y'} } . "\"\n";
		    if ($i == 1 ) {
			$project_csv_1 .= "$project,\"";
			$project_csv_1 .= $m->{'id'} . '","';
			$project_csv_1 .= $m->{'name'} . '","';
			$project_csv_1 .= $m->{'type'} . '","';
			$project_csv_1 .= $m->{'x'} . '","';
			$project_csv_1 .= $m->{'y'} . '","';
			$project_csv_1 .= $d->{ $m->{'x'} } . '","';
			$project_csv_1 .= $d->{ $m->{'y'} } . "\"\n";
			$i++;
		    }
		    $projects_csv .= "$project,\"";
		    $projects_csv .= $m->{'id'} . '","';
		    $projects_csv .= $m->{'name'} . '","';
		    $projects_csv .= $m->{'type'} . '","';
		    $projects_csv .= $m->{'x'} . '","';
		    $projects_csv .= $m->{'y'} . '","';
		    $projects_csv .= $d->{ $m->{'x'} } . '","';
		    $projects_csv .= $d->{ $m->{'y'} } . "\"\n";
		}
	    }
	} else {
	    # $project_csv .= "$project,";
	    # $project_csv .= $m->{'id'} . ",";
	    # $project_csv .= $m->{'name'} . ",";
	    # $project_csv .= $m->{'type'} . ",";
	    # $project_csv .= $m->{'x'} . ",";
	    # $project_csv .= $m->{'y'} . ",,\n";

 	    # $projects_csv .= "$project,";
	    # $projects_csv .= $m->{'id'} . ",";
	    # $projects_csv .= $m->{'name'} . ",";
	    # $projects_csv .= $m->{'type'} . ",";
	    # $projects_csv .= $m->{'x'} . ",";
	    # $projects_csv .= $m->{'y'} . ",,\n";
	}
#        print "     " . Dumper($m) . "\n";
    }

#    print "# Retrieving similar projects for $project.\n";
#    my $s = &get_url($base_url . "/api/recommendation/similar/p/$project/m/Compound/n/3");
#    print Dumper($s);

    &write_file($project_csv, "project_$project.csv");
    &write_file($project_csv, "project_$project.csv");
    &write_file($project_csv_1, "project_${project}_single.csv");
    
    #    @projects_csv = ( @projects_csv, @project_csv );
}

my $projects_json = encode_json(\%projects);
&write_file($projects_json, "projects.json");

&write_file($projects_csv, "projects.csv");





























