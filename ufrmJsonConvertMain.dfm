object frmJSONConvert: TfrmJSONConvert
  Left = 0
  Top = 0
  Caption = 'frmJSONConvert'
  ClientHeight = 590
  ClientWidth = 929
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnActivate = FormActivate
  OnCreate = FormCreate
  TextHeight = 21
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 929
    Height = 41
    Align = alTop
    TabOrder = 0
    object btnExport: TBitBtn
      Left = 8
      Top = 9
      Width = 113
      Height = 25
      Caption = 'Export'
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000010000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00600000666666
        6666666888886666666666660000877778066666666666877778866666666666
        00008FF7780666666666668FF77886666666666600008F7F780666666666668F
        7F7886666666666600008FF7780666666666668FF77886666666666600008F7F
        780666666666668F7F7886666666666600008FF7780666666666668FF7788666
        66666666000088888806666666666688888886666666666600008FF7F7066600
        0000008FF7F78666888888880000688888666687777770688888666687777778
        000066666666668FBFBF7066666666668F7F7F78000066486666668BFBFB7066
        8866666687F7F778000066486846668FBFBF7066886886668F7F7F7800006648
        6644668BFBFB70668866886687F7F778000066844444468FBF00006688888886
        8F7F8888000066666644668BFB7F86666666886687F77F86000066666846668F
        BF786666666886668F7F78660000666666666688888666666666666688888666
        0000}
      NumGlyphs = 2
      TabOrder = 0
      OnClick = btnExportClick
    end
    object cmbJsonLibs: TComboBox
      Left = 127
      Top = 7
      Width = 391
      Height = 29
      Style = csDropDownList
      TabOrder = 1
      Items.Strings = (
        'System.JSON (Embarcadero)'
        'EasyJson (tinyBigGames)'
        'McJson (HydroByte)'
        'VSoft.YAML (VSoft Technologies)'
        'SuperObject (Vadim Lou)')
    end
  end
  object Panel2: TPanel
    Left = 523
    Top = 41
    Width = 406
    Height = 549
    Align = alRight
    TabOrder = 1
    object Label1: TLabel
      Left = 1
      Top = 238
      Width = 91
      Height = 21
      Align = alTop
      Caption = 'Invoice Items'
    end
    object Label3: TLabel
      Left = 1
      Top = 1
      Width = 56
      Height = 21
      Align = alTop
      Caption = 'Invoices'
    end
    object DBGrid2: TDBGrid
      Left = 1
      Top = 259
      Width = 404
      Height = 289
      Align = alClient
      DataSource = srcInvItems
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -16
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'InvoiceLineId'
          Title.Caption = 'Line#'
          Width = 50
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'TrackId'
          Width = 60
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'UnitPrice'
          Title.Alignment = taRightJustify
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Quantity'
          Title.Alignment = taRightJustify
          Width = 80
          Visible = True
        end>
    end
    object DBGrid3: TDBGrid
      Left = 1
      Top = 22
      Width = 404
      Height = 216
      Align = alTop
      DataSource = srcInvoices
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -16
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'InvoiceId'
          Title.Caption = 'ID'
          Width = 40
          Visible = True
        end
        item
          Alignment = taCenter
          Expanded = False
          FieldName = 'InvoiceDate'
          Title.Alignment = taCenter
          Width = 110
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Total'
          Title.Alignment = taRightJustify
          Visible = True
        end>
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 41
    Width = 523
    Height = 549
    Align = alClient
    TabOrder = 2
    object Label2: TLabel
      Left = 1
      Top = 1
      Width = 75
      Height = 21
      Align = alTop
      Caption = 'Customers'
    end
    object DBGrid1: TDBGrid
      Left = 1
      Top = 22
      Width = 521
      Height = 526
      Align = alClient
      DataSource = dsCustomers
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -16
      TitleFont.Name = 'Segoe UI'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'CustomerId'
          Title.Caption = 'ID'
          Width = 40
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'FirstName'
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'LastName'
          Width = 100
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'City'
          Width = 120
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'State'
          Width = 60
          Visible = True
        end>
    end
  end
  object dsCustomers: TDataSource
    DataSet = dmJsonConvert.qryCustomers
    Left = 176
    Top = 400
  end
  object srcInvoices: TDataSource
    DataSet = dmJsonConvert.qryInvoices
    Left = 816
    Top = 176
  end
  object srcInvItems: TDataSource
    DataSet = dmJsonConvert.qryInvoiceItems
    Left = 720
    Top = 424
  end
end
