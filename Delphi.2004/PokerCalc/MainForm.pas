unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, PokerCards, Math, ComCtrls, ExtCtrls, Menus, Optimization,
  RussianPoker;

type
  TfrmMain = class(TForm)
    grpSource: TGroupBox;
    grdPlayCards: TDrawGrid;
    lblDealer: TLabel;
    lblPlayer: TLabel;
    lblCards: TLabel;
    lblAnteCost1: TLabel;
    txtExChange: TEdit;
    lblWinTable: TLabel;
    lblExCards: TLabel;
    grdExCards: TDrawGrid;
    grpResults: TGroupBox;
    grdWins: TStringGrid;
    grdCombo: TStringGrid;
    lblAnteEx: TLabel;
    lblWins: TLabel;
    lblAnteCost2: TLabel;
    lblNumGames2: TLabel;
    lblNumGames1: TLabel;
    txtNNN: TEdit;
    ProgressBar: TProgressBar;
    lblWinsValue: TLabel;
    lblCardsCount1: TLabel;
    chk6Cards: TCheckBox;
    lblTime: TLabel;
    lblEx: TLabel;
    lblExCount: TLabel;
    btnStart: TButton;
    Bevel1: TBevel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    chkMin22: TRadioButton;
    chkMinTK: TRadioButton;
    grdMem: TStringGrid;
    btnClear: TButton;
    lblCardsNum: TLabel;
    popResults: TPopupMenu;
    N1: TMenuItem;
    lblAnteValue: TLabel;
    grdPlayWhen: TDrawGrid;
    chkPlayAlways: TRadioButton;
    chkPlayWhen: TRadioButton;
    cmbChange: TComboBox;
    btnBestChange: TButton;
    Timer: TTimer;
    chkRussian: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure grdPlayCardsKeyPress(Sender: TObject; var Key: Char);
    procedure grdPlayCardsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure grdExCardsDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
    procedure grdPlayCardsKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure grdPlayCardsDblClick(Sender: TObject);
    procedure chk6CardsClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnStartClick(Sender: TObject);
    procedure chkMin22Click(Sender: TObject);
    procedure chkMinTKClick(Sender: TObject);
    procedure txtNNNChange(Sender: TObject);
    procedure btnClearClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure grdMemDblClick(Sender: TObject);
    procedure grdExCardsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chkPlayWhenClick(Sender: TObject);
    procedure grdPlayWhenDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure grdPlayWhenKeyPress(Sender: TObject; var Key: Char);
    procedure grdPlayWhenKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure txtExChangeChange(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    function PlayNow(playerComb: Byte; russianComb : russianCombo) : boolean;
    procedure cmbChangeChange(Sender: TObject);
    procedure grdPlayCardsMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btnBestChangeClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure chkRussianClick(Sender: TObject);

  private
    { Private declarations }
    function InPlayCards(c: Shortint) : Boolean;
    procedure NormalizePlayCards;
    procedure UpdateComboChange;
  public
    { Public declarations }
    exchange: array[1..6] of Boolean;

    minGame: Byte; // минимальная игра ТК/22
    playWhen: cards; playFlag: boolean; // закрываться
    NNN: Longint;      // количество экспериментов
    changePrice: Single;
    closePrice: Single;
    CardsInGame: Byte; // количество карт в игре (6/5)

    stopFLAG: Boolean;
    calcFLAG: Boolean;
    showStatFLAG: Boolean;

    _AUTOMATE: Boolean;
    procedure SetComboChange(n: Byte);
  end;

var
  frmMain: TfrmMain;

implementation

uses DrawCards, BestChangesForm, analize;
{$R *.dfm}

{ ***************************************************** FORM CREATE ***** }
procedure TfrmMain.FormCreate(Sender: TObject);
var i: Byte;
begin
   grdWins.Cells[0,wNoGame] := 'Нет игры';        
   grdWins.Cells[0,wAK] := 'Туз-Король';          
   grdWins.Cells[0,wPair] := 'Пара';              
   grdWins.Cells[0,w2Pair] := 'Две пары';         
   grdWins.Cells[0,wTriple] := 'Тройка';          
   grdWins.Cells[0,wStreet] := 'Стрит';           
   grdWins.Cells[0,wFlash] := 'Флеш';             
   grdWins.Cells[0,wFullHouse] := 'Фул Хаус';     
   grdWins.Cells[0,wCare] := 'Каре';              
   grdWins.Cells[0,wStreetFlash] := 'Стрит Флеш';
   grdWins.Cells[0,wRoyalFlash] := 'Ройял Флеш';
   grdWins.ColWidths[0] := 95;
   for i:=wNoGame to wRoyalFlash do begin
       grdWins.Cells[1,i] := IntToStr(winCoef[i,0]);
       grdWins.RowHeights[i] := 20;
   end;

   grdCombo.Cells[1,0] := 'Дилер'; grdCombo.Cells[2,0] := '%';
   grdCombo.Cells[3,0] := 'Игрок'; grdCombo.Cells[4,0] := '%';
   grdCombo.Cells[0,0] := 'Комбинаций:';
   grdCombo.Cells[0,wNoGame+1]      := 'Нет игры';
   grdCombo.Cells[0,wAK+1]          := 'Туз-Король';
   grdCombo.Cells[0,wPair+1]        := 'Пара';
   grdCombo.Cells[0,w2Pair+1]       := 'Две пары';
   grdCombo.Cells[0,wTriple+1]      := 'Тройка';
   grdCombo.Cells[0,wStreet+1]      := 'Стрит';
   grdCombo.Cells[0,wFlash+1]       := 'Флеш';
   grdCombo.Cells[0,wFullHouse+1]   := 'Фул Хаус';
   grdCombo.Cells[0,wCare+1]        := 'Каре';
   grdCombo.Cells[0,wStreetFlash+1] := 'Стрит Флеш';
   grdCombo.Cells[0,wRoyalFlash+1]  := 'Ройял Флеш';
   grdCombo.ColWidths[0] := 90;

   grdMem.Cells[0,0] := 'Прикуп 6-ой';
   grdMem.Cells[0,1] := 'Обмен 5-и';
   grdMem.Cells[0,2] := 'Обмен 4-х';
   grdMem.Cells[0,3] := 'Обмен 3-х';
   grdMem.Cells[0,4] := 'Обмен 2-х';
   grdMem.Cells[0,5] := 'Обмен 1-й';
   grdMem.Cells[0,6] := 'Без обмена';
   grdMem.ColWidths[0] := 85;

   for i:=1 to 6 do exchange[i] := False;

   cmbChange.ItemIndex := 0;
   changePrice := 1;
   playFlag := False;
   CardsInGame := 5;
   minGame := 2;
   closePrice := 2;
   NNN := 500000;
   ClearCards(playWhen);
   playWhen[1] := GetCard(0,c2); playWhen[2] := GetCard(1,c2);
   playFLAG := False;

   if playFlag then chkPlayWhen.Checked := True else chkPlayAlways.Checked := True;
   if minGame = wAK then chkMinTK.Checked := True else chkMin22.Checked := True;
   txtExChange.Text := FloatToStr(changePrice);
   txtNNN.Text := IntToStr(NNN);

   stopFLAG := False;
   calcFLAG := False;
   showStatFLAG := False;

   {$IF demo}
   with Self do Caption := Caption + ' DEMO VERSION!';
   txtNNN.Enabled := False;
   NNN := dfrom;
   {$IFEND}
end;

procedure TfrmMain.FormActivate(Sender: TObject);
var c: Byte;
begin
 
   if playFlag then chkPlayWhen.Checked := True else chkPlayAlways.Checked := True;
   if minGame = wAK then chkMinTK.Checked := True else chkMin22.Checked := True;
   txtExChange.Text := FloatToStr(changePrice);
   txtNNN.Text := IntToStr(NNN);
   c := CardsInPack;
   lblCardsNum.Caption := 'Искл./в колоде: ' + IntToStr(52-c) + '/' + IntToStr(c);
   grdExCards.Repaint;
   //cmbChangeChange(self);

   {$IF demo}
   Randomize; txtNNN.Text:=IntToStr(RandomRange(dfrom,dto));
   {$IFEND}

   if _AUTOMATE then begin
      btnStart.Click;
      Timer.Interval := 100;
   end;
end;


{ ***************************************************** PlayCards KEY DOWN ***** }
procedure TfrmMain.grdPlayCardsKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  var c: Byte;
begin
   if Key = VK_DELETE then begin
      packCards[playCards[grdPlayCards.Col+1,grdPlayCards.Row+1]] := True;
      playCards[grdPlayCards.Col+1,grdPlayCards.Row+1] := NOCARD;
      exchange[grdPlayCards.Col+1] := False;
      c := CardsInPack;
      lblCardsNum.Caption := 'Искл./в колоде: ' + IntToStr(52-c) + '/' + IntToStr(c);
      grdPlayCards.Repaint;
      grdExCards.Repaint;
   end;
end;

{ ***************************************************** PlayCards Key Press ***** }
procedure TfrmMain.grdPlayCardsKeyPress(Sender: TObject; var Key: Char);
var mast, cost, i, j: Shortint;
    mastExist: array[0..3] of Boolean;
    allMastExistFLAG: Boolean;
begin
   if (grdPlayCards.Col=5) and (grdPlayCards.Row=0) then Exit;

   if Key = ' ' then exit;
   mast := 0; cost := NOCARD;
   if playCards[grdPlayCards.Col+1,grdPlayCards.Row+1] in ISCARD then begin
      mast := GetMast(playCards[grdPlayCards.Col+1,grdPlayCards.Row+1]);
      cost := GetCost(playCards[grdPlayCards.Col+1,grdPlayCards.Row+1]);
   end;
      case Key of
        '2': cost := c2;
        '3': cost := c3;
        '4': cost := c4;
        '5': cost := c5;
        '6': cost := c6;
        '7': cost := c7;
        '8': cost := c8;
        '9': cost := c9;
        '0': cost := c10;
        '/': cost := cJack;
        '*': cost := cQueen;
        '-': cost := cKing;
        '+': cost := cAce;
        '.': if mast < 3 then Inc(mast) else mast := 0;
        ',': if mast < 3 then Inc(mast) else mast := 0;
      end;

      { проверка существования этой карты в других полях }
      for i:=0 to 3 do mastExist[i] := False;
      for j:=1 to 2 do
          for i:=1 to 6 do
              if not (((i-1)=grdPlayCards.Col) and ((j-1)=grdPlayCards.Row)) then
                 if GetCost(playCards[i,j]) = cost then
                    mastExist[GetMast(playCards[i,j])] := True;

      if mastExist[mast] then begin
         allMastExistFLAG := True;
         for i:=0 to 3 do if not mastExist[i] then allMastExistFLAG := False;
         if allMastExistFLAG then
            Exit
         else begin
            i:=mast+1;
            repeat
               if i>3 then i:=0;
               if mastExist[i] then Inc(i) else Break;
            until i=mast;
            mast := i;
         end;
      end;

      packCards[playCards[grdPlayCards.Col+1,grdPlayCards.Row+1]] := True;
      packCards[GetCard(mast, cost)] := False;
      playCards[grdPlayCards.Col+1,grdPlayCards.Row+1] := GetCard(mast, cost);
      i := CardsInPack;
      lblCardsNum.Caption := Concat('Искл./в колоде: ', IntToStr(52-i), '/', IntToStr(i));
      grdPlayCards.Repaint;
      grdExCards.Repaint;
end;

{ ***************************************************** PlayCards DRAW CELL ***** }
procedure TfrmMain.grdPlayCardsDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
  if (ACol=5) and (ARow=0) then begin
     grdPlayCards.Canvas.Brush.Color := RGB(99,99,99);
     grdPlayCards.Canvas.FillRect(Rect);
  end else
     DrawCard(grdPlayCards.Canvas, Rect, playCards[ACol+1, ARow+1], 12,
                                (gdFocused in State), (exchange[Acol+1] and (ARow=1)));
end;


{ ***************************************************** ExCards Draw Cell ***** }
procedure TfrmMain.grdExCardsDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var c: Shortint;
begin
  c := GetCard(ACol, ARow);
  DrawCard(grdExCards.Canvas, Rect, c, 10, False, (not packCards[c]));
end;

{ ***************************************************** ExCards MOUSE DOWN ***** }
procedure TfrmMain.grdExCardsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var c,f,row: Shortint;

   function FirstFreePlace(row: Byte) : Byte;
   var i,m: Byte;
   begin
      FirstFreePlace := 0;
      if row=1 then m:=5 else m:=6;
      for i:=1 to m do
          if not (playCards[i,row] in ISCARD) then begin
             FirstFreePlace := i;
             Exit;
          end;
   end;

   function FirstFreePlaceAlt : Byte;
   var i: Byte;
   begin
      FirstFreePlaceAlt := 0;
      for i:=1 to 5 do
          if not (playWhen[i] in ISCARD) then begin
             FirstFreePlaceAlt := i;
             Exit;
          end;
   end;

begin
   if ssAlt in Shift then begin
      f := FirstFreePlaceAlt();
      if f <> 0 then begin
         playWhen[f] := GetCard(f mod 4,grdExCards.Row);
         grdPlayWhen.Repaint;
         Exit;
      end;
   end;

   c := GetCard(grdExCards.Col, grdExCards.Row);
   if InPlayCards(c) then Exit;

   row := 0;
   if ssShift in Shift then row := 1; if ssCtrl in Shift then row := 2;
   if row <> 0 then begin
      f := FirstFreePlace(row);
      if f <> 0 then begin
         if (row=2) and (f=6) and not chk6Cards.Checked then Exit;
         playCards[f,row] := c;
         packCards[c] := False;
      end;
   end else begin
      packCards[c] := not packCards[c];
   end;


   c := CardsInPack;
   lblCardsNum.Caption := 'Искл./в колоде: ' + IntToStr(52-c) + '/' + IntToStr(c);
   grdExCards.Repaint;
   grdPlayCards.Repaint;
end;





{ ------------------------- Начало расчета ----------------------------------------- }
{ ***************************************************** PlayCards DOUBLE CLICK ***** }
procedure TfrmMain.grdPlayCardsDblClick(Sender: TObject);
var i,j, step: Longint;
    nPlayer,nDealer, playerComb, dealerComb: Byte;
    dealerCombos, playerCombos: array [wNoGame..wAKplus] of Longint;
    money, conmoney: Double;
    t,curT: TDateTime;
    exchangeN: Byte;


    russian: russianCombo;
    cmbFlag: Boolean;


    costs: costArray;


    procedure Init;                                                 { Initialize }
    var i: Byte;
    begin
       nPlayer := 0; nDealer := 0;
       for i:=wNoGame to wAKplus do begin// инициализация
           dealerCombos[i] := 0; playerCombos[i] := 0;
       end;
       exchangeN := 0;
       for i:=1 to 6 do
           if exchange[i] then Inc(exchangeN);

       ClearCards(player); ClearCards(dealer);
       for i:=1 to CardsInGame do begin
           player[i] := playCards[i, 2]; // инициализация карт игрока
           dealer[i] := playCards[i, 1]; // инициализации карт дилера
           if player[i] in ISCARD then nPlayer := i;
           if dealer[i] in ISCARD then nDealer := i;
       end;
    end;

    procedure GetCardsFromPack;                            { Get Cards From Pack }
    var i: Byte;
    begin // взять недостающие карты из колоды
       for i:=nPlayer+1 to CardsInGame do {взять карты игроку}
           player[i] := RandomFromPack();
       for i:=nDealer+1 to 5 do           {взять карты дилеру}
           dealer[i] := RandomFromPack();
       for i:=1 to nPlayer do
           if exchange[i] then
              player[i] := RandomFromPack();
    end;

    procedure BackCardsToPack;                              { Back Cards To Pack }
    var i: Byte;
    begin {вернуть карты в колоду для следующего эксперимента}
       for i:=nPlayer+1 to CardsInGame do
           BackToPack(player[i]);
       for i:=nDealer+1 to 5 do
           BackToPack(dealer[i]);
       for i:=1 to nPlayer do
           if exchange[i] then
              BackToPack(player[i]);
    end;

    { Заключительный показ статистики                             Show Statistic }
    procedure ShowStatistic(num: Longint);
    var i: Byte;
    begin
       for i:=1 to grdCombo.RowCount-1 do begin
           grdCombo.Cells[1,i] := IntToStr(dealerCombos[i-1]);
           grdCombo.Cells[2,i] := Format('%2.1f', [dealerCombos[i-1]/num*100]);
           grdCombo.Cells[3,i] := IntToStr(playerCombos[i-1]);
           grdCombo.Cells[4,i] := Format('%2.1f', [playerCombos[i-1]/num*100]);
       end;

       lblExCount.Caption := IntToStr(num);
       lblWinsValue.Caption := FloatToStr(money);
       if money>0 then lblWinsValue.Font.Color := RGB(0,0,255)
       else if money<0 then lblWinsValue.Font.Color := RGB(255,0,0)
       else lblWinsValue.Font.Color := RGB(0,0,0);
       lblAnteValue.Caption := Format('%8.3f', [money/num]);
    end;

    { Определяет кто победитель                                    Who Is Winner
      -1   Дилер
       0   Ничья
       1   Игрок                }
    function WhoIsWinner(playerComb, dealerComb : Byte) : Shortint;
    begin
       result := Sign(playerComb - dealerComb);
       if result = 0 then begin { player и dealer - с другого "уровня" :) }
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


