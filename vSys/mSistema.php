<?php session_start();
  set_include_path(join(PATH_SEPARATOR,$_SESSION['path']));
  require_once('baseDatos.php');

class Sistema extends BaseDatos{
  public static $nombreArchivo = "";

  // http://blog.deservidores.com/inyeccion-de-codigo-sql-para-hackear-tu-web-o-servidor/
//update dtmp_bcv set nombres = regexp_replace(nombres, 'A', 'a', 'g');
  function __construct() { }

  public function SistemaIni(){
    @session_start();
    $vSys = new Sistema();
    $vSys->Conectar();
    if ($vSys->dbDriver==="postgres"){
      $sPath = $vSys->vfSelect("FSELECT reset_val FROM pg_settings WHERE name='search_path'");
      //$hh = $vSys->vfSelect("show search_path") ; // Sirve Con esto Tambien
      $esquemas = str_replace(" ","",Sistema::$vSysEsquemas);
      $esquemas = str_replace("~",",",$esquemas);
      $esquemas2 = str_replace(" ","",$sPath->reset_val);
      if ($esquemas!==$esquemas2){
        $vSys->vfSelect("ALTER DATABASE ".$vSys->dbNombre." SET search_path = $esquemas;");
      }
    }


    $tmp = dirname(__DIR__).'/tmp/*.*';
    foreach(glob($tmp) as $file) {
      if ( date('d/m/Y',filemtime($file)) !== date('d/m/Y') ){
        @unlink($file);
      }
    }

    //https://docs.w3cub.com/php/function.ini-get-all/
    /*
    if (!version_compare(phpversion(),'5.5.9','>=')){
      echo "La aplicación para ejecutarse correctamente, necesita de una versión de PHP igual y/o superior a: <b>5.5.9</b><br><br>Instalada en su Servidor: <b>".PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION.'.'.PHP_RELEASE_VERSION."</b>\n</html>";die();
    }

    $msg  = '';
    if (!extension_loaded('curl'))      { $msg .= 'curl, '; }
    if (!extension_loaded('gd'))        { $msg .= 'gd, '; }
    if (!extension_loaded('json'))      { $msg .= 'json, '; }
    if (!extension_loaded('libxml'))    { $msg .= 'libxml, '; }

    if (!extension_loaded('PDO'))       { $msg .= 'PDO, '; }
    if (!extension_loaded('pdo_mysql')) { $msg .= 'pdo_mysql, '; }
    if (!extension_loaded('pdo_pgsql')) { $msg .= 'pdo_pgsql, '; }
    if (!extension_loaded('pgsql'))     { $msg .= 'pgsql, '; }
    //if (!extension_loaded('mysql'))     { $msg .= 'mysql, '; }
    if (!extension_loaded('mysqli'))    { $msg .= 'mysqli, '; }

    if (!extension_loaded('session'))   { $msg .= 'session, '; }
    if (!extension_loaded('SimpleXML')) { $msg .= 'SimpleXML, '; }
    if (!extension_loaded('soap'))      { $msg .= 'soap, '; }
    if (!extension_loaded('standard'))  { $msg .= 'standard, '; }

    if (!extension_loaded('xml'))       { $msg .= 'xml, '; }
    if (!extension_loaded('xmlreader')) { $msg .= 'xmlreader, '; }
    if (!extension_loaded('xmlwriter')) { $msg .= 'xmlwriter, '; }
    //if (!extension_loaded('zip'))       { $msg .= 'zip, '; }
    if (!extension_loaded('zlib'))      { $msg .= 'zlib, '; }

    if ($msg!==''){
      echo "Instalar Extensión(es) en PHP: ".substr($msg,0,-2).".\n</html>";die();
    };
    */
    return;
  }

  // Variables del Sistema
  public function varSistema(){
    @session_start();
    $vSys = new Sistema();
    $archivo3['UnaVainaLoca'] = 7;
    $rstComun = $vSys->vfSelect("SELECT * FROM vcomun");
    while ($o=$rstComun->FetchNextObject()) {
      $archivo3["$o->comun"] = trim($o->descripcion);
    }
    $archivo1 = parse_ini_file($_SESSION['vDirServer']."/conexion/config.php",false);
    $archivo2 = parse_ini_file($_SESSION['vDirRoot']."/vSys/config.php",false);
    $archivo1 = array_merge($archivo2,$archivo1,$archivo3);
    return $archivo1;
  }




  // Para las Clases
  public function SistemaClase($vClase='persona', $id='0', $id2='0', $id3='0'){
    @session_start();
    $vSys = new Sistema();
    $vClase = strtolower($vClase);
    $sql    = "SELECT *, vfnedad(fnacimiento,current_date) AS vedad FROM dpersona WHERE idpersona=$id";
    include($_SESSION['vDirSys']."Clase.php");
    $rstClase = $vSys->vfSelect("F$sql");
    return $rstClase;
  }

  public function vfQR($codigo,$url=''){
    /* http://phpqrcode.sourceforge.net/examples/index.php?example=203

    Como Usar para Crear Codigos QR
      Sistema::vfQR('12345678','http://minea.gob.ve?cedula=');
      Sistema::vfQR('12345678');

      al Retornar
      echo "<img src='tmp/$codigo'/>";
      echo "<img src='".Sistema::vfQR('12345678')."'/>";
    */
    include_once('qrlib.php');
    $tmp = "../tmp/";
    $url = $url.$codigo;
    $archivo = $tmp.$codigo.'.png';
    //@unlink($aTmp2);
    QRcode::png($url,$archivo,'H',4,2);
    chmod($archivo,0777);
    return "$archivo";
  }


  public function cutNum($num, $precision=2) {
    /*
    echo Sistema::cutNum("5,6789.00");     //returns 5.67 (default precision is two decimals)
echo"<br>";
echo Sistema::cutNum("5.6789,00");     //returns 5.67 (default precision is two decimals)
echo"<br>";
echo Sistema::cutNum("56789,00");     //returns 5.67 (default precision is two decimals)
echo"<br>";
echo Sistema::cutNum("56789.00");     //returns 5.67 (default precision is two decimals)
echo"<br>";
echo Sistema::cutNum("5.6789", 3);  //returns 5.678
echo"<br>";
echo Sistema::cutNum("5.6789", 10); //returns 5.6789
echo"<br>";
echo Sistema::cutNum("5.6789", 0);
die();
    */
    return floor($num) . substr(str_replace(floor($num), '', $num), 0, $precision + 1);
  }

