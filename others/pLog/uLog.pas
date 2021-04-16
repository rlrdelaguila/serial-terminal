unit uLog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, inifiles,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.ExtCtrls, CPort, IdBaseComponent, IdIntercept, IdLogBase, IdLogFile,
  Vcl.Menus;

type
  TfLog = class(TForm)
    cpSerial: TComPort;
    cpPkt: TComDataPacket;
    mmoLog: TMemo;
    pnl1: TPanel;
    btConfig: TButton;
    btConnection: TButton;
    stt1: TStatusBar;
    pmLog: TPopupMenu;
    Clear1: TMenuItem;
    procedure btConfigClick(Sender: TObject);
    procedure cpPktPacket(Sender: TObject; const Str: string);
    procedure FormCreate(Sender: TObject);
    procedure btConnectionClick(Sender: TObject);
    procedure cpSerialAfterOpen(Sender: TObject);
    procedure cpSerialAfterClose(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mmoLogDblClick(Sender: TObject);
    procedure cpSerialError(Sender: TObject; Errors: TComErrors);
    procedure cpSerialException(Sender: TObject; TComException: TComExceptions;
      ComportMessage: string; WinError: Int64; WinMessage: string);
    procedure Clear1Click(Sender: TObject);
  private
    procedure showMessage(Str: string);
    procedure savetoFile_(msg: string);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fLog: TfLog;
  InicioMSG: string = '!';
  FimMSG: string = '#';
  _Nome: string = 'ghost';
  inifile: string;

implementation

uses
  uConfig;

{$R *.dfm}

procedure TfLog.btConfigClick(Sender: TObject);
begin
  try
    fConfig := TfConfig.Create(self);

    case fConfig.ShowModal of
      mrOK:
        begin
          cpPkt.StartString := fConfig.edtInicioMessage.Text;
          cpPkt.StopString := fConfig.edtFimMessage.Text;
          cpPkt.ComPort := cpSerial;
          _Nome := fConfig.edtNome.Text;
        end;
      mrCancel, mrClose:
        begin

        end;
    end;
  finally
    FreeAndNil(fConfig);
  end;
end;

procedure TfLog.btConnectionClick(Sender: TObject);
begin
  if not cpSerial.Connected then
  begin
    cpSerial.Open;
  end
  else
  begin
    cpSerial.Close;
  end;
end;

procedure TfLog.Clear1Click(Sender: TObject);
begin
  mmoLog.Lines.Clear;
end;

procedure TfLog.cpPktPacket(Sender: TObject; const Str: string);
begin
  showMessage(Str);
end;

procedure TfLog.cpSerialAfterClose(Sender: TObject);
begin
  btConnection.Caption := 'Conectar';
  btConfig.Enabled := True;
  stt1.Panels[1].Text := 'Desconnectado';
end;

procedure TfLog.cpSerialAfterOpen(Sender: TObject);
begin
  btConnection.Caption := 'Desconectar';
  btConfig.Enabled := False;
  stt1.Panels[1].Text := 'Connectado (' + cpSerial.Port + ')';
end;

procedure TfLog.cpSerialError(Sender: TObject; Errors: TComErrors);
begin
  if cpSerial.Connected then
    cpSerial.Close;
end;

procedure TfLog.cpSerialException(Sender: TObject;
  TComException: TComExceptions; ComportMessage: string; WinError: Int64;
  WinMessage: string);
begin
  if cpSerial.Connected then
    cpSerial.Close;
end;

procedure TfLog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if cpSerial.Connected then
  begin
    cpSerial.Close;
  end;

  Application.Terminate;
end;

procedure TfLog.FormCreate(Sender: TObject);
var
  ini: TIniFile;
begin
  inifile := GetCurrentDir + '\pLog.ini';

  if FileExists(inifile) then
  begin
    cpSerial.LoadSettings(stIniFile, inifile);
    ini := TIniFile.Create(inifile);
    cpPkt.StartString := ini.ReadString('Configs', 'InicioMSG', '!');
    cpPkt.StopString := ini.ReadString('Configs', 'FimMSG', '#');
    _Nome := ini.ReadString('Configs', 'Name', 'ghost');
    cpPkt.ComPort := cpSerial;
    ini.free;
    btConnection.Enabled := True;
  end;
end;

procedure TfLog.mmoLogDblClick(Sender: TObject);
begin
  // mmoLog.Lines.Clear;
end;

procedure TfLog.savetoFile_(msg: string);
var
  path: string;
  folder, nfile: string;
  arq: TextFile;
begin
  folder := GetCurrentDir + '\logs\' + _Nome;
  nfile := FormatDateTime('YYYMMdd', now) + '.log';
  path := folder + '\' + nfile;
  fLog.Caption := 'Serial Log - File: ' + path;

  if not DirectoryExists(folder) then
    ForceDirectories(folder);

  AssignFile(arq, path);

  if not FileExists(path) then
  begin
    Rewrite(arq);
  end
  else
    Append(arq);

  Writeln(arq, msg);
  CloseFile(arq);
end;

procedure TfLog.showMessage(Str: string);
begin
  TThread.CreateAnonymousThread(
    procedure
    var
      msg, Text: string;
    begin
      msg := Str;
      Text := '[' + FormatDateTime('HH:mm:ss', now) + '] - ' + Str;
      mmoLog.Lines.Add(Text);
      savetoFile_(Text);
    end).start();
end;

end.
