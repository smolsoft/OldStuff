object frmMain: TfrmMain
  Left = 312
  Top = 92
  Width = 685
  Height = 626
  ActiveControl = grdWins
  Caption = 'Poker Calc'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  DesignSize = (
    677
    599)
  PixelsPerInch = 96
  TextHeight = 16
  object grpSource: TGroupBox
    Left = 0
    Top = 0
    Width = 305
    Height = 599
    Align = alLeft
    Caption = #1048#1089#1093#1086#1076#1085#1099#1077' '#1076#1072#1085#1085#1099#1077':'
    Constraints.MaxWidth = 305
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object lblDealer: TLabel
      Left = 24
      Top = 44
      Width = 47
      Height = 16
      Alignment = taRightJustify
      Caption = #1044#1080#1083#1077#1088' :'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblPlayer: TLabel
      Left = 26
      Top = 76
      Width = 45
      Height = 16
      Alignment = taRightJustify
      Caption = #1048#1075#1088#1086#1082' :'
    end
    object lblCards: TLabel
      Left = 72
      Top = 24
      Width = 43
      Height = 16
      Caption = #1050#1072#1088#1090#1099':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblAnteCost1: TLabel
      Left = 8
      Top = 475
      Width = 70
      Height = 16
      Caption = #1057#1090#1086#1080#1084#1086#1089#1090#1100
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblWinTable: TLabel
      Left = 8
      Top = 104
      Width = 136
      Height = 16
      Caption = #1058#1072#1073#1083#1080#1094#1072' '#1074#1099#1080#1075#1088#1099#1096#1077#1081':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblExCards: TLabel
      Left = 160
      Top = 104
      Width = 51
      Height = 16
      Caption = #1050#1086#1083#1086#1076#1072':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblAnteCost2: TLabel
      Left = 26
      Top = 488
      Width = 52
      Height = 16
      Caption = #1086#1073#1084#1077#1085#1072':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblNumGames2: TLabel
      Left = 172
      Top = 488
      Width = 50
      Height = 16
      Caption = #1088#1072#1089#1076#1072#1095':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblNumGames1: TLabel
      Left = 141
      Top = 475
      Width = 78
      Height = 16
      Caption = #1050#1086#1083#1080#1095#1077#1089#1090#1074#1086
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblCardsCount1: TLabel
      Left = 240
      Top = 19
      Width = 40
      Height = 16
      Caption = '6 '#1082#1072#1088#1090
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object Bevel1: TBevel
      Left = 8
      Top = 472
      Width = 289
      Height = 9
      Shape = bsTopLine
    end
    object lblCardsNum: TLabel
      Left = 160
      Top = 424
      Width = 128
      Height = 16
      Caption = #1048#1089#1082#1083'./'#1074' '#1082#1086#1083#1086#1076#1077': 0/52'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object grdPlayCards: TDrawGrid
      Left = 72
      Top = 40
      Width = 189
      Height = 58
      DefaultColWidth = 36
      DefaultRowHeight = 26
      DefaultDrawing = False
      FixedCols = 0
      RowCount = 2
      FixedRows = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
      ParentFont = False
      ScrollBars = ssNone
      TabOrder = 0
      OnDblClick = grdPlayCardsDblClick
      OnDrawCell = grdPlayCardsDrawCell
      OnKeyDown = grdPlayCardsKeyDown
      OnKeyPress = grdPlayCardsKeyPress
      OnMouseDown = grdPlayCardsMouseDown
    end
    object txtExChange: TEdit
      Left = 80
      Top = 478
      Width = 41
      Height = 24
      TabOrder = 1
      Text = '1'
      OnChange = txtExChangeChange
    end
    object grdExCards: TDrawGrid
      Left = 160
      Top = 120
      Width = 137
      Height = 303
      ColCount = 4
      DefaultColWidth = 32
      DefaultRowHeight = 22
      DefaultDrawing = False
      FixedCols = 0
      RowCount = 13
      FixedRows = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsItalic]
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
      ParentFont = False
      ScrollBars = ssNone
      TabOrder = 2
      OnDrawCell = grdExCardsDrawCell
      OnMouseDown = grdExCardsMouseDown
    end
    object grdWins: TStringGrid
      Left = 8
      Top = 144
      Width = 137
      Height = 234
      ColCount = 2
      DefaultColWidth = 36
      DefaultRowHeight = 22
      RowCount = 11
      FixedRows = 0
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goEditing, goAlwaysShowEditor]
      ParentFont = False
      ScrollBars = ssNone
      TabOrder = 3
      RowHeights = (
        17
        17
        17
        17
        22
        22
        22
        22
        22
        22
        22)
    end
    object txtNNN: TEdit
      Left = 224
      Top = 478
      Width = 73
      Height = 24
      MaxLength = 20
      TabOrder = 4
      Text = '500000'
      OnChange = txtNNNChange
    end
    object chk6Cards: TCheckBox
      Left = 284
      Top = 15
      Width = 17
      Height = 25
      Caption = 'chk6Cards'
      TabOrder = 5
      OnClick = chk6CardsClick
    end
    object btnStart: TButton
      Left = 8
      Top = 408
      Width = 137
      Height = 28
      Caption = #1053#1072#1095#1072#1090#1100
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'MS Sans Serif'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 6
      OnClick = btnStartClick
    end
    object GroupBox1: TGroupBox
      Left = 136
      Top = 512
      Width = 161
      Height = 82
      Caption = '    '#1048#1075#1088#1072#1090#1100' '
      Color = clBtnFace
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      TabOrder = 7
      object grdPlayWhen: TDrawGrid
        Left = 4
        Top = 50
        Width = 121
        Height = 29
        ColCount = 4
        DefaultColWidth = 28
        DefaultDrawing = False
        FixedCols = 0
        FixedRows = 0
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBlack
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = [fsBold]
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine]
        ParentFont = False
        ScrollBars = ssNone
        TabOrder = 0
        OnDrawCell = grdPlayWhenDrawCell
        OnKeyDown = grdPlayWhenKeyDown
        OnKeyPress = grdPlayWhenKeyPress
      end
      object chkPlayAlways: TRadioButton
        Left = 2
        Top = 16
        Width = 79
        Height = 17
        Caption = #1042#1089#1077#1075#1076#1072
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        TabStop = True
        OnClick = chkPlayWhenClick
      end
      object chkPlayWhen: TRadioButton
        Left = 2
        Top = 32
        Width = 151
        Height = 17
        Caption = #1055#1088#1080' '#1085#1072#1083#1080#1095#1080#1080
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = chkPlayWhenClick
      end
    end
    object GroupBox2: TGroupBox
      Left = 8
      Top = 512
      Width = 113
      Height = 82
      Caption = '    '#1052#1080#1085#1080#1084'. '#1080#1075#1088#1072
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clMaroon
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      object chkMin22: TRadioButton
        Left = 2
        Top = 24
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
        Top = 48
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
    object btnClear: TButton
      Left = 160
      Top = 440
      Width = 137
      Height = 25
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
      OnClick = btnClearClick
    end
    object cmbChange: TComboBox
      Left = 8
      Top = 120
      Width = 137
      Height = 21
      AutoDropDown = True
      Style = csDropDownList
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ItemHeight = 13
      ParentFont = False
      TabOrder = 10
      OnChange = cmbChangeChange
      Items.Strings = (
        #1041#1077#1079' '#1086#1073#1084#1077#1085#1072
        #1054#1073#1084#1077#1085' 1-'#1081
        #1054#1073#1084#1077#1085' 2-'#1093
        #1054#1073#1084#1077#1085' 3-'#1093
        #1054#1073#1084#1077#1085' 4-'#1093
        #1054#1073#1084#1077#1085' 5-'#1080
        #1055#1088#1080#1082#1091#1087' 6-'#1081)
    end
    object btnBestChange: TButton
      Left = 8
      Top = 440
      Width = 137
      Height = 25
      Caption = #1054#1087#1090#1080#1084#1072#1083#1100#1085#1099#1081' '#1086#1073#1084#1077#1085
      Default = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      TabOrder = 11
      OnClick = btnBestChangeClick
    end
    object chkRussian: TCheckBox
      Left = 8
      Top = 384
      Width = 137
      Height = 17
      Caption = #171#1056#1091#1089#1089#1082#1080#1081' '#1087#1086#1082#1077#1088#187
      TabOrder = 12
      OnClick = chkRussianClick
    end
  end
  object grpResults: TGroupBox
    Left = 312
    Top = 0
    Width = 365
    Height = 598
    Anchors = [akLeft, akTop, akRight, akBottom]
    Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090#1099':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    DesignSize = (
      365
      598)
    object lblAnteEx: TLabel
      Left = 8
      Top = 120
      Width = 110
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Caption = 'Ante/'#1089#1076#1072#1095#1091':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblWins: TLabel
      Left = 8
      Top = 96
      Width = 110
      Height = 16
      AutoSize = False
      Caption = #1042#1099#1080#1075#1088#1099#1096' '#1080#1075#1088#1086#1082#1072':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblWinsValue: TLabel
      Left = 120
      Top = 96
      Width = 3
      Height = 16
    end
    object lblTime: TLabel
      Left = 8
      Top = 42
      Width = 3
      Height = 16
    end
    object lblEx: TLabel
      Left = 8
      Top = 72
      Width = 110
      Height = 16
      Alignment = taRightJustify
      AutoSize = False
      Caption = #1056#1072#1079#1076#1072#1095':'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
    end
    object lblExCount: TLabel
      Left = 120
      Top = 72
      Width = 3
      Height = 16
    end
    object lblAnteValue: TLabel
      Left = 120
      Top = 120
      Width = 3
      Height = 16
    end
    object grdCombo: TStringGrid
      Left = 2
      Top = 142
      Width = 361
      Height = 280
      Anchors = [akLeft, akTop, akRight]
      DefaultColWidth = 65
      DefaultRowHeight = 22
      RowCount = 12
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goColMoving]
      ParentFont = False
      ScrollBars = ssNone
      TabOrder = 0
      RowHeights = (
        22
        22
        22
        22
        22
        22
        22
        22
        22
        22
        22
        22)
    end
    object ProgressBar: TProgressBar
      Left = 8
      Top = 18
      Width = 350
      Height = 22
      Anchors = [akLeft, akTop, akRight]
      Min = 0
      Max = 100
      Smooth = True
      TabOrder = 1
    end
    object grdMem: TStringGrid
      Left = 2
      Top = 424
      Width = 361
      Height = 172
      Align = alBottom
      Anchors = [akLeft, akTop, akRight, akBottom]
      DefaultColWidth = 60
      DefaultRowHeight = 22
      RowCount = 7
      FixedRows = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSizing, goColSizing, goEditing, goAlwaysShowEditor]
      PopupMenu = popResults
      ScrollBars = ssNone
      TabOrder = 2
      OnDblClick = grdMemDblClick
    end
  end
  object popResults: TPopupMenu
    Left = 600
    Top = 56
    object N1: TMenuItem
      Caption = #1054#1095#1080#1089#1090#1080#1090#1100
      OnClick = N1Click
    end
  end
  object Timer: TTimer
    Interval = 0
    OnTimer = TimerTimer
    Left = 272
    Top = 88
  end
end
