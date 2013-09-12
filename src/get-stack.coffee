

###

`cso` is dhort for 'CallSite object', see http://code.google.com/p/v8/wiki/JavaScriptStackTraceApi

###

# #-----------------------------------------------------------------------------------------------------------
@_new_trace = ( cso ) ->
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
  #.........................................................................................................
  prepare_stack_trace = ( error, stack ) ->
    if delta?
      @_new_trace cso[ delta ]
    else
      return ( @_new_trace cso for cso in stack )
  #.........................................................................................................
  original_prepareStackTrace  = Error.prepareStackTrace
  Error.prepareStackTrace     = prepare_stack_trace
  error                       = new Error()
  R                           = error.stack
  Error.prepareStackTrace     = original_prepareStackTrace
  return R
