object fmControls: TfmControls
  Left = 267
  Top = 163
  ActiveControl = eRotate
  BorderStyle = bsDialog
  Caption = 'Настройки'
  ClientHeight = 179
  ClientWidth = 264
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object gbKeys: TGroupBox
    Left = 8
    Top = 8
    Width = 241
    Height = 121
    Caption = 'Клавиши управления'
    TabOrder = 0
    object lLeft: TLabel
      Left = 16
      Top = 24
      Width = 38
      Height = 13
      Caption = 'Налево'
    end
    object lRight: TLabel
      Left = 16
      Top = 48
      Width = 44
      Height = 13
      Caption = 'Направо'
    end
    object lDown: TLabel
      Left = 16
      Top = 72
      Width = 25
      Height = 13
      Caption = 'Вниз'
    end
    object lRotate: TLabel
      Left = 16
      Top = 96
      Width = 54
      Height = 13
      Caption = 'Повернуть'
    end
    object eLeft: TEdit
      Tag = 1
      Left = 80
      Top = 16
      Width = 153
      Height = 21
      ReadOnly = True
      TabOrder = 0
      OnKeyUp = eLeftKeyUp
    end
    object eRight: TEdit
      Tag = 2
      Left = 80
      Top = 40
      Width = 153
      Height = 21
      ReadOnly = True
      TabOrder = 1
      OnKeyUp = eLeftKeyUp
    end
    object eDown: TEdit
      Tag = 3
      Left = 80
      Top = 64
      Width = 153
      Height = 21
      ReadOnly = True
      TabOrder = 2
      OnKeyUp = eLeftKeyUp
    end
    object eRotate: TEdit
      Tag = 4
      Left = 80
      Top = 88
      Width = 153
      Height = 21
      ReadOnly = True
      TabOrder = 3
      OnKeyUp = eLeftKeyUp
    end
  end
  object btnCancel: TButton
    Left = 96
    Top = 144
    Width = 75
    Height = 25
    Caption = '&Отмена'
    ModalResult = 2
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object btnOk: TButton
    Left = 176
    Top = 144
    Width = 75
    Height = 25
    Caption = 'OK'
    ModalResult = 1
    TabOrder = 2
  end
end
