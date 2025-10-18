unit ufrmJsonConvertMain;

interface


uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.Grids, Vcl.DBGrids, Vcl.ExtCtrls, Vcl.Buttons;

type
  TAddJsonCustomerProc = reference to procedure(const FirstName, LastName, City, State: string);
  TAddJsonInvoiceProc = reference to procedure(const InvoiceID: Integer; const InvoiceDT: TDateTime; const InvoiceTotal: Double);
  TAddJsonItemProc = reference to procedure(const LineID, TrackID: Integer; const UnitPrice: Double; const Quantity: Integer);

  TfrmJSONConvert = class(TForm)
    Panel1: TPanel;
    DBGrid1: TDBGrid;
    Panel2: TPanel;
    DBGrid2: TDBGrid;
    Label1: TLabel;
    Label2: TLabel;
    Panel3: TPanel;
    Label3: TLabel;
    DBGrid3: TDBGrid;
    dsCustomers: TDataSource;
    srcInvoices: TDataSource;
    srcInvItems: TDataSource;
    btnExport: TBitBtn;
    cmbJsonLibs: TComboBox;
    procedure btnExportClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FirstTime: Boolean;
    FExportFilename: string;
    procedure ExportItems(AddJsonItemProc: TAddJsonItemProc);
    procedure ExportInvoices(AddJsonInvoiceProc: TAddJsonInvoiceProc);
    procedure ExportCustomers(AddJsonCustomerProc: TAddJsonCustomerProc);
    procedure ExportToJson;
    procedure ExportToSystemJson;
    procedure ExportToEasyJson;
    procedure ExportToMcJson;
  end;


var
  frmJSONConvert: TfrmJSONConvert;

implementation

{$R *.dfm}


uses
  System.Diagnostics,
  System.JSON, {Embarcadero}
  EasyJson, {tinyBigGames}
  McJson, {HydroByte}
  udmJsonConvert;

procedure TfrmJSONConvert.btnExportClick(Sender: TObject);
begin
  ExportToJson;
end;

procedure TfrmJSONConvert.FormActivate(Sender: TObject);
begin
  if FirstTime then begin
    FirstTime := False;
    dmJsonConvert.OpenTables;
  end;
end;

procedure TfrmJSONConvert.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;
  FirstTime := True;
end;

procedure TfrmJSONConvert.ExportToJson;
begin
  var StopWatch := TStopWatch.StartNew;
  case cmbJsonLibs.ItemIndex of
    0: ExportToSystemJson;
    1: ExportToEasyJson;
    2: ExportToMcJson;
  end;

  ShowMessage('Exported to ' + FExportFilename + '; elasped time in seconds: ' + StopWatch.Elapsed.Seconds.ToString);
end;

procedure TfrmJSONConvert.ExportCustomers(AddJsonCustomerProc: TAddJsonCustomerProc);
begin
  dmJsonConvert.qryCustomers.First;
  while not dmJsonConvert.qryCustomers.Eof do begin
    AddJsonCustomerProc(dmJsonConvert.qryCustomersFirstName.AsString, dmJsonConvert.qryCustomersLastName.AsString,
      dmJsonConvert.qryCustomersCity.AsString, dmJsonConvert.qryCustomersState.AsString);

    dmJsonConvert.qryCustomers.Next;
  end;
end;

procedure TfrmJSONConvert.ExportInvoices(AddJsonInvoiceProc: TAddJsonInvoiceProc);
begin
  dmJsonConvert.qryInvoices.First;
  while not dmJsonConvert.qryInvoices.Eof do begin
    AddJsonInvoiceProc(dmJsonConvert.qryInvoicesInvoiceId.AsInteger, dmJsonConvert.qryInvoicesInvoiceDate.AsDateTime,
      dmJsonConvert.qryInvoicesTotal.AsFloat);

    dmJsonConvert.qryInvoices.Next;
  end;
end;

procedure TfrmJSONConvert.ExportItems(AddJsonItemProc: TAddJsonItemProc);
begin
  dmJsonConvert.qryInvoiceItems.First;
  while not dmJsonConvert.qryInvoiceItems.Eof do begin
    AddJsonItemProc(dmJsonConvert.qryInvoiceItemsInvoiceLineId.AsInteger, dmJsonConvert.qryInvoiceItemsTrackId.AsInteger,
      dmJsonConvert.qryInvoiceItemsUnitPrice.AsFloat, dmJsonConvert.qryInvoiceItemsQuantity.AsInteger);

    dmJsonConvert.qryInvoiceItems.Next;
  end;
end;

procedure TfrmJSONConvert.ExportToSystemJson;
var
  sj: TJSONObject;
begin
  FExportFilename := 'System.json';

  sj := TJSONObject.Create;
  try
    var sjCustArray := TJSONArray.Create;

    // == CUSTOMERS ==
    ExportCustomers(
      procedure(const FirstName, LastName, City, State: string)
      begin
        var sjCust := TJSONObject.Create;
        sjCust.AddPair('FirstName', FirstName).AddPair('LastName', LastName).AddPair('City', City).AddPair('State', State);

        // === INVOICES ===
        var sjInvList := TJSONArray.Create;
        ExportInvoices(
          procedure(const InvoiceID: Integer; const InvoiceDT: TDateTime; const InvoiceTotal: Double)
          begin
            var sjInv := TJSONObject.Create;
              sjInv.AddPair('InvId', InvoiceID)
                   .AddPair('InvDT', InvoiceDT)
                   .AddPair('Total', InvoiceTotal);

              // === INVOICE ITEMS ===
              var sjInvItems := TJSONArray.Create;
              ExportItems(
                procedure(const LineID, TrackID: Integer; const UnitPrice: Double; const Quantity: Integer)
                begin
                  var sjItem := TJSONObject.Create;
                  sjItem.AddPair('LineId', LineID).AddPair('TrackId', TrackID).AddPair('UnitPrice', UnitPrice).AddPair('Quantity',
                    Quantity);

                  sjInvItems.Add(sjItem);
                end);

              sjInv.AddPair('items', sjInvItems);
              sjInvList.Add(sjInv);
          end);

        sjCust.AddPair('invoices', sjInvList);

        sjCustArray.Add(sjCust);
      end);

    sj.AddPair('customers', sjCustArray);

    var sw := TStreamWriter.Create(FExportFilename, False);
    try
      sw.Write(sj);
    finally
      sw.Free;
    end;
  finally
    sj.Free;
  end;
end;

procedure TfrmJSONConvert.ExportToEasyJson;
var
  ej: TEasyJson;
begin
  FExportFilename := 'EasyJson.json';

  ej := TEasyJson.Create;
  try
    var ejCustList := ej.AddArray('customers');
    var CustCount := 0;

    // == CUSTOMERS ==
    ExportCustomers(
      procedure(const FirstName, LastName, City, State: string)
      begin
        var ejCust := TEasyJson.Create;
        try
          ejCust.Put('FirstName', FirstName).Put('LastName', LastName).Put('City', City).Put('State', State);

          // === INVOICES ===
          var ejInvList := ejCust.AddArray('invoices');
          var InvCount := 0;

          ExportInvoices(
            procedure(const InvoiceID: Integer; const InvoiceDT: TDateTime; const InvoiceTotal: Double)
            begin
              var ejInv := TEasyJson.Create;
              try
                ejInv.Put('InvId', InvoiceID).Put('InvDT', InvoiceDT).Put('Total', InvoiceTotal);

                // === INVOICE ITEMS ===
                var ejInvItems := ejInv.AddArray('items');
                var ItemCount := 0;
                ExportItems(
                  procedure(const LineID, TrackID: Integer; const UnitPrice: Double; const Quantity: Integer)
                  begin
                    var ejItem := TEasyJson.Create;
                    try
                      ejItem.Put('LineId', LineID).Put('TrackId', TrackID).Put('UnitPrice', UnitPrice).Put('Quantity', Quantity);

                      ejInvItems.Put(ItemCount, ejItem);
                      Inc(ItemCount);
                    finally
                      ejItem.Free;
                    end;
                  end);

                ejInvList.Put(InvCount, ejInv);
                Inc(InvCount);
              finally
                ejInv.Free;
              end;
            end);

          ejCustList.Put(CustCount, ejCust);
          Inc(CustCount);
        finally
          ejCust.Free;
        end;
      end);

    ej.SaveToFile(FExportFilename);
  finally
    ej.Free;
  end;
end;

procedure TfrmJSONConvert.ExportToMcJson;
var
  mj: TMcJsonItem;
begin
  FExportFilename := 'McJson.json';

  mj := TMcJsonItem.Create;
  try
    // == CUSTOMERS ==
    mj.Add('customers', jitArray);
    ExportCustomers(
      procedure(const FirstName, LastName, City, State: string)
      begin
        var mjCust := mj['customers'].Add(jitObject);

        mjCust.Add('FirstName').AsString := FirstName;
        mjCust.Add('LastName').AsString := LastName;
        mjCust.Add('City').AsString := City;
        mjCust.Add('State').AsString := State;

        // === INVOICES ===
        mjCust.Add('invoices', jitArray);
        ExportInvoices(
          procedure(const InvoiceID: Integer; const InvoiceDT: TDateTime; const InvoiceTotal: Double)
          begin
            var mjInv := mjCust['invoices'].Add(jitObject);
            mjInv.Add('InvId').AsInteger := InvoiceID;
            mjInv.Add('InvDT').AsString := FormatDateTime('yyyy-mm-dd', InvoiceDT);
            mjInv.Add('Total').AsNumber := InvoiceTotal;

            // === INVOICE ITEMS ===
            mjInv.Add('items', jitArray);
            ExportItems(
              procedure(const LineID, TrackID: Integer; const UnitPrice: Double; const Quantity: Integer)
              begin
                var mjInvItem := mjInv['items'].Add(jitObject);
                mjInvItem.Add('LineId').AsInteger := LineID;
                mjInvItem.Add('TrackId').AsInteger := TrackID;
                mjInvItem.Add('UnitPrice').AsNumber := UnitPrice;
                mjInvItem.Add('Quantity').AsInteger := Quantity;
              end);
          end);
      end);

    mj.SaveToFile(FExportFilename);
  finally
    mj.Free;
  end;
end;


end.
