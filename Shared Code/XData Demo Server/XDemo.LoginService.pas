unit XDemo.LoginService;

(* Sign-in of the demo server: POST <root>/LoginService/Login with {"User": ..., "Password": ...} answers
  {"value": "<JWT>"}. The password of the demo user is made when the server starts and shown in its window; the key
  that signs the tokens is made at start too. Nothing secret is stored in a file. *)

interface

uses
  XData.Service.Common;

type
  [ServiceContract]
  ILoginService = interface(IInvokable)
    ['{6C1B7F0E-4F7B-4C35-9F43-2C8E9A4D1B61}']
    function Login(const User, Password: string): string;
  end;

  [ServiceImplementation]
  TLoginService = class(TInterfacedObject, ILoginService)
  public
    function Login(const User, Password: string): string;
  end;

var
  DemoUser: string = 'demo';
  DemoPassword: string;
  { the key that signs the tokens (random, made at start) }
  DemoSigningKey: string;

{ a password and a signing key for this run }
procedure MakeDemoSecrets;

implementation

uses
  System.SysUtils, Bcl.JOSE.Core.Builder, Bcl.JOSE.Core.JWA, Bcl.JOSE.Core.JWT, Bcl.JOSE.Core.JWK,
  XData.Sys.Exceptions;

procedure MakeDemoSecrets;
const
  Chars = 'abcdefghjkmnpqrstuvwxyz23456789';
var
  I: Integer;
  g: TGUID;
  b: TBytes;
begin
  // the password from the random bytes of a GUID (not from Random, which the clock seeds)
  CreateGUID(g);
  SetLength(b, SizeOf(g));
  Move(g, b[0], SizeOf(g));
  DemoPassword := '';
  for I := 1 to 10 do
  begin
    if I = 6 then
      DemoPassword := DemoPassword + '-';
    DemoPassword := DemoPassword + Chars[b[I + 5] mod Length(Chars) + 1];
  end;
  DemoSigningKey := '';
  for I := 1 to 2 do
  begin
    CreateGUID(g);
    DemoSigningKey := DemoSigningKey + GUIDToString(g);
  end;
end;

function TLoginService.Login(const User, Password: string): string;
var
  jwt: TJWT;
  jwk: TJWK;
begin
  if not SameText(User, DemoUser) or (Password <> DemoPassword) then
    raise EXDataHttpUnauthorized.Create('The user name or password is wrong.');
  jwt := TJWT.Create;
  try
    jwt.Claims.SetClaimOfType<string>('user', DemoUser);
    jwt.Claims.Expiration := Now + 1 / 24;
    jwk := TJWK.Create(TEncoding.UTF8.GetBytes(DemoSigningKey));
    try
      Result := TJOSE.SerializeCompact(jwk, TJOSEAlgorithmId.HS256, jwt, False);
    finally
      jwk.Free;
    end;
  finally
    jwt.Free;
  end;
end;

initialization
  RegisterServiceType(TLoginService);

end.
