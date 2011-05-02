package Test::Business::OnlinePayment::SagePay;

use strict;
use warnings;

use Exporter 'import';

our @EXPORT_OK = qw(create_transaction create_simple_web_server);

sub create_transaction {
    my %args = @_;

    my $id = sprintf(
        'auth-unit-test-%d-%d',
        $$,
        time(),
    );

    return (
        type                => 'VISA',
        action              => 'Normal Authorization',
        description         => 'Test order',
        invoice_number      => $id,
        customer_id         => 'sagepay@test.com',
        email               => 'sagepay@test.com',
        amount              => 10.99,
        first_name          => 'Joe',
        last_name           => 'Bloggs',
        address             => '1 Test Street',
        city                => 'London',
        zip                 => 'W1 2AB',
        country             => 'gb',
        name_on_card        => 'Joe Bloggs',
        card_number         => '4921123412341230',
        expiration          => '01/19',
        cvv2                => 123,

        %args,
    );
}

sub create_simple_web_server {
    {
        package Test::Business::OnlinePayment::SagePay::WebServer;

        use base 'Net::Server::HTTP';

        use CGI;
        use Storable 'freeze';

        sub process_http_request {
            my $self = shift;

            print "Content-type: application/octet-stream\n\n";

            my $cgi = CGI->new;
            print freeze({ map {$_ => $cgi->param($_) } $cgi->param });
        }
    }

    Test::Business::OnlinePayment::SagePay::WebServer->run(port => $ENV{SAGEPAY_TEST_WEB_SERVER_PORT} || 15100)
}

1;
