use Test;
BEGIN { plan tests => 2 }

use Spread::Session;

if (defined eval { require Log::Channel }) {
    disable Log::Channel "Spread::Session";
}

my $group = "session_test";

if (fork) {
    # this is the sender

    sleep(1);

    my $session = new Spread::Session;
    $session->callbacks(
			message => sub {
			    my ($sender, $groups, $message) = @_;
			    print "MESSAGE:\n", $message, "\n";
			    ok($message eq "response!");
			}
		       );
    $session->publish($group, "test message");
    $session->receive(2);

} else {
    # this is the listener

    my $session = new Spread::Session;
    my $done = 0;
    $session->callbacks(
			message => sub {
			    my ($sender, $groups, $message) = @_;
			    $session->publish($sender, "response!");
			    $done++;
			}
		       );
    $session->subscribe($group);
    while (!$done) {
	$session->receive(2);
    }
    exit;
}

ok(1);
