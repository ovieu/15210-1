structure BareArraySequence : BARESEQUENCE =
struct
  type 'a seq = { ary : 'a array, idx : int, len : int }
  datatype 'a listview = NIL | CONS of 'a * 'a seq

  exception Range
  exception Size
  
  fun empty _ = {ary=Array.fromList [], idx=0, len=0}

  fun singleton x = {ary=Array.fromList [x], idx=0, len=1}

  fun nth {ary, idx, len} i =
      if i < 0 orelse i >= len then raise Range
      else Array.sub (ary, idx+i)

  fun length {len, ary, idx} = len

  fun tabulate f n =
      if n < 0 then raise Size else
      if n = 0 then empty () else let
        val a = Array.array (n, f (n-1))
        fun parTab (n, f) = let val v = Vector.tabulate (n, f)
                      in fn i => Vector.sub (v, i) end
        val _ = parTab (n-1, fn i => Array.update (a, i, f i))
      in {ary=a, idx=0, len=n} end

  fun fromList l =
      let val ary = Array.fromList l
      in {ary=ary, idx=0, len=Array.length ary}
      end

  fun subseq {ary, idx, len} (i, len') =
      if len' < 0 then raise Size
      else if i < 0 orelse i+len' > len then raise Range
      else {ary=ary, idx=idx+i, len=len'}

  fun take (s, n) = subseq s (0, n)

  fun drop (s, n) = subseq s (n, length s - n)

  fun showl {len=0, ...} = NIL
    | showl s = CONS (nth s 0, drop (s, 1))
end
