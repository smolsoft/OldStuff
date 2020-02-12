unit RussianPoker;

interface

uses PokerCards;

type
    costArray = array[c2..cAce] of byte;
    russianCombo = array[wAK..wAKplus] of byte;



    { возвращает кобинацию Русского покера для набора карт (до 6 шт.) }
    function russianCombination(c: cards) : russianCombo;
    { возвращает саму старшую комбинаци Русского покера }
    function combRus2Simple(cmb: russianCombo) : Byte;
    { возваращает количетсво денег за данный намор комбинаций Русского покера }
    function russianMoney(cmb: russianCombo; changeN: Byte) : Integer;

    { переводит массив карт в массив повторений их достоинств }
    function Cards2CostArray(c: cards) : costArray;

    { проверяет наличие Туза, Короля }
    procedure hasAK(ca: costArray; var combos: russianCombo);
    { проверяет наличие простых комбинаций }
    procedure hasSimple(ca: costArray; var combos: russianCombo);
    { проверяет наличие стритов }
    procedure hasStreet(ca: costArray; var combos: russianCombo);
    { проверяет наличие флеша }
    procedure hasFlash(c: cards; var combos: russianCombo);
    { уточняет, что стрит именно одной масти }
    procedure hasStreetFlash(c: cards; var combos: russianCombo);

    { возвращает комбинацию обычного покера (сделана по мотивам алгоритма Р.П.) }
    function simpleCombination(c: cards; var costs: costArray; useCosts: Boolean = False) : Byte;
    { возвращает комбинацию обычного покера для 6 карт }
    function simple6Combination(c: cards; var costs: costArray; useCosts: Boolean = False) : Byte;
    function hasSimple_smp(ca: costArray; var combos: russianCombo) : Boolean;
    function hasStreet_smp(ca: costArray; var combos: russianCombo) : Boolean;
    function hasFlash_smp(c: cards; var combos: russianCombo) : Boolean;
    function hasAK_smp(ca: costArray) : Boolean;

    function MajorComb(cards1, cards2: cards; combo: Byte) : Shortint;


    function wConst2Str(w: Byte): string;


implementation

uses Math;

{==================================================== RUSSIAN COMBINATION }
function russianCombination(c: cards) : russianCombo;
var cmb: russianCombo;
    costs: costArray;
