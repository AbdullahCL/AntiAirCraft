program UntiAirCraft;

uses
  FMX.Forms,
  UntMain in 'UntMain.pas' {Form1},
  UntBaseForm in 'UntBaseForm.pas',
  UntBaseFrame in 'UntBaseFrame.pas' {BaseFrame: TFrame},
  UntFrmGameOver in 'UntFrmGameOver.pas' {FrameGameOver: TFrame},
  UntFrmSettings in 'UntFrmSettings.pas' {FrameSettings: TFrame},
  UntFrmHighScore in 'UntFrmHighScore.pas' {FrameHighScore: TFrame},
  UntFrmAbout in 'UntFrmAbout.pas' {FrameAbout: TFrame},
  UntFrmControl in 'UntFrmControl.pas' {FormControl},
  UntFrmSplash in 'UntFrmSplash.pas' {FrameSplash: TFrame},
  UntRegister in 'UntRegister.pas',
  UntModule in 'UntModule.pas' {DModule: TDataModule},
  UntFrmUserScore in 'UntFrmUserScore.pas' {FrameUserScore: TFrame},
  UntFrmCongratulations in 'UntFrmCongratulations.pas' {FrameCongratulations: TFrame};

{$R *.res}


procedure CreateDM;
begin
  with TDModule.Create(nil) do
  begin

  end;
end;


begin
  RegisterClasses;
  CreateDM;


  Application.Initialize;

  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
