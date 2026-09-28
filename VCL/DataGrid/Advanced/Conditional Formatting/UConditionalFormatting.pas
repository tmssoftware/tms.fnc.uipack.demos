{ TMS FNC Data Grid - Conditional Formatting demo (VCL).

  A sales-performance dashboard showcasing every Phase 1 + Phase 2 rule type
  across many columns:
    - Sales     : 3-colour scale + whole-row highlight for the top 5
    - Quota %   : data bar + below-target (<100) red font
    - Pipeline  : data bar
    - Deals     : arrow icon set
    - Win %     : data bar
    - Growth %  : positive/negative font colour + traffic-light icon set
    - CSAT      : 5-level icon set
    - Status    : text rules (Active / At Risk / Churned)

  The grid is built in code so the .dfm stays minimal. }

unit UConditionalFormatting;

interface

uses
  System.SysUtils, System.Classes, System.UITypes,
  Vcl.Controls, Vcl.Forms,
  VCL.TMSFNCTypes, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes,
  VCL.TMSFNCCustomControl, VCL.TMSFNCDataGrid,
  VCL.TMSFNCDataGridConditionalFormatting;

type
  TfrmConditionalFormatting = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    FGrid: TTMSFNCDataGrid;
    procedure BuildGrid;
    procedure FillData;
    procedure AddRules;
  end;

var
  frmConditionalFormatting: TfrmConditionalFormatting;

implementation

{$R *.dfm}

type
  TSalesRow = record
    Rep, Region, Team: string;
    Sales, Quota, Pipeline, Deals, WinRate: Integer;
    Growth, CSAT: Double;
    Status: string;
  end;