  public function vfnBarSum($cuantos) {
    @session_start();
    $vSys = new Sistema();
    $vSys->vfSelect("UPDATE vbar SET fpersona2=now(), ejecutado=ejecutado+$cuantos WHERE idpersona1=".$_SESSION['idpersona']);
    return ;
  }

  // Sumar Dias a una Fecha
  public function vfFecha($getFecha,$dia){
    $getFecha .= '';
    list($day,$mon,$year) = explode('/',$getFecha);
    return date('d/m/Y',mktime(0,0,0,$mon,$day+$dia,$year));
  }

  /**
   * The function is_date() validates the date and returns true or false
   * @param $str sting expected valid date format
   * @return bool returns true if the supplied parameter is a valid date
   * otherwise false
   */
  public function is_date( $str ) {
      try {
          $dt = new DateTime( trim($str) );
      }
      catch( Exception $e ) {
          return false;
      }
      $month = $dt->format('m');
      $day   = $dt->format('d');
      $year  = $dt->format('Y');
      if( checkdate($month, $day, $year) ) {
          return true;
      }
      else {
          return false;
      }
  }

  // Calcular la Edad a la Fecha Actual
  public function vfnCalculaEdad( $fecha, $hoyEs='' ) {
    //https://es.wikibooks.org/wiki/Programaci%C3%B3n_en_PHP/Ejemplos/Calcular_edad
    if ($hoyEs==='') $hoyEs = date("d/m/Y",time());
    $fecha = str_replace("-","/",$fecha);
    $hoyEs = str_replace("-","/",$hoyEs);
    if (strpos($fecha,"/")===4) $fecha = date_format(date_create_from_format('Y/m/d',$fecha),'d/m/Y');
    if (strpos($hoyEs,"/")===4) $hoyEs = date_format(date_create_from_format('Y/m/d',$hoyEs),'d/m/Y');
    list($d,$m,$Y)    = explode("/",$fecha);
    list($d2,$m2,$Y2) = explode("/",$hoyEs);
    $edad = $m2.$d2 < $m.$d ? $Y2-$Y-1 : $Y2-$Y ;
    return($edad);
  }

  // Buscar la Descripcion de la Tabla Comun y vTablas2
  public function vfBuscarComun( $idcodigo, $donde='vcomun'){
    @session_start();
    // Obsoleta
    return "";
  }

  // Para los ComboBox.
  public function SistemaCbo($cbo, $id='', $id2='', $id3=''){
    @session_start();
    require_once("mSistema.php");
    $vSys = new Sistema();
    $cbo  = strtolower($cbo);
    $rtco = '":Seleccionar"';
    $rSQL = '';

    if (intval($cbo)!==0){
      // Para los Combos que vienen de vTablas2
      if ($id===''){
        $rSQL = "SELECT idtexto, descripcion  FROM vtablas2 WHERE idtipofk=$cbo AND NOT re ORDER BY orden, descripcion";
      }else{
        $rSQL = "SELECT idcodigo, descripcion FROM vtablas2 WHERE idtipofk=$cbo AND NOT re ORDER BY orden, descripcion";
      }
    }elseif ($cbo==='idpersona'){
      $rtco = $vSys->vfComboBoxGrid("SELECT idpersona AS vi, dpersona.nombres1 || ' ' || dpersona.apellidos1 AS vd FROM dpersona ORDER BY nombres1,apellidos1");
    }elseif ($cbo==='idusuario'){
      $rtco = $vSys->vfComboBoxGrid("SELECT idpersona AS vi, dpersona.apellidos1 || ' ' || dpersona.nombres1 AS vd FROM dpersona ORDER BY apellidos1,nombres1");
    }elseif ($cbo==='idpais'){
      $rtco = $vSys->vfComboBoxGrid("SELECT idpais as vi, pais as vd FROM npais ORDER BY pais");
    }elseif ($cbo==='idpais_todos'){
      $rtco = $vSys->vfComboBoxGrid("SELECT idpais as vi, pais as vd FROM npais ORDER BY pais");
      $rtco = str_replace(":Seleccionar;","Todos:Todos;0:Ninguno;",$rtco);
    }elseif ($cbo==='idestado'){
      $rtco = $vSys->vfComboBoxGrid("SELECT idestado as vi, estado as vd FROM nestado WHERE idpaisfk=1 ORDER BY estado");
    }elseif ($cbo==='idestado_todos'){
      $rtco = $vSys->vfComboBoxGrid("SELECT idestado as vi, estado as vd FROM nestado WHERE idpaisfk=1 ORDER BY estado");
      $rtco = str_replace(":Seleccionar;","Todos:Todos;0:Ninguno;",$rtco);
    }elseif ($cbo==='idmunicipio'){
      $rtco = $vSys->vfComboBoxGrid("SELECT idmunicipio as vi, municipio as vd FROM nmunicipio ORDER BY idestadofk, municipio");
    }elseif ($cbo==='idparroquia'){
      $rtco = $vSys->vfComboBoxGrid("SELECT idparroquia as vi, parroquia as vd FROM nparroquia ORDER BY idmunicipiofk, parroquia");
    }elseif ($cbo==='idciudad'){
      $rtco = $vSys->vfComboBoxGrid("SELECT idciudad as vi, ciudad as vd FROM nciudad ORDER BY idestadofk, ciudad");
    }elseif ($cbo==='idemp'){
      // Estado - Municipio - Parroquia de Venezuela Solamente
      $rtco = $vSys->vfComboBoxGrid("SELECT idparroquia, estado || ' - ' || municipio || ' - ' || parroquia as vd FROM nparroquia INNER JOIN nmunicipio ON nmunicipio.idmunicipio=nparroquia.idmunicipiofk INNER JOIN nestado ON nestado.idestado=nmunicipio.idestadofk WHERE nestado.idpaisfk=1 ORDER BY estado, municipio, parroquia");
    }elseif ($cbo==='idpemp'){
      // Pais - Estado - Municipio - Parroquia
      $rtco = $vSys->vfComboBoxGrid("
        SELECT idparroquia, pais || ' - ' || estado || ' - ' || municipio || ' - ' || parroquia as vd,  pais,estado, municipio, parroquia
          FROM nparroquia INNER JOIN nmunicipio ON nmunicipio.idmunicipio=nparroquia.idmunicipiofk
          INNER JOIN nestado ON nestado.idestado=nmunicipio.idestadofk
          INNER JOIN npais ON npais.idpais=nestado.idpaisfk
          WHERE idpais=1
        UNION  ALL
        SELECT idparroquia, parroquia as vd, pais,estado, municipio, parroquia
          FROM nparroquia INNER JOIN nmunicipio ON nmunicipio.idmunicipio=nparroquia.idmunicipiofk
          INNER JOIN nestado ON nestado.idestado=nmunicipio.idestadofk
          INNER JOIN npais ON npais.idpais=nestado.idpaisfk
          WHERE idpais<>1
        ORDER BY pais, estado, municipio, parroquia"
      );

    }elseif ($cbo==='sexo'){
      $rtco = '":Seleccionar;M:Masculino;F:Femenino"';
    }elseif ($cbo==='diasemana'){
      $rtco = '"1:Lunes;2:Martes;3:Miércoles;4:Jueves;5:Viernes;6:Sábado;0:Domingo"';
    }elseif ($cbo==='nacionalidad'){
      $rtco = '"V:V;E:E"';
    }elseif ($cbo==='edocivil'){
      $rtco = '"S:Soltero;C:Casado;O:Concubino;D:Divorciado;V:Viudo"';
    }elseif ($cbo==='idrol'){
      $rSQL = "SELECT idrol, rol FROM vrol ORDER BY rol";
    }elseif ($cbo==='idformulario'){
      $rSQL = "SELECT idformulario, descripcion FROM vformulario ORDER BY descripcion";
    }

    //if ( file_exists($_SESSION['vDirSys']."/".$_SESSION['vDirSys']."Cbo.php") ){
    if ( include_once($_SESSION['vDirSys']."Cbo.php")){
      include_once($_SESSION['vDirSys']."Cbo.php");
    }

    if ($rSQL!==''){
      $rtco = $vSys->vfComboBoxGrid($rSQL);
    }
    return $rtco;

  }

