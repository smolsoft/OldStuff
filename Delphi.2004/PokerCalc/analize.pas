unit analize;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, StdCtrls, PokerCards, Math, MainForm, Buttons, ExtCtrls, WinOptionsForm,
  RussianPoker;

type
  GameParam = record
      startDate: TDateTime;
      name: string;
      filename: string;
      razdach: Longint;
      boxes: Byte;
      poker: Byte;
      minGame: Byte;
      buy: Byte;
   end;



  TfrmAnalize = class(TForm)
    grdDealerCards: TDrawGrid;
    grdChangesPrice: TStringGrid;
    grpMinGame: TGroupBox;
    chkMin22: TRadioButton; chkMinTK: TRadioButton;
    chk2box: TCheckBox;
    grpBuyDealerGame: TGroupBox;
    chkBuyNo: TRadioButton; chkBuyHi: TRadioButton; chkBuyLow: TRadioButton;
    lblChangesPrice: TLabel;
    grdBox2: TDrawGrid; grdBox1: TDrawGrid;
    lblDealer: TLabel;
    lblBox1: TLabel;
    lblChange1: TLabel;        lblPlay1: TLabel;
    chkChange1N: TSpeedButton; chkPlay1N: TSpeedButton;
    chkChange1Y: TSpeedButton; chkPlay1Y: TSpeedButton;
    lblBox2: TLabel;
    lblChange2: TLabel;        lblPlay2: TLabel;
    chkChange2N: TSpeedButton; chkPlay2N: TSpeedButton;
    chkChange2Y: TSpeedButton; chkPlay2Y: TSpeedButton;
    grdStatistic: TStringGrid;
    lblStatistic: TLabel;
    lblSettings: TLabel;
    btnWinsOptions: TButton;
    txtSum: TEdit;
    btnSavedGames: TButton;
    btnNewGame: TButton;
    Bevel1: TBevel; Bevel2: TBevel; Bevel3: TBevel;
    btnRazdat: TButton;
    btnAnalize: TButton;
     lblRazdach: TLabel;
    lblSum: TLabel;
    chkAnte2Y: TSpeedButton;
    lblAnte2: TLabel;
    chkAnte2N: TSpeedButton;
    chkAnte1Y: TSpeedButton;
    lblAnte1: TLabel;
    chkAnte1N: TSpeedButton;
    btnBestChange: TBitBtn;
    btnBestBuy: TBitBtn;
    btnAuto: TBitBtn;
    chkDebug: TCheckBox;
    btnEndGame: TButton;
    lblDemo: TLabel;
    lblGameName: TLabel;
    lblWarning: TLabel;
    chkRussian: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btnAnalizeClick(Sender: TObject);
    procedure btnWinsOptionsClick(Sender: TObject);
    procedure chk2boxClick(Sender: TObject);
    procedure btnNewGameClick(Sender: TObject);
    procedure grdDealerCardsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure grdBox2DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure grdBox1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btnRazdatClick(Sender: TObject);
    procedure grdBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chkPlay1Click(Sender: TObject);
    procedure chkPlay2Click(Sender: TObject);
    procedure chkChange1Click(Sender: TObject);
    procedure chkChange2Click(Sender: TObject);
    procedure grdBox2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure chkMin22Click(Sender: TObject);
    procedure chkMinTKClick(Sender: TObject);
    procedure chkBuyNoClick(Sender: TObject);
    procedure chkBuyHiClick(Sender: TObject);
    procedure chkBuyLowClick(Sender: TObject);
    procedure chkAnte1Click(Sender: TObject);
    procedure chkAnte2Click(Sender: TObject);
    procedure grdStatisticDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btnSavedGamesClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure grdChangesPriceSetEditText(Sender: TObject; ACol,
      ARow: Integer; const Value: String);
    procedure grdChangesPriceKeyPress(Sender: TObject; var Key: Char);
    procedure btnBestChangeClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnBestBuyClick(Sender: TObject);
    procedure btnAutoClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnEndGameClick(Sender: TObject);
    procedure chkRussianClick(Sender: TObject);
  private
    { Private declarations }
    gameover: Boolean;
    procedure EnableOptions(value: Boolean);
    procedure OptionsInit;
    procedure OptionsShow;

    procedure SaveGame;
    procedure LoadGame(gamekey: string);
    function GetFreeKeyName : string;
    function SavedGamesCount : Integer;
    procedure AutoLoad;
    procedure EndGame;

    procedure Change1Finish;
    procedure Change2Finish;
    procedure Box1Finish;
    procedure Box2Finish;
    procedure BoxsFinish;
    procedure Ante1Finish;
    procedure Ante2Finish;
    procedure GameFinish;
    procedure PrepareNextGame;

    procedure AutoStep1Razdat;
    procedure AutoStep2BestChange1;
    procedure AutoStep3Analize1;
    procedure AutoStep4BestChange2;
    procedure AutoStep5Analize2;
    procedure AutoStep6BestBuy;
  public
    { Public declarations }
    game: GameParam;
    dealer, box1, box2: cards;
    exchange1,exchange2: cards;

    gameSaved: Boolean;

    _AUTOSTEP: Byte;
    _AUTOSTOP: Boolean;
  end;

var
  frmAnalize: TfrmAnalize;

implementation

uses NewGameForm, DrawCards, Registry, SavedGamesForm, BestChangesForm, Optimization, BestChange,
  BestBuyForm;

{$R *.dfm}

procedure TfrmAnalize.FormCreate(Sender: TObject);
var i,j: Byte;
    {$IF deadline}
    d: TDateTime;
    reg: TRegistry;
    p: ^Double;
const a1=9; a2=5; a3=11;
    {$IFEND}
begin
   gameOver := False;
   {$IF deadline}
   reg := TRegistry.Create;
   try
      reg.OpenKey('Software\VirtualPokerAnalizer', True);
      try d := reg.ReadDateTime('version'); except d := Now; end;
      Randomize;
      if (d>Now) or (d>EncodeDate((1 shl 11)-43,a1,Random(a3)+5)) then Exit;
      reg.WriteDateTime('version', Now);
      reg.CloseKey;
   finally
      reg.Free;
   end;
   {$IFEND}
   InitPack;
   grdChangesPrice.Cells[0,0] := 'За одну';    grdChangesPrice.Cells[1,0] := '1';
   grdChangesPrice.Cells[0,1] := 'За две';     grdChangesPrice.Cells[1,1] := '1';
   grdChangesPrice.Cells[0,2] := 'За три';     grdChangesPrice.Cells[1,2] := '1';
   grdChangesPrice.Cells[0,3] := 'За четыре';  grdChangesPrice.Cells[1,3] := '1';
   grdChangesPrice.Cells[0,4] := 'За пять';    grdChangesPrice.Cells[1,4] := '1';
   grdChangesPrice.Cells[0,5] := 'Прикуп 6-й'; grdChangesPrice.Cells[1,5] := '1';
   grdChangesPrice.ColWidths[0] := 80;

   grdStatistic.Cells[1,0] := 'Дилер';
   grdStatistic.Cells[2,0] := 'Бокс 2'; grdStatistic.Cells[3,0] := 'Бокс 1';
   grdStatistic.Cells[0,0] := 'Комбинаций:';
   grdStatistic.Cells[0,wNoGame+1]      := 'Нет игры';
   grdStatistic.Cells[0,wAK+1]          := 'Туз-Король';
   grdStatistic.Cells[0,wPair+1]        := 'Пара';
   grdStatistic.Cells[0,w2Pair+1]       := 'Две пары';
   grdStatistic.Cells[0,wTriple+1]      := 'Тройка';
   grdStatistic.Cells[0,wStreet+1]      := 'Стрит';
   grdStatistic.Cells[0,wFlash+1]       := 'Флеш';
   grdStatistic.Cells[0,wFullHouse+1]   := 'Фул Хаус';
   grdStatistic.Cells[0,wCare+1]        := 'Каре';
   grdStatistic.Cells[0,wStreetFlash+1] := 'Стрит Флеш';
   grdStatistic.Cells[0,wRoyalFlash+1]  := 'Ройял Флеш';
   grdStatistic.Cells[0,12]  := 'Выигрыш';
   grdStatistic.ColWidths[0] := 90;

   OptionsInit;
   OptionsShow;
   for i:=1 to 6 do begin
       dealer[i]:=NOCARD; box1[i]:=NOCARD; box2[i]:=NOCARD;
       exchange1[i] := NOCARD; exchange2[i] := NOCARD;
       grdChangesPrice.RowHeights[i-1] := 19;
   end;
   gameSaved:=True;

   for i:=1 to 3 do
       for j:=1 to 12 do
           grdStatistic.Cells[i,j] := '0';

   _AUTOSTOP := False; _AUTOSTEP := 1;


   {$IF demo}
       chkDebug.Checked := True;
       lblDemo.Visible := True;
       Self.Caption := Self.Caption + ' DEMO VERSION!';
   {$IFEND}

