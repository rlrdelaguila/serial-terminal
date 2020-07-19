unit uSerialPort;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls, CPort,
  Vcl.Menus, Vcl.ComCtrls, CPortCtl, Vcl.StdCtrls, System.ImageList,
  Vcl.ImgList, System.UITypes;

type
  TfSerial = class(TForm)
    pnlMenu: TPanel;
    btnSetupPort: TSpeedButton;
    btnOpen: TSpeedButton;
    btnExit: TSpeedButton;
    cmpt1: TComPort;
    pnlCorpo: TPanel;
    pnlLuzes: TPanel;
    cmld1: TComLed;
    cmld2: TComLed;
    cmld3: TComLed;
    cmld4: TComLed;
    cmld5: TComLed;
    cmld6: TComLed;
    cmld7: TComLed;
    pnlMSG: TPanel;
    mmoRecebidas: TMemo;
    spl1: TSplitter;
    mmoEnviadas: TMemo;
    btnSend: TButton;
    edtDados: TEdit;
    sttStatus: TStatusBar;
    procedure close(Sender: TObject);
    procedure About(Sender: TObject);
    procedure Setup(Sender: TObject);
    procedure Open(Sender: TObject);
    procedure SendData(Sender: TObject);
    procedure ReceiveData(Sender: TObject; Count: Integer);
    procedure clean(Sender: TObject);

    procedure Mensagem(str: string);
    function connect(status: Boolean): Boolean;
    function Buttons(status: Boolean): Boolean;
    procedure EscreveDadosRecebidos(str: String);
    procedure EscreveDadosEnviados(str: String);
    procedure edtDadosKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cmpt1Error(Sender: TObject; Errors: TComErrors);
    procedure cmpt1Exception(Sender: TObject; TComException: TComExceptions;
      ComportMessage: string; WinError: Int64; WinMessage: string);
    procedure FormCreate(Sender: TObject);
    procedure mmoRecebidasDblClick(Sender: TObject);
    procedure LimpaMemoria;
    procedure mmoEnviadasDblClick(Sender: TObject);
  private

    { Private declarations }
  public
    { Public declarations }
  end;

var
  fSerial: TfSerial;
  nHistorico: Integer = -1;
  Connected: Boolean = False;

implementation

uses
  uFileINI;

{$R *.dfm}
{ TForm1 }

procedure TfSerial.LimpaMemoria;
var
  MainHandle: THandle;
begin
  try
    MainHandle := OpenProcess(PROCESS_ALL_ACCESS, False, GetCurrentProcessID);
    SetProcessWorkingSetSize(MainHandle, $FFFFFFFF, $FFFFFFFF);
    CloseHandle(MainHandle);
  except
  end;
  Application.ProcessMessages;
end;

procedure TfSerial.clean(Sender: TObject);
begin
  edtDados.Text := '';
  mmoEnviadas.Lines.Clear;
  mmoRecebidas.Lines.Clear;
  nHistorico := -1;
end;

procedure TfSerial.close(Sender: TObject);
begin
  if cmpt1.Connected then
    connect(False);
  Application.Terminate;
end;

procedure TfSerial.cmpt1Error(Sender: TObject; Errors: TComErrors);
begin
  Mensagem('Erro.');
end;

procedure TfSerial.cmpt1Exception(Sender: TObject;
  TComException: TComExceptions; ComportMessage: string; WinError: Int64;
  WinMessage: string);
begin
  // ShowMessage('WinError: ' + WinError.ToString);
  case WinError of
    2, 5, 123:
      begin
        btnOpen.Enabled := False;
        Mensagem('Exception.');
        EscreveDadosRecebidos(WinMessage);
        Connected := False;

        {
          --
          Erros:
          2 - Quando ele leu uma porta salva no arquivo ini porém não existe agora;
          5 - Quando já tem alguém conectado na porta;
          123 - Quando o usuário abriu a janela de setup do comport e deixou o campo port vazio;
          --
        }
      end;
  end;
end;

procedure TfSerial.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if cmpt1.Connected then
    connect(False);
end;

procedure TfSerial.FormCreate(Sender: TObject);
begin
  uINI.ReadINIFile;
  LimpaMemoria;
end;

{ ------------------------------------------------------- Funções Abrir/Fechar Porta ------------------------------------------------------- }

procedure TfSerial.Setup(Sender: TObject);
begin
  cmpt1.ShowSetupDialog;
  btnOpen.Enabled := True;
end;

procedure TfSerial.Open(Sender: TObject);
begin
  if cmpt1.Connected then
  begin
    if not connect(False) then
    begin
      sttStatus.Panels[1].Text := 'Disconnected';
      sttStatus.Panels[2].Text := '';
      btnOpen.Caption := 'Connect';
      LimpaMemoria;
    end
    else
      Mensagem('Erro ao desconectar!');
  end
  else
  begin
    try
      if connect(True) then
      begin
        sttStatus.Panels[1].Text := 'Connected (' + cmpt1.Port + ')';
        sttStatus.Panels[2].Text := '';
        btnOpen.Caption := 'Disconnect';
        uINI.WriteINIFile;
      end
      else
        Mensagem('Erro ao conectar!');
    except
      btnOpen.Enabled := False;
    end;
  end;
