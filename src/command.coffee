#  Copyright (C) 2012-2014 Yusuke Suzuki <utatane.tea@gmail.com>
#
#  Redistribution and use in source and binary forms, with or without
#  modification, are permitted provided that the following conditions are met:
#
#    * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#    * Redistributions in binary form must reproduce the above copyright
#      notice, this list of conditions and the following disclaimer in the
#      documentation and/or other materials provided with the distribution.
#
#  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
#  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
#  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
#  ARE DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
#  DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
#  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

fs = require 'fs'
optimist = require 'optimist'


COMMANDS = [
    'cover'
    'report'
]


TAB = '        '
argv = optimist.usage("""
    Usage: $0 subcommand
    === subcommands ===
#{TAB}#{COMMANDS.join "\n#{TAB}"}
    """).argv


command = argv._[0]
unless command?
    do optimist.showHelp
    process.exit 0


if command not in COMMANDS
    possibilities = (c for c in COMMANDS when command is c[...command.length])
    switch possibilities.length
        when 0
            console.error "Unrecognised command: `#{command}`. Run `#{argv['$0']}` for help."
            process.exit 1
        when 1
            command = possibilities[0]
        else
            console.error "Ambiguous command `#{command}` matches `#{possibilities.join '`, `'}`"
            process.exit 1


(require "./#{command}") argv, (err,cov,exitCode = 0) ->
    if err
        console.error err
        process.exit 1
    process.exit exitCode
# vim: set sw=4 ts=4 et tw=80 :
