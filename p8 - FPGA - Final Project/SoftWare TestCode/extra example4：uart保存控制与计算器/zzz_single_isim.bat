@echo off
    java -jar Mars.jar a nc db mc CompactDataAtZero dump 0x00003000-0x00003ffc HexText code.txt target.asm

    java -jar Mars.jar a nc db mc CompactDataAtZero dump 0x00004180-0x00004ffc HexText code_handler.txt target.asm

pause