unit DemoShot;

{ Demo check probe (tools/democheck.py). Linked into a scratch copy of a demo project only; never
  part of a shipped demo. Inert unless the environment variable DEMOSHOT_OUT is set.

  When the main form is up it runs every mode of DEMOSHOT_MODES ('|' separated):
    asis     the demo as it ships (its own ThemeManager, if any)
    none     no theme at all (TTMSFNCTheme.Apply(''))
    <theme>  a TTMSFNCThemeManager injected on the main form with Theme = <theme>
  and writes per mode <slug>.png (the main form's client area) and <slug>.json (every control:
  class, name, bounds in form pixels, visible, FNC or native, and under a theme the values the
  developer owns: TTMSFNCTheme.DeveloperValues). defaults.json holds the run-time defaults of every
  FNC class on the form (published leaf properties of a fresh instance) and the colour idents, so
  the scanner can tell default-equal form values from intentional ones. Then the demo terminates.

  Compile with DEMOSHOT_FMX or DEMOSHOT_VCL defined. }

interface

implementation

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, System.Types, System.UITypes,
  System.TypInfo, System.JSON, System.IOUtils, System.Generics.Collections,
  {$IFDEF DEMOSHOT_FMX}
  System.UIConsts, FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.TMSFNCCustomControl, FMX.TMSFNCTheme
  {$ELSE}
  Vcl.Forms, Vcl.Controls, Vcl.Graphics, Vcl.Imaging.pngimage, VCL.TMSFNCCustomControl, VCL.TMSFNCTheme
  {$ENDIF};

{$IFDEF DEMOSHOT_FMX}
type
  TShot = FMX.Graphics.TBitmap;
{$ELSE}
type
  TShot = Vcl.Graphics.TBitmap;
  TCommonCustomForm = TCustomForm;
{$ENDIF}

var
  OutDir: string;
  TimerId: UINT_PTR;
  Injected: TTMSFNCThemeManager;
  DefaultsDone: TDictionary<TClass, Boolean>;
  DefaultsJson: TJSONObject;

procedure Pump(AMs: Integer);
var
  t: Cardinal;
begin
  t := GetTickCount;
  repeat
    Application.ProcessMessages;
    CheckSynchronize(1);
    Sleep(5);
  until GetTickCount - t >= Cardinal(AMs);
end;

function Slug(const S: string): string;
var
  c: Char;
begin
  Result := '';
  for c in LowerCase(S) do
    if CharInSet(c, ['a'..'z', '0'..'9']) then
      Result := Result + c
    else if (Result <> '') and (Result[Length(Result)] <> '-') then
      Result := Result + '-';
end;

procedure SaveText(const AName, AText: string);
begin
  TFile.WriteAllText(TPath.Combine(OutDir, AName), AText, TEncoding.UTF8);
end;

{ ---- run-time defaults of a class: published leaf properties of a fresh instance ---- }

procedure DumpProps(AObj: TObject; const APrefix: string; ADepth: Integer; AOut: TJSONObject);
var
  list: PPropList;
  n, I: Integer;
  pi: PPropInfo;
  name: string;
  sub: TObject;
begin
  if not Assigned(AObj) or (ADepth > 4) or (AObj.ClassInfo = nil) then
    Exit;
  n := GetPropList(AObj.ClassInfo, tkProperties, nil);
  if n = 0 then
    Exit;
  GetMem(list, n * SizeOf(PPropInfo));
  try
    GetPropList(AObj.ClassInfo, tkProperties, list);
    for I := 0 to n - 1 do
    begin
      pi := list^[I];
      name := APrefix + string(pi^.Name);
      try
        case pi^.PropType^.Kind of
          tkInteger, tkInt64:
            AOut.AddPair(name, TJSONString.Create(IntToStr(GetInt64Prop(AObj, pi))));
          tkEnumeration:
            AOut.AddPair(name, TJSONString.Create(GetEnumProp(AObj, pi)));
          tkFloat:
            AOut.AddPair(name, TJSONString.Create(FloatToStr(GetFloatProp(AObj, pi), TFormatSettings.Invariant)));
          tkUString, tkLString, tkWString, tkString:
            AOut.AddPair(name, TJSONString.Create(GetStrProp(AObj, pi)));
          tkSet:
            AOut.AddPair(name, TJSONString.Create(GetSetProp(AObj, pi, True)));
          tkClass:
            begin
              sub := GetObjectProp(AObj, pi);
              if Assigned(sub) and (sub is TPersistent) and not (sub is TComponent) and not (sub is TCollection) then
                DumpProps(sub, name + '.', ADepth + 1, AOut);
            end;
        end;
      except
        { a getter that needs a parent or handle: no default known }
      end;
    end;
  finally
    FreeMem(list);
  end;
