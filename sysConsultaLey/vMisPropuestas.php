<?php @session_start();
  require_once("../vSys/vfnSession.php");
  // Por Ahora Despues Buscar una Solucion
  $rst = $vSys->vfSelect("FSELECT * FROM vformulario WHERE formulario='mispropuestas'");
  $vf['entrar']      = true;
  $vf['pb']          = true;
  $vf['mt']          = $rst->mt == t ? true:false ;
  $vf['fb']          = $rst->fb == t ? true:false ;
  $vf['fa']          = $rst->activo == t ? true:false ;
  if ( !$vf['fa'] ){
    $vf['fb'] = true;
  }
  if ( $vf['mt'] || $vf['fb'] ){
    $vf['incluir'] = false ;
    $vf['editar']  = false ;
    $vf['borrar']  = false ;
  }else{
    $vf['incluir'] = true;
    $vf['editar']  = true;
    $vf['borrar']  = true;
  }
  $miVF = json_encode($vf);
?>
  <script type="text/javascript">

    $(document).ready(function(){

      vfnTitulo({titulo:"Mis Propuestas", icono:'file-text-o'});
      var pU1 = <?php echo($miVF);?>;
      vfnGridPermiso({op:pU1});
      $('#sysVar').data('rehacer','0');
      var vcolModel = [];
      vcolModel.push({ label:'#', name:'idconsulta', align:'center',  editrules:{required:false}, editable:false, hidden:true});
      vcolModel.push({ name:'idaspectofk', label:'Aspecto',  width:150, template:'vtSelect', editoptions:{value:<?php echo(Sistema::SistemaCbo('4','n'));?>} });
      vcolModel.push({ name:'numero', label:'Número', template:'vtText', align:'center',  editrules:{required:true, edithidden:true}, editoptions:{size:10}, width:80, search:false });
      vcolModel.push({ name:'numero2', label:'Numeral', template:'vtText',  align:'center',  editrules:{required:false, edithidden:true}, width:80, editoptions:{size:10, placeholder:'Numeral'}, search:false });
      vcolModel.push({ name:'numero3', label:'Literal', template:'vtText',  align:'center',  editrules:{required:false, edithidden:true}, width:80, editoptions:{size:10, placeholder:'Literal'}, search:false });
      vcolModel.push({ name:'idpropuestafk', label:'Tipo', template:'vtSelect', editoptions:{value:<?php echo(Sistema::SistemaCbo('3','n'));?>} });
      vcolModel.push({ label:'Propuesta', name:'propuesta', template:'vtTextArea', width:500, search:false, editable:true, editoptions:{placeholder:'', rows:7, style:"width:550px"} });
      vcolModel.push({ label:'Incluido', name:'fpropuesta', editable:false, template:'vtDateT' });
      vcolModel.push({ label:'Modificado', name:'fpersona2', editable:false, template:'vtDateT' });

      vfnCrearGrid({id:'propuestas'});
      $('#propuestas').jqGrid({
        caption: " ",
        url:"dpropuesta",
        colModel:vcolModel,
        cmTemplate:{ search:false, editrules:{required:true, edithidden:true}, editable:true, align:'left', sortable:false, width:120 },
        sortname:'fpropuesta',
        sortorder:'desc',
        rowNum:20,
        loadComplete: function(data){
          $(this).vfnGridBED(false);
          if (data.records==0 && $('#sysVar').data('rehacer')==='0'){
            vfPanelAyuda({hlp:'sysConsultaLey/hlp/propuesta.hlp',hlpTitle:'Información'});
            $('#sysVar').data('rehacer','1');
          }
          $(this).jqGrid('showCol',['fpersona2']);
          $(this).vfnGridRow1();
        },
        onSelectRow: function(id){
          $(this).vfnGridBED();
        }
      })
      .jqGrid('navGrid','#propuestasPag',
        { add:pU1.incluir, edit:pU1.editar, del:pU1.borrar,
           addtitle:'Incluir una Propuesta',
           edittitle:'Modificar la Propuesta',
           deltitle:'Borrar la Propuesta'
        },
        { beforeShowForm: function(form) {
            vfnGridFormulario({frm:form, width:650});
            $("#numero2").insertAfter("#numero");
            $("#numero3").insertAfter("#numero2");
            vfnGridTrRemove('numero2,numero3,fpersona1');
            if ($("#idaspectofk").val()==='7'){
              $('#numero2,#numero3').show();
            }else{
              $('#numero2,#numero3').hide();
            }
          }
        },
        { beforeShowForm: function(form) {
            vfnGridFormulario({frm:form, width:650});
            $("#numero2").insertAfter("#numero");
            $("#numero3").insertAfter("#numero2");
            vfnGridTrRemove('numero2,numero3,fpersona1');
            vfnGridTrHide('numero,idaspectofk,idpropuestafk,propuesta');
            $('#numero2,#numero3').hide();
            vfnGridTrHide('numero,idaspectofk,idpropuestafk,propuesta',false);
            $("#idaspectofk").change(function() {
              if (this.value==='7'){
                  $('#numero2,#numero3').show();
              }else{
                 $('#numero2,#numero3').val('').hide();
              }
            });
          }
        },
        { msg:'Desea BORRAR la Propuesta',
          beforeShowForm: function(form) {
            vfnGridFormulario({frm:form});
          }
        }
      )
      .vfnGridConfigurar({showUser:false, hlp:'sysConsultaLey/hlp/propuesta.hlp'});

    });
  </script>