const
  COL_REP      = 0;
  COL_REGION   = 1;
  COL_TEAM     = 2;
  COL_SALES    = 3;
  COL_QUOTA    = 4;
  COL_PIPELINE = 5;
  COL_DEALS    = 6;
  COL_WIN      = 7;
  COL_GROWTH   = 8;
  COL_CSAT     = 9;
  COL_STATUS   = 10;

  SAMPLE: array[0..26] of TSalesRow = (
    (Rep: 'Alice Chen';    Region: 'EMEA'; Team: 'Enterprise';  Sales: 2450; Quota: 112; Pipeline: 4200; Deals: 22; WinRate: 58; Growth:  18.5; CSAT: 4.6; Status: 'Active'),
    (Rep: 'Bob Martins';   Region: 'APAC'; Team: 'SMB';         Sales:  780; Quota:  68; Pipeline: 1100; Deals:  9; WinRate: 34; Growth:  -6.0; CSAT: 3.2; Status: 'At Risk'),
    (Rep: 'Carol Diaz';    Region: 'AMER'; Team: 'Enterprise';  Sales: 3120; Quota: 128; Pipeline: 5600; Deals: 31; WinRate: 67; Growth:  34.0; CSAT: 4.9; Status: 'Active'),
    (Rep: 'Dan Osei';      Region: 'AMER'; Team: 'Mid-Market';  Sales: 1490; Quota:  96; Pipeline: 2600; Deals: 17; WinRate: 45; Growth:   4.5; CSAT: 4.0; Status: 'Active'),
    (Rep: 'Eve Novak';     Region: 'EMEA'; Team: 'Enterprise';  Sales: 2670; Quota: 118; Pipeline: 4800; Deals: 26; WinRate: 61; Growth:  22.0; CSAT: 4.7; Status: 'Active'),
    (Rep: 'Frank Bauer';   Region: 'APAC'; Team: 'SMB';         Sales:  410; Quota:  52; Pipeline:  700; Deals:  5; WinRate: 22; Growth: -14.0; CSAT: 2.6; Status: 'Churned'),
    (Rep: 'Grace Kim';     Region: 'APAC'; Team: 'Enterprise';  Sales: 2980; Quota: 133; Pipeline: 5200; Deals: 29; WinRate: 70; Growth:  41.0; CSAT: 4.8; Status: 'Active'),
    (Rep: 'Heidi Ross';    Region: 'EMEA'; Team: 'Mid-Market';  Sales: 1180; Quota:  88; Pipeline: 2100; Deals: 14; WinRate: 41; Growth:  -2.5; CSAT: 3.6; Status: 'Active'),
    (Rep: 'Ivan Petrov';   Region: 'EMEA'; Team: 'SMB';         Sales:  640; Quota:  61; Pipeline:  950; Deals:  7; WinRate: 28; Growth:  -9.0; CSAT: 3.0; Status: 'At Risk'),
    (Rep: 'Julia Santos';  Region: 'AMER'; Team: 'Enterprise';  Sales: 2210; Quota: 105; Pipeline: 3900; Deals: 21; WinRate: 55; Growth:  12.0; CSAT: 4.4; Status: 'Active'),
    (Rep: 'Karl Weiss';    Region: 'APAC'; Team: 'Mid-Market';  Sales: 1875; Quota:  99; Pipeline: 3100; Deals: 18; WinRate: 48; Growth:   7.5; CSAT: 4.1; Status: 'Active'),
    (Rep: 'Lena Haas';     Region: 'EMEA'; Team: 'Enterprise';  Sales: 3050; Quota: 124; Pipeline: 5400; Deals: 30; WinRate: 66; Growth:  29.0; CSAT: 4.8; Status: 'Active'),
    (Rep: 'Mohammed Ali';  Region: 'AMER'; Team: 'SMB';         Sales:  520; Quota:  58; Pipeline:  820; Deals:  6; WinRate: 24; Growth: -11.5; CSAT: 2.8; Status: 'Churned'),
    (Rep: 'Nadia Farah';   Region: 'APAC'; Team: 'Mid-Market';  Sales: 1640; Quota:  92; Pipeline: 2800; Deals: 16; WinRate: 43; Growth:   1.0; CSAT: 3.8; Status: 'Active'),
    (Rep: 'Oscar Lund';    Region: 'EMEA'; Team: 'Enterprise';  Sales: 2380; Quota: 109; Pipeline: 4100; Deals: 23; WinRate: 57; Growth:  16.0; CSAT: 4.5; Status: 'Active'),
    (Rep: 'Priya Nair';    Region: 'AMER'; Team: 'SMB';         Sales:  990; Quota:  74; Pipeline: 1500; Deals: 10; WinRate: 33; Growth:  -4.0; CSAT: 3.3; Status: 'At Risk'),
    (Rep: 'Quinn Doyle';   Region: 'APAC'; Team: 'Enterprise';  Sales: 2760; Quota: 121; Pipeline: 4900; Deals: 27; WinRate: 63; Growth:  25.5; CSAT: 4.7; Status: 'Active'),
    (Rep: 'Rosa Vidal';    Region: 'EMEA'; Team: 'Mid-Market';  Sales: 1330; Quota:  90; Pipeline: 2300; Deals: 15; WinRate: 42; Growth:   0.0; CSAT: 3.7; Status: 'Active'),
    (Rep: 'Sven Larsen';   Region: 'EMEA'; Team: 'Enterprise';  Sales: 2890; Quota: 126; Pipeline: 5100; Deals: 28; WinRate: 64; Growth:  31.0; CSAT: 4.8; Status: 'Active'),
    (Rep: 'Tara Singh';    Region: 'APAC'; Team: 'SMB';         Sales:  700; Quota:  64; Pipeline: 1000; Deals:  8; WinRate: 26; Growth:  -7.5; CSAT: 3.1; Status: 'At Risk'),
    (Rep: 'Uma Reddy';     Region: 'AMER'; Team: 'Mid-Market';  Sales: 1720; Quota:  94; Pipeline: 2900; Deals: 17; WinRate: 46; Growth:   3.0; CSAT: 3.9; Status: 'Active'),
    (Rep: 'Viktor Ilic';   Region: 'EMEA'; Team: 'Enterprise';  Sales: 2540; Quota: 114; Pipeline: 4400; Deals: 24; WinRate: 59; Growth:  19.5; CSAT: 4.6; Status: 'Active'),
    (Rep: 'Wendy Cole';    Region: 'AMER'; Team: 'SMB';         Sales:  460; Quota:  55; Pipeline:  760; Deals:  5; WinRate: 23; Growth: -12.5; CSAT: 2.7; Status: 'Churned'),
    (Rep: 'Xavier Roy';    Region: 'APAC'; Team: 'Mid-Market';  Sales: 1560; Quota:  91; Pipeline: 2700; Deals: 16; WinRate: 44; Growth:   2.5; CSAT: 3.8; Status: 'Active'),
    (Rep: 'Yara Haddad';   Region: 'EMEA'; Team: 'Enterprise';  Sales: 3210; Quota: 131; Pipeline: 5800; Deals: 32; WinRate: 69; Growth:  38.0; CSAT: 4.9; Status: 'Active'),
    (Rep: 'Zack Turner';   Region: 'AMER'; Team: 'SMB';         Sales:  880; Quota:  71; Pipeline: 1300; Deals:  9; WinRate: 31; Growth:  -3.0; CSAT: 3.4; Status: 'At Risk'),
    (Rep: 'Ana Duarte';    Region: 'AMER'; Team: 'Mid-Market';  Sales: 2050; Quota: 101; Pipeline: 3500; Deals: 20; WinRate: 52; Growth:   9.0; CSAT: 4.2; Status: 'Active')
  );

procedure TfrmConditionalFormatting.FormCreate(Sender: TObject);
begin
  Caption := 'TMS FNC Data Grid - Conditional Formatting Demo';
  BuildGrid;
  FillData;
  AddRules;
  FGrid.AutoSizeColumns;
end;

