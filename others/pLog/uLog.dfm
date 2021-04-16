object fLog: TfLog
  Left = 0
  Top = 0
  Caption = 'Serial Log'
  ClientHeight = 300
  ClientWidth = 650
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 650
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object mmoLog: TMemo
    AlignWithMargins = True
    Left = 5
    Top = 50
    Width = 640
    Height = 223
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alClient
    PopupMenu = pmLog
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
    OnDblClick = mmoLogDblClick
  end
  object pnl1: TPanel
    AlignWithMargins = True
    Left = 5
    Top = 5
    Width = 640
    Height = 35
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object btConfig: TButton
      AlignWithMargins = True
      Left = 3
      Top = 3
      Width = 145
      Height = 29
      Align = alLeft
      Caption = 'Configurar'
      TabOrder = 0
      OnClick = btConfigClick
    end
    object btConnection: TButton
      AlignWithMargins = True
      Left = 492
      Top = 3
      Width = 145
      Height = 29
      Align = alRight
      Caption = 'Conectar'
      Enabled = False
      TabOrder = 1
      OnClick = btConnectionClick
    end
  end
  object stt1: TStatusBar
    AlignWithMargins = True
    Left = 0
    Top = 281
    Width = 650
    Height = 19
    Margins.Left = 0
    Margins.Right = 0
    Margins.Bottom = 0
    Panels = <
      item
        Text = 'Status:'
        Width = 50
      end
      item
        Text = 'Desconectado'
        Width = 50
      end>
  end
  object cpSerial: TComPort
    BaudRate = br9600
    Port = 'COM1'
    Parity.Bits = prNone
    StopBits = sbOneStopBit
    DataBits = dbEight
    Events = [evRxChar, evTxEmpty, evRxFlag, evRing, evBreak, evCTS, evDSR, evError, evRLSD, evRx80Full]
    FlowControl.OutCTSFlow = False
    FlowControl.OutDSRFlow = False
    FlowControl.ControlDTR = dtrDisable
    FlowControl.ControlRTS = rtsDisable
    FlowControl.XonXoffOut = False
    FlowControl.XonXoffIn = False
    StoredProps = [spBasic]
    TriggersOnRxChar = False
    OnAfterOpen = cpSerialAfterOpen
    OnAfterClose = cpSerialAfterClose
    OnError = cpSerialError
    OnException = cpSerialException
    Left = 232
    Top = 8
  end
  object cpPkt: TComDataPacket
    ComPort = cpSerial
    StartString = '!'
    StopString = '#'
    OnPacket = cpPktPacket
    Left = 320
    Top = 8
  end
  object pmLog: TPopupMenu
    Left = 320
    Top = 152
    object Clear1: TMenuItem
      Caption = 'Clear'
      ShortCut = 49219
      OnClick = Clear1Click
    end
  end
end