end;

procedure DumpDefaults(AComponent: TComponent);
var
  inst: TComponent;
  o: TJSONObject;
begin
  if DefaultsDone.ContainsKey(AComponent.ClassType) then
    Exit;
  DefaultsDone.Add(AComponent.ClassType, True);
  o := TJSONObject.Create;
  try
    inst := TComponentClass(AComponent.ClassType).Create(nil);
    try
      DumpProps(inst, '', 0, o);
    finally
      inst.Free;
    end;
  except
    on E: Exception do
      o.AddPair('#error', E.ClassName + ': ' + E.Message);
  end;
  DefaultsJson.AddPair(AComponent.ClassName, o);
end;

type
  TIdentSink = class
    Target: TJSONObject;
    procedure Add(const AName: string);
  end;

procedure TIdentSink.Add(const AName: string);
var
  v: Integer;
begin
  {$IFDEF DEMOSHOT_FMX}
  if IdentToAlphaColor(AName, v) then
    Target.AddPair(AName, TJSONString.Create(IntToStr(Int64(Cardinal(v)))));
  {$ELSE}
  if IdentToColor(AName, v) then
    Target.AddPair(AName, TJSONString.Create(IntToStr(v)));
  {$ENDIF}
end;

{ FMX streams alpha colours as cla<Name> or x<AARRGGBB>, VCL colours as cl<Name> or a number }
procedure DumpColorIdents;
var
  sink: TIdentSink;
begin
  sink := TIdentSink.Create;
  try
    sink.Target := TJSONObject.Create;
    {$IFDEF DEMOSHOT_FMX}
    GetAlphaColorValues(sink.Add);
    {$ELSE}
    GetColorValues(sink.Add);
    {$ENDIF}
    DefaultsJson.AddPair('#colors', sink.Target);
  finally
    sink.Free;
  end;
end;

{ ---- controls of the form ---- }

function IsFNC(AComponent: TComponent): Boolean;
var
  c: TClass;
begin
  c := AComponent.ClassType;
  while Assigned(c) do
  begin
    if SameText(Copy(c.UnitName, 1, 4), 'FMX.') and (Pos('TMSFNC', c.UnitName) > 0) then
      Exit(True);
    if SameText(Copy(c.UnitName, 1, 4), 'VCL.') and (Pos('TMSFNC', c.UnitName) > 0) then
      Exit(True);
    c := c.ClassParent;
  end;
  Result := False;
end;

function ControlInfo(AControl: TControl; AThemed: Boolean): TJSONObject;
var
  r: TRect;
  vis: Boolean;
  sl: TStringList;
  a: TJSONArray;
  s: string;
  {$IFDEF DEMOSHOT_FMX}
  rf: TRectF;
  {$ELSE}
  p, fp: TPoint;
  {$ENDIF}
