package ByteBeat;
our $VERSION = '0.0.1';

use Mo;
use Getopt::Long;
use ByteBeat::Compiler;

has args => ();

sub run {
    my ($self) = shift;
    my ($code, $length) = $self->get_options;

    my $function = ByteBeat::Compiler->new(code => $code)->compile;

    for (my $t = 0; $t < $length; $t++) {
        print chr ($function->run($t) % 256);
    }
}

sub get_options {
    my ($self) = shift;
    local @ARGV = @{$self->args};
    my $code;
    my $second = 2**13;
    my $length = $second * 60;
    GetOptions(
        'e=s' => \$code,
        'l=s' => \$length,
    );
    $length =
        $length =~ /^(\d+)s$/ ? $1 * $second :
        $length =~ /^(\d+)m$/ ? $1 * $second * 60 :
        $length =~ /^(\d+)$/ ? $1 :
            die "Invalid value for '-l'\n";
    my $file = shift(@ARGV) || '';
    if ($file) {
        open IN, $file
            or die "Can't open '$file' for input";
        local $/;
        $code = <IN>;
    }
    die "Please provide a file name or '-e' string for 'bytebeat'\n"
        unless $code;
    return ($code, $length);
}

1;
