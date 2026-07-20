# 1. ツールとフラグの設定
NASM   = nasm
CC     = gcc
LD     = ld
OBJCOPY = objcopy

# -m64で64bit化、-mno-red-zoneでスタック破壊防止
CFLAGS  = -m64 -ffreestanding -O2 -Wall -Wextra -mno-red-zone
LDFLAGS = -m elf_x86_64 -T linker.ld

# 2. ターゲット名
TARGET  = oscn.img

# 3. 必要なファイルを自動でリストアップ
ASM_SRCS = $(wildcard *.asm)
ASM_OBJS = $(ASM_SRCS:.asm=.o)

C_SRCS   = $(wildcard *.c)
C_OBJS   = $(C_SRCS:.c=.o)

OBJS     = $(ASM_OBJS) $(C_OBJS)

# 4. 全体のビルドルール（先頭は「Tab」）
all: $(TARGET)

# オブジェクトファイルをリンクしてELFを作り、それを純粋なバイナリ（RAW）に変換する
$(TARGET): $(OBJS)
	$(LD) $(LDFLAGS) -o oscn.elf $(OBJS)
	$(OBJCOPY) -O binary oscn.elf $(TARGET)

# .asm を ELF64 形式のオブジェクトファイルにするルール
%.o: %.asm
	$(NASM) -f elf64 $< -o $@

# .c を 64bitオブジェクトファイルにするルール
%.o: %.c
	$(%.o: %.c)
	$(CC) $(CFLAGS) -c $< -o $@

# 5. BIOS起動でQEMUを実行するルール
run: all
	qemu-system-x86_64 -drive format=raw,file=$(TARGET)

# 6. 掃除
clean:
	rm -f *.o oscn.elf $(TARGET)
