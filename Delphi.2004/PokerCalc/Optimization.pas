unit Optimization;

interface
uses PokerCards;

type xcards = record
         c: cards;
         s: string[13];
         comb: byte;
     end;

     function Combination(c: cards) : Byte;
     function CombinationX(c: xcards) : Byte;
     function LookOverCombinations(player: cards; var cardN: Byte) : Byte;

implementation


function Combination(c: cards) : Byte;
var i: Byte;
    costs: array[c2..cAce] of Byte;
    res: set of Byte;
    flash, street: Boolean;
    s: string;
begin
   s := '0000000000000'; res := [];
   FillChar(costs, cardsInMast, 0);
   //for i:=c2 to cAce do costs[i] := 0;
   for i:=1 to 5 do Inc(costs[GetCost(c[i])]);
   for i:=c2 to cAce do
       if costs[i]>0 then begin
          s[i+1] := '1';
          if (costs[i]=2) and (2 in res) then
             res := res + [22]
          else
             res := res + [costs[i]];
       end;

   Combination := wNoGame;
   if (costs[cKing]>0) and (costs[cAce]>0) then Combination := wAK; 
   if 4 in res then  { IsCare }
      Combination := wCare
   else
      if 3 in res then begin { IsTriple or IsFullHouse }
         if 2 in res then
            Combination := wFullHouse
         else
            Combination := wTriple;
      end else begin
         if 2 in res then begin
            if 22 in res then
               Combination := w2Pair
            else
               Combination := wPair;
         end else begin
            ;{Street, Flash etc.}
            flash := True;
            for i:=2 to 5 do if GetMast(c[i]) <> GetMast(c[i-1]) then flash := False;
            street := (Pos('11111', s)>0) or (s = '1111000000001');
            if street and flash then begin
               if s='0000000011111' then
                  Combination := wRoyalFlash
               else
                  Combination := wStreetFlash;
            end else begin;
               if street then Combination := wStreet;
               if flash  then Combination := wFlash;
            end;
         end;
      end;
end;

{ Выбор лучшей комбинации для 6-и карточной игры      Look Over Combinations }
function LookOverCombinations(player: cards; var cardN: Byte) : Byte;
var i,c,Cmax,Imax: Byte;
    p: cards;
begin
   Cmax := 0; Imax := 0; p := player;
   for i:=1 to 6 do begin
       p[i] := p[6]; // подставить шестую (прикупленную) карту
       c := Combination(p);
       if c > Cmax then begin Cmax := c; Imax := i; end;
       p[i] := player[i] // восстановить значение этой карты
                         // (немного некрасиво, но... :)
   end;
   cardN := Imax; // индекс "ненужной" карты
   LookOverCombinations := Cmax;
end;


function CombinationX(c: xcards) : Byte;
var i: Byte;
    flash, street: Boolean;
begin
   CombinationX := wNoGame;
   if (c.s[cKing]>'0') and (c.s[cAce]>'0') then CombinationX := wAK;
   if Pos('4', c.s) > 0 then  { IsCare }
      CombinationX := wCare
   else
      if Pos('3', c.s) > 0 then begin { IsTriple or IsFullHouse }
         if Pos('2', c.s) > 0 then
            CombinationX := wFullHouse
         else
            CombinationX := wTriple;
      end else begin
         i := Pos('2', c.s);
         if i > 0 then begin
            if Pos('2', Copy(c.s, i+1, 13)) > 0 then
               CombinationX := w2Pair
            else
               CombinationX := wPair;
         end else begin
            ;{Street, Flash etc.}
            flash := True;
            for i:=2 to 5 do if GetMast(c.c[i]) <> GetMast(c.c[i-1]) then flash := False;
            street := (Pos('11111', c.s)>0) or (c.s = '1111000000001');
            if street and flash then begin
               if c.s='0000000011111' then
                  CombinationX := wRoyalFlash
               else
                  CombinationX := wStreetFlash;
            end else begin;
               if street then CombinationX := wStreet;
               if flash  then CombinationX := wFlash;
            end;
         end;
      end;
end;


end.
