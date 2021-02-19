<?php @session_start();

  if ($vGrid==='ajaxActualizarTablas'){
    $vSys->vfVacuumSequence('dconsulta');
    $vReturn['ejecutar'] .= "vJsMsg({msgC:'center',msg:'Actualizadas las Tablas del Sistema.<br>'});";
  }

  if ($vGrid==='ajaxBuscarLogin'){

    $login = $_POST['mAjax']["login"];

    $vReturn['ejecutar'] .= "vfnGridFrmError('');";
    $rst = $vSys->vfSelect("FSELECT * FROM dpersona WHERE cedula::text='$login'");
    if ( !$rst->idpersona ){
      $rst = $vSys->vfSelect("FSELECT * FROM dpersona WHERE login='$login'");
      if ( !$rst->idpersona ){
        $rst = $vSys->vfSelect("FSELECT * FROM dpersona WHERE correo='$login'");
        if ( !$rst->idpersona ){
          $rst = $vSys->vfSelect("FSELECT * FROM dpersona WHERE idpersona::text='$login'");
        }
      }
    }

    if ( !$rst->idpersona ){
      $vReturn['ejecutar'] .= "vfnGridFrmError('El Usuario no existe en la Base de Datos.');";
    }else{
      $vReturn['ejecutar'] .= "$('#usuario').val('$rst->nombres1 $rst->apellidos1');";
      $vReturn['ejecutar'] .= "$('#pregunta').val('$rst->pregunta');";
      $vReturn['ejecutar'] .= "vfnGridTrHide('login');";
      $vReturn['ejecutar'] .= "vfnGridTrHide('pregunta,respuesta',false);";
      $vReturn['ejecutar'] .= "$('#sData').show(); ";
      $vReturn['ejecutar'] .= "$('#respuesta').focus(); ";
    }

  }

  if ($vGrid==='ajaxBuscarRegistro'){

    $cedula = $_POST['mAjax']["cedula"];
    $vReturn['ejecutar'] .= "vfnGridFrmError('');";

    $rst = $vSys->vfSelect("FSELECT * FROM dpersona WHERE cedula=$cedula");
    if ( !$rst->idpersona ){
      $vReturn['ejecutar'] .= "$('#vlogin').vfnEnabled('*');";
      $vReturn['ejecutar'] .= "$('#cedula').vfnEnabled(false);";
      $vReturn['ejecutar'] .= "$('#apellidos1').focus();";
      $vReturn['ejecutar'] .= "$('#sData').show();";
      $vReturn['ejecutar'] .= "$('#idparroquiafk').chosen({});";

      $vReturn['ejecutar'] .= "vfnGridFrmError('El Usuario no existe en Nuestra Base de Datos.<br>Complete la Información Requerida para su Registro.');";
      # Buscar Cedula en Saime
      $rst = $vSys->vfSelect("FSELECT * FROM dsaime WHERE cedula=$cedula","Saime");
      if ( !empty($rst->cedula) ) {
        $fn = new DateTime($rst->fecha_nacimiento);
        $fn = $fn->format('d-m-Y');
        $vReturn['ejecutar'] .= "$('#apellidos1').val('$rst->primer_apellido');
                                 $('#apellidos2').val('$rst->segundo_apellido');
                                 $('#nombres1').val('$rst->primer_nombre');
                                 $('#nombres2').val('$rst->segundo_nombre');
                                 $('#sexo').val('$rst->sexo');
                                 $('#fnacimiento').val('$fn');";
      }
    }else{
      $vReturn['ejecutar'] .= "vfnGridFrmError('El Usuario está Registrado en Nuestra Base de Datos.');";

      $vReturn['ejecutar'] .= "$('#apellidos1').val('$rst->apellidos1');
                               $('#apellidos2').val('$rst->apellidos2');
                               $('#nombres1').val('$rst->nombres1');
                               $('#nombres2').val('$rst->nombres2');";
      $vReturn['ejecutar'] .= "vfnGridTrRemove('ciudad,sexo,fnacimiento,celular,direccion,institucion,idparroquiafk,correo,password,pregunta');";
      $vReturn['ejecutar'] .= "$('#vlogin').vfnEnabled('*',false);";
      $vReturn['ejecutar'] .= "$('#editmodvlogin').css({'width':'370px'});";
    }

  }

?>
