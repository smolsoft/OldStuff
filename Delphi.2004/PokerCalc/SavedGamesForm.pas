unit SavedGamesForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids;

type
  TfrmSavedGames = class(TForm)
    grdGames: TStringGrid;
    btnLoad: TButton;
    btnDelete: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnLoadClick(Sender: TObject);
    procedure grdGamesDblClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    gamekey: string;
  end;

var
  frmSavedGames: TfrmSavedGames;

implementation

uses Registry;
{$R *.dfm}

procedure TfrmSavedGames.FormCreate(Sender: TObject);
begin
   grdGames.ColWidths[0] := 95;
   grdGames.ColWidths[1] := 95;
   grdGames.ColWidths[2] := 255;
   grdGames.ColWidths[3] := 60;
   grdGames.ColWidths[4] := 60;
   grdGames.ColWidths[5] := 0;
   grdGames.Cells[0,0] := 'Начало';
   grdGames.Cells[1,0] := 'Посл. игра';
   grdGames.Cells[2,0] := 'Название';
   grdGames.Cells[3,0] := 'Раздач';
   grdGames.Cells[4,0] := 'Выигрыш';
   grdGames.RowCount := 2;
end;

procedure TfrmSavedGames.FormShow(Sender: TObject);
var i: Integer;
    reg: TRegistry;
    keys: TStrings;
begin
   grdGames.RowCount := 2;  
   reg := TRegistry.Create;
   keys := TStringList.Create;
   try
   reg.OpenKey('Software\VirtualPokerAnalizer', True);
   reg.GetKeyNames(keys);
   reg.CloseKey;
   for i:=0 to keys.Count-1 do begin
      reg.OpenKey('Software\VirtualPokerAnalizer\' + keys[i], False);
      grdGames.Cells[0,grdGames.RowCount-1] := FormatDateTime('dd.mm.yyyy hh:nn', reg.ReadDateTime('start'));
      grdGames.Cells[1,grdGames.RowCount-1] := FormatDateTime('dd.mm.yyyy hh:nn', reg.ReadDateTime('saved'));
      grdGames.Cells[2,grdGames.RowCount-1] := reg.ReadString('name');
      grdGames.Cells[3,grdGames.RowCount-1] := IntToStr(reg.ReadInteger('razdach'));
      grdGames.Cells[4,grdGames.RowCount-1] := FloatToStr(reg.ReadFloat('money1')+reg.ReadFloat('money2'));
      grdGames.Cells[5,grdGames.RowCount-1] := keys[i];
      grdGames.RowCount := grdGames.RowCount + 1;
      reg.CloseKey;
   end;
   finally
   reg.Free; keys.Free;
   grdGames.RowCount := grdGames.RowCount - 1;
   grdGames.Row := grdGames.RowCount - 1;
   end;
end;

procedure TfrmSavedGames.btnLoadClick(Sender: TObject);
begin gamekey := grdGames.Cells[5,grdGames.Row]; end;

procedure TfrmSavedGames.grdGamesDblClick(Sender: TObject);
begin gamekey := grdGames.Cells[5,grdGames.Row]; ModalResult := mrOk; end;

procedure TfrmSavedGames.btnDeleteClick(Sender: TObject);
var i,j: Integer;
    reg: TRegistry;
begin
   reg := TRegistry.Create;
   reg.DeleteKey('Software\VirtualPokerAnalizer\' + grdGames.Cells[5,grdGames.Row]);
   reg.Free;
   with grdGames do
       for i:=Row to RowCount-2 do
           for j:=0 to 5 do
               Cells[j,i] := Cells[j,i+1];
   grdGames.RowCount := grdGames.RowCount - 1;
end;

end.
