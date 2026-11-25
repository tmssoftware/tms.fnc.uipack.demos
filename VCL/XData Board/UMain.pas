unit UMain;

{ TMS FNC UI Pack - XData Board

  The orders and the team tasks of a TMS XData server (Shared Code\XData Demo Server) in a DataGrid and a Kanban
  board. Both were bound in the IDE with Bind to data, without code: the data module UAppData holds a TTMSFNCDataSet
  and a TTMSFNCDataLinkREST per control and the TTMSFNCDataSettings that load them in the background; Demo.data.json
  holds the address of the server per profile. The tasks need the sign-in of the server (user demo, the password its
  window shows): the settings ask for it and keep it in the credential store of Windows, never in a file. }

interface

uses
  Winapi.Windows, System.SysUtils, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes,
  System.Rtti, VCL.TMSFNCDataGridCell, VCL.TMSFNCDataGridData,
  VCL.TMSFNCDataGridBase, VCL.TMSFNCDataGridCore, VCL.TMSFNCDataGridRenderer,
  VCL.TMSFNCDataGridConditionalFormatting, VCL.TMSFNCCustomScrollControl,
  VCL.TMSFNCKanbanBoard, VCL.TMSFNCCustomControl, VCL.TMSFNCDataGrid,
  VCL.TMSFNCHTMLText, VCL.TMSFNCPanel, VCL.TMSFNCTheme, VCL.TMSFNCThemeSelector;

type
  TMain = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    InfoPanel: TTMSFNCPanel;
    ContentPanel: TTMSFNCPanel;
    OrdersCaption: TTMSFNCHTMLText;
    OrdersText: TTMSFNCHTMLText;
    TasksCaption: TTMSFNCHTMLText;
    TasksText: TTMSFNCHTMLText;
    ServerCaption: TTMSFNCHTMLText;
    ServerText: TTMSFNCHTMLText;
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    TMSFNCKanbanBoard1: TTMSFNCKanbanBoard;
  end;

var
  Main: TMain;

implementation

uses
  UAppData;

{$R *.dfm}

end.
