OUTPUT_FORMAT("elf64-x86-64")
ENTRY(start) /* アセンブリ側の最初のエントリポイント関数名（例: start）を指定 */

SECTIONS
{
    /* BIOSがブートセクタを読み込む絶対アドレス */
    . = 0x7C00;

    .text : {
        *(.boot)    /* ブートローダの16bitコードを先頭に配置 */
        *(.text)    /* C言語などの実行コード */
    }

    .rodata : {
        *(.rodata)  /* printfの文字列などの定数データ */
    }

    .data : {
        *(.data)    /* 初期値ありの変数 */
    }

    .bss : {
        *(.bss)     /* 初期値なしの変数 */
    }
}