begin
     FillChar(cmb, SizeOf(cmb), 0);
     costs := Cards2CostArray(c);

     hasAK(costs, cmb);
     hasSimple(costs, cmb);
     hasFlash(c, cmb);
     hasStreet(costs, cmb);
     { доп. проверка на то, что все карты стрита одной масти }
     if (cmb[wStreet]>0) and (cmb[wFlash]>0) then hasStreetFlash(c, cmb);
     //result := cmb; exit; //debug version

     FillChar(result, SizeOf(result), 0);

     { 2 топовые комбинации }
     if cmb[wRoyalFlash]=1 then begin
        { Royal Flash }
        result[wRoyalFlash] := 1;
        { Royal Flash + Street Flash }
        if cmb[wStreetFlash]>0 then result[wStreetFlash] := 1;
        if cmb[wFlash]>0 then result[wFlash] := 1;
        if cmb[wStreet]>0 then result[wStreet] := 1;
        Exit;
     end;

     {все одноцветные стриты}
     if cmb[wStreetFlash]>0 then begin
        { Street Flash }
        result[wStreetFlash] := cmb[wStreetFlash];
        { Street Flash + Street Flash }
        //if (cmb[wStreet]=2) and (cmb[wFlash]=2) then Inc(result[wStreetFlash]);
        { Street Flash + Street }
        if cmb[wStreet]>0 then begin result[wStreet] := 1; Exit; end;
        { Street Flash + Flash }
        if cmb[wFlash]>0 then begin result[wFlash] := 1; Exit; end;
        { Street Flash + AK }
        if cmb[wAK]=1 then result[wAKplus] := 1;
        Exit;
     end;

     {==================================== Обработка уличных комбинаций ===}
     if (cmb[wStreet]>0) or (cmb[wFlash]>0) then begin


        { Street & Flash }
        if (cmb[wStreet]>0) and (cmb[wFlash]>0) then
           begin result[wStreet] := 1; result[wFlash] := 1; Exit; end;
        { Street + TK }
        if (cmb[wStreet]=1) and (cmb[wAK]=1) {& исключить случай разномастного 10ВДКТ}
           and (costs[c2]>0) and (costs[c3]>0) then
           begin result[wStreet] := 1; result[wAKplus] := 1; Exit; end;
        { Street & Street + Street}
        if (cmb[wStreet]>0) then
           begin result[wStreet] := cmb[wStreet]; Exit; end;

        { Flash + AK }
        if (cmb[wFlash]=1) and (cmb[wAK]=1) then
           begin result[wFlash] := 1; result[wAKplus] := 1; Exit; end;
        if (cmb[wFlash]=1) and (cmb[wPair]=1) then
           begin result[wFlash]:=1; result[wPair]:=1; Exit; end;
        { Flash & Flash + Flash }
        if cmb[wFlash]>0 then
           begin result[wFlash] := cmb[wFlash]; Exit; end;



     {==================================== Обработка прямых комбинаций ===}
     end else begin
        { Care + Full House }
        if (cmb[wCare]=1) and (cmb[wPair]=1) then
           begin result[wCare] := 1; result[wFullHouse] := 1; Exit; end;
        { Care + AK }
        if (cmb[wCare]=1) and (cmb[wAK]=1) then
           begin result[wCare] := 1; result[wAKplus] := 1; Exit; end;
        { Care }
        if (cmb[wCare]=1) then
           begin result[wCare] := 1; Exit; end;

        { Full House + Full House }
        if (cmb[wTriple]=2) then
           begin result[wFullHouse] := 2; Exit; end;
        { Full House + TK }
        if (cmb[wTriple]=1) and (cmb[wPair]=1) and (cmb[wAK]=1) // & исключение случая ТТТКК:
                            and ( (costs[cAce]=1) or (costs[cKing]=1) ) then
           begin result[wFullHouse] := 1; result[wAKplus] := 1; Exit; end;
        { Full House }
        if (cmb[wTriple]=1) and (cmb[wPair]=1) then
           begin result[wFullHouse] := 1; Exit; end;

        { Triple + AK }
        if (cmb[wTriple]=1) and (cmb[wAK]=1) then
           begin result[wTriple] := 1; result[wAKplus] := 1; Exit; end;
        { Triple }
        if (cmb[wTriple]=1) then
           begin result[wTriple] := 1; Exit; end;

        { 2Pair + 2Pair }
        if (cmb[wPair]=3) then
           begin result[w2Pair] := 2; Exit; end;
        { 2Pair + AK }                       // & исключение случая ТТКК:
        if (cmb[wPair]=2) and (cmb[wAK]=1) and ( (costs[cAce]=1) or (costs[cKing]=1) ) then
           begin result[w2Pair] := 1; result[wAKplus] := 1; Exit; end;
        { 2Pair }
        if (cmb[wPair]=2) then
           begin result[w2Pair] := 1; Exit; end;

        { Pair + AK }
        if (cmb[wPair]=1) and (cmb[wAK]=1) then
           begin result[wPair] := 1; result[wAKplus] := 1; Exit; end;

        result := cmb // обработка Пары, Туз-Король и Нет игры
     end;
end;


function russianMoney(cmb: russianCombo; changeN: Byte) : Integer;
var i: Byte;
begin
     result := 0;
     for i:=wAK to wAKplus do
         Inc(result,cmb[i]*winCoefRUS[i, changeN]);
     if result=0 then result := winCoefRUS[wNoGame, changeN];
end;

{==================================================== SIMPLE COMBINATION }
function simpleCombination(c: cards; var costs: costArray; useCosts: Boolean = False) : Byte;
var cmb: russianCombo;
    flash, street: Boolean;
begin
     result := wNoGame;
     FillChar(cmb, SizeOf(cmb), 0);
     c[6] := NOCARD;
     if not useCosts then
        costs := Cards2CostArray(c);

     if hasSimple_smp(costs,cmb) then begin
        if cmb[wCare]=1 then begin result:=wCare; Exit; end;
        if (cmb[wTriple]=1) and (cmb[wPair]=1) then begin result:=wFullHouse; Exit; end;
        if cmb[wTriple]=1 then begin result:=wTriple; Exit; end;
        if cmb[wPair]=2 then begin result:=w2Pair; Exit; end;
        if cmb[wPair]=1 then begin result:=wPair; Exit; end;
     end;

     flash := hasFlash_smp(c, cmb);
     street := hasStreet_smp(costs, cmb);

     if flash or street then begin
        if flash and street then begin
           result := wStreetFlash;
           if cmb[wRoyalFlash]=1 then result:=wRoyalFlash;
        end else begin
           if flash then result:=wFlash;
           if street then result:=wStreet;
        end;
        Exit;
     end;

     if hasAK_smp(costs) then result := wAK;
end;


function simple6Combination(c: cards; var costs: costArray; useCosts: Boolean = False) : Byte;
var cmb: russianCombo;
begin
     result := wNoGame;
     FillChar(cmb, SizeOf(cmb), 0);
     if not useCosts then costs := Cards2CostArray(c);

     hasAK(costs, cmb);
     hasSimple(costs, cmb);
     hasFlash(c, cmb);
     hasStreet(costs, cmb);
     { доп. проверка на то, что все карты стрита одной масти }
     if (cmb[wStreet]>0) and (cmb[wFlash]>0) then begin
        hasStreetFlash(c, cmb);
        if cmb[wRoyalFlash]>0 then begin result:=wRoyalFlash; Exit; end;
        if cmb[wStreetFlash]>0 then begin result:=wStreetFlash; Exit; end;
     end;



     {==================================== Обработка уличных комбинаций ===}
     if (cmb[wStreet]>0) or (cmb[wFlash]>0) then begin
        if cmb[wFlash]>0 then begin result:=wFlash; Exit; end;
        if cmb[wStreet]>0 then begin result:=wStreet; Exit; end;
     {==================================== Обработка прямых комбинаций ===}
     end else begin
        if cmb[wCare]>0 then begin result:=wCare; Exit; end;
        if (cmb[wTriple]=2) or
           ((cmb[wTriple]>0) and (cmb[wPair]>0)) then begin result:=wFullHouse; Exit; end;
        if cmb[wTriple]>0 then begin result:=wTriple; Exit; end;
        if cmb[wPair]>=2 then begin result:=w2Pair; Exit; end;
        if cmb[wPair]=1 then begin result:=wPair; Exit; end;
        if cmb[wAK]>0 then begin result:=wAK; Exit; end;
     end;
end;

{==================================================== CARDS TO COSTARRAY }
function Cards2CostArray(c: cards) : costArray;
var i: Byte;
begin
     FillChar(result, SizeOf(result), 0);
     for i:=1 to 6 do
         if c[i] in ISCARD then Inc(result[GetCost(c[i])]);
end;


{==================================================== HAS ACE-KING }
procedure hasAK(ca: costArray; var combos: russianCombo);
begin
     if ((ca[cAce]>0) and (ca[cKing]>0)) then
        combos[wAK]:=1
     else
        combos[wAK]:=0;
end;

{==================================================== HAS SIMPLE }
procedure hasSimple(ca: costArray; var combos: russianCombo);
var i: Byte;
begin
     for i:=c2 to cAce do
         case ca[i] of
              2: Inc(combos[wPair]);
              3: Inc(combos[wTriple]);
              4: Inc(combos[wCare]);
         end;
end;

{==================================================== HAS STREET }
{ устанавливает wStreet и/или wRoyalFlash}
procedure hasStreet(ca: costArray; var combos: russianCombo);
var i, sameCount, sameStart, sameSum: Byte;
begin
     sameCount := 0; sameStart := 0; sameSum := 0;

     if ca[cAce]>0 then begin
        Inc(sameCount);
        sameStart := cAce;
        sameSum := sameSum + ca[cAce];
     end;

     for i:=c2 to cAce do
         if ca[i]>0 then begin
            if sameCount=0 then sameStart:=i;
            Inc(sameCount);
            sameSum := sameSum + ca[i];
         end else begin
            if sameCount >= 5 then break;
            sameCount:=0;
            sameStart:=0;
            sameSum  :=0;
         end;

     if sameCount >= 5 then begin
        combos[wStreet] := sameSum-4; // 1 или 2 стрита
        if (sameStart + sameCount - 1 = cAce)    { если кончается на тузе }
                     and (combos[wFlash]>0) then { и есть флэш }
           combos[wRoyalFlash] := 1;           { - значит подозрение на Royal }
     end;
end;

{==================================================== HAS FLASH }
{ устанавливает wFlash }
procedure hasFlash(c: cards; var combos: russianCombo);
var i,m: Byte;
    mArr: array [mCrosses..mPeaks] of Byte;
    maxCount: Byte;
begin
     FillChar(mArr, SizeOf(mArr), 0);
     maxCount := 0;

     for i:=1 to Length(c) do
         if c[i] in ISCARD then begin
             m := GetMast(c[i]);
             Inc(mArr[m]);
             if mArr[m]>maxCount then maxCount := mArr[m];
         end;

     if maxCount>=5 then
        combos[wFlash] := maxCount-4; //1 или 2 флеша
end;

{==================================================== HAS STREET FLASH }
{ устанавливает wRoyalFlash и/или wStreetFlash }
procedure hasStreetFlash(c: cards; var combos: russianCombo);
var i,j: Byte;
    flash: cards;
    cmb: russianCombo;
    costs: costArray;
begin
     j := 1;
     ClearCards(flash);
     for i:=1 to Length(c) do
         if ThisMastCount(GetMast(c[i]),c)>=5 then begin
            flash[j] := c[i];
            Inc(j);
         end;

     if j>5 then begin
        FillChar(cmb, SizeOf(cmb), 0);
        cmb[wFlash] := j-5;
        costs := Cards2CostArray(flash);
        hasStreet(costs,cmb);

        combos[wRoyalFlash] := cmb[wRoyalFlash];
        if cmb[wStreet] > 0 then begin
           combos[wStreetFlash] := cmb[wStreet]-cmb[wRoyalFlash];
           Dec(combos[wStreet], combos[wStreetFlash]+combos[wRoyalFlash]);
           Dec(combos[wFlash], combos[wStreetFlash]+combos[wRoyalFlash]);
           //combos[wStreet] := 0;
           //combos[wFlash] := cmb[wStreet];
        end;
     end;
end;

{ Возвращает максимальную комбинацию или нет игры }
function combRus2Simple(cmb: russianCombo) : Byte;
var i: Byte;
begin
   result := wNoGame;
   for i:=wRoyalFlash downto wAK do
       if cmb[i]>0 then begin result:=i; Exit; end;
end;

function wConst2Str(w: Byte): string;
begin
     case w of
          wNoGame:       result := 'NOGAME';
          wAK:           result := 'AK';
          wPair:         result := 'PAIR';
          w2Pair:        result := '2PAIR';
          wTriple:       result := 'TRIPLE';
          wStreet:       result := 'STREET';
          wFlash:        result := 'FLASH';
          wFullHouse:    result := 'FULLHOUSE';
          wCare:         result := 'CARE';
          wStreetFlash:  result := 'STRFLASH';
          wRoyalFlash:   result := 'ROYFLASH';
     end;

end;













{==================================================== HAS SIMPLE for simple}
function hasSimple_smp(ca: costArray; var combos: russianCombo) : Boolean;
var i: Byte;
begin
     result := False;
     for i:=c2 to cAce do
         case ca[i] of
              2: begin Inc(combos[wPair]); result:=True; end;
              3: begin Inc(combos[wTriple]); result:=True; end;
              4: begin Inc(combos[wCare]); result:=True; end;
         end;
end;

{==================================================== HAS STREET for simple }
function hasStreet_smp(ca: costArray; var combos: russianCombo) : Boolean;
var i, count: Byte;
begin
     result := False;
     count := 0;

     if (ca[cAce]>0) and (ca[c2]>0) then Inc(count);

     for i:=c2 to cAce do
         if ca[i]>0 then begin
            if count<5 then Inc(count) else Break;
         end else begin
            if count>0 then Break;
         end;

     if count = 5 then begin
        result := True;
        combos[wStreet] := 1;
        if ca[c10]+ca[cAce]=2 then  { если есть десятка и есть туз }
           combos[wRoyalFlash] := 1;{ - значит подозрение на Royal }
     end;
end;

{==================================================== HAS FLASH for simple }
function hasFlash_smp(c: cards; var combos: russianCombo) : Boolean;
var i,m: Byte;
begin
     m := GetMast(c[1]); result:=True;

     for i:=2 to 5 do
         if GetMast(c[i])<>m then begin
            result:=False;
            Break;
         end;

     if result then combos[wFlash] := 1;
end;

{==================================================== HAS ACE-KING for simple }
function hasAK_smp(ca: costArray) : Boolean;
begin
     if ((ca[cAce]>0) and (ca[cKing]>0)) then result:=True else result:=False;
end;




function MajorComb(cards1, cards2: cards; combo: Byte) : Shortint;
var costs1, costs2: costArray;
    i: Byte;
    signs: array [1..4] of Shortint;
begin
     MajorComb:=0;
     costs1:=Cards2CostArray(cards1); costs2:=Cards2CostArray(cards2);

     if combo in wSTREETGROUP then begin
        for i:=cKing downto c2 do
            if (costs1[i]>0) and (costs2[i]>0) then begin
               MajorComb := 0;
               if costs1[i+1]>0 then MajorComb := 1;
               if costs2[i+1]>0 then MajorComb := -1;
               Break;
            end
     end else if combo=wFlash then begin
        for i:=cAce downto c2 do
            if costs1[i]<>costs2[i] then begin
               MajorComb := Sign(costs1[i]-costs2[i]);
               Break;
            end
     end else begin
        FillChar(signs, SizeOf(signs), 0);
        for i:=cAce downto c2 do begin
            if costs2[i]<>costs1[i] then begin
               if (costs1[i]>0) and (signs[costs1[i]]=0) then signs[costs1[i]]:=1;
               if (costs2[i]>0) and (signs[costs2[i]]=0) then signs[costs2[i]]:=-1;
            end;
        end;
        for i:=4 downto 1 do
            if signs[i]<>0 then begin MajorComb:=signs[i]; Break; end;
     end;
end;


