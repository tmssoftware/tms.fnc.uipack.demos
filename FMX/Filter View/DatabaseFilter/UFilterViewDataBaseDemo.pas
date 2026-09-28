unit UFilterViewDataBaseDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Edit, FMX.TMSFNCCustomControl, FMX.TMSFNCTypes,
  FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, System.Rtti,
  FMX.TMSFNCDataGridCell, FMX.TMSFNCDataGridData, FMX.TMSFNCDataGridBase,
  FMX.TMSFNCDataGridCore, FMX.TMSFNCDataGridRenderer, Data.Bind.Controls,
  Data.DB, FMX.TMSFNCCustomComponent, FMX.TMSFNCDataGridDatabaseAdapter,
  Datasnap.DBClient, FMX.Layouts, Fmx.Bind.Navigator, FMX.TMSFNCDataGrid,
  Data.Bind.Components, Data.Bind.DBScope, FMX.TMSFNCFilterView,
  FMX.TMSFNCHTMLText, FMX.TMSFNCTrackBar, FMX.TMSFNCHTMLImageContainer,
  FMX.TMSFNCCheckBox, FMX.ListBox, FMX.TMSFNCPanel, TMS.TMSFNCFilterBuilder, TMS.TMSFNCValue,
  TMS.TMSFNCFilterStructure;

type
  TFilterViewDemoForm = class(TForm)
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    TMSFNCDataGridDatabaseAdapter1: TTMSFNCDataGridDatabaseAdapter;
    DataSource1: TDataSource;
    BindSourceDB1: TBindSourceDB;
    AnimalDataSet: TClientDataSet;
    TMSFNCFilterView1: TTMSFNCFilterView;
    TMSFNCHTMLText1: TTMSFNCHTMLText;
    ExtinctCheck: TTMSFNCFilterViewCheckBox;
    Label1: TLabel;
    SizeTrackBar: TTMSFNCFilterViewTrackBar;
    SizeValueLbl: TLabel;
    TMSFNCFilterViewExpressionValueEdit1: TTMSFNCFilterViewExpressionValueEdit;
    CustomAreaComboBox: TComboBox;
    LblArea: TLabel;
    TMSFNCFilterViewPanel1: TTMSFNCFilterViewPanel;
    SecondCondition: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure SizeTrackBarChanged(Sender: TObject);
    procedure TMSFNCFilterView1FilterTextChanged(Sender: TObject; AFilterText: string);
    procedure CustomAreaComboBoxChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SecondConditionChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    NameCombo2: TTMSFNCFilterViewExpressionValueEdit;
    secondEO: TTMSFNCFilterBuilderExpressionOperator;
    secondValue: TTMSFNCValue;

    ComboBoxFilterExpressions: TTMSFNCFilterViewExpressions;
    procedure InitializeComboBox;
    procedure DoDefaultExpression(Sender: TObject; APropertyValue: string; var AFilterItemParameters: TTMSFNCFilterViewExpressionParameters);
    procedure SetAreaExpressionValueEdits;
  end;

var
  FilterViewDemoForm: TFilterViewDemoForm;

implementation

{$R *.fmx}


procedure TFilterViewDemoForm.SecondConditionChange(Sender: TObject);
begin
  TMSFNCFilterViewPanel1.BeginUpdate;
  if SecondCondition.IsChecked then
  begin
    if not Assigned(NameCombo2) then
    begin
      NameCombo2 := TMSFNCFilterViewPanel1.AddFilterExpressionValueEdit(FNCValueToString(secondValue, FormatSettings), 'NAME', fdtText, secondEO);
      NameCombo2.Height := TMSFNCFilterViewExpressionValueEdit1.Height;
      NameCombo2.Align := TAlignLayout.Top;
      NameCombo2.Position.Y := 800;
      NameCombo2.ShowNameLabel := False;
      if TMSFNCFilterViewPanel1.GroupOperator = fgoAND then
        SecondCondition.Text := TMSFNCFilterView1.UILanguage.AndOperatorText
      else
        SecondCondition.Text := TMSFNCFilterView1.UILanguage.OrOperatorText;
    end;
  end
  else if Assigned(NameCombo2) then
  begin
    secondValue := NameCombo2.FilterExpression.FilterValue;
    secondEO := NameCombo2.FilterExpression.ExpressionOperator;
    SecondCondition.Text := 'Add second condition';
    FreeAndNil(NameCombo2);
  end;
  TMSFNCFilterViewPanel1.EndUpdate;
  TMSFNCFilterViewPanel1.UpdateHeight;
