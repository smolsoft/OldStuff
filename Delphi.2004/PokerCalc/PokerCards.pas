unit PokerCards;

interface

const
     {demo constants}
     demo = False;
     dfrom = 11; dto = 28;

     cardsInMast = 13;         mCrosses     = 0;
     InPack = 52;              mDiamonds    = 1;
     c2     = 0;               mHearts      = 2;
     c3     = 1;               mPeaks       = 3;
     c4     = 2;               wNoGame      = 0;
     c5     = 3;               wAK          = 1;
     c6     = 4;               wPair        = 2;
     c7     = 5;               w2Pair       = 3;
     c8     = 6;               wTriple      = 4;
     c9     = 7;               wStreet      = 5;
     c10    = 8;               wFlash       = 6;
     cJack  = 9;               wFullHouse   = 7;
     cQueen = 10;              wCare        = 8;
     cKing  = 11;              wStreetFlash = 9;
     cAce   = 12;              wRoyalFlash  = 10;
                               wAKplus      = 11;
                               wSIMPLEGROUP = [wPair,w2Pair,wTriple,wFullHouse,wCare];
                               wSTREETGROUP = [wStreet,wStreetFlash,wRoyalFlash];
                               wOTHER       = [wAK,wFlash];
     NOCARD = -128; ISCARD = [0..InPack-1];
     buyNo = 1; buyHi = 2; buyLow =3;
     pokerSimple = 0; pokerRussian = 1;
     deadline = False;


type pack = array[Shortint] of Boolean;
     cards = array [1..6] of Shortint;
     checkCombination  = array [wNoGame..wRoyalFlash] of function(c: cards) : Boolean;
     winCoefficient = array[wNoGame..wAKplus, 0..6] of Integer;
     changePrice = array[1..6] of Single;

     //optimized
     cardsOpt = array [0..InPack-1] of Shortint;

var  packCards: pack;
     playCards: array[1..6,1..3] of Shortint;
     player,dealer: cards;
     check: checkCombination;
     winCoef,winCoefRUS: winCoefficient;
     changePrices: changePrice;

     GLOBAL_DEBUG,GLOBAL_DEBUG2: Longint;

     function GetMast(card: Shortint): Shortint;
     function GetCost(card: Shortint): Shortint;
     function GetCard(mast, cost: Shortint) : Shortint;


     procedure InitPack();
     function GetInitialWinCoefs : winCoefficient;
     function GetInitialWinCoefsRUS : winCoefficient;
     procedure ClearCards(var c: cards);
     function SwapCards(c: cards; src,dest: byte) : cards;
     function RandomFromPack() : Shortint;
     procedure BackToPack(card: Shortint);
     function CardsInPack(): Byte;
     function MastOutCount(cost: Shortint) : Byte;

     function Combination(c: cards) : Byte;
     function IsNothing      (c: cards) : Boolean;
     function IsAK           (c: cards) : Boolean;
     function IsPair         (c: cards) : Boolean;
     function Is2Pair        (c: cards) : Boolean;
     function IsTriple       (c: cards) : Boolean;
     function IsStreet       (c: cards) : Boolean;
     function IsFlash        (c: cards) : Boolean;
     function IsFullHouse    (c: cards) : Boolean;
     function IsCare         (c: cards) : Boolean;
     function IsStreetFlash  (c: cards) : Boolean;
     function IsRoyalFlash   (c: cards) : Boolean;
     function MajorComb(c1,c2: cards; combo: Byte) : Shortint;
     function MajorCard(c1,c2: cards) : Shortint;
     function LookOverCombinations(player: cards; var cardN: Byte) : Byte;

     function ThisMastCount(mast: Shortint; c: cards) : Byte;
     function ThisCostCount(cost: Shortint; c: cards) : Byte;
     function CostSort(c: cards) : cards;
     function Sort(c: cards) : cards;
     function SortByCost(c: cards) : cards;
     function MinCostIndex(c: cards) : Byte;
     function MaxCostIndex(c: cards) : Byte;

implementation

uses math, classes;


{function GetMast(card: Shortint) : Shortint;
begin GetMast := card div cardsInMast; end;
function GetCost(card: Shortint) : Shortint;
begin GetCost := card - (card div cardsInMast) * cardsInMast; end;
function GetCard(mast, cost: Shortint) : Shortint;
begin GetCard := mast * cardsInMast + cost; end;}

