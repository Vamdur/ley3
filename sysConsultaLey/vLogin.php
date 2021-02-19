<?php @session_start();
  require_once("../vSys/vfnSession.php");
?>
  <script type="text/javascript">

    $(document).ready(function(){

      vfnTitulo({titulo:"", icono:''});
      var vcolModel = [];
      vcolModel.push({ label:'Usuario',    name:'login',    template:'vtText', editoptions:{ size:30, placeholder:'Cédula o Correo Electrónico'}, editrules:{required:true} });
      vcolModel.push({ label:'Contraseña', name:'password', template:'vtPassword', editoptions:{ size:30}, editrules:{required:true} });

      vfnCrearGrid({id:'vlogin',hide:true});
      $('#vlogin').jqGrid({
        url:"vlogin",
        colModel:vcolModel,
        cmTemplate:{ editable:true, editrules:{edithidden:true} }
      })
      .jqGrid('navGrid','#vloginPag',{ add:true },{},
        { beforeShowForm: function(form) {
          vfnGridFormulario({frm:form, caption:'Inicio de Sesión', width:350, center:true, top:120, labelBold:true });
            $('#sData').html(vfnFa('sign-in fa-2x text-success','Iniciar Sesión'));
            $('#cData').html(vfnFa('undo fa-2x text-danger','Cancelar'));
          },
          afterShowForm: function(form) {
            $("#login").focus();
          }
        }
      )
      .vfnGridConfigurar({});
      $('#add_vlogin_top').click();

    });

  </script>
