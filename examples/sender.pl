#!/usr/bin/perl
#
# Simple example of a Spread publisher.  Sends one message and terminates.
#

use strict;
use Spread;
use Spread::Session;

use Log::Channel;
enable Log::Channel "Spread::Session";
enable Log::Channel "Spread::Session::message";

my $queue_name = shift @ARGV || die;
my $message = shift @ARGV || die;

my $session = new Spread::Session;
$session->callbacks(
		     message => \&callback,
		    );
$session->publish($queue_name, $message);


sub callback {
    my ($sender, $groups, $message) = @_;

    print "SENDER: $sender\n";
    print "GROUPS: [", join(",", @$groups), "]\n";
    print "MESSAGE:\n", $message, "\n";
}