end;

procedure TfrmAnalize.btnAnalizeClick(Sender: TObject);
var backupCards: pack;

    procedure PrepareCards;
    var i: Byte;
        playerCards: cards;
    begin
      if lblPlay1.Enabled or (not lblBox2.Enabled) then playerCards := box1 else playerCards := box2;
      for i:=1 to 6 do begin
          playCards[i,2] := playerCards[i];
          playCards[i,1] := dealer[i];
          frmMain.exchange[i] := False;
      end;
    end;

    procedure PrepareChanges;
    var i, Nchange: Byte;
        exchange: cards;
    begin
      frmMain.chkRussian.Checked := self.chkRussian.Checked;
      Nchange := 0;
      if lblPlay1.Enabled or (not lblBox2.Enabled) then exchange := exchange1 else exchange := exchange2;
      for i:=1 to 5 do if exchange[i] <> NOCARD then Inc(Nchange);
      if exchange[6] <> NOCARD then Nchange:=6;
      frmMain.SetComboChange(Nchange);
    end;

    procedure PrepareOptions;
    begin with frmMain do begin
       minGame := game.minGame;
       playFlag := False;
       ClearCards(playWhen);
       if minGame = wAK then begin
          playWhen[1] := c2; playWhen[2] := c2;
       end else
          playWhen[1] := dealer[1];
       frmMain.chk6Cards.Checked := playCards[6,2] in ISCARD;
    end; end;

begin
   PrepareCards;
   PrepareChanges;
   PrepareOptions;
   backupCards := packCards;
   frmMain.ShowModal;
   packCards := backupCards;
end;


procedure TfrmAnalize.OptionsInit;
var i: Byte;
begin
   game.boxes := 2;
   game.poker := pokerSimple;
   game.minGame := wPair;
   for i:=1 to 6 do
       changePrices[i] := 1;
   game.buy := buyNo;
end;

procedure TfrmAnalize.OptionsShow;
var i: Byte;
begin
   chk2box.Checked := (game.boxes = 2);
   chkRussian.Checked := (game.poker = pokerRussian);
   chkMin22.Checked := (game.minGame = wPair);
   chkMinTK.Checked := (game.minGame = wAK);
   case game.buy of
        buyNo: chkBuyNo.Checked := True;
        buyLow:chkBuyLow.Checked:= True;
        buyHi: chkBuyHi.Checked := True;
   end;
   for i:=1 to 6 do
       grdChangesPrice.Cells[1, i-1] := FloatToStr(changePrices[i]);
end;

function TfrmAnalize.GetFreeKeyName : string;
var i: Integer;
    reg: TRegistry;
begin
   i := 0;
   reg := TRegistry.Create;
   reg.OpenKey('Software\VirtualPokerAnalizer', True);
   repeat
      Inc(i);
   until not reg.KeyExists('game' + IntToStr(i));
   GetFreeKeyName := 'game' + IntToStr(i);
   reg.Free;
end;

function TfrmAnalize.SavedGamesCount : Integer;
var reg: TRegistry;
    keys: TStrings;
begin
   reg := TRegistry.Create;
   keys := TStringList.Create;
   reg.OpenKey('Software\VirtualPokerAnalizer', False);
   reg.GetKeyNames(keys);
   SavedGamesCount := keys.Count;
end;

procedure TfrmAnalize.SaveGame;
var reg: TRegistry;
    stat: array [1..12, 1..3] of Longint;
    money1, money2: Single;
    i,j: Byte;
begin
   for i:=1 to 3 do
       for j:=1 to grdStatistic.RowCount-2 do
           try stat[j,i] := StrToInt(grdStatistic.Cells[i,j]); except stat[j,i] := 0; end;
   try money2 := StrToFloat(grdStatistic.Cells[2,grdStatistic.RowCount-1]); except money2 := 0; end;
   try money1 := StrToFloat(grdStatistic.Cells[3,grdStatistic.RowCount-1]); except money1 := 0; end;

   reg := TRegistry.Create;
   try
      reg.OpenKey('Software\VirtualPokerAnalizer', True);
      reg.OpenKey(game.filename, True);
      reg.WriteDateTime('start', game.startDate);
      reg.WriteDateTime('saved', Now);
      reg.WriteString('name', game.name);
      reg.WriteInteger('razdach', game.razdach);
      reg.WriteInteger('boxes', game.boxes);
      reg.WriteInteger('poker', game.poker);
      reg.WriteInteger('mingame', game.minGame);
      reg.WriteInteger('buy', game.buy);
      reg.WriteFloat('money1', money1);
      reg.WriteFloat('money2', money2);
      reg.WriteBinaryData('changeprices', changePrices, SizeOf(changePrices));
      reg.WriteBinaryData('wincoef', winCoef, SizeOf(winCoef));
      reg.WriteBinaryData('wincoefrus', winCoefRUS, SizeOf(winCoefRUS));
      reg.WriteBinaryData('statistic', stat, SizeOf(stat));
      reg.CloseKey;
   finally
      reg.Free;
   end;
   gameSaved := True;
end;

procedure TfrmAnalize.LoadGame(gamekey: string);
var reg: TRegistry;
    stat: array [1..12, 1..3] of Longint;
    money1, money2: Single;
    i,j: Byte;
