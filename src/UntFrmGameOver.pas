unit UntFrmGameOver;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UntBaseFrame, FMX.Controls.Presentation, FMX.Layouts, System.Actions,
  FMX.ActnList, UntFrmUserScore;

type
  TFrameGameOver = class(TBaseFrame)
    LabelScore: TLabel;
    ActSaveScrore: TAction;
    FrameUserScore1: TFrameUserScore;
    procedure ActSaveScroreExecute(Sender: TObject);
  private
    { Private declarations }
  public
    function Execute: Boolean; override;
  end;

implementation

{$R *.fmx}

uses UntModule;

{ TFrameGameOver }

procedure TFrameGameOver.ActSaveScroreExecute(Sender: TObject);
var
  pName: String;
begin
  pName := FrameUserScore1.EditPlayerName.Text.Trim;

  if pName = '' then
    ShowMessage('Plase Enter Correctly Player Name')
  else
  begin
    SaveScore(pName);
    FrameUserScore1.Visible := False;
    ActPlayGame.Enabled := True;
    ActMainMenu.Enabled := True;
  end;
end;

function TFrameGameOver.Execute: Boolean;
begin
   inherited;

   ActPlayGame.Enabled := GetCurrentScore <= MIN_HIGH_SCORE;
   ActMainMenu.Enabled := GetCurrentScore <= MIN_HIGH_SCORE;
   FrameUserScore1.Visible := GetCurrentScore >= MIN_HIGH_SCORE;

   LabelScore.Text := Format('Score: %d', [GetCurrentScore]);
   Result := True;
end;
end.