end;

procedure TFilterViewDemoForm.CustomAreaComboBoxChange(Sender: TObject);
begin
  if CustomAreaComboBox.ItemIndex >= 0  then
  begin
    //Update the Filter Item in the Filter Structure
    ComboBoxFilterExpressions.UpdateFilterItem(CustomAreaComboBox.Items[CustomAreaComboBox.ItemIndex]);
  end;
end;

//Customize the epxression before it is updated to the Filter Structure
procedure TFilterViewDemoForm.DoDefaultExpression(Sender: TObject; APropertyValue: string; var AFilterItemParameters: TTMSFNCFilterViewExpressionParameters);
begin
  AFilterItemParameters.FilterValue := APropertyValue;
  //Do not add the filter if the value is 'All'
  AFilterItemParameters.AddToFilter := not (APropertyValue = 'All');
end;

procedure TFilterViewDemoForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(NameCombo2) then
    FreeAndNil(NameCombo2);
  FreeAndNil(ComboBoxFilterExpressions);
  FreeAndNil(CustomAreaComboBox);
end;

procedure TFilterViewDemoForm.FormCreate(Sender: TObject);
begin
  secondEO := feoStartsWith;
  secondValue := 'B';
  SizeTrackBarChanged(SizeTrackBar);
  InitializeComboBox;
end;

//Create ComboBox
procedure TFilterViewDemoForm.InitializeComboBox;
begin
  CustomAreaComboBox.Items.Clear;
  ComboBoxFilterExpressions := TTMSFNCFilterViewExpressions.Create(CustomAreaComboBox);

  //Default properties to add the expression to the Filter Structure
  ComboBoxFilterExpressions.DefaultFilterProperties.FilterFieldName := 'AREA';
  ComboBoxFilterExpressions.DefaultFilterProperties.FilterFieldType := fdtText;
  ComboBoxFilterExpressions.DefaultFilterProperties.ExpressionOperator := feoEqual;
  ComboBoxFilterExpressions.OnExpressionNotFound := DoDefaultExpression;

  ComboBoxFilterExpressions.AddFilterItem('All');
  //Add values to combobox
  SetAreaExpressionValueEdits;
end;

// Get DISTINCT values from the DataSet
procedure TFilterViewDemoForm.SetAreaExpressionValueEdits;
var
  s: string;
  ds: TDataSet;
  f: TField;
  fd: Boolean;
  sl: TStringList;
begin
  CustomAreaComboBox.Items.Clear;
  sl := TStringList.Create;
  try

    if Assigned(AnimalDataSet) and AnimalDataSet.Active then
    begin
      f := AnimalDataSet.FieldByName('AREA');

      if Assigned(f) and Assigned(f.DataSet) then
      begin
        f.DataSet.DisableControls;

        fd := f.DataSet.Filtered;
        f.DataSet.Filtered := False;
        ds := f.DataSet;

        if Assigned(ds) then
        begin
          try
            ds.First;

            while not ds.Eof do
            begin
              s := ds.FieldByName(f.FieldName).AsString;
              if sl.IndexOf(s) < 0 then
                sl.Add(s);
              ds.Next;
            end;
          finally
            f.DataSet.Filtered := fd;
            f.DataSet.EnableControls;
          end;
        end;
      end;
    end;
	
    sl.Sort;

    CustomAreaComboBox.Items.Add('All');
    CustomAreaComboBox.Items.AddStrings(sl);

    CustomAreaComboBox.ItemIndex := 0;

  finally
    sl.Free
  end;
end;

procedure TFilterViewDemoForm.TMSFNCFilterView1FilterTextChanged(Sender: TObject; AFilterText: string);
begin
  if Assigned(AnimalDataSet) then
  begin
    AnimalDataSet.Filter := AFilterText;
    AnimalDataSet.Filtered := AFilterText <> '';
  end;
end;

procedure TFilterViewDemoForm.SizeTrackBarChanged(Sender: TObject);
begin
  SizeValueLbl.Text := SizeTrackBar.Value.ToString;
end;

end.
