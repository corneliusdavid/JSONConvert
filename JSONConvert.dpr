program JSONConvert;

uses
  Vcl.Forms,
  ufrmJsonConvertMain in 'ufrmJsonConvertMain.pas' {frmJSONConvert},
  udmJsonConvert in 'udmJsonConvert.pas' {dmJsonConvert: TDataModule},
  EasyJson in 'EasyJson\src\EasyJson.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmJSONConvert, frmJSONConvert);
  Application.CreateForm(TdmJsonConvert, dmJsonConvert);
  Application.Run;
end.