  // Para Generar Combos para el jqGrid
  public function vfComboBoxGrid( $tabla, $largo=200){
    $vSys = new Sistema();
    $rst = $vSys->vfSelect($tabla);
    $seleccion = '":Seleccionar';

    /*
      Antes y Funciona Tambien
      $rst = $vSys->vfSelect("SELECT idtexto  as vi, descripcion as vd FROM vtablas2 WHERE idtipofk=$id AND NOT re ORDER BY orden, descripcion");

      foreach($rst as $indice=>$valor){
        $descripcion = $vSys->vEncode($valor["vd"]);
        $descripcion = str_replace(':','',$descripcion);
        $descripcion = substr($descripcion,0,$largo);
        $seleccion .= ";".$valor["vi"].":".trim($descripcion);
      }
    */
    while (!$rst->EOF) {
      $field1 = $rst->FetchField(0);
      $field2 = $rst->FetchField(1);
      $descripcion = trim($vSys->vEncode( $rst->fields[$field2->name] ));
      $descripcion = str_replace(':','',$descripcion);
      $descripcion = str_replace(';','',$descripcion);
      //$descripcion = substr($descripcion,0,$largo);
      $seleccion .= ";".$rst->fields[$field1->name].":".$descripcion;
      $rst->MoveNext();
    }

    $seleccion .= '"';
    return $seleccion ;
  }

  // Son las Misma Pero queda esta para el Futuro
  public function vfnComboUsuario( $tabla, $id='1',$alias=''){
    $vSys = new Sistema();
    $vsql = "SELECT $tabla.idpersona$id AS vi,
            xdp.apellidos1 || ' ' || xdp.nombres1 AS vd
            FROM $tabla
            INNER JOIN dpersona AS xdp ON xdp.idpersona=$tabla.idpersona$id
            GROUP BY $tabla.idpersona$id, xdp.apellidos1, xdp.nombres1
            ORDER BY xdp.apellidos1,xdp.nombres1";

    $rst = $vSys->vfSelect($vsql,$alias);
    $seleccion = '":Seleccionar';
    foreach($rst as $indice=>$valor){
      $descripcion = $vSys->vEncode($valor["vd"]);
      $descripcion = str_replace(':','',$descripcion);
      $descripcion = str_replace(';','',$descripcion);
      $descripcion = substr($descripcion,0,100);
      $seleccion .= ";".$valor["vi"].":".trim($descripcion);
    }
    $seleccion .= '"';
    return $seleccion ;
  }

  public function SistemaCboUsuario( $tabla, $id='1',$largo=100){
    $seleccion = '":Quitar esto Obsoleta SistemaCboUsuario"';
    return $seleccion ;
  }


