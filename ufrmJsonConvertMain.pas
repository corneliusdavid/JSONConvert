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
    procedure ExportToVSoftYAML;
    procedure ExportToSuperObject;
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
  VSoft.YAML, {VSoft Technologies}
  SuperObject, {Vadim Lou}
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
  case cmbJsonLibs.ItemIndex of
    0: ExportToSystemJson;
    1: ExportToEasyJson;
    2: ExportToMcJson;
    3: ExportToVSoftYAML;
    4: ExportToSuperObject;
  end;

  ShowMessage('Exported to ' + FExportFilename);
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
        sjCust.AddPair('FirstName', FirstName)
              .AddPair('LastName', LastName)
              .AddPair('City', City)
              .AddPair('State', State);

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
                  sjItem.AddPair('LineId', LineID)
                        .AddPair('TrackId', TrackID)
                        .AddPair('UnitPrice', UnitPrice)
                        .AddPair('Quantity', Quantity);

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
      sw.Write(sj.Format(2));
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
          ejCust.Put('FirstName', FirstName)
                .Put('LastName', LastName)
                .Put('City', City)
                .Put('State', State);

          // === INVOICES ===
          var ejInvList := ejCust.AddArray('invoices');
          var InvCount := 0;

          ExportInvoices(
            procedure(const InvoiceID: Integer; const InvoiceDT: TDateTime; const InvoiceTotal: Double)
            begin
              var ejInv := TEasyJson.Create;
              try
                ejInv.Put('InvId', InvoiceID)
                     .Put('InvDT', InvoiceDT)
                     .Put('Total', InvoiceTotal);

                // === INVOICE ITEMS ===
                var ejInvItems := ejInv.AddArray('items');
                var ItemCount := 0;
                ExportItems(
                  procedure(const LineID, TrackID: Integer; const UnitPrice: Double; const Quantity: Integer)
                  begin
                    var ejItem := TEasyJson.Create;
                    try
                      ejItem.Put('LineId', LineID)
                            .Put('TrackId', TrackID)
                            .Put('UnitPrice', UnitPrice)
                            .Put('Quantity', Quantity);

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

        mjCust.S['FirstName'] := FirstName;
        mjCust.S['LastName'] := LastName;
        mjCust.S['City'] := City;
        mjCust.S['State'] := State;

        // === INVOICES ===
        mjCust.Add('invoices', jitArray);
        ExportInvoices(
          procedure(const InvoiceID: Integer; const InvoiceDT: TDateTime; const InvoiceTotal: Double)
          begin
            var mjInv := mjCust['invoices'].Add(jitObject);
            mjInv.I['InvId'] := InvoiceID;
            mjInv.D['InvDT'] := InvoiceDT;
            mjInv.D['Total'] := InvoiceTotal;

            // === INVOICE ITEMS ===
            mjInv.Add('items', jitArray);
            ExportItems(
              procedure(const LineID, TrackID: Integer; const UnitPrice: Double; const Quantity: Integer)
              begin
                var mjInvItem := mjInv['items'].Add(jitObject);
                mjInvItem.I['LineId'] := LineID;
                mjInvItem.I['TrackId'] := TrackID;
                mjInvItem.D['UnitPrice'] := UnitPrice;
                mjInvItem.I['Quantity'] := Quantity;
              end);
          end);
      end);

    mj.SaveToFile(FExportFilename);
  finally
    mj.Free;
  end;
end;

procedure TfrmJSONConvert.ExportToVSoftYAML;
var
  vyj: IYAMLDocument;
begin
  FExportFilename := 'VSoftYAML.json';

  vyj := TYAML.CreateMapping;

  // == CUSTOMERS ==
  var vyjCustomers := vyj.AsMapping.AddOrSetSequence('customers');
  ExportCustomers(
    procedure(const FirstName, LastName, City, State: string)
    begin
      var vyjCust := vyjCustomers.AddMapping;

      vyjCust.S['FirstName'] := FirstName;
      vyjCust.S['LastName'] := LastName;
      vyjCust.S['City'] := City;
      vyjCust.S['State'] := State;

      // === INVOICES ===
      var vyjInvoices := vyjCust.AsMapping.AddOrSetSequence('invoices');
      ExportInvoices(
        procedure(const InvoiceID: Integer; const InvoiceDT: TDateTime; const InvoiceTotal: Double)
        begin
          var vyjInv := vyjInvoices.AddMapping;
          vyjInv.I['InvId'] := InvoiceID;
          vyjInv.D['InvDT'] := InvoiceDT;
          vyjInv.F['Total'] := InvoiceTotal;

          // === INVOICE ITEMS ===
          var vyjItems := vyjInv.AsMapping.AddOrSetSequence('items');
          ExportItems(
            procedure(const LineID, TrackID: Integer; const UnitPrice: Double; const Quantity: Integer)
            begin
              var vyjInvItem := vyjItems.AddMapping;
              vyjInvItem.I['LineId'] := LineID;
              vyjInvItem.I['TrackId'] := TrackID;
              vyjInvItem.F['UnitPrice'] := UnitPrice;
              vyjInvItem.I['Quantity'] := Quantity;
            end);
        end);
    end);

  TYAML.WriteToJSONFile(vyj, FExportFilename);
end;

procedure TfrmJSONConvert.ExportToSuperObject;
var
  soj: ISuperObject;
begin
  FExportFilename := 'SuperObject.json';

  soj := SO; // create a SuperObject

  // == CUSTOMERS ==
  var sojCustomers := SA; // create a SuperArray
  ExportCustomers(
    procedure(const FirstName, LastName, City, State: string)
    begin
      var soCust := SO;
      soCust.S['FirstName'] := FirstName;
      soCust.S['LastName'] := LastName;
      soCust.S['City'] := City;
      soCust.S['State'] := State;

      // === INVOICES ===
      var soInvList := SA;
      ExportInvoices(
        procedure(const InvoiceID: Integer; const InvoiceDT: TDateTime; const InvoiceTotal: Double)
        begin
          var soInv := SO;

          soInv.I['InvId'] := InvoiceID;
          soInv.V['InvDT'] := InvoiceDT;
          soInv.D['Total'] := InvoiceTotal;

          // === INVOICE ITEMS ===
          var soInvItems := SA;
          ExportItems(
            procedure(const LineID, TrackID: Integer; const UnitPrice: Double; const Quantity: Integer)
            begin
              var soItem := SO;
              soItem.I['LineId'] := LineID;
              soItem.I['TrackId'] := TrackID;
              soItem.D['UnitPrice'] := UnitPrice;
              soItem.I['Quantity'] := Quantity;

              soInvItems.AsArray.Add(soItem);
            end);
          soInv.O['items'] := soInvItems;
          soInvList.AsArray.Add(soInv);
        end);

    soCust.O['invoices'] := soInvList;
    sojCustomers.AsArray.Add(soCust);
  end);

  soj.AsObject.O['customers'] := sojCustomers;
  soj.SaveTo(FExportFilename);
end;


end.
