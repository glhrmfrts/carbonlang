a.out: src/*.g
	pardalc -p ../ -I runtime/linux -V -o a.out

run: a.out
	./a.out

clean:
	rm a.out

.PHONY: clean run