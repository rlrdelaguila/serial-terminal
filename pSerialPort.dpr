program pSerialPort;

uses
  Vcl.Forms,
  uSerialPort in 'uSerialPort.pas' {fSerial},
  Vcl.Themes,
  Vcl.Styles,
  uFileINI in 'uFileINI.pas';

{$R *.res}

begin
	ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Silver');
  Application.CreateForm(TfSerial, fSerial);
  Application.Run;
end.
