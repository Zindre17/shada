with Data; use Data;

package Padder is
  function Pad_Content(Content: Byte_Array_Access) return Block_Array_Access;
  function Load_Content(Filename: String) return Byte_Array_Access;
end Padder;
