all: disk.img

boot/boot.bin: boot/boot.asm
	nasm -f bin boot/boot.asm -o boot/boot.bin
	nasm -f bin boot/boot.asm -l boot/boot.lst -o boot/boot.bin

game/game.bin: game/game.asm
	nasm -f bin game/game.asm -o game/game.bin
	nasm -f bin game/game.asm -l game/game.lst -o game/game.bin

disk.img: boot/boot.bin game/game.bin
	dd if=/dev/zero of=disk.img bs=512 count=2880
	dd if=boot/boot.bin of=disk.img bs=512 count=1 conv=notrunc
	dd if=game/game.bin of=disk.img bs=512 seek=1 conv=notrunc

clean:
	rm -f boot/boot.bin boot/boot.lst game/game.bin game/game.lst disk.img