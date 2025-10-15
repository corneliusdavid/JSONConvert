unit udmJsonConvert;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.SQLite,
  FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.VCLUI.Wait, FireDAC.Phys.SQLiteWrapper.Stat,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TdmJsonConvert = class(TDataModule)
    cnSqlite: TFDConnection;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    qryCustomers: TFDQuery;
    qryCustomersCustomerId: TFDAutoIncField;
    qryCustomersFirstName: TWideStringField;
    qryCustomersLastName: TWideStringField;
    qryCustomersCity: TWideStringField;
    qryCustomersState: TWideStringField;
    qryInvoices: TFDQuery;
    qryInvoiceItems: TFDQuery;
    srcCustomers: TDataSource;
    srcInvoices: TDataSource;
    qryInvoicesInvoiceId: TFDAutoIncField;
    qryInvoicesCustomerId: TIntegerField;
    qryInvoicesInvoiceDate: TDateTimeField;
    qryInvoicesTotal: TBCDField;
    qryInvoiceItemsInvoiceId: TIntegerField;
    qryInvoiceItemsInvoiceLineId: TFDAutoIncField;
    qryInvoiceItemsTrackId: TIntegerField;
    qryInvoiceItemsUnitPrice: TBCDField;
    qryInvoiceItemsQuantity: TIntegerField;
		procedure DataModuleDestroy(Sender: TObject);
		procedure DataModuleCreate(Sender: TObject);
  public
    procedure OpenTables;
  end;

var
  dmJsonConvert: TdmJsonConvert;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  IOUtils;

procedure TdmJsonConvert.DataModuleCreate(Sender: TObject);
begin
  cnSqlite.Params.Database := TPath.Combine(ExtractFilePath(ParamStr(0)), 'chinook.db');
  cnSqlite.Open;
end;

procedure TdmJsonConvert.DataModuleDestroy(Sender: TObject);
begin
  cnSqlite.Close;
end;

procedure TdmJsonConvert.OpenTables;
begin
  qryCustomers.Open;
  qryInvoices.Open;
  qryInvoiceItems.Open;
end;

end.