begin
   {Init;
   ShowMessage(IntToStr(Optimization.Combination(player)));
   Exit;}


   NormalizePlayCards;
   grdPlayCards.Repaint;

   {$IF demo}
   if NNN>77 then NNN:=dto;
   {$IFEND}

   Randomize; money := 0;
   t := Now(); ProgressBar.Max := NNN; step := 1000;

   Init;

   { цикл экспериментов }
   calcFLAG := True; btnStart.Caption := 'Остановить';
try
   for i:=1 to NNN do begin

       {*** ОТОБРАЖЕНИЕ ПРОГРЕСС-БАРА ***}
       if i mod step = 0 then begin
          if stopFLAG then begin
             stopFLAG := False;
             Break;
          end;
          if showStatFLAG then begin
             ShowStatistic(i);
             showStatFLAG := False;
          end;
          ProgressBar.Position := i;
          lblExCount.Caption := IntToStr(i);
          curT := Now()-t;
          lblTime.Caption := 'Осталось: ' + FormatDateTime('h:n:s', curT * ProgressBar.Max / i - curT) + ' (ч:м:с)';
          Application.ProcessMessages;
       end;


       GetCardsFromPack; { добрать карты из колоды }


       conmoney := 0;

       {*** ОПРЕДЕЛЕНИЕ КОМБИНАЦИЙ *** OPTIMIZED!!!}
       dealerComb := simpleCombination(dealer,costs); // комбинация дилера

       if chkRussian.Checked then
          russian := russianCombination(player) // комбинация Р.П.
       else begin
          if CardsInGame = 6 then
             playerComb := simple6Combination(player,costs) // выбрать лучшую
          else
             playerComb := simpleCombination(player,costs); // комбинация игрока
       end;

       {*** ПОДСЧЕТ СТАТИСТИКИ ***}
       Inc(dealerCombos[dealerComb]);

       if chkRussian.Checked then begin
          cmbFlag := False;
          for j:=wAK to wAKplus do
              if russian[j]>0 then begin
                 playerCombos[j] := playerCombos[j]+russian[j];
                 cmbFlag := True;
              end;
          if not cmbFlag then Inc(playerCombos[wNoGame]);
       end else
          Inc(playerCombos[playerComb]);

       { ВЫЧЕСТЬ СТОИМОСТЬ ОБМЕНА }
       if ((CardsInGame-nPlayer)>0) or (exchangeN>0) then conmoney := conmoney - changePrice;

       if PlayNow(playerComb,russian) then begin 
          if dealerComb < minGame then begin  // нет игры у дилера
             conmoney := conmoney + StrToInt(grdWins.Cells[1,0]);
          end else begin

              if chkRussian.Checked then begin
                 { РУССКИЙ ПОКЕР }
                 case WhoIsRussianWinner(dealerComb, russian) of
                      1: { Player win}
                         for j:=wAK to wAKplus do
                             if russian[j]>0 then
                                conmoney := conmoney + StrToInt(grdWins.Cells[1,j])*russian[j];
                      0: { Ничья }
                         ;
                     -1: { Dealer win}
                         conmoney := conmoney - (1 + closePrice); // вычесть ставку + закрывание
                 end;
              end else begin
                 { ОБЫЧНЫЙ ПОКЕР }
                 case WhoIsWinner(playerComb, dealerComb) of
                      1: { Player win}
                         conmoney := conmoney + StrToInt(grdWins.Cells[1,playerComb]);
                      0: { Ничья }
                         ;
                     -1: { Dealer win}
                         conmoney := conmoney - (1 + closePrice); // вычесть ставку + закрывание
                 end;
              end;

          end;

       end else conmoney := conmoney - 1; // проиграли ставку

       BackCardsToPack; { вернуть карты в колоду }

       money := money + conmoney;
   end;
finally
   calcFLAG := False; btnStart.Caption := 'Начать';
end;

   {отчитаться}
   ShowStatistic(i-1);

   t := Now()-t;
   lblTime.Caption := 'Расчет длился ' + FormatDateTime('h:n:s.zzz', t) + ' (ч:м:с.мс)';

   grdPlayCards.Repaint;
   grdExCards.Repaint;



end;

{ Определяет закрываться ли при таких картах                        Play Now }
function TfrmMain.PlayNow(playerComb: Byte; russianComb : russianCombo) : boolean;
var sorted, playerSort: cards;
    combWhen: Byte;

    function HaveSingleCard : Boolean;  // возвращает True, если
    var i: Byte;
    begin
       HaveSingleCard := True;
       for i:=1 to 5 do
           if playWhen[i] in ISCARD then
              if ThisCostCount(GetCost(playWhen[i]), player) = 0 then begin
                 HaveSingleCard := False;
                 Exit;
              end;
    end;

    function CheckMinGame(comb: Byte) : Boolean;
    var temp: cards;
    begin
       ClearCards(temp); temp := playWhen;
       ClearCards(playWhen);
       if comb=wAK then begin playWhen[1] := GetCard(0,cAce);
                              playWhen[2] := GetCard(1,cKing);
                              playWhen[3] := GetCard(2,c9);
                        end
                   else begin playWhen[1] := GetCard(0,c3); playWhen[2] := GetCard(1,c3); end;

       result := PlayNow(playerComb, russianComb);
       playWhen := temp;
    end;