  public function vfnPermiso($pFormulario, $soloChequeo='') {
    @session_start();
    $vSys = new Sistema();
    $pFormulario = trim(strtolower($pFormulario));
    $rst = $vSys->vfSelect("SELECT formulario FROM vformulario WHERE formulario='$pFormulario'");
    if ( $rst->EOF && $pFormulario!=='miperfil' ) {
      if ($pFormulario!=='') {
        $vSys->vfSelect("INSERT INTO vformulario (formulario,descripcion) VALUES('$pFormulario','* $pFormulario')");
      }
    }
    $elUsuarioActivo   = $_SESSION['idpersona'];
    $vf = array();
    $vf['id']          = $elUsuarioActivo;
    $vf['entrar']      = false;
    $vf['incluir']     = false;
    $vf['editar']      = false;
    $vf['eliminar']    = false;
    $vf['borrar']      = false;
    $vf['imprimir']    = false;
    $vf['procesar']    = false;
    $vf['administrar'] = false;
    $vf['autenticado'] = $_SESSION['autenticado'];
    $vf['mt']          = false;
    $vf['su']          = false;
    $vf['pb']          = true;
    $vf['fb']          = false;
    $vf['aviso']       = '';

    $rstPersona = $vSys->vfSelect("FSELECT dpersona.cedula, dpersona.clave, dpersona.login, vusuario.clave2 FROM dpersona LEFT JOIN vusuario ON dpersona.idpersona=vusuario.idusuario WHERE dpersona.idpersona=$elUsuarioActivo");
    if ( $rstPersona->login ) {
      if ( $rstPersona->clave===md5("$rstPersona->cedula") ) { $vf['pb'] = false;}
      if ( $_SESSION['autenticado'] && $rstPersona->clave2==="261a7d80916532797f8735dd198d4ada" ) { $vf['su'] = true; }
    }

    if ( $vf['autenticado'] && !$vf['su'] ) {

      $sql = "SELECT vrolformulario.*, vformulario.mt, vformulario.fb
              FROM vrolformulario
              INNER JOIN vformulario ON vformulario.idformulario = vrolformulario.idformulariofk
              INNER JOIN vrol        ON vrol.idrol               = vrolformulario.idrolfk
              INNER JOIN vrolusuario ON vrol.idrol               = vrolusuario.idrolfk
              INNER JOIN vusuario    ON vusuario.idusuario       = vrolusuario.idusuariofk
              WHERE vformulario.activo
                AND vrol.activo
                AND vrolusuario.activo
                AND vusuario.activo
                AND vformulario.formulario='$pFormulario'
                AND vrolusuario.idusuariofk=$elUsuarioActivo";

      $rst = $vSys->vfSelect("$sql");
      if ( !$rst->EOF ) {
        $rst = $rst->FetchNextObject();
        $vf['entrar']      = true;
        $vf['incluir']     = $rst->incluir     == t ? true:false ;
        $vf['editar']      = $rst->editar      == t ? true:false ;
        $vf['eliminar']    = $rst->eliminar    == t ? true:false ;
        $vf['borrar']      = $rst->borrar      == t ? true:false ;
        $vf['imprimir']    = $rst->imprimir    == t ? true:false ;
        $vf['procesar']    = $rst->procesar    == t ? true:false ;
        $vf['administrar'] = $rst->administrar == t ? true:false ;
        $vf['mt']          = $rst->mt          == t ? true:false ;
        $vf['fb']          = $rst->fb          == t ? true:false ;
        $vf['aviso']       = '';
      }

    }

    if ($soloChequeo===''){

      if ( $vf['mt']===true || $vf['pb']===false ){
        $vf['incluir']     = false;
        $vf['editar']      = false;
        $vf['eliminar']    = false;
        $vf['borrar']      = false;
        $vf['imprimir']    = false;
        $vf['procesar']    = false;
        $vf['administrar'] = false;
        $vf['fb']          = true;
      }
      if ( $vf['su'] && $vf['autenticado'] ){
        $vf['entrar']      = true;
        $vf['incluir']     = true;
        $vf['editar']      = true;
        $vf['eliminar']    = true;
        $vf['borrar']      = true;
        $vf['imprimir']    = true;
        $vf['procesar']    = true;
        $vf['administrar'] = true;
        $vf['mt']          = false;
        $vf['pb']          = true;
        $vf['fb']          = false;
        $vf['aviso']       = '';
      }

      // Si no me Logueo desde una Computadora no puedo IMPRIMIR
      if ($_SESSION['desktop']!=='desktop'){
        $vf['imprimir'] = false;
      }

      echo json_encode($vf);

    }else{

      if ( $vf['su'] ) { $vf['entrar'] = true; }

      $vf1 = $vf['entrar']===true ? '1':'0';
      return $vf1;

    }

  }

  public function vfnPermiso2($pFormulario, $soloChequeo='') {
    @session_start();
    // Solo Para Saber si un Formulario esta Activo o No
    $vSys = new Sistema();
    $pFormulario = trim(strtolower($pFormulario));
    $rst = $vSys->vfSelect("SELECT formulario FROM vformulario WHERE formulario='$pFormulario'");
    if ($rst->EOF && $pFormulario!=='') {
      $vSys->vfSelect("INSERT INTO vformulario (formulario,descripcion) VALUES('$pFormulario','* $pFormulario')");
    }
    $elUsuarioActivo = $_SESSION['idpersona'];
    $vf = array();
    $vf['id']          = $elUsuarioActivo;
    $vf['entrar']      = false;
    $vf['mt']          = false;
    $vf['pb']          = true;
    $vf['su']          = false;
    $vf['fb']          = false;
    $vf['incluir']     = true;
    $vf['editar']      = true;
    $vf['eliminar']    = true;
    $vf['borrar']      = true;
    $vf['imprimir']    = true;
    $vf['autenticado'] = $_SESSION['autenticado'];

    $rstPersona = $vSys->vfSelect("FSELECT dpersona.cedula, dpersona.clave, dpersona.login, vusuario.clave2 FROM dpersona LEFT JOIN vusuario ON dpersona.idpersona=vusuario.idusuario WHERE dpersona.idpersona=$elUsuarioActivo");
    if ( $rstPersona->login ) {
      if ( $rstPersona->clave===md5("$rstPersona->cedula") ) { $vf['pb'] = false;}
      if ( $_SESSION['autenticado'] && $rstPersona->clave2==="261a7d80916532797f8735dd198d4ada" ) { $vf['su'] = true; }
    }

    if ( $vf['autenticado'] && !$vf['su'] ) {
      $rst = $vSys->vfSelect("SELECT mt, fb FROM vformulario WHERE activo AND formulario='$pFormulario'");
      if ( !$rst->EOF ) {
        $rst = $rst->FetchNextObject();
        $vf['entrar'] = true;
        $vf['fb']     = $rst->fb == t ? true:false ;
        $vf['mt']     = $rst->mt == t ? true:false ;
      }

      if ($vf['fb']===true || $vf['mt']===true){
        $vf['incluir']  = false;
        $vf['editar']   = false;
        $vf['eliminar'] = false;
        $vf['borrar']   = false;
      }

    }

    if ($soloChequeo===''){
      if ( $vf['su'] && $vf['autenticado'] ){
        $vf['entrar'] = true;
        $vf['mt']     = false;
        $vf['fb']     = false;
        $vf['pb']     = true;
      }
      echo json_encode($vf);
    }else{
      if ( $vf['su'] ) { $vf['entrar'] = true; $vf['fb'] = false;}
      $vf1 = $vf['entrar']===true ? '1':'0';
      return $vf1;
    }

  }


