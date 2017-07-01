use v6.c;
use Crust::Middleware;

unit class Crust::Middleware::WrapPSGI:ver<0.0.1> is Crust::Middleware;

my class IOlike::PrintSupplier {
    has Supplier $.supplier;

    # Many methods are missing...
    method print(**@text --> True) {
        $!supplier.emit(@text);
    }
}

method CALL-ME(%env) {
    # Tell server to this (wrapped) app uses request-response protocol
    %env<p6w.protocol.enabled> = %env<p6w.protocol.support> ∩ set('request-response');
    # Replace p6w.errors so that legacy apps can emit errors by %env<p6w.errors>.print
    temp %env<p6w.errors> = IOlike::PrintSupplier.new(:supplier(%env<p6w.errors>));
    %env<p6sgi.errors> = %env<p6w.errors>;

    # XXX should I check p6w.protocol is set to request-response?
    given $.app()(%env) {
        when Promise {
            start { await $_; };
        }
        default { start { $_ }; }
    }
}

=begin pod

=head1 NAME

Crust::Middleware::WrapPSGI - An wrapper middleware for legay PSGI apps

=head1 SYNOPSIS

  # An legacy PSGI app
  my $psgi-app = -> %env {
      (200, [ 'Content-Type' => 'text/plain' ], [ 'Hello World' ]);
  };
  my $wrapped-app = builder {
      # You can add other middlewares which expects Promise as response here.
      enable "WrapPSGI";
      $psgi-app;
  };

=head1 DESCRIPTION

Crust::Middleware::WrapPSGI is a simple wrapper middleware for legacy PSGI applications.
L<P6W> (formally known as PSGI) Version 0.7.Draft expects P6W apps to implement "request-response" protocol.
Under the protocol, P6W apps must return a Promise which is kept with a Capture with 3-elements response.

This middleware enables "legacy" PSGI applications which directly returns Capture (that means the application can respond to only psgi protocol) to work with "request-response" protocol.

=head1 AUTHOR

Asato Wakisaka <asato.wakisaka@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2017 Asato Wakisaka

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