begin
   result := True; { Всегда }

   if playFlag then begin
      if chkRussian.Checked then playerComb := combRus2Simple(russianComb);
      combWhen := Combination(playWhen);

      if combWhen < minGame then begin
         if HaveSingleCard then
            result := True
         else
            result := (playerComb > minGame)
                   or((playerComb = minGame) and CheckMinGame(minGame));
      end else begin
         sorted := CostSort(playWhen);
         playerSort := CostSort(player);
         result := (playerComb > combWhen)
                or((playerComb = combWhen) and (MajorCard(playerSort, sorted) <> -1));
      end;
   end;
end;


procedure TfrmMain.chk6CardsClick(Sender: TObject);
var c: Byte;
begin
   if chk6Cards.Checked then begin
      CardsInGame := 6;
      grdPlayCards.Width := 226;
   end else begin
      CardsInGame := 5;
      grdPlayCards.Width := 189;
   end;
   grdPlayCards.ColCount := CardsInGame;
   packCards[playCards[6,1]] := True;
   packCards[playCards[6,1]] := True;
   playCards[6,1] := NOCARD; playCards[6,1] := NOCARD;
   c := CardsInPack;
   lblCardsNum.Caption := 'Искл./в колоде: ' + IntToStr(52-c) + '/' + IntToStr(c);
   UpdateComboChange;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
   if calcFLAG then begin
      btnStartClick(self);
      calcFLAG := False;
      CanClose := False;
   end else
      CanClose := True;
