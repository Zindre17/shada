with Ada.Direct_IO;
with Ada.Text_IO;
with Data; use Data;
with Interfaces;

package body Padder is
  type i64 is new Interfaces.Unsigned_64;
  package Byte_IO is new Ada.Direct_IO(Byte);

  function Pad_Content(Content: Byte_Array_Access) return Block_Array_Access is
    SizeInBits : i64 := i64(Content'Length * 8);
    ContentSize1 : Word32 := Word32(Shift_Right(SizeInBits, 32));
    ContentSize2 : Word32 := Word32(SizeInBits rem i64(Word32'Last));
    Remainder: Integer := 64 - (Content'Last rem 64);
    FullBlocks: Integer := Content'Last / 64;
    Zeroes: Integer :=
      (if Remainder < 9
        then Remainder + 64 - 9
        else Remainder - 9);

    TotalBlocks: Integer :=
      (if Remainder < 9
        then FullBlocks + 1
        else FullBlocks);

    CurrentBlock: Block16 := Empty_Block;
    WordInBlock: Block_Range := 0;
    ByteInWord: Word_Builder_Range := Word_Builder_Range'Last;
    Blocks: Block_Array_Access := new Block_Array(0 .. TotalBlocks);
    BlockIndex: Natural := 0;

    procedure Increment_Block_Position is
    begin
      if ByteInWord = 0 then
        ByteInWord := Word_Builder_Range'Last;
        if WordInBlock = Block_Range'Last then
          WordInBlock := 0;
          Blocks(BlockIndex) := CurrentBlock;
          CurrentBlock := Empty_Block;
          BlockIndex := BlockIndex + 1;
        else
          WordInBlock := WordInBlock + 1;
        end if;
      else
        ByteInWord := ByteInWord - 1;
      end if;
    end;

  begin
    for I in Content'Range loop
      Update_Block(CurrentBlock, WordInBlock, ByteInWord, Content(I));
      Increment_Block_Position;
    end loop;

    Update_Block(CurrentBlock, WordInBlock, ByteInWord, Shift_Left(1, 7));
    Increment_Block_Position;

    for I in 1 .. Zeroes loop
      Update_Block(CurrentBlock, WordInBlock, ByteInWord, 0);
      Increment_Block_Position;
    end loop;

    CurrentBlock(14) := ContentSize1;
    CurrentBlock(15) := ContentSize2;
    Blocks(Blocks'Last) := CurrentBlock;
    return blocks;
  end;

  function Load_Content(Filename: String) return Byte_Array_Access is
    File : Byte_IO.File_Type;
  begin
    Byte_IO.Open (File, Byte_IO.In_File, Filename);
    declare
      Bytes : Byte_Array_Access := new Byte_Array(1 .. Integer(Byte_IO.Size(File)));
    begin
      for I in Bytes'Range loop
        Byte_IO.Read(File, Bytes(I));
      end loop;

      Byte_IO.Close(File);
      return Bytes;
    end;
  end;
end Padder;
