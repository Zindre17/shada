with Ada.Text_IO; use Ada.Text_IO;

package body Data is
  function Empty_Block return Block16 is
  begin
    return Result : constant Block16 := (others => 0);
  end;

  function New_Word_Builder(Value: Word32) return Word_Builder is
    Result : Word_Builder := (others => 0);
    Part : Byte;
  begin
    for I in Result'Range loop
      Part := Byte(Shift_Right(Value, 8 * I) rem 256);
      Result(I) := Part;
    end loop;

    return Result;
  end;

  function Build_Word32(Builder : Word_Builder) return Word32 is
    Result : Word32 := 0;
    PartialWord: Word32;
  begin
    for I in Builder'Range loop
      PartialWord := Shift_Left(Word32(Builder(I)), 8 * I);
      Result := Result or PartialWord;
    end loop;

    return Result;
  end;

  procedure Update_Block(Block: in out Block16; WordInBlock: Block_Range; ByteInWord: Word_Builder_Range; Value: Byte) is
    WordToUpdate : Word_Builder := New_Word_Builder(Block(WordInBlock));
  begin
    WordToUpdate(ByteInWord) := Value;
    Block(WordInBlock) := Build_Word32(WordToUpdate);
  end;

  procedure Print_Digest(Value : Digest) is
  begin
    for I in Digest_Range loop
      Print_Word32(Value(I));
    end loop;
  end;

  procedure Print_Blocks(Blocks : in Block_Array) is
  begin
    for I in Blocks'Range loop
      Put_Line("Block " & I'Image);
      Put_Line("--------");
      Print_Block(Blocks(I));
      Put_Line("--------");
    end loop;
  end;

  procedure Print_Block(Block: Block16) is
  begin
    for I in Block_Range loop
      Print_Word32(Block(I));
      New_Line;
    end loop;
  end;

  procedure Print_Word32(Value : Word32) is
    Nibble: Nibble_Range;
  begin
    for I in 0 .. (32 / 4) - 1 loop
      Nibble := Nibble_Range(Shift_Right(Value, 28 - (I * 4)) rem 16);
      Put(Hex(Nibble));
    end loop;
  end;

  function Hex(Value : Nibble_Range) return Character is
    Symbols: constant String := "0123456789abcdef";
  begin
    return Symbols(Integer(Value) + 1);
  end;

end;