function GetMast(card: Shortint) : Shortint;
begin GetMast := card and 3; end;
function GetCost(card: Shortint) : Shortint;
begin GetCost := card shr 2; end;
function GetCard(mast, cost: Shortint) : Shortint;
begin GetCard := (cost shl 2) + mast; end;



procedure InitPack();
var i,j: Byte;
begin
   GLOBAL_DEBUG := 0;  GLOBAL_DEBUG2 := 0;
   for i:=0 to InPack-1 do
       packCards[i] := True;
   check[wNoGame] := IsNothing;          
   check[wAK] := IsAK;                   
   check[wPair] := IsPair;               
   check[w2Pair] := Is2Pair;             
   check[wTriple] := IsTriple;           
   check[wStreet] := IsStreet;           
   check[wFlash] := IsFlash;             
   check[wFullHouse] := IsFullHouse;     
   check[wCare] := IsCare;
   check[wStreetFlash] := IsStreetFlash; 
   check[wRoyalFlash] := IsRoyalFlash;

   winCoef := GetInitialWinCoefs;
   winCoefRUS := GetInitialWinCoefsRUS;
   
   for i:=1 to 6 do
       for j:=1 to 3 do
           playCards[i,j] := NOCARD;
end;

function GetInitialWinCoefs : winCoefficient;
var i,j: Byte;
begin
   result[wNoGame,0] := 1;
   result[wAK,0] := 3;
   result[wPair,0] := 3;
   result[w2Pair,0] := 5;
   result[wTriple,0] := 7;
   result[wStreet,0] := 9;
   result[wFlash,0] := 11;
   result[wFullHouse,0] := 15;
   result[wCare,0] := 41;
   result[wStreetFlash,0] := 101;
   result[wRoyalFlash,0] := 201;
   result[wAKplus,0] := 3;
   for i:=wNoGame to wAKplus do
       for j:=1 to 6 do
           result[i,j] := result[i,0];
end;

function GetInitialWinCoefsRUS : winCoefficient;
var i,j: Byte;
begin
   result[wNoGame,0] := 1;
   result[wAK,0] := 2;
   result[wPair,0] := 2;
   result[w2Pair,0] := 4;
   result[wTriple,0] := 6;
   result[wStreet,0] := 8;
   result[wFlash,0] := 10;
   result[wFullHouse,0] := 14;
   result[wCare,0] := 40;
   result[wStreetFlash,0] := 100;
   result[wRoyalFlash,0] := 200;
   result[wAKplus,0] := 2;
   for i:=wNoGame to wAKplus do
       for j:=1 to 6 do
           result[i,j] := result[i,0];
end;

procedure ClearCards(var c: cards);
var i: Byte;
begin
   for i:=1 to 6 do
       c[i] := NOCARD;
end;

{ Меняет значения карт с индексами src и dest }
function SwapCards(c: cards; src,dest: byte) : cards;
var temp: Byte;
begin
   result := c;
   if (src=dest) or (src=0) or (dest=0) then Exit;
   temp := result[src];
   result[src] := result[dest];
   result[dest] := temp;
end;

function RandomFromPack() : Shortint;
var r,i: Byte;
    res: Byte;
begin
     res := Random(InPack);
     if not packCards[res] then begin
        r := Random(CardsInPack());
        for i:=0 to InPack-1 do
            if packCards[i] then
               if r=0 then begin
                  res := i;
                  break;
               end else
                  Dec(r);
     end;
     packCards[res] := False;
     Result := res;
end;

procedure BackToPack(card: Shortint);
begin
     packCards[card] := True;
end;

function CardsInPack(): Byte;
var i: Byte;
begin
   result := 0;
   for i:=0 to InPack-1 do
       if packCards[i] then Inc(result);
end;

(*
{ Возвращает количество вышедших карт данного достоинства }
function MastOutCount(cost: Shortint) : Byte;
var i: Byte;
begin
   result := 0;
   for i:=0 to 3 do
       if not packCards[GetCard(i,cost)] then Inc(result);
end;*)
function MastOutCount(cost: Shortint) : Byte;
var i,a,b: Byte;
begin
   result := 0;
   a := cost shl 2; b := a+3;
   for i:=a to b do
       if not packCards[i] then Inc(result);
end;

{**************************************************** CHECKING COMBINATIONS FUNCTIONS ******}

{ ***************************************************** Combinations ***** }
{ Определяет принадлежность карт какой-либо комбинации }
function Combination(c: cards) : Byte;
var winFLAG: Boolean;
    i: Byte;
