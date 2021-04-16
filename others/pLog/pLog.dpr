program pLog;

uses
  Vcl.Forms,
  uLog in 'uLog.pas' {fLog},
  Vcl.Themes,
  Vcl.Styles,
  uConfig in 'uConfig.pas' {fConfig};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Serial Log';
  TStyleManager.TrySetStyle('Smokey Quartz Kamri');
  Application.CreateForm(TfLog, fLog);
  Application.Run;
end.
