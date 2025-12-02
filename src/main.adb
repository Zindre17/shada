With Ada.Text_IO; use Ada.Text_IO;
With Ada.Command_Line; use Ada.Command_Line;
with Padder; use Padder;
with Data; use Data;
with Sha; use Sha;

Procedure Main is
  begin
  if Argument_Count = 0 then
    Put_Line("Please provide a file to compute sha1 of.");
  else
    declare
      Filename : constant String := Argument(1);
      Bytes : Byte_Array_Access := Load_Content(Filename);
      Blocks : Block_Array_Access := Pad_Content(Bytes);
      MD : Digest := Compute_Sha_1(Blocks);
    begin
      Print_Digest(MD);
      New_Line;
    end;
  end if;
end;
