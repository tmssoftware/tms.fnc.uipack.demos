unit UStelllarDS;

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
  Data.Bind.Components, Data.Bind.DBScope,
  FMX.TMSFNCCloudStellarDataStoreDataSet, FMX.TMSFNCCloudImage;

type
  TForm130 = class(TForm)
    Z: TPanel;
    Button2: TButton;
    TMSFNCDataGrid1: TTMSFNCDataGrid;
    BindNavigator1: TBindNavigator;
    TMSFNCDataGridDatabaseAdapter1: TTMSFNCDataGridDatabaseAdapter;
    DataSource1: TDataSource;
    BindSourceDB1: TBindSourceDB;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Panel1: TPanel;
    Button3: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Button4: TButton;
    Button5: TButton;
    pnAuth: TPanel;
    Label5: TLabel;
    edClientID: TEdit;
    edSecret: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label3: TLabel;
    edCallbackURL: TEdit;
    lbConnected: TLabel;
    btConnect: TButton;
    Label4: TLabel;
    Label8: TLabel;
    TMSFNCCloudImage1: TTMSFNCCloudImage;
    Label10: TLabel;
    edProjectID: TEdit;
    TMSFNCCloudStellarDataStoreDataSetFMX1: TTMSFNCCloudStellarDataStoreDataSetFMX;
    procedure FormCreate(Sender: TObject);
    procedure CheckBox1Change(Sender: TObject);
    procedure CheckBox2Change(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Edit1ChangeTracking(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure TMSFNCDataGrid1GetInplaceEditorProperties(Sender: TObject;
      ACell: TTMSFNCDataGridCellCoord;
      AInplaceEditor: TTMSFNCDataGridInplaceEditor;
      AInplaceEditorType: TTMSFNCDataGridInplaceEditorType);
    procedure TMSFNCDataGrid1GetCellFormatting(Sender: TObject;
      ACell: TTMSFNCDataGridCellCoord; AData: TTMSFNCDataGridCellValue;
      var AFormatting: TTMSFNCDataGridDataFormatting;
      var AConvertSettings: TFormatSettings; var ACanFormat: Boolean);
    procedure TMSFNCDataGrid1BeforeSortColumn(Sender: TObject; AColumn: Integer;
      var ACanSort: Boolean);
    procedure btConnectClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edClientIDChangeTracking(Sender: TObject);
    procedure edSecretChangeTracking(Sender: TObject);
    procedure edCallbackURLChangeTracking(Sender: TObject);
    procedure edProjectIDChangeTracking(Sender: TObject);
    procedure TMSFNCCloudStellarDataStoreDataSetFMX1AfterClose(
      DataSet: TDataSet);
  private
    { Private declarations }
    procedure DoConnected(Sender: TObject);
  public
    { Public declarations }
    procedure InitTable;
  end;

var
  Form130: TForm130;

implementation

{$R *.fmx}

uses
  FMX.TMSFNCCloudStellarDataStore;

procedure TForm130.btConnectClick(Sender: TObject);
begin
  TMSFNCCloudStellarDataStoreDataSetFMX1.Active := not TMSFNCCloudStellarDataStoreDataSetFMX1.Active;
  if TMSFNCCloudStellarDataStoreDataSetFMX1.Active then
    btConnect.Text := 'Disconnect'
  else
  begin
    btConnect.Text := 'Connect';
    TMSFNCCloudStellarDataStoreDataSetFMX1.Adapter.OnConnected := DoConnected;
  end;
end;

procedure TForm130.Button3Click(Sender: TObject);
begin
  Edit1.Text := '';
  Edit1.Text := 'S*';
end;

procedure TForm130.Button4Click(Sender: TObject);
begin
  TMSFNCDataGrid1.Sort(1, gsdAscending);
end;

procedure TForm130.Button5Click(Sender: TObject);
begin
  TMSFNCDataGrid1.Sort(1, gsdDescending);
end;

procedure TForm130.CheckBox1Change(Sender: TObject);
begin
  TMSFNCDataGridDatabaseAdapter1.ShowPictureFields := CheckBox1.IsChecked;
end;

procedure TForm130.CheckBox2Change(Sender: TObject);
begin
  TMSFNCDataGridDatabaseAdapter1.ShowMemoFields := CheckBox2.IsChecked;
end;

procedure TForm130.DoConnected(Sender: TObject);
begin
  lbConnected.Text := 'Connected!';
  if TMSFNCCloudStellarDataStoreDataSetFMX1.Active then
    btConnect.Text := 'Disconnect'
  else
    btConnect.Text := 'Connect';

  InitTable;
end;

procedure TForm130.edCallbackURLChangeTracking(Sender: TObject);
begin
  TMSFNCCloudStellarDataStoreDataSetFMX1.Adapter.Authentication.CallBackURL := edCallbackURL.Text;
end;

procedure TForm130.edClientIDChangeTracking(Sender: TObject);
begin
  TMSFNCCloudStellarDataStoreDataSetFMX1.Authentication.ClientID := edClientID.Text;
end;

procedure TForm130.Edit1ChangeTracking(Sender: TObject);
var
  fltr : TTMSFNCDataGridDataFilterData;
begin
  TMSFNCDataGrid1.ClearFilter;
  if Edit1.Text <> '' then
  begin
    fltr := TMSFNCDataGrid1.Filter.Add;

    fltr.Column := 2;
    fltr.CaseSensitive := false;
    fltr.Condition := Edit1.Text;

    TMSFNCDataGrid1.ApplyFilter;
  end;
end;

procedure TForm130.edProjectIDChangeTracking(Sender: TObject);
begin
  TMSFNCCloudStellarDataStoreDataSetFMX1.ProjectID := edProjectID.Text;
  TMSFNCCloudStellarDataStoreDataSetFMX1.PersistTokens.Extra := edProjectID.Text;
end;

procedure TForm130.edSecretChangeTracking(Sender: TObject);
begin
  TMSFNCCloudStellarDataStoreDataSetFMX1.Adapter.Authentication.Secret := edSecret.Text;
end;

procedure TForm130.FormCreate(Sender: TObject);
begin
  TMSFNCDataGridDatabaseAdapter1.LoadMode := almAllRecords;
  TMSFNCCloudStellarDataStoreDataSetFMX1.Adapter.PersistTokens.SaveClientID := True;
  TMSFNCCloudStellarDataStoreDataSetFMX1.Adapter.PersistTokens.SaveSecret := True;
  TMSFNCCloudStellarDataStoreDataSetFMX1.Adapter.PersistTokens.SaveCallBack := True;
  TMSFNCCloudStellarDataStoreDataSetFMX1.Adapter.PersistTokens.SaveExtra := True;

  TMSFNCCloudStellarDataStoreDataSetFMX1.Adapter.PersistTokens.Key := 'StellarDataStoreConnection.ini';
  TMSFNCCloudStellarDataStoreDataSetFMX1.Adapter.LoadTokens;


  edClientID.Text := TMSFNCCloudStellarDataStoreDataSetFMX1.Authentication.ClientID;
  edSecret.Text := TMSFNCCloudStellarDataStoreDataSetFMX1.Authentication.Secret;
  edCallbackURL.Text := TMSFNCCloudStellarDataStoreDataSetFMX1.Authentication.CallBackURL;
  edProjectID.Text := TMSFNCCloudStellarDataStoreDataSetFMX1.PersistTokens.Extra;

  TMSFNCCloudStellarDataStoreDataSetFMX1.Table := 'DataGridDemo';
  TMSFNCCloudStellarDataStoreDataSetFMX1.Adapter.OnConnected := DoConnected;

  TMSFNCDataGrid1.Options.Sorting.Enabled := True;
  TMSFNCDataGrid1.Options.Filtering.Enabled := True;
  TMSFNCDataGrid1.ScrollMode := gsmCellScrolling;
end;

procedure TForm130.FormDestroy(Sender: TObject);
begin
  TMSFNCCloudStellarDataStoreDataSetFMX1.Adapter.SaveTokens;
end;

procedure TForm130.InitTable;
var
  StellarDataStore: TTMSFNCCloudStellarDataStore;
  t: TTMSFNCCloudStellarDataStoreTable;
  mi: TTMSFNCCloudStellarDataStoreMetaDataItem;
  et: TTMSFNCCloudStellarDataStoreEntity;
begin
  if not TMSFNCCloudStellarDataStoreDataSetFMX1.Active then
    Exit;

  StellarDataStore := TMSFNCCloudStellarDataStoreDataSetFMX1.Adapter;
  StellarDataStore.GetTables;

  t := StellarDataStore.TableByName(TMSFNCCloudStellarDataStoreDataSetFMX1.Table);
  if not Assigned(t) then
  begin
    t := TTMSFNCCloudStellarDataStoreTable.Create(StellarDataStore.Tables);
    t.Name := TMSFNCCloudStellarDataStoreDataSetFMX1.Table;
    StellarDataStore.AddTable(t);

    StellarDataStore.TableId := t.ID;

    mi := StellarDataStore.MetaData.Add;
    mi.PropertyName := 'FirstName';
    mi.DataType := ftString;
    StellarDataStore.AddMetaData(mi);

    mi := StellarDataStore.MetaData.Add;
    mi.PropertyName := 'LastName';
    mi.DataType := ftString;
    StellarDataStore.AddMetaData(mi);

    mi := StellarDataStore.MetaData.Add;
    mi.PropertyName := 'Email';
    mi.DataType := ftString;
    StellarDataStore.AddMetaData(mi);

    mi := StellarDataStore.MetaData.Add;
    mi.PropertyName := 'Joined';
    mi.DataType := ftDateTime;
    StellarDataStore.AddMetaData(mi);

    mi := StellarDataStore.MetaData.Add;
    mi.PropertyName := 'Admin';
    mi.DataType := ftBoolean;
    StellarDataStore.AddMetaData(mi);

    mi := StellarDataStore.MetaData.Add;
    mi.PropertyName := 'Avatar';
    mi.DataType := ftBlob;
    StellarDataStore.AddMetaData(mi);

    StellarDataStore.GetMetaData;

    et := StellarDataStore.Entities.Add as TTMSFNCCloudStellarDataStoreEntity;
    et.Values['FirstName'] := 'Isaac';
    et.Values['LastName'] := 'Tailor';
    et.Values['Email'] := 'isaac@contacts.com';
    et.Values['Admin'] := True;
    et.Values['Joined'] := EncodeDate(2009, 11, 10);
    StellarDataStore.Insert(et);

    et := StellarDataStore.Entities.Add as TTMSFNCCloudStellarDataStoreEntity;
    et.Values['FirstName'] := 'Laura';
    et.Values['LastName'] := 'Schneider';
    et.Values['Email'] := 'laura@contacts.com';
    et.Values['Admin'] := False;
    et.Values['Joined'] := EncodeDate(2011, 06, 21);
    StellarDataStore.Insert(et);

    et := StellarDataStore.Entities.Add as TTMSFNCCloudStellarDataStoreEntity;
    et.Values['FirstName'] := 'Leon';
    et.Values['LastName'] := 'Sastre';
    et.Values['Email'] := 'leon@contacts.com';
    et.Values['Admin'] := False;
    et.Values['Joined'] := EncodeDate(1996, 02, 01);
    StellarDataStore.Insert(et);

    et := StellarDataStore.Entities.Add as TTMSFNCCloudStellarDataStoreEntity;
    et.Values['FirstName'] := 'Marie';
    et.Values['LastName'] := 'Tailleur';
    et.Values['Email'] := 'marie@contacts.com';
    et.Values['Admin'] := False;
    et.Values['Joined'] := EncodeDate(2014, 07, 06);
    StellarDataStore.Insert(et);
  end
  else
    StellarDataStore.TableId := t.ID;

  TMSFNCCloudStellarDataStoreDataSetFMX1.Adapter.OnConnected := nil;
  TMSFNCCloudStellarDataStoreDataSetFMX1.Active := False;
  TMSFNCCloudStellarDataStoreDataSetFMX1.Active := True;
end;

procedure TForm130.TMSFNCCloudStellarDataStoreDataSetFMX1AfterClose(
  DataSet: TDataSet);
begin
  lbConnected.Text := '';
  if TMSFNCCloudStellarDataStoreDataSetFMX1.Active then
    btConnect.Text := 'Disconnect'
  else
    btConnect.Text := 'Connect';
end;

procedure TForm130.TMSFNCDataGrid1BeforeSortColumn(Sender: TObject;
  AColumn: Integer; var ACanSort: Boolean);
begin
  ACanSort := not (AColumn in [6, 7]);
end;

procedure TForm130.TMSFNCDataGrid1GetCellFormatting(Sender: TObject;
  ACell: TTMSFNCDataGridCellCoord; AData: TTMSFNCDataGridCellValue;
  var AFormatting: TTMSFNCDataGridDataFormatting;
  var AConvertSettings: TFormatSettings; var ACanFormat: Boolean);
begin
  if ACell.Column in [4] then
  begin
    AFormatting.Format := '%g';
    AFormatting.&Type := gdftNumber;
  end
  else if ACell.Column in [5] then
  begin
    AFormatting.Format := '%' + FormatSettings.DecimalSeparator + '2f';
    AFormatting.&Type := gdftNumber;
  end;
end;

procedure TForm130.TMSFNCDataGrid1GetInplaceEditorProperties(Sender: TObject;
  ACell: TTMSFNCDataGridCellCoord; AInplaceEditor: TTMSFNCDataGridInplaceEditor;
  AInplaceEditorType: TTMSFNCDataGridInplaceEditorType);
begin
  if (AInplaceEditorType = getFloatEdit) then
  begin
    if ACell.Column in [4] then
      (AInplaceEditor as TTMSFNCDataGridEdit).Precision := 0
    else
      (AInplaceEditor as TTMSFNCDataGridEdit).Precision := 2;
  end;
end;

end.
