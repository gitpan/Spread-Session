use Test;
BEGIN { plan tests => 2 }

use Spread::Session;

my $group = "session_test";

if (fork) {
    # this is the sender

    sleep(1);

    my $session = new Spread::Session;
    $session->publish($group, "test message");
    exit;

} else {
    # this is the listener

    use Event qw(loop unloop);

    my $session = new Spread::Session;
    my $done = 0;
    $session->callbacks(
			message => sub {
			    my ($sender, $groups, $message) = @_;
			    ok($message eq "test message");
			    Event::unloop;
			}
		       );
    $session->subscribe($group);

    Event->io(fd => $session->{MAILBOX},
	      cb => sub { $session->receive(0) },
	     );
    Event::loop;
}

ok(1);
