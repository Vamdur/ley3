<?php @session_start();
  class Conexion{

    public static $vSysNombre       = "Plan de Ordenamiento y Reglamento de Uso de la Zona Protectora Mitar Nakichenovich";
    public static $vSysNombreCorreo = "Plan de Ordenamiento y Reglamento de Uso de la Zona Protectora Mitar Nakichenovich";
    public static $vSysNombre2      = "Consulta Pública";
    public static $vSysNombreCorto  = "MINEC";
    public static $vSysPiePagina   = "<div class='col-xs-1 text-right'><img src='vSys/img/bandera.gif' style='width:80px;height:50px'></div><div class='col-xs-8'>Gobierno <b>Bolivariano</b> de Venezuela. <br><strong><i class='fa fa-copyright'></i> Ministerio del Poder Popular para el Ecosocialismo.</strong><br><small>® Oficina de Tecnología de la Información y la Comunicación.</small><img src='vSys/img/transparente.png' style='width:10px;height:10px' title='® Ambrosio Duarte.'></small></div>";

    public static $vSysEsquemas    = "public,vsistema";

    # Local
    public $vSysConexion = array(
      array('dbNombre'=>'vconsulta_ley'),
      array('dbNombre'=>'vsaime',  'dbAlias'=>'Saime')
    );

    # Produccion
    public $vSysConexionP = array(
      array('dbServidor'=>'xx.xx.x.xxx', 'dbNombre'=>'vconsulta_ley', 'dbClave'=>'postgres' ),
      array('dbServidor'=>'xx.xx.x.xxx', 'dbNombre'=>'vsaime',        'dbClave'=>'postgres', 'dbAlias'=>'Saime')
    );

    function __construct(){
    }

  }
?>
