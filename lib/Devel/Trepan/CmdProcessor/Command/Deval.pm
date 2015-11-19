# -*- coding: utf-8 -*-
# Copyright (C) 2015 Rocky Bernstein <rocky@cpan.org>
use warnings; use utf8;
use rlib '../../../..';

package Devel::Trepan::CmdProcessor::Command::Deval;


use Devel::Trepan::CmdProcessor::Command;
use Devel::Trepan::CmdProcessor::Command::Deparse;

use constant ALIASES    => qw(deval@ deval% deval$);
use constant CATEGORY   => 'data';
use constant SHORT_HELP => 'Run deparsed code in the current context';
use constant NEED_STACK => 0;
use constant MIN_ARGS  => 0;  # Need at least this many
use constant MAX_ARGS  => 0;  # Need at most this many

use strict;
use Devel::Trepan::Util;

use vars qw(@ISA); @ISA = @CMD_ISA;
use vars @CMD_VARS;  # Value inherited from parent

our $NAME = set_name();
=head2 Synopsis:

=cut
our $HELP = <<'HELP';
=pod

B<deval>[B<@$>][B<?>]

Run deparsed I<Perl-code> in the context of the current frame.

Qe run the string from the current source code about to be run.

The value of the expression is stored into global array I<@DB:D> so it
may be used again easily.

Normally I<deval> assumes you are typing a statement, not an expression;
the result is a scalar value. However you can force the type of the result
by adding the appropriate sigil C<@>, C<%>, or C<$>.

=head2 Examples:

 deval
 deval$  # Possibly same as above, if the return type was scalar
 deval@  # Possibly the same as deval if the return type was an array

=cut
HELP

no warnings 'redefine';

sub run($$)
{
    my ($self, $args) = @_;
    my $proc = $self->{proc};
    my $cmd_name = $args->[0];
    my $hide_position = 1;

    if ($proc->{terminated}) {
	$proc->msg_need_running("implicit eval source code");
	return;
    }
    my $funcname = $proc->{frame}{fn};
    my $deparse = B::DeparseTree->new();
    my $addr = $proc->{op_addr};
    if ($funcname eq "DB::DB" or $proc->{stack_size} <= 0) {
	$deparse->main2info;
    } else {
	# Pick up string to eval from current source address.
	$deparse->coderef2info(\&$funcname);
    }
    my $op_info = Devel::Trepan::CmdProcessor::Command::Deparse::get_addr($deparse, $addr);
    unless ($op_info) {
	my $mess = sprintf("Can't get info for address 0x%x", $addr);
	$proc->errmsg($mess);
	return;
    }
    my $code_to_eval  = $op_info->{text};
    $proc->msg("eval: ${code_to_eval}");
    $hide_position = 0;
    my $return_type = parse_eval_suffix($cmd_name) || '$';
    # my $eval_lead_word;
    # $return_type = parse_eval_sigil($eval_lead_word) unless $return_type;
    my $opts = {return_type       => $return_type,
		hide_position     => $hide_position,
		fix_file_and_line => 1,
    };
    no warnings 'once';
    $proc->eval($code_to_eval, $opts);
}

# unless (caller) {
     require Devel::Trepan::CmdProcessor;
     # my $proc = Devel::Trepan::CmdProcessor->new(undef, 'bogus');
     # my $cmd = __PACKAGE__->new($proc);
#     my $frame_ary = Devel::Trepan::CmdProcessor::Mock::create_frame();
#     $proc->frame_setup($frame_ary);

#     $cmd->run([$NAME]);
# }

1;