end;

procedure TfrmMain.btnStartClick(Sender: TObject);
begin
   if calcFLAG then
      stopFLAG := True
   else
      grdPlayCardsDblClick(self);
end;

procedure TfrmMain.chkMin22Click(Sender: TObject);
begin minGame := 2; end;
procedure TfrmMain.chkMinTKClick(Sender: TObject);
begin minGame := 1; end;

procedure TfrmMain.txtNNNChange(Sender: TObject);
var i: Byte;
    s: String;
begin
   s := Trim(txtNNN.Text);
   try
      NNN := StrToInt(s);
   except
      for i:=1 to Length(s) do
          if (Ord(s[i]) < Ord('0')) or (Ord(s[i]) > Ord('9')) then begin
             s := Copy(s, 0, i-1);
             Break;
          end;
      NNN := StrToInt(s);
   end;
   txtNNN.Text := s;
end;

procedure TfrmMain.txtExChangeChange(Sender: TObject);
var i: Byte;
    s: String;
begin
   s := Trim(txtExChange.Text);
   try
      changePrice := StrToFloat(s);
   except
      for i:=1 to Length(s) do
          if not (s[i] in [',', '.', '0'..'9']) then begin
             s := Copy(s, 0, i-1);
             Break;
          end;
      changePrice := StrToFloat(s);
   end;
   txtExChange.Text := s;
