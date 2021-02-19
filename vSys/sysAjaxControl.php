<?php @session_start();

  if($vGrid==='sysAjaxEnviarCorreo'){

$tt = $vSys->correo("asunto","vamdur@gmail.com|jjdjd");
    $vReturn['ejecutar'] .= "alert('envio correo');  alert( $('#sysDoc').data('nombreCompleto') ); ";

    //$vSys = new Sistema();
//    $mensaje =
   // $uu = $vSys->correo("asunto","irosoturale@gmail.com|jjdjd");

  }


  if($vGrid==='sysAjaxFotoPerfil'){
    $vReturn['ejecutar'] .= "vJsPanelRemove();";
    $rst = $vSys->vfSelect("FSELECT * FROM dpersona WHERE idpersona=".$_SESSION['idpersona']);
    if ($rst->foto==='f' || $rst->clave===md5($rst->cedula)){
      $vReturn['ejecutar'] .= "jError('$rst->nombres1|No tiene Permiso para Cambiar su Fotografía.');";
    }else{
      $vReturn['ejecutar'] .= "vfnCamara({idfoto:'$rst->cedula', nombre:'$rst->nombres1 $rst->nombres2', sexo:'$rst->sexo', perfil:true});";
    }
  }

  if($vGrid==='sysAjaxSaime'){

    # Buscar Cedula en Saime
    $rst = $vSys->vfSelect("FSELECT * FROM dsaime WHERE cedula=0".$_POST['mAjax'],"Saime");
    $vReturn['ejecutar'] .= "$('#nacionalidad').val('V');";
    if ( empty($rst->cedula) ) {
      $rst = $vSys->vfSelect("FSELECT * FROM dsaimextranjero WHERE cedula=0".$_POST['mAjax'],"Saime");
      if ( !empty($rst->cedula) ) {
        $vReturn['ejecutar'] .= "$('#nacionalidad').val('E');";
      }
    }

    if ( !empty($rst->cedula) ) {
      $xFN = new DateTime($rst->fecha_nacimiento);
      $xFN = $xFN->format('d-m-Y');
      $vReturn['ejecutar'] .= "$('#apellidos1').val('$rst->primer_apellido');
                               $('#apellidos2').val('$rst->segundo_apellido');
                               $('#nombres1').val('$rst->primer_nombre');
                               $('#nombres2').val('$rst->segundo_nombre');
                               $('#sexo').val('$rst->sexo');
                               $('#login').val('c$rst->cedula');
                               $('#fnacimiento').val('$xFN');";
    }

    //$vReturn['ejecutar'] .= "alert('busco en el Saime');";

  }

  if($vGrid==='sysAjaxSaimeF'){

    # Buscar Cedula en Saime de un Familiar
    $rst = $vSys->vfSelect("FSELECT * FROM dsaime WHERE cedula=0".$_POST['mAjax'],"Saime");
    $vReturn['ejecutar'] .= "$('#fnacionalidad').val('V');";
    if ( empty($rst->cedula) ) {
      $rst = $vSys->vfSelect("FSELECT * FROM dsaimextranjero WHERE cedula=0".$_POST['mAjax'],"Saime");
      if ( !empty($rst->cedula) ) {
        $vReturn['ejecutar'] .= "$('#fnacionalidad').val('E');";
      }
    }

    if ( !empty($rst->cedula) ) {
      $xFN = new DateTime($rst->fecha_nacimiento);
      $xFN = $xFN->format('d-m-Y');
      $vReturn['ejecutar'] .= "$('#fapellidos1').val('$rst->primer_apellido');
                               $('#fapellidos2').val('$rst->segundo_apellido');
                               $('#fnombres1').val('$rst->primer_nombre');
                               $('#fnombres2').val('$rst->segundo_nombre');
                               $('#fsexo').val('$rst->sexo');
                               $('#ffnacimiento').val('$xFN');";
    }

  }

  if ($vGrid==='sysAjaxVideos'){

    // Incluyo en la Tabla Videos/Musica de la Carpeta
    $dir = dirname(__DIR__)."/videos/*.mp?";
    $files = glob($dir);
    foreach ($files as $file){
      $cfile = $file;
      $file  = str_replace(dirname(__DIR__).'/videos/','',$file);
      $rst = $vSys->vfSelect("FSELECT nvideo FROM vvideo WHERE nvideo='$file'");
      if (!$rst->nvideo){
        $vSys->vfSelect("INSERT INTO vvideo ( nvideo, idpersona1 ) VALUES ('$file','".$_SESSION['idpersona']."');");
      }
    }

    // Borro los Nombres de Videos/Music que No existen en la Carpeta
    $rst = $vSys->vfSelect("SELECT nvideo FROM vvideo ORDER BY nvideo");
    while ( $o = $rst->FetchNextObject() ) {
      if ( !file_exists( dirname(__DIR__)."/videos/$o->nvideo") ){
        $vSys->vfSelect("DELETE FROM vvideo WHERE nvideo='$o->nvideo'");
      }
    }

  }

  if ($vGrid==='sysAjaxUsuarioActivo'){

    $idVar   = $_POST['mAjax']["idVar"];
    $idValor = $_POST['mAjax']["idValor"];

    $vReturn['ejecutar'] .= "$('#$idVar').prop('disabled',false);
                             $('#$idVar option').remove();
                             $('#$idVar').append('<option value=\'\'>Seleccionar</option>');";
    $rst = $vSys->vfSelect("SELECT idpersona AS vi, nombres1 || ' ' || apellidos1 AS vd FROM dpersona INNER JOIN vusuario ON vusuario.idusuario=dpersona.idpersona WHERE vusuario.activo ORDER BY nombres1,apellidos1");
    while ( $o = $rst->FetchNextObject() ) {
      $vReturn['ejecutar'] .= "$('#$idVar').append('<option value=$o->vi>$o->vd</option>');";
     if ($o->vi===$idValor) $vReturn['ejecutar'] .= $vReturn['ejecutar'] .= "$('#$idVar').val('$idValor');";
    }

  }elseif ($vGrid==='sysAjaxBuscarPersonaUsuario'){

    $cedula = $_POST['mAjax']["cedula"];
    $vReturn['ejecutar'] .= "$('#usuario').val('');";

    $rst = $vSys->vfSelect("FSELECT idpersona, apellidos1, nombres1 FROM dpersona WHERE cedula=$cedula");
    if ( !$rst->idpersona ){
      $vReturn['ejecutar'] .= "$('#usuario').attr('placeholder','No Existen los Datos Personales');";
    }else{
      $vReturn['ejecutar'] .= "$('#usuario').val('$rst->apellidos1 $rst->nombres1');";
      $vReturn['ejecutar'] .= "$('#idusuario').val($rst->idpersona);";
    }

  }elseif ($vGrid==='sysAjaxBuscarUsuario'){

    $cedula = $_POST['mAjax']["cedula"];
    $vReturn['ejecutar'] .= "$('#usuario,#idusuariofk').val('');";

    $rst = $vSys->vfSelect("FSELECT vusuario.idusuario, vusuario.usuario FROM vusuario LEFT JOIN dpersona ON dpersona.idpersona=vusuario.idusuario WHERE dpersona.cedula=$cedula");
    if ( !$rst->idusuario ){
      $vReturn['ejecutar'] .= "$('#usuario').attr('placeholder','No Existe');";
    }else{
      $vReturn['ejecutar'] .= "$('#idusuariofk').val($rst->idusuario); $('#usuario').val('$rst->usuario');";
    }


  }elseif ($vGrid==='sysAjaxBuscarPersona'){


    $cedula = $_POST['mAjax']["cedula"];

    $rst = $vSys->vfSelect("FSELECT * FROM dpersona WHERE cedula=$cedula");

    if ( !$rst->idpersona ){

      $rst = $vSys->vfSelect("FSELECT * FROM dsaime WHERE cedula=$cedula",'Saime');
      $vReturn['ejecutar'] .= "
        vfnGridErrorFormulario('Favor Completar los Datos');
        $('#sData').show();
        //$('#Personas').vfnDisabled('*',true);
        $('#nombres1').val('$rst->primer_nombre');
        $('#nombres2').val('$rst->segundo_nombre');
        $('#apellidos1').val('$rst->primer_apellido');
        $('#apellidos2').val('$rst->segundo_apellido');
        $('#fnacimiento').val('$rst->fecha_nacimiento');
        $('#sexo').val('$rst->sexo');
        $('#login').val('$cedula');
        $('#vid').val('0');
      ";

    }else{
      $vReturn['ejecutar'] .= "
        vfnGridErrorFormulario('La Persona está REGISTRADA.');
        $('#Personas').vfnEnabled('*',false);
        vfnSetDisabled('cedula',false);
        $('#sData').hide();
        $('#apellidos1').val('$rst->apellidos1');
        $('#apellidos2').val('$rst->apellidos2');
        $('#nombres1').val('$rst->nombres1');
        $('#nombres2').val('$rst->nombres2');
        $('#sexo').val('$rst->sexo');
        $('#fnacimiento').val('$rst->fnacimiento');
        $('#login').val('$rst->login');
        $('#correo').val('$rst->correo');
        $('#vid').val('$rst->idpersona');
      ";
    }


  }elseif($vGrid==='sysAjaxFechaDesdeHasta'){

    $_SESSION['fdesde'] = $_POST['mAjax']['fdesde'];
    $_SESSION['fhasta'] = $_POST['mAjax']['fhasta'];

   // $vReturn['ejecutar'] .= "alert('desde ".$_POST['mAjax']['fdesde'].$_SESSION['fdesde']."');";

  }elseif ($vGrid==='sysAjaxIniciarSesion'){
    /*
    <!--
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
-->
    */

    $vDirSys = $_SESSION['vDirSys'];

     if ($vDirSys==='sysSigefor') {
      $vReturn['ejecutar'] .= "vfnPetro();";
    }

    $vReturn['ejecutar'] .= "
      $('#sysSistema').data('skin-jqgrid-btn','".$vSysConfig['sysSkinJqGridBtn']."');
      $('#sysSistema').data('skin-frm','".$vSysConfig['sysSkinFrm']."');
      $('#sysSistema').data('skin-frm-btn','".$vSysConfig['sysSkinFrmBtn']."');
      $('#sysSistema').data('skin-ayuda','".$vSysConfig['sysSkinAyuda']."');
      $('#sysSistema').data('skin-panel','".$vSysConfig['sysSkinPanel']."');
      $('#sysUsuario').data('externo','false');
      $('#imgTransparente').attr('title','® ".strrev('.etrauD oisorbmA')."');
      $('#mnuIcoCerrar').hide();
      //$('#codigoBuscar').on('cut copy paste',function(e) { e.preventDefault(); });
    ";

    if ( $_SESSION['desktop']!=='desktop'){
      // Si inicio con un Movil o una Tablet
      $vReturn['ejecutar'] .= "
        $('#inicioSysNombre').html('".Sistema::$vSysNombre2."').prop('title','".Sistema::$vSysNombre."');
        $('#inicioBody').addClass('sidebar-collapse').removeClass('sidebar-open');
        $('#mnuIcoMenu').show();
        $('#mnuIcoCerrar').remove();
      ";
    }else{
      // Si Inicio en un Computadora
      $vReturn['ejecutar'] .= "vfnVentanasEmergentes();";
    }

    if($_SESSION['idpersona']===0){
      $vReturn['ejecutar'] .= "vfnF5();";
      $vReturn['ejecutar'] .= "vfnCargar('vSys/vLoginSesionIniciar.php');";

      if (file_exists("../$vDirSys/mnuPublico.php")){
        $vReturn['ejecutar'] .= "vfnCargarMenu('$vDirSys/mnuPublico.php');";
      }

      if (file_exists("../$vDirSys/$vDirSys"."Inicio.php")){
        require_once("../$vDirSys/$vDirSys"."Inicio.php");
      //}else{
      //  $vReturn['ejecutar'] .= "vfnCargar('vSys/vLoginSesionIniciar.php');";
      }

    }else{
      $vReturn['ejecutar'] .= "vfnCargarMenu('$vDirSys');
        $('#sysUsuario').show().attr('onclick','').prop('title','Usuario Logueado');
        $('#inicioBuscar').show().prop({hidden:true});
      ";
    }



  }elseif ($vGrid==='sysAjaxNavegador'){

    $vReturn['ejecutar'] .= "
      vfnF5();
      $('.sidebar, .ml-auto, #mnuIcoMenu').remove();
      $('#inicioContenido').show();
      $('#inicioBody').off('onload');
      vfnPermiso({tf:false,modal:false,msg:'Navegador|Sistema Diseñado para <b><br><i>Mozilla Firefox (v65+)</i></b> o <b>Google Chrome</b>.', img:'vSys/imagenes/mozilla.png' });
      $('#inicioImagen').addClass('elevation-5').addClass('img-circle');
    ";


  }

  if ($vGrid==='ajaxTalCosa'){

    // Ejemplo de como traer el DataGrid y No Buscar en la Base de Datos

    /* En el Grid
      var id = $('#guias').jqGrid('getGridParam','selrow');
      var rD = $('#guias').jqGrid("getRowData",id);
      vfnAjax( 'ajaxTalCosa', {idp:id, vDGrid:rD} );
    */

    // Despues aqui Hago Esto
    $id  = $_POST['mAjax']['idp'];
    $rst = $_POST['mAjax']['vDGrid'];

    $rif = $rst['rif'];

  }

  if ($vGrid==='sysAjaxActualizarTablas'){
    $vSys->vfVacuum('dpersona');       $vSys->vfSequence('dpersona');
    $vSys->vfVacuum('vbar');           $vSys->vfSequence('vbar');
    $vSys->vfVacuum('vbitacora');      $vSys->vfSequence('vbitacora');
    $vSys->vfVacuum('vformulario');    $vSys->vfSequence('vformulario');
    $vSys->vfVacuum('vips');           $vSys->vfSequence('vips');
    $vSys->vfVacuum('vrol');           $vSys->vfSequence('vrol');
    $vSys->vfVacuum('vrolformulario'); $vSys->vfSequence('vrolformulario');
    $vSys->vfVacuum('vrolusuario');    $vSys->vfSequence('vrolusuario');
    $vSys->vfVacuum('vtablas');        $vSys->vfSequence('vtablas');
    $vSys->vfVacuum('vtablas2');       $vSys->vfSequence('vtablas2');
    $vSys->vfVacuum('vvideo');         $vSys->vfSequence('vvideo');
    $vSys->vfVacuum('npais');          $vSys->vfSequence('npais');
    $vSys->vfVacuum('nestado');        $vSys->vfSequence('nestado');
    $vSys->vfVacuum('nmunicipio');     $vSys->vfSequence('nmunicipio');
    $vSys->vfVacuum('nparroquia');     $vSys->vfSequence('nparroquia');
    $vReturn['ejecutar'] .= "vJsMsg({msgC:'center',msg:'Actualizadas las Tablas de Configuración del Sistema.<br>'});";
  }

?>
