use v6;
use Test;

use lib 'lib';
use blok;

subtest {
    my $input =
"Day 1:
Task 1: *5 Task 2: *2,8
Task 3 was the hardest, your score is *-1";
    is(points($input), [5, 2.8, -1]);
    done-testing;
}, "points";

my $input =
"408287:Pomajbíková, Klára   :BIOCH  :ONLINE_A:          :k:408287/ONLINE_A/420831:
|[df_id:59616772]
|*5
|Klara, ...
|[df_id:59616765]
|*5
|";
my $klara = Blok.new(:$input);

subtest {
    my $buf = Buffer.new();
    $klara.blanked($buf);
    is($buf.Str,
"408287:Pomajbíková, Klára   :BIOCH  :ONLINE_A:          :k:408287/ONLINE_A/420831:[df_id:59616772][df_id:59616765]|points were moved to a new notebook\n");
}, "blank";

subtest {
     my $buf = Buffer.new();
    $klara.justpoints($buf);
    is($buf.Str,
"408287:Pomajbíková, Klára   :BIOCH  :ONLINE_A:          :k:408287/ONLINE_A/420831:
|[df_id:59616772]
|*5
|[df_id:59616765]
|*5
");
}

done-testing;