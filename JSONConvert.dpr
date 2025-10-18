program JSONConvert;

uses
  Vcl.Forms,
  ufrmJsonConvertMain in 'ufrmJsonConvertMain.pas' {frmJSONConvert},
  udmJsonConvert in 'udmJsonConvert.pas' {dmJsonConvert: TDataModule},
  EasyJson in 'EasyJson\src\EasyJson.pas',
  McJSON in 'McJSON\src\McJSON.pas',
  VSoft.YAML in 'VSoft.YAML\Source\VSoft.YAML.pas',
  VSoft.YAML.Classes in 'VSoft.YAML\Source\VSoft.YAML.Classes.pas',
  VSoft.YAML.IO in 'VSoft.YAML\Source\VSoft.YAML.IO.pas',
  VSoft.YAML.Lexer in 'VSoft.YAML\Source\VSoft.YAML.Lexer.pas',
  VSoft.YAML.Parser in 'VSoft.YAML\Source\VSoft.YAML.Parser.pas',
  VSoft.YAML.Utils in 'VSoft.YAML\Source\VSoft.YAML.Utils.pas',
  VSoft.YAML.Writer.JSON in 'VSoft.YAML\Source\VSoft.YAML.Writer.JSON.pas',
  VSoft.YAML.Writer in 'VSoft.YAML\Source\VSoft.YAML.Writer.pas',
  VSoft.YAML.TagInfo in 'VSoft.YAML\Source\VSoft.YAML.TagInfo.pas',
  VSoft.YAML.StreamWriter in 'VSoft.YAML\Source\VSoft.YAML.StreamWriter.pas',
  VSoft.YAML.Path in 'VSoft.YAML\Source\VSoft.YAML.Path.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmJSONConvert, frmJSONConvert);
  Application.CreateForm(TdmJsonConvert, dmJsonConvert);
  Application.Run;
end.
