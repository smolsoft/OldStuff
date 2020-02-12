object frmWinOptions: TfrmWinOptions
  Left = 213
  Top = 181
  BorderStyle = bsDialog
  Caption = #1050#1086#1101#1092#1092#1080#1094#1080#1077#1085#1090#1099' '#1074#1099#1080#1075#1088#1099#1096#1077#1081
  ClientHeight = 316
  ClientWidth = 617
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object grdWins: TStringGrid
    Left = 0
    Top = 0
    Width = 617
    Height = 281
    ColCount = 8
    DefaultColWidth = 73
    DefaultRowHeight = 22
    RowCount = 12
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goEditing, goAlwaysShowEditor]
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 0
  end
  object btnOK: TButton
    Left = 536
    Top = 288
    Width = 81
    Height = 25
    Caption = 'OK'
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 448
    Top = 288
    Width = 81
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
