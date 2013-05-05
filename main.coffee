
#-----------------------------------------------------------------------------------------------------------
require 'longjohn'
#...........................................................................................................
log                       = console.log
fs                        = require 'fs'
stacktrace                = require 'stack-trace'
coffee                    = require "coffee-script"
TRM                       = require 'coffeenode-trm'
#...........................................................................................................
ruler                     = '——————————————————————————————————————————————————————————'

#-----------------------------------------------------------------------------------------------------------
@log_stacktrace = ( error ) ->
  cache   = {}
  traces  = ( stacktrace.parse error ).reverse()
  log TRM.grey error[ 'stack' ]
  log()
  #.........................................................................................................
  for trace in traces
    route = trace[ 'fileName' ]
    #.......................................................................................................
    if route is '---------------------------------------------'
      log TRM.red ruler
      continue
    #.......................................................................................................
    error_line_nr   = parseInt trace[ 'lineNumber' ], 10
    log ( TRM.cyan "▉ #{route}" ), ( TRM.grey "line" ), ( TRM.cyan "#{error_line_nr}" )
    continue unless ( route.match /\// )?
    #.......................................................................................................
    if ( entry = cache[ route ] )?
      source = entry[ 'source' ]
      lines  = entry[ 'lines'  ]
    else
      entry  = cache[ route ]     = {}
      source = entry[ 'source' ]  = fs.readFileSync route, 'utf-8'
      #.....................................................................................................
      # ###TAINT### is there a more general way to get any kind of file compiled?
      # ###TAINT### should use source maps
      if ( route.match /\.coffee/ )?
        source = entry[ 'source' ] = coffee.compile source, 'bare': false, 'filename': route
      #.....................................................................................................
      lines  = entry[ 'lines'  ]  = source.split /\n/
    #.......................................................................................................
    error_line_idx  = error_line_nr - 1
    first_idx       = Math.max error_line_idx - 2, 0
    last_idx        = Math.min error_line_idx + 2, lines.length - 1
    for line_idx in [ first_idx .. last_idx ]
      log ( if line_idx is error_line_idx then TRM.gold else TRM.grey ) lines[ line_idx ]
    # log()
  #.........................................................................................................
  if error[ 'message' ]?
    for line in error[ 'message' ].split '\n'
      log ( TRM.gold TRM.reverse TRM.bold '/// ERROR ///' ), TRM.red line

#-----------------------------------------------------------------------------------------------------------
# This is *so* 1990s VBA!
process.on 'uncaughtException', ( error ) =>
  @log_stacktrace error
