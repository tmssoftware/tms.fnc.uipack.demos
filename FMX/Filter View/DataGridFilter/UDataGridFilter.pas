unit UDataGridFilter;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  System.Rtti, FMX.TMSFNCDataGridCell, FMX.TMSFNCDataGridData,
  FMX.TMSFNCDataGridBase, FMX.TMSFNCDataGridCore, FMX.TMSFNCDataGridRenderer,
  TMS.TMSFNCFilterBuilder, TMS.TMSFNCFilterStructure, FMX.TMSFNCHTMLText,
  FMX.TMSFNCFilterView, FMX.TMSFNCPanel, FMX.Layouts, FMX.TMSFNCCustomControl,
  FMX.TMSFNCDataGrid, FMX.ListBox, FMX.TMSFNCCalendar, FMX.TMSFNCImage,
  FMX.TMSFNCToolBar;

type
  TFilterViewDataGridForm = class(TForm)
    TMSFNCFilterView1: TTMSFNCFilterView;
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    TMSFNCFilterView1_FilterPanel1_FilterExpressionValueEdit1: TTMSFNCFilterViewExpressionValueEdit;
    ControlContainer: TTMSFNCFilterViewControlContainer;
    TMSFNCFilterViewLabel1: TTMSFNCFilterViewLabel;
    TMSFNCCalendar1: TTMSFNCCalendar;
    TMSFNCFilterViewLabel2: TTMSFNCFilterViewLabel;
    OfficeBtn: TTMSFNCToolBarButton;
    AllBtn: TTMSFNCToolBarButton;
    FlightBtn: TTMSFNCToolBarButton;
    AbroadBtn: TTMSFNCToolBarButton;
    OnLeaveBtn: TTMSFNCToolBarButton;
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCFilterView1FilterTextChanged(Sender: TObject;
      AFilterText: string);
    procedure TMSFNCCalendar1SelectDate(Sender: TObject; ADate: TDate);
    procedure TMSFNCFilterViewControlContainer1SetFilterItem(Sender: TObject; APropertyValue: string; var AFilterItemParameters: TTMSFNCFilterViewExpressionParameters);
    procedure AllBtnClick(Sender: TObject);
    procedure OfficeBtnClick(Sender: TObject);
    procedure FlightBtnClick(Sender: TObject);
    procedure AbroadBtnClick(Sender: TObject);
    procedure OnLeaveBtnClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UpdateFilter;
    procedure StatusClicked(AIndex: Integer);
  end;

var
  FilterViewDataGridForm: TFilterViewDataGridForm;

implementation

{$R *.fmx}

procedure TFilterViewDataGridForm.FormCreate(Sender: TObject);
begin
  TMSFNCDataGrid1.LoadSampleData;
  TMSFNCDataGrid1.Options.Filtering.Advanced := True;
  TMSFNCDataGrid1.Options.Filtering.Actions := [gdfaApplyAppearance];

  TMSFNCFilterView1.AddCustomItemControl(TMSFNCCalendar1, TMSFNCCalendar1.SelectedDate, 'Joined', fdtDate, feoSmallerThanOrEqual);

  UpdateFilter;
end;

procedure TFilterViewDataGridForm.StatusClicked(AIndex: Integer);
begin
  OfficeBtn.DownState := AIndex = 0;
  FlightBtn.DownState := AIndex = 1;
  AbroadBtn.DownState := AIndex = 2;
  OnLeaveBtn.DownState := AIndex = 3;

  ControlContainer.FilterExpression.FilterFieldName := 'Status';
  ControlContainer.FilterExpression.FilterFieldType := fdtText;
  ControlContainer.FilterExpression.ExpressionOperator := feoEqual;
    ControlContainer.FilterExpression.AddToFilter := False;



  case AIndex of
    0: ControlContainer.FilterExpression.FilterValue := 'Office';
    1: ControlContainer.FilterExpression.FilterValue := 'Flight';
    2: ControlContainer.FilterExpression.FilterValue := 'Abroad';
    3: ControlContainer.FilterExpression.FilterValue := 'On Leave';
  end;
  ControlContainer.FilterExpression.AddToFilter := (AIndex <= 4) and (AIndex >= 0);
end;

procedure TFilterViewDataGridForm.TMSFNCCalendar1SelectDate(Sender: TObject; ADate: TDate);
begin
  TMSFNCFilterView1.UpdateCustomItemControlValue(TMSFNCCalendar1, ADate);
end;

procedure TFilterViewDataGridForm.TMSFNCFilterView1FilterTextChanged(Sender: TObject; AFilterText: string);
begin
  UpdateFilter;
end;

procedure TFilterViewDataGridForm.TMSFNCFilterViewControlContainer1SetFilterItem(Sender: TObject; APropertyValue: string; var AFilterItemParameters: TTMSFNCFilterViewExpressionParameters);
begin
  AFilterItemParameters.AddToFilter := TMSFNCCalendar1.SelectedDate <> Now;
end;

procedure TFilterViewDataGridForm.FlightBtnClick(Sender: TObject);
begin
  StatusClicked(1);
end;

procedure TFilterViewDataGridForm.AbroadBtnClick(Sender: TObject);
begin
  StatusClicked(2);
end;

procedure TFilterViewDataGridForm.OnLeaveBtnClick(Sender: TObject);
begin
  StatusClicked(3);
end;

procedure TFilterViewDataGridForm.AllBtnClick(Sender: TObject);
begin
  StatusClicked(-1);
end;

procedure TFilterViewDataGridForm.OfficeBtnClick(Sender: TObject);
begin
  StatusClicked(0);
end;

procedure TFilterViewDataGridForm.UpdateFilter;
begin
  TTMSFNCUtils.Log(TMSFNCFilterView1.FilterText);
  if Assigned(TMSFNCDataGrid1) then
  begin
    TMSFNCDataGrid1.ClearFilter;
    TMSFNCDataGrid1.FilterBuilder.FilterText := TMSFNCFilterView1.FilterText;
    TMSFNCDataGrid1.ApplyFilter;
  end;
end;

end.
