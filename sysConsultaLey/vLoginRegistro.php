<?php @session_start();
  require_once("../vSys/vfnSession.php");
?>
  <script type="text/javascript">
    $(document).ready(function(){

      vfnTitulo({titulo:"", icono:''});
      var vcolModel = [];
      vcolModel.push({ label:'Cédula', name:'cedula', template:'vtCedula'} );
      vcolModel.push({ name:'apellidos1', label:'Apellido', formoptions:{label:'Apellidos'},  template:'vtText' });
      vcolModel.push({ name:'apellidos2', formoptions:{label:'2°'}, editrules:{required:false, edithidden:true} });
      vcolModel.push({ name:'nombres1', label:'Nombre', formoptions:{label:'Nombres'}, template:'vtText' });
      vcolModel.push({ name:'nombres2', formoptions:{label:'2°'}, editrules:{required:false, edithidden:true} });
      vcolModel.push({ name:'fnacimiento', template:'vtFNacimiento' });
      vcolModel.push({ name:'sexo',template:'vtSexo', search:true});
      vcolModel.push({ name:'correo', label:'Correo',template:'vtCorreo', editrules:{required:true, edithidden:true}, editoptions:{size:50, maxlength:50} });
      vcolModel.push({ label:'Edo-Mun-Pquia', name:'idparroquiafk', template:'vtSelect', editoptions:{ value:<?php echo(Sistema::SistemaCbo('idemp'));?>,  style:"width:95%"} });
      vcolModel.push({ name:'ciudad', label:'Ciudad', template:'vtText', editoptions:{ placeholder:'o Lugar', size:50, maxlength:50} });
      vcolModel.push({ name:'institucion', label:'Institución', template:'vtText',  editoptions:{ rows:4, placeholder:'o Comunidad', style:"width:95%"} });
      vcolModel.push({ name:'direccion', label:'Dirección', template:'vtTextArea', editoptions:{style:"width:510px"} });
      vcolModel.push({ name:'celular', label:'Teléfonos', template:'vtText', editoptions:{ size:30} });
      vcolModel.push({ name:'fax', label:'Fax', template:'vtText', editrules:{required:false, edithidden:true}, editoptions:{placeholder:'Fax (Opcional)'} });
      vcolModel.push({ name:'password', label:'Contraseña', template:'vtText', editrules:{required:false, edithidden:true},  editoptions:{ size:10, maxlength:10 } });
      vcolModel.push({ name:'pregunta', label:'Pregunta Secreta', template:'vtText', editoptions:{ size:50, maxlength:50, placeholder:'Unica forma de Recuperar su Contraseña' }  });
      vcolModel.push({ name:'respuesta', label:'Repuesta', template:'vtText', editoptions:{size:30, maxlength:30, placeholder:'Respuesta a su Pregunta Secreta'} });

      vfnCrearGrid({id:'vlogin',hide:true});
      $('#vlogin').jqGrid({
        url:"vloginregistro",
        colModel:vcolModel,
        cmTemplate:{ editable:true, editrules:{required:true, edithidden:true} }
      })
      .jqGrid('navGrid','#vloginPag',{ add:true },{},
        { beforeShowForm: function(form) {
          vfnGridFormulario({frm:form, trHide:'', caption:'Registro', width:650, center:true, top:80, labelBold:true });
            $('#sData').html(vfnFa('user-plus fa-2x text-success','Registrarse'));
            $('#cData').html(vfnFa('undo fa-2x text-danger','Cancelar'));
            $("#apellidos2").insertAfter("#apellidos1");
            $("#nombres2").insertAfter("#nombres1");
            $("#fax").insertAfter("#celular");
            $("#respuesta").insertAfter("#pregunta");
            $("#password2").insertAfter("#password");
            vfnGridTrRemove('apellidos2,nombres2,fax,idpersona,password2,respuesta');
            $('#vlogin').vfnEnabled('*',false);
            $('#cedula,#apellidos1').vfnEnabled();
            $('#correo').val('@gmail.com');
            $("#cedula").attr("onchange","vfnAjax('ajaxBuscarRegistro',{cedula:this.value});");
            $("#fnacimiento").datepicker({endDate:"0d", showOn:"focus", dateFormat:"dd-mm-yyyy"});
          },
          afterShowForm: function(form) {
            $("#cedula").focus();
          }
        }
      )
      .vfnGridConfigurar({});
      $('#add_vlogin_top').click();
    });

  </script>
