unit uFileINI;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Forms, System.IniFiles, CPort;

type
  TFileINI = class(TForm)
    procedure ReadINIFile;
    procedure WriteINIFile;
  end;

var
  uINI: TFileINI;

implementation

uses
  uSerialPort;

{ TFileINI }

procedure TFileINI.ReadINIFile;
begin
  if FileExists(GetCurrentDir + '\pSerialPort.ini') then
  begin
    fSerial.cmpt1.LoadSettings(stIniFile, GetCurrentDir + '\pSerialPort.ini');
    fSerial.btnOpen.Enabled := True;
  end;
end;

procedure TFileINI.WriteINIFile;
begin
  fSerial.cmpt1.StoreSettings(stIniFile, GetCurrentDir + '\pSerialPort.ini');
end;

end.
