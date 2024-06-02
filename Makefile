all: inst.s
	loongarch32r-linux-gnusf-as -mabi=ilp32 inst.S -o inst.o
	loongarch32r-linux-gnusf-ld inst.o -T bin.lds -o main.elf
	loongarch32r-linux-gnusf-objcopy -O binary -j .text main.elf main.bin
	loongarch32r-linux-gnusf-objcopy -O binary -j .data main.elf main.data
	gcc ./convert.c -o convert
	./convert
