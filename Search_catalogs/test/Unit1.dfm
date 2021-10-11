object Form1: TForm1
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsDialog
  Caption = 'Form1'
  ClientHeight = 147
  ClientWidth = 383
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 7
    Top = 8
    Width = 32
    Height = 13
    Caption = #1044#1086#1084#1077#1085
  end
  object Label2: TLabel
    Left = 124
    Top = 31
    Width = 93
    Height = 13
    Caption = #1057#1086#1089#1090#1086#1103#1085#1080#1077' '#1087#1086#1090#1086#1082#1072
  end
  object Label3: TLabel
    Left = 280
    Top = 31
    Width = 53
    Height = 13
    Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090
  end
  object Label4: TLabel
    Left = 156
    Top = 50
    Width = 12
    Height = 13
    Caption = '---'
  end
  object Label5: TLabel
    Left = 156
    Top = 73
    Width = 12
    Height = 13
    Caption = '---'
  end
  object Label6: TLabel
    Left = 156
    Top = 96
    Width = 12
    Height = 13
    Caption = '---'
  end
  object Label7: TLabel
    Left = 292
    Top = 50
    Width = 12
    Height = 13
    Caption = '---'
  end
  object Label8: TLabel
    Left = 292
    Top = 73
    Width = 12
    Height = 13
    Caption = '---'
  end
  object Label9: TLabel
    Left = 292
    Top = 96
    Width = 12
    Height = 13
    Caption = '---'
  end
  object Edit1: TEdit
    Left = 44
    Top = 4
    Width = 333
    Height = 21
    TabOrder = 0
    Text = 'webdelphi.ru'
  end
  object CheckBox1: TCheckBox
    Left = 8
    Top = 48
    Width = 97
    Height = 17
    Caption = #1071#1085#1076#1077#1082#1089'.'#1050#1072#1090#1072#1083#1086#1075
    TabOrder = 1
  end
  object CheckBox2: TCheckBox
    Left = 8
    Top = 71
    Width = 97
    Height = 17
    Caption = 'DMOZ'
    TabOrder = 2
  end
  object CheckBox3: TCheckBox
    Left = 8
    Top = 94
    Width = 97
    Height = 17
    Caption = 'Yahoo Directory'
    TabOrder = 3
  end
  object Button1: TButton
    Left = 96
    Top = 117
    Width = 75
    Height = 25
    Caption = #1055#1088#1086#1074#1077#1088#1080#1090#1100
    TabOrder = 4
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 177
    Top = 116
    Width = 75
    Height = 25
    Caption = #1055#1088#1077#1088#1074#1072#1090#1100' '
    TabOrder = 5
    OnClick = Button2Click
  end
  object SearchCatalogs1: TSearchCatalogs
    Options.Yandex = False
    Options.DMOZ = False
    Options.YahooDir = False
    OnAcceptData = SearchCatalogs1AcceptData
    OnGiveYandex = SearchCatalogs1GiveYandex
    OnGiveDMOZ = SearchCatalogs1GiveDMOZ
    OnGiveYahoo = SearchCatalogs1GiveYahoo
    OnStopYandex = SearchCatalogs1StopYandex
    OnStopDMOZ = SearchCatalogs1StopDMOZ
    OnStopYahooDir = SearchCatalogs1StopYahooDir
    OnStartYandex = SearchCatalogs1StartYandex
    OnStartDMOZ = SearchCatalogs1StartDMOZ
    OnStartYahooDir = SearchCatalogs1StartYahooDir
    Left = 208
    Top = 58
  end
end
