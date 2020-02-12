unit BestChangesForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, PokerCards, ExtCtrls;

type
  TfrmBestChange = class(TForm)
    Label1: TLabel;
    txtNNN: TEdit;
    btnStart: TButton;
    grdResults: TStringGrid;
    lblPlayWhen1: TLabel;
    lblPlayWhen2: TLabel;
    Timer: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure grdResultsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure FormActivate(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    stopFlag: Boolean;
  public
    { Public declarations }
    dealer, player: cards;
    poker: Byte;
    minGame: Byte;
    bestRow: Byte;

    _AUTOMATE: Boolean;

    procedure ClearResults;
    procedure Prepare(firstCard: Shortint);
  end;

var
  frmBestChange: TfrmBestChange;

implementation

uses BestChange, analize, DrawCards, Math;

{$R *.dfm}

procedure TfrmBestChange.FormCreate(Sender: TObject);
var i: Byte;
begin
   grdResults.Cells[1,0] := 'Ante/сдачу';
   grdResults.Cells[0,1] := 'Не играть';
   grdResults.Cells[0,2] := 'Без обмена';
   grdResults.Cells[0,3] := 'Обмен 1-й';
   grdResults.Cells[0,4] := 'Обмен 2-х';
   grdResults.Cells[0,5] := 'Обмен 3-х';
   grdResults.Cells[0,6] := 'Обмен 4-х';
   grdResults.Cells[0,7] := 'Обмен 5-и';
   grdResults.Cells[0,8] := 'Прикуп 6-й';
   grdResults.Cells[1,1] := Format('%8.3f', [-1.0]);
   grdResults.ColWidths[0] := 95;
   grdResults.ColWidths[1] := 106;
   for i:=2 to 6 do
       grdResults.ColWidths[i] := 26;
   grdResults.Col := 1; grdResults.Row := 1;
   stopFlag := False;
   _AUTOMATE := False;

   {$IF demo}
   txtNNN.Enabled := False;
   with Self do Caption := Caption + ' DEMO VERSION!'
   {$IFEND}
end;

procedure TfrmBestChange.btnStartClick(Sender: TObject);
type exchangeRecord = record
         exchange: exchangeArray;
         mo: Double;
     end;

var i,j,maxI,counter: Byte;
    exchange: exchangeArray;
    changeStat: array of exchangeRecord;
    mo, maxMO, bestMO: Double;
    nnn: Longint;

    procedure ShowChanges(ch: exchangeRecord; row: Integer);
    var i: Byte;
    begin
       for i:=1 to 5 do
           if ch.exchange[i] then grdResults.Cells[1+i,row] := 'X'
                             else grdResults.Cells[1+i,row] := '';
    end;
begin
   dealer[6] := NOCARD;
   player[6] := NOCARD;  
   if stopFlag then begin stopFlag := False; Exit; end;
   if btnStart.Caption = 'Остановить' then begin stopFlag := True; Exit; end;
   grdResults.SetFocus;
   ClearResults;
   nnn := StrToInt(txtNNN.Text); bestMO := -1; bestRow := 1;

InitDataCards(nnn, 9);


   {$IF demo}
   if nnn>77 then nnn:=dto;
   {$IFEND}
   grdResults.Repaint;
   btnStart.Caption := 'Остановить';

   { без обмена }
   exchange[1]:=False;exchange[2]:=False;exchange[3]:=False;
   exchange[4]:=False;exchange[5]:=False;exchange[6]:=False;
   mo := GetMO(dealer, player, exchange, nnn, minGame, poker);
   grdResults.Cells[1,2] := Format('%8.3f', [RoundTo(mo, -3)]);
   if mo>bestMO then begin bestMO:=mo; bestRow:=2; grdResults.Repaint;  end;
   Application.ProcessMessages;

try
   { обмен 1-й }
   if (changePrices[1]>0) then begin
      SetLength(changeStat,6);
      for j:=1 to 5 do begin { перебирать все обмены одной карты }
          for i:=1 to 6 do
              if i=j then changeStat[j].exchange[i] := True
                     else changeStat[j].exchange[i] := False;
          changeStat[j].mo := GetMO(dealer, player, changeStat[j].exchange, nnn, minGame, poker);
          if j=1 then begin maxMO := changeStat[j].mo; maxI := 1; end
                 else if changeStat[j].mo > maxMO then begin
                         maxMO := changeStat[j].mo; maxI := j;
                      end;
          ShowChanges(changeStat[j], 3);
          grdResults.Cells[1,3] := Format('%8.3f', [RoundTo(changeStat[j].mo, -3)]);
          Application.ProcessMessages;
          if stopFlag then raise Exception.Create('');
      end;
      { показ лучшего обмена }
      grdResults.Cells[1,3] := Format('%8.3f', [RoundTo(changeStat[maxI].mo, -3)]);
      ShowChanges(changeStat[maxI], 3);
      if changeStat[maxI].mo>bestMO then begin bestMO:=changeStat[maxI].mo; bestRow:=3; grdResults.Repaint; end;
      SetLength(changeStat, 0);
   end;

   { обмен 2-х }
   if (changePrices[2]>0) and not stopFlag then begin
      SetLength(changeStat,11); counter := 1;
      for i:=1 to 10 do
          for j:=1 to 6 do changeStat[i].exchange[j] := False;
      for j:=1 to 5 do
          for i:=j+1 to 5 do begin
              changeStat[counter].exchange[j] := True;
              changeStat[counter].exchange[i] := True;
              changeStat[counter].mo := GetMO(dealer, player, changeStat[counter].exchange,
                                                              nnn, minGame, poker);

              if counter=1 then begin maxMO := changeStat[counter].mo; maxI := 1; end
                           else if changeStat[counter].mo > maxMO then begin
                                   maxMO := changeStat[counter].mo; maxI := counter;
                                end;
              ShowChanges(changeStat[counter], 4);
              grdResults.Cells[1,4] :=Format('%8.3f',[RoundTo(changeStat[counter].mo,-3)]);
              Inc(counter);
              Application.ProcessMessages;
              if stopFlag then raise Exception.Create('');
          end;
          { показ лучшего обмена }
          grdResults.Cells[1,4] := Format('%8.3f', [RoundTo(changeStat[maxI].mo, -3)]);
          if changeStat[maxI].mo>bestMO then begin bestMO:=changeStat[maxI].mo; bestRow:=4; grdResults.Repaint; end;
          ShowChanges(changeStat[maxI], 4);
          SetLength(changeStat, 0);
   end;

   { обмен 3-х }
   if (changePrices[3]>0) and not stopFlag then begin
      SetLength(changeStat,11); counter := 1;
      for i:=1 to 10 do begin
          for j:=1 to 5 do changeStat[i].exchange[j] := True;
          changeStat[i].exchange[6] := False;
      end;
      for j:=1 to 5 do
          for i:=j+1 to 5 do begin
              changeStat[counter].exchange[j] := False;
              changeStat[counter].exchange[i] := False;
              changeStat[counter].mo := GetMO(dealer, player, changeStat[counter].exchange, nnn, minGame, poker);

              if counter=1 then begin maxMO := changeStat[counter].mo; maxI := 1; end
                           else if changeStat[counter].mo > maxMO then begin
                                   maxMO := changeStat[counter].mo; maxI := counter;
                                end;
              ShowChanges(changeStat[counter], 5);
              grdResults.Cells[1,5] := Format('%8.3f', [RoundTo(changeStat[counter].mo, -3)]);
              Inc(counter);
              Application.ProcessMessages;
              if stopFlag then raise Exception.Create('');
          end;
          { показ лучшего обмена }
          grdResults.Cells[1,5] := Format('%8.3f', [RoundTo(changeStat[maxI].mo, -3)]);
          if changeStat[maxI].mo>bestMO then begin bestMO:=changeStat[maxI].mo; bestRow:=5; grdResults.Repaint; end;
          ShowChanges(changeStat[maxI], 5);
          SetLength(changeStat, 0);
   end;

   { обмен 4-x }
   if (changePrices[4]>0) and not stopFlag then begin
      SetLength(changeStat,6);
      for j:=1 to 5 do begin { перебирать все обмены одной карты }
          for i:=1 to 5 do
              if i=j then changeStat[j].exchange[i] := False
                     else changeStat[j].exchange[i] := True;
          changeStat[j].exchange[6]:=False;
          changeStat[j].mo := GetMO(dealer, player, changeStat[j].exchange, nnn, minGame, poker);
          if j=1 then begin maxMO := changeStat[j].mo; maxI := 1; end
                 else if changeStat[j].mo > maxMO then begin
                         maxMO := changeStat[j].mo; maxI := j;
                      end;
          ShowChanges(changeStat[j], 6);
          grdResults.Cells[1,6] := Format('%8.3f', [RoundTo(changeStat[j].mo, -3)]);
          Application.ProcessMessages;
          if stopFlag then raise Exception.Create('');
      end;
      { показ лучшего обмена }
      grdResults.Cells[1,6] := Format('%8.3f', [RoundTo(changeStat[maxI].mo, -3)]);
      if changeStat[maxI].mo>bestMO then begin bestMO:=changeStat[maxI].mo; bestRow:=6; grdResults.Repaint; end;
      ShowChanges(changeStat[maxI], 6);
      SetLength(changeStat, 0);
   end;

   { обмен 5-х }
   if (changePrices[5]>0) and not stopFlag then begin
      exchange[1]:=True;exchange[2]:=True;exchange[3]:=True;
      exchange[4]:=True;exchange[5]:=True;exchange[6]:=False;
      mo := GetMO(dealer, player, exchange, nnn, minGame, poker);
      for i:=1 to 5 do grdResults.Cells[1+i,7] := 'X';
      grdResults.Cells[1,7] := Format('%8.3f', [RoundTo(mo, -3)]);
      if mo>bestMO then begin bestMO:=mo; bestRow:=7; grdResults.Repaint; end;
      Application.ProcessMessages;
      if stopFlag then raise Exception.Create('');
   end;

   { прикуп 6-ой }
   if (changePrices[6]>0) and not stopFlag then begin
      exchange[1]:=False;exchange[2]:=False;exchange[3]:=False;
      exchange[4]:=False;exchange[5]:=False;exchange[6]:=True;
      mo := GetMO(dealer, player, exchange, nnn, minGame, poker);
      grdResults.Cells[1,8] := Format('%8.3f', [RoundTo(mo, -3)]);
      if mo>bestMO then begin bestRow:=8; grdResults.Repaint; end;
      Application.ProcessMessages;
   end;
except
   ;
end;
FreeDataCards;
   btnStart.Caption := 'Начать расчет'; stopFlag := False;
   lblPlayWhen2.Caption := '';
   case bestRow of
        1: lblPlayWhen1.Caption := 'Не играть';
        2: lblPlayWhen1.Caption := 'Играть';
        else
           if minGame = wAK then begin
              lblPlayWhen1.Caption := 'Играть при наличии 2-х вскрытых карт дилера или';
              lblPlayWhen2.Caption := 'Туз, Король, Валет или Две двойки и старше';
           end else begin
              lblPlayWhen1.Caption := 'Играть при наличии 1-й вскрытой карты дилера или';
              lblPlayWhen2.Caption := 'Двух троек и старше';
           end;
   end;
end;

procedure TfrmBestChange.grdResultsDrawCell(Sender: TObject; ACol, ARow: Integer;
                                                    Rect: TRect; State: TGridDrawState);
begin
   if not (gdFixed in State) then begin
      if (ARow = bestRow) and (bestRow <> 0) then grdResults.Canvas.Brush.Color := clMoneyGreen;
      grdResults.Canvas.FillRect(Rect);
      grdResults.Canvas.TextOut(Rect.Left+2,Rect.Top+2,grdResults.Cells[ACol, ARow]);
      if ACol in [2..6] then
         case ARow of
           1: DrawCard(grdResults.Canvas, Rect, player[ACol-1], 10, False, False, True, True, False);
        2..8: DrawCard(grdResults.Canvas, Rect, player[ACol-1], 10, False,
                                          grdResults.Cells[ACol, ARow]='X', False, True, False);
         end;
   end;
end;

procedure TfrmBestChange.ClearResults;
var r,c: Byte;
begin
   for r:=2 to 8 do
       for c:=1 to 6 do
           grdResults.Cells[c,r] := '';
   bestRow := 0;
   lblPlayWhen1.Caption := '';
   lblPlayWhen2.Caption := '';
end;

procedure TfrmBestChange.Prepare(firstCard: Shortint);
begin
   PrepareArray(StrToInt(txtNNN.Text), firstCard);
end;

procedure TfrmBestChange.FormActivate(Sender: TObject);
begin
   {$IF demo}
   Randomize; txtNNN.Text := IntToStr(RandomRange(dfrom, dto));
   {$IFEND}
   if _AUTOMATE then begin
      btnStart.Click;
      _AUTOMATE := False;
      Timer.Interval := 100;
   end;
end;


procedure TfrmBestChange.TimerTimer(Sender: TObject);
begin
   if not _AUTOMATE then begin
      ModalResult := mrOk;
      Timer.Interval := 0;
   end;
end;

procedure TfrmBestChange.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if (Key=VK_SPACE) and (not frmAnalize.chkDebug.Checked) then begin
      stopFlag:=True; _AUTOMATE := False; frmAnalize._AUTOSTOP:=True;
   end;
end;

end.
