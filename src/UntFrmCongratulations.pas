unit UntFrmCongratulations;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UntFrmGameOver, System.Actions, FMX.ActnList, UntFrmUserScore,
  FMX.Controls.Presentation, FMX.Layouts;

type
  TFrameCongratulations = class(TFrameGameOver)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FrameCongratulations: TFrameCongratulations;

implementation

{$R *.fmx}

end.