end;

function TfSerial.connect(status: Boolean): Boolean;
begin
  Connected := status;
  if status then
  begin
    cmpt1.Open;

    if not Connected then
    begin
      cmpt1.close;
    end;
  end
  else
    cmpt1.close;

  Result := Buttons(Connected);
end;

function TfSerial.Buttons(status: Boolean): Boolean;
begin
  if status then
  begin
    btnSetupPort.Enabled := False;
    btnSend.Enabled := True;
  end
  else
  begin
    btnSetupPort.Enabled := True;
    btnSend.Enabled := False;
  end;

  Result := status;
end;

{ ----------------------------------------------------- Fim Funções Abrir/Fechar Porta ----------------------------------------------------- }

{ ------------------------------------------------------- Funções Envia/Recebe Dados ------------------------------------------------------- }

procedure TfSerial.ReceiveData(Sender: TObject; Count: Integer);
var
  cnt: Integer;
  str: string;
begin
  cnt := cmpt1.InputCount;
  cmpt1.ReadStr(str, cnt);
  EscreveDadosRecebidos(str);
  Mensagem('Dados Recebidos');
end;

procedure TfSerial.SendData(Sender: TObject);
var
  str: string;
  function PegaDado: String;
  begin
    Result := edtDados.Text;
    edtDados.Text := '';
  end;

begin
  try
    str := PegaDado;
    if (not str.IsEmpty) then
    begin
      if cmpt1.WriteStr(str) <> 0 then
      begin
        EscreveDadosEnviados(str);
        Mensagem('Dados Enviados');
        nHistorico := mmoEnviadas.Lines.Count - 1;
      end
      else
        Mensagem('Digite algo');
    end
    else
      Mensagem('Digite algo');
  except
    on E: Exception do
    begin
      Mensagem('Erro ao enviar mensagem - ' + E.Message);
      // conection(False);
    end;
  end;
end;

procedure TfSerial.edtDadosKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  str: string;
  ini, fim: Integer;
begin
  // ShowMessage('Key: ' + Key.ToString);
  case Key of
    13: { 13 - ENTER }
      begin
        btnSend.Click;
      end;
    38: { 38 - Seta para Cima }
      begin
        if nHistorico >= 0 then
        begin
          str := mmoEnviadas.Lines[nHistorico];
          ini := Pos('-', str) + 2;
          fim := Length(str);
          edtDados.Text := Copy(str, ini, fim);

          if nHistorico > 0 then
            nHistorico := nHistorico - 1;
        end;
        edtDados.SelStart := Length(edtDados.Text);
      end;
    40: { 40 - Seta para Baixo }
      begin
        if (nHistorico < mmoEnviadas.Lines.Count - 1) then
        begin
          nHistorico := nHistorico + 1;
          str := mmoEnviadas.Lines[nHistorico];
          ini := Pos('-', str) + 2;
          fim := Length(str);
          edtDados.Text := Copy(str, ini, fim);
        end
        else if (nHistorico = mmoEnviadas.Lines.Count - 1) then
        begin
          edtDados.Text := '';
        end;
        edtDados.SelStart := Length(edtDados.Text);
      end;
  end;
end;

procedure TfSerial.EscreveDadosEnviados(str: String);
begin
  mmoEnviadas.Lines.Add(FormatDateTime('HH:mm:ss', now) + ' - ' + str);
end;

procedure TfSerial.EscreveDadosRecebidos(str: String);
begin
  mmoRecebidas.Lines.Add(FormatDateTime('HH:mm:ss', now) + ' - ' + str);
end;

{ ---------------------------------------------------- Fim Funções Envia/Recebe Mensagem --------------------------------------------------- }

procedure TfSerial.Mensagem(str: string);
begin
  TThread.CreateAnonymousThread(
    procedure
    begin
      fSerial.sttStatus.Panels.Items[2].Text := str;
      sleep(500);
      fSerial.sttStatus.Panels.Items[2].Text := '';
    end).start();
end;

procedure TfSerial.mmoEnviadasDblClick(Sender: TObject);
begin
  mmoEnviadas.Lines.Clear;
end;

procedure TfSerial.mmoRecebidasDblClick(Sender: TObject);
begin
  mmoRecebidas.Lines.Clear;
end;

procedure TfSerial.About(Sender: TObject);
begin
  MessageDlg('Author: Raul del Aguila' + #13 + 'Update: 2.0 - 21/05/2019',
    mtInformation, [mbOK], 0);
end;

end.
