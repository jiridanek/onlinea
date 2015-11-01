unit module blok;

my regex float { <[+-]>?  \d+  [ <[.,]> \d+ ]? }
my sub points($string) is export {
    return $string.match( / \* <( <float> )> /, :g )».trans(',' => '.');
}

my class Buffer is export {
    has $!buf = "";
    multi method print($string) {
        $!buf ~= $string;
    }
    multi method say($string) {
        $!buf ~= $string ~ "\n";
    }
    multi method Str() {
        return $!buf;
    }
}

my class Blok is export {
    has $.input;
    
    method justpoints($buf) {
        my $inrecord = False;
        my $pts = 0.0;
        for $!input.lines -> $line {
            my $isheader = $line ~~ /^\d/;
            if $isheader {
                if $inrecord {
                    say $buf: "|*$pts";
                }
                $inrecord = False;
                $pts = 0;
                say $buf: $line;
            } else {
                if $line ~~ /\| \[df_id\:\d*\]/ {
                    if ($inrecord) {
                        say $buf: "|*$pts";
                        $pts = 0.0;
                    }
                    $inrecord = True;
                    say $buf: $line;
                } else {
                    $pts += [+] points($line);
                }
            }
        }
        if $inrecord {
            say $buf: "|*$pts";
        }
    }
    
    method blanked($buf) {
        my $message = "|points were moved to a new notebook";
        my $inrecord = False;
        for $!input.lines -> $line {
            my $isheader = $line ~~ /^\d/;
            if $isheader {
                if $inrecord {
                    say $buf: "\n$message";
                }
                $inrecord = False;
                print $buf: $line;
            } else {
                if $line ~~ /\| <( \[df_id\:\d*\] )> / {
                    $inrecord = True;
                    print $buf: ~$/;
                }
            }
        }
        if $inrecord {
            say $buf: $message;
        }
    }
}