#perl6 compress_blok.pl < in.txt > out-txt

my $message = "\n|*points moved to a new notebook";

my $inrecord = False;
my $isheader = True;
my $bloky = [];
for slurp.lines -> $line {
  $isheader = $line ~~ /^\d/;
  if $isheader {
    if $inrecord {
      say "$message";
    }
    $inrecord = False;
    say $line;
  } else {
    if $line ~~ /| <( \[df_id\:\d*\] )> / {
      unless $inrecord {
        print '|';
      }
      $inrecord = True;
      print ~$/;
    }
  }
}
unless $isheader { #inrecord fixme
  say $message;
}