unit BestChange;

interface

uses PokerCards, Optimization, RussianPoker;

type exchangeArray = array[1..6] of Boolean;

var playWhen: cards; combWhen: Byte;
    preparingFLAG, preparedFLAG: Boolean;
    waitingMO: Boolean;
    dealer, player: array of xcards;

function GetMO(dealer, player: cards;
                     exchange: exchangeArray;
                          nnn: Longint;
                      minGame: Byte;
                        poker: Byte = pokerSimple) : Double;

function BestBuy(dealer, player: cards; NNN: Longint;
                 buyWhat, minGame, changeN,poker: Byte) : Double;


procedure PreparingInit;
procedure PrepareArray(nnn: Longint; firstCard: shortint);
function GetMOopt(pl: cards; changeN: Byte; changePrice: Real; minGame: Byte) : Double;

procedure InitDataCards(NNN: Longint; deep: Byte);
procedure FreeDataCards;

implementation

uses SysUtils, Math, Analize, Forms;

type cardsArray = array [1..9] of Shortint;
var filledCards: Byte;
    dataCards: array of cardsArray;

procedure InitDataCards(NNN: Longint; deep: Byte);
var i:Longint;
    j:Byte;
begin
     SetLength(dataCards, NNN+1);
     filledCards := Min(deep,9);
     for i:=1 to NNN do begin
         for j:=1 to filledCards do dataCards[i][j]:=RandomFromPack();
         for j:=1 to filledCards do BackToPack(dataCards[i][j]);
     end;
end;

procedure FreeDataCards;
begin SetLength(dataCards, 0); filledCards := 0; end;

function GetMO(dealer, player: cards;
                     exchange: exchangeArray;
                          NNN: Longint;
                      minGame: Byte;
                        poker: Byte = pokerSimple) : Double;
var i: Longint;
    playerComb, dealerComb: Byte;
    rusComb: russianCombo;
    money: Double;
    changeN: Byte;
    playDecision: Boolean;
    minDealerCards: Byte;

    costs: costArray;


    procedure GetCardsFromPack;                            { Get Cards From Pack }
    var j,k,needed: Byte;
    begin
       if changeN=6 then needed:=5 else needed:=changeN+4;
       if filledCards>=needed then begin
          k:=1;
          for j:=1 to 6 do
              if exchange[j] then begin
                 player[j] := dataCards[i][k];
                 packCards[player[j]] := False;
                 Inc(k);
              end;
          playDecision := MastOutCount(GetCost(dealer[1]))>minDealerCards;
          for j:=2 to 5 do begin
              dealer[j] := dataCards[i][k];
              packCards[dealer[j]] := False;
              Inc(k);
          end;
       end else begin
          for j:=1 to 6 do         {обменять карты игроку}
              if exchange[j] then
                 player[j] := RandomFromPack();
          playDecision := MastOutCount(GetCost(dealer[1]))>minDealerCards;
          for j:=2 to 5 do dealer[j] := RandomFromPack(); {взять карты дилеру}
       end;
    end;

    procedure BackCardsToPack;                              { Back Cards To Pack }
    var i: Byte;
    begin {вернуть карты в колоду для следующего эксперимента}
       for i:=2 to 5 do BackToPack(dealer[i]);
       for i:=1 to 6 do
           if exchange[i] then BackToPack(player[i]);
    end;

    { Определяет кто победитель                                    Who Is Winner
      -1   Дилер
       0   Ничья
       1   Игрок                }
    function WhoIsWinner(playerComb, dealerComb : Byte) : Shortint;
    begin
       result := Sign(playerComb - dealerComb);
       if result = 0 then begin  {player и dealer - с другого "уровня" :) }
          result := RussianPoker.MajorComb(player, dealer, playerComb);
       end;
    end;

    function WhoIsRussianWinner(dealerComb: Byte; rus: russianCombo) : Shortint;
    var i: Byte;
    begin
       result := -1;
       // поиск наличия комбинации старшей чем у дилера
       for i:=dealerComb+1 to wRoyalFlash do
           if rus[i]>0 then begin result := 1; Exit; end;
       // если есть равная комбинация
       if rus[dealerComb]>0 then
          result := RussianPoker.MajorComb(player, dealer, dealerComb);
    end;

    function PlayNow(playerComb: Byte) : Boolean;
    var playerSort: cards;
    begin
       if poker=pokerRussian then playerComb:=combRus2Simple(rusComb);
       playerSort := CostSort(player);
       result := (playerComb > combWhen)
              or((playerComb = combWhen) and (MajorCard(playerSort, playWhen) <> -1));
    end;

