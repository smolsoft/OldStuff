object frmBestChange: TfrmBestChange
  Left = 342
  Top = 170
  BorderStyle = bsDialog
  Caption = #1040#1085#1072#1083#1080#1079' '#1086#1073#1084#1077#1085#1072
  ClientHeight = 319
  ClientWidth = 348
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 4
    Top = 8
    Width = 135
    Height = 16
    Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086' '#1088#1072#1079#1076#1072#1095' :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblPlayWhen1: TLabel
    Left = 4
    Top = 280
    Width = 349
    Height = 16
    Alignment = taCenter
    AutoSize = False
    Caption = 'lblPlayWhen1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblPlayWhen2: TLabel
    Left = 4
    Top = 300
    Width = 349
    Height = 16
    Alignment = taCenter
    AutoSize = False
    Caption = 'lblPlayWhen2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object txtNNN: TEdit
    Left = 144
    Top = 6
    Width = 73
    Height = 24
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    Text = '100000'
  end
  object btnStart: TButton
    Left = 224
    Top = 4
    Width = 121
    Height = 25
    Caption = #1053#1072#1095#1072#1090#1100' '#1088#1072#1089#1095#1077#1090
    Default = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnStartClick
  end
  object grdResults: TStringGrid
    Left = 4
    Top = 32
    Width = 342
    Height = 247
    TabStop = False
    ColCount = 7
    DefaultColWidth = 106
    DefaultRowHeight = 26
    RowCount = 9
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 2
    OnDrawCell = grdResultsDrawCell
    RowHeights = (
      26
      26
      26
      26
      26
      26
      26
      26
      26)
  end
  object Timer: TTimer
    Interval = 0
    OnTimer = TimerTimer
    Left = 40
    Top = 40
  end
end
