make:
	as sand.s -g -o sand.o
	ld sand.o -g -o sand

test: 
	make
	./sand
	echo $?

clean:
	rm sand.o sand

