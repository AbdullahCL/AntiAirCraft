unit UntFrmAbout;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  UntBaseFrame, FMX.Controls.Presentation, FMX.Layouts, FMX.ScrollBox, FMX.Memo,
  System.Actions, FMX.ActnList;

type
  TFrameAbout = class(TBaseFrame)
    MemoAbout: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
