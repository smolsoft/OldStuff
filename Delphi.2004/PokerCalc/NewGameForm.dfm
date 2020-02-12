object frmNewGame: TfrmNewGame
  Left = 372
  Top = 278
  Width = 345
  Height = 183
  Caption = #1053#1086#1074#1072#1103' '#1080#1075#1088#1072
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 89
    Height = 16
    Caption = #1044#1072#1090#1072' '#1085#1072#1095#1072#1083#1072' :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 23
    Top = 32
    Width = 72
    Height = 16
    Alignment = taRightJustify
    Caption = #1053#1072#1079#1074#1072#1085#1080#1077' :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblDate: TLabel
    Left = 100
    Top = 8
    Width = 113
    Height = 16
    Caption = '31.12.2004 15:37'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object memGameName: TMemo
    Left = 101
    Top = 32
    Width = 233
    Height = 81
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Lines.Strings = (
      'memGameName')
    ParentFont = False
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 259
    Top = 120
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 179
    Top = 120
    Width = 75
    Height = 25
    Cancel = True
    Caption = #1054#1090#1084#1077#1085#1072
    ModalResult = 2
    TabOrder = 2
  end
end
