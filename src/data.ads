with Interfaces; use Interfaces;

package Data is
  subtype RangeOfT is Integer range 0 .. 79;

  type Nibble_Range is new Integer range 0 .. 15;

  type Byte is new Unsigned_8;
  type Byte_Array is array (Natural range <>) of Byte;
  type Byte_Array_Access is access Byte_Array;

  type Word32 is new Unsigned_32;
  subtype Word_Builder_Range is Natural range 0 .. 3;
  type Word_Builder is array (Word_Builder_Range) of Byte;

  subtype Digest_Range is Natural range 0 .. 4;
  type Digest is array (Digest_Range) of Word32;

  subtype Block_Range is Natural range 0 .. 15;
  type Block16 is array (Block_Range) of Word32;
  type Block_Array is array (Natural range <>) of Block16;
  type Block_Array_Access is access Block_Array;

  function Empty_Block return Block16;
  function Build_Word32(Builder : Word_Builder) return Word32;
  function New_Word_Builder(Value : Word32) return Word_Builder;
  function Hex(Value : Nibble_Range) return Character;

  procedure Update_Block(Block : in out Block16; WordInBlock: Block_Range; ByteInWord : Word_Builder_Range; Value : Byte);
  procedure Print_Digest(Value : Digest);
  procedure Print_Word32(Value : Word32);
  procedure Print_Blocks(Blocks : Block_Array);
  procedure Print_Block(Block : Block16);

  K0_19 : constant Word32 := 16#5A827999#;
  K20_39 : constant Word32 := 16#6ED9EBA1#;
  K40_59 : constant Word32 := 16#8F1BBCDC#;
  K60_79 : constant Word32 := 16#CA62C1D6#;
end Data;
