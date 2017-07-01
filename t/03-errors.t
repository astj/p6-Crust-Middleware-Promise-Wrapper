use v6.c;
use Test;
use Crust::Builder;
use HTTP::Message::P6W;
use Crust::Middleware::WrapPSGI;
use IO::Blob;

subtest {
    my $app = builder {
        enable "WrapPSGI";
        -> %env {
            %env<p6w.errors>.print("ohno");
            %env<p6sgi.errors>.print("legacy");
            (200, [ 'Content-Type' => 'text/plain' ], [ 'Hello World' ]);
        };
    };

    my $io = IO::Blob.new();
    $*ERR = $io;

    my $req = HTTP::Request.new(GET => "http://localhost/hello").to-p6w;
    my $res = $app($req);
    await $res;

    $io.seek(0);
    is $io.slurp-rest, "ohno\nlegacy\n";
}, 'psgi';

subtest {
    my $app = builder {
        enable "WrapPSGI";
        -> %env {
            start {
                %env<p6w.errors>.print("ohno");
                %env<p6sgi.errors>.print("legacy");
                (200, [ 'Content-Type' => 'text/plain' ], [ 'Hello World' ]);
            };
        };
    };

    my $io = IO::Blob.new();
    $*ERR = $io;

    my $req = HTTP::Request.new(GET => "http://localhost/hello").to-p6w;
    my $res = $app($req);
    await $res;

    $io.seek(0);
    is $io.slurp-rest, "ohno\nlegacy\n";
}, 'print inside Promise';

subtest {
    my $app = builder {
        enable "WrapPSGI";
        -> %env {
            %env<p6w.errors>.print("ohno");
            %env<p6sgi.errors>.print("legacy");
            start {
                (200, [ 'Content-Type' => 'text/plain' ], [ 'Hello World' ]);
            };
        };
    };

    my $io = IO::Blob.new();
    $*ERR = $io;

    my $req = HTTP::Request.new(GET => "http://localhost/hello").to-p6w;
    my $res = $app($req);
    await $res;

    $io.seek(0);
    is $io.slurp-rest, "ohno\nlegacy\n";
}, 'print outside Promise';

done-testing;
