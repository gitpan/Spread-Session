#!/usr/bin/perl
#
# Using Spread::Session with Event and POE
#
# This program listens on a Spread topic and prints incoming messages.
#

use strict;
use warnings;

use Spread::Session;

use Event;
use POE;

my $group = shift @ARGV || 'test';

my $session = new Spread::Session;
$session->callbacks(
		     message => sub {
			 my ($sender, $groups, $message) = @_;

			 print "RECEIVED: ", $message, "\n";
		     }
		    );
$session->subscribe($group);

Event->io(fd => $session->{MAILBOX},
	  cb => sub { $session->receive(0) },
	 );

$poe_kernel->run();
