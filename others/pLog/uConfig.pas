unit uConfig;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, CPort, inifiles,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfConfig = class(TForm)
    grp1: TGroupBox;
    btSetup: TButton;
    pnl1: TPanel;
    btCancel: TButton;
    btSave: TButton;
    grp2: TGroupBox;
    lbl1: TLabel;
    lbl2: TLabel;
    edtInicioMessage: TEdit;
    edtFimMessage: TEdit;
    grp3: TGroupBox;
    lbl3: TLabel;
    edtNome: TEdit;
    procedure btSetupClick(Sender: TObject);
    procedure btSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fConfig: TfConfig;

implementation

uses
  uLog;

{$R *.dfm}

procedure TfConfig.btSetupClick(Sender: TObject);
begin
  fLog.cpSerial.ShowSetupDialog;
end;

procedure TfConfig.FormCreate(Sender: TObject);
begin
  edtNome.Text := _Nome;
  edtInicioMessage.Text := fLog.cpPkt.StartString;
  edtFimMessage.Text := fLog.cpPkt.StopString;
end;

procedure TfConfig.btSaveClick(Sender: TObject);
var
  ini: TIniFile;
begin
  fLog.cpSerial.StoreSettings(stIniFile, inifile);
  ini := TIniFile.Create(inifile);
  ini.WriteString('Configs', 'InicioMSG', edtInicioMessage.Text);
  ini.WriteString('Configs', 'FimMSG', edtFimMessage.Text);
  ini.WriteString('Configs', 'Name', edtNome.Text);
  ini.free;
  fLog.btConnection.Enabled := True;
end;

end.