  public function vfnPermisoOriginal($pFormulario, $soloChequeo='') {
    @session_start();
    $vSys = new Sistema();
    $pFormulario = trim(strtolower($pFormulario));
    $rst = $vSys->vfSelect("SELECT formulario FROM vformulario WHERE formulario='$pFormulario'");
    if ( $rst->EOF && $pFormulario!=='miperfil' ) {
      if ( $pFormulario!=='' ) {
        $vSys->vfSelect("INSERT INTO vformulario (formulario,descripcion) VALUES('$pFormulario','* $pFormulario')");
      }
    }

    $vf = array();
    $vf['entrar']      = false;
    $vf['incluir']     = false;
    $vf['editar']      = false;
    $vf['eliminar']    = false;
    $vf['borrar']      = false;
    $vf['imprimir']    = false;
    $vf['procesar']    = false;
    $vf['administrar'] = false;
    $vf['mt']          = false;
    $vf['su']          = false;
    $vf['pb']          = true;
    $vf['aviso']       = "<b style='color:red;font-size:20px;'>No tiene Autorizacion.</b>";

    $rstPersona = $vSys->vfSelect("FSELECT dpersona.cedula, dpersona.clave, dpersona.login, vusuario.clave2 FROM dpersona LEFT JOIN vusuario ON dpersona.idpersona=vusuario.idusuario WHERE dpersona.idpersona=".$_SESSION['idpersona']);
    if ( $rstPersona->login ) {
      if( $rstPersona->clave===md5($rstPersona->cedula) || $rstPersona->clave===md5("12345") ) {
        $vf['pb'] = false;
      }
      if ( $rstPersona->clave2==="261a7d80916532797f8735dd198d4ada" && $_SESSION['autenticado'] ){
        $vf['entrar']      = true;
        $vf['incluir']     = true;
        $vf['editar']      = true;
        $vf['eliminar']    = true;
        $vf['borrar']      = true;
        $vf['imprimir']    = true;
        $vf['procesar']    = true;
        $vf['administrar'] = true;
        $vf['mt']          = false;
        $vf['su']          = true;
        $vf['aviso']       = '';

        // Si no me Logueo desde una Computadora no puedo IMPRIMIR
        if ($_SESSION['desktop']!=='desktop'){
          $vf['imprimir']  = false;
        }

      }
    }

    if ( $_SESSION['autenticado'] && !$vf['su'] ) {

      $sqlT = "SELECT vrolformulario.*, vformulario.re
          FROM vrolformulario
          INNER JOIN vformulario ON vformulario.idformulario = vrolformulario.idformulariofk
          INNER JOIN vrol        ON vrol.idrol               = vrolformulario.idrolfk
          INNER JOIN vrolusuario ON vrol.idrol               = vrolusuario.idrolfk
          INNER JOIN vusuario    ON vusuario.idusuario       = vrolusuario.idusuariofk
          WHERE vformulario.activo
            AND vrol.activo
            AND vrolusuario.activo
            AND vusuario.activo
            AND vformulario.formulario='$pFormulario'
            AND vrolusuario.idusuariofk=".$_SESSION['idpersona'];

      $rst = $vSys->vfSelect($sqlT);
      if ( !$rst->EOF ) {
        $rst = $rst->FetchNextObject();
        $vf['entrar']      = true;
        $vf['incluir']     = $rst->incluir     == t ? true:false ;
        $vf['editar']      = $rst->editar      == t ? true:false ;
        $vf['eliminar']    = $rst->eliminar    == t ? true:false ;
        $vf['borrar']      = $rst->borrar      == t ? true:false ;
        $vf['imprimir']    = $rst->imprimir    == t ? true:false ;
        $vf['procesar']    = $rst->procesar    == t ? true:false ;
        $vf['administrar'] = $rst->administrar == t ? true:false ;
        $vf['mt']          = $rst->re          == t ? true:false ;
        $vf['aviso']       = '';

        // Si no me Logueo desde una Computadora no puedo IMPRIMIR
        if ($_SESSION['desktop']!=='desktop'){
          $vf['imprimir']  = false ;
        }

      }
    }

    if ($soloChequeo===''){






      echo json_encode($vf);
    }else{
      $vf1 = $vf['entrar']===true ? '1':'0';
      return $vf1;
    }

  }

  public function validarFormulario($pFormulario, $soloChequeo='') {
    $vf = array();
    $vf['entrar']      = false;
    $vf['incluir']     = false;
    $vf['editar']      = false;
    $vf['eliminar']    = false;
    $vf['borrar']      = false;
    $vf['imprimir']    = false;
    $vf['procesar']    = false;
    $vf['administrar'] = false;
    $vf['su']          = false;
    $vf['pb']          = false;
    $vf['aviso']       = "<b style='color:red;font-size:20px;'>No tiene Autorizacion.</b>";
    if ( $soloChequeo === '' ){
      echo json_encode($vf);
    }else{
      return json_encode($vf);
    }
  }


 //  Empezar a Evaluar los Codigos de Aqui para Abajo a ver Si Son Necesarios //

  // Para Generar Combos en Formulario de la Tabla Unica
  public function vfComboBox( $nCombo="cbo", $tCombo=1, $cCombo='1', $txtCombo="n", $width=''){
    $vSys = new Sistema();
    //if ($txtCombo === "n" ) $tCombo .= " OR idtipo=1";
    if ($width!=='') $width = "style='width:$width%'";
    $rst = $vSys->vfSelect("SELECT idcodigo, idtexto, descripcion FROM vtablas2 WHERE idtipo=$tCombo ORDER BY idtipo, orden, descripcion");
    // $nCombo ->   Nombre del Combo
    // $tCombo ->   Tipo del Combo
    // $cCombo ->   Valor Seleccionado del Combo
    // $txtCombo -> El Indice es Texto (t) o Numero (n)
    echo "<select data-placeholder='Seleccione' id='$nCombo' name='$nCombo' $width >";
    echo "<option value='' selected='selected'>Seleccionar</option>";
    foreach($rst as $indice=>$valor){
      if ($txtCombo !== "n" ){
        echo "<option value='".$valor["idtexto"]."'";
        if ( $cCombo === $valor['idtexto'] ) echo " selected='selected'" ;
      }else{
        echo "<option value='".$valor["idcodigo"]."'";
        if ( $cCombo === $valor['idcodigo'] ) echo " selected='selected'" ;
      }
      echo ">".ucwords(trim(strtolower( $valor["descripcion"] )))."</option>";
    }
    echo "</select>";
  }

  // Para Generar Combos de Cualquier Tabla
  public function vfComboBoxTabla(  $nCombo="cbo", $tabla, $id, $descripcion, $valorId='', $where='1=1', $width='' ){
    // Ejemplo: Sistema::vfComboBoxTabla('cboEstado','nestado','idestado','estado','1','',40);
    $vSys = new Sistema();
    if ($where=='') $where='1=1';
    if ($width!=='') $width = "style='width:$width%'";
    $rst = $vSys->vfSelect("SELECT $id, $descripcion FROM $tabla WHERE $where ORDER BY $descripcion ASC");
    echo "<select data-placeholder='Seleccionar' id='$nCombo' name='$nCombo' $width >";
    foreach($rst as $indice=>$valor){
      echo "<option value='".$valor["$id"]."'";
      if ( $valorId == $valor["$id"] ) echo " selected='selected'" ;
      echo ">".ucwords(trim(strtolower( $valor["$descripcion"] )))."</option>";
    }
    echo "</select>";
  }


