object frmBestBuy: TfrmBestBuy
  Left = 349
  Top = 385
  BorderStyle = bsDialog
  Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090' '#1087#1086#1082#1091#1087#1082#1080
  ClientHeight = 75
  ClientWidth = 273
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
  object lblResult: TLabel
    Left = 0
    Top = 0
    Width = 266
    Height = 20
    Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090' '#1087#1086#1082#1091#1087#1082#1080', ante/'#1089#1076#1072#1095#1091':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object grdResults: TStringGrid
    Left = 0
    Top = 24
    Width = 273
    Height = 50
    ColCount = 3
    DefaultColWidth = 89
    DefaultRowHeight = 22
    FixedCols = 0
    RowCount = 2
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
    ParentFont = False
    TabOrder = 0
    OnDrawCell = grdResultsDrawCell
  end
  object Timer: TTimer
    Interval = 0
    OnTimer = TimerTimer
    Left = 112
    Top = 24
  end
end
