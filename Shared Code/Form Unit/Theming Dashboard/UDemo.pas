unit UDemo;

{ TMS FNC UI Pack - Theming Dashboard demo.

  The form holds a TTMSFNCThemeManager with Scope tsApplication and Theme 'Fluent Light': that one
  component themes every FNC control of the application, also the ones created in code. The
  dashboard itself (header with the theme switcher, navigation, KPI cards, orders grid, projects
  tree, goals and preferences) is built in code by TDashboard in UBL.pas. }

interface

uses
  {$IFDEF VCL}
  System.SysUtils, System.Classes, Vcl.Controls, Vcl.Forms, VCL.TMSFNCTheme, UBL;
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Classes, FMX.Types, FMX.Controls, FMX.Forms, FMX.TMSFNCTheme, UBL;
  {$ENDIF}

type
  TForm1 = class(TForm)
    TMSFNCThemeManager1: TTMSFNCThemeManager;
    procedure FormCreate(Sender: TObject);
  private
    FDashboard: TDashboard;
  public
    property Dashboard: TDashboard read FDashboard;
  end;

var
  Form1: TForm1;

implementation

{$IFDEF FMX}
{$R *.fmx}
{$ENDIF}
{$IFDEF VCL}
{$R *.dfm}
{$ENDIF}

{$IFDEF DASHBOARD_AUTOMATION}
{ the unattended tests of the TMS build (not part of the demo, only in a build with this define) }
uses
  UDashboardAutomation;
{$ENDIF}

procedure TForm1.FormCreate(Sender: TObject);
begin
  FDashboard := TDashboard.Create(Self);
  { the dashboard is designed for 1440 x 1277: on a smaller screen the window fits the work area
    and the layout adapts }
  FDashboard.FitToScreen;
end;

end.