end;

procedure TfrmMain.btnClearClick(Sender: TObject);
var i,j: Byte;
begin
   for i:=0 to 51 do
       packCards[i] := True;
   for i:=1 to 6 do begin
       exchange[i] := False;
       for j:=1 to 2 do
           playCards[i,j] := NOCARD;
   end;
   ClearCards(playWhen); playWhen[1] := GetCard(0,c2); playWhen[2] := GetCard(0,c2);
   i := CardsInPack;
   lblCardsNum.Caption := 'Искл./в колоде: ' + IntToStr(52-i) + '/' + IntToStr(i);
   grdPlayCards.Repaint;
   grdExCards.Repaint;
   grdPlayWhen.Repaint;
end;

{ Возвращает True, если карта есть в playCards }
function TfrmMain.InPlayCards(c: Shortint) : Boolean;
var row,col: Byte;
begin
   InPlayCards := False;
   for row:=1 to 2 do
       for col:=1 to 6 do
           if playCards[col,row] = c then begin
              InPlayCards := True;
              Exit;
           end;
end;

{ Уплотняет влево playCards & playWhen }
procedure TfrmMain.NormalizePlayCards;
var r,c,i: Byte;
begin
   for r:=1 to 2 do begin
       i := 1;
       for c:=1 to 6 do
           if playCards[c,r] in ISCARD then begin
              playCards[i,r] := playCards[c,r];
              if i<>c then playCards[c,r] := NOCARD;
              Inc(i);
           end;
   end;
   i := 1;
   for c:=1 to 5 do
       if playWhen[c] in ISCARD then begin
          playWhen[i] := playWhen[c];
          if i<>c then playWhen[c] := NOCARD;
          Inc(i);
       end;
