#perl6 compress_blok.pl < in.txt > out-txt

my $message = "|points were moved to a new notebook";

my $inrecord = False;
my $isheader = True;
my $bloky = [];
for slurp.lines -> $line {
  $isheader = $line ~~ /^\d/;
  if $isheader {
    if $inrecord {
      say "\n$message";
    }
    $inrecord = False;
    print $line;
  } else {
    if $line ~~ /| <( \[df_id\:\d*\] )> / {
      $inrecord = True;
      print ~$/;
    }
  }
}
unless $isheader { #inrecord fixme
  say $message;
}