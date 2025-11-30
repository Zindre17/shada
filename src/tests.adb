with Ada.Text_IO; use Ada.Text_IO;
with Sha_1;
with Data;
with Padder;

package body Tests is
  procedure S is
    CircularShifted : Data.Word32 := 16#01000010#;
  begin
    Put_Line("Testing Cicular left shift:");
    Put_Line("Original Value:");
    Data.Print_Word32(CircularShifted);
    New_Line;

    CircularShifted := Sha_1.S(1, CircularShifted);
    Put_Line("Shifted left once:");
    Data.Print_Word32(CircularShifted);
    New_Line;

    CircularShifted := Sha_1.S(7, CircularShifted);
    Put_Line("Shifted left 8 times:");
    Data.Print_Word32(CircularShifted);
    New_Line;
    Put_Line("---------------------------");
  end;

end;