  // Para Generar Combos en Formulario de cualquier Tabla
  public function vfComboBoxSelect( $nCombo="cbo", $sql, $cCombo='', $alias='', $width='' ){
    $vSys = new Sistema();
    if ( $width!=='' ) $width = "style='width:$width%'";
    $rst = $vSys->vfSelect($sql, $alias);
    echo "<select data-placeholder='Seleccionar' id='$nCombo' name='$nCombo' $width >";
    echo "<option value='' selected='selected'>Seleccionar</option>";
    foreach($rst as $indice=>$valor){
      echo "<option value='".$valor["idcodigo"]."'";
      if ( $cCombo == $valor['idcodigo'] ) echo " selected='selected'" ;
      echo ">".$valor["descripcion"]."</option>";
    }
    echo "</select>";
  }

  // Buscar una Imagen desde Cualquier Directorio en el Directorio de Imagenes y Fotos //
  public function vfnImagen($archivo){
    session_start();
    $archivo2 = '';
    for( $i = 1 ; $i <= 4 ; $i++ ){
      if ( $i ==  1 ) $dir = $_SESSION['vDirRoot']."/vSys/imagenes/*";
      if ( $i ==  2 ) $dir = $_SESSION['vDirRoot']."/vSys/fotos/*";
      if ( $i ==  3 ) $dir = $_SESSION['vDirRootSistema']."/vSys/imagenes/*";
      if ( $i ==  4 ) $dir = $_SESSION['vDirRootSistema']."/vSys/fotos/*";
      foreach(glob($dir) as $file) {
        if ( filetype($file) === 'file' && strpos($file, $archivo) ) {
          $archivo2 = $file;
          $i = 5;
          break;
        }
      }
    }
    echo($archivo2);
  }

  // Validacion de Fechas
  public function validarFecha( $fecha="", $campo="" , $format="dmy" ){
    //http://www.kickbill.com/?p=1132
    //http://idesweb.es/proyecto/proyecto-prac05-js-validacion
    if ($fecha != "" ){
      $separator_type= array("/","-",".");
      foreach ($separator_type as $separator) {
        $find = stripos($fecha, $separator);
        if ($find <> false) $separator_used = $separator;
      }
      $fecha_array = explode($separator_used,$fecha);
      if ($format == "mdy") {
        $fecha = checkdate($fecha_array[0],$fecha_array[1],$fecha_array[2]);
      } elseif ($format == "ymd") {
        $fecha = checkdate($fecha_array[1],$fecha_array[2],$fecha_array[0]);
      } else {
        $fecha = checkdate($fecha_array[1],$fecha_array[0],$fecha_array[2]);
      }
      if ( $fecha ) {
        $fecha = "";
      } else {
        $fecha = "Fecha Incorrecta. <br>";
        if ( $campo != "" ) $fecha = $campo." Incorrecta. <br>";
      }

    }
    return $fecha;
  }

  // Cambiar el Formato de la Fecha
  public function vfConvertirFecha( $xFecha, $xHacer='m' ){
    $xHacer = strtolower($xHacer);
    $xFecha = str_replace('-','/',$xFecha);
    if ( $xHacer=='i' || $xHacer=='m' ){
      // Cambiar la Fecha a Dia/Mes/Año para Mostrar
      if ( $xFecha{4} == '/' ) $xFecha = $xFecha{8}.$xFecha{9}."/".$xFecha{5}.$xFecha{6}."/".$xFecha{0}.$xFecha{1}.$xFecha{2}.$xFecha{3};
    } elseif ( $xHacer=='c' || $xHacer=='g' ){
      // Cambiar la Fecha a Año/Mes/dia para Guardar
      if ( $xFecha{2} == '/' ) $xFecha = $xFecha{6}.$xFecha{7}.$xFecha{8}.$xFecha{9}."/".$xFecha{3}.$xFecha{4}."/".$xFecha{0}.$xFecha{1};
      $xFecha = trim($xFecha);
      if ( $xFecha == '' ) $xFecha = null ;
    }
    return $xFecha;
  }

  // Generar Password Aleatorio
  public function vGenerarPassword($pLongitud=8, $vLetras="abc123defgh456ijkmnpq7890rstuvwxyz"){
    $vContrasena = '';
    $max = strlen($vLetras)-1;
    for ( $i = 0 ; $i < $pLongitud ; $i ++) {
        $vContrasena .= substr($vLetras, rand(0, $max), 1);
    }
    return $vContrasena;
  }

  public function vfnAleatorio($pLongitud=7, $vLetras="abcdefhjkmnpqrstuvwxyz1234789ABCDEFGHIJKLMNPQRSTUVWXYZ"){
    // No hay giloO 056  porque se confunden
    $vTexto = '';
    $max = strlen($vLetras)-1;
    for ( $i = 0 ; $i < $pLongitud ; $i ++) {
        $vTexto .= substr($vLetras, rand(0, $max), 1);
    }
    return $vTexto;
  }

  public function vfnVideos($ext='*', $dir='videos'){
    if ($dir==='') { $dir='videos'; }
    $dir = dirname(__DIR__)."/$dir/*.$ext";
    $files = glob($dir);
    $listStr = '';
    foreach ($files as $file){
      $file = str_replace(dirname(__DIR__).'/','',$file);
      $listStr .= ($listStr!=='')?", ":"";
      $listStr .= "'$file'";
    }
    return $listStr;
  }

  // Obtener la Ip del Usuario
  public function getRealIP() {
    if (!empty($_SERVER['HTTP_CLIENT_IP']))       return $_SERVER['HTTP_CLIENT_IP'];
    if (!empty($_SERVER['HTTP_X_FORWARDED_FOR'])) return $_SERVER['HTTP_X_FORWARDED_FOR'];
    return $_SERVER['REMOTE_ADDR'];
  }


