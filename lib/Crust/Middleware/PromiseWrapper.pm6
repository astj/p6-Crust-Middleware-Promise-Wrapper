use v6.c;
use Crust::Middleware;

unit class Crust::Middleware::PromiseWrapper:ver<0.0.1> is Crust::Middleware;

method CALL-ME(%env) {
    given $.app()(%env) {
        when Promise { $_; }
        default { start { $_ }; }
    }
}

=begin pod

=head1 NAME

Crust::Middleware::PromiseWrapper - An wrapper middleware for legay PSGI apps

=head1 SYNOPSIS

  use Crust::Middleware::PromiseWrapper;

=head1 DESCRIPTION

Crust::Middleware::PromiseWrapper is a simple wrapper middleware for legacy PSGI apps.


=head1 AUTHOR

Asato Wakisaka <asato.wakisaka@gmail.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2017 Asato Wakisaka

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod
