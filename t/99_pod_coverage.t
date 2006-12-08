#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests => 1;

eval "use Test::Pod::Coverage 1.08";
plan skip_all => "Test::Pod::Coverage 1.08 required" if $@;
pod_coverage_ok("WWW::ConfixxBackup");
