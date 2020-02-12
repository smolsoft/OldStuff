program Poker;

uses
  Forms,
  MainForm in 'MainForm.pas' {frmMain},
  PokerCards in 'PokerCards.pas',
  analize in 'analize.pas' {frmAnalize},
  WinOptionsForm in 'WinOptionsForm.pas' {frmWinOptions},
  NewGameForm in 'NewGameForm.pas' {frmNewGame},
  DrawCards in 'DrawCards.pas',
  SavedGamesForm in 'SavedGamesForm.pas' {frmSavedGames},
  Optimization in 'Optimization.pas',
  BestChange in 'BestChange.pas',
  BestChangesForm in 'BestChangesForm.pas' {frmBestChange},
  BestBuyForm in 'BestBuyForm.pas' {frmBestBuy},
  RussianPoker in 'RussianPoker.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Virtual Poker';
  Application.CreateForm(TfrmAnalize, frmAnalize);
  Application.CreateForm(TfrmMain, frmMain);
  Application.CreateForm(TfrmWinOptions, frmWinOptions);
  Application.CreateForm(TfrmNewGame, frmNewGame);
  Application.CreateForm(TfrmSavedGames, frmSavedGames);
  Application.CreateForm(TfrmBestChange, frmBestChange);
  Application.CreateForm(TfrmBestBuy, frmBestBuy);
  Application.Run;
end.
