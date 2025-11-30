with Ada.Streams.Stream_IO; use Ada.Streams.Stream_IO;
with Data; use Data;

package Padder is
  function Pad_Content(Content: Byte_Array) return Block_Array;
  function Load_Content(Filename: String) return Byte_Array;
  function Load_Bytes(File: File_Type) return Byte_Array;
end Padder;
