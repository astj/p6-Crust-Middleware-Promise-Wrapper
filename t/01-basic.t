use v6.c;
use Test;
use Crust::Builder;
use HTTP::Message::PSGI;
use Crust::Middleware::PromiseWrapper;

my $req = HTTP::Request.new(GET => "http://localhost/hello").to-psgi;

my $psgi-app = -> %env {
    (200, [ 'Content-Type' => 'text/plain' ], [ 'Hello World' ]);
};

subtest {
    my $res = $psgi-app($req);
    ok $res ~~ List;
    is $res[2], 'Hello World';
}, 'Raw legacy psgi app';

subtest {
    my $wrapped-psgi = builder {
        enable "PromiseWrapper";
        $psgi-app;
    };
    my $res = $wrapped-psgi($req);
    ok $res ~~ Promise;
    is $res.result[2], 'Hello World';
}, 'Wrapped legacy psgi app';

my $request-response-app = -> %env {
    start { 200, [ 'Content-Type' => 'text/plain' ], [ 'Hello World' ]; };
};

subtest {
    my $res = $request-response-app($req);
    ok $res ~~ Promise;
    is $res.result[2], 'Hello World';
}, 'Raw request-response app ';

subtest {
    my $wrapped-psgi = builder {
        enable "PromiseWrapper";
        $request-response-app;
    };
    my $res = $wrapped-psgi($req);
    ok $res ~~ Promise;
    is $res.result[2], 'Hello World';
}, 'Wrapped request-response app';

done-testing;
