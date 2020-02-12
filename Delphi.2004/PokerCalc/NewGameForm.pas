unit NewGameForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmNewGame = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    memGameName: TMemo;
    lblDate: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    procedure FormActivate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNewGame: TfrmNewGame;

implementation

{$R *.dfm}

procedure TfrmNewGame.FormActivate(Sender: TObject);
begin
   memGameName.Text := '';
   lblDate.Caption := FormatDateTime('dd.mm.yyyy hh:nn', Now)
end;

end.
