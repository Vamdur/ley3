<!DOCTYPE html>
<html lang="es">
<?php @session_start();
  $vLibServer = "vLibJs";
  $hora = md5(date("YmdHis"));
  $vDirSys = 'sysConsultaLey';
  require_once("vSys/vSession.php");
  Sistema::SistemaIni();
  $vSysConfig = Sistema::varSistema();
  $_SESSION['autenticado'] = true;
  $_SESSION['idpersona']   = 0;
  $_SESSION['idusuario']   = 0;
  $_SESSION['cedula']      = '';

  //$_SESSION['idpersona']   = 7;
  //$_SESSION['idusuario']   = 7;
  //$_SESSION['cedula']      = '8760097';

?>
<head>
  <title><?php echo(Sistema::$vSysNombre);?></title>
  <META NAME="viewport"              CONTENT="width=device-width, initial-scale=1">
  <META HTTP-EQUIV='x-ua-compatible' CONTENT='ie=edge'>
  <META HTTP-EQUIV="CONTENT-TYPE"    CONTENT="text/html; charset=UTF-8">
  <META HTTP-EQUIV="EXPIRES"         CONTENT="Mon, 01 Jan 1990 00:00:01 GMT">
  <META HTTP-EQUIV="CACHE-CONTROL"   CONTENT="NO-STORE">
  <?php
    echo "\n";

    header("Last-Modified: ".gmdate("D, d M Y H:i:s")." GMT");
    //header("Connection: close");

    Sistema::vfnLink("$vDirSys/img/logo.png");

    if ($vSysConfig["reCaptcha"]){
      echo "\n<!-- reCaptcha -->\n<script src='https://www.google.com/recaptcha/api.js?hl=es' type='text/javascript'></script>\n";
    }

    echo "  <noscript><meta http-equiv='refresh' content='0;url=vSys/noJavaScript.php'></noscript>\n";

    Sistema::vfnLink('AdminLTE-3/adminlte.css','Theme Style','l');

    //Sistema::vfnLink('chosen-1.8.7/docsupport/prism.css','Chosen Select','f');
    Sistema::vfnLink('chosen-1.8.7/chosen.css','','f');

    //Sistema::vfnLink('jQuery/jquery.autogrow-textarea.js','Autogrowing Textarea Plugin');

    Sistema::vfnLink('bootstrap-4.5.0/css/bootstrap.min.css','Bootstrap 4.5.0','l');
    Sistema::vfnLink('jQueryUI/jquery-ui.min.css','jQueryUI Theme','l');

  //Sistema::vfnLink('floatingLabels/floatingLabels.css','Floating Labels','f');

    Sistema::vfnLink("jQueryUI-Themes/themes/".$vSysConfig['sysSkinJqGrid']."/jquery-ui.css",'','l');
    Sistema::vfnLink("jQueryUI-Themes/themes/".$vSysConfig['sysSkinJqGrid']."/jquery-ui.min.css",'','l');
    Sistema::vfnLink("jQueryUI-Themes/themes/".$vSysConfig['sysSkinJqGrid']."/theme.css",'','l');

    Sistema::vfnLink('jqGrid-4.15/ui.jqgrid.css','jQuery Grid','f');
    Sistema::vfnLink('jqGrid-4.15/ui.multiselect.min.css','','f');

    Sistema::vfnLink('select2/dist/css/select2.min.css','Select 2 https://select2.org/','f');
    Sistema::vfnLink('font-awesome-4.7.0/css/font-awesome.css','Font Awesome https://fortawesome.github.io/Font-Awesome/','l');

    Sistema::vfnLink("jsPanel-4.7.0/jspanel.css",'jsPanel 4.7.0 https://jspanel.de/','l');
    Sistema::vfnLink("jsPanel-4.7.0/animate.css",'l');

    Sistema::vfnLink("vSys/vSistema.css",'Css','l');
    if ( file_exists("$vDirSys/$vDirSys.css") ){
      Sistema::vfnLink("$vDirSys/$vDirSys.css",'Css','l');
    }

    Sistema::vfnLink("datepicker-1.9/bootstrap-datepicker3.css",'Bootstrap Datepicker','f');

    Sistema::vfnLink("jQuery/jQuery-3.5.1.min.js",'jQuery');
    Sistema::vfnLinkJs("jQuery/jQuery-3.5.1.min.js");

    Sistema::vfnLink("AdminLTE-3/adminlte.js",'AdminLTE');
    Sistema::vfnLinkJs("AdminLTE-3/adminlte.js");

    Sistema::vfnlink("jQueryUI/jquery-ui.min.js",'jQueryUI Theme','f');

    Sistema::vfnLink("jqGrid-4.15/jqGrid.4.15.js?ver=$hora",'jqGrid','f');
    Sistema::vfnLink("jqGrid-4.15/jqGridLocale.js",'','f');
    Sistema::vfnLink("jqGrid-4.15/ui.multiselect.min.js",'','f');

    Sistema::vfnLink("vSys/vJQuery.js?ver=$hora","Js",'l');
    Sistema::vfnLink("vSys/vJPanel.js?ver=$hora",'','l');

    Sistema::vfnLink("vSys/vJqGrid.js?ver=$hora",'','l');
    Sistema::vfnLinkJs("vSys/vJqGrid.js?ver=$hora");
    Sistema::vfnLink("vSys/vJqGridMethods.js",'','f');


    if ( file_exists("$vDirSys/$vDirSys.js") ){
      Sistema::vfnLink("$vDirSys/$vDirSys.js",'','l');
    }

    Sistema::vfnLink("select2/dist/js/select2.full.min.js",'Select 2','f');
    Sistema::vfnLink("select2/dist/js/i18n/es.js",'','f');

    // Teclas
    Sistema::vfnLink("shortcut/shortcut.js",'','f');

    Sistema::vfnLink('datepicker-1.9/bootstrap-datepicker.js','Bootstrap Datepicker','f');

    Sistema::vfnLink("jsPanel-4.7.0/jspanel.js",'jsPanel-4.7.0','f');
    Sistema::vfnLink("jsPanel-4.7.0/extensions/contextmenu/jspanel.contextmenu.min.js",'','f');
    Sistema::vfnLink("jsPanel-4.7.0/extensions/dock/jspanel.dock.min.js",'','f');
    Sistema::vfnLink("jsPanel-4.7.0/extensions/hint/jspanel.hint.min.js",'','f');
    Sistema::vfnLink("jsPanel-4.7.0/extensions/layout/jspanel.layout.min.js",'','f');
    Sistema::vfnLink("jsPanel-4.7.0/extensions/modal/jspanel.modal.min.js",'','f');
    Sistema::vfnLink("jsPanel-4.7.0/extensions/tooltip/jspanel.tooltip.min.js",'','f');

    Sistema::vfnLink('bootstrap-4.5.0/js/bootstrap.min.js','Bootstrap 4.5.0','f');
    Sistema::vfnLink('jQuery-Validation-1.19.0/jquery.validate.js','jQuery Validate','f');
    Sistema::vfnLink('jQuery-Validation-1.19.0/additional-methods.js','','f');
    Sistema::vfnLink("snowflakes/snowflakes.js",'Efecto Nieve','f');

    Sistema::vfnLink("chosen-1.8.7/chosen.jquery.js",'Chosen Select','f');
    Sistema::vfnLink("chosen-1.8.7/docsupport/prism.js",'','f');
    Sistema::vfnLink("chosen-1.8.7/docsupport/init.js",'','f');

    Sistema::vfnLink("moment/moment-with-locales.js",'','f');

 //Sistema::vfnLink("jqGrid-4.15/jqGridExportToExcel.js",'','f');
    echo("  <script> $.jgrid = $.jgrid || {}; $.jgrid.no_legacy_api = true; $.jgrid.useJSON = true; </script>\n");
