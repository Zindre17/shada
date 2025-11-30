with data; use data;

package body Sha is

  function F(T : RangeOfT; B : Word32; C : Word32; D : Word32) return Word32 is
    Result : Word32;
  begin
    case T is
      when 0 .. 19 =>
        Result := (B and C) or ((not B) and D);
      when 20 .. 39 | 60 .. 79 =>
        Result := B xor C xor D;
      when 40 .. 59 =>
        Result := (B and C) or (B and D) or (C and D);
    end case;

    return Result;
  end;

  function K(T : RangeOfT) return Word32 is
    Result : Word32;
  begin
    case T is
      when 0 .. 19 =>
        Result := K0_19;
      when 20 .. 39 =>
        Result := K20_39;
      when 40 .. 59 =>
        Result := K40_59;
      when 60 .. 79 =>
        Result := K60_79;
    end case;
    return Result;
  end;

  function S(N : RangeOfN; X : Word32) return Word32 is
    A: Word32 := Shift_Left(X, N);
    B: Word32 := Shift_Right(X, 32 - N);
  begin
    return A or B;
  end;

  function Compute_Sha_1(M : Block_Array) return Digest is
    A, B, C, D, E : Word32;

    H0 : Word32 := 16#67452301#;
    H1 : Word32 := 16#EFCDAB89#;
    H2 : Word32 := 16#98BADCFE#;
    H3 : Word32 := 16#10325476#;
    H4 : Word32 := 16#C3D2E1F0#;

    W : array (RangeOfT) of Word32;

    Temp: Word32;
  begin
    for BlockIndex in M'Range loop
      for WordIndex in M(BlockIndex)'Range loop
        W(WordIndex) := M(BlockIndex)(WordIndex);
      end loop;

      for T in 16 .. 79 loop
        W(T) := S(1,(W(T-3) xor W(T-8) xor W(T-14) xor W(T-16)));
      end loop;

      A := H0;
      B := H1;
      C := H2;
      D := H3;
      E := H4;

      for T in 0 .. 79 loop
        Temp := S(5,A) + F(T, B, C, D) + E + W(T) + K(T);
        E := D;
        D := C;
        C := S(30,B);
        B := A;
        A := Temp;
      end loop;

      H0 := H0 + A;
      H1 := H1 + B;
      H2 := H2 + C;
      H3 := H3 + D;
      H4 := H4 + E;
    end loop;

    return (H0, H1, H2, H3, H4);
  end;
end;
