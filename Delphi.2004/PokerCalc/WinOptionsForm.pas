unit WinOptionsForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Grids, PokerCards;

type
  TfrmWinOptions = class(TForm)
    grdWins: TStringGrid;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    fPoker: Byte;
    procedure setPoker(value: Byte);
  public
    { Public declarations }
    property Poker: Byte read fPoker write setPoker;
  end;

var
  frmWinOptions: TfrmWinOptions;

implementation

{$R *.dfm}

procedure TfrmWinOptions.FormCreate(Sender: TObject);
begin
   grdWins.Cells[1,0] := '��� ������';
   grdWins.Cells[2,0] := '����� 1�';
   grdWins.Cells[3,0] := '����� 2�';
   grdWins.Cells[4,0] := '����� 3�';
   grdWins.Cells[5,0] := '����� 4�';
   grdWins.Cells[6,0] := '����� 5�';
   grdWins.Cells[7,0] := '������ 6�';

   grdWins.Cells[0,wNoGame+1] := '��� ����';
   grdWins.Cells[0,wAK+1] := '���-������';
   grdWins.Cells[0,wPair+1] := '����';
   grdWins.Cells[0,w2Pair+1] := '��� ����';
   grdWins.Cells[0,wTriple+1] := '������';
   grdWins.Cells[0,wStreet+1] := '�����';
   grdWins.Cells[0,wFlash+1] := '����';
   grdWins.Cells[0,wFullHouse+1] := '��� ����';
   grdWins.Cells[0,wCare+1] := '����';
   grdWins.Cells[0,wStreetFlash+1] := '����� ����';
   grdWins.Cells[0,wRoyalFlash+1] := '����� ����';
   grdWins.ColWidths[0] := 94;
   Poker := pokerSimple;
end;

procedure TfrmWinOptions.FormActivate(Sender: TObject);
var i,j: Byte;
begin
   for i:=wNoGame to wAKplus do
       for j:=0 to 6 do
           if fPoker=pokerSimple then
              grdWins.Cells[j+1,i+1] := IntToStr(winCoef[i,j])
           else
              grdWins.Cells[j+1,i+1] := IntToStr(winCoefRUS[i,j]);
end;

procedure TfrmWinOptions.btnOKClick(Sender: TObject);
var i,j: Byte;
begin
   for i:=wNoGame to wAKplus do
       for j:=0 to 6 do
           try
              if fPoker=pokerSimple then
                 winCoef[i,j] := StrToInt(grdWins.Cells[j+1,i+1])
              else
                 winCoefRUS[i,j] := StrToInt(grdWins.Cells[j+1,i+1]);
           except;
           end;
   Self.Close;
end;

procedure TfrmWinOptions.btnCancelClick(Sender: TObject);
begin
   Self.Close;
end;

procedure TfrmWinOptions.setPoker(value: Byte);
var i,j: Byte;
    offset: Shortint;
begin
     if (value in [pokerRussian, pokerSimple]) and (value<>fPoker) then begin
        fPoker := value;
        case fPoker of
             pokerSimple: begin
                            offset := 1;
                            Self.Height := 343;
                            grdWins.RowCount := 12;
                            grdWins.Height := 281;
                            btnOK.Top := 288;
                            btnCancel.Top := 288;
                          end;
             pokerRussian:begin
                            offset := -1;
                            Self.Height := 367;
                            btnOK.Top := 312;
                            btnCancel.Top := 312;
                            grdWins.RowCount := 13;
                            grdWins.Height := 305;
                            grdWins.Cells[0,wAKplus+1] := '+���-������';
                            for i:=0 to 6 do
                                grdWins.Cells[i+1,wAKplus+1] := IntToStr(winCoefRUS[wAKplus,i]);
                          end;
        end;
     end;
end;

end.
