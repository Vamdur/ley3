<?php @session_start();

  if ($vGrid==='dpropuesta'){

    $vGridSelect = "SELECT * FROM dconsulta";
    $vGridWhere .= " AND dconsulta.cedulafk=".$_SESSION['cedula'];

  }

  if ($vGrid==='dpropuestas'){

    $vGridSelect = "SELECT dconsulta.*,
                      dpersona.cedula, dpersona.apellidos1, dpersona.nombres1, dpersona.sexo, dpersona.celular, dpersona.correo,
                      nestado.estado, nmunicipio.municipio, nparroquia.parroquia, dpersona.ciudad
                    FROM dconsulta
                    INNER JOIN dpersona   ON dpersona.cedula=dconsulta.cedulafk
                    LEFT  JOIN nparroquia ON nparroquia.idparroquia=dpersona.idparroquiafk
                    LEFT  JOIN nmunicipio ON nmunicipio.idmunicipio=nparroquia.idmunicipiofk
                    LEFT  JOIN nestado    ON nestado.idestado=nmunicipio.idestadofk ";

    if ($xfdesde!=='' && $xfhasta!==''){
      $vGridWhere .= " AND dconsulta.fpropuesta::date BETWEEN '$xfdesde'::date AND '$xfhasta'::date";
    }elseif ($xfdesde!==''){
      $vGridWhere .= " AND dconsulta.fpropuesta::date>='$xfdesde'::date";
    }elseif ($xfhasta!==''){
      $vGridWhere .= " AND dconsulta.fpropuesta::date<='$xfhasta'::date";
    }

  }

  if ($vGrid==='vlogin' || $vGrid==='vloginrecuperar'  || $vGrid==='vloginregistro' ){

    $vGridSelect = "SELECT * FROM dpersona";
    $vGridWhere .= " AND cedula=0";

  }

  if ($vGrid==='vloginperfil' ){

    $vGridSelect = "SELECT * FROM dpersona";
    $vGridWhere .= " AND cedula=".$_SESSION['cedula'];

  }

?>
