[![Build Status](https://travis-ci.org/astj/p6-Crust-Middleware-Promise-Wrapper.svg?branch=master)](https://travis-ci.org/astj/p6-Crust-Middleware-Promise-Wrapper)

NAME
====

Crust::Middleware::PromiseWrapper - An wrapper middleware for legay PSGI apps

SYNOPSIS
========

    # An legacy PSGI app
    my $psgi-app = -> %env {
        (200, [ 'Content-Type' => 'text/plain' ], [ 'Hello World' ]);
    };
    my $wrapped-app = builder {
        # You can add other middlewares which expects Promise as response here.
        enable "PromiseWrapper";
        $psgi-app;
    };

DESCRIPTION
===========

Crust::Middleware::PromiseWrapper is a simple wrapper middleware for legacy PSGI applications. [P6W](P6W) (formally known as PSGI) Version 0.7.Draft expects P6W apps to implement "request-response" protocol. Under the protocol, P6W apps must return a Promise which is kept with a Capture with 3-elements response.

This middleware enables "legacy" PSGI applications which directly returns Capture (that means the application can respond to only psgi protocol) to work with "request-response" protocol.

AUTHOR
======

Asato Wakisaka <asato.wakisaka@gmail.com>

COPYRIGHT AND LICENSE
=====================

Copyright 2017 Asato Wakisaka

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.
