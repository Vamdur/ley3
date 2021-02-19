<?php @session_start();

  $cedula = $_POST["cedulafk"];

  if ( $vGrid==='vlogin' ){

    $login = $_POST["login"];
    $clave = md5($_POST["password"]);
    $rst = $vSys->vfSelect("FSELECT idpersona,cedula FROM dpersona WHERE cedula::text='$login' AND clave='$clave'");
    if ( !$rst->idpersona ){
      $rst = $vSys->vfSelect("FSELECT idpersona,cedula FROM dpersona WHERE login='$login' AND clave='$clave'");
      if ( !$rst->idpersona ){
        $rst = $vSys->vfSelect("FSELECT idpersona,cedula FROM dpersona WHERE correo='$login' AND clave='$clave'");
        if ( !$rst->idpersona ){
          $rst = $vSys->vfSelect("FSELECT idpersona,cedula FROM dpersona WHERE idpersona::text='$login' AND clave='$clave'");
        }
      }
    }

    if ( !$rst->idpersona ){
      $vReturn['error'] = 'El Usuario no existe en la Base de Datos.<br> o la Contraseña no es la Correcta.';
    }else{
      $_SESSION['autenticado'] = true;
      $_SESSION['idpersona']   = $rst->idpersona ;
      $_SESSION['idusuario']   = $rst->idpersona ;
      $_SESSION['cedula']      = $rst->cedula ;

      $vReturn['script'] .= "$('#sysUsuario').data('cedula','".$cedula."');";
      $vReturn['script'] .= "$('#mnuSesionLogin,#mnuSesionRegistro,#mnuSesionRecuperar').remove();";
      $vReturn['script'] .= "$('#mnuIcoSesionLogin,#mnuIcoSesionRegistro,#mnuIcoSesionRecuperar').remove();";
      $vReturn['script'] .= "$('#mnuSesionPerfil,#mnuIcoSesionPerfil').show();";

      $vReturn['script'] .= "$('#inicioMenu li').remove();";
      $vReturn['script'] .= "vfnCargarMenu('sysConsultaLey');";

    }
  }

  if ( $vGrid==='vloginregistro' || $vGrid==='vloginperfil' ){

    $cedula = $_POST["cedula"];
    $record["cedula"]        = $cedula;
    $record["apellidos1"]    = ucwords(strtolower($_POST["apellidos1"]));
    $record["apellidos2"]    = ucwords(strtolower($_POST["apellidos2"]));
    $record["nombres1"]      = ucwords(strtolower($_POST["nombres1"]));
    $record["nombres2"]      = ucwords(strtolower($_POST["nombres2"]));
    $record["correo"]        = strtolower($_POST["correo"]);
    $record["ciudad"]        = $_POST["ciudad"];
    $record["direccion"]     = $_POST["direccion"];
    $record["celular"]       = $_POST["celular"];
    $record["fax"]           = $_POST["fax"];
    $record["institucion"]   = $_POST["institucion"];
    $record["idparroquiafk"] = $_POST["idparroquiafk"];
    $record["pregunta"]      = strtolower($_POST["pregunta"]);
    $record["sexo"]          = $_POST["sexo"];
    $record["fnacimiento"]   = $_POST["fnacimiento"];
    $elUsuario = $record["nombres1"].' '.$record["apellidos1"];

    if ( $vAccion==='Incluir' ){
      $record["login"] = $cedula;
      $record["ipdir"] = $vSys->getRealIP();
      if ($_POST["password"]===''){
         $record["clave"] = md5("$cedula");
      }else{
        $record["clave"] = md5(strtolower($_POST["password"]));
      }
      $record["respuesta"] = md5(strtolower($_POST["respuesta"]));
    }elseif ( $vAccion==='Editar' ){
      if ($_POST["password"]!==''){
        $record["clave"]  = md5(strtolower($_POST["password"]));
      }
      if ($_POST["respuesta2"]!==''){
        $record["respuesta"] = md5(strtolower($_POST["respuesta2"]));
      }
    }
    unset($record['idpersona1']);
    unset($record['fpersona1']);
    unset($record['idpersona2']);
    unset($record['fpersona2']);

    $vReturn['error'] = $vSys->vfRegistrar("dpersona",$record,"cedula=$cedula");

    if ( $vReturn['error']==='' ){
      $_SESSION['cedula'] = $cedula;
      $vReturn['script'] .= "$('#sysUsuario').data('cedula','".$cedula."');";
      $vReturn['script'] .= "$('#mnuSesionLogin,#mnuSesionRegistro,#mnuSesionRecuperar').remove();";
      $vReturn['script'] .= "$('#mnuIcoSesionLogin,#mnuIcoSesionRegistro,#mnuIcoSesionRecuperar').remove();";
      $vReturn['script'] .= "$('#mnuSesionPerfil,#mnuIcoSesionPerfil').show();";

      if ( $vAccion==='Incluir' ){
        $rst = $vSys->vfSelect("FSELECT idpersona FROM dpersona WHERE cedula=$cedula");
        $_SESSION['autenticado'] = true;
        $_SESSION['idpersona']   = $rst->idpersona;
        $_SESSION['idusuario']   = $rst->idpersona;

        $vReturn['script'] .= "jAviso('$elUsuario ha sido Registrado(a).');";
        $vReturn['script'] .= "$('#inicioMenu li').remove();";
        $vReturn['script'] .= "vfnCargarMenu('sysConsultaLey');";

      }elseif ( $vAccion==='Editar' ){
        $vmensaje  = "$elUsuario has Actualizado tus Datos según su Criterio, ";
        $vmensaje .= "quedan EXENTOS de cualquier Responsabilidad los Administradores del Sistema.";
        $vReturn['script'] .= "jAdvertencia('$vmensaje');";
      }

    }

  }

  if ( $vGrid==='vloginrecuperar' ){

    $login = $_POST["login"];
    $clave = md5($_POST["respuesta"]);
    $rst = $vSys->vfSelect("FSELECT idpersona,cedula FROM dpersona WHERE cedula::text='$login' AND respuesta='$clave'");
    if ( !$rst->idpersona ){
      $rst = $vSys->vfSelect("FSELECT idpersona,cedula FROM dpersona WHERE login='$login' AND respuesta='$clave'");
      if ( !$rst->idpersona ){
        $rst = $vSys->vfSelect("FSELECT idpersona,cedula FROM dpersona WHERE correo='$login' AND respuesta='$clave'");
        if ( !$rst->idpersona ){
          $rst = $vSys->vfSelect("FSELECT idpersona,cedula FROM dpersona WHERE idpersona::text='$login' AND respuesta='$clave'");
        }
      }
    }

    if ( !$rst->idpersona ){
      $vReturn['error'] = 'La Respuesta solicitada no es Correcta.';
    }else{
      $_SESSION['autenticado'] = true;
      $_SESSION['idpersona']   = $rst->idpersona ;
      $_SESSION['idusuario']   = $rst->idpersona ;
      $_SESSION['cedula']      = $rst->cedula ;
     // $clave = md5("$rst->cedula");

      $vContrasena  = $vSys->vGenerarPassword(5);
      $clave = md5("$vContrasena");
      $rst = $vSys->vfSelect("UPDATE dpersona SET clave='$clave' WHERE cedula=$rst->cedula");
      $vmensaje  .= "Nueva Contraseña Asignada:<b><h3><center>$vContrasena</center></h3></b>";
      $vmensaje .= "La puede y debe Cambiar luego en su PERFIL, ";
      $vmensaje .= "quedan EXENTOS de cualquier Responsabilidad los Administradores del Sistema.";
      $vReturn['script'] .= "jAdvertencia('$vmensaje');";

      $vReturn['script'] .= "$('#sysUsuario').data('cedula','".$cedula."');";
      $vReturn['script'] .= "$('#mnuSesionLogin,#mnuSesionRegistro,#mnuSesionRecuperar').remove();";
      $vReturn['script'] .= "$('#mnuIcoSesionLogin,#mnuIcoSesionRegistro,#mnuIcoSesionRecuperar').remove();";

      $vReturn['script'] .= "$('#mnuSesionPerfil,#mnuIcoSesionPerfil').show();";
    }
  }

  if ( $vGrid==='dpropuesta' ){

    $record["cedulafk"]      = $_SESSION['cedula'];
    $record["propuesta"]     = $_POST["propuesta"];
    $record["numero"]        = $_POST["numero"];
    $record["numero2"]       = $_POST["numero2"];
    $record["numero3"]       = $_POST["numero3"];
    $record["idpropuestafk"] = $_POST["idpropuestafk"];
    $record["idaspectofk"]   = $_POST["idaspectofk"];
    $record["ipmaquina2"]    = $vSys->getRealIP();
    if ( $vAccion==='Incluir' ){
      $record["fpropuesta"] = "now";
      $record["ipmaquina1"] = $vSys->getRealIP();
    }
    $vReturn['error'] = $vSys->vfRegistrar("dconsulta",$record,"idconsulta=$vId");

  }

?>
