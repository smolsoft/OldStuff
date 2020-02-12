unit BestBuyForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, PokerCards, Grids;


type
  TfrmBestBuy = class(TForm)
    grdResults: TStringGrid;
    lblResult: TLabel;
    Timer: TTimer;
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure grdResultsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure TimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    d,p1,p2: cards;
    buyWhen, minGame, change1, change2: Byte;
    poker: Byte;
    NNN: Longint;

    _AUTOMATE: Boolean;
    procedure Process;
  end;

var
  frmBestBuy: TfrmBestBuy;


implementation

uses Math,BestChange, analize;
{$R *.dfm}

procedure TfrmBestBuy.FormActivate(Sender: TObject);
begin grdResults.Cells[1,1]:=''; grdResults.Cells[2,1]:=''; Process; end;

procedure TfrmBestBuy.Process;
var bb1,bb2: Double;
begin
   Application.ProcessMessages;
   if frmAnalize.lblBox2.Enabled then begin
      bb2 := BestBuy(d,p2,NNN,buyWhen,minGame,change2,poker);
      grdResults.Cells[1,1] := FloatToStr(RoundTo(bb2, -3));
      Application.ProcessMessages;
   end;
   if frmAnalize.lblBox1.Enabled then begin
      bb1 := BestBuy(d,p1,NNN,buyWhen,minGame,change1,poker);
      grdResults.Cells[2,1] := FloatToStr(RoundTo(bb1, -3));
   end;

   if _AUTOMATE then begin
      _AUTOMATE := False;
      Timer.Interval := 100;
   end;
end;

procedure TfrmBestBuy.FormCreate(Sender: TObject);
begin
   grdResults.Cells[0,0] := 'Не покупать';
   grdResults.Cells[1,0] := 'Бокс 2';
   grdResults.Cells[2,0] := 'Бокс 1';
   grdResults.ColWidths[0] := 100;
   grdResults.ColWidths[1] := 83;
   grdResults.ColWidths[2] := 83;
   grdResults.Cells[0,1] := '1';
   {$IF demo}
   NNN := 5000;
   Self.Caption := Self.Caption + ' DEMO VERSION!';
   {$ELSE}
   NNN := 500000;
   {$IFEND}
   _AUTOMATE := False;
end;

procedure TfrmBestBuy.grdResultsDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var value: Real;
begin
   if ARow=1 then begin
      if grdResults.Cells[ACol, ARow]<>'' then
         try    value := StrToFloat(grdResults.Cells[ACol, ARow]);
         except value := 1; end
      else
         value := 1; 

      if value>1 then
         grdResults.Canvas.Pen.Color := RGB(0,0,255)
      else if value<1 then
         grdResults.Canvas.Pen.Color := RGB(255,0,0)
      else
         grdResults.Canvas.Pen.Color := RGB(0,0,0);
   end;
end;

procedure TfrmBestBuy.TimerTimer(Sender: TObject);
begin
   if not _AUTOMATE then begin
      ModalResult := mrOk;
      Timer.Interval := 0;
   end;
end;

end.
