unit UntFrmSettings;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UntBaseFrame, FMX.Controls.Presentation, FMX.Layouts, FMX.Objects,

  UntMain, System.Actions, FMX.ActnList;

type
  TFrameSettings = class(TBaseFrame)
    SwMusic: TSwitch;
    Label1: TLabel;
    GBArcade: TGroupBox;
    LayoutMusic: TLayout;
    LayoutScreen: TLayout;
    Label4: TLabel;
    SwScreen: TSwitch;
    RBEasy: TRadioButton;
    RBMedium: TRadioButton;
    RBHard: TRadioButton;
    LayoutApply: TLayout;
    BtnApply: TButton;
    GBGeneral: TGroupBox;
    procedure BtnApplyClick(Sender: TObject);
    procedure SwMusicClick(Sender: TObject);
  private
    { Private declarations }
  public
    function Execute: Boolean; override;
  end;

implementation

{$R *.fmx}

uses UntModule, IniFiles;

procedure TFrameSettings.BtnApplyClick(Sender: TObject);

  function GetArcMode: Integer;
  begin
     Result := 0;

     if RBMedium.IsChecked then
        Result := 1
     else if RBHard.IsChecked then
       Result := 2;
  end;
begin
  inherited;

  SetMusicMode(SwMusic.IsChecked);
  SetScreenMode(SwScreen.IsChecked);
  SetArcadeModee(GetArcMode);
end;

function TFrameSettings.Execute: Boolean;

  procedure Initialize;
  begin
    SwMusic.IsChecked := GetMusicMode;
    SwScreen.IsChecked := GetScreenMode;

    case GetArcadeMode of
      0: RBEasy.IsChecked := True;
      1: RBMedium.IsChecked := True;
      2: RBHard.IsChecked := True;
    end;

  end;
begin
  inherited;

  Initialize;
  Result := True;
end;

procedure TFrameSettings.SwMusicClick(Sender: TObject);
begin
  inherited;

  if not SwMusic.IsChecked then
    TDModule.StopPlayer
  else
    TDModule.PlayMusic;
end;

end.
