{
  -------------------------------------------------------------------------------
  Projeto......: Consulta de NCM x CEST por UF (SP, MT, PR)
  Desenvolvedor: Francisco [Engenheiro de Software]
  Linguagem....: Pascal (Lazarus / Free Pascal)
  Data.........: 04/07/2025

  Descrição....:
    Este projeto realiza a consulta automática de tabelas públicas de NCM x CEST
    diretamente do site https://tributei.net, separadas por Unidade Federativa.
    A aplicação utiliza requisições HTTP para acessar os dados publicados em:
      - São Paulo (SP)
      - Mato Grosso (MT)
      - Paraná (PR)

    Os dados são públicos e não há qualquer tipo de violação de acesso ou uso,
    pois são os mesmos disponibilizados no blog da Tributei, via navegador.

    Toda a consulta é feita em tempo real, sem armazenamento local.

  Repositório..: https://github.com/fraurino/Tabela-CEST-X-NCM-de-Tributei.net/tree/main

  Licença......: Código aberto (MIT)
  Contato......: [98988923379]

  -------------------------------------------------------------------------------
}



unit uTabelaCESTNCMinMT;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, ExtCtrls, LCLIntf,
  StdCtrls, IdHTTP,IdSSLOpenSSL, IdSSL, fpjson, jsonparser;

type

  { TfrmCESTNCM }

  TfrmCESTNCM = class(TForm)
    Button1: TButton;
    Button2: TButton;
    estados: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    total: TLabel;
    Panel1: TPanel;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure estadosChange(Sender: TObject);
    procedure Label3Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
  private
  procedure BuscarJSON;
  procedure BuscarEPreencherGrid(uf:string);
  procedure ExportarStringGridParaCSV(Grid: TStringGrid; const NomeArquivo: string);
  public

  end;

var
  frmCESTNCM: TfrmCESTNCM;

implementation

{$R *.lfm}

{ TfrmCESTNCM }

procedure TfrmCESTNCM.Button1Click(Sender: TObject);
begin
  Button1.caption := 'Consultando. Aguarde...';
  Button1.Enabled:= false;
  BuscarEPreencherGrid(estados.text);
  Button1.caption := 'Consultar';
  Button1.Enabled:= true;
end;

procedure TfrmCESTNCM.Button2Click(Sender: TObject);
var
  SaveDialog: TSaveDialog;
begin
  SaveDialog := TSaveDialog.Create(nil);
  try
    SaveDialog.Filter     := 'CSV files (*.csv)|*.csv';
    SaveDialog.DefaultExt := 'csv';
    SaveDialog.FileName   := 'tabela_cestxncm_'+estados.text+'.csv';
    if SaveDialog.Execute then
      ExportarStringGridParaCSV(StringGrid1, SaveDialog.FileName);
  finally
    SaveDialog.Free;
  end;
end;

procedure TfrmCESTNCM.estadosChange(Sender: TObject);
begin
  case estados.ItemIndex of
  0:
  begin
    Label2.Caption:= 'de São Paulo (SP)';
    Label3.caption := 'https://tributei.net/blog/tabela-cest-ncm-de-sao-paulo-sp';
  end;
  1:
  begin
    Label2.Caption:= 'de Mato Grosso (MT)';
    Label3.caption := 'https://tributei.net/blog/tabela-cest-ncm-de-mato-grosso-mt';
    end;
  2:
  begin
    label2.caption :=' de Paraná (PR)';
    Label3.caption := 'https://tributei.net/blog/tabela-cest-ncm-de-parana-pr';
  end;

  end;



end;

procedure TfrmCESTNCM.Label3Click(Sender: TObject);
begin
  OpenURL(Label3.Caption);
end;

procedure TfrmCESTNCM.Panel1Click(Sender: TObject);
begin

end;


procedure TfrmCESTNCM.BuscarJSON;
var
  Http: TIdHTTP;
  Response: TStringStream;
  JSONArray: TJSONArray;
  JSONObject, ValueObj: TJSONObject;
  i: Integer;
  item, cest, ncm, descrio, segmento: string;
  id: Integer;
begin
  Http := TIdHTTP.Create(nil);
  Response := TStringStream.Create('', TEncoding.UTF8);
  try
    Http.Request.ContentType := 'application/json';
    Http.Get('https://tributei.net/wp-admin/admin-ajax.php?action=wp_ajax_ninja_tables_public_action&table_id=17451&target_action=get-all-data', Response);

    Response.Position := 0;
    JSONArray := GetJSON(Response.DataString) as TJSONArray;

    for i := 0 to JSONArray.Count - 1 do
    begin
      JSONObject := JSONArray.Objects[i];
      ValueObj := JSONObject.Objects['value'];

      item     := ValueObj.Get('item', '');
      cest     := ValueObj.Get('cest', '');
      ncm      := ValueObj.Get('ncm', '');
      descrio  := ValueObj.Get('descrio', '');
      segmento := ValueObj.Get('segmento', '');
      id       := ValueObj.Get('___id___', 0);

      // Exemplo: exibir no console ou salvar onde quiser
      WriteLn('Item: ', item);
      WriteLn('CEST: ', cest);
      WriteLn('NCM: ', ncm);
      WriteLn('Descrição: ', descrio);
      WriteLn('Segmento: ', segmento);
      WriteLn('ID: ', id);
      WriteLn('-------------------------');
    end;

  finally
    Http.Free;
    Response.Free;
  end;
end;

procedure TfrmCESTNCM.BuscarEPreencherGrid ( uf:string );
var
  Http: TIdHTTP;
  Response: TStringStream;
  JSONArray: TJSONArray;
  JSONObject, ValueObj: TJSONObject;
  i, row: Integer;
  SSLHandler: TIdSSLIOHandlerSocketOpenSSL;
  idUF : string ;
begin
  Http := TIdHTTP.Create(nil);
  SSLHandler := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
  SSLHandler.SSLOptions.Method := sslvTLSv1_2; // Força TLS 1.2
  SSLHandler.SSLOptions.Mode := sslmUnassigned;
  Http.IOHandler := SSLHandler;

  Response := TStringStream.Create('', TEncoding.UTF8);
  try
    Http.Request.ContentType := 'application/json';
    if uf = 'SP' then idUF := '17399'; //https://tributei.net/blog/tabela-cest-ncm-de-mato-grosso-mt/
    if uf = 'MT' then idUF := '17451'; //https://tributei.net/blog/tabela-cest-ncm-de-sao-paulo-sp/
    if uf = 'PR' then idUF := '17420'; //https://tributei.net/blog/tabela-cest-ncm-de-parana-pr/

    Http.Get('https://tributei.net/wp-admin/admin-ajax.php?action=wp_ajax_ninja_tables_public_action&table_id='+idUF+'&target_action=get-all-data&default_sorting=old_first&skip_rows=0&limit_rows=0', Response);
   //https://tributei.net/wp-admin/admin-ajax.php?action=wp_ajax_ninja_tables_public_action&table_id=17420&target_action=get-all-data&default_sorting=old_first&skip_rows=0&limit_rows=0&ninja_table_public_nonce=8846357d02&chunk_number=0
    Response.Position := 0;

        with StringGrid1 do
      begin
        ColCount := 5;
        RowCount := 1; // apenas cabeçalho inicialmente

        Cells[0, 0] := 'Item';
        Cells[1, 0] := 'CEST';
        Cells[2, 0] := 'NCM';
        Cells[3, 0] := 'Descrição';
        Cells[4, 0] := 'Segmento';
      end;

      with StringGrid1 do
      begin
        ColWidths[0] := 50;   // Item
        ColWidths[1] := 80;   // CEST
        ColWidths[2] := 100;  // NCM
        ColWidths[3] := 700;  // Descrição
        ColWidths[4] := 300;  // Segmento
      end;


    JSONArray := GetJSON(Response.DataString) as TJSONArray;

    total.Caption:= 'Total de registros: ' + JSONArray.Count.ToString ;

    StringGrid1.RowCount := JSONArray.Count + 1; // Cabeçalho + registros

    for i := 0 to JSONArray.Count - 1 do
    begin
      JSONObject := JSONArray.Objects[i];
      ValueObj := JSONObject.Objects['value'];
      row := i + 1;

      StringGrid1.Cells[0, row] := ValueObj.Get('item', '');
      StringGrid1.Cells[1, row] := ValueObj.Get('cest', '');
      StringGrid1.Cells[2, row] := ValueObj.Get('ncm', '');
      StringGrid1.Cells[3, row] := ValueObj.Get('descrio', '');
      StringGrid1.Cells[4, row] := ValueObj.Get('segmento', '');
    end;



  finally
    SSLHandler.free;
    Http.Free;
    Response.Free;
  end;
end;

procedure TfrmCESTNCM.ExportarStringGridParaCSV(Grid: TStringGrid;
  const NomeArquivo: string);
var
  SL: TStringList;
  row, col: Integer;
  linha: string;
begin
  SL := TStringList.Create;
  try
    for row := 0 to Grid.RowCount - 1 do
    begin
      linha := '';
      for col := 0 to Grid.ColCount - 1 do
      begin
        // Escapa aspas e separa por ponto-e-vírgula
        linha := linha + '"' + StringReplace(Grid.Cells[col, row], '"', '""', [rfReplaceAll]) + '"';
        if col < Grid.ColCount - 1 then
          linha := linha + ';';
      end;
      SL.Add(linha);
    end;
    SL.SaveToFile(NomeArquivo, TEncoding.UTF8);
    ShowMessage('Exportado para: ' + NomeArquivo);
  finally
    SL.Free;
  end;
end;





end.

