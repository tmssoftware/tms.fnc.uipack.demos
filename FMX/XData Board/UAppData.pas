unit UAppData;

interface

uses
  System.SysUtils, System.Classes, Data.DB, TMS.TMSFNCDataSettings, FMX.TMSFNCDataSettingsDialogs,
  TMS.TMSFNCCustomDataLink, TMS.TMSFNCDataLinkJSON, FMX.TMSFNCDataLinkREST,
  TMS.TMSFNCDataSet;

type
  TAppData = class(TDataModule)
    DataSettings: TTMSFNCDataSettings;
    dsOrder: TTMSFNCDataSet;
    linkOrder: TTMSFNCDataLinkREST;
    dsDsOrder: TDataSource;
    dsTask: TTMSFNCDataSet;
    linkTask: TTMSFNCDataLinkREST;
    dsDsTask: TDataSource;
  private
  public
  end;

var
  AppData: TAppData;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

initialization
  { Debug builds connect with the Development settings, Release builds with Production }
  {$IFDEF DEBUG}
  TTMSFNCDataSettings.DefaultProfile := TMSFNCDataProfileDevelopment;
  {$ELSE}
  TTMSFNCDataSettings.DefaultProfile := TMSFNCDataProfileProduction;
  {$ENDIF}

end.