end;

procedure TfrmMain.N1Click(Sender: TObject);
var r,c: Byte;
begin
   for r:=0 to 6 do
       for c:=1 to 4 do
           grdMem.Cells[c,r] := '';
end;

procedure TfrmMain.grdMemDblClick(Sender: TObject);
begin
   try
   with grdMem do
        if calcFLAG then
           Cells[Col, Row] := lblAnteValue.Caption
        else
           Cells[Col, Row] :=
                      Format('%8.3f', [StrToFloat(lblWinsValue.Caption)/StrToInt(lblExCount.Caption)]);
   except
        ;
   end;
end;

procedure TfrmMain.chkPlayWhenClick(Sender: TObject);
begin playFlag := chkPlayWhen.Checked; end;

procedure TfrmMain.grdPlayWhenDrawCell(Sender: TObject; ACol, ARow: Integer;
                                               Rect: TRect; State: TGridDrawState);
begin
  DrawCard(grdPlayWhen.Canvas, Rect,
           GetCard(0,GetCost(playWhen[ACol+1])), 12, (gdFocused in State), False, False, False);
end;

procedure TfrmMain.grdPlayWhenKeyPress(Sender: TObject; var Key: Char);
var cost: Shortint;
begin
   cost := NOCARD;
   case Key of
        '2': cost := c2;
        '3': cost := c3;
        '4': cost := c4;
        '5': cost := c5;
        '6': cost := c6;
        '7': cost := c7;
        '8': cost := c8;
        '9': cost := c9;
        '0': cost := c10;
        '/': cost := cJack;
        '*': cost := cQueen;
        '-': cost := cKing;
        '+': cost := cAce;
   end;
   if cost <> NOCARD then begin
      playWhen[grdPlayWhen.Col+1] := GetCard((grdPlayWhen.Col+1) mod 4,cost);
      grdPlayWhen.Repaint;
   end;
end;

procedure TfrmMain.grdPlayWhenKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key=VK_DELETE then begin
      playWhen[grdPlayWhen.Col+1] := NOCARD;
      grdPlayWhen.Repaint;
   end;
end;

procedure TfrmMain.cmbChangeChange(Sender: TObject);
var i: Byte;
begin
   for i:=wNoGame to wRoyalFlash do
       if chkRussian.Checked then
          grdWins.Cells[1,i] := IntToStr(WinCoefRUS[i,cmbChange.ItemIndex])
       else
          grdWins.Cells[1,i] := IntToStr(WinCoef[i,cmbChange.ItemIndex]);

   if cmbChange.ItemIndex > 0 then
      txtExChange.Text := FloatToStr(changePrices[cmbChange.ItemIndex]);
