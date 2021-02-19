<?php @session_start();
  require_once("../vSys/vfnSession.php");
?>
  <script type="text/javascript">
    $(document).ready(function(){

      vfnTitulo({titulo:"", icono:''});
      var vcolModel = [];
      vcolModel.push({ name:'login', label:'Usuario',  template:'vtText', editoptions:{ size:30, placeholder:'Cédula o Correo Electrónico'}, editrules:{required:true} });
      vcolModel.push({ name:'usuario', label:'Nombres', template:'vtText', editrules:{required:true, edithidden:true}, editoptions:{ size:30, "readonly":"readonly" }  });
      vcolModel.push({ name:'pregunta', label:'Pregunta', template:'vtText', editrules:{required:true, edithidden:true}, editoptions:{ size:30, "readonly":"readonly" }  });
      vcolModel.push({ name:'respuesta', label:'Repuesta', template:'vtText', editrules:{required:true, edithidden:true}, editoptions:{size:30, placeholder:'a su Pregunta Secreta'} });

      vfnCrearGrid({id:'vlogin',hide:true});
      $('#vlogin').jqGrid({
        url:"vloginrecuperar",
        colModel:vcolModel,
        cmTemplate:{ editable:true, editrules:{edithidden:true} }
      })
      .jqGrid('navGrid','#vloginPag',{ add:true },{},
        { beforeShowForm: function(form) {
          vfnGridFormulario({frm:form, trHide:'1pregunta,1respuesta', caption:'Recuperar Contraseña', width:350, center:true, top:120, labelBold:true });
            $('#sData').html(vfnFa('key fa-2x text-success','Recuperar'));
            $('#cData').html(vfnFa('undo fa-2x text-danger','Cancelar'));
            $("#login").attr("onchange","vfnAjax('ajaxBuscarLogin',{login:this.value});");
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
