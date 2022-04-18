{ mkDerivation, aeson, base, bytestring, hpack, http-client
, http-conduit, lib, process, protolude, servant, servant-server
, text, warp
}:
mkDerivation {
  pname = "pms";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = true;
  isExecutable = true;
  libraryHaskellDepends = [
    aeson base bytestring http-client http-conduit process protolude
    servant servant-server text warp
  ];
  libraryToolDepends = [ hpack ];
  executableHaskellDepends = [ base ];
  testHaskellDepends = [ base ];
  prePatch = "hpack";
  homepage = "https://github.com/githubuser/pms#readme";
  license = lib.licenses.bsd3;
}
