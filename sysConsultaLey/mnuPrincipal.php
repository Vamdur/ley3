<?php @session_start();

  require_once("../vSys/vfnSession.php");
  $html  = "";

  if ($_SESSION['idpersona']>1){
    $html .= "vfnCrearMenu({titulo:'Mis Propuestas', id:'mnuPublicoMisPropuestas', icono:'file-text-o', onclick:'sysConsultaLey/vMisPropuestas.php', tf:'1'});";

    $p[1]  = Sistema::vfnPermiso('Propuestas','1');
    $html .= "vfnCrearMenu({titulo:'Propuestas', id:'mnuPrivadoPropuestas', icono:'file-text-o', onclick:'sysConsultaLey/vPropuestas.php', tf:'$p[1]'});";
  }

  $html .= "vfnCrearMenu({titulo:'Descargas',  id:'mnuDescargas', clase:'menu', icono:'download', tf:'1'});";

  $item  = "<li id='mnuPublico01' class='nav-item'><a href='sysConsultaLey/docs/convocatoria.pdf' download target='_blank' class='nav-link'> <i class='fa fa-file-pdf-o nav-icon'></i><p>Convocatoria</p><small class='badge badge-danger pull-right'></small></a></li>";
  $item .= "<li id='mnuPublico02' class='nav-item'><a href='sysConsultaLey/docs/resumen_ejecutivo.pdf' download target='_blank' class='nav-link'><i class='fa fa-file-pdf-o nav-icon'></i><p>Resumen Ejecutivo</p><small class='badge badge-danger pull-right'></small></a></li>";
  $item .= "<li id='mnuPublico03' class='nav-item'><a href='sysConsultaLey/docs/decreto.pdf' download target='_blank' class='nav-link'><i class='fa fa-file-pdf-o nav-icon'></i><p>Decreto</p><small class='badge badge-danger pull-right'></small></a></li>";
  $item .= "<li id='mnuPublico04' class='nav-item'><a href='sysConsultaLey/docs/mapa_asignacion.pdf' download target='_blank' class='nav-link'><i class='fa fa-file-pdf-o nav-icon'></i><p>Mapa de Asignación de Uso</p><small class='badge badge-danger pull-right'></small></a></li>";
  $item .= "<li id='mnuPublico05' class='nav-item'><a href='sysConsultaLey/docs/documento_tecnico.pdf' download target='_blank' class='nav-link'><i class='fa fa-file-pdf-o nav-icon'></i><p>Documento Técnico</p><small class='badge badge-danger pull-right'></small></a></li>";
  $item .= "<li id='mnuPublico06' class='nav-item'><a href='sysConsultaLey/docs/mapa_soporte.pdf' download target='_blank' class='nav-link'><i class='fa fa-file-pdf-o nav-icon'></i><p>Mapa de Soporte</p><small class='badge badge-danger pull-right'></small></a></li>";

  $html .= "$('#inicioMenu>#mnuDescargas>ul').append(\"$item\"); $('#mnuMiSesionPerfil1').hide(); ";

  if ($_SESSION['idpersona']>1){
    //$p[2] = Sistema::vfnPermiso('sysGeografia','1');
   // $html .= "vfnCrearMenu({titulo:'Geografía', id:'mnuPrivadoConfig12', icono:'globe', onclick:'vSys/sysGeografia.php', tf:'$p[2]'});";

    $p[3]  = Sistema::vfnPermiso('Sistema','1');
    $html .= "vfnCrearMenu({titulo:'Sistema', id:'mnuPrivadoConfig2', icono:'gears', onclick:'vSys/sysConfigurar.php', tf:'$p[3]'});";
  }

  echo "<script>$html</script>";

?>
