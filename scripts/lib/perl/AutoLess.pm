package AutoLess;

BEGIN {
	open(STDOUT,"|less -S");
	open(STDERR,">&STDOUT");
};
END {
	close(STDERR);
	close(STDOUT);
};

1;
