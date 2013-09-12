


### Note

This module used to work but stopped doing so due to V8 changes (i guess). The new version will be more
reliable and also faster as it will be using the V8 stack trace API—have a look at `src/get-stack.coffee`
for a sneak preview.




# Why?

JavaScript stacktraces are often hard to read:

* They may spit out a lot of data that is densely formatted, so wee need a nicer layout and colorizing
	to make the data more readable.

* They do contain file names and line numbers, but it's a chore to walk through all the spots one by one
	with the text editor. Also, line numbers refer to the JS source of transpiled code (such as resulting from
	CoffeeScript files.) So we need to offer peeks into the (transpiled) source (or better still, use Source
	Maps) to show the relevant contexts.

* When asynchronous function calls have occurred, JS itselfs only shows the stacktrace concerning the most
	recent turn of the event loop. What we need are 'long stacktraces'.




