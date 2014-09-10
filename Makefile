compile:
	coffee -o $(CURDIR)/lib/ -c $(CURDIR)/src/*.coffee

.DEFAULT:
	$make compile
