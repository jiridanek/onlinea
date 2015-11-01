#perl6 compress_blok.pl < in.txt > out-txt

use v6;
use lib 'lib';
use blok;

my $buf = Buffer.new();
my $tmp = Blok.new(input => slurp());
$tmp.blanked($buf);
print $buf.Str;
