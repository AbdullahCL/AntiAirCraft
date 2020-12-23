unit UntFrmSplash;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UntBaseFrame, FMX.Controls.Presentation, System.Actions, FMX.ActnList,
  FMX.Objects, FMX.Layouts;

type
  TFrameSplash = class(TBaseFrame)
    Button2: TButton;
    Button4: TButton;
    Button5: TButton;
    Button1: TButton;
    ActAbout: TAction;
    ActHighScore: TAction;
    ActSettings: TAction;
    ActClose: TAction;
    procedure ActCloseExecute(Sender: TObject);
    procedure ActSettingsExecute(Sender: TObject);
    procedure ActHighScoreExecute(Sender: TObject);
    procedure ActAboutExecute(Sender: TObject);
  private
    { Private declarations }
  public
    function Execute: Boolean; override;
  end;

implementation

{$R *.fmx}

uses UntBaseForm;

procedure TFrameSplash.ActAboutExecute(Sender: TObject);
begin
  inherited;

  CrateBaseFrame(Self, 'TFrameAbout').Execute;
end;

procedure TFrameSplash.ActCloseExecute(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TFrameSplash.ActHighScoreExecute(Sender: TObject);
begin
  inherited;

  CrateBaseFrame(Self, 'TFrameHighScore').Execute;
end;

procedure TFrameSplash.ActSettingsExecute(Sender: TObject);
begin
  inherited;

  CrateBaseFrame(Self, 'TFrameSettings').Execute;
end;

function TFrameSplash.Execute: Boolean;
begin
   Result := True;
end;

end.
