#!/usr/bin/perl
use strict;

## Use this to push changes to dotfiles from zugzug home to various boxes that you may not have access to git on or 
## that you don't want to have to manually retrieve the files and run the symlink.sh on
##
##
## Set $from to your alpha - ex: $USER.alpha.bluehost.com
## Under __DATA__ add all the servers you'd like to push to - ex: i0.bluehost.com
##
##

my $filter = $ARGV[0];
my $from = 'bcowley.alpha.bluehost.com';
while (<DATA>) {
    chomp;
    next unless $_;
    next if $filter && $_ !~ /$filter/;

    my $cmd = qq{ssh $_ 'rm -rf ~/dotfiles'};
    print "$cmd\n";
    system($cmd);

    $cmd = qq{ssh $from 'tar -C ~ -czf - --exclude=.git dotfiles' | ssh $_ 'tar -C ~ -xzf -'};
    print "$cmd\n";
    system($cmd);

    $cmd = qq{ssh $from 'tar -C ~ -czf - .bash_extra' | ssh $_ 'tar -C ~ -xzf -'};
    print "$cmd\n";
    system($cmd);

    $cmd = qq{ssh $_ '~/dotfiles/symlink.sh'};
    print "$cmd\n";
    system($cmd);
}

__DATA__
i0.bluehost.com
app-loghost.bluehost.com