end;

procedure TfrmMain.grdPlayCardsMouseDown(Sender: TObject; Button: TMouseButton;
                                          Shift: TShiftState; X, Y: Integer);
var col,row: Integer;
begin
   grdPlayCards.MouseToCell(x, y, col, row);
   if (Button = mbRight) and (row <> 0) and (playCards[col+1, 2] in ISCARD) then begin
      exchange[col+1] := not exchange[col+1];
      grdPlayCards.Repaint;
      UpdateComboChange;
   end;
end;

procedure TfrmMain.SetComboChange(n: Byte);
begin
   cmbChange.ItemIndex := n;
   cmbChangeChange(self);
end;

procedure TfrmMain.UpdateComboChange;
var i, ch: Byte;
begin
   ch := 0;
   for i:=1 to 5 do if exchange[i] then Inc(ch);
   if ((CardsInGame=6) and (exchange[6] or (playCards[6,2] = NOCARD))) then
      cmbChange.ItemIndex := 6
   else
      cmbChange.ItemIndex := ch;
   cmbChangeChange(self);
end;

procedure TfrmMain.btnBestChangeClick(Sender: TObject);
var i: Byte;
begin
   for i:=1 to 5 do
       if playCards[i, 2] in ISCARD then
          frmBestChange.player[i] := playCards[i, 2]
       else begin
          MessageDlg( 'Установлены не все карты игрока!', mtError, [mbCancel], 0); Exit;
       end;
   if playCards[1, 1] in ISCARD then
      frmBestChange.dealer[1] := playCards[1, 1]
   else begin
      MessageDlg( 'Не установлена первая карта дилера!', mtError, [mbCancel], 0); Exit;
   end;
   frmBestChange.minGame := minGame;
   if chkRussian.Checked then frmBestChange.poker := pokerRussian
                         else frmBestChange.poker := pokerSimple;
   frmBestChange.ClearResults;
   frmBestChange.Show;
   {if frmBestChange.ShowModal = mrOk then
      if frmBestChange.bestRow = 8 then
         exchange[6] := True
      else
         for i:=1 to 5 do
             if frmBestChange.grdResults.Cells[i+1, frmBestChange.bestRow] = 'X' then
                exchange[i] := True;
   grdPlayCards.Repaint;}
end;

procedure TfrmMain.TimerTimer(Sender: TObject);
begin if _AUTOMATE then begin
   ModalResult := mrOk;
   Timer.Interval := 0;
   _AUTOMATE := False;
end;end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (Key=VK_SPACE) and (not frmAnalize.chkDebug.Checked) then begin
      stopFLAG:=True; _AUTOMATE := False; frmAnalize._AUTOSTOP:=True;
   end;
end;

procedure TfrmMain.chkRussianClick(Sender: TObject);
var i: Byte;
begin
   if chkRussian.Checked then begin
      chkMinTK.Checked := True;
      chkMinTK.Enabled := False;
      chkMin22.Enabled := False;
      grdWins.RowCount := grdWins.RowCount+1;
      grdWins.Cells[0,wAKplus] := '+Туз-Король';
      grdWins.Cells[1,wAKplus] := IntToStr(WinCoefRUS[wAKplus,cmbChange.ItemIndex]);
      grdWins.Font.Size := 9;
      grdCombo.RowCount := grdCombo.RowCount+1;
      grdCombo.Cells[0,wAKplus+1] := '+Туз-Король';
      //grdCombo.Font.Size := 9;
      for i:=wNoGame to wAKplus do begin
          grdWins.RowHeights[i] := 18;
          grdCombo.RowHeights[i+1] := 20;
      end;
   end else begin
      chkMin22.Checked := True;
      chkMinTK.Enabled := True;
      chkMin22.Enabled := True;
      grdWins.RowCount := grdWins.RowCount-1;
      grdWins.Font.Size := 10;
      grdCombo.RowCount := grdCombo.RowCount-1;
      grdCombo.Font.Size := 10;
      for i:=wNoGame to wRoyalFlash do begin
          grdWins.RowHeights[i] := 20;
          grdCombo.RowHeights[i] := 22;
      end;
   end;
   cmbChangeChange(Self);
end;

end.