begin
   reg := TRegistry.Create;
   try
      game.filename := gamekey;
      reg.OpenKey('Software\VirtualPokerAnalizer\' + gamekey, False);
      game.startDate := reg.ReadDateTime('start');
      game.name := reg.ReadString('name');
      game.razdach := reg.ReadInteger('razdach');
      game.boxes := reg.ReadInteger('boxes');
      try game.poker := reg.ReadInteger('poker'); except game.poker := pokerSimple; end;
      game.minGame := reg.ReadInteger('mingame');
      game.buy := reg.ReadInteger('buy');
      money1 := reg.ReadFloat('money1');
      money2 := reg.ReadFloat('money2');
      reg.ReadBinaryData('changeprices', changePrices, SizeOf(changePrices));
      reg.ReadBinaryData('wincoef', winCoef, SizeOf(winCoef));
      try
         reg.ReadBinaryData('wincoefrus', winCoefRUS, SizeOf(winCoefRUS));
      except
         winCoefRUS := GetInitialWinCoefsRUS;
      end;
      reg.ReadBinaryData('statistic', stat, SizeOf(stat));
      reg.CloseKey;

      gameSaved := True;
      OptionsShow;
      for i:=1 to 3 do
          for j:=1 to grdStatistic.RowCount-2 do
              grdStatistic.Cells[i,j] := IntToStr(stat[j,i]);
      grdStatistic.Cells[1,grdStatistic.RowCount-1] := FloatToStr(-(money1+money2));
      grdStatistic.Cells[2,grdStatistic.RowCount-1] := FloatToStr(money2);
      grdStatistic.Cells[3,grdStatistic.RowCount-1] := FloatToStr(money1);
      txtSum.Text := FloatToStr(money1+money2);
      lblRazdach.Caption := 'Раздач: ' + IntToStr(game.razdach);

      EnableOptions(False);
      btnNewGame.Visible := False;
      //btnSavedGames.Visible := False;
      lblGameName.Caption := game.name;
      btnEndGame.Visible := True;
      btnEndGame.Enabled := True;
      PrepareNextGame;
   finally
      reg.Free;
   end;
end;

procedure TfrmAnalize.AutoLoad;
var reg: TRegistry;
    keys: TStrings;
    curDate, maxDate: TDateTime;
    key: string;
    i: Integer;
begin
   reg := TRegistry.Create;
   keys := TStringList.Create;
   try
      reg.OpenKey('Software\VirtualPokerAnalizer', True);
      reg.GetKeyNames(keys);
      reg.CloseKey;
      maxDate := 0; key := '';
      for i:=0 to keys.Count-1 do begin
          reg.OpenKey('Software\VirtualPokerAnalizer\' + keys[i], False);
          curDate := reg.ReadDate('saved');
          if curDate > maxDate then begin
             maxDate := curDate; key := keys[i];
          end;
          reg.CloseKey;
      end;
   finally
      reg.Free;
      keys.Free;
   end;
   if key <> '' then LoadGame(key);
end;


procedure TfrmAnalize.btnNewGameClick(Sender: TObject);
begin
   if frmNewGame.ShowModal = mrOK then begin
      btnNewGame.Visible := False;
      game.startDate := Now;
      game.name := frmNewGame.memGameName.Text;
      game.filename := GetFreeKeyName;
      game.razdach := 0;
      EnableOptions(False);
      PrepareNextGame;
      gameSaved := False;
      btnNewGame.Visible := False;
      //btnSavedGames.Visible := False;
      btnEndGame.Visible := True;
      lblGameName.Caption := game.name;
   end;
end;

procedure TfrmAnalize.PrepareNextGame;
var i: Byte;
begin
   for i:=0 to InPack-1 do
       packCards[i] := True;
   for i:=1 to 6 do begin
       dealer[i]:=NOCARD; box1[i]:=NOCARD; box2[i]:=NOCARD;
       exchange1[i] := NOCARD; exchange2[i] := NOCARD;
   end;
   grdDealerCards.Repaint;
   grdBox2.Repaint; grdBox1.Repaint;
   lblPlay1.Enabled := False;
   lblPlay2.Enabled := False;
   chkPlay2N.Down := False;   chkPlay2N.Enabled := False;   chkPlay2N.Visible := True;
   chkPlay2Y.Down := False;   chkPlay2Y.Enabled := False;   chkPlay2Y.Visible := True;
   chkPlay1N.Down := False;   chkPlay1N.Enabled := False;   chkPlay1N.Visible := True;
   chkPlay1Y.Down := False;   chkPlay1Y.Enabled := False;   chkPlay1Y.Visible := True;
   lblChange1.Enabled := False;
   lblChange2.Enabled := False;
   chkChange2N.Down := False; chkChange2N.Enabled := False; chkChange2N.Visible := True;
   chkChange2Y.Down := False; chkChange2Y.Enabled := False; chkChange2Y.Visible := True;
   chkChange1N.Down := False; chkChange1N.Enabled := False; chkChange1N.Visible := True;
   chkChange1Y.Down := False; chkChange1Y.Enabled := False; chkChange1Y.Visible := True;
   lblAnte1.Enabled := False;
   lblAnte2.Enabled := False;
   chkAnte2N.Down := False;   chkAnte2N.Enabled := False;   chkAnte2N.Visible := True;
   chkAnte2Y.Down := False;   chkAnte2Y.Enabled := False;   chkAnte2Y.Visible := True;
   chkAnte1N.Down := False;   chkAnte1N.Enabled := False;   chkAnte1N.Visible := True;
   chkAnte1Y.Down := False;   chkAnte1Y.Enabled := False;   chkAnte1Y.Visible := True;
   grdBox2.Enabled := False;
   grdBox1.Enabled := False;
   btnEndGame.Enabled := False;
   btnRazdat.Enabled := True;
   btnBestBuy.Enabled := False;
   btnAuto.Enabled := True;

   if not demo then
   chkDebug.Enabled := True;
end;

procedure TfrmAnalize.btnRazdatClick(Sender: TObject);
var i: Byte;
begin
   PrepareNextGame;
   chkPlay1N.Enabled := True;
   chkPlay1Y.Enabled := True;
   lblPlay1.Enabled := True;
   grdBox1.Enabled := True;
   btnRazdat.Enabled := False;
   btnSavedGames.Enabled := False;
   btnAuto.Enabled := True;
   btnBestChange.Enabled := True;

   Randomize;
   dealer[1] := RandomFromPack;
   {dealer[1] := c4;
   packcards[c4]:=False;}
   for i:=1 to 5 do
       box1[i] := RandomFromPack;
   {box1[1]:=c5;box1[2]:=c4+cardsInMast;box1[3]:=c3;box1[4]:=c6;box1[5]:=c7;
   packCards[c5]:=False;
   packCards[c4+cardsInMast]:=False;
   packCards[c3]:=False;
   packCards[c6]:=False;
   packCards[c7]:=False;}
   box1 := Sort(box1);
   grdDealerCards.Repaint;
   grdBox1.Repaint;
   _AUTOSTEP := 2;
end;

procedure TfrmAnalize.Change1Finish;
var i: Byte;
    n: Byte;
begin
   n := 0;
   for i:=1 to 5 do if exchange1[i] <> NOCARD then Inc(n);
   if chkChange1Y.Down and ((n>0) and (grdChangesPrice.Cells[1,n-1]='0')) or
      chkChange1Y.Down and ((exchange1[6] <> NOCARD) and (grdChangesPrice.Cells[1,5]='0')) then begin
      chkChange1Y.Down := False;
      Exit;
   end;

   grdBox1.Repaint; lblChange1.Enabled := False;
   if chkChange1Y.Down then begin
      chkChange1Y.Enabled := False; chkChange1N.Visible := False;
      for i:=1 to 6 do
          if exchange1[i] <> NOCARD then
             box1[i] := exchange1[i];
      box1 := Sort(box1);
   end else begin
      chkChange1N.Enabled := False; chkChange1Y.Visible := False;
   end;
   chkPlay1Y.Enabled := True; chkPlay1N.Enabled := True;
   lblPlay1.Enabled := True;
   grdBox1.Repaint;
   _AUTOSTEP := 3;
end;

procedure TfrmAnalize.Change2Finish;
var i,n: Byte;
begin
   n := 0;
   for i:=1 to 5 do if exchange2[i] <> NOCARD then Inc(n);
   if chkChange2Y.Down and ((n>0) and (grdChangesPrice.Cells[1,n-1]='0')) or
      chkChange2Y.Down and ((exchange2[6] <> NOCARD) and (grdChangesPrice.Cells[1,5]='0')) then begin
      chkChange2Y.Down := False;
      Exit;
   end;

   grdBox2.Repaint; lblChange2.Enabled := False;
   if chkChange2Y.Down then begin
      chkChange2Y.Enabled := False; chkChange2N.Visible := False;
      for i:=1 to 6 do
          if exchange2[i] <> NOCARD then box2[i] := exchange2[i];
      box2 := Sort(box2);
   end else begin
      chkChange2N.Enabled := False; chkChange2Y.Visible := False;
   end;
   chkPlay2Y.Enabled := True; chkPlay2N.Enabled := True;
   lblPlay2.Enabled := True;
   grdBox2.Repaint;
   _AUTOSTEP := 5;
end;

procedure TfrmAnalize.Box1Finish;
var i: Byte;
begin
   grdBox1.Repaint;
   lblPlay1.Enabled := False; grdBox1.Enabled := False;
   if chkPlay1Y.Down then begin
      chkPlay1Y.Enabled := False; chkPlay1N.Visible := False;
   end else begin
      chkPlay1N.Enabled := False; chkPlay1Y.Visible := False;
   end;
   chkChange1N.Enabled := False; chkChange1Y.Enabled := False;
   lblChange1.Enabled := False;
   if not chkChange1Y.Down then chkChange1Y.Visible := False;

   if game.boxes = 2 then begin
      _AUTOSTEP := 4;
      chkPlay2N.Enabled := True; chkPlay2Y.Enabled := True;
      lblPlay2.Enabled := True;
      grdBox2.Enabled := True;
      for i:=1 to 5 do
          box2[i] := RandomFromPack;
      box2 := Sort(box2);
      grdBox2.Repaint;
   end else
      BoxsFinish;
end;

procedure TfrmAnalize.Box2Finish;
begin
   grdBox2.Repaint;
   grdBox2.Enabled := False;
   lblPlay2.Enabled := False; grdBox2.Enabled := False;
   if chkPlay2Y.Down then begin
      chkPlay2Y.Enabled := False; chkPlay2N.Visible := False;
   end else begin
      chkPlay2N.Enabled := False; chkPlay2Y.Visible := False;
   end;
   chkChange2N.Enabled := False; chkChange2Y.Enabled := False;
   lblChange2.Enabled := False;
   if not chkChange2Y.Down then chkChange2Y.Visible := False;
   BoxsFinish;
end;

procedure TfrmAnalize.BoxsFinish;
var i: Byte;
begin
   for i:=2 to 5 do
       dealer[i] := RandomFromPack;
   {dealer[2]:=c9;dealer[3]:=cJack;dealer[4]:=cKing+2*cardsInMast;dealer[5]:=c10+cardsInMast;
   //packCards[c8]:=False;
   packCards[c9]:=False;
   packCards[cJack]:=False;
   packCards[cKing+2*cardsInMast]:=False;
   packCards[c10+cardsInMast]:=False;}
   dealer := Sort(dealer);
   grdDealerCards.Repaint;

   if (game.buy <> buyNo) and (Combination(dealer) < game.minGame) then begin
      _AUTOSTEP := 6;
      if chkPlay1Y.Down then begin
         chkAnte1Y.Enabled := True;
         chkAnte1N.Enabled := True;
         lblAnte1.Enabled := True;
      end;
      if chkPlay2Y.Down then begin
         chkAnte2Y.Enabled := True;
         chkAnte2N.Enabled := True;
         lblAnte2.Enabled := True;
      end;
      btnBestBuy.Enabled := True;
   end;
   GameFinish;
end;

procedure TfrmAnalize.Ante1Finish;
begin
   lblAnte1.Enabled := False;
   if chkAnte1Y.Down then begin
      chkAnte1Y.Enabled := False; chkAnte1N.Visible := False;
   end else begin
      chkAnte1N.Enabled := False; chkAnte1Y.Visible := False;
   end;
   if not lblAnte2.Enabled then GameFinish;
end;

procedure TfrmAnalize.Ante2Finish;
begin
   lblAnte2.Enabled := False;
   if chkAnte2Y.Down then begin
      chkAnte2Y.Enabled := False; chkAnte2N.Visible := False;
   end else begin
      chkAnte2N.Enabled := False; chkAnte2Y.Visible := False;
   end;
   if not lblAnte1.Enabled then GameFinish;
end;

procedure TfrmAnalize.GameFinish;
var f1, f2, dealerGameFLAG: Boolean;
    comb1, comb2, combd: Byte;
    comb1rus, comb2rus: russianCombo;
    comb1flag, comb2flag: Boolean;
    card: Byte;
    money1, money2: Single;
    Nchange1, Nchange2: Byte;

    procedure ProcessChanges;
    var i: Byte;
    begin
      Nchange1 := 0; Nchange2 := 0;
      for i:=1 to 5 do begin
          if exchange1[i] <> NOCARD then Inc(Nchange1);
          if exchange2[i] <> NOCARD then Inc(Nchange2);
      end;
      if chkChange1Y.Down and (Nchange1>0) then
         money1 := money1 - StrToFloat(grdChangesPrice.Cells[1, Nchange1-1]);
      if chkChange2Y.Down and (Nchange2>0) then
         money2 := money2 - StrToFloat(grdChangesPrice.Cells[1, Nchange2-1]);
      if exchange1[6] <> NOCARD then money1 := money1 - StrToFloat(grdChangesPrice.Cells[1, 5]);
      if exchange2[6] <> NOCARD then money2 := money2 - StrToFloat(grdChangesPrice.Cells[1, 5]);
    end;

    { Определяет кто победитель                                    Who Is Winner
      -1   Дилер
       0   Ничья
       1   Игрок                }
    function WhoIsWinner(player, dealer : cards) : Shortint;
    var playerComb, dealerComb: Byte;
    begin
       playerComb := Optimization.Combination(player);
       dealerComb := Optimization.Combination(dealer);
       result := Sign(playerComb - dealerComb);
       if result = 0 then begin
          result := MajorComb(player, dealer, playerComb);
       end;
    end;

    function WhoIsRussianWinner(dealerComb: Byte; rus: russianCombo; box: cards) : Shortint;
    var i: Byte;
    begin
       result := -1;
       // поиск наличия комбинации старшей чем у дилера
       for i:=dealerComb+1 to wRoyalFlash do
           if rus[i]>0 then begin result := 1; Exit; end;
       // если есть равная комбинация
       if rus[dealerComb]>0 then
          result := MajorComb(box, dealer, dealerComb);
    end;


    procedure UpdateStatistic;
    var i,moneyRow: Byte;
    begin
       with grdStatistic do begin
            Cells[1, combd+1] := IntToStr(StrToInt(Cells[1, combd+1])+1);

            if game.poker=pokerRussian then begin
               comb1flag:=False; comb2flag:=false;
               for i:=wAK to wAKplus do begin
                   if lblBox2.Enabled  and (comb2rus[i]>0) then begin
                      Cells[2, i+1] := IntToStr(StrToInt(Cells[2, i+1])+comb2rus[i]);
                      comb2flag := True;
                   end;
                   if comb1rus[i]>0 then begin
                      Cells[3, i+1] := IntToStr(StrToInt(Cells[3, i+1])+comb1rus[i]);
                      comb1flag := True;
                   end;
               end;
               if lblBox2.Enabled and (not comb2flag) then // обраьотка NoGame
                  Cells[2, wNoGame+1] := IntToStr(StrToInt(Cells[2, wNoGame+1])+1);
               if not comb1flag then // обраьотка NoGame
                  Cells[3, wNoGame+1] := IntToStr(StrToInt(Cells[3, wNoGame+1])+1);
            end else begin
               if lblBox2.Enabled then
                  Cells[2, comb2+1] := IntToStr(StrToInt(Cells[2, comb2+1])+1);
               Cells[3, comb1+1] := IntToStr(StrToInt(Cells[3, comb1+1])+1);
            end;

            { обновление денег }
            moneyRow := RowCount-1;
            if lblBox2.Enabled then
               Cells[2, moneyRow] := FloatToStr(StrToFloat(Cells[2, moneyRow])+RoundTo(money2, -1));
            Cells[3, moneyRow] := FloatToStr(StrToFloat(Cells[3, moneyRow])+RoundTo(money1,-2));
            txtSum.Text := FloatToStr(StrToFloat(Cells[2,moneyRow])+StrToFloat(Cells[3,moneyRow]));
            Cells[1,moneyRow] := FloatToStr(-StrToFloat(txtSum.Text));
            Inc(game.razdach);
            lblRazdach.Caption := 'Раздач: ' + IntToStr(game.razdach);
       end;
    end;

    { возвращает True, если после покупки карты дилер стал играть }
    function BuyDealerGame : Boolean;
    var index: Byte;
    begin
       index := 6;
       if not dealerGameFLAG then begin
          case game.buy of
               buyHi:  index := MaxCostIndex(dealer);
               buyLow: index := MinCostIndex(dealer);
          end;
          dealer[index] := RandomFromPack;
          dealerGameFLAG := True;
          grdDealerCards.Repaint;
       end;
       BuyDealerGame := (Combination(dealer) >= game.minGame);
    end;
begin
   card := 6;
   f1 := chkAnte1Y.Down or chkAnte1N.Down or (not chkAnte1N.Enabled);
   f2 := chkAnte2Y.Down or chkAnte2N.Down or (not chkAnte2N.Enabled);
   if f1 and f2 then begin
      btnRazdat.Enabled := True;
      btnSavedGames.Enabled := True;
      {for i:=1 to 6 do begin
          if exchange1[i] <> NOCARD then box1[i] := exchange1[i];
          if exchange2[i] <> NOCARD then box2[i] := exchange2[i];
      end;}

      if game.poker = pokerRussian then begin
         { РУССКИЙ ПОКЕР }
         comb1rus := russianCombination(box1);
         comb2rus := russianCombination(box2);
      end else begin
         { ПРОСТОЙ ПОКЕР }
         if box1[6] = NOCARD then comb1 := Optimization.Combination(box1)
                             else begin
                                  comb1 := Optimization.LookOverCombinations(box1, card);
                                  box1 := SwapCards(box1, card, 6);
                             end;
         if box2[6] = NOCARD then comb2 := Optimization.Combination(box2)
                             else begin
                                  comb2 := Optimization.LookOverCombinations(box2, card);
                                  box2 := SwapCards(box2, card, 6);
                             end;
      end;

      combd := Combination(dealer);

      money1 := 0; money2 := 0; dealerGameFLAG := False;
      ProcessChanges;


      {*** РАЗБОР ПЕРВОГО БОКСА ***}
      if chkPlay1Y.Down then begin
         if combd < game.minGame then begin  // нет игры у дилера
            if chkAnte1N.Down then begin // покупалась игра дилеру
               money1 := money1 - 1; {за покупку}
               if buyDealerGame then // у дилера игра

               if game.poker=pokerRussian then
                  case WhoIsRussianWinner(combd, comb1rus, box1) of
                   1: { Player win }
                      money1 := money1 + russianMoney(comb1rus, Nchange1);
                  -1: { Dealer win }
                      money1 := money1 - (1 + 2); // вычесть (ставку + закрывание)
                  end
               else
                  case WhoIsWinner(box1, dealer) of
                   1: { Player win }
                      money1 := money1 + winCoef[comb1, Nchange1];
                  -1: { Dealer win }
                      money1 := money1 - (1 + 2); // вычесть (ставку + закрывание)
                  end

            end else // игра не покупалась
               money1 := money1 + winCoef[wNoGame, Nchange1];
         end else
             { есть игра у дилера }
             if game.poker=pokerRussian then
                  case WhoIsRussianWinner(combd, comb1rus, box1) of
                     1: { Player win }
                        money1 := money1 + russianMoney(comb1rus, Nchange1);
                     0: { Ничья }
                        ;
                    -1: { Dealer win }
                        money1 := money1 - (1 + 2); // вычесть (ставку + закрывание)
                  end
             else
                case WhoIsWinner(box1, dealer) of
                     1: { Player win }
                        money1 := money1 + winCoef[comb1, Nchange1];
                     0: { Ничья }
                        ;
                    -1: { Dealer win }
                        money1 := money1 - (1 + 2); // вычесть (ставку + закрывание)
                end;

      end else money1 := money1 - 1; // проиграли ставку


      {*** РАЗБОР ВТОРОГО БОКСА ***}
      if chkPlay2Y.Down then begin
         if combd < game.minGame then begin  // нет игры у дилера
            if chkAnte2N.Down then begin// покупалась игра дилеру
               money2 := money2 - 1; {за покупку}
               if buyDealerGame then // у дилера игра

               if game.poker=pokerRussian then
                  case WhoIsRussianWinner(combd, comb2rus, box2) of
                   1: { Player win }
                      money2 := money2 + russianMoney(comb2rus, Nchange2);
                  -1: { Dealer win }
                      money2 := money2 - (1 + 2); // вычесть (ставку + закрывание)
                  end
               else
                  case WhoIsWinner(box2, dealer) of
                   1: { Player win }
                      money2 := money2 + winCoef[comb2, Nchange2];
                  -1: { Dealer win}
                      money2 := money2 - (1 + 2); // вычесть (ставку + закрывание)
                  end

            end else // игра не покупалась
               money2 := money2 + winCoef[wNoGame, Nchange2];
         end else

             if game.poker=pokerRussian then
                case WhoIsRussianWinner(combd, comb2rus, box2) of
                     1: { Player win }
                        money2 := money2 + russianMoney(comb2rus, Nchange2);
                     0: { Ничья }
                        ;
                    -1: { Dealer win }
                        money2 := money2 - (1 + 2); // вычесть (ставку + закрывание)
                  end
             else
                case WhoIsWinner(box2, dealer) of
                     1: { Player win}
                        money2 := money2 + winCoef[comb2, Nchange2];
                     0: { Ничья }
                        ;
                    -1: { Dealer win}
                        money2 := money2 - (1 + 2); // вычесть (ставку + закрывание)
                end;

      end else money2 := money2 - 1; // проиграли ставку

      UpdateStatistic;
      gameSaved := False;
      btnEndGame.Enabled := True;
      _AUTOSTEP := 1;
   end;
end;

(*****************************************************************/

             И Н Т Е Р Ф Е Й С Н А Я     Ч А С Т Ь

/*******************************************************************)

procedure TfrmAnalize.grdDealerCardsDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
   DrawCard(grdDealerCards.Canvas, Rect, dealer[ACol+1], 16);
end;

procedure TfrmAnalize.grdBox2DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var cross, grey: Boolean;
    card: Shortint;
begin
   cross := (exchange2[ACol+1] in ISCARD) and (not chkChange2Y.Down) and (not chkChange2N.Down);
   grey := chkPlay2N.Down;
   card := box2[ACol+1];
   DrawCard(grdBox2.Canvas, Rect, card, 16, (gdFocused in State), cross, grey);
end;

procedure TfrmAnalize.grdBox1DrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
var cross, grey: Boolean;
    card: Shortint;
begin
   cross := (exchange1[ACol+1] in ISCARD) and (not chkChange1Y.Down) and (not chkChange1N.Down);
   grey := chkPlay1N.Down;
   card := box1[ACol+1];
   DrawCard(grdBox1.Canvas, Rect, card, 16, (gdFocused in State), cross, grey);
end;

procedure TfrmAnalize.grdBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var c,r,i: Integer;
    exchangeFlag: Boolean;
begin
   if not (chkChange1Y.Visible and chkChange1N.Visible) then Exit;
   exchangeFlag := False;
   for i:=1 to 6 do
       if (exchange1[i] in ISCARD) then exchangeFlag := True;

   grdBox1.MouseToCell(x, y, c, r);
   if ((c<5) and (exchange1[6] <>NOCARD)) or
      ((c=5) and (exchange1[6] = NOCARD) and exchangeFlag) then Exit;


   grdBox1.Col := c; grdBox1.Row := r;
   if button = mbRight then begin
      if exchange1[c+1] = NOCARD then begin
         exchange1[c+1] := RandomFromPack;
         exchangeFlag := True;
      end else begin
         BackToPack(exchange1[c+1]);
         exchange1[c+1] := NOCARD;
         exchangeFlag := False;
         for i:=1 to 6 do
             if (exchange1[i] in ISCARD) then exchangeFlag := True;
      end;
      grdBox1.Repaint;
   end;
   chkChange1N.Enabled := exchangeFlag; chkChange1Y.Enabled := exchangeFlag;
   lblChange1.Enabled := exchangeFlag;
   chkPlay1Y.Enabled:=not exchangeFlag; chkPlay1N.Enabled:=not exchangeFlag;
   lblPlay1.Enabled := not exchangeFlag;
end;

procedure TfrmAnalize.grdBox2MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var c,r,i: Integer;
    exchangeFlag: Boolean;
begin
   if not (chkChange2Y.Visible and chkChange2N.Visible) then Exit;
   exchangeFlag := False;
   for i:=1 to 6 do
       if (exchange2[i] in ISCARD) then exchangeFlag := True;

   grdBox2.MouseToCell(x, y, c, r);
   if ((c<5) and (exchange2[6] <>NOCARD)) or
      ((c=5) and (exchange2[6] = NOCARD) and exchangeFlag) then Exit;

   grdBox2.Col := c; grdBox2.Row := r;
   if button = mbRight then begin
      if exchange2[grdBox2.Col+1] = NOCARD then begin
         exchange2[grdBox2.Col+1] := RandomFromPack;
         exchangeFlag := True;
      end else begin
         BackToPack(exchange2[grdBox2.Col+1]);
         exchange2[grdBox2.Col+1] := NOCARD;
         exchangeFlag := False;
         for i:=1 to 6 do
             if (exchange2[i] in ISCARD) then exchangeFlag := True;
      end;
      grdBox2.Repaint;
   end;
   chkChange2N.Enabled := exchangeFlag; chkChange2Y.Enabled := exchangeFlag;
   lblChange2.Enabled := exchangeFlag;
   chkPlay2Y.Enabled:=not exchangeFlag; chkPlay2N.Enabled:=not exchangeFlag;
   lblPlay2.Enabled := not exchangeFlag;
end;


procedure TfrmAnalize.chkChange1Click(Sender: TObject);
begin Change1Finish; end;
procedure TfrmAnalize.chkChange2Click(Sender: TObject);
begin Change2Finish; end;

procedure TfrmAnalize.chkPlay1Click(Sender: TObject);
begin Box1Finish; end;
procedure TfrmAnalize.chkPlay2Click(Sender: TObject);
begin Box2Finish; end;

procedure TfrmAnalize.chkAnte1Click(Sender: TObject);
begin Ante1Finish; end;
procedure TfrmAnalize.chkAnte2Click(Sender: TObject);
begin Ante2Finish; end;

{ options proc }
procedure TfrmAnalize.chk2boxClick(Sender: TObject);
var value: Boolean;
begin
   value := chk2box.Checked;
   if value then game.boxes := 2 else game.boxes := 1;
   lblBox2.Enabled := value;
end;

procedure TfrmAnalize.EnableOptions(value: Boolean);
begin
   chk2box.Enabled := value;
   chkRussian.Enabled := value;
   grdChangesPrice.Enabled := value;
   frmWinOptions.grdWins.Enabled := value;
   grpMinGame.Enabled := value;
   chkMin22.Enabled := value;
   chkMinTK.Enabled := value;
   grpBuyDealerGame.Enabled := value;
   chkBuyNo.Enabled := value;
   chkBuyLow.Enabled := value;
   chkBuyHi.Enabled := value;
end;

procedure TfrmAnalize.chkRussianClick(Sender: TObject);
var i: Byte;
begin
     if chkRussian.Checked then begin
        game.poker:=pokerRussian;
        game.buy := buyHi;
             chkBuyHi.Checked:=True;
             chkBuyNo.Enabled:=False;
             chkBuyHi.Enabled:=False;
             chkBuyLow.Enabled:=False;
        game.minGame := wAK;
             chkMinTK.Checked:=True;
             chkMin22.Enabled:=False;
             chkMinTK.Enabled:=False;
        grdStatistic.RowCount := grdStatistic.RowCount+1;
        for i:=0 to 3 do
            grdStatistic.Cells[i,13] := grdStatistic.Cells[i,12];
        grdStatistic.Cells[0,12] := '+Туз-Король';
        grdStatistic.RowHeights[0]:=24;
        for i:=1 to grdStatistic.rowcount-1 do
            grdStatistic.RowHeights[i]:=18;
     end else begin
        game.poker:=pokerSimple;
        game.buy := buyNo;
             chkBuyNo.Checked:=True;
             chkBuyNo.Enabled:=True;
             chkBuyHi.Enabled:=True;
             chkBuyLow.Enabled:=True;
        game.minGame := wPair;
             chkMin22.Checked:=True;
             chkMin22.Enabled:=True;
             chkMinTK.Enabled:=True;
        grdStatistic.RowCount := grdStatistic.RowCount-1;
        grdStatistic.Cells[0,12] := 'Выигрыш';
        for i:=0 to grdStatistic.rowcount-1 do
            grdStatistic.RowHeights[i]:=20;
     end;
     frmWinOptions.Poker := game.poker;
end;

procedure TfrmAnalize.chkMin22Click(Sender: TObject);
begin game.minGame := wPair; end;
procedure TfrmAnalize.chkMinTKClick(Sender: TObject);
begin game.minGame := wAK; end;

procedure TfrmAnalize.chkBuyNoClick(Sender: TObject);
begin game.buy := buyNo; end;
procedure TfrmAnalize.chkBuyHiClick(Sender: TObject);
begin game.buy := buyHi; end;
procedure TfrmAnalize.chkBuyLowClick(Sender: TObject);
begin game.buy := buyLow; end;

procedure TfrmAnalize.btnWinsOptionsClick(Sender: TObject);
begin frmWinOptions.ShowModal; end;

procedure TfrmAnalize.btnSavedGamesClick(Sender: TObject);
var mbResult: TModalResult;
begin
   if not gameSaved then begin
      mbResult := MessageDlg('Текущая игра не сохранена.'#10#13'Сохранить игру?',
                          mtConfirmation, [mbYes, mbNo, mbCancel], 0);
      if mbResult<>mrCancel then begin
         if mbResult=mrYes then SaveGame;
         EndGame;
      end
   end;
   if frmSavedGames.ShowModal<>mrCancel then LoadGame(frmSavedGames.gamekey);
end;

procedure TfrmAnalize.grdStatisticDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
begin
   {with grdStatistic.Canvas do begin
        Pen.Color := clRed;
        MoveTo(Rect.Left,Rect.Top);
        LineTo(Rect.Right,Rect.Bottom);
   end;}
end;


procedure TfrmAnalize.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var mbResult: Integer;
begin
   CanClose := btnNewGame.Visible or btnRazdat.Enabled;
   if CanClose then begin
      if not gameSaved then begin
         mbResult := MessageDlg('Текущая игра не сохранена.'#10#13'Сохранить игру?',
                             mtConfirmation, [mbYes, mbNo, mbCancel], 0);
         case mbResult of
              mrYes: SaveGame;
           mrCancel: CanClose := False;
         end;
      end;
   end else
      MessageDlg('Закончить игру можно только'#10#13'при завершенной раздаче.', mtError, [mbCancel], 0);
end;

procedure TfrmAnalize.FormActivate(Sender: TObject);
begin btnSavedGames.Enabled := (SavedGamesCount > 0); end;

procedure TfrmAnalize.grdChangesPriceSetEditText(Sender: TObject; ACol,
  ARow: Integer; const Value: String);
begin
   try
      changePrices[ARow+1] := StrToFloat(grdChangesPrice.Cells[ACol, ARow]);
   except
      if grdChangesPrice.Cells[ACol, ARow]<>'' then
         grdChangesPrice.Cells[ACol, ARow] := FloatToStr(changePrices[ARow+1]);
   end;
end;

procedure TfrmAnalize.grdChangesPriceKeyPress(Sender: TObject; var Key: Char);
begin if Key='.' then Key:=','; end;

procedure TfrmAnalize.btnBestChangeClick(Sender: TObject);
begin
   frmBestChange.Left := Self.Left + 292;
   frmBestChange.Top := Self.Top + 192;
   frmBestChange.dealer := dealer;
   if lblPlay1.Enabled or lblChange1.Enabled then frmBestChange.player := box1
                                             else frmBestChange.player := box2;
   frmBestChange.minGame := game.minGame;
   frmBestChange.poker := game.poker;
   frmBestChange.ClearResults;
   frmBestChange.ShowModal;
end;

procedure TfrmAnalize.btnBestBuyClick(Sender: TObject);
var i: Byte;
begin
   frmBestBuy.d := dealer;  
   frmBestBuy.p1:=box1;frmBestBuy.p2:=box2;
   frmBestBuy.change1:=0;frmBestBuy.change2:=0;
   frmBestBuy.poker := game.poker;
   if exchange1[6] <> NOCARD then frmBestBuy.change1:=6;
   if exchange2[6] <> NOCARD then frmBestBuy.change2:=6;
   for i:=1 to 5 do begin
       if exchange1[i] <> NOCARD then Inc(frmBestBuy.change1);
       if exchange2[i] <> NOCARD then Inc(frmBestBuy.change2);
   end;
   frmBestBuy.minGame := game.minGame;
   frmBestBuy.buyWhen := game.buy;
   frmBestBuy.ShowModal;
end;

(*

      if chkPlay1Y.Down then begin
         if combd < game.minGame then begin  // нет игры у дилера
            if chkAnte1N.Down then begin // покупалась игра дилеру
               money1 := money1 - 1; {за покупку}
               if buyDealerGame then // у дилера игра
                  case WhoIsWinner(box1, dealer) of
                   1: { Player win }
                      money1 := money1 + winCoef[comb1, Nchange1];
                  -1: { Dealer win }
                      money1 := money1 - (1 + 2); // вычесть (ставку + закрывание)
                  end
            end else // игра не покупалась
               money1 := money1 + winCoef[wNoGame, Nchange1];
         end else
             case WhoIsWinner(box1, dealer) of
              1: { Player win }
                 money1 := money1 + winCoef[comb1, Nchange1];
              0: { Ничья }
                 ;
             -1: { Dealer win }
                 money1 := money1 - (1 + 2); // вычесть (ставку + закрывание)
             end;
      end else money1 := money1 - 1; // проиграли ставку


      if chkPlay2Y.Down then begin
         if combd < game.minGame then begin  // нет игры у дилера
            if chkAnte2N.Down then begin// покупалась игра дилеру
               money2 := money2 - 1; {за покупку}
               if buyDealerGame then // у дилера игра
                  case WhoIsWinner(box2, dealer) of
                   1: { Player win }
                      money2 := money2 + winCoef[comb2, Nchange2];
                  -1: { Dealer win}
                      money2 := money2 - (1 + 2); // вычесть (ставку + закрывание)
                  end
            end else // игра не покупалась
               money2 := money2 + winCoef[wNoGame, Nchange2];
         end else
             case WhoIsWinner(box2, dealer) of
              1: { Player win}
                 money2 := money2 + winCoef[comb2, Nchange2];
              0: { Ничья }
                 ;
             -1: { Dealer win}
                 money2 := money2 - (1 + 2); // вычесть (ставку + закрывание)
             end;
      end else money2 := money2 - 1; // проиграли ставку


*)


procedure TfrmAnalize.Button1Click(Sender: TObject);
type     optCards= array[1..9] of Shortint;
var dealer, player: array of xcards;
    i,j: Longint;
    t: TDateTime;
    ch: char;
    card,m,c: Byte;
    data: array of optCards;
begin
ShowMessage(FloatToStr(exp(2.3)));
Exit;
   t := Now();
   Randomize;
   SetLength(data,100000);
   for i:=1 to 16 do card := RandomFromPack;
   for i:=1 to 100000 do begin
       for j:=1 to 9 do data[i][j]:= RandomFromPack;
       for j:=1 to 9 do BackToPack(data[i][j]);
   end;

{  ТЕСТ ОПТИМИЗИРОВННОЙ Ф-ИИ Optimization.CombinationX
   SetLength(dealer, 500000);
   SetLength(player, 500000);
   for i:=0 to 499999 do begin
       dealer[i].s := '0000000000000'; player[i].s := '0000000000000';
       for j:=1 to 5 do with dealer[i] do begin
           c[j] := RandomFromPack;
           ch := s[GetCost(c[j])];
           ch := Chr(Ord(ch)+1);
           s[GetCost(c[j])] := ch;
       end;
       for j:=1 to 5 do with player[i] do begin
           c[j] := RandomFromPack; s[GetCost(c[j])] := Chr(Ord(s[GetCost(c[j])])+1);
       end;
       for j:=1 to 5 do BackToPack(dealer[i].c[j]);
       for j:=1 to 5 do BackToPack(player[i].c[j]);
       Application.ProcessMessages;
   end;
   ShowMessage(FormatDateTime('h:n:s.zzz', Now()-t));
   t := Now();
   for i:=0 to 499999 do begin
       dealer[i].comb := Optimization.CombinationX(dealer[i]);
       player[i].comb := Optimization.CombinationX(player[i]);
       Application.ProcessMessages;
   end;
   SetLength(dealer, 0);
   SetLength(player, 0);
}
ShowMessage(FormatDateTime('h:n:s.zzz', Now()-t));
end;



{ ************************************************************************** }
{        А В Т О М А Т И Ч Е С К А Я       И Г Р А
{ ************************************************************************** }

procedure TfrmAnalize.AutoStep1Razdat;
begin btnRazdat.Click; end;

procedure TfrmAnalize.AutoStep2BestChange1;
var bestRow,i: Byte;
    r: TRect;
begin
   frmBestChange._AUTOMATE := True; frmMain._AUTOMATE := True;
   btnBestChange.Click;
   bestRow := frmBestChange.bestRow;
   case bestRow of
        1: begin chkPlay1N.Down:=True; chkPlay1N.Click; end; { не играть}
        2: begin chkPlay1Y.Down:=True; chkPlay1Y.Click; end; { играть }
        8: begin { прикуп шестой }
              r := grdBox1.CellRect(5,0);
              grdBox1MouseDown(Self, mbRight, [], r.Left+1, r.Top+1);
              Inc(_AUTOSTEP);
           end;
        else {обмен карт}
             for i:=2 to 6 do
                 if frmBestChange.grdResults.Cells[i,bestRow]='X' then begin
                    r := grdBox1.CellRect(i-2,0);
                    grdBox1MouseDown(Self, mbRight, [], r.Left+1, r.Top+1);
                 end;
             Inc(_AUTOSTEP);
   end;
end;

procedure TfrmAnalize.AutoStep3Analize1;
var a: Real;
begin
   if chkChange1Y.Enabled then begin
      chkChange1Y.Down:=True; chkChange1Y.Click;
   end;
   btnAnalize.Click;
   try a := StrToFloat(frmMain.lblAnteValue.Caption);
   except MessageDlg('Ошибка в модуле анализа!', mtError, [mbOK], 0); a:=0; end;
   if a > -1 then begin chkPlay1Y.Down:=True; chkPlay1Y.Click; end
             else begin chkPlay1N.Down:=True; chkPlay1N.Click; end;
   if game.boxes=2 then _AUTOSTEP := 4 else _AUTOSTEP := 6;
end;

procedure TfrmAnalize.AutoStep4BestChange2;
var bestRow,i: Byte;
    r: TRect;
begin
   frmBestChange._AUTOMATE := True; frmMain._AUTOMATE := True;
   btnBestChange.Click;
   bestRow := frmBestChange.bestRow;
   case bestRow of
        1: begin chkPlay2N.Down:=True; chkPlay2N.Click; end; { не играть}
        2: begin chkPlay2Y.Down:=True; chkPlay2Y.Click; end; { играть }
        8: begin { прикуп шестой }
              r := grdBox2.CellRect(5,0);
              grdBox2MouseDown(Self, mbRight, [], r.Left+1, r.Top+1);
              Inc(_AUTOSTEP);
           end;
        else {обмен карт}
             for i:=2 to 6 do
                 if frmBestChange.grdResults.Cells[i,bestRow]='X' then begin
                    r := grdBox2.CellRect(i-2,0);
                    grdBox2MouseDown(Self, mbRight, [], r.Left+1, r.Top+1);
                 end;
             Inc(_AUTOSTEP);
   end;
end;

procedure TfrmAnalize.AutoStep5Analize2;
var a: Real;
begin
   if chkChange2Y.Enabled then begin
      chkChange2Y.Down:=True; chkChange2Y.Click;
   end;
   btnAnalize.Click;
   try a := StrToFloat(frmMain.lblAnteValue.Caption);
   except MessageDlg('Ошибка в модуле анализа!', mtError, [mbOK], 0); a:=0; end;
   if a > -1 then begin chkPlay2Y.Down:=True; chkPlay2Y.Click; end
             else begin chkPlay2N.Down:=True; chkPlay2N.Click; end;
end;

procedure TfrmAnalize.AutoStep6BestBuy;
var tempNNN: Longint;
begin
   if lblAnte1.Enabled or lblAnte2.Enabled then begin
      frmBestBuy._AUTOMATE := True;
      tempNNN := frmBestBuy.NNN; frmBestBuy.NNN := 5000;
      btnBestBuy.Click;
      frmBestBuy.NNN := tempNNN;

      if lblAnte1.Enabled then begin
         if (StrToFloat(frmBestBuy.grdResults.Cells[2,1]) > 1) then chkAnte1N.Down := True
                                                               else chkAnte1Y.Down := True;
         Ante1Finish;
      end;
      if lblAnte2.Enabled then begin
         if (StrToFloat(frmBestBuy.grdResults.Cells[1,1]) > 1) then chkAnte2N.Down := True
                                                               else chkAnte2Y.Down := True;
         Ante2Finish;
      end;
   end else _AUTOSTEP := 1;
end;


procedure TfrmAnalize.btnAutoClick(Sender: TObject);
    procedure NextStep(step: Byte);
    begin
       case step of
       1:   AutoStep1Razdat;
       2:   AutoStep2BestChange1;
       3:   AutoStep3Analize1;
       4:   AutoStep4BestChange2;
       5:   AutoStep5Analize2;
       6:   AutoStep6BestBuy;
       end;
    end;
begin
   btnAuto.Enabled := False;
   chkDebug.Enabled := False;
   _AUTOSTOP := False;

   {$IF demo}
   NextStep(_AUTOSTEP);
   {$ELSE}
   lblWarning.Visible := True;
   if chkDebug.Checked then
      NextStep(_AUTOSTEP)
   else repeat
      NextStep(_AUTOSTEP);
   until _AUTOSTOP;
   {$IFEND}

   frmMain._AUTOMATE := False;
   frmBestChange._AUTOMATE := False;
   frmBestBuy._AUTOMATE := False;
   
   btnAuto.Enabled := True;
   {$IF not demo}
   chkDebug.Enabled := True;
   lblWarning.Visible := False;
   {$IFEND}
end;

procedure TfrmAnalize.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Key=VK_SPACE then begin
      if chkDebug.Checked then btnAuto.Click
                          else _AUTOSTOP := True;
   end;
end;

procedure TfrmAnalize.btnEndGameClick(Sender: TObject);
var mbResult: TModalResult;
begin
   if not gameSaved then begin
      mbResult := MessageDlg('Текущая игра не сохранена.'#10#13'Сохранить игру?',
                          mtConfirmation, [mbYes, mbNo, mbCancel], 0);
      if mbResult<>mrCancel then begin
         if mbResult=mrYes then SaveGame;
         EndGame;
      end;
   end else EndGame;
end;

procedure TfrmAnalize.EndGame;
var i,j: Byte;
begin
   grdChangesPrice.Cells[1,0] := '1';
   grdChangesPrice.Cells[1,1] := '1';
   grdChangesPrice.Cells[1,2] := '1';
   grdChangesPrice.Cells[1,3] := '1';
   grdChangesPrice.Cells[1,4] := '1';
   grdChangesPrice.Cells[1,5] := '1';
   OptionsInit;
   OptionsShow;
   EnableOptions(True);
   lblRazdach.Caption := 'Расдач: 0';
   txtSum.Text := '0';
   for i:=1 to 3 do
       for j:=1 to 12 do
           grdStatistic.Cells[i,j] := '';

   for i:=1 to 6 do begin
       dealer[i]:=NOCARD; box1[i]:=NOCARD; box2[i]:=NOCARD;
       exchange1[i] := NOCARD; exchange2[i] := NOCARD;
   end;
   grdDealerCards.Repaint;
   grdBox2.Repaint;
   grdBox1.Repaint;
   lblGameName.Caption := '';
   gameSaved:=True;

   for i:=1 to 3 do
       for j:=1 to 12 do                   
           grdStatistic.Cells[i,j] := '0';

   _AUTOSTOP := False; _AUTOSTEP := 1;

   btnEndGame.Visible := False;
   btnNewGame.Visible := True;
   btnSavedGames.Visible := True;
   btnRazdat.Enabled := False;
   btnBestChange.Enabled := False;
   btnBestBuy.Enabled := False;
   btnAuto.Enabled := False;
end;


end.
