object frmSavedGames: TfrmSavedGames
  Left = 253
  Top = 156
  Width = 581
  Height = 371
  Caption = #1054#1090#1083#1086#1078#1077#1085#1085#1099#1077' '#1080#1075#1088#1099
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  DesignSize = (
    573
    344)
  PixelsPerInch = 96
  TextHeight = 13
  object grdGames: TStringGrid
    Left = 0
    Top = 0
    Width = 573
    Height = 309
    Anchors = [akLeft, akTop, akRight, akBottom]
    ColCount = 6
    DefaultColWidth = 164
    DefaultRowHeight = 20
    FixedCols = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
    ParentFont = False
    TabOrder = 0
    OnDblClick = grdGamesDblClick
  end
  object btnLoad: TButton
    Left = 484
    Top = 317
    Width = 89
    Height = 24
    Anchors = [akRight, akBottom]
    Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100
    Default = True
    ModalResult = 1
    TabOrder = 1
    OnClick = btnLoadClick
  end
  object btnDelete: TButton
    Left = 0
    Top = 313
    Width = 89
    Height = 24
    Anchors = [akLeft]
    Caption = #1059#1076#1072#1083#1080#1090#1100
    TabOrder = 2
    OnClick = btnDeleteClick
  end
  object btnCancel: TButton
    Left = 388
    Top = 317
    Width = 89
    Height = 24
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 3
  end
end