begin
   winFLAG := False; i := wRoyalFlash+1;

   { последовательная проверка на соответствие комбинациям
     (сверху вниз, check - массив функций, см. PokerCards) }
   repeat
       Dec(i);
       if check[i](c) then winFLAG := True;
   until winFLAG;

   { возврат результата }
   Combination := i;
end;



{ -------------------------- ничего :) }
function IsNothing(c: cards) : Boolean;
begin
     IsNothing := True;
end;
{ -------------------------- туз-король }
function IsAK(c: cards) : Boolean;
var A, K : Boolean;
    i: Byte;
begin
     A := False; K := False;
     for i:=1 to 5 do begin
         if GetCost(c[i]) = cKing then K := True;
         if GetCost(c[i]) = cAce then A := True;
     end;
     IsAK := A and K;
end;
{ -------------------------- пара }
function IsPair(c: cards) : Boolean;
var i: Byte;
begin
     IsPair := False;
     for i:=1 to 4 do begin
         if ThisCostCount(GetCost(c[i]), c) = 2 then begin
            IsPair := True;
            Break;
         end;
     end;
end;
{ -------------------------- две пары }
function Is2Pair(c: cards) : Boolean;
begin
     Is2Pair := False;
     c := CostSort(c);
     if (c[1]=c[2]) and (c[3]=c[4]) then Is2Pair := True;
end;
{ -------------------------- тройка }
function IsTriple(c: cards) : Boolean;
begin
     IsTriple := False;
     c := CostSort(c);
     if (c[1]=c[2]) and (c[2]=c[3]) then IsTriple := True;
end;
{ -------------------------- стрит }
function IsStreet(c: cards) : Boolean;
var i: Byte;
begin
     IsStreet := True;
     c := CostSort(c);
     for i:=2 to 5 do
         if c[i] <> c[i-1]-1 then IsStreet := False;

     if (c[1]=12) and (c[2]=3) and (c[3]=2) and (c[4]=1) and (c[5]=0) then IsStreet := True;
end;
{ -------------------------- флэш }
function IsFlash(c: cards) : Boolean;
begin
     IsFlash := False;
     if ThisMastCount(GetMast(c[1]), c) = 5 then IsFlash := True;
end;
{ -------------------------- фул хаус }
function IsFullHouse(c: cards) : Boolean;
begin
     IsFullHouse := False;
     c := CostSort(c);
     if (c[1]=c[2]) and (c[2]=c[3]) and (c[4]=c[5])
     or (c[1]=c[2]) and (c[3]=c[4]) and (c[4]=c[5]) then IsFullHouse := True;
end;
{ -------------------------- карэ }
function IsCare(c: cards) : Boolean;
var i: Byte;
begin
     IsCare := False;
     for i:=1 to 2 do
         if ThisCostCount(GetCost(c[i]), c) > 3 then begin
            IsCare := True;
            Break;
         end;
end;

{ -------------------------- стрит флэш }
function IsStreetFlash(c: cards) : Boolean;
begin IsStreetFlash := IsFlash(c) and IsStreet(c); end;

{ -------------------------- флеш-ройял }
function IsRoyalFlash(c: cards) : Boolean;
begin IsRoyalFlash := IsFlash(c) and IsStreet(c) and (ThisCostCount(cAce,c)=1) and (ThisCostCount(cKing,c)=1); end;

{ ------------------------------- Major Combination }
{ определяет выигрышную среди одинаковых комбинаций }
{ c1 win = 1; c2 win = -1; c1=c2=0                  }
function MajorComb(c1, c2: cards; combo: Byte) : Shortint;
begin
     c1 := CostSort(c1); c2 := CostSort(c2);
     if combo = wStreet then // T2345 - самый младший стрит
        MajorComb := Sign(c1[2]-c2[2])
     else
        MajorComb := MajorCard(c1, c2);
end;


{ -------------------------------------------- Major Card }
function MajorCard(c1,c2: cards) : Shortint; // определяет где старшая карта старше
var i: Byte;
begin
     MajorCard := 0;
     for i:=1 to 5 do
         if c1[i] <> c2[i] then begin
            MajorCard := Sign(c1[i]-c2[i]);
            Break;
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


{************************************************************************************}


{ ------------ количество карт этой масти }
function ThisMastCount(mast: Shortint; c: cards) : Byte;
var i,count: Byte;
begin
     count := 0;
     if mast < 0 then begin ThisMastCount := 0; Exit; end;
     for i:=1 to 6 do
         if c[i] in ISCARD then
            if GetMast(c[i]) = mast then Inc(count);
     ThisMastCount := count;
