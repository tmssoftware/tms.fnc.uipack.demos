unit XDemo.Entities;

{ The entities of the TMS XData demo server: Customer, Order (with its customer) and Task. }

interface

uses
  Aurelius.Mapping.Attributes, Aurelius.Types.Proxy, XData.Security.Attributes;

type
  [Entity, Table('CUSTOMER')]
  [Id('FId', TIdGenerator.None)]
  TCustomer = class
  private
    [Column('ID', [TColumnProp.Required])]
    FId: Integer;
    [Column('NAME', [TColumnProp.Required], 80)]
    FName: string;
    [Column('CITY', [], 40)]
    FCity: string;
    [Column('COUNTRY', [], 40)]
    FCountry: string;
    [Column('CREDIT', [])]
    FCredit: Double;
    [Column('ACTIVE', [])]
    FActive: Boolean;
    [Column('CREATED', [])]
    FCreated: TDate;
  public
    property Id: Integer read FId write FId;
    property Name: string read FName write FName;
    property City: string read FCity write FCity;
    property Country: string read FCountry write FCountry;
    property Credit: Double read FCredit write FCredit;
    property Active: Boolean read FActive write FActive;
    property Created: TDate read FCreated write FCreated;
  end;

  [Entity, Table('ORDERS')]
  [Id('FId', TIdGenerator.None)]
  TOrder = class
  private
    [Column('ID', [TColumnProp.Required])]
    FId: Integer;
    [Association([TAssociationProp.Lazy], [])]
    [JoinColumn('CUSTOMER_ID', [])]
    FCustomer: Proxy<TCustomer>;
    [Column('ORDER_DATE', [])]
    FOrderDate: TDate;
    [Column('STATUS', [], 20)]
    FStatus: string;
    [Column('AMOUNT', [])]
    FAmount: Double;
    function GetCustomer: TCustomer;
    procedure SetCustomer(const Value: TCustomer);
  public
    property Id: Integer read FId write FId;
    property Customer: TCustomer read GetCustomer write SetCustomer;
    property OrderDate: TDate read FOrderDate write FOrderDate;
    property Status: string read FStatus write FStatus;
    property Amount: Double read FAmount write FAmount;
  end;

  { the tasks of the team: only a signed-in user reads them (JWT of LoginService/Login) }
  [Entity, Table('TASK')]
  [Id('FId', TIdGenerator.None)]
  [EntityAuthorize]
  TTask = class
  private
    [Column('ID', [TColumnProp.Required])]
    FId: Integer;
    [Column('TITLE', [TColumnProp.Required], 80)]
    FTitle: string;
    [Column('STATUS', [], 20)]
    FStatus: string;
    [Column('OWNER', [], 40)]
    FOwner: string;
    [Column('PRIORITY', [], 20)]
    FPriority: string;
    [Column('SORT_ORDER', [])]
    FOrder: Integer;
    { the customer the task is for (an eager association: read with the task) }
    [Association([], [])]
    [JoinColumn('CUSTOMER_ID', [])]
    FCustomer: TCustomer;
  public
    property Id: Integer read FId write FId;
    property Title: string read FTitle write FTitle;
    property Status: string read FStatus write FStatus;
    property Owner: string read FOwner write FOwner;
    property Priority: string read FPriority write FPriority;
    property Order: Integer read FOrder write FOrder;
    property Customer: TCustomer read FCustomer write FCustomer;
  end;

implementation

uses
  Aurelius.Mapping.Explorer;

function TOrder.GetCustomer: TCustomer;
begin
  Result := FCustomer.Value;
end;

procedure TOrder.SetCustomer(const Value: TCustomer);
begin
  FCustomer.Value := Value;
end;

initialization
  RegisterEntity(TCustomer);
  RegisterEntity(TOrder);
  RegisterEntity(TTask);

end.
