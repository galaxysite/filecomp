all :
	fpc -CX -XX -O4 -Cg acmp.pas
	-sstrip acmp
	echo "Use Lazarus for make gcmp"

clean :
	    -rm *.o *.a *.ppu acmp gcmpc_test gcmp
	    -rm -r lib backup
