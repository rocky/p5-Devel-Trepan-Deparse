# -*- coding: utf-8 -*-
# Copyright (C) 2015 Rocky Bernstein <rocky@cpan.org>
use warnings; no warnings 'redefine'; no warnings 'once';
use rlib '../../../../../..';

package Devel::Trepan::CmdProcessor::Command::Show::Auto::Deparse;
use Devel::Trepan::CmdProcessor::Command::Subcmd::Subsubcmd;

use strict;
use vars qw(@ISA @SUBCMD_VARS);
@ISA = qw(Devel::Trepan::CmdProcessor::Command::ShowBoolSubsubcmd);
# Values inherited from parent

use vars @Devel::Trepan::CmdProcessor::Command::Subsubcmd::SUBCMD_VARS;

our $IN_DEPARSE      = 1;
our $MIN_ABBREV   = length('de');
our $SHORT_HELP   = "Show whether to run a 'deparse' command when we enter the debugger";

=pod

=head2 Synopsis:

=cut
our $HELP         = <<"HELP";
=pod

B<show auto deparse>

Show whether deparseing on debugger stop is in effect.

=head2 See also:

L<C<set auto deparse>|Devel::Trepan::CmdProcessor::Command::Set::Auto Deparse>
=cut
HELP


unless (caller) {
  # Demo it.
  # require_relative '../../../mock'

  # dbgr, set_cmd = MockDebugger::setup('set')
  # $max_cmd       = __PACKAGE__->new(dbgr.core.processor, $set_cmd)
  # $cmd_ary       = Trepan::SubSubcommand::SetMaxDeparse::PREFIX
  # $cmd_name      = cmd_ary.join(' ')
  # $subcmd        = __PACKAGE__->new($set_cmd->{proc}, $max_cmd, $cmd_name);
  # $prefix_run = cmd_ary[1..-1]
  # $subcmd->run(\@prefix_run);
  # $subcmd-.run(\@prefix_run, qw(0));
  # $subcmd->run(prefix_run, qw(20));
  # $subcmd->summary_help(name);
  # print "\n";
  # print '-' x 20, "\n";
  # print $subcmd->save_command;
}

1;
