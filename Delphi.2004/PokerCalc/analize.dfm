object frmAnalize: TfrmAnalize
  Left = 264
  Top = 138
  BorderStyle = bsDialog
  Caption = 'Virtual Poker'
  ClientHeight = 490
  ClientWidth = 603
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object lblChangesPrice: TLabel
    Left = 296
    Top = 227
    Width = 125
    Height = 16
    Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100' '#1086#1073#1084#1077#1085#1072':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblDealer: TLabel
    Left = 276
    Top = 2
    Width = 55
    Height = 20
    Caption = #1044#1080#1083#1077#1088
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblBox2: TLabel
    Left = 44
    Top = 10
    Width = 56
    Height = 20
    Caption = #1041#1086#1082#1089' 2'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblStatistic: TLabel
    Left = 8
    Top = 170
    Width = 87
    Height = 16
    Caption = #1057#1090#1072#1090#1080#1089#1090#1080#1082#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lblSettings: TLabel
    Left = 296
    Top = 170
    Width = 120
    Height = 16
    Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1080#1075#1088#1099
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object chkChange2N: TSpeedButton
    Left = 102
    Top = 34
    Width = 33
    Height = 22
    AllowAllUp = True
    GroupIndex = 1
    Caption = #1053#1077#1090
    Enabled = False
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Spacing = 0
    OnClick = chkChange2Click
  end
  object chkPlay2N: TSpeedButton
    Left = 102
    Top = 62
    Width = 33
    Height = 22
    AllowAllUp = True
    GroupIndex = 2
    Caption = #1053#1077#1090
    Enabled = False
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = chkPlay2Click
  end
  object chkPlay2Y: TSpeedButton
    Left = 6
    Top = 62
    Width = 35
    Height = 22
    AllowAllUp = True
    GroupIndex = 2
    Caption = #1044#1072
    Enabled = False
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = chkPlay2Click
  end
  object chkChange2Y: TSpeedButton
    Left = 6
    Top = 34
    Width = 35
    Height = 22
    AllowAllUp = True
    GroupIndex = 1
    Caption = #1044#1072
    Enabled = False
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = chkChange2Click
  end
  object lblChange2: TLabel
    Left = 44
    Top = 37
    Width = 55
    Height = 16
    Caption = #1052#1077#1085#1103#1090#1100'?'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblPlay2: TLabel
    Left = 44
    Top = 65
    Width = 55
    Height = 16
    Alignment = taCenter
    AutoSize = False
    Caption = #1048#1075#1088#1072#1090#1100'?'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object chkChange1N: TSpeedButton
    Left = 558
    Top = 34
    Width = 33
    Height = 22
    AllowAllUp = True
    GroupIndex = 3
    Caption = #1053#1077#1090
    Enabled = False
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Spacing = 0
    OnClick = chkChange1Click
  end
  object chkPlay1N: TSpeedButton
    Left = 558
    Top = 62
    Width = 33
    Height = 22
    AllowAllUp = True
    GroupIndex = 4
    Caption = #1053#1077#1090
    Enabled = False
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = chkPlay1Click
  end
  object lblPlay1: TLabel
    Left = 500
    Top = 65
    Width = 55
    Height = 16
    Alignment = taCenter
    AutoSize = False
    Caption = #1048#1075#1088#1072#1090#1100'?'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblChange1: TLabel
    Left = 500
    Top = 37
    Width = 55
    Height = 16
    Caption = #1052#1077#1085#1103#1090#1100'?'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object chkChange1Y: TSpeedButton
    Left = 462
    Top = 34
    Width = 35
    Height = 22
    AllowAllUp = True
    GroupIndex = 3
    Caption = #1044#1072
    Enabled = False
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = chkChange1Click
  end
  object chkPlay1Y: TSpeedButton
    Left = 462
    Top = 62
    Width = 35
    Height = 22
    AllowAllUp = True
    GroupIndex = 4
    Caption = #1044#1072
    Enabled = False
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = chkPlay1Click
  end
  object lblBox1: TLabel
    Left = 500
    Top = 10
    Width = 56
    Height = 20
    Caption = #1041#1086#1082#1089' 1'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Bevel1: TBevel
    Left = 8
    Top = 168
    Width = 593
    Height = 2
  end
  object Bevel2: TBevel
    Left = 288
    Top = 176
    Width = 2
    Height = 313
  end
  object Bevel3: TBevel
    Left = 472
    Top = 176
    Width = 2
    Height = 313
  end
  object lblRazdach: TLabel
    Left = 104
    Top = 170
    Width = 177
    Height = 16
    Alignment = taRightJustify
    AutoSize = False
    Caption = #1056#1072#1079#1076#1072#1095' : 0'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblSum: TLabel
    Left = 95
    Top = 470
    Width = 64
    Height = 16
    Alignment = taRightJustify
    Caption = #1042#1099#1080#1075#1088#1099#1096' :'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object chkAnte2Y: TSpeedButton
    Left = 6
    Top = 134
    Width = 35
    Height = 22
    AllowAllUp = True
    GroupIndex = 5
    Caption = #1044#1072
    Enabled = False
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = chkAnte2Click
  end
  object lblAnte2: TLabel
    Left = 44
    Top = 137
    Width = 55
    Height = 16
    Alignment = taCenter
    AutoSize = False
    Caption = #1040#1085#1090#1077'?'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object chkAnte2N: TSpeedButton
    Left = 102
    Top = 134
    Width = 33
    Height = 22
    AllowAllUp = True
    GroupIndex = 5
    Caption = #1053#1077#1090
    Enabled = False
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = chkAnte2Click
  end
  object chkAnte1Y: TSpeedButton
    Left = 462
    Top = 134
    Width = 35
    Height = 22
    AllowAllUp = True
    GroupIndex = 6
    Caption = #1044#1072
    Enabled = False
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = chkAnte1Click
  end
  object lblAnte1: TLabel
    Left = 500
    Top = 137
    Width = 55
    Height = 16
    Alignment = taCenter
    AutoSize = False
    Caption = #1040#1085#1090#1077'?'
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object chkAnte1N: TSpeedButton
    Left = 558
    Top = 134
    Width = 33
    Height = 22
    AllowAllUp = True
    GroupIndex = 6
    Caption = #1053#1077#1090
    Enabled = False
    Flat = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    OnClick = chkAnte1Click
  end
  object lblDemo: TLabel
    Left = 160
    Top = 136
    Width = 275
    Height = 24
    Caption = #1044#1077#1084#1086#1085#1089#1090#1088#1072#1094#1080#1086#1085#1085#1072#1103' '#1074#1077#1088#1089#1080#1103'!'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object lblGameName: TLabel
    Left = 204
    Top = 69
    Width = 190
    Height = 16
    Alignment = taCenter
    AutoSize = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object lblWarning: TLabel
    Left = 152
    Top = 136
    Width = 298
    Height = 20
    Caption = #1044#1083#1103' '#1086#1089#1090#1072#1085#1086#1074#1082#1080' - '#1085#1072#1078#1084#1080#1090#1077' "'#1087#1088#1086#1073#1077#1083'"'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clRed
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    Visible = False
  end
  object grdDealerCards: TDrawGrid
    Left = 204
    Top = 24
    Width = 190
    Height = 41
    TabStop = False
    DefaultColWidth = 36
    DefaultRowHeight = 36
    DefaultDrawing = False
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goDrawFocusSelected]
    ParentFont = False
    TabOrder = 3
    OnDrawCell = grdDealerCardsDrawCell
  end
  object grdChangesPrice: TStringGrid
    Left = 296
    Top = 243
    Width = 169
    Height = 123
    ColCount = 2
    DefaultColWidth = 65
    DefaultRowHeight = 20
    RowCount = 6
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goAlwaysShowEditor]
    ParentFont = False
    ScrollBars = ssNone
    TabOrder = 4
    OnKeyPress = grdChangesPriceKeyPress
    OnSetEditText = grdChangesPriceSetEditText
    RowHeights = (
      20
      20
      20
      20
      20
      20)
  end
  object grpMinGame: TGroupBox
    Left = 296
    Top = 390
    Width = 169
    Height = 55
    Caption = '    '#1052#1080#1085#1080#1084'. '#1080#1075#1088#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 5
    object chkMin22: TRadioButton
      Left = 2
      Top = 16
      Width = 97
      Height = 17
      Caption = #1044#1074#1077' '#1076#1074#1086#1081#1082#1080
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TabStop = True
      OnClick = chkMin22Click
    end
    object chkMinTK: TRadioButton
      Left = 2
      Top = 32
      Width = 97
      Height = 17
      Caption = #1058#1091#1079'-'#1050#1086#1088#1086#1083#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = chkMinTKClick
    end
  end
  object chk2box: TCheckBox
    Left = 296
    Top = 191
    Width = 137
    Height = 16
    Caption = #1048#1075#1088#1072#1090#1100' '#1085#1072' 2 '#1073#1086#1082#1089#1072
    Checked = True
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    State = cbChecked
    TabOrder = 6
    OnClick = chk2boxClick
  end
  object grpBuyDealerGame: TGroupBox
    Left = 296
    Top = 448
    Width = 169
    Height = 39
    Caption = '    '#1055#1086#1082#1091#1087#1082#1072' '#1080#1075#1088#1099' '#1076#1080#1083#1077#1088#1091
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 7
    object chkBuyNo: TRadioButton
      Left = 2
      Top = 16
      Width = 55
      Height = 17
      Caption = #1053#1077#1090
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      TabStop = True
      OnClick = chkBuyNoClick
    end
    object chkBuyHi: TRadioButton
      Left = 62
      Top = 16
      Width = 35
      Height = 17
      Caption = 'Hi'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = chkBuyHiClick
    end
    object chkBuyLow: TRadioButton
      Left = 114
      Top = 16
      Width = 47
      Height = 17
      Caption = 'Low'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = chkBuyLowClick
    end
  end
  object grdBox2: TDrawGrid
    Left = 8
    Top = 88
    Width = 225
    Height = 41
    ColCount = 6
    DefaultColWidth = 36
    DefaultRowHeight = 36
    DefaultDrawing = False
    Enabled = False
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
    ParentFont = False
    TabOrder = 2
    OnDrawCell = grdBox2DrawCell
    OnMouseDown = grdBox2MouseDown
  end
  object grdBox1: TDrawGrid
    Left = 365
    Top = 88
    Width = 225
    Height = 41
    ColCount = 6
    DefaultColWidth = 36
    DefaultRowHeight = 36
    DefaultDrawing = False
    Enabled = False
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -21
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
    ParentFont = False
    TabOrder = 1
    OnDrawCell = grdBox1DrawCell
    OnMouseDown = grdBox1MouseDown
  end
  object grdStatistic: TStringGrid
    Left = 8
    Top = 190
    Width = 273
    Height = 277
    ColCount = 4
    DefaultColWidth = 58
    DefaultRowHeight = 20
    RowCount = 13
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
    ScrollBars = ssNone
    TabOrder = 8
    OnDrawCell = grdStatisticDrawCell
  end
  object btnWinsOptions: TButton
    Left = 296
    Top = 367
    Width = 169
    Height = 20
    Caption = #1054#1087#1083#1072#1090#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 9
    OnClick = btnWinsOptionsClick
  end
  object txtSum: TEdit
    Left = 161
    Top = 468
    Width = 120
    Height = 20
    AutoSize = False
    BevelKind = bkSoft
    BorderStyle = bsNone
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 10
    Text = '0'
  end
  object btnSavedGames: TButton
    Left = 480
    Top = 448
    Width = 121
    Height = 33
    Caption = #1054#1090#1083#1086#1078#1077#1085#1085#1099#1077
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 11
    TabStop = False
    OnClick = btnSavedGamesClick
  end
  object btnNewGame: TButton
    Left = 480
    Top = 408
    Width = 121
    Height = 33
    Caption = #1053#1086#1074#1072#1103' '#1080#1075#1088#1072
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 12
    TabStop = False
    OnClick = btnNewGameClick
  end
  object btnRazdat: TButton
    Left = 248
    Top = 88
    Width = 105
    Height = 41
    Caption = #1056#1072#1079#1076#1072#1090#1100
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    OnClick = btnRazdatClick
  end
  object btnAnalize: TButton
    Left = 480
    Top = 176
    Width = 121
    Height = 33
    Caption = #1040#1085#1072#1083#1080#1079
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 13
    TabStop = False
    OnClick = btnAnalizeClick
  end
  object btnBestChange: TBitBtn
    Left = 480
    Top = 216
    Width = 121
    Height = 33
    Caption = #1054#1087#1090'. '#1086#1073#1084#1077#1085
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 14
    OnClick = btnBestChangeClick
  end
  object btnBestBuy: TBitBtn
    Left = 480
    Top = 256
    Width = 121
    Height = 33
    Caption = #1048#1089#1089#1083'. '#1087#1086#1082#1091#1087#1082#1080
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 15
    OnClick = btnBestBuyClick
  end
  object btnAuto: TBitBtn
    Left = 480
    Top = 336
    Width = 121
    Height = 33
    Caption = #1040#1074#1090#1086#1084#1072#1090'. '#1080#1075#1088#1072
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 16
    OnClick = btnAutoClick
  end
  object chkDebug: TCheckBox
    Left = 480
    Top = 370
    Width = 121
    Height = 17
    Caption = #1055#1086#1096#1072#1075#1086#1074#1099#1081' '#1088#1077#1078#1080#1084
    Enabled = False
    TabOrder = 17
  end
  object btnEndGame: TButton
    Left = 480
    Top = 408
    Width = 121
    Height = 33
    Caption = #1047#1072#1082#1086#1085#1095#1080#1090#1100' '#1080#1075#1088#1091
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 18
    TabStop = False
    Visible = False
    OnClick = btnEndGameClick
  end
  object chkRussian: TCheckBox
    Left = 296
    Top = 208
    Width = 121
    Height = 17
    Caption = #1056#1091#1089#1089#1082#1080#1081' '#1087#1086#1082#1077#1088
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 19
    OnClick = chkRussianClick
  end
end
