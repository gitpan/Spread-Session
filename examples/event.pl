#!/usr/bin/perl
#
# Using Spread::Session with Event
#

use strict;
use Spread::Session;
use Event qw(loop unloop);

use Log::Channel;
enable Log::Channel "Spread::Session";

my $group = shift @ARGV || "example";

my $session = new Spread::Session;
$session->callbacks(
		     message => sub {
			 my ($sender, $groups, $message) = @_;

			 print "THE SENDER IS $sender\n";
			 print "GROUPS: [", join(",", @$groups), "]\n";
			 print "MESSAGE:\n", $message, "\n\n";

			 $session->publish($sender, "the response!");
		     },
		    );
$session->subscribe($group);

Event->io(fd => $session->{MAILBOX},
	  cb => sub { $session->receive(0) },
	 );
Event->timer(interval => 5,
	     cb => sub { print STDERR "(5 second timer)\n" },
	    );
Event::loop;

