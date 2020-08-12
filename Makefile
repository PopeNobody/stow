
test2:

tests:
	make test1
	make test2

test1:
	report perl bin/pkg-file -wp stow

test2:
	report vi_perl bin/pkg-file -wp stow
