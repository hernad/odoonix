{ft, lib}:

{

    freetype-py = { 
      #name = "freetype-py"; 
      version = "2.4.0";
      extension = "zip";
      sha256 = "sha256-itgRldL48zmrphcAzr+9d9760UnFH1m3WipeN4M64S4=";
    };

    xlrd = { 
      #name = "xlrd"; 
      version = "1.2.0";
      sha256 = "sha256-VG6zbO6NtAw+qkbDUeZ//ubutfomULcbxMdYopobKbI=";
    };

    Pillow = {
       version = "10.1.0";
      #format = "pyproject";
      hash = "sha256-5r+N5sNu2WyG6jtuHVJzxT9G71GKBiRkzX713Sz5Ljg=";
    };

    pypdf2 = {
      #name = "pypdf2";
      version = "2.12.1";
      hash = "sha256-4D7xirzHXadBoKzBp3SSU0loh744zZiHvM4c7jk9pF4=";
      doCheck = false;
    };

    gevent =  {
      version = "22.10.2";
#      format = "setuptools";
      hash = "sha256-HKAdoXbuN7NSeicC99QNvJ/7jPx75aA7+k+e7EXlXEY=";
      patches = [
        ./patches/gevent/threadpool.patch
      ];      
      doCheck = false;
    };

    devtools = {
      #name = "devtools";
      doCheck = false;
    };

    aiohttp = {
      doCheck = false;
    };

    httpx = {
      doCheck = false;
    };

    curio = {
      doCheck = false;
    };

    astroid = {
      doCheck = false;
    };

    sphinx = {
      doCheck = false;

      #nativeCheckInputs = [
      #  cython
      #  filelock
      #  html5lib
      #  pytestCheckHook
      #];    

    };

    watchdog = {
      doCheck = false;
    };

    orjson = {
      doCheck = false;
    };

    protobuf = {
      doCheck = false;
    };

    mocket = {
      doCheck = false;
    };

    scipy = {
      doCheck = false;
    };

    numpy = {
      doCheck = false;
    };

    xdist = {
      doCheck = false;
    };

    pandas = {
      doCheck = false;
    };

    reportlab = {
      #pname = "reportlab";
      version = "3.6.13";
      hash = "sha256-b3XTP3o3IM9HNxq2PO0PDr0a622xk4aukviXegm+lhE=";

      buildInputs = [ ft ];

      postPatch = ''
        substituteInPlace setup.py \
          --replace "mif = findFile(d,'ft2build.h')" "mif = findFile('${lib.getDev ft}','ft2build.h')"

        # Remove all the test files that require access to the internet to pass.
        rm tests/test_lib_utils.py
        rm tests/test_platypus_general.py
        rm tests/test_platypus_images.py

        # Remove the tests that require Vera fonts installed
        rm tests/test_graphics_render.py
        rm tests/test_graphics_charts.py
      '';

      doCheck = false;
    };

  }