(*


     {==================================== Обработка уличных комбинаций ===}
     if (cmb[wStreet]>0) or (cmb[wFlash]>0) then begin
        { доп. проверка на то, что все карты стрита одной масти }
        hasStreetFlash(c, cmb);

        if cmb[wRoyalFlash]=1 then begin
           { Royal Flash + Street Flash }
           if (cmb[wFlash]=2) and (cmb[wStreet]=2) then
              begin result[wRoyalFlash] := 1; result[wStreetFlash] := 1; Exit; end;
           { Royal Flash }
           result[wRoyalFlash] := 1;
           Exit;
        end;

        {все одноцветные стриты}
        if cmb[wStreetFlash]=1 then begin
           { Street Flash + Street Flash }
           if (cmb[wStreet]=2) and (cmb[wFlash]=2) then
              begin result[wStreetFlash] := 2; Exit; end;
           { Street Flash + Street }
           if (cmb[wStreet]=2) and (cmb[wFlash]=1) then
              begin result[wStreetFlash] := 1; result[wStreet] := 1; Exit; end;
              { Street Flash + Flash }
           if (cmb[wStreet]=1) and (cmb[wFlash]=2) then
              begin result[wStreetFlash] := 1; result[wFlash] := 1; Exit; end;
           { Street Flash + AK }
           if (cmb[wStreet]=1) and (cmb[wFlash]=1) and (cmb[wAK]=1) then
              begin result[wStreetFlash] := 1; result[wAK] := 1; Exit; end;
           { Street Flash }
           result[wStreetFlash] := 1;
           Exit;
        end;

        { Street + TK }
        if (cmb[wStreet]=1) and (cmb[wAK]=1) {& исключить случай разномастного 10ВДКТ}
           and (costs[c2]>0) and (costs[c3]>0) then
           begin result[wStreet] := 1; result[wAK] := 1; Exit; end;
        { Street & Street + Street}
        if (cmb[wStreet]>0) then
           begin result[wStreet] := cmb[wStreet]; Exit; end;

        { Flash & Flash + Flash }
        if (cmb[wFlash]>0) then
           begin result[wFlash] := cmb[wFlash]; Exit; end;



     {==================================== Обработка прямых комбинаций ===}
     end else begin
        { Care + Full House }
        if (cmb[wCare]=1) and (cmb[wPair]=1) then
           begin result[wCare] := 1; result[wFullHouse] := 1; Exit; end;
        { Care + AK }
        if (cmb[wCare]=1) and (cmb[wAK]=1) then
           begin result[wCare] := 1; result[wAK] := 1; Exit; end;
        { Care }
        if (cmb[wCare]=1) then
           begin result[wCare] := 1; Exit; end;

        { Full House + Full House }
        if (cmb[wTriple]=2) then
           begin result[wFullHouse] := 2; Exit; end;
        { Full House + TK }
        if (cmb[wTriple]=1) and (cmb[wPair]=1) and (cmb[wAK]=1) // & исключение случая ТТТКК:
                            and ( (costs[cAce]=1) or (costs[cKing]=1) ) then
           begin result[wFullHouse] := 1; result[wAK] := 1; Exit; end;
        { Full House }
        if (cmb[wTriple]=1) and (cmb[wPair]=1) then
           begin result[wFullHouse] := 1; Exit; end;

        { Triple + AK }
        if (cmb[wTriple]=1) and (cmb[wAK]=1) then
           begin result[wTriple] := 1; result[wAK] := 1; Exit; end;
        { Triple }
        if (cmb[wTriple]=1) then
           begin result[wTriple] := 1; Exit; end;

        { 2Pair + AK }
        if (cmb[wPair]=2) and (cmb[wAK]=1) then
           begin result[w2Pair] := 1; result[wAK] := 1; Exit; end;
        { 2Pair }
        if (cmb[wPair]=2) then
           begin result[w2Pair] := 1; Exit; end;

        { Pair + AK }
        if (cmb[wPair]=1) and (cmb[wAK]=1) then
           begin result[wPair] := 1; result[wAK] := 1; Exit; end;

        result := cmb // обработка Пары, Туз-Король и Нет игры
     end;






{==================================================== HAS STREET FLASH }
procedure hasStreetFlash(c: cards; var combos: russianCombo);
var i,i0, mast: Byte;
    flag1, flag2: Boolean;
begin
     {отсортировать карты по убыванию достоинства}
     c := CostSort(c);

     {проверка с какой карты начинается стрит}
     if GetCost(c[1])-GetCost(c[2])=1 then begin
        {доп. проверка на равность масти первых двух карт}
        if GetMast(c[1])=GetMast(c[2]) then i0:=1 else i0:=2;
     end else
        i0:=2;

     flag1 := True; // надежда
     mast := GetMast(c[i0]);
     for i:=i0+1 to i0+4 do
         if GetMast(c[i])<>mast then begin
            flag1 := False;
            Break;
         end;

     { если не наудено при такой сортировке, попробуем отсортировать в виде К5432Т }
     if not flag1 then begin
        c := SortByCost(c);
        if GetCost(c[1])-GetCost(c[2])=1 then begin
           if GetMast(c[1])=GetMast(c[2]) then i0:=1 else i0:=2;
        end else
           i0:=2;
        flag2 := True; mast := GetMast(c[i0]);
        for i:=i0+1 to i0+4 do
            if GetMast(c[i])<>mast then begin flag2 := False; Break; end;
     end;

     {найдено 5 карт одной масти}
     if flag1 then begin
        combos[wStreetFlash] := 1;
        Exit;
     end else if flag2 then begin
        combos[wStreetFlash] := 1;
     end;
     if combos[wRoyalFlash]=1 then combos[wRoyalFlash] := 0;
end;






     *)




end.
