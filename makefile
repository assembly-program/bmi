bmi: bmi.s
	as bmi.s -o bmi.o
	ld bmi.o -o bmi
	rm *.o
