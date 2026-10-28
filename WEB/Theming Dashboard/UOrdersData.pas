unit UOrdersData;

{ TMS FNC UI Pack - Theming Dashboard demo, TMS WEB Core version: the data of the order management app.

  orders.json (next to the project, deployed with the page) holds the orders, the customers, the
  project tasks and the goals. The orders are the rows of the form's TWebClientDataSet; the key
  figures and the projects' states are computed from the rows here, as the Kpis and Projects queries
  of the VCL / FMX data module do in SQL. What the browser tab changes is kept in its session
  storage: it lasts as long as the tab. }

interface

uses
  SysUtils, Math, JS, Web, DB, WEBLib.CDS;

type
  { the figures of the latest month in the data and the goals of its quarter }
  TOrderKpis = record
    RefDate: TDateTime;
    OrderCount, OpenOrders, LateOrders, Customers, NewCustomers: Integer;
    Revenue, RevenuePrev, AvgOrder, AvgOrderPrev, GoalRevenue, GoalOnTime, GoalRetention: Double;
  end;

  TOrdersData = class
  private
    FData: TJSObject;
    FOrders: TWebClientDataSet;
    function Rows: TJSArray;
  public
    constructor Create(AOrders: TWebClientDataSet);
    { this tab's data, when it changed any (True), else orders.json must be loaded with Load }
    function Restore: Boolean;
    procedure Load(const AJSON: string);
    { keeps the tab's data; Forget drops it }
    procedure Save;
    procedure Forget;
    function Kpis: TOrderKpis;
    function NextId: Integer;
    function Customers: TJSArray;
    { the projects, each followed by its tasks (id, parent_id, name, owner, status, done); a project is
      done when all its tasks are, at risk when an open task is }
    function Projects: TJSArray;
    procedure SetDone(AProjectId: Integer; ADone: Boolean);
  end;

function ISODate(ADate: TDateTime): string;
function ParseISODate(const AText: string): TDateTime;

implementation

const
  SessionKey = 'tms-fnc-theming-dashboard';

function ISODate(ADate: TDateTime): string;
begin
  Result := FormatDateTime('yyyy-mm-dd', ADate);
end;

function ParseISODate(const AText: string): TDateTime;
begin
  Result := EncodeDate(StrToIntDef(Copy(AText, 1, 4), 2026), StrToIntDef(Copy(AText, 6, 2), 1),
    StrToIntDef(Copy(AText, 9, 2), 1));
end;

constructor TOrdersData.Create(AOrders: TWebClientDataSet);
begin
  FOrders := AOrders;
end;

function TOrdersData.Restore: Boolean;
begin
  Result := isString(window.sessionStorage.getItem(SessionKey));
  if Result then
    Load(window.sessionStorage.getItem(SessionKey));
end;

procedure TOrdersData.Load(const AJSON: string);
begin
  FData := TJSObject(TJSJSON.parse(AJSON));
  FOrders.Close;
  FOrders.Rows := TJSArray(FData['orders']);
  FOrders.Open;
end;

{ the dataset's rows (a deleted row is undefined) }
function TOrdersData.Rows: TJSArray;
begin
  Result := FOrders.Rows.filter(function(el: JSValue; i: NativeInt; a: TJSArray): Boolean begin Result := isDefined(el); end);
end;

procedure TOrdersData.Save;
begin
  FData['orders'] := Rows;
  window.sessionStorage.setItem(SessionKey, TJSJSON.stringify(FData));
end;

procedure TOrdersData.Forget;
begin
  window.sessionStorage.removeItem(SessionKey);
end;

function TOrdersData.Customers: TJSArray;
begin
  Result := TJSArray(FData['customers']);
end;

function TOrdersData.NextId: Integer;
var
  o: JSValue;
begin
  Result := 10240;
  for o in Rows do
    Result := Max(Result, Integer(TJSObject(o)['id']) + 1);
end;

function TOrdersData.Kpis: TOrderKpis;
var
  r: TJSArray;
  o, firsts, back: TJSObject;
  v: JSValue;
  ref, cur, prev, qstart, d, c: string;
  nNow, nPrev, qCount, qLate, before: Integer;
  qRev: Double;
begin
  r := Rows;
  ref := '';
  firsts := TJSObject.new;
  for v in r do
  begin
    o := TJSObject(v);
    d := string(o['order_date']);
    c := string(o['customer']);
    if d > ref then
      ref := d;
    if not firsts.hasOwnProperty(c) or (d < string(firsts[c])) then
      firsts[c] := d;
  end;
  Result.RefDate := ParseISODate(ref);
  cur := Copy(ref, 1, 7);
  prev := Copy(ISODate(IncMonth(Result.RefDate, -1)), 1, 7);
  qstart := Copy(ISODate(IncMonth(Result.RefDate, -((StrToInt(Copy(ref, 6, 2)) - 1) mod 3))), 1, 7);
  Result.OrderCount := r.Length;
  Result.OpenOrders := 0;
  Result.LateOrders := 0;
  Result.Revenue := 0;
  Result.RevenuePrev := 0;
  nNow := 0;
  nPrev := 0;
  qRev := 0;
  qCount := 0;
  qLate := 0;
  back := TJSObject.new;
  for v in r do
  begin
    o := TJSObject(v);
    d := Copy(string(o['order_date']), 1, 7);
    if string(o['status']) <> 'Shipped' then
      Inc(Result.OpenOrders);
    if string(o['status']) = 'Late' then
      Inc(Result.LateOrders);
    if d = cur then
    begin
      Result.Revenue := Result.Revenue + Double(o['amount']);
      Inc(nNow);
    end
    else if d = prev then
    begin
      Result.RevenuePrev := Result.RevenuePrev + Double(o['amount']);
      Inc(nPrev);
    end;
    if d >= qstart then
    begin
      qRev := qRev + Double(o['amount']);
      Inc(qCount);
      if string(o['status']) = 'Late' then
        Inc(qLate);
      { a customer of before the quarter who ordered again }
      if Copy(string(firsts[string(o['customer'])]), 1, 7) < qstart then
        back[string(o['customer'])] := True;
    end;
  end;
  Result.Customers := Customers.Length;
  Result.NewCustomers := 0;
  before := 0;
  for c in TJSObject.keys(firsts) do
    if Copy(string(firsts[c]), 1, 7) = cur then
      Inc(Result.NewCustomers)
    else if Copy(string(firsts[c]), 1, 7) < qstart then
      Inc(before);
  Result.AvgOrder := Result.Revenue / Max(1, nNow);
  Result.AvgOrderPrev := Result.RevenuePrev / Max(1, nPrev);
  Result.GoalRevenue := 100 * qRev / Double(TJSObject(TJSArray(FData['goals'])[0])['target']);
  Result.GoalOnTime := 100 * (qCount - qLate) / Max(1, qCount);
  Result.GoalRetention := 100 * Length(TJSObject.keys(back)) / Max(1, before);
end;

function TOrdersData.Projects: TJSArray;
var
  all: TJSArray;
  p, t: TJSObject;
  v, w: JSValue;
  open, risk: Integer;
begin
  all := TJSArray(FData['projects']);
  Result := TJSArray.new;
  for v in all do
  begin
    p := TJSObject(v);
    if Integer(p['parent_id']) <> 0 then
      Continue;
    Result.push(p);
    open := 0;
    risk := 0;
    for w in all do
    begin
      t := TJSObject(w);
      if Integer(t['parent_id']) <> Integer(p['id']) then
        Continue;
      Result.push(t);
      if not Boolean(t['done']) then
        Inc(open);
      if not Boolean(t['done']) and (string(t['status']) = 'At risk') then
        Inc(risk);
    end;
    p['done'] := open = 0;
    if open = 0 then
      p['status'] := 'Done'
    else if risk > 0 then
      p['status'] := 'At risk'
    else
      p['status'] := 'On track';
  end;
end;

procedure TOrdersData.SetDone(AProjectId: Integer; ADone: Boolean);
var
  v: JSValue;
  t: TJSObject;
begin
  for v in TJSArray(FData['projects']) do
  begin
    t := TJSObject(v);
    if (Integer(t['parent_id']) <> 0) and ((Integer(t['id']) = AProjectId) or (Integer(t['parent_id']) = AProjectId)) then
    begin
      t['done'] := ADone;
      if ADone then
        t['status'] := 'Done'
      else
        t['status'] := 'In progress';
    end;
  end;
  Save;
end;

end.
