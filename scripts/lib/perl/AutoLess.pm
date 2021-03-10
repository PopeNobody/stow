package AutoLess;

BEGIN {
	open(STDOUT,"|less -S");
	open(STDERR,">&STDOUT");
	close(STDERR);
	close(STDOUT);
};

1;
