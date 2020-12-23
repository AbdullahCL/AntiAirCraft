unit UntFrmHighScore;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UntBaseFrame, FMX.Controls.Presentation, FMX.Layouts, FMX.ListBox,
  FMX.ScrollBox, FMX.Memo, System.Actions, FMX.ActnList;

type
  TFrameHighScore = class(TBaseFrame)
    MemoHighScore: TMemo;
  private
    { Private declarations }
  public
    function Execute: Boolean; override;
  end;

implementation

{$R *.fmx}


uses UntModule;

{ TFrameHighScore }

function TFrameHighScore.Execute: Boolean;
var
  scores: TMemoryStream;
begin
   inherited;

   scores := LoadScores;
   if Assigned(scores) then
   begin
     MemoHighScore.Lines.LoadFromStream(scores);
   end;
end;

end.
