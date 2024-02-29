{pkgs, python, odooVersion, ...}:

let 

  name_remove_unused_prevodi = "remove_unused_prevodi";
  name_remove_file = "remove_file";

  script_src_remove_unused_prevodi = builtins.readFile scripts/remove_unused_prevodi_nix.sh;
  script_src_remove_file = builtins.readFile scripts/remove.sh;
  
  script_remove_unused_prevodi = (
    pkgs.writeScriptBin name_remove_unused_prevodi script_src_remove_unused_prevodi).overrideAttrs(old: {
     buildCommand = "${old.buildCommand}\n patchShebangs $out";
  });

  script_remove_file = (pkgs.writeScriptBin name_remove_file script_src_remove_file).overrideAttrs(old: {
     buildCommand = "${old.buildCommand}\n patchShebangs $out";
  });

  
in
python.pkgs.buildPythonApplication rec {

    pname = "odoo";
    version = "${odooVersion.version}.${odooVersion.release}";

    format = "setuptools";

    src = pkgs.fetchzip {
      url = (if odooVersion.url != null then "${odooVersion.url}" else "https://nightly.odoo.com/${odooVersion.version}/nightly/src/odoo_${version}.zip");
      name = "${pname}-${version}";
      hash = "${odooVersion.hash}";
    };

    doCheck = false;

    preInstall = ''
        #echo "import _distutils_hack; _distutils_hack.insert_shim(); import distutils; print('ok-distutils')" | python      
    '';

    postInstall = ''
    '';

    # https://github.com/pypa/setuptools/issues/3661
    # [BUG] distutils cannot be imported on Python 3.12 (without distutils) if pip was imported #3661

    preBuild = ''
      #no payment provider
      echo '<?xml version="1.0" encoding="utf-8"?><odoo noupdate="1"></odoo>' > odoo/addons/payment/data/payment_provider_data.xml

    '';

    #dontConfigure = true;
    #dontBuild = true;

    #preBuild = ''
    #      addAutoPatchelfSearchPath ${jre8}/lib/openjdk/jre/lib/
    #'';

    propagatedBuildInputs = with python.pkgs; [
      babel
      chardet
      cryptography
      decorator
      docutils
      ebaysdk
      freezegun
      gevent
      greenlet
      idna
      jinja2
      libsass
      lxml
      markupsafe
      num2words
      ofxparse
      passlib
      pillow
      polib
      psutil
      psycopg2
      pydot
      pyopenssl
      pypdf2
      pyserial
      python-dateutil
      python-stdnum
      pytz
      pyusb
      qrcode
      requests
      urllib3
      vobject
      werkzeug
      xlrd
      xlsxwriter
      rjsmin
      setuptools
      mock
      reportlab
      python-ldap
      geoip2
      xlwt
      zeep
      python-barcode
    ] ++ [
      pkgs.wkhtmltopdf-bin
    ];

    dontStrip = true;

    postFixup = ''
     cd $out
     ${script_remove_unused_prevodi}/bin/remove_unused_prevodi ${script_remove_file}/bin/remove_file
     mv $out/bin/odoo $out/bin/odoo.sh
     mv $out/bin/.odoo-wrapped $out/bin/odoo
     sed -i "s|import odoo|import os; os.environ['PATH'] += os.pathsep + os.pathsep.join(['${pkgs.wkhtmltopdf-bin}/bin']); import odoo; from importlib import metadata\nfor pkg in ['werkzeug','reportlab', 'pypdf2', 'pillow', 'xlrd', 'zeep', 'gevent', 'psycopg2','freezegun','greenlet','jinja2','libsass','lxml','markupsafe','urllib3','vobject','xlwt','pydot','pyopenssl','python-ldap','pytz','qrcode','requests','rjsmin','XlsxWriter']: print(pkg, ':', metadata.version(pkg))|" $out/bin/odoo

    '';

    #meta = with lib; {
    #  description = "Open Source ERP and CRM";
    #  homepage = "https://www.odoo.com/";
    #  license = licenses.lgpl3Only;
    #  maintainers = with maintainers; [ mkg20001 ];
    #};

}



#werkzeug : 2.3.8
#reportlab : 3.6.13
#pypdf2 : 2.12.1
#pillow : 10.1.0
#xlrd : 1.2.0
#zeep : 4.2.1
#gevent : 22.10.2
#psycopg2 : 2.9.7
#freezegun : 1.2.2
#greenlet : 3.0.1
#jinja2 : 3.1.3
#libsass : 0.22.0
#lxml : 4.9.3
#markupsafe : 2.1.3
#urllib3 : 2.0.7
#vobject : 0.9.6.1
#xlwt : 1.3.0
#pydot : 1.4.2
#pyopenssl : 23.2.0
#python-ldap : 3.4.4
#pytz : 2023.3.post1
#qrcode : 7.4.2
#requests : 2.31.0
#rjsmin : 1.2.2
#XlsxWriter : 3.1.9