begin
  Result := TJSONObject.Create;
  Result.AddPair('name', AControl.Name);
  Result.AddPair('class', AControl.ClassName);
  Result.AddPair('unit', AControl.UnitName);
  Result.AddPair('fnc', TJSONBool.Create(IsFNC(AControl)));
  {$IFDEF DEMOSHOT_FMX}
  vis := AControl.ParentedVisible;
  rf := AControl.AbsoluteRect;
  r := Rect(Round(rf.Left), Round(rf.Top), Round(rf.Right), Round(rf.Bottom));
  {$ELSE}
  vis := AControl.Visible and (not Assigned(AControl.Parent) or AControl.Parent.Showing);
  if vis and Assigned(AControl.Parent) and AControl.Parent.HandleAllocated then
  begin
    p := AControl.Parent.ClientToScreen(Point(AControl.Left, AControl.Top));
    fp := Application.MainForm.ClientToScreen(Point(0, 0));
    r := Rect(p.X - fp.X, p.Y - fp.Y, p.X - fp.X + AControl.Width, p.Y - fp.Y + AControl.Height);
  end
  else
    r := Rect(0, 0, 0, 0);
  {$ENDIF}
  Result.AddPair('visible', TJSONBool.Create(vis));
  a := TJSONArray.Create;
  a.Add(r.Left);
  a.Add(r.Top);
  a.Add(r.Right);
  a.Add(r.Bottom);
  Result.AddPair('rect', a);
  if AThemed and IsFNC(AControl) then
  begin
    sl := TStringList.Create;
    try
      TTMSFNCTheme.DeveloperValues(AControl, sl);
      a := TJSONArray.Create;
      for s in sl do
        a.Add(s);
      Result.AddPair('developer', a);
    finally
      sl.Free;
    end;
    Result.AddPair('theme', TTMSFNCTheme.EffectiveThemeName(AControl));
  end;
end;

{$IFDEF DEMOSHOT_FMX}
procedure Walk(AObj: TFmxObject; AThemed: Boolean; AOut: TJSONArray);
var
  I: Integer;
  c: TFmxObject;
begin
  for I := 0 to AObj.ChildrenCount - 1 do
  begin
    c := AObj.Children[I];
    if (c is TControl) and (c.Name <> '') then
    begin
      AOut.AddElement(ControlInfo(TControl(c), AThemed));
      if IsFNC(c) then
        DumpDefaults(c);
    end;
    if (c is TControl) and not TControl(c).Visible then
      Continue;
    Walk(c, AThemed, AOut);
  end;
end;
{$ELSE}
procedure Walk(AObj: TWinControl; AThemed: Boolean; AOut: TJSONArray);
var
  I: Integer;
  c: TControl;
begin
  for I := 0 to AObj.ControlCount - 1 do
  begin
    c := AObj.Controls[I];
    if c.Name <> '' then
    begin
      AOut.AddElement(ControlInfo(c, AThemed));
      if IsFNC(c) then
        DumpDefaults(c);
    end;
    if (c is TWinControl) and c.Visible then
      Walk(TWinControl(c), AThemed, AOut);
  end;
end;
{$ENDIF}

procedure Capture(AForm: TCommonCustomForm; const AName: string);
var
  s: TShot;
  {$IFNDEF DEMOSHOT_FMX}
  png: TPngImage;
  dc: HDC;
  {$ENDIF}
begin
  {$IFDEF DEMOSHOT_FMX}
  s := TShot.Create(Round(AForm.ClientWidth), Round(AForm.ClientHeight));
  try
    TForm(AForm).PaintTo(s.Canvas);
    s.SaveToFile(TPath.Combine(OutDir, AName + '.png'));
  finally
    s.Free;
  end;
  {$ELSE}
  RedrawWindow(AForm.Handle, nil, 0, RDW_INVALIDATE or RDW_ERASE or RDW_FRAME or RDW_ALLCHILDREN or RDW_UPDATENOW);
  Pump(150);
  GdiFlush;
  s := TShot.Create;
  png := TPngImage.Create;
  try
    s.PixelFormat := pf24bit;
    s.SetSize(AForm.ClientWidth, AForm.ClientHeight);
    dc := GetDC(AForm.Handle);
    try
      BitBlt(s.Canvas.Handle, 0, 0, AForm.ClientWidth, AForm.ClientHeight, dc, 0, 0, SRCCOPY);
    finally
      ReleaseDC(AForm.Handle, dc);
    end;
    png.Assign(s);
    png.SaveToFile(TPath.Combine(OutDir, AName + '.png'));
  finally
    png.Free;
    s.Free;
  end;
  {$ENDIF}
end;

