unit DemoShot;

{ Demo check probe (tools/democheck.py). Linked into a scratch copy of a demo project only; never
  part of a shipped demo. Inert unless the environment variable DEMOSHOT_OUT is set.

  When the main form is up it runs every mode of DEMOSHOT_MODES ('|' separated):
    asis     the demo as it ships (its own ThemeManager, if any)
    none     no theme at all (TTMSFNCTheme.Apply(''))
    <theme>  a TTMSFNCThemeManager injected on the main form with Theme = <theme>
    smoke    no capture: the form came up and the demo ends (the start check of democheck smoke)
    click    the click-through of democheck click: under 'Fluent Light' every reachable control is clicked
             once (newly shown controls first), pop-ups and dialogs are captured and closed, the keyboard
             walks the tab order, the form is resized; then 'Fluent Dark' with the pop-ups opened again.
             Writes click.json (steps, exceptions, windows, geometry issues, focus walk) and NN-*.png.
             DEMOSHOT_PPI emulates a DPI from the start (VCL: GetDpiForMonitor detour, a form that does
             not follow is scaled with ScaleForPPI; FMX: forced window scale). ShellExecute is logged,
             never run.
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
  System.TypInfo, System.JSON, System.IOUtils, System.Generics.Collections, System.Math, System.Rtti,
  {$IFDEF DEMOSHOT_FMX}
  System.UIConsts, FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Platform.Win, FMX.TMSFNCCustomControl,
  FMX.TMSFNCTheme
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
  LastPumpTick: Cardinal;
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
    LastPumpTick := GetTickCount;
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

{ Ends the demo. A leak report is a modal dialog nobody closes on the hidden desktop, so it is switched
  off. A normal end goes through Application.Terminate: Halt while the form is alive made the leak
  report list the whole form (and every demo with ReportMemoryLeaksOnShutdown hung at exit). }
procedure Finish(ACode: Integer);
begin
  ReportMemoryLeaksOnShutdown := False;
  if ACode = 0 then
    Application.Terminate
  else
    Halt(ACode);
end;

{ ---- click-through ---- }

var
  ClickPPI: Integer;
  Clicking: Boolean;
  StepLog: TJSONArray;
  CurStep: TJSONObject;
  ShellLog: TJSONArray;
  StepPre: TList<HWND>;
  CurAct: string;
  WatchId: UINT_PTR;
  ShotNo: Integer;
  MainWnd: HWND;

function ClickScale: Single;
begin
  if ClickPPI > 0 then
    Result := ClickPPI / 96
  else
    Result := 1;
end;

{ shell32 ShellExecuteW / ShellExecuteExW: a demo link or "open file" must not start a program }

function FakeShellExecuteW(AWnd: HWND; AOperation, AFile, AParameters, ADirectory: PChar; AShowCmd: Integer): HINST; stdcall;
begin
  if Assigned(ShellLog) then
    ShellLog.Add(string(AFile) + ' ' + string(AParameters));
  Result := 33;
end;

function FakeShellExecuteExW(AInfo: Pointer): BOOL; stdcall;
begin
  if Assigned(ShellLog) then
    ShellLog.Add('ShellExecuteEx');
  Result := True;
end;

function FakeGetDpiForMonitor(AMonitor: THandle; ADpiType: Integer; out ADpiX, ADpiY: Cardinal): HRESULT; stdcall;
begin
  ADpiX := ClickPPI;
  ADpiY := ClickPPI;
  Result := S_OK;
end;

procedure Detour(const ALib, AName: string; ATarget: Pointer);
var
  h: HMODULE;
  p: PByte;
  old: Cardinal;
begin
  h := LoadLibrary(PChar(ALib));
  if h = 0 then
    Exit;
  p := GetProcAddress(h, PChar(AName));
  if p = nil then
    Exit;
  if VirtualProtect(p, 5, PAGE_EXECUTE_READWRITE, @old) then
  begin
    p[0] := $E9;
    PInteger(p + 1)^ := NativeInt(ATarget) - NativeInt(p) - 5;
    FlushInstructionCache(GetCurrentProcess, p, 5);
  end;
end;

procedure InitClick;
{$IFNDEF DEMOSHOT_FMX}
var
  ctx: TRttiContext;
  f: TRttiField;
{$ENDIF}
begin
  ClickPPI := StrToIntDef(GetEnvironmentVariable('DEMOSHOT_PPI'), 0);
  ShellLog := TJSONArray.Create;
  Detour('shell32.dll', 'ShellExecuteW', @FakeShellExecuteW);
  Detour('shell32.dll', 'ShellExecuteExW', @FakeShellExecuteExW);
  if ClickPPI <= 96 then
    Exit;
  {$IFDEF DEMOSHOT_FMX}
  TWinWindowHandle.SetForcedScale(ClickPPI / 96);
  {$ELSE}
  Detour('shcore.dll', 'GetDpiForMonitor', @FakeGetDpiForMonitor);
  { the system DPI a per monitor aware process gets on a primary monitor with this DPI: forms scale to it when
    they load }
  f := ctx.GetType(TScreen).GetField('FPixelsPerInch');
  if Assigned(f) then
    f.SetValue(Screen, ClickPPI);
  {$ENDIF}
end;

function WndClass(AWnd: HWND): string;
var
  buf: array[0..255] of Char;
begin
  SetString(Result, buf, GetClassName(AWnd, buf, 256));
end;

function WndText(AWnd: HWND): string;
var
  buf: array[0..1023] of Char;
begin
  SetString(Result, buf, GetWindowText(AWnd, buf, 1024));
end;

function CollectWnd(AWnd: HWND; AParam: LPARAM): BOOL; stdcall;
var
  r: TRect;
begin
  if IsWindowVisible(AWnd) and (AWnd <> MainWnd) and GetWindowRect(AWnd, r) and (r.Width > 4) and (r.Height > 4) then
    TList<HWND>(AParam).Add(AWnd);
  Result := True;
end;

{ the visible top-level windows of the demo besides the main form, bottom of the z-order first }
function ExtraWindows: TList<HWND>;
begin
  Result := TList<HWND>.Create;
  EnumThreadWindows(GetCurrentThreadId, @CollectWnd, LPARAM(Result));
  Result.Reverse;
end;

function DialogTexts(AWnd: HWND): string;
var
  child: HWND;
  s: string;
begin
  Result := WndText(AWnd);
  child := GetWindow(AWnd, GW_CHILD);
  while child <> 0 do
  begin
    s := Trim(WndText(child));
    if (s <> '') and IsWindowVisible(child) then
      Result := Result + ' | ' + s;
    child := GetWindow(child, GW_HWNDNEXT);
  end;
end;

{ the main form's client area, the whole window of the others (the hidden desktop draws no captions) }
function ShotRect(AWnd: HWND): TRect;
var
  p: TPoint;
begin
  if AWnd = MainWnd then
  begin
    GetClientRect(AWnd, Result);
    p := Point(0, 0);
    Winapi.Windows.ClientToScreen(AWnd, p);
    Result.Offset(p.X, p.Y);
  end
  else
    GetWindowRect(AWnd, Result);
end;

{ The main form and the given windows in one image: VCL and native windows from their window DC, FMX
  forms painted (their window DC holds nothing on the hidden desktop). }
procedure CaptureAll(AWnds: TList<HWND>; const AName: string);
var
  all: TList<HWND>;
  u, r: TRect;
  w: HWND;
  {$IFDEF DEMOSHOT_FMX}
  comp, b: TShot;
  f: TCommonCustomForm;
  s: Single;
  p: TPoint;
  {$ELSE}
  bmp: TShot;
  png: TPngImage;
  dc: HDC;
  {$ENDIF}
begin
  all := TList<HWND>.Create;
  try
    all.Add(MainWnd);
    if Assigned(AWnds) then
      all.AddRange(AWnds);
    u := ShotRect(MainWnd);
    for w in all do
      u := TRect.Union(u, ShotRect(w));
    u.Width := Min(u.Width, 6000);
    u.Height := Min(u.Height, 4000);
    {$IFDEF DEMOSHOT_FMX}
    s := ClickScale;
    comp := TShot.Create(u.Width, u.Height);
    try
      comp.Clear(TAlphaColors.Black);
      for w in all do
      begin
        f := FMX.Platform.Win.FindWindow(w);
        if not (f is TCustomForm) then
          Continue;
        p := Point(0, 0);
        Winapi.Windows.ClientToScreen(w, p);
        b := TShot.Create(Max(1, Round(f.ClientWidth * s)), Max(1, Round(f.ClientHeight * s)));
        try
          b.BitmapScale := s;
          b.Clear(TAlphaColors.White);
          TCustomForm(f).PaintTo(b.Canvas);
          comp.Canvas.BeginScene;
          try
            comp.Canvas.DrawBitmap(b, RectF(0, 0, b.Width, b.Height),
              RectF(p.X - u.Left, p.Y - u.Top, p.X - u.Left + b.Width, p.Y - u.Top + b.Height), 1, True);
          finally
            comp.Canvas.EndScene;
          end;
        finally
          b.Free;
        end;
      end;
      comp.SaveToFile(TPath.Combine(OutDir, AName + '.png'));
    finally
      comp.Free;
    end;
    {$ELSE}
    for w in all do
      RedrawWindow(w, nil, 0, RDW_INVALIDATE or RDW_ERASE or RDW_FRAME or RDW_ALLCHILDREN or RDW_UPDATENOW);
    Pump(120);
    GdiFlush;
    bmp := TShot.Create;
    png := TPngImage.Create;
    try
      bmp.PixelFormat := pf24bit;
      bmp.SetSize(u.Width, u.Height);
      bmp.Canvas.Brush.Color := clBlack;
      bmp.Canvas.FillRect(Rect(0, 0, u.Width, u.Height));
      for w in all do
      begin
        r := ShotRect(w);
        if w = MainWnd then
          dc := GetDC(w)
        else
          dc := GetWindowDC(w);
        try
          BitBlt(bmp.Canvas.Handle, r.Left - u.Left, r.Top - u.Top, r.Width, r.Height, dc, 0, 0, SRCCOPY);
        finally
          ReleaseDC(w, dc);
        end;
      end;
      png.Assign(bmp);
      png.SaveToFile(TPath.Combine(OutDir, AName + '.png'));
    finally
      png.Free;
      bmp.Free;
    end;
    {$ENDIF}
  finally
    all.Free;
  end;
end;

function NextShot(const ASuffix: string): string;
begin
  Inc(ShotNo);
  Result := Format('%.3d-%s', [ShotNo, ASuffix]);
end;

procedure SendKey(AWnd: HWND; AKey: Word; AShift: Boolean = False);
begin
  if AShift then
    PostMessage(AWnd, WM_KEYDOWN, VK_SHIFT, 0);
  PostMessage(AWnd, WM_KEYDOWN, AKey, 0);
  PostMessage(AWnd, WM_KEYUP, AKey, LPARAM($C0000000));
  if AShift then
    PostMessage(AWnd, WM_KEYUP, VK_SHIFT, LPARAM($C0000000));
end;

procedure ClickWnd(AWnd: HWND; X, Y: Integer);
var
  lp: LPARAM;
begin
  lp := MakeLParam(Word(X), Word(Y));
  PostMessage(AWnd, WM_MOUSEMOVE, 0, lp);
  PostMessage(AWnd, WM_LBUTTONDOWN, MK_LBUTTON, lp);
  PostMessage(AWnd, WM_LBUTTONUP, 0, lp);
end;

{ closes what a click opened: Escape first (pop-ups, drop-downs), then a modal result or Close for forms,
  WM_CLOSE for native dialogs; what stays open is hidden and reported }
procedure CloseWindows(AWnds: TList<HWND>; AInfo: TJSONArray);
var
  w, focus: HWND;
  o: TJSONObject;
  {$IFDEF DEMOSHOT_FMX}
  f: TCommonCustomForm;
  {$ELSE}
  c: TWinControl;
  {$ENDIF}
begin
  focus := GetFocus;
  if focus = 0 then
    focus := MainWnd;
  SendKey(focus, VK_ESCAPE);
  Pump(250);
  for w in AWnds do
  begin
    if not IsWindow(w) or not IsWindowVisible(w) then
      Continue;
    {$IFDEF DEMOSHOT_FMX}
    f := FMX.Platform.Win.FindWindow(w);
    if Assigned(f) then
    begin
      if TFmxFormState.Modal in f.FormState then
        f.ModalResult := mrCancel
      else
        f.Close;
    end
    {$ELSE}
    c := FindControl(w);
    if c is TCustomForm then
    begin
      if fsModal in TCustomForm(c).FormState then
        TCustomForm(c).ModalResult := mrCancel
      else
        TCustomForm(c).Close;
    end
    {$ENDIF}
    else
      PostMessage(w, WM_CLOSE, 0, 0);
  end;
  Pump(300);
  for w in AWnds do
    if IsWindow(w) and IsWindowVisible(w) then
    begin
      o := TJSONObject.Create;
      o.AddPair('class', WndClass(w));
      o.AddPair('text', WndText(w));
      o.AddPair('issue', 'did not close');
      AInfo.AddElement(o);
      ShowWindow(w, SW_HIDE);
    end;
end;

function NewWindows: TList<HWND>;
var
  now: TList<HWND>;
  w: HWND;
begin
  Result := TList<HWND>.Create;
  now := ExtraWindows;
  try
    for w in now do
      if not StepPre.Contains(w) then
        Result.Add(w);
  finally
    now.Free;
  end;
end;

{ records, captures and closes the windows a step opened; also runs from the watchdog timer inside a
  modal loop the click started }
procedure HandleNewWindows;
var
  wnds: TList<HWND>;
  w: HWND;
  arr: TJSONArray;
  o: TJSONObject;
  r: TRect;
  shot: string;
begin
  wnds := NewWindows;
  try
    if wnds.Count = 0 then
      Exit;
    arr := TJSONArray.Create;
    for w in wnds do
    begin
      o := TJSONObject.Create;
      GetWindowRect(w, r);
      o.AddPair('class', WndClass(w));
      o.AddPair('text', DialogTexts(w));
      o.AddPair('rect', Format('%d,%d,%d,%d', [r.Left, r.Top, r.Right, r.Bottom]));
      arr.AddElement(o);
    end;
    shot := NextShot('window');
    CaptureAll(wnds, shot);
    if Assigned(CurStep) then
    begin
      CurStep.AddPair('windows', arr);
      CurStep.AddPair('windowShot', shot);
    end
    else
      arr.Free;
    arr := TJSONArray.Create;
    CloseWindows(wnds, arr);
    if Assigned(CurStep) and (arr.Count > 0) then
      CurStep.AddPair('notClosed', arr)
    else
      arr.Free;
  finally
    wnds.Free;
  end;
end;

{ a click that runs a modal loop (a dialog, a modal form) stops Pump: the timer still fires inside that loop }
procedure WatchProc(AWnd: HWND; AMsg: UINT; AId: UINT_PTR; ATime: DWORD); stdcall;
begin
  if Assigned(CurStep) and (GetTickCount - LastPumpTick > 1500) then
  try
    LastPumpTick := GetTickCount;
    HandleNewWindows;
  except
  end;
end;

{ ---- targets ---- }

const
  ContainerWords: array[0..19] of string = ('Panel', 'GroupBox', 'Layout', 'Rectangle', 'StackPanel', 'FlowPanel',
    'ScrollBox', 'SplitView', 'Expander', 'CardPanel', 'TabSheet', 'PageControl', 'PageSlider', 'Frame',
    'DockPanel', 'TabControl', 'TabItem', 'Container', 'Splitter', 'ControlBar');
  SkipWords: array[0..6] of string = ('HTMLText', 'Divider', 'Skeleton', 'Bevel', 'Splitter', 'ScrollBar',
    'BrandLogo');
  SkipClasses: array[0..10] of string = ('TLabel', 'TImage', 'TText', 'TShape', 'TLine', 'TCircle', 'TRectangle',
    'TTMSFNCImage', 'TImageControl', 'TPaintBox', 'TStaticText');
  SkipCaptions: array[0..4] of string = ('close', 'exit', 'quit', 'log out', 'sign out');

function HasWord(const AClass: string; const AWords: array of string): Boolean;
var
  s: string;
begin
  for s in AWords do
    if Pos(LowerCase(s), LowerCase(AClass)) > 0 then
      Exit(True);
  Result := False;
end;

function CaptionOf(AControl: TObject): string;
var
  ctx: TRttiContext;
  p: TRttiProperty;
  n: string;
begin
  Result := '';
  for n in ['Text', 'Caption'] do
  try
    p := ctx.GetType(AControl.ClassType).GetProperty(n);
    if Assigned(p) and p.IsReadable and (p.PropertyType.TypeKind in [tkUString, tkString, tkWString, tkLString]) then
    begin
      Result := p.GetValue(AControl).AsString;
      if Result <> '' then
        Exit(Copy(Result, 1, 60));
    end;
  except
  end;
end;

function Skipped(AControl: TControl): Boolean;
var
  s: string;
begin
  for s in SkipClasses do
    if AControl.ClassName = s then
      Exit(True);
  Result := HasWord(AControl.ClassName, SkipWords);
end;

function SkipByCaption(const ACaption: string): Boolean;
var
  s: string;
begin
  for s in SkipCaptions do
    if SameText(Trim(ACaption), s) or SameText(Trim(StringReplace(ACaption, '&', '', [rfReplaceAll])), s) then
      Exit(True);
  Result := False;
end;

{ form client rectangle of a control (FMX logical, VCL pixels) }
function FormRect(AControl: TControl): TRect;
{$IFDEF DEMOSHOT_FMX}
var
  rf: TRectF;
begin
  rf := AControl.AbsoluteRect;
  Result := Rect(Round(rf.Left), Round(rf.Top), Round(rf.Right), Round(rf.Bottom));
end;
{$ELSE}
var
  p: TPoint;
begin
  if Assigned(AControl.Parent) and AControl.Parent.HandleAllocated then
  begin
    p := AControl.Parent.ClientToScreen(Point(AControl.Left, AControl.Top));
    p := TCustomForm(Application.MainForm).ScreenToClient(p);
    Result := Rect(p.X, p.Y, p.X + AControl.Width, p.Y + AControl.Height);
  end
  else
    Result := Rect(0, 0, 0, 0);
end;
{$ENDIF}

function Usable(AControl: TControl): Boolean;
begin
  {$IFDEF DEMOSHOT_FMX}
  Result := AControl.ParentedVisible and AControl.AbsoluteEnabled and (AControl.Width > 2) and (AControl.Height > 2);
  {$ELSE}
  Result := AControl.Visible and AControl.Enabled and (AControl.Width > 2) and (AControl.Height > 2) and
    Assigned(AControl.Parent) and AControl.Parent.Showing;
  {$ENDIF}
end;

function IsContainer(AControl: TControl): Boolean;
begin
  {$IFDEF DEMOSHOT_FMX}
  Result := (AControl.ControlsCount > 0) and HasWord(AControl.ClassName, ContainerWords);
  {$ELSE}
  Result := (AControl is TWinControl) and (TWinControl(AControl).ControlCount > 0) and
    HasWord(AControl.ClassName, ContainerWords);
  {$ENDIF}
end;

{ the visible part of a control: its rectangle clipped by every parent }
function VisiblePart(AControl: TControl): TRect;
var
  {$IFDEF DEMOSHOT_FMX}
  p: TFmxObject;
  {$ELSE}
  p: TWinControl;
  {$ENDIF}
begin
  Result := FormRect(AControl);
  {$IFDEF DEMOSHOT_FMX}
  p := AControl.Parent;
  while (p is TControl) do
  begin
    Result.Intersect(FormRect(TControl(p)));
    p := p.Parent;
  end;
  {$ELSE}
  p := AControl.Parent;
  while Assigned(p) and not (p is TCustomForm) do
  begin
    Result.Intersect(FormRect(p));
    p := p.Parent;
  end;
  {$ENDIF}
end;

procedure CollectTargets(AParent: TControl; AList: TList<TControl>);
var
  I: Integer;
  c: TControl;
  {$IFDEF DEMOSHOT_FMX}
  o: TFmxObject;
  {$ENDIF}
begin
  {$IFDEF DEMOSHOT_FMX}
  for I := 0 to AParent.ChildrenCount - 1 do
  begin
    o := AParent.Children[I];
    if not (o is TControl) then
      Continue;
    c := TControl(o);
  {$ELSE}
  for I := 0 to TWinControl(AParent).ControlCount - 1 do
  begin
    c := TWinControl(AParent).Controls[I];
  {$ENDIF}
    if not Usable(c) then
      Continue;
    if IsContainer(c) then
      CollectTargets(c, AList)
    else if not Skipped(c) and not SkipByCaption(CaptionOf(c)) then
      AList.Add(c);
  end;
end;

procedure CollectForm(AForm: TCommonCustomForm; AList: TList<TControl>);
var
  I: Integer;
  {$IFDEF DEMOSHOT_FMX}
  o: TFmxObject;
  {$ELSE}
  c: TControl;
  {$ENDIF}
begin
  {$IFDEF DEMOSHOT_FMX}
  for I := 0 to AForm.ChildrenCount - 1 do
  begin
    o := AForm.Children[I];
    if (o is TControl) and Usable(TControl(o)) then
    begin
      if IsContainer(TControl(o)) then
        CollectTargets(TControl(o), AList)
      else if not Skipped(TControl(o)) and not SkipByCaption(CaptionOf(o)) then
        AList.Add(TControl(o));
    end;
  end;
  {$ELSE}
  for I := 0 to TWinControl(AForm).ControlCount - 1 do
  begin
    c := TWinControl(AForm).Controls[I];
    if Usable(c) then
    begin
      if IsContainer(c) then
        CollectTargets(c, AList)
      else if not Skipped(c) and not SkipByCaption(CaptionOf(c)) then
        AList.Add(c);
    end;
  end;
  {$ENDIF}
end;


type
  TMouseAct = (maMove, maClick, maFastClicks, maDouble, maRight, maWheel, maDrag);
  TTargetKind = (tgButton, tgEditor, tgList, tgDropDown, tgSlider);

const
  EditorWords: array[0..11] of string = ('Edit', 'Memo', 'NumberBox', 'TagEdit', 'SpinBox', 'SearchBox', 'IPEdit',
    'RichEditor', 'Signature', 'NumberEdit', 'Lookup', 'PassLock');
  ListWords: array[0..18] of string = ('Grid', 'ListBox', 'ListView', 'TreeView', 'TableView', 'Planner', 'Kanban',
    'Timeline', 'Calendar', 'Repeater', 'ListEditor', 'TileList', 'Chat', 'Inspector', 'SearchList', 'ResponsiveList',
    'ControlList', 'Ribbon', 'NavigationPanel');
  DropWords: array[0..5] of string = ('ComboBox', 'Picker', 'DatePicker', 'ColorSelector', 'FontName', 'Breadcrumb');
  SliderWords: array[0..4] of string = ('Knob', 'TrackBar', 'Slider', 'Rating', 'RangeSlider');

function KindOf(AControl: TControl): TTargetKind;
var
  n: string;
begin
  n := AControl.ClassName;
  if HasWord(n, DropWords) then
    Result := tgDropDown
  else if HasWord(n, ListWords) then
    Result := tgList
  else if HasWord(n, EditorWords) then
    Result := tgEditor
  else if HasWord(n, SliderWords) then
    Result := tgSlider
  else
    Result := tgButton;
end;

{ a control is used once: buttons, check boxes and items are told apart by their caption, an editor or a list
  whose text changes by its place }
function TargetKey(AControl: TControl): string;
var
  r: TRect;
  s: string;
begin
  r := FormRect(AControl);
  s := '';
  if KindOf(AControl) = tgButton then
    s := CaptionOf(AControl);
  Result := Format('%s|%s|%s|%d|%d', [AControl.ClassName, AControl.Name, s, r.Left div 8, r.Top div 8]);
end;

{ the window under a point of the control (its centre plus an offset in form units) and that point in the
  window's client pixels }
procedure TargetPoint(AControl: TControl; ADX, ADY: Integer; out AWnd: HWND; out APt: TPoint);
var
  r: TRect;
  cx, cy: Integer;
  {$IFDEF DEMOSHOT_FMX}
  s: Single;
  {$ENDIF}
begin
  r := VisiblePart(AControl);
  cx := (r.Left + r.Right) div 2 + ADX;
  cy := (r.Top + r.Bottom) div 2 + ADY;
  {$IFDEF DEMOSHOT_FMX}
  s := ClickScale;
  AWnd := MainWnd;
  APt := Point(Round(cx * s), Round(cy * s));
  {$ELSE}
  APt := TCustomForm(Application.MainForm).ClientToScreen(Point(cx, cy));
  if AControl is TWinControl then
  begin
    AWnd := TWinControl(AControl).Handle;
    APt := TWinControl(AControl).ScreenToClient(APt);
  end
  else
  begin
    AWnd := AControl.Parent.Handle;
    APt := AControl.Parent.ScreenToClient(APt);
  end;
  {$ENDIF}
end;

procedure Mouse(AControl: TControl; AAct: TMouseAct; ADX: Integer = 0; ADY: Integer = 0);
var
  w: HWND;
  p, sp, q: TPoint;
  I: Integer;
  lp: LPARAM;
begin
  { a drag starts at the centre and ends at the offset; the other actions happen at the offset }
  if AAct = maDrag then
    TargetPoint(AControl, 0, 0, w, p)
  else
    TargetPoint(AControl, ADX, ADY, w, p);
  lp := MakeLParam(Word(p.X), Word(p.Y));
  PostMessage(w, WM_MOUSEMOVE, 0, lp);
  case AAct of
    maClick:
      begin
        PostMessage(w, WM_LBUTTONDOWN, MK_LBUTTON, lp);
        PostMessage(w, WM_LBUTTONUP, 0, lp);
      end;
    maFastClicks:
      for I := 1 to 3 do
      begin
        PostMessage(w, WM_LBUTTONDOWN, MK_LBUTTON, lp);
        PostMessage(w, WM_LBUTTONUP, 0, lp);
      end;
    maDouble:
      begin
        PostMessage(w, WM_LBUTTONDOWN, MK_LBUTTON, lp);
        PostMessage(w, WM_LBUTTONUP, 0, lp);
        PostMessage(w, WM_LBUTTONDBLCLK, MK_LBUTTON, lp);
        PostMessage(w, WM_LBUTTONUP, 0, lp);
      end;
    maRight:
      begin
        PostMessage(w, WM_RBUTTONDOWN, MK_RBUTTON, lp);
        PostMessage(w, WM_RBUTTONUP, 0, lp);
      end;
    maWheel:
      begin
        sp := p;
        Winapi.Windows.ClientToScreen(w, sp);
        for I := 1 to 3 do
          PostMessage(w, WM_MOUSEWHEEL, MakeWParam(0, Word(-WHEEL_DELTA)), MakeLParam(Word(sp.X), Word(sp.Y)));
      end;
    maDrag:
      begin
        PostMessage(w, WM_LBUTTONDOWN, MK_LBUTTON, lp);
        Pump(60);
        TargetPoint(AControl, ADX, ADY, w, q);
        for I := 1 to 6 do
        begin
          PostMessage(w, WM_MOUSEMOVE, MK_LBUTTON, MakeLParam(Word(p.X + (q.X - p.X) * I div 6),
            Word(p.Y + (q.Y - p.Y) * I div 6)));
          Pump(40);
        end;
        PostMessage(w, WM_LBUTTONUP, 0, MakeLParam(Word(q.X), Word(q.Y)));
      end;
  end;
end;

{ a key with Ctrl / Shift held: the thread's key state is set while the posted messages are handled }
procedure Keys(AKey: Word; ACtrl: Boolean = False; AShift: Boolean = False; ACount: Integer = 1);
var
  ks: TKeyboardState;
  w: HWND;
  I: Integer;
begin
  w := GetFocus;
  if w = 0 then
    w := MainWnd;
  GetKeyboardState(ks);
  if ACtrl then
    ks[VK_CONTROL] := $80;
  if AShift then
    ks[VK_SHIFT] := $80;
  SetKeyboardState(ks);
  try
    for I := 1 to ACount do
    begin
      PostMessage(w, WM_KEYDOWN, AKey, 1);
      PostMessage(w, WM_KEYUP, AKey, LPARAM($C0000001));
      Pump(60);
    end;
  finally
    ks[VK_CONTROL] := 0;
    ks[VK_SHIFT] := 0;
    SetKeyboardState(ks);
  end;
end;

procedure TypeText(const AText: string);
var
  c: Char;
  w: HWND;
begin
  w := GetFocus;
  if w = 0 then
    w := MainWnd;
  for c in AText do
    PostMessage(w, WM_CHAR, Ord(c), 1);
  Pump(150);
end;

{ ---- geometry: a control outside its parent (clipped), siblings on top of each other ---- }

procedure CheckGeometry(AParent: TControl; AOut: TJSONArray);
var
  I, J: Integer;
  kids: TList<TControl>;
  c, d: TControl;
  pr, cr, x: TRect;
  scroll: Boolean;
  {$IFDEF DEMOSHOT_FMX}
  o: TFmxObject;
  {$ENDIF}

  procedure Add(const AKind: string; A, B: TControl; const ARect: TRect);
  var
    e: TJSONObject;
  begin
    e := TJSONObject.Create;
    e.AddPair('issue', AKind);
    e.AddPair('control', A.ClassName + ' ' + A.Name + ' "' + CaptionOf(A) + '"');
    e.AddPair('parent', AParent.ClassName + ' ' + AParent.Name);
    if Assigned(B) then
      e.AddPair('other', B.ClassName + ' ' + B.Name + ' "' + CaptionOf(B) + '"');
    e.AddPair('rect', Format('%d,%d,%d,%d', [ARect.Left, ARect.Top, ARect.Right, ARect.Bottom]));
    AOut.AddElement(e);
  end;

begin
  kids := TList<TControl>.Create;
  try
    {$IFDEF DEMOSHOT_FMX}
    for I := 0 to AParent.ChildrenCount - 1 do
    begin
      o := AParent.Children[I];
      if (o is TControl) and TControl(o).ParentedVisible and (TControl(o).Width > 0) and (TControl(o).Height > 0) then
        kids.Add(TControl(o));
    end;
    {$ELSE}
    if AParent is TWinControl then
      for I := 0 to TWinControl(AParent).ControlCount - 1 do
        if TWinControl(AParent).Controls[I].Visible and (TWinControl(AParent).Controls[I].Width > 0) then
          kids.Add(TWinControl(AParent).Controls[I]);
    {$ENDIF}
    scroll := Pos('scroll', LowerCase(AParent.ClassName)) > 0;
    pr := FormRect(AParent);
    for I := 0 to kids.Count - 1 do
    begin
      c := kids[I];
      cr := FormRect(c);
      if not scroll and ((cr.Left < pr.Left - 1) or (cr.Top < pr.Top - 1) or (cr.Right > pr.Right + 1) or
        (cr.Bottom > pr.Bottom + 1)) then
        Add('outside parent', c, nil, cr);
      for J := I + 1 to kids.Count - 1 do
      begin
        d := kids[J];
        x := TRect.Intersect(cr, FormRect(d));
        if (x.Width > 3) and (x.Height > 3) and not IsContainer(c) and not IsContainer(d) then
          Add('overlap', c, d, x);
      end;
      if IsContainer(c) then
        CheckGeometry(c, AOut);
    end;
  finally
    kids.Free;
  end;
end;

function GeometryOf(AForm: TCommonCustomForm): TJSONArray;
var
  I: Integer;
  {$IFDEF DEMOSHOT_FMX}
  o: TFmxObject;
  {$ENDIF}
  e: TJSONObject;
  r: TRect;
  c: TControl;
begin
  Result := TJSONArray.Create;
  {$IFDEF DEMOSHOT_FMX}
  for I := 0 to AForm.ChildrenCount - 1 do
  begin
    o := AForm.Children[I];
    if not ((o is TControl) and TControl(o).ParentedVisible) then
      Continue;
    c := TControl(o);
  {$ELSE}
  for I := 0 to TWinControl(AForm).ControlCount - 1 do
  begin
    c := TWinControl(AForm).Controls[I];
    if not c.Visible then
      Continue;
  {$ENDIF}
    r := FormRect(c);
    if (r.Right > Round(AForm.ClientWidth) + 1) or (r.Bottom > Round(AForm.ClientHeight) + 1) then
    begin
      e := TJSONObject.Create;
      e.AddPair('issue', 'outside form');
      e.AddPair('control', c.ClassName + ' ' + c.Name);
      e.AddPair('rect', Format('%d,%d,%d,%d', [r.Left, r.Top, r.Right, r.Bottom]));
      Result.AddElement(e);
    end;
    if IsContainer(c) then
      CheckGeometry(c, Result);
  end;
end;

function FocusedName: string;
{$IFDEF DEMOSHOT_FMX}
var
  fc: IControl;
begin
  Result := '';
  fc := Application.MainForm.Focused;
  if Assigned(fc) then
    Result := fc.GetObject.ClassName + ' ' + fc.GetObject.Name;
end;
{$ELSE}
begin
  Result := '';
  if Assigned(Screen.ActiveControl) then
    Result := Screen.ActiveControl.ClassName + ' ' + Screen.ActiveControl.Name;
end;
{$ENDIF}

procedure SetTheme(AForm: TCommonCustomForm; const ATheme: string);
begin
  if not Assigned(Injected) then
    Injected := TTMSFNCThemeManager.Create(AForm);
  Injected.Theme := ATheme;
  Pump(700);
  AForm.Invalidate;
  Pump(200);
end;

var
  Phases: TJSONArray;

{ after an action: let it settle and capture the form with every window the step opened; those windows are
  closed unless AKeepOpen (a drop-down that stays open for the next action) }
procedure Settle(const AAct: string; AKeepOpen: Boolean = False);
var
  o, e: TJSONObject;
  wnds: TList<HWND>;
  arr: TJSONArray;
  w: HWND;
  r: TRect;
  shot: string;
begin
  CurAct := AAct;
  Pump(350);
  o := TJSONObject.Create;
  o.AddPair('act', AAct);
  Phases.AddElement(o);
  wnds := NewWindows;
  try
    if wnds.Count > 0 then
    begin
      arr := TJSONArray.Create;
      for w in wnds do
      begin
        e := TJSONObject.Create;
        GetWindowRect(w, r);
        e.AddPair('class', WndClass(w));
        e.AddPair('text', DialogTexts(w));
        e.AddPair('rect', Format('%d,%d,%d,%d', [r.Left, r.Top, r.Right, r.Bottom]));
        arr.AddElement(e);
      end;
      o.AddPair('windows', arr);
    end;
    shot := NextShot(Slug(AAct));
    o.AddPair('shot', shot);
    CaptureAll(wnds, shot);
    if (wnds.Count > 0) and not AKeepOpen then
    begin
      arr := TJSONArray.Create;
      CloseWindows(wnds, arr);
      if arr.Count > 0 then
        o.AddPair('notClosed', arr)
      else
        arr.Free;
    end;
  finally
    wnds.Free;
  end;
end;

function IsPushButton(AControl: TControl): Boolean;
var
  n: string;
begin
  n := AControl.ClassName;
  Result := (Pos('Button', n) > 0) and (Pos('Radio', n) = 0) and (Pos('Check', n) = 0);
end;

function RunStep(AForm: TCommonCustomForm; AControl: TControl; const AKey: string): TJSONObject;
var
  r: TRect;
  kind: TTargetKind;
begin
  Result := TJSONObject.Create;
  CurStep := Result;
  r := FormRect(AControl);
  kind := KindOf(AControl);
  Result.AddPair('key', AKey);
  Result.AddPair('class', AControl.ClassName);
  Result.AddPair('name', AControl.Name);
  Result.AddPair('text', CaptionOf(AControl));
  Result.AddPair('kind', GetEnumName(TypeInfo(TTargetKind), Ord(kind)));
  Result.AddPair('rect', Format('%d,%d,%d,%d', [r.Left, r.Top, r.Right, r.Bottom]));
  Phases := TJSONArray.Create;
  Result.AddPair('phases', Phases);
  StepPre.Free;
  StepPre := ExtraWindows;
  try
    case kind of
      tgButton:
        begin
          Mouse(AControl, maClick);
          Settle('click');
          if IsPushButton(AControl) and IsWindow(MainWnd) and Usable(AControl) then
          begin
            Mouse(AControl, maFastClicks);
            Settle('fast clicks');
          end;
        end;
      tgEditor:
        begin
          Mouse(AControl, maClick);
          Settle('click');
          TypeText('Test 12');
          Settle('type');
          SetTheme(AForm, 'Fluent Dark');
          Settle('dark while editing');
          SetTheme(AForm, 'Fluent Light');
          Keys(Ord('Z'), True);
          Settle('ctrl+z');
          Keys(VK_ESCAPE);
        end;
      tgList:
        begin
          Mouse(AControl, maMove);
          Settle('hover');
          Mouse(AControl, maClick);
          Settle('click');
          Keys(VK_DOWN, False, False, 2);
          Settle('arrow down');
          Mouse(AControl, maDouble);
          Settle('double click', True);
          TypeText('7');
          Settle('type', True);
          SetTheme(AForm, 'Fluent Dark');
          Settle('dark while editing', True);
          Keys(VK_ESCAPE);
          SetTheme(AForm, 'Fluent Light');
          Settle('escape');
          Keys(VK_F2);
          Settle('f2', True);
          Keys(VK_RETURN);
          Settle('enter');
          Keys(Ord('C'), True);
          Keys(Ord('Z'), True);
          Settle('ctrl+c ctrl+z');
          Mouse(AControl, maWheel);
          Settle('wheel');
          Mouse(AControl, maRight);
          Settle('right click');
          Mouse(AControl, maDrag, 0, 60);
          Settle('drag');
        end;
      tgDropDown:
        begin
          { the drop-down button sits at the right end of a combo box or picker }
          Mouse(AControl, maClick, Max(0, (VisiblePart(AControl).Width div 2) - 14), 0);
          Settle('open', True);
          SetTheme(AForm, 'Fluent Dark');
          Settle('dark while open', True);
          Keys(VK_DOWN);
          Keys(VK_RETURN);
          SetTheme(AForm, 'Fluent Light');
          Settle('pick');
        end;
      tgSlider:
        begin
          Mouse(AControl, maDrag, 60, -30);
          Settle('drag');
          Mouse(AControl, maWheel);
          Settle('wheel');
          Keys(VK_RIGHT, False, False, 3);
          Settle('arrow keys');
        end;
    end;
  except
    on E: Exception do
      Result.AddPair('driverError', E.ClassName + ': ' + E.Message);
  end;
  CurStep := nil;
  CurAct := '';
end;

function OpenedWindows(AStep: TJSONObject): Boolean;
var
  arr: TJSONArray;
  v: TJSONValue;
begin
  Result := AStep.GetValue('windows') <> nil;
  if not Result and AStep.TryGetValue<TJSONArray>('phases', arr) then
    for v in arr do
      if TJSONObject(v).GetValue('windows') <> nil then
        Exit(True);
end;

{ ---- scenario: a person-like sequence of a demo (DEMOSHOT_SCENARIO, tools/scenarios/<demo>.txt) ----

  One action per line, fields separated by '|'; '#' starts a comment. A target is a component name, 'Class#n' (the
  n-th visible control of that class, 1-based, in the order of the form) or the start of a caption.
    click|<target>[|dx,dy]   dbl|<target>[|dx,dy]   right|<target>   wheel|<target>
                              dx,dy: 96 DPI units from the centre; tl:x,y from the top left corner
    segment|<target>|<i>|<n>  the i-th (0-based) of n equal parts of the control, from the left
    hold|<target>|<ms>        press, a shot while pressed, release
    type|<text>   key|<enter|escape|tab|down|up|left|right|home|end|f2|delete|space|ctrl+z>[|<count>]
    theme|<theme name>   wait|<ms>   shot|<label>
  Every action is followed by a shot; a target that is not there is logged as missing. }

procedure CollectVisible(AObj: TObject; AList: TList<TControl>);
var
  I: Integer;
begin
  {$IFDEF DEMOSHOT_FMX}
  for I := 0 to TFmxObject(AObj).ChildrenCount - 1 do
    if TFmxObject(AObj).Children[I] is TControl then
    begin
      if not TControl(TFmxObject(AObj).Children[I]).Visible then
        Continue;
      AList.Add(TControl(TFmxObject(AObj).Children[I]));
      CollectVisible(TFmxObject(AObj).Children[I], AList);
    end;
  {$ELSE}
  for I := 0 to TWinControl(AObj).ControlCount - 1 do
    if TWinControl(AObj).Controls[I].Visible then
    begin
      AList.Add(TWinControl(AObj).Controls[I]);
      if TWinControl(AObj).Controls[I] is TWinControl then
        CollectVisible(TWinControl(AObj).Controls[I], AList);
    end;
  {$ENDIF}
end;

function FindTarget(AForm: TCommonCustomForm; const ASpec: string): TControl;
var
  all: TList<TControl>;
  c: TControl;
  cls: string;
  n, p: Integer;
begin
  Result := nil;
  all := TList<TControl>.Create;
  try
    CollectVisible(AForm, all);
    p := Pos('#', ASpec);
    if p > 0 then
    begin
      cls := Copy(ASpec, 1, p - 1);
      n := StrToIntDef(Copy(ASpec, p + 1, 5), 1);
      for c in all do
        if SameText(c.ClassName, cls) then
        begin
          Dec(n);
          if n = 0 then
            Exit(c);
        end;
      Exit;
    end;
    for c in all do
      if SameText(c.Name, ASpec) then
        Exit(c);
    for c in all do
      if (ASpec <> '') and SameText(Copy(CaptionOf(c), 1, Length(ASpec)), ASpec) then
        Exit(c);
  finally
    all.Free;
  end;
end;

function KeyOf(const AName: string; out ACtrl: Boolean): Word;
var
  n: string;
begin
  n := LowerCase(AName);
  ACtrl := n.StartsWith('ctrl+');
  if ACtrl then
    n := Copy(n, 6, MaxInt);
  if n = 'enter' then Result := VK_RETURN
  else if n = 'escape' then Result := VK_ESCAPE
  else if n = 'tab' then Result := VK_TAB
  else if n = 'down' then Result := VK_DOWN
  else if n = 'up' then Result := VK_UP
  else if n = 'left' then Result := VK_LEFT
  else if n = 'right' then Result := VK_RIGHT
  else if n = 'home' then Result := VK_HOME
  else if n = 'end' then Result := VK_END
  else if n = 'f2' then Result := VK_F2
  else if n = 'delete' then Result := VK_DELETE
  else if n = 'space' then Result := VK_SPACE
  else if Length(n) = 1 then Result := Ord(UpCase(n[1]))
  else Result := 0;
end;

procedure RunScenario(AForm: TCommonCustomForm; const AFile: string; ALog: TJSONArray);
var
  lines: TStringList;
  line, verb: string;
  f: TArray<string>;
  c: TControl;
  step: TJSONObject;
  dx, dy, I: Integer;
  r: TRect;
  w: HWND;
  pt: TPoint;
  ctrl: Boolean;
  k: Word;

  { an offset at 96 DPI from the centre of the target, or from its top left corner with 'tl:' }
  procedure Offset(AIndex: Integer);
  var
    xy: TArray<string>;
    s: string;
    fromTopLeft: Boolean;
    tr: TRect;
  begin
    dx := 0;
    dy := 0;
    if Length(f) > AIndex then
    begin
      s := Trim(f[AIndex]);
      fromTopLeft := s.StartsWith('tl:');
      if fromTopLeft then
        s := Copy(s, 4, MaxInt);
      xy := s.Split([',']);
      if Length(xy) = 2 then
      begin
        dx := StrToIntDef(Trim(xy[0]), 0);
        dy := StrToIntDef(Trim(xy[1]), 0);
        {$IFNDEF DEMOSHOT_FMX}
        { the VCL form is in pixels of the emulated DPI; FMX works in logical units }
        if ClickPPI > 96 then
        begin
          dx := MulDiv(dx, ClickPPI, 96);
          dy := MulDiv(dy, ClickPPI, 96);
        end;
        {$ENDIF}
        if fromTopLeft then
        begin
          tr := FormRect(c);
          dx := dx - tr.Width div 2;
          dy := dy - tr.Height div 2;
        end;
      end;
    end;
  end;

begin
  lines := TStringList.Create;
  try
    lines.LoadFromFile(AFile, TEncoding.UTF8);
    for line in lines do
    begin
      if (Trim(line) = '') or Trim(line).StartsWith('#') then
        Continue;
      if not IsWindow(MainWnd) then
        Break;
      f := Trim(line).Split(['|']);
      verb := LowerCase(f[0]);
      step := TJSONObject.Create;
      CurStep := step;
      step.AddPair('key', 'scenario|' + Trim(line));
      step.AddPair('scenario', Trim(line));
      Phases := TJSONArray.Create;
      step.AddPair('phases', Phases);
      ALog.AddElement(step);
      StepPre.Free;
      StepPre := ExtraWindows;
      c := nil;
      if (verb = 'click') or (verb = 'dbl') or (verb = 'right') or (verb = 'wheel') or (verb = 'segment') or
        (verb = 'hold') then
      begin
        if Length(f) > 1 then
          c := FindTarget(AForm, f[1]);
        if not Assigned(c) then
        begin
          step.AddPair('missing', Copy(line, 1, 120));
          Continue;
        end;
        step.AddPair('class', c.ClassName);
        step.AddPair('text', CaptionOf(c));
      end;
      if verb = 'click' then
      begin
        Offset(2);
        Mouse(c, maClick, dx, dy);
      end
      else if verb = 'dbl' then
      begin
        Offset(2);
        Mouse(c, maDouble, dx, dy);
      end
      else if verb = 'right' then
        Mouse(c, maRight)
      else if verb = 'wheel' then
        Mouse(c, maWheel)
      else if (verb = 'segment') and (Length(f) > 3) then
      begin
        r := FormRect(c);
        I := StrToIntDef(f[2], 0);
        dx := Round((I + 0.5) * r.Width / Max(1, StrToIntDef(f[3], 1)) - r.Width / 2);
        Mouse(c, maClick, dx, 0);
      end
      else if verb = 'hold' then
      begin
        TargetPoint(c, 0, 0, w, pt);
        PostMessage(w, WM_MOUSEMOVE, 0, MakeLParam(Word(pt.X), Word(pt.Y)));
        PostMessage(w, WM_LBUTTONDOWN, MK_LBUTTON, MakeLParam(Word(pt.X), Word(pt.Y)));
        if Length(f) > 2 then
          Pump(StrToIntDef(f[2], 600))
        else
          Pump(600);
        Settle('held', True);
        PostMessage(w, WM_LBUTTONUP, 0, MakeLParam(Word(pt.X), Word(pt.Y)));
      end
      else if (verb = 'type') and (Length(f) > 1) then
        TypeText(f[1])
      else if (verb = 'key') and (Length(f) > 1) then
      begin
        k := KeyOf(f[1], ctrl);
        if Length(f) > 2 then
          I := StrToIntDef(f[2], 1)
        else
          I := 1;
        if k <> 0 then
          Keys(k, ctrl, False, I);
      end
      else if (verb = 'theme') and (Length(f) > 1) then
        SetTheme(AForm, f[1])
      else if (verb = 'wait') and (Length(f) > 1) then
      begin
        Pump(StrToIntDef(f[1], 500));
        Continue;
      end
      else if verb <> 'shot' then
      begin
        step.AddPair('unknown', verb);
        Continue;
      end;
      Settle(Trim(line));
    end;
  finally
    lines.Free;
    CurStep := nil;
  end;
end;

procedure RunClick(AForm: TCommonCustomForm);
var
  res: TJSONObject;
  targets: TList<TControl>;
  clicked, prev: TDictionary<string, Boolean>;
  popupKeys: TList<string>;
  c, pick: TControl;
  key, k: string;
  steps, I: Integer;
  focus: TJSONArray;
  w, h: Integer;
  step: TJSONObject;
begin
  {$IFDEF DEMOSHOT_FMX}
  MainWnd := FormToHWND(AForm);
  {$ELSE}
  MainWnd := TCustomForm(AForm).Handle;
  {$ENDIF}
  res := TJSONObject.Create;
  StepLog := TJSONArray.Create;
  Clicking := True;
  targets := TList<TControl>.Create;
  clicked := TDictionary<string, Boolean>.Create;
  prev := TDictionary<string, Boolean>.Create;
  popupKeys := TList<string>.Create;
  WatchId := SetTimer(0, 0, 250, @WatchProc);
  try
    res.AddPair('ppi', TJSONNumber.Create(ClickPPI));
    {$IFNDEF DEMOSHOT_FMX}
    res.AddPair('formPPI', TJSONNumber.Create(TCustomForm(AForm).CurrentPPI));
    res.AddPair('monitorPPI', TJSONNumber.Create(TCustomForm(AForm).Monitor.PixelsPerInch));
    res.AddPair('win', Format('%d.%d', [Win32MajorVersion, Win32MinorVersion]));
    res.AddPair('screenPPI', TJSONNumber.Create(Screen.PixelsPerInch));
    { the form keeps the 96 DPI it loaded with although the screen and the monitor report the emulated DPI: it is
      scaled as when it moves to a monitor with that DPI }
    if (ClickPPI > 96) and (TCustomForm(AForm).CurrentPPI <> ClickPPI) then
    begin
      TCustomForm(AForm).ScaleForPPI(ClickPPI);
      res.AddPair('scaledAfterStart', TJSONBool.Create(True));
    end;
    {$ENDIF}
    SetTheme(AForm, 'Fluent Light');
    res.AddPair('width', TJSONNumber.Create(Round(AForm.ClientWidth)));
    res.AddPair('height', TJSONNumber.Create(Round(AForm.ClientHeight)));
    CaptureAll(nil, 'light');
    res.AddPair('geometryLight', GeometryOf(AForm));

    { the demo's own sequence first, from its start state }
    if GetEnvironmentVariable('DEMOSHOT_SCENARIO') <> '' then
    begin
      RunScenario(AForm, GetEnvironmentVariable('DEMOSHOT_SCENARIO'), StepLog);
      SetTheme(AForm, 'Fluent Light');
    end;

    { every reachable control once; controls a click revealed first }
    steps := 0;
    while steps < StrToIntDef(GetEnvironmentVariable('DEMOSHOT_MAXSTEPS'), 70) do
    begin
      targets.Clear;
      CollectForm(AForm, targets);
      pick := nil;
      for c in targets do
      begin
        key := TargetKey(c);
        if clicked.ContainsKey(key) or VisiblePart(c).IsEmpty then
          Continue;
        if not prev.ContainsKey(key) then
        begin
          pick := c;
          Break;
        end;
        if pick = nil then
          pick := c;
      end;
      prev.Clear;
      for c in targets do
        prev.AddOrSetValue(TargetKey(c), True);
      if pick = nil then
        Break;
      key := TargetKey(pick);
      clicked.Add(key, True);
      step := RunStep(AForm, pick, key);
      StepLog.AddElement(step);
      if OpenedWindows(step) and (KindOf(pick) <> tgDropDown) then
        popupKeys.Add(key);
      Inc(steps);
      if not IsWindow(MainWnd) then
        Break;
    end;
    res.AddPair('steps', StepLog);

    { keyboard: the tab order from the first control }
    focus := TJSONArray.Create;
    res.AddPair('focus', focus);
    for I := 1 to 25 do
    begin
      SendKey(GetFocus, VK_TAB);
      Pump(120);
      focus.Add(FocusedName);
    end;
    SendKey(GetFocus, VK_ESCAPE);
    Pump(150);
    StepPre.Free;
    StepPre := TList<HWND>.Create;
    HandleNewWindows;

    { smaller window }
    w := Round(AForm.Width);
    h := Round(AForm.Height);
    AForm.SetBounds(Round(AForm.Left), Round(AForm.Top), Round(w * 0.8), Round(h * 0.8));
    Pump(500);
    CaptureAll(nil, 'small');
    res.AddPair('geometrySmall', GeometryOf(AForm));
    AForm.SetBounds(Round(AForm.Left), Round(AForm.Top), w, h);
    Pump(300);

    { dark, with the pop-ups opened again }
    SetTheme(AForm, 'Fluent Dark');
    CaptureAll(nil, 'dark');
    res.AddPair('geometryDark', GeometryOf(AForm));
    for k in popupKeys do
    begin
      targets.Clear;
      CollectForm(AForm, targets);
      for c in targets do
        if TargetKey(c) = k then
        begin
          step := RunStep(AForm, c, k);
          step.AddPair('theme', 'Fluent Dark');
          StepLog.AddElement(step);
          Break;
        end;
    end;
    res.AddPair('shell', ShellLog);
    ShellLog := nil;
    SaveText('click.json', res.Format(1));
  finally
    KillTimer(0, WatchId);
    Clicking := False;
    res.Free;
    targets.Free;
    clicked.Free;
    prev.Free;
    popupKeys.Free;
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
      Finish(2);
    end;
    modes := GetEnvironmentVariable('DEMOSHOT_MODES').Split(['|']);
    if Length(modes) = 0 then
      modes := ['asis', 'Fluent Light', 'Fluent Dark'];
    DefaultsDone := TDictionary<TClass, Boolean>.Create;
    DefaultsJson := TJSONObject.Create;
    try
      DumpColorIdents;
      for m in modes do
        if SameText(Trim(m), 'smoke') then
          Pump(1000)
        else if SameText(Trim(m), 'click') then
          RunClick(f)
        else if Trim(m) <> '' then
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
  Finish(0);
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
var
  arr: TJSONArray;
begin
  if Clicking then
  begin
    { the click-through goes on: the exception belongs to the step }
    if Assigned(CurStep) then
    begin
      if not CurStep.TryGetValue<TJSONArray>('exceptions', arr) then
      begin
        arr := TJSONArray.Create;
        CurStep.AddPair('exceptions', arr);
      end;
      arr.Add(CurAct + ': ' + E.ClassName + ': ' + E.Message);
    end
    else
      TFile.AppendAllText(TPath.Combine(OutDir, 'exceptions.txt'), E.ClassName + ': ' + E.Message + sLineBreak,
        TEncoding.UTF8);
    Exit;
  end;
  SaveText('error.txt', E.ClassName + ': ' + E.Message);
  Finish(3);
end;

procedure UnhandledException(ExceptObject: TObject; ExceptAddr: Pointer);
begin
  if ExceptObject is Exception then
    SaveText('error.txt', ExceptObject.ClassName + ': ' + Exception(ExceptObject).Message)
  else
    SaveText('error.txt', 'unhandled exception');
  Finish(3);
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
    InitClick;
    TimerId := SetTimer(0, 0, StrToIntDef(GetEnvironmentVariable('DEMOSHOT_DELAY'), 2500), @TimerProc);
  end;

finalization
  ErrorSink.Free;
  StepPre.Free;
  ShellLog.Free;

end.
