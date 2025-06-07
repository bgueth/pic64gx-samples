LD=/usr/local/bin/riscv64-unknown-elf-ld
CC=/usr/local/bin/riscv64-unknown-elf-gcc
HSS=/usr/local/bin/hss-payload-generator
CFLAGS=-g -I../include
LD_SCRIPT=linker.ld
DST=../build

disc:
	[ -f $(DST)/output.bin ] && (sudo dd if=$(DST)/output.bin of=/dev/mmcblk0p1 && sync) || echo "Nothing to write to disc"

gpio_out: $(DST)/gpio_out.elf
	$(HSS) -c gpio_out/single-hart.yaml $(DST)/output.bin

$(DST)/gpio_out.elf: $(DST)/gpio_out.o
	$(LD) -T gpio_out/linker.ld -o $@ $<

$(DST)/gpio_out.o: gpio_out/gpio_out.S
	$(CC) -c $(CFLAGS) -o $@ $<

machine_timer: $(DST)/machine_timer.elf
	$(HSS) -c machine_timer/single-hart.yaml $(DST)/output.bin

$(DST)/machine_timer.elf: $(DST)/machine_timer.o
	$(LD) -T machine_timer/linker.ld -o $@ $<

$(DST)/machine_timer.o: machine_timer/machine_timer.S
	$(CC) -c $(CFLAGS) -o $@ $<

clean:
	find "$(DST)" -type f -exec rm {} \;