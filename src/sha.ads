with Data; use Data;

package Sha is
  subtype RangeOfN is Natural range 0 .. 31;

  function F(T : RangeOfT; B : Word32; C : Word32; D : Word32) return Word32;
  function K(T : RangeOfT) return Word32;
  function S(N : RangeOfN; X : Word32) return Word32;
  function Compute_Sha_1(M : Block_Array) return Digest;
end;