  public function vfnFecha($formato='dn-mn-an',$fecha='',$k='') {
    //$vSys->vfnFecha('a los dl días del mes de ml del año al');
    //$vSys->vfnFecha('a los dl días del mes de ml del año al','',1);
    //$vSys->vfnFecha('a los dl días del mes de ml del año al','',2);

    setlocale(LC_TIME, 'spanish');
    $vSysFecha = new Sistema();
    if ($fecha===''){
      $fecha = new DateTime();
      $fecha->format("d-m-Y");
    }else{
      $fecha = new DateTime("$fecha");
      $fecha->format("d-m-Y");
    }
    $fechaRetorno = "$formato";

    $sl = $vSysFecha->vfnFechaDiaSemana($fecha->format('w'));
    $dn = $fecha->format('d');
    $dl = $vSysFecha->vfnFechaDia($fecha->format('d'));
    $mn = $fecha->format('m');
    $ml = $vSysFecha->vfnFechaMes($fecha->format('m'));
    $an = $fecha->format('Y');
    $al = $vSysFecha->vfnFechaAño($fecha->format('Y'));

    $fechaRetorno = str_ireplace("sl","$sl",$fechaRetorno);
    $fechaRetorno = str_ireplace("dn","$dn",$fechaRetorno);
    $fechaRetorno = str_ireplace("dl","$dl",$fechaRetorno);
    $fechaRetorno = str_ireplace("mn","$mn",$fechaRetorno);
    $fechaRetorno = str_ireplace("ml","$ml",$fechaRetorno);
    $fechaRetorno = str_ireplace("an","$an",$fechaRetorno);
    $fechaRetorno = str_ireplace("al","$al",$fechaRetorno);

    if ($k=='1'){
      if ($dn==='01') $fechaRetorno = str_ireplace("a los primer días","al primer día",$fechaRetorno);
      $fechaRetorno = strtolower($fechaRetorno);
    }elseif ($k=='2'){
      if ($dn==='01') $fechaRetorno = str_ireplace("a los primer días del mes","el primero",$fechaRetorno);
      $fechaRetorno = strtolower($fechaRetorno);
    }
    return ($fechaRetorno);
  }

  public function vfnFechaDia($dd1) {
    $dd1 = intval($dd1);
    switch ( $dd1 ) {
      case 1:  $dia = "primer";       break;
      case 2:  $dia = "dos";          break;
      case 3:  $dia = "tres";         break;
      case 4:  $dia = "cuatro";       break;
      case 5:  $dia = "cinco";        break;
      case 6:  $dia = "seis";         break;
      case 7:  $dia = "siete";        break;
      case 8:  $dia = "ocho";         break;
      case 9:  $dia = "nueve";        break;
      case 10: $dia = "diez";         break;
      case 11: $dia = "once";         break;
      case 12: $dia = "doce";         break;
      case 13: $dia = "trece";        break;
      case 14: $dia = "catorce";      break;
      case 15: $dia = "quince";       break;
      case 16: $dia = "dieciseis";    break;
      case 17: $dia = "diecisiete";   break;
      case 18: $dia = "dieciocho";    break;
      case 19: $dia = "diecinueve";   break;
      case 20: $dia = "veinte";       break;
      case 21: $dia = "veintiun";     break;
      case 22: $dia = "veintidos";    break;
      case 23: $dia = "veintitres";   break;
      case 24: $dia = "veinticuatro"; break;
      case 25: $dia = "veinticinco";  break;
      case 26: $dia = "veintiseis";   break;
      case 27: $dia = "veintisiete";  break;
      case 28: $dia = "veintiocho";   break;
      case 29: $dia = "veintinueve";  break;
      case 30: $dia = "treinta";      break;
      case 31: $dia = "treintiun";    break;
      default: $dia = "$dd1";         break;
    }
    return ($dia);
  }

  public function vfnFechaDiaSemana($dd1) {
    $dd1 = intval($dd1);
    switch ( $dd1 ) {
      case 0: $dia = "Domingo";   break;
      case 1: $dia = "Lunes";     break;
      case 2: $dia = "Martes";    break;
      case 3: $dia = "Miércoles"; break;
      case 4: $dia = "Jueves";    break;
      case 5: $dia = "Viernes";   break;
      case 6: $dia = "Sábado";    break;
      default: $dia = "$dd1";     break;
    }
    return ($dia);
  }

  public function vfnFechaMes($mm1) {
    $mm1 = intval($mm1);
    switch ( $mm1 ) {
      case 1:  $mes = "Enero";      break;
      case 2:  $mes = "Febrero";    break;
      case 3:  $mes = "Marzo";      break;
      case 4:  $mes = "Abril";      break;
      case 5:  $mes = "Mayo";       break;
      case 6:  $mes = "Junio";      break;
      case 7:  $mes = "Julio";      break;
      case 8:  $mes = "Agosto";     break;
      case 9:  $mes = "Septiembre"; break;
      case 10: $mes = "Octubre";    break;
      case 11: $mes = "Noviembre";  break;
      case 12: $mes = "Diciembre";  break;
      default: $mes = "$mm1";       break;
    }
    return ($mes);
  }

  public function vfnFechaAño($aa1) {
    $aa1 = intval($aa1);
    switch ( $aa1 ) {
      case 2020: $caa = "dos mil veinte";       break;
      case 2021: $caa = "dos mil veintiuno";    break;
      case 2022: $caa = "dos mil veintidos";    break;
      case 2023: $caa = "dos mil veintitres";   break;
      case 2024: $caa = "dos mil veinticuatro"; break;
      case 2025: $caa = "dos mil veinticinco";  break;
      case 2026: $caa = "dos mil veintiseis";   break;
      case 2027: $caa = "dos mil veintisiete";  break;
      case 2028: $caa = "dos mil veintiocho";   break;
      case 2029: $caa = "dos mil veintinueve";  break;
      case 2030: $caa = "dos mil treinta";      break;
      default:   $caa = "$aa1";                 break;
    }
    return ($caa);
  }


  // Validar una Cuenta Bancaria
  // http://www.neleste.com/validar-ccc-con-php/


/*
-- Select replace('Peã±A', 'ã±','ñ');
update dpersonajbp set
apellidos1 = initcap(replace(apellidos1, 'ã±','ñ')),
apellidos2 = initcap(replace(apellidos2, 'ã±','ñ')),
nombres1 = initcap(replace(nombres1, 'ã±','ñ')),
nombres2 = initcap(replace(nombres2, 'ã±','ñ'));

*/

