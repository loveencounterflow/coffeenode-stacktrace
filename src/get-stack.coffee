

############################################################################################################
TYPES                     = require 'coffeenode-types'


###

`cso` is dhort for 'CallSite object', see http://code.google.com/p/v8/wiki/JavaScriptStackTraceApi

###

# #-----------------------------------------------------------------------------------------------------------
_new_trace = ( cso ) ->
  R = [
    cso.getFileName()
    cso.getLineNumber()
    cso.getColumnNumber()
    cso.getFunctionName()
    cso.getMethodName() ]
  #.........................................................................................................
  return R

#-----------------------------------------------------------------------------------------------------------
module.exports = @get_stack = ( error, delta ) ->
  has_error                   = error?
  has_delta                   = delta?
  #.........................................................................................................
  if has_error
    if ( not has_delta ) and TYPES.isa_number error
      has_error = no
      delta     = error
      has_delta = yes
      error     = new Error()
  else
    error       = new Error()
  #.........................................................................................................
  prepare_stack_trace = ( error, stack ) ->
    #.......................................................................................................
    if has_delta
      delta  += 1 unless has_error
      R       = _new_trace stack[ delta ]
    #.......................................................................................................
    else
      R = ( _new_trace cso for cso in stack )
      R.shift() unless has_error
    #.......................................................................................................
    return R
  #.........................................................................................................
  original_prepareStackTrace  = Error.prepareStackTrace
  Error.prepareStackTrace     = prepare_stack_trace
  R                           = error.stack
  ### get rid of top entry in case no error was passed in: ###
  Error.prepareStackTrace     = original_prepareStackTrace
  return R
