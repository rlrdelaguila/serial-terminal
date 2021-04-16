object fConfig: TfConfig
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = 'Configura'#231#245'es'
  ClientHeight = 243
  ClientWidth = 230
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object grp1: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 224
    Height = 54
    Align = alTop
    Caption = 'Conex'#227'o'
    TabOrder = 0
    object btSetup: TButton
      AlignWithMargins = True
      Left = 22
      Top = 20
      Width = 180
      Height = 25
      Margins.Left = 20
      Margins.Top = 5
      Margins.Right = 20
      Margins.Bottom = 7
      Align = alClient
      Caption = 'Porta'
      TabOrder = 0
      OnClick = btSetupClick
    end
  end
  object pnl1: TPanel
    Left = 0
    Top = 209
    Width = 230
    Height = 34
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btCancel: TButton
      AlignWithMargins = True
      Left = 10
      Top = 3
      Width = 90
      Height = 26
      Margins.Left = 10
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'Cancelar'
      ModalResult = 2
      TabOrder = 0
    end
    object btSave: TButton
      AlignWithMargins = True
      Left = 130
      Top = 3
      Width = 90
      Height = 26
      Margins.Right = 10
      Margins.Bottom = 5
      Align = alRight
      Caption = 'Salvar'
      ModalResult = 1
      TabOrder = 1
      OnClick = btSaveClick
    end
  end
  object grp2: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 63
    Width = 224
    Height = 72
    Align = alTop
    Caption = 'Mensagem'
    TabOrder = 2
    object lbl1: TLabel
      Left = 22
      Top = 21
      Width = 98
      Height = 13
      Caption = 'In'#237'cio da Mensagem:'
    end
    object lbl2: TLabel
      Left = 31
      Top = 45
      Width = 89
      Height = 13
      Caption = 'Fim da Mensagem:'
    end
    object edtInicioMessage: TEdit
      Left = 153
      Top = 17
      Width = 41
      Height = 21
      Alignment = taCenter
      TabOrder = 0
      Text = '!'
    end
    object edtFimMessage: TEdit
      Left = 153
      Top = 44
      Width = 41
      Height = 21
      Alignment = taCenter
      TabOrder = 1
      Text = '#'
    end
  end
  object grp3: TGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 141
    Width = 224
    Height = 65
    Align = alClient
    Caption = 'Nome'
    TabOrder = 3
    object lbl3: TLabel
      Left = 2
      Top = 15
      Width = 220
      Height = 13
      Align = alTop
      Alignment = taCenter
      Caption = 'Nome do log:'
      ExplicitWidth = 63
    end
    object edtNome: TEdit
      AlignWithMargins = True
      Left = 12
      Top = 31
      Width = 200
      Height = 21
      Margins.Left = 10
      Margins.Right = 10
      Align = alTop
      Alignment = taCenter
      TabOrder = 0
      Text = 'ghost'
    end
  end
end
