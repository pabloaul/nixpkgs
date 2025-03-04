{
  lib,
  buildPythonPackage,
  cbor-diag,
  cbor2,
  cryptography,
  dtlssocket,
  fetchFromGitHub,
  filelock,
  ge25519,
  pygments,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  setuptools,
  termcolor,
  websockets,
}:

buildPythonPackage rec {
  pname = "aiocoap";
  version = "0.4.12";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "chrysn";
    repo = "aiocoap";
    tag = version;
    hash = "sha256-yy9TsNTdk7kfLilXsjDCVAe1C3O70P09It71zU26PKo=";
  };

  build-system = [ setuptools ];

  optional-dependencies = {
    oscore = [
      cbor2
      cryptography
      filelock
      ge25519
    ];
    tinydtls = [ dtlssocket ];
    ws = [ websockets ];
    prettyprint = [
      termcolor
      cbor2
      pygments
      cbor-diag
    ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Don't test the plugins
    "tests/test_tls.py"
    "tests/test_reverseproxy.py"
    "tests/test_oscore_plugtest.py"
  ];

  disabledTests =
    [
      # Communication is not properly mocked
      "test_uri_parser"
      # Doctest
      "test_001"
    ]
    ++ lib.optionals (pythonAtLeast "3.12") [
      # https://github.com/chrysn/aiocoap/issues/339
      "TestServerTCP::test_big_resource"
      "TestServerTCP::test_empty_accept"
      "TestServerTCP::test_error_resources"
      "TestServerTCP::test_fast_resource"
      "TestServerTCP::test_js_accept"
      "TestServerTCP::test_manualbig_resource"
      "TestServerTCP::test_nonexisting_resource"
      "TestServerTCP::test_replacing_resource"
      "TestServerTCP::test_root_resource"
      "TestServerTCP::test_slow_resource"
      "TestServerTCP::test_slowbig_resource"
      "TestServerTCP::test_spurious_resource"
      "TestServerTCP::test_unacceptable_accept"
    ];

  pythonImportsCheck = [ "aiocoap" ];

  meta = with lib; {
    description = "Python CoAP library";
    homepage = "https://aiocoap.readthedocs.io/";
    changelog = "https://github.com/chrysn/aiocoap/blob/${version}/NEWS";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
