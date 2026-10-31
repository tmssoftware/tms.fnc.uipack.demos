unit UFNCUIKanban;

{ TMS FNC UI Pack - Kanban Board template

  A starting point for an FMX application (Windows, macOS, iOS, Android) built around a themed
  TTMSFNCKanbanBoard. Copy the project, rename the form and replace the sample cards with your own.

  Theme
    ThemeManager (Theme = 'Fluent Light', Scope = tsApplication) themes every FNC control of the
    application: board, columns, cards, header. DemoThemeSelector switches between Light and Dark;
    its "Follow system" switch makes the application follow the light/dark setting of the
    operating system (TTMSFNCTheme.SetFollowSystem(True) does the same in code).
    ThemeManager.Theme = '' gives the classic FNC look of earlier versions.

  Brand it
    - ThemeManager.Accent: your accent color on top of the theme.
    - ThemeManager.Brand (stored in the form) or ThemeManager.BrandFile := 'mybrand.fncbrand' (a
      .fncbrand file loaded at run time; a relative name is next to the executable): your own Light
      and Dark themes, used following ThemeManager.BrandMode (default: follow the system).
    - ThemeManager.TitleBar := tbTheme (or tbBrand): the window title bar in the theme's colors.
    - DemoTitle / DemoDescription: your application's name and a one-line description.
    Do not set colors or font names on the controls in the Object Inspector: such a value is yours
    and survives every theme switch (white cards in Dark). Card texts are HTML: leave out
    <font color> so the text follows the theme. Custom drawing takes its colors from the theme
    (ThemeColors below), so it follows Light, Dark, the accent and the brand.

  Data
    The cards are stored in the form (Columns[].Items[]); the card's Tag is its category (the color
    of the mark on top of the card). For a database, link the KanbanBoardAdapter on this form:
      KanbanBoardAdapter.Item.DataSource := <your TDataSource>;
      KanbanBoardAdapter.Item.DBKey := '<key field>'; (and .Column: the field with the column
        index, .Title, .Text: the fields shown on the card)
      TMSFNCKanbanBoard1.Adapter := KanbanBoardAdapter;
      <your dataset>.Active := True;
    Dragging a card to another column then updates the record. }

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomControl, FMX.TMSFNCCustomScrollControl, FMX.TMSFNCKanbanBoard,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCBitmapContainer, FMX.TMSFNCKanbanBoardDatabaseAdapter,
  FMX.TMSFNCHTMLText, FMX.TMSFNCPanel, FMX.TMSFNCTheme, FMX.TMSFNCThemeSelector;

type
  TForm3 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TTMSFNCPanel;
    DemoTitle: TTMSFNCHTMLText;
    DemoDescription: TTMSFNCHTMLText;
    DemoThemeSelector: TTMSFNCThemeSelector;
    TMSFNCKanbanBoard1: TTMSFNCKanbanBoard;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    KanbanBoardAdapter: TTMSFNCKanbanBoardDatabaseAdapter;
    procedure TMSFNCKanbanBoard1ItemCustomDrawMark(Sender: TObject;
      AGraphics: TTMSFNCGraphics; ARect: TRectF;
      AMarkType: TTMSFNCKanbanBoardMarkType; AColumn: TTMSFNCKanbanBoardColumn;
      AItem: TTMSFNCKanbanBoardItem);
  private
    function ThemeColors: TTMSFNCResolvedTheme;
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

{ the colors of the theme in effect (Light, Dark, a brand, with the accent applied); without a
  theme the light colors, which match the classic look }
function TForm3.ThemeColors: TTMSFNCResolvedTheme;
var
  n: string;
begin
  n := TTMSFNCTheme.EffectiveThemeName(Self);
  Result := nil;
  if n <> '' then
    Result := TTMSFNCTheme.Resolve(n);
  if not Assigned(Result) then
    Result := TTMSFNCTheme.Resolve('Fluent Light');
end;

{ the mark on top of a card in the color of its category (Tag): theme colors, so a category keeps
  its meaning in Light and Dark and follows a brand }
procedure TForm3.TMSFNCKanbanBoard1ItemCustomDrawMark(Sender: TObject;
  AGraphics: TTMSFNCGraphics; ARect: TRectF;
  AMarkType: TTMSFNCKanbanBoardMarkType; AColumn: TTMSFNCKanbanBoardColumn;
  AItem: TTMSFNCKanbanBoardItem);
var
  t: TTMSFNCResolvedTheme;
begin
  t := ThemeColors;
  case AItem.Tag of
    1: AGraphics.Fill.Color := t[ttInfo];     // customer
    2: AGraphics.Fill.Color := t[ttAccent];   // quality, communication
    3: AGraphics.Fill.Color := t[ttWarning];  // minor issue
    4: AGraphics.Fill.Color := t[ttError];    // high priority
  else
    AGraphics.Fill.Color := t[ttSuccess];     // planning, documentation
  end;
  AGraphics.Fill.Kind := gfkSolid;
  AGraphics.Stroke.Kind := gskNone;
  AGraphics.DrawRoundRectangle(ARect, t.Metrics[tmxRadiusSmall], [gcTopLeft, gcTopRight]);
end;

end.