procedure RunMode(AForm: TCommonCustomForm; const AMode: string);
var
  themed: Boolean;
  arr: TJSONArray;
  o: TJSONObject;
  name: string;
begin
  name := Slug(AMode);
  if SameText(AMode, 'none') then
  begin
    if Assigned(Injected) then
      Injected.Theme := '';
    TTMSFNCTheme.Apply('');
  end
  else if not SameText(AMode, 'asis') then
  begin
    if not Assigned(Injected) then
      Injected := TTMSFNCThemeManager.Create(AForm);
    Injected.Theme := AMode;
  end;
  Pump(900);
  AForm.Invalidate;
  Pump(300);
  Capture(AForm, name);
  themed := TTMSFNCTheme.Current <> '';
  arr := TJSONArray.Create;
  o := TJSONObject.Create;
  try
    o.AddPair('mode', AMode);
    o.AddPair('theme', TTMSFNCTheme.Current);
    o.AddPair('form', AForm.ClassName);
    o.AddPair('width', TJSONNumber.Create(Round(AForm.ClientWidth)));
    o.AddPair('height', TJSONNumber.Create(Round(AForm.ClientHeight)));
    {$IFDEF DEMOSHOT_FMX}
    Walk(AForm, themed, arr);
    {$ELSE}
    Walk(TWinControl(AForm), themed, arr);
    {$ENDIF}
    o.AddPair('controls', arr);
    SaveText(name + '.json', o.Format(1));
  finally
    o.Free;
  end;
end;

procedure Run;
var
  f: TCommonCustomForm;
  modes: TArray<string>;
  m: string;
begin
  try
    f := Application.MainForm;
    if not Assigned(f) then
    begin
      SaveText('error.txt', 'no main form');
      Halt(2);
    end;
    modes := GetEnvironmentVariable('DEMOSHOT_MODES').Split(['|']);
    if Length(modes) = 0 then
      modes := ['asis', 'Fluent Light', 'Fluent Dark'];
    DefaultsDone := TDictionary<TClass, Boolean>.Create;
    DefaultsJson := TJSONObject.Create;
    try
      DumpColorIdents;
      for m in modes do
        if Trim(m) <> '' then
          RunMode(f, Trim(m));
      SaveText('defaults.json', DefaultsJson.Format(1));
    finally
      DefaultsJson.Free;
      DefaultsDone.Free;
    end;
    SaveText('done.txt', 'ok');
  except
    on E: Exception do
      SaveText('error.txt', E.ClassName + ': ' + E.Message);
  end;
  Halt(0);
end;

type
  TErrorSink = class
    procedure HandleException(Sender: TObject; E: Exception);
  end;

var
  ErrorSink: TErrorSink;

{ an exception (a form that does not stream, an error in FormCreate) would show a dialog nobody
  closes on the hidden desktop: it is written to error.txt and the demo ends }
procedure TErrorSink.HandleException(Sender: TObject; E: Exception);
begin
  SaveText('error.txt', E.ClassName + ': ' + E.Message);
  Halt(3);
end;

procedure UnhandledException(ExceptObject: TObject; ExceptAddr: Pointer);
begin
  if ExceptObject is Exception then
    SaveText('error.txt', ExceptObject.ClassName + ': ' + Exception(ExceptObject).Message)
  else
    SaveText('error.txt', 'unhandled exception');
  Halt(3);
end;

procedure TimerProc(AWnd: HWND; AMsg: UINT; AId: UINT_PTR; ATime: DWORD); stdcall;
begin
  KillTimer(0, TimerId);
  TimerId := 0;
  Run;
end;

initialization
  OutDir := GetEnvironmentVariable('DEMOSHOT_OUT');
  if OutDir <> '' then
  begin
    ForceDirectories(OutDir);
    ErrorSink := TErrorSink.Create;
    Application.OnException := ErrorSink.HandleException;
    ExceptProc := @UnhandledException;
    TimerId := SetTimer(0, 0, StrToIntDef(GetEnvironmentVariable('DEMOSHOT_DELAY'), 2500), @TimerProc);
  end;

end.