procedure TfrmConditionalFormatting.BuildGrid;
begin
  FGrid := TTMSFNCDataGrid.Create(Self);
  FGrid.Parent := Self;
  FGrid.Align := alClient;
  FGrid.BeginUpdate;
  try
    FGrid.FixedColumnCount := 0;
    FGrid.ColumnCount := 11;
    FGrid.RowCount := 1 + Length(SAMPLE);
    FGrid.Cells[COL_REP, 0]      := 'Sales Rep';
    FGrid.Cells[COL_REGION, 0]   := 'Region';
    FGrid.Cells[COL_TEAM, 0]     := 'Team';
    FGrid.Cells[COL_SALES, 0]    := 'Sales';
    FGrid.Cells[COL_QUOTA, 0]    := 'Quota %';
    FGrid.Cells[COL_PIPELINE, 0] := 'Pipeline';
    FGrid.Cells[COL_DEALS, 0]    := 'Deals';
    FGrid.Cells[COL_WIN, 0]      := 'Win %';
    FGrid.Cells[COL_GROWTH, 0]   := 'Growth %';
    FGrid.Cells[COL_CSAT, 0]     := 'CSAT';
    FGrid.Cells[COL_STATUS, 0]   := 'Status';
  finally
    FGrid.EndUpdate;
  end;
end;

procedure TfrmConditionalFormatting.FillData;
var
  i: Integer;
begin
  FGrid.BeginUpdate;
  try
    for i := 0 to High(SAMPLE) do
    begin
      FGrid.Cells[COL_REP,      i + 1] := SAMPLE[i].Rep;
      FGrid.Cells[COL_REGION,   i + 1] := SAMPLE[i].Region;
      FGrid.Cells[COL_TEAM,     i + 1] := SAMPLE[i].Team;
      FGrid.Cells[COL_SALES,    i + 1] := SAMPLE[i].Sales;
      FGrid.Cells[COL_QUOTA,    i + 1] := SAMPLE[i].Quota;
      FGrid.Cells[COL_PIPELINE, i + 1] := SAMPLE[i].Pipeline;
      FGrid.Cells[COL_DEALS,    i + 1] := SAMPLE[i].Deals;
      FGrid.Cells[COL_WIN,      i + 1] := SAMPLE[i].WinRate;
      FGrid.Cells[COL_GROWTH,   i + 1] := SAMPLE[i].Growth;
      FGrid.Cells[COL_CSAT,     i + 1] := SAMPLE[i].CSAT;
      FGrid.Cells[COL_STATUS,   i + 1] := SAMPLE[i].Status;
    end;
  finally
    FGrid.EndUpdate;
  end;
end;

procedure TfrmConditionalFormatting.AddRules;
begin
  // Sales: 3-colour scale (low=red .. high=green), lowest priority so highlights overlay it.
  FGrid.ConditionalFormatting.AddColorScale(COL_SALES, gcRed, gcYellow, gcLimegreen).Priority := 100;

  // Sales: top 5 performers -> tint the whole row + bold.
  with FGrid.ConditionalFormatting.AddTopBottomRule(COL_SALES, rkTop, 5) do
  begin
    Priority := 10;
    ApplyToEntireRow := True;
    Appearance.Fill.Color := gcLightgoldenrodyellow;
    Appearance.Font.Style := [TFontStyle.fsBold];
  end;

  // Quota %: data bar + below-target (<100) in red.
  FGrid.ConditionalFormatting.AddDataBar(COL_QUOTA, gcDodgerblue);
  with FGrid.ConditionalFormatting.AddCellValueRule(COL_QUOTA, gfcLess, '100') do
    Appearance.Font.Color := gcRed;

  // Pipeline: data bar (green).
  FGrid.ConditionalFormatting.AddDataBar(COL_PIPELINE, gcLimegreen);

  // Deals: arrow icon set (low->down, high->up).
  FGrid.ConditionalFormatting.AddIconSet(COL_DEALS, gisArrows4);

  // Win %: data bar (orange).
  FGrid.ConditionalFormatting.AddDataBar(COL_WIN, gcOrange);

  // Growth %: negative -> red, positive -> green, plus a traffic-light icon set.
  with FGrid.ConditionalFormatting.AddCellValueRule(COL_GROWTH, gfcLess, '0') do
    Appearance.Font.Color := gcRed;
  with FGrid.ConditionalFormatting.AddCellValueRule(COL_GROWTH, gfcGreater, '0') do
    Appearance.Font.Color := gcGreen;
  FGrid.ConditionalFormatting.AddIconSet(COL_GROWTH, gisTrafficLights3);

  // CSAT: 5-level icon set.
  FGrid.ConditionalFormatting.AddIconSet(COL_CSAT, gisStars5);

  // Status: text rules.
  with FGrid.ConditionalFormatting.AddTextRule(COL_STATUS, gfcEqual, 'Active') do
    Appearance.Font.Color := gcGreen;
  with FGrid.ConditionalFormatting.AddTextRule(COL_STATUS, gfcEqual, 'At Risk') do
  begin
    Appearance.Fill.Color := gcOldlace;
    Appearance.Font.Color := gcDarkorange;
  end;
  with FGrid.ConditionalFormatting.AddTextRule(COL_STATUS, gfcEqual, 'Churned') do
  begin
    Appearance.Fill.Color := gcMistyrose;
    Appearance.Font.Color := gcRed;
  end;
end;

end.