  public function vfProbarSistema(){
    @session_start();
    $_SESSION['autenticado']     = true;
    $_SESSION['idpersona']       = 7;
    $_SESSION['idusuario']       = 7;
    $_SESSION['cedula']          = 8760097;
    $_SESSION['cedulaSigesp']    = "0008760097";
    return;
  }

/*

CREATE OR REPLACE FUNCTION vsistema.vfnvusuario(
    IN pin_usuario integer,
    OUT pout_usuario text)
  RETURNS text AS
$BODY$
  DECLARE
  vRst Record;
BEGIN
   FOR vRst IN SELECT nombres1, apellidos1 FROM dpersona WHERE idpersona=pin_usuario ORDER BY idpersona LOOP
       pout_usuario := vRst.apellidos1 || ' ' || vRst.nombres1;
   END LOOP;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION vsistema.vfnvusuario(integer)
  OWNER TO postgres;



CREATE OR REPLACE FUNCTION vsistema.vfnedad(
    IN pd_fecha_ini date,
    IN pd_fecha_fin date,
    OUT pn_edad integer)
  RETURNS integer AS
$BODY$
BEGIN
pn_edad := FLOOR(((DATE_PART('YEAR',pd_fecha_fin)-DATE_PART('YEAR',pd_fecha_ini))* 372 + (DATE_PART('MONTH',pd_fecha_fin) - DATE_PART('MONTH',pd_fecha_ini))*31 + (DATE_PART('DAY',pd_fecha_fin)-DATE_PART('DAY',pd_fecha_ini)))/372);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION vsistema.vfnedad(date, date)
  OWNER TO postgres;


CREATE OR REPLACE FUNCTION vsistema.vfngenerar_password(integer)
  RETURNS text AS
$BODY$
    Declare
    -- Parametros
    pLongitud   ALIAS For $1;
    -- Variables
    vContrasena text    := '';
    vCaracter   text    := '';
    i           integer := 0;
    BEGIN
      If pLongitud > 8 Then
        pLongitud := 8;
      End If;
      While i < pLongitud Loop
        vCaracter := chr(round((random()*87)+35)::Integer);
        if strpos('abcdefghijkmnpqrstuvwxyz123456789#$%',lower(vCaracter)) <> 0 then
          i := i + 1;
          vContrasena := vContrasena || vCaracter;
        end if;
      End Loop;
      Return vContrasena;
    END;
 $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION vsistema.vfngenerar_password(integer)
  OWNER TO postgres;



CREATE OR REPLACE FUNCTION vsistema.vusuario_trigger()
  RETURNS trigger AS
$BODY$
    BEGIN
        IF (TG_OP = 'UPDATE') THEN
           UPDATE vusuario SET usuario=new.nombres1 || ' ' || new.apellidos1 WHERE idusuario=old.idpersona;
           RETURN NEW;
        END IF;
        RETURN NULL;
    END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION vsistema.vusuario_trigger()
  OWNER TO postgres;


*/



  // RUTINAS para eliminarlas ya que se mejoraron en los Controladores

/*

  // Validar que no venga una SPAM
  public function validarSpam($cmensaje, $campo=""){
    $cm = strtolower(trim($cmensaje));
    $cm = str_replace("script"     ,"",$cm);
    $cm = str_replace("select"     ,"",$cm);
    $cm = str_replace("insert into","",$cm);
    $cm = str_replace("update"     ,"",$cm);
    $cm = str_replace("delete"     ,"",$cm);
    $cm = str_replace("session"    ,"",$cm);
    $cm = str_replace("<meta"      ,"",$cm);
    $cm = str_replace("link"       ,"",$cm);
    $cm = str_replace("java"       ,"",$cm);
    $cm = str_replace("location"   ,"",$cm);
    $cm = str_replace("drop"       ,"",$cm);
    $cm = str_replace("require"    ,"",$cm);
    $cm = str_replace("include"    ,"",$cm);
    $cm = str_replace("http"       ,"",$cm);
    $cm = str_replace("www"        ,"",$cm);
    $cm = str_replace("//"         ,"",$cm);
    $cm = str_replace("spam"       ,"",$cm);
    $cm = str_replace(";"          ,"",$cm);
    $spam = "";
    if ( strtolower(trim($cmensaje)) != trim($cm) ){
      $spam = "El Contenido de un Dato se Considera un SPAM. <br>";
      if ( $campo != "" ) $spam = $campo.": Su Contenido se Considera un SPAM. <br>";
    };
    return $spam;
  }

  // Covertirlos acentos y las ñ en Acute
  public function vAcute($cm){
    $cm = str_replace('á','&aacute;',$cm);
    $cm = str_replace('é','&eacute;',$cm);
    $cm = str_replace('í','&iacute;',$cm);
    $cm = str_replace('ó','&oacute;',$cm);
    $cm = str_replace('ú','&uacute;',$cm);
    $cm = str_replace('Á','&Aacute;',$cm);
    $cm = str_replace('É','&Eacute;',$cm);
    $cm = str_replace('Í','&Iacute;',$cm);
    $cm = str_replace('Ó','&Oacute;',$cm);
    $cm = str_replace('Ú','&Uacute;',$cm);
    $cm = str_replace('ü','&uuml;'  ,$cm);
    $cm = str_replace('Ü','&Uuml;'  ,$cm);
    $cm = str_replace('ñ','&ntilde;',$cm);
    $cm = str_replace('Ñ','&Ntilde;',$cm);
    return $cm;
  }

  // Eliminar Saltos de Lineas y SPAM
  public function eliminarSpam( $mensaje ){

    $mensaje = strtolower(trim($mensaje));

    // Eliminar los Saltos de Linea
    $sustituye = array("\r\n", "\n\r", "\n", "\r");
    $mensaje   = trim(str_replace($sustituye, "", $mensaje));

    // Validar que no venga una SPAM
    $sustituye = array("script","select","insert into","values","update","delete","session","<meta","link","java","location","drop","require","include","http","www","//","spam",";","*");
    $mensaje   = trim(str_replace($sustituye, "", $mensaje));

    // Validar que no sea una Tabla del Sistema
    $sustituye = array("vrol","vusuario","vformulario","vrolformulario","vrolusuario","vcomun","ntablas","ndtablas","dpersona");
    $mensaje   = trim(str_replace($sustituye, "", $mensaje));


    // Eliminar los Dobles Espacios
    $sustituye = array("  ");
    $mensaje   = trim(str_replace($sustituye, " ", $mensaje));

    $sustituye = array("  ");
    $mensaje   = trim(str_replace($sustituye, " ", $mensaje));

    $mensaje = ucwords($mensaje);
    $mensaje = utf8_decode($mensaje);

    return $mensaje;
  }


  // Buscar la Descripcion de la Tabla Unica
  public function buscarDescripcion( $codigo ){
    $rst = $this->vfSelectSql("SELECT descripcion FROM ntablas WHERE idcodigo=$codigo ORDER BY idcodigo");
    return trim($rst[0]["descripcion"]);
  }

  // Buscar la Descripcion de la Tabla Unica por Texto
  public function buscarDescripcionTexto( $tipo, $valor ){
    $rst = $this->vfSelectSql("SELECT descripcion FROM ntablas WHERE idtipo=$tipo AND idtexto='$valor' ORDER BY idcodigo");
    return trim($rst[0]["descripcion"]);
  }

*/
}
?>