begin
   money := 0; changeN := 0; ClearCards(playWhen);
   if minGame = wAK then begin
      playWhen[1] := cAce; playWhen[2] := cKing; playWhen[3] := cJack; combWhen := wAK;
      minDealerCards := 2;
   end else begin
      playWhen[1] := c3; playWhen[2] := c3; combWhen := wPair;
      minDealerCards := 1;
   end;

   if exchange[6] then
      changeN := 6
   else begin
      for i:=1 to 5 do if exchange[i] then Inc(changeN);
      player[6] := NOCARD;
   end;

   for i:=1 to NNN do begin
       GetCardsFromPack; { добрать карты из колоды }

       dealerComb := simpleCombination(dealer,costs); // комбинация дилера

       if poker=pokerSimple then begin
          if exchange[6] then
             playerComb := simple6Combination(player,costs) // выбрать лучшую
          else
             playerComb := simpleCombination(player,costs); // комбинация игрока
       end else
          rusComb := russianCombination(player);

       if changeN > 0 then money := money - changePrices[changeN]; { СТОИМОСТЬ ОБМЕНА }

       if (changeN=0) or playDecision or PlayNow(playerComb) then begin
          if dealerComb < minGame then  // нет игры у дилера
             money := money + winCoef[wNoGame, changeN]
          else

             if poker=pokerSimple then
                case WhoIsWinner(playerComb, dealerComb) of
                 1: money := money + winCoef[playerComb, changeN]; { Player win}
                -1: money := money - (1 + 2); // вычесть ставку + закрывание
                end
             else
                { RUSSIAN POKER }
                case WhoIsRussianWinner(dealerComb, rusComb) of
                 1: money := money + russianMoney(rusComb, changeN); { Player win}
                -1: money := money - (1 + 2); // вычесть ставку + закрывание
                end;

       end else
           money := money - 1; // проиграли ставку

       BackCardsToPack; { вернуть карты в колоду }
   end;
   GetMO := money/NNN;
end;


function BestBuy(dealer, player: cards; NNN: Longint; buyWhat, minGame, changeN: Byte; poker: Byte) : Double;
var i: Longint;
    BuyIndex, cardN: Byte;
    dComb, pComb: Byte;
    pMoney: Integer;
    sum: Double;

    function WhoIsWinner : Shortint;
    begin
       result := Sign(pComb - dComb);
       if result = 0 then result := MajorComb(player, dealer, pComb);
    end;

begin
   sum := 0; BuyIndex := 6;
   case buyWhat of
        buyHi:  BuyIndex := MaxCostIndex(dealer);
        buyLow: BuyIndex := MinCostIndex(dealer);
   end;

   if poker=pokerSimple then begin
      if player[6] in ISCARD then
         pComb := Optimization.LookOverCombinations(player, cardN)
      else
         pComb := Optimization.Combination(player);
      pMoney := winCoef[pComb, changeN];
   end else begin
      pComb := combRus2Simple(russianCombination(player));
      pMoney := russianMoney(russianCombination(player),changeN);
   end;

   for i:=1 to NNN do begin
       dealer[BuyIndex] := RandomFromPack;
       dComb := Combination(dealer);
       sum := sum - 1;
       if dComb >= minGame then
          case WhoIsWinner of
           -1: sum := sum - 3;
           {0: ;}
            1: sum := sum + pMoney;
          end;
       {if changeN > 0 then
          sum := sum - changePrices[changeN];}
       BackToPack(dealer[BuyIndex]);
   end;

   result := sum / NNN;
end;


procedure PreparingInit;
begin preparingFLAG := False; preparedFLAG := False; waitingMO := False;
      SetLength(dealer, 0); SetLength(player,0); end;

procedure PrepareArray(nnn: Longint; firstCard: shortint);
var i: Longint;
    j: Byte;
    ch: Shortint;