// if (letra.match(/[VEJGCvejgc0-9]/)===null) n += 1;
//https://ebweb.es/iconos-de-font-awesome-archivos/
    //$bodyOnload ="onload='iniciarSesion();Javascript:history.go(1);' onunload='Javascript:history.go(1);' oncontextomenu='return false' onkeypress='chequearSesion();' onmousemove='chequearSesion();' onclick='chequearSesion();'";
    $bodyOnload ="onload='Javascript:history.go(1);' onunload='Javascript:history.go(1);' oncontextomenu='return false'";
 ?>
</head>
<body id="inicioBody" class="hold-transition sidebar-migni" <?php echo($bodyOnload);?> >
  <div id="sysSistema"
    data-desktop="<?php echo($_SESSION['desktop']);?>"
    data-vsysnombre="<?php echo(Sistema::$vSysNombre);?>"
    data-vsysnombre2="<?php echo(Sistema::$vSysNombre2);?>"
    data-vdirsys="<?php echo($vDirSys);?>"
    data-skin="<?php echo($vSysConfig['sysSkin']);?>"
    data-skin-jqgrid-btn="<?php echo($vSysConfig['sysSkinJqGridBtn']);?>"
    data-skin-frm="<?php echo($vSysConfig['sysSkinFrm']);?>"
    data-skin-frm-btn="<?php echo($vSysConfig['sysSkinFrmBtn']);?>"
    data-skin-ayuda="<?php echo($vSysConfig['sysSkinAyuda']);?>"
    data-skin-panel="<?php echo($vSysConfig['sysSkinPanel']);?>"
    data-icon="<?php echo($vSysConfig['sysIcon']);?>"
  ></div>
  <div id="sysVar"></div>
  <div id="sysGrid"></div>
  <div id="sysFoto"></div>
  <a id='sysDoc' class='miHide' href='#' download target='_blank'></a>

  <audio id="inicioSonido" prefetch><source src="vSys/sounds/default.wav" type="audio/mpeg">Tu navegador no soporta HTML5 audio.</audio>

  <div class="wrapper">
    <nav id='nav-iconos' class="main-header navbar elevation-4 navbar-expand <?php echo($vSysConfig['sysSkin']);?> navbar-light border-bottom">
      <ul class="navbar-nav">
        <li class="nav-item d-none d-sm-inline-block" >
          <b id='inicioSysNombre' class="nav-link m-0 text-dark1 " style='color:white;font-size:120%;' ><?php echo(Sistema::$vSysNombre);?></b>
        </li>
      </ul>
      <ul class="navbar-nav ml-auto">
        <li id="mnuIcoSesionLogin" class="nav-item" title="Iniciar Sesion" style=''>
          <a href="#" class="nav-link" onclick="vfnCargar('sysConsultaLey/vLogin.php');"><i class="fa fa-2x fa-sign-in"></i></a>
        </li>
        <li id="mnuIcoSesionRegistro" class="nav-item" title="Registrarse" style=''>
          <a href="#" class="nav-link" onclick="vfnCargar('sysConsultaLey/vLoginRegistro.php');"><i class="fa fa-2x fa-user-plus"></i></a>
        </li>
        <li id="mnuIcoSesionPerfil" class="nav-item" title="Mi Perfil" style='display:none;'>
          <a href="#" class="nav-link" onclick="vfnCargar('sysConsultaLey/vLoginPerfil.php');"><b id="sysUsuario"><i class="fa fa-2x fa-user"></i></b></a>
        </li>
        <li id="mnuIcoSesionRecuperar" class="nav-item" title="Recuperar Contraseña" style=''>
          <a href="#" class="nav-link" onclick="vfnCargar('sysConsultaLey/vLoginRecuperar.php');"><i class="fa fa-2x fa-key"></i></a>
        </li>
        <li id="mnuIcoSesionCerrar" class="nav-item" title='Cerrar'>
          <a class="nav-link" href="#" onclick="vfnCargar('blanco.php');" > <i class="fa fa-2x fa-power-off"></i></a>
        </li>
        <li id='inicioCargando' class="float-sm-right" style='display:none;'>
          <img src='vSys/img/cargando3.gif' width="50" height="50" style="position:absolute;right:10px;top:5px;z-index:99;">
        </li>
      </ul>
    </nav>

    <aside id="snowflakes-layer"  class="main-sidebar <?php echo($vSysConfig['sysSkinMenu']);?> elevation-3">
      <a href="#" class="brand-link <?php echo($vSysConfig['sysSkinLogo']);?>" >
        <img id='inicioIconLogo' src=<?php echo("$vDirSys/img/".$vSysConfig['sysIconLogo']);?> alt="Logo" class="brand-image img-circle align-self-end mr-3" style="opacity: .8;">
        <span class="brand-text font-weight-light" > <b><?php echo(Sistema::$vSysNombreCorto);?></b></span>
      </a>
      <div class="sidebar">
        <small>
          <nav class="mt-2">
            <ul id="inicioMenu" class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
            </ul>
          </nav>
        </small>
      </div>
    </aside>

    <div class="content-wrapper">
      <div class="content-header">
        <div class="container-fluid">
          <div class="row mb-2">
            <div class="col-sm-12">
              <span id='inicioTitulo' class="m-0 text-dark"></span>
              <span id='inicioSubTitulo' class="m-0 text-dark"></span>
              <span id='inicioLeer2' class="float-sm-right" style='padding:3px; display:none;border:2px solid #A9A9A9;border-radius:5px;'></span>
            </div>
          </div>
        </div>
      </div>

      <div class="content">
        <div class="container-fluid">
          <div class="row">
            <div id='inicioContenido' class="col-lg-12">
              <img  src='<?php echo("$vDirSys/img/covid19.png");?>' class="img-circle align-self-end mr-1" style="opacity: .8;">
            </div>
          </div>
          <br>
        </div>
      </div>

    </div>

    <footer class="main-footer">
      <div class="row"> <?php echo(Sistema::$vSysPiePagina);?> </div>
      <span id='inicioLeerArchivo' class="float-sm-right" style='display:none;'></span>
    </footer>

    <input id="idConfirmar" name="idConfirmar" value="false" >
    <div id='inicioConfirmar'></div>
    <div id='inicioBuscar' class='form-inline ml-3' >
      <div class='input-group input-group-sm' >
        <input id='codigoBuscar' name='codigoBuscar'  maxlength='10' class='form-control form-control-navbar' type='search' placeholder='Buscar...' aria-label='Search' >
        <div class='input-group-append'><button id='btnCodigoBuscar' class='btn btn-navbar' title='Buscar...' ><i class='fa fa-search'></i></button></div>
      </div>
    </div>

    <div id='inicioControlador'></div>

  </div>

  <script type="text/javascript">
    var vtLastSel;
    $(function(){
      if ( navigator.userAgent.indexOf('Firefox')!==-1 || navigator.userAgent.indexOf('Chrome')!==-1 ) {
        $('#inicioMenu li').remove();
        vfnCargarMenu("sysConsultaLey");
        jInformar("Información|<i class='fa fa-2x fa-sign-in'></i>&nbsp;&nbsp;INGRESAR (Usuario Registrado)<br><i class='fa fa-2x fa-user-plus'></i>&nbsp;&nbsp;REGISTRO (Usuario Nuevo)<br><i class='fa fa-2x fa-key'></i>&nbsp;&nbsp;RECUPERAR CONTRASEÑA (Por olvido)<br><i class='fa fa-2x fa-download'></i>&nbsp;&nbsp;DESCARGAR (Documentos)<br><br><center>Puede escribirnos al correo electrónico:<br> <b><i style='color:red;'>ordenaciondelterritorio.ve@gmail.com</i></center>");
       } else {
        vfnAjax("sysAjaxNavegador",{});
      }
    });

    $(window).bind('resize', function () {
      vfnGridResize();
      if ($(window).width()<=700){
        $('#inicioSysNombre').html($("#sysSistema").data("vsysnombre2"));
      }else if ($("#sysSistema").data("desktop")==='desktop') {
        $('#inicioSysNombre').html($("#sysSistema").data("vsysnombre"));
      }
    });
  </script>

  <?php
    echo "\n";

    Sistema::vfnlinkJs("jQueryUI/jquery-ui.min.js");

    Sistema::vfnLinkJs("jqGrid-4.15/jqGrid.4.15.js?ver=$hora");
    Sistema::vfnLinkJs("jqGrid-4.15/jqGridLocale.js?ver=$hora");
    Sistema::vfnLinkJs("jqGrid-4.15/ui.multiselect.min.js");
    Sistema::vfnLinkJs("vSys/vJqGridMethods.js");

    Sistema::vfnLinkJs("vSys/vJQuery.js?ver=$hora");
    Sistema::vfnLinkJs("vSys/vJPanel.js?ver=$hora");

    if ( file_exists("$vDirSys/$vDirSys.js") ){
      Sistema::vfnLinkJs("$vDirSys/$vDirSys.js?ver=$hora");
    }

    Sistema::vfnLinkJs("select2/dist/js/select2.full.min.js");
    Sistema::vfnLinkJs("select2/dist/js/i18n/es.js");

    // Teclas
    Sistema::vfnLinkJs("shortcut/shortcut.js");

    Sistema::vfnLinkJs("datepicker-1.9/bootstrap-datepicker.js");

    Sistema::vfnLinkJs("jsPanel-4.7.0/jspanel.js");
    Sistema::vfnLinkJs("jsPanel-4.7.0/extensions/contextmenu/jspanel.contextmenu.min.js");
    Sistema::vfnLinkJs("jsPanel-4.7.0/extensions/dock/jspanel.dock.min.js");
    Sistema::vfnLinkJs("jsPanel-4.7.0/extensions/hint/jspanel.hint.min.js");
    Sistema::vfnLinkJs("jsPanel-4.7.0/extensions/layout/jspanel.layout.min.js");
    Sistema::vfnLinkJs("jsPanel-4.7.0/extensions/modal/jspanel.modal.js");
    Sistema::vfnLinkJs("jsPanel-4.7.0/extensions/tooltip/jspanel.tooltip.min.js");

    Sistema::vfnLinkJs("bootstrap-4.5.0/js/bootstrap.min.js");
    Sistema::vfnLinkJs("jQuery-Validation-1.19.0/jquery.validate.js");
    Sistema::vfnLinkJs("jQuery-Validation-1.19.0/additional-methods.js");
    Sistema::vfnLinkJs("snowflakes/snowflakes.js");

    //https://cybmeta.com/chosen-caracteristicas-y-ejemplos-de-uso
    Sistema::vfnLinkJs("chosen-1.8.7/chosen.jquery.js");
    //Sistema::vfnLinkJs("chosen-1.8.7/docsupport/prism.js");
    //Sistema::vfnLinkJs("chosen-1.8.7/docsupport/init.js");
    Sistema::vfnLinkJs("moment/moment-with-locales.js");

//Sistema::vfnLinkJs("jqGrid-4.15/jqGridExportToExcel.js");
    echo("  <script> $.widget.bridge('uibutton',$.ui.button); </script>\n");

  ?>

</body>
</html>
