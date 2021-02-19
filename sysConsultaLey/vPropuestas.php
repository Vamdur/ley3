<?php @session_start();
  require_once("../vSys/vfnSession.php");
  $hoy = $_SESSION['hoy'];
?>
  <script type="text/javascript">

    $(document).ready(function(){

      vfnTitulo({titulo:"Propuestas Registradas", icono:'file-text-o'});
      var pU1 = <?php echo($vSys->vfnPermiso('Propuestas'));?>;
      vfnGridPermiso({op:pU1});

      var vcolModel = [];
      vcolModel.push({ name:'idaspectofk', label:'Aspecto', width:150, editable:true, template:'vtSelect', editoptions:{value:<?php echo(Sistema::SistemaCbo('4','n'));?>} });
      vcolModel.push({ name:'numero', label:'Número', template:'vtText', align:'center', editable:true,  editrules:{required:true, edithidden:true}, editoptions:{size:10}, width:80 });
      vcolModel.push({ name:'numero2', label:'Numeral', template:'vtText',  align:'center', editable:true,  editrules:{required:false, edithidden:true}, width:80, editoptions:{size:10, placeholder:'Numeral'} });
      vcolModel.push({ name:'numero3', label:'Literal', template:'vtText',  align:'center', editable:true,  editrules:{required:false, edithidden:true}, width:80, editoptions:{size:10, placeholder:'Literal'} });
      vcolModel.push({ name:'idpropuestafk', label:'Tipo', template:'vtSelect', editable:true, editoptions:{value:<?php echo(Sistema::SistemaCbo('3','n'));?>} });
      vcolModel.push({ label:'Propuesta', name:'propuesta', template:'vtTextArea', width:500, editable:true, editoptions:{placeholder:'', rows:7, style:"width:550px"} });

      vcolModel.push({ label:'Cédula', name:'cedula', template:'vtCedula', editable:true });
      vcolModel.push({ name:'apellidos1', label:'Apellido', formoptions:{label:'Usuario'},   editable:true, template:'vtText' });
      vcolModel.push({ name:'nombres1', label:'Nombre', template:'vtText', editable:true });
      vcolModel.push({ name:'sexo', template:'vtSexo', search:true});
      vcolModel.push({ name:'correo', label:'Correo', template:'vCorreo', search:true});
      vcolModel.push({ name:'celular', label:'Teléfono', template:'vText'});

      vcolModel.push({ name:'estado', label:'Estado' });
      vcolModel.push({ name:'municipio', label:'Municipio' });
      vcolModel.push({ name:'parroquia', label:'Parroquia' });
      vcolModel.push({ name:'ciudad', label:'Ciudad' });
      vcolModel.push({ name:'idusuario1', template:'vtUser2' });
      vcolModel.push({ label:'Incluido', name:'fpropuesta', template:'vtDateT' });
      vcolModel.push({ label:'Modificado', name:'fpersona2', template:'vtDateT' });

      vfnCrearGrid({id:'propuestas'});
      $('#propuestas').jqGrid({
        caption: " ",
        url:"dpropuestas&xfdesde=&xfhasta=<?php echo($hoy);?>",
        colModel:vcolModel,
        cmTemplate:{ editable:false, search:true, editrules:{required:true, edithidden:true},  align:'left', sortable:false, width:120 },
        sortname:'fpropuesta',
        sortorder:'desc',
        rowNum:20,
        loadComplete: function(data){
          $(this).vfnGridBED(false);
          $(this).jqGrid('showCol',['fpersona2']);
        },
        onSelectRow: function(id){
          $(this).vfnGridBED();
        }
      })
      .jqGrid('navGrid','#propuestasPag',
        { edit:true,
          edittitle:'Visualizar la Propuesta'
        },
        { beforeShowForm: function(form) {
            vfnGridFormulario({frm:form, caption:'Propuesta', width:650});
            $("#nombres1").insertAfter("#apellidos1");
            $("#numero2").insertAfter("#numero");
            $("#numero3").insertAfter("#numero2");
            vfnGridTrRemove('nombres1,numero2,numero3,fpersona1');
            $('#propuestas').vfnEnabled('*',false);
            $('#sData').remove();
          }
        }
      )
      .jqGrid('setGroupHeaders',{groupHeaders:[
        {startColumnName:'cedula', numberOfColumns:6,  titleText:vfnFa('user','Usuario')},
        {startColumnName:'estado', numberOfColumns:4,  titleText:vfnFa('map-marker','Ubicación')},
        {startColumnName:'fpropuesta', numberOfColumns:2,  titleText:vfnFa('calendar','Fechas')},
      ]})
      .vfnGridConfigurar({showUser:false, fechas:true, iconEdit:'eye',  hlp:'sysConsultaLey/hlp/propuestas.hlp'});

      $('#xfdesde').val("");
      $('#xfdesde,#xfhasta').datepicker('setEndDate','0').datepicker('update');
      $('#xfdesde,#xfhasta').change(function(e){
        var condicion1  =  'xfdesde='+$('#xfdesde').val();
            condicion1 += '&xfhasta='+$('#xfhasta').val();
        $("#propuestas").vfnGridSetUrl({vGrid:'dpropuestas', condicion:condicion1 });
      });

    });
  </script>