end;
{ ------------ количество карт этого достоинства }
function ThisCostCount(cost: Shortint; c: cards) : Byte;
var i,count: Byte;
begin
     count := 0;
     if cost < 0 then begin ThisCostCount := 0; Exit; end;
     for i:=1 to 6 do
         if c[i] in ISCARD then
            if GetCost(c[i]) = cost then Inc(count);
     ThisCostCount := count;
end;
{ ------------ сортировка карт по убыванию достоинства }
function CostSort(c: cards) : cards;
var sorted: array [0..12] of Shortint;
    m, cur: Byte;
    i,j: Byte;

    function Max(sort: array of Shortint): Shortint; // возвращает достоинство карты
    var i,maxI: Shortint;                        // с максимальным количеством
    begin
         result := 0; maxI := NOCARD;
         for i:=0 to 12 do
             if sort[i] >= result then begin
                result := sort[i];
                maxI := i;
             end;
         if result<2 then result := NOCARD else result := maxI;
    end;
begin
   for i:=0 to 12 do sorted[i] := 0;
   for i:=1 to 5 do begin
       result[i] := NOCARD+i;
       Inc(sorted[GetCost(c[i])]);
   end;

   m := Max(sorted); cur := 1;// сначала - группы карт по старшинству
   while m < 13 do begin
       for i:=cur to cur + sorted[m]-1 do
           result[i] := m;
       cur := cur + sorted[m];
       sorted[m] := 0;
       m := Max(sorted);
   end;

   for i:=12 downto 0 do  // потом - все остальные
       for j:=1 to sorted[i] do begin
          result[cur] := i;
          Inc(cur);
       end;
end;

function compForward (c1, c2: Pointer) : Integer;
begin compForward  := GetCost(Shortint(c1^)) - GetCost(Shortint(c2^)); end;
function compBackward(c1, c2: Pointer) : Integer;
begin compBackward := GetCost(Shortint(c2^)) - GetCost(Shortint(c1^)); end;

function Sort(c: cards) : cards;
var list: TList;
    item: ^shortint;
    i: Byte;
begin
   list := TList.Create;
   try
      for i:=1 to 6 do begin
          Sort[i] := NOCARD;
          if c[i] in ISCARD then begin
             New(item);
             item^ := c[i];
             list.Add(item)
          end;
      end;

      list.Sort(compBackward);

   finally
      for i:=0 to list.Count-1 do begin
          item := list.Items[i];
          Sort[i+1] := item^;
          Dispose(item);
      end;
      list.Free;
   end;
end;

function simpleCompare(c1, c2: Pointer) : Integer;
begin simpleCompare := Shortint(c2^) - Shortint(c1^); end;
{ то же что и Cost, но сортирует учитывая только достоинство }
function SortByCost(c: cards) : cards;
var list: TList;
    item: ^shortint;
    i,a,cost,mast: Byte;
begin
   list := TList.Create;
   try
      for i:=1 to 6 do begin
          a:=a+i;
          SortByCost[i] := NOCARD;
          if c[i] in ISCARD then begin
             New(item);
             {сдвигаем достоинство на 2 бита влево,
                       на освободившееся место пишем масть:}
             if GetCost(c[i])=cAce then cost := 0 // Туз - в конец, чтобы ловить стрит 5432A
                                   else cost := (GetCost(c[i])+1) shl 2;
             mast := GetMast(c[i]);
             item^ := cost + mast;
             list.Add(item)
          end;
      end;

      list.Sort(simpleCompare);

   finally
      for i:=0 to list.Count-1 do begin
          item := list.Items[i];
          if (item^ shr 2)=0 then cost := cAce
                             else cost := (item^-1) shr 2;
          SortByCost[i+1] := GetCard(item^ and 3, cost);
          Dispose(item);
      end;
      list.Free;
   end;
end;


function MinCostIndex(c: cards) : Byte;
var min, minI, i: Byte;
begin
   min := cAce; minI := 0;
   for i:=1 to 6 do
       if c[i] in ISCARD then
          if GetCost(c[i]) < min then begin
             min := GetCost(c[i]); minI := i;
          end;
   MinCostIndex := minI;
end;

function MaxCostIndex(c: cards) : Byte;
var max, maxI, i: Byte;
begin
   max := c2; maxI := 0;
   for i:=1 to 6 do
       if c[i] in ISCARD then
          if GetCost(c[i]) >= max then begin
             max := GetCost(c[i]); maxI := i;
          end;
   MaxCostIndex := maxI;
end;


end.