begin
   if preparingFLAG then Exit;
   if preparedFlag then PreparingInit;
   preparingFlag := True;
   try
      SetLength(dealer, nnn); SetLength(player, nnn);
      Randomize;
      for i:=0 to nnn-1 do begin
          dealer[i].s := '0000000000000'; player[i].s := '0000000000000';
          with dealer[i] do begin
              c[1] := firstCard; s[GetCost(firstCard)] := Chr(Ord(s[GetCost(firstCard)])+1);
          end;
          for j:=2 to 5 do with dealer[i] do begin
              c[j] := RandomFromPack;
              ch := GetCost(c[j]);
              s[ch] := Chr(Ord(s[ch])+1);
          end;
          for j:=1 to 5 do with player[i] do begin
              c[j] := RandomFromPack; s[GetCost(c[j])] := Chr(Ord(s[GetCost(c[j])])+1);
          end;
          for j:=2 to 5 do BackToPack(dealer[i].c[j]);
          for j:=1 to 5 do BackToPack(player[i].c[j]);
          dealer[i].comb := Optimization.CombinationX(dealer[i]);
          Application.ProcessMessages;
      end;
      preparingFLAG := False; preparedFLAG := True;
   except
      preparedFLAG := False;
      SetLength(dealer, 0); SetLength(player, 0);
   end;
end;

function GetMOopt(pl: cards; changeN: Byte; changePrice: Real; minGame: Byte):Double;
var i: Longint; temp: Cards;
    playerComb, cardN, j: Byte;
    money: Double;
    playDecision: Boolean;

    { Определяет кто победитель                                    Who Is Winner }
    function WhoIsWinner(playerComb, dealerComb : Byte) : Shortint;
    begin
       result := Sign(playerComb - dealerComb);
       if result = 0 then begin  {player и dealer - с другого "уровня" :) }
          result := MajorComb(player[i].c, dealer[i].c, playerComb);
       end;
    end;

    function PlayNow(playerComb: Byte) : Boolean;
    var playerSort: cards;
    begin
       playerSort := CostSort(player[i].c);
       result := (playerComb > combWhen)
              or((playerComb = combWhen) and (MajorCard(playerSort, playWhen) <> -1));
    end;

begin
   if preparingFLAG then Exit;

   money := 0; ClearCards(playWhen);
   if minGame = wAK then begin
      playWhen[1] := cAce; playWhen[2] := cKing; playWhen[3] := cJack; combWhen := wAK;
      playDecision := MastOutCount(GetCost(dealer[0].c[1]))>2;
   end else begin
      playWhen[1] := c3; playWhen[2] := c3; combWhen := wPair;
      playDecision := MastOutCount(GetCost(dealer[0].c[1]))>1;
   end;

   for i:=0 to Length(dealer) do begin
       cardN := 6; temp := player[i].c;
       for j:=1 to 5 do         {обменять карты игроку}
           if pl[j] in ISCARD then player[i].c[j] := pl[j];

       if changeN = 6 then begin
          player[i].c[6] := temp[1];
          player[i].comb := Optimization.LookOverCombinations(player[i].c, cardN); // выбрать лучшую
          player[i].c := SwapCards(player[i].c, cardN, 6); // актуализировать массив player
       end else
          player[i].comb := Optimization.CombinationX(player[i]); // комбинация игрока

       if changeN > 0 then money := money - changePrices[changeN]; { СТОИМОСТЬ ОБМЕНА }

       if (changeN=0) or playDecision or PlayNow(player[i].comb) then begin
          if dealer[i].comb < minGame then  // нет игры у дилера
             money := money + winCoef[wNoGame, changeN]
          else
             case WhoIsWinner(player[i].comb, dealer[i].comb) of
              1: money := money + winCoef[player[i].comb, changeN]; { Player win}
             -1: money := money - (1 + 2); // вычесть ставку + закрывание
             end;
       end else
           money := money - 1; // проиграли ставку

       player[i].c := temp;
   end;
   GetMOopt := money/Length(dealer);
end;
(*
    function PlayNow(playerComb: Byte) : Boolean;
    var playerSort: cards;

        function CheckMinGame() : Boolean;
        var temp: cards; comb: Byte;
        begin
           ClearCards(temp);temp:=playWhen;comb:=combWhen;ClearCards(playWhen);
           playWhen[1] := c3; playWhen[2] := c3; combWhen := wPair;
           result := PlayNow(playerComb);
           playWhen := temp; combWhen := comb;
        end;

    begin
       result := True;

       if combWhen = wNoGame then begin {minGame = 22}
          if ThisCostCount(playWhen[1], player)>0 then
             result := True
          else
             result := (playerComb > wPair)
                    or((playerComb = wPair) and CheckMinGame());
       end else begin { minGame = TK }
          playerSort := CostSort(player);
          result := (playerComb > combWhen)
                 or((playerComb = combWhen) and (MajorCard(playerSort, playWhen) <> -1));
       end;
    end;
*)


end.
