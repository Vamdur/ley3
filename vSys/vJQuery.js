(function ($) {


vfnPlayNext11 = function(){

}


  // Para Recortar Decimales
  Number.prototype.vFixed = function(digits) {
    var re = new RegExp("(\\d+\\.\\d{" + digits + "})(\\d)"),
        m  = this.toString().match(re);
    return m ? parseFloat(m[1]) : this.valueOf();
  };

/*

    function vfnPhp(lavariable){
      return "<?php echo($"+lavariable+");?>";
    }
*/
  vfnFormatoPetro = function(valor){
   //style: 'currency', currency: 'eur',
    return new Intl.NumberFormat('de-DE',{ minimumFractionDigits:8, maximumFractionDigits:8}).format(valor);
  }

  vfnCargar = function ( desde, div ){
    //if (desde.indexOf(".php")<=0) desde += ".php";
    if (typeof(div)==='undefined') { div='#inicioContenido'; }
    //$('#inicioCargando').show();
//document.body.style.overflowY = "hidden";
    //$('#inicioCargandoMensaje').html('Cargando...');
    if (div.indexOf("#")=== -1 )   { div='#'+div;}
    if (div==='#inicioContenido')  { $('#inicioContenido').html('');  }
    if (div==='#inicioContenido2') { $('#inicioContenido2').html(''); }

    //$("[id*=alertcnt_]").remove();
    //$("[id*=alertmod_]").remove();
    //$("[id*=alerthd_]").remove();

    $(div).load(desde, function(response,status,xhr) {
      $(div).show();
      $('#inicioCargando').hide();
//document.body.style.overflowY= "visible";
      // Cerrar Cualquier Ventana Abierta de Jqgrid
      $('.ui-jqdialog-titlebar-close').trigger('click');
      if (status==="error") {
        if (desde.indexOf("li=")!==0){
          var quitarLi = desde.substr(desde.indexOf("li=")+3).trim();
          var quitarLs = desde.substr(desde.indexOf("lis=")+4).trim();
          quitarLi = quitarLi.substr(0,quitarLi.indexOf("&lis")).trim();
          $("#"+quitarLi).remove();
          desde = '';
          if ($("#"+quitarLs+" li").length===0){
            $("#"+quitarLs).remove();
          }
        }
        vJsMsg({msg:"e|Inconveniente al procesar la Opción.<br>"+desde+"<br># Error: "+xhr.status+" "+xhr.statusText+"<br><br>Comuníquese con el Administrador del Sistema.", seg:60, icon:'frown-o'});
      }
    });
    return this;
  }

  /* Crear Archivo: Excel, Texto, Pdf */
  vfnSysDoc = function(opciones) {
    var defaults = {
      php: '',
      doc: '',
      hoja: 1,
      i: 2,
      correo:'',
      asunto:'',
      pagina:{
        orientacion: 'vertical',
        horizontal: true,
        vertical: false
      },
      margen:{
        arriba: 0.5,
        derecha: 0,
        izquierda: 0,
        abajo: 0.5,
        cabeza: 0.25,
        pie: 0.25
      },
      vGrid: '',
      grid: '',
      datos: null,
      //html: true,
      //sql: null,
      //cParametros: null,
      //vars: null
    };
    var vVar = $.fn.extend(defaults, opciones);

    // Si no se EJECUTA la acción favor VERIFICAR
    // si están Bloqueadas las Ventanas Emergentes del Navegador.

    $.ajax({
      async: true,
      type: "POST",
      dataType: "html",
      ContentType: "application/x-www-form-urlencoded",
      url: "vSys/sysDocumento.php",
      data: { vVar },
      beforeSend: function() {
        $('#inicioCargando').show();
      },
      success: function(datos) {
        //vfnAdvertencia('');
        $('#inicioCargando').hide();
        $('#inicioControlador').html(datos);
      }
    });
    return this;
  }
  /* fin Crear Archivo: Excel Texto, Pdf */


  vfnCargarArchivo = function(opciones) {
    var defaults = { php:'', ext:'.xls', idfk:0, vGrid:'', grid:'ElGridReload', tkb:'', proceso:'', linea:'2', carpeta:'', nombre:'', titulo:'Leer Archivo' };
    var vVar = $.fn.extend(defaults, opciones);

    if (vVar.php.indexOf(".php")=== -1) {vVar.php=vVar.php+'.php';}

    $('#sysDoc').data('php',vVar.php);
    $('#sysDoc').data('ext',vVar.ext);
    $('#sysDoc').data('linea',vVar.linea);
    $('#sysDoc').data('proceso',vVar.proceso);
    $('#sysDoc').data('vGrid',vVar.vGrid);
    $('#sysDoc').data('grid',vVar.grid);
    $('#sysDoc').data('carpeta',vVar.carpeta);
    $('#sysDoc').data('nombre',vVar.nombre);
    $('#sysDoc').data('tkb',vVar.tkb);
    $('#sysDoc').data('titulo',vVar.titulo);
    $('#sysDoc').data('idfk',vVar.idfk);
    vfnCargar('vSys/sysArchivo.php',"#inicioLeerArchivo");
    // el Original antes era vfnArchivo2.php
    return this;
  }

  // Cargar Camara
  vfnCamara = function(opciones) {
    // Si kb=''  Es una Foto de Persona = sysFotoKb
    // Si kb='0' Es una Imagen Cualquiera (Ejemplo: Mapa, Arbol, Vaucher) = sysImagenKb
    var defaults = { idfoto:0, nombre:'', sexo:'M', kb:'', grid:'#elGridReload', camara:true, adjuntar:true, perfil:false, carpeta:'fotos' };
    var vVar = $.fn.extend(defaults, opciones);

    if (vVar.nombre==='') vVar.nombre = vVar.idfoto;

    $('#sysFoto').data('idfoto',vVar.idfoto)
                 .data('nombre',vVar.nombre)
                 .data('sexo',vVar.sexo)
                 .data('grid',vVar.grid)
                 .data('camara',vVar.camara)
                 .data('adjuntar',vVar.adjuntar)
                 .data('perfil',vVar.perfil)
                 .data('carpeta',vVar.carpeta)
                 .data('kb',vVar.kb);

    vfnCargar('vSys/sysFoto.php?idfoto='+vVar.idfoto+'&sexo='+vVar.sexo+'&grid='+escape(vVar.grid)+'&camara='+vVar.camara+'&adjuntar='+vVar.adjuntar+'&perfil='+vVar.perfil+'&carpeta='+vVar.carpeta+'&kb='+vVar.kb, '#inicioLeerArchivo');
    return this;
  }

  // Cargar Grafico
  vfnGrafico = function(opciones) {
    var defaults = { idgrafico:'', gfechas:true };
    var vVar = $.fn.extend(defaults, opciones);
    vfnCargar('vSys/sysGrafico.php?idgrafico='+vVar.idgrafico+'&gfechas='+vVar.gfechas, '#inicioLeerArchivo');
    return this;
  }

  // Cargar Cuadro-Pivot
  vfnPivot = function(opciones) {
    var defaults = { idpivot:'', gfechas:true };
    var vVar = $.fn.extend(defaults, opciones);
    vfnCargar('vSys/sysPivot.php?idpivot='+vVar.idpivot+'&gfechas='+vVar.gfechas, '#inicioLeerArchivo');
    return this;
  }

  // Cargar Archivo Php
  vfnCargarPhp = function(opciones) {
    var defaults = { php:'', grid:'', idfk:0, idfk2:0, idfk3:0, maximizar:false, op:{entrar:true, mt:false} };
    var vVar = $.fn.extend(defaults, opciones);
    if ($("#sysSistema").data("desktop")==='mobil') { vVar.maximizar=true; }
    if (vVar.op.mt){
      vfnAviso({taviso:'Mantenimiento'});
    }else if (!vVar.op.entrar){
      vfnAviso({taviso:'SinPermiso'});
    }else{
      $('#sysGrid').data('maximizar',vVar.maximizar);
      vfnCargar('vSys/sysCargarPhp.php?php='+vVar.php+'&grid='+vVar.grid+'&idfk='+escape(vVar.idfk)+'&idfk2='+escape(vVar.idfk2)+'&idfk3='+escape(vVar.idfk3),'#inicioLeerArchivo');
    }
    return this;
  }

  // Cargar Archivo Php
  vfnCargarProceso = function(opciones) {
    var defaults = { php:'', grid:'', vGrid:'', msg:''};
    var vVar = $.fn.extend(defaults, opciones);

    $('#sysVar').data('vGrid', vVar.vGrid);
    $('#sysVar').data('grid', vVar.grid);
    vfnCargar('vSys/sysCargarProceso.php','#inicioLeerArchivo');

    return this;
  }

  vfnAviso = function(opciones) {
    var defaults = { tit:'', stit:'', tp:'w', icon:'warning', msg:'', taviso:'', nimg:'candado.gif', wimg:'100', himg:'100' };
    var vVar = $.fn.extend(defaults, opciones);
    var msgP = "";

    if (vVar.taviso.toLowerCase()==='seguridad'){
      if (vVar.tit==='') { vVar.tit='Seguridad'; }
      vVar.stit='Seguridad'; vVar.icon='key';
      vVar.msg="Es necesario <a style=\'color:blue; text-decoration:underline;\' href=\'#\' onclick=\'vfnCargar(&#39;vSys/vLoginSesionPerfil.php&#39;)\'; ><i>CAMBIAR</i></a> su Contraseña/Clave,<br> para tener acceso a esta opción.";
    }else if (vVar.taviso.toLowerCase()==='sinpermiso'){
      if (vVar.tit==='') { vVar.tit='Permisología'; }
      vVar.stit='Sin Permisología'; vVar.tp='e'; vVar.icon='lock';
      vVar.msg="Disculpe las molestias, no tiene <i style='color:red;'>Permiso</i> para ejecutar esta Opción.<br><br><b>Consultar con el Administrador del Sistema.</b>";
    }else if (vVar.taviso.toLowerCase()==='mantenimiento'){
      if (vVar.tit==='') { vVar.tit='Mantenimiento'; }
      vVar.stit='Mantenimiento'; vVar.icon='wrench'; vVar.nimg='informatico2.gif';
      vVar.msg="Disculpe las molestias, la opción se encuentra <span style='color:red;'>INHABILITADA</span>.";
    }else if (vVar.taviso.toLowerCase()==='construccion'){
      if (vVar.tit==='') { vVar.tit='Construcción'; }
      vVar.stit='En Construcción'; vVar.tp='w'; vVar.icon='lightbulb-o'; vVar.nimg='informatico.gif'; vVar.wimg='150'; vVar.himg='150';
      vVar.msg="La opción se encuentra en la etapa de<br>Análisis y Diseño.";
    }else if (vVar.taviso.toLowerCase()==='bloqueo'){
      if (vVar.tit==='') { vVar.tit='Bloqueada'; }
      vVar.stitk='Bloqueada'; vVar.tp='e'; vVar.icon='lock';
      if (vVar.msg==='') { vVar.msg="Disculpe las molestias, la opción se encuentra <i style='color:red;'>Bloqueada</i> para Actualizar Datos."; }
    }

    vVar.msg="<p style='text-align:center;'>"+vVar.msg+"<br></p>";

    if (vVar.tit==='') { vVar.tit='Atención'; }

    if (vVar.nimg!==''){
      msgP += "<p style='text-align:center;'><img id='inicioImagen' src='vSys/img/"+vVar.nimg+"' width="+vVar.wimg+"px height="+vVar.himg+"px/></p>";
    }
    if (vVar.stit!=''){
      vVar.msg = "<p style='color:red;font-size:150%;text-align:center;'>"+vVar.stit+"</p>"+vVar.msg;
    }

    msgP += vVar.msg;

    vJsPanelRemove();
    vJsMsg({msg:vVar.tp+'|'+msgP, icon:vVar.icon, tit:vVar.tit, animateIn:'zoomIn',animateOut:'zoomOut'});
    return this;
  }

  // Limpiar Div del Grafico, Cuadro
  vfnChartLimpiar = function (msg=''){
    //vfnFa('pie-chart')+vfnFa('bar-chart')+vfnFa('line-chart')+vfnFa('area-chart')+vfnFa('table')+
    html = '<p style="text-align:center;"><img src="vSys/img/grafico.jpeg" height="80%"><br><b>'+msg+'</b></p>';
    $("#chartDiv").html(html).removeClass('text-danger').removeClass('text-primary');
    if (msg!==''){
      $("#chartDiv").addClass('text-danger');
    }else{
      $("#chartDiv").addClass('text-primary');
    }
    $('#btnGraficar').show();
  }

  // Simular Enter
  $.fn.vfnKeyEnter = function( ) {
    $(this).focus().trigger($.Event('keydown',{which:13}));
    return this;
  }
  // Tambien: $("#selector").focus().trigger($.Event('keydown',{which:13}));

  /* Al Pulsar Enter pasar al siguiente Campo */
  $.fn.vfnEnter = function() {
    return this.each(function() {
      $(this).bind("keypress", function(event) {
        if (event.keyCode == 13) {
          event.preventDefault();
          //var list = $("input:enabled[type=text]");
          var list = $("input:enabled");
          if ( $(this).prop('required') && $(this).val() == '' ) {
            /* No saltar, porque es Requerido */
          }else{
            list.eq(list.index(this)+1).focus().select();
          }
        }
      });
    });
  }
  /* fin Al Pulsar Enter pasar al siguiente Campo */

  // Colocar un Icono y Texto
  vfnFa = function(icon,text){
    if (typeof(icon)==='undefined') { icon='thumbs-up'; }
    if (typeof(text)==='undefined') { text=''; }
    return "<i class='fa fa-"+icon+"'></i> "+text+"";
  }

  // Teclas
  vfnF5 = function (){
    document.oncontextmenu = function(){return false};
    shortcut.add("F3", function() {});
    shortcut.add("F6", function() {});
    shortcut.add("F5", function() {});
    shortcut.add("Ctrl+S", function() {});
    shortcut.add("Ctrl+R", function() {});
    shortcut.add("F7", function() {});
    shortcut.add("F12",function() {});
    return false;
  }

  // Pitido
  vfnBeep = function(){
    var snd = new Audio("data:audio/wav;base64,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qJrx4KOQjahZxWbcZgztj2c49nKmkId44S71j0c8eV9yDK6uPRzx5X18eDvjvQ6yKo9ZSS6l//8elePK/Lf//IInrOF/FvDoADYAGBMGb7FtErm5MXMlmPAJQVgWta7Zx2go+8xJ0UiCb8LHHdftWyLJE0QIAIsI+UbXu67dZMjmgDGCGl1H+vpF4NSDckSIkk7Vd+sxEhBQMRU8j/12UIRhzSaUdQ+rQU5kGeFxm+hb1oh6pWWmv3uvmReDl0UnvtapVaIzo1jZbf/pD6ElLqSX+rUmOQNpJFa/r+sa4e/pBlAABoAAAAA3CUgShLdGIxsY7AUABPRrgCABdDuQ5GC7DqPQCgbbJUAoRSUj+NIEig0YfyWUho1VBBBA//uQZB4ABZx5zfMakeAAAAmwAAAAF5F3P0w9GtAAACfAAAAAwLhMDmAYWMgVEG1U0FIGCBgXBXAtfMH10000EEEEEECUBYln03TTTdNBDZopopYvrTTdNa325mImNg3TTPV9q3pmY0xoO6bv3r00y+IDGid/9aaaZTGMuj9mpu9Mpio1dXrr5HERTZSmqU36A3CumzN/9Robv/Xx4v9ijkSRSNLQhAWumap82WRSBUqXStV/YcS+XVLnSS+WLDroqArFkMEsAS+eWmrUzrO0oEmE40RlMZ5+ODIkAyKAGUwZ3mVKmcamcJnMW26MRPgUw6j+LkhyHGVGYjSUUKNpuJUQoOIAyDvEyG8S5yfK6dhZc0Tx1KI/gviKL6qvvFs1+bWtaz58uUNnryq6kt5RzOCkPWlVqVX2a/EEBUdU1KrXLf40GoiiFXK///qpoiDXrOgqDR38JB0bw7SoL+ZB9o1RCkQjQ2CBYZKd/+VJxZRRZlqSkKiws0WFxUyCwsKiMy7hUVFhIaCrNQsKkTIsLivwKKigsj8XYlwt/WKi2N4d//uQRCSAAjURNIHpMZBGYiaQPSYyAAABLAAAAAAAACWAAAAApUF/Mg+0aohSIRobBAsMlO//Kk4soosy1JSFRYWaLC4qZBYWFRGZdwqKiwkNBVmoWFSJkWFxX4FFRQWR+LsS4W/rFRb/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////VEFHAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAU291bmRib3kuZGUAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAMjAwNGh0dHA6Ly93d3cuc291bmRib3kuZGUAAAAAAAAAACU=");
    snd.play();
    return true;
  }

  // Ejecutar un Audio
  vfnAudio = function(opciones) {
    var defaults = { wav:'vSys/sounds/default.wav', seg:6 };
    var vVar = $.fn.extend(defaults, opciones);
    var xAudio = document.getElementById("inicioSonido");
    $('#inicioSonido').attr('src',vVar.wav+'?'+Math.random());
    xAudio.play();
    setTimeout(function(){ xAudio.pause(); },(vVar.seg*1000));
    return false;
  }


/// Revisar desde aqui


  //http://www.etnassoft.com/2011/08/16/como-obtener-el-tipo-de-datos-preciso-de-una-variable-en-javascript/
  // var fecha=new Date();


  vfnDiaSemana = function (fecha){
    var dias  = ['Domingo','Lunes','Martes','Miercoles','Jueves','Viernes','Sabado'];
    var fecha = new Date(fecha);
    return dias[fecha.getUTCDay()];
  //  console.log(dias[fecha.getDay()]);
  }


  vfnLimpiarInicio = function ( ){
    $('#inicioContenido').html('');
    vfnTitulo({titulo:'', icono:''});
    return this;
  }





  vfnImprimirUrl = function (url,n,w,h){
    if ( typeof(n)==='undefined') { n='Sistema'; }
    if ( typeof(w)==='undefined') { w=940; }
    if ( typeof(h)==='undefined') { h=480; }
    //https://es.stackoverflow.com/questions/205670/centrar-ventana-modal-window-open-con-javascript
    var dualScreenLeft = window.screenLeft != undefined ? window.screenLeft : window.screenX;
    var dualScreenTop  = window.screenTop != undefined ? window.screenTop : window.screenY;

    var width  = window.innerWidth  ? window.innerWidth : document.documentElement.clientWidth ? document.documentElement.clientWidth : screen.width;
    var height = window.innerHeight ? window.innerHeight : document.documentElement.clientHeight ? document.documentElement.clientHeight : screen.height;

    var h = height-100;
    var left = ((width / 2) - (w / 2)) + dualScreenLeft;
    var top  = ((height / 2) - 220 ) + dualScreenTop;

    var newWindow = window.open(url,n,'width='+w+',height='+h+',top='+top+',left='+left+',toolbar=no,location=no,status=no,menubar=no,scrollbars=yes,directories=no,resizable=no');

    // Puts focus on the newWindow
    if (window.focus) newWindow.focus();
    return false;
  }

  vfnGraficar = function(opciones) {
    var defaults = {
      id:  '1',
      div: 'chartDiv',
      frm: {},
      opc: {},
      height:0
    };
    var vVar = $.fn.extend(defaults, opciones);
    $("[id*=jsPanel").remove('');
    var chart;
    $.post("vSys/mGraficoCtrl.php",
      {vGrafico:vVar.id, vFormulario:vVar.frm, vOpciones:vVar.opc},
      function(datos){
        if (datos['series'].length!==0){
          //var chart;
          chart = AmCharts.makeChart(vVar.div,vfnChart({config:datos['config'],series:datos['series']}));
          chart.validateData();
          chart.validateNow();
          chart.animateAgain();
          if (vVar.height===0) vVar.height = $(window).height()-300;
          $('#'+vVar.div).css({height:vVar.height}).prop({hidden:false});
        }else{
          $('#'+vVar.div).css({height:'30px'}).prop({hidden:true});
          jError(datos['config']['error']);
        }
      },'json');
    return this;
  }




/////////////// A partir de aqui Revisar //////////////






  //////////////

  //https://jqueryui.com/datepicker/#date-range
  //https://api.jqueryui.com/datepicker/#option-showOptions
  //http://www.daterangepicker.com/
  //http://www.malot.fr/bootstrap-datetimepicker/demo.php
  //https://www.grocerycrud.com/forums/topic/1597-como-configurar-mi-datepicker-para-no-mostrar-fechas-futuras/


  $.fn.vfnCboSelectJson = function( opciones ) {
    var defaults = { opcion:':Seleccionar;', selected:'', remove:false, todos:'' };
    var vVar = $.fn.extend(defaults, opciones);
    $(this).html('');
    var numbers = vVar.opcion.split(';');
    for(var i = 0; i < numbers.length; i++){
      var xtrue = false;
      if (vVar.selected === numbers[i].split(':')[0] ) xtrue = true;
      $(this).append(new Option( numbers[i].split(':')[1] , numbers[i].split(':')[0] , true, xtrue));
    }
    // Eliminar la Opcion Seleccionar Si solo existe una Opcion
    //if ( $('#'+this.prop('id')+' option').size()===2 ) $("#"+this.prop('id')+" option[value='']").remove();
    if (vVar.remove) $("#"+this.prop('id')+" option[value='']").remove();
    if (vVar.todos!=='') $("#"+this.prop('id')+" option[value='']").html(vVar.todos);
    return this;
  }

  // Eliminar la Opcion Seleccionar Si solo existe una Opcion
  $.fn.vfnSelectRemove = function(remove) {
    if (typeof(remove)==='undefined') { remove=false; }
    if ($(this).find('option').length===2) { $("#"+this.prop('id')+" option[value='']").remove(); }
    if (remove) { $("#"+this.prop('id')+" option[value='']").remove(); }
    return this;
  }

  vfnGetDate = function(element) {
    var date;
    try {
      date = $.datepicker.parseDate("dd/mm/yy",element.value);
    } catch( error ) {
      date = null;
    }
    return date;
  }

  vfnVentanasEmergentes = function (){
    var popUp = window.open('','userConsole','width=5,height=5,left=0,top=0,scrollbars,resizable');
    if (popUp == null || typeof(popUp)=='undefined') {

      msg  = "<b></b>";
      msg += "Favor DESHABILITAR el bloqueador de ventanas emergentes del <i><b>Navegador</i></b>, de lo contrario no se podrán ejecutar algunas funciones básicas del Sistema, como Imprimir/Guardar entre otras.<br>";
      //msg += "En Windows <i class='fa fa-2x fa-windows'></i><br>";
      //msg += "&nbsp;&nbsp;<i class='fa fa-navicon'></i> Herramientas<br>";
      //msg += "&nbsp;&nbsp;<i class='fa fa-cog'></i> Opciones<br>";
      //msg += "&nbsp;&nbsp;<i class='fa fa-lock'></i> Privacidad y Seguridad<br>";
      //msg += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Permisos<br>";
      //msg += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i class='fa fa-square-o'></i> Bloquear ventanas emergentes<br><br>";

      //msg += "En Linux <i class='fa fa-2x fa-linux'></i><br>";
      //msg += "&nbsp;&nbsp;<i class='fa fa-navicon'></i> Abrir Menú<br>";
      //msg += "&nbsp;&nbsp;<i class='fa fa-cog'></i> Preferencias<br>";
      //msg += "&nbsp;&nbsp;<i class='fa fa-lock'></i> Privacidad y Seguridad<br>";
      //msg += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Permisos<br>";
      //msg += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<i class='fa fa-square-o'></i> Bloquear ventanas emergentes";
      vJsMsg({msg:'w2|'+msg, tit:'Leer antes de continuar'});

    }else{
      popUp.close();
    }
    return;
  }


  $.fn.blink = function(options) {
    //https://jsfiddle.net/Sk8erPeter/Yca4Z/
    var defaults = { delay:500 };
    var options = $.extend(defaults, options);

    return this.each(function() {
      var obj = $(this);
      setInterval(function() {
        if ($(obj).css("visibility") == "visible") {
            $(obj).css('visibility', 'hidden');
        }
        else {
            $(obj).css('visibility', 'visible');
        }
      }, options.delay);
    });
  }

  /* Para Buscar una Cedula en Saime */
  $.fn.vfnBuscarCedula = function( donde ) {
    if ( typeof(donde)==='undefined') donde='';
    var id = "#"+this.prop('id');
    $("<span>&nbsp;&nbsp;</span><button id='btnCedula' class='btn btn-primary' type='button' title='Buscar Datos ' ><i class='fa fa-search'></i></button>").insertAfter(id);
    $('#btnCedula').attr('onclick', "vfnCedula('"+donde+"');");
    if ( donde.toLowerCase() ==='saime') $('#btnCedula').attr('title',"Buscar Datos en el Saime");
    return this;
  }

  vfnCedula = function ( donde, preF, pasar ){
    if ( typeof(donde)==='undefined') donde='';
    if ( typeof(preF)==='undefined')  preF ='';
    if ( typeof(pasar)==='undefined') pasar='';
    var datos;
    if (pasar===''){
      if ( vfnExiste("#FormError") ) $('#sData').hide();
    }

    $.post(
      "vSys/vfnCedula.php",
      { cedula: $("#"+preF+"cedula").val(),
        donde: donde
      },
      function(datos){
        datos = $.parseJSON(datos);
        if (datos.error === '' && $("#"+preF+"apellidos1").val()==='' ) {
          $("#"+preF+"apellidos1").val(datos.apellidos1);
          $("#"+preF+"apellidos2").val(datos.apellidos2);
          $("#"+preF+"nombres1").val(datos.nombres1);
          $("#"+preF+"nombres2").val(datos.nombres2);
          $("#"+preF+"sexo").val(datos.sexo);
          $("#"+preF+"fnacimiento").val(datos.fnacimiento);
          $("#"+preF+"correo").val(datos.correo);
          $("#"+preF+"login").val( datos.nombres1.substr(0,1).toLowerCase() +datos.apellidos1.toLowerCase() );

          if ( vfnExiste("#FormError") ) {
            $("#FormError").hide();
            $('#sData').show();
            $(".ui-state-error").html('');
          }

        }else{
          if ( vfnExiste("#FormError") ){
            $("#FormError").show();
            $(".ui-state-error").html(datos.error);
          }else{
            vfnError(datos.error);
          }
        }
      }
    );
    return datos;
  }
  /* fin Para Buscar una Cedula en Saime */


  vfnErrorValidador = function (validator) {
    $("#divError").show().html('Hay ' + validator.numberOfInvalids() + ' error' + (validator.numberOfInvalids() > 1 ? 'es' : '') + ' en los Datos.');
  }


  vfnFormatoNumero = function (amount, decimals) {
    if (typeof(decimals)==='undefined') decimals=2;
    amount += ''; // por si pasan un numero en vez de un string
    amount = parseFloat(amount.replace(/[^0-9\.]/g, '')); // elimino cualquier cosa que no sea numero o punto

    decimals = decimals || 0; // por si la variable no fue fue pasada

    // si no es un numero o es igual a cero retorno el mismo cero
    if (isNaN(amount) || amount === 0)
        return parseFloat(0).toFixed(decimals);

    // si es mayor o menor que cero retorno el valor formateado como numero
    amount = '' + amount.toFixed(decimals);

    var amount_parts = amount.split('.'),
        regexp = /(\d+)(\d{3})/;

    while (regexp.test(amount_parts[0]))
        amount_parts[0] = amount_parts[0].replace(regexp, '$1' + '.' + '$2');

    return amount_parts.join(',');
  }

  /* Verificar si Existe un Selector */
  vfnExiste = function(selector) {
    return ($(selector).length > 0);
  }





  /* fin Mensajes */
  vfnCargarMenu = function(sys) {
    if (sys.indexOf("/")<=0) sys += "/mnuPrincipal.php";
    $("#inicioMenu").html("");
    $.ajax({ async:true, type: "POST", dataType: "html", ContentType: "application/x-www-form-urlencoded", url: sys,
      success: function(datos) { $('#inicioControlador').html(datos); }
    });
    return this;
  }
/*
<li id='mnuIcoMenu' class="nav-item" title="Contraer/Expandir Menú Principal">
          <a class="nav-link" data-widget="pushmenu" href="#"><i class="fa fa-bars fa-1x"></i></a>
        </li>
        <li id='mnuIcoBuscar' class="nav-item" title="Buscar..." style='display:none;' >
          <a class="nav-link" href="#"><i class="fa fa-search fa-1x"></i></a>
        </li>
        <li id='mnuIcoAyuda' class="nav-item" title="Ayuda..." style='display:none;' >
          <a class="nav-link" href="#"><i class="fa fa-question fa-1x"></i></a>
        </li>

        <li id="mnuIcoSesion" class="nav-item" title="Iniciar Sesión">
          <a href="#" class="nav-link">
            <img id="sysUsuario" onclick="vfnCargar('vSys/vLoginSesionIniciar.php');" src="vSys/img/fotoM.png" class="img-circle" style="width:25px; height:25px;" alt="Usuario" >
          </a>
        </li>

        <li id="mnuIcoCerrar" class="nav-item" title='Cerrar Sesión' style='display:none;'>
          <a class="nav-link" href="#" onclick="vfnCargar('vSys/vLoginSesionCerrar.php');"><i class="fa fa-2x fa-sign-out"></i></a>
        </li>

*/
  vfnCrearMenuIco = function(opciones) {
    var defaults = { id:'mnuIcoVacio', after:'mnuIcoMenu', title:'', php:'', click:false, icon:'dot-circle-o', maximizar:true
      };
    var vVar = $.fn.extend(defaults, opciones);

        //      vfnCargarPhp({php:'../sysCM/sysSM/vHcm.php', maximizar:true});

      contenido  = '<li id="'+vVar.id+'"';
      contenido += 'class="nav-item" >';
      contenido += '<a class="nav-link" href="#" onclick="';

     // if (vVar.click===false){
        contenido += 'vfnCargar(\''+vVar.php+'\');';
     // }else{
     //   contenido += 'vfnCargarPhp({php:\''+vVar.php+'\', maximizar:true});';
     // }

      contenido += '" ><i class="fa fa-'+vVar.icon+'"></i></a>';
      contenido += '</li>';
      $(contenido).insertAfter('#'+vVar.after);
      //$('#'+selector).append(contenido);
    return this;
  }



  vfnCrearMenu = function(opciones) {
    var defaults = { id:'vacio', ids:'inicioMenu', clase:'', titulo:'', onclick:'', icono:'dot-circle-o',
     label:'', labelColor:'danger', tf:'1' };
    var vVar = $.fn.extend(defaults, opciones);
    var selector = vVar.ids;

    //if (vVar.labelColor==='' || vVar.labelColor){
    //vVar.labelColor='danger';
    //}

    if (vVar.tf==='1'){
      vVar.icono=vVar.icono.replace(' ','');
      vVar.icono=vVar.icono.replace('+',' ');
      contenido = '<li ';
      if ( vVar.clase==='titulo' ){
        contenido += ' class="nav-header">'+vVar.titulo;
      }else if ( vVar.clase==='menu' ){
        contenido += 'id="'+vVar.id+'" class="nav-item has-treeview"><a href="#" class="nav-link"><i class="nav-icon fa fa-'+vVar.icono+'"></i><p>'+vVar.titulo+'</p>';
        contenido += '<small class="badge badge-'+vVar.labelColor+' pull-right">'+vVar.label+'</small>';
        contenido += '<i class="right fa fa-angle-left pull-right"></i>';
        contenido += '</a><ul class="nav nav-treeview"></ul>';
      }else{
        contenido += 'id="'+vVar.id+'" class="nav-item"><a href="#" class="nav-link">';
        if (vVar.ids!=='inicioMenu') contenido += '&nbsp;&nbsp;&nbsp;';
        contenido += '<i class="fa fa-'+vVar.icono+' nav-icon"></i><p>'+vVar.titulo+'</p>';
        contenido += '<small class="badge badge-'+vVar.labelColor+' pull-right">'+vVar.label+'</small>';
        contenido += '</a>';
      }
      contenido += '</li>';

      if (vVar.ids!=='inicioMenu') { selector = 'inicioMenu>#'+vVar.ids+'>ul'; }

      $('#'+selector).append(contenido);

      if (vVar.onclick!==''){

        if (vVar.onclick.indexOf(".php")<=0){

          $('#'+vVar.id).attr('onclick',"$('#inicioTitulo,#inicioSubTitulo,#inicioContenido').html('').hide();this.remove();vJsPanelRemove();vJsMsg({msgC:'center', msg:'e|Aviso|"+vVar.onclick+"'});");
        //  $('#'+vVar.id).attr('onclick',"$('#inicioTitulo,#inicioSubTitulo,#inicioContenido').html('').hide();vJsPanelRemove();"+vVar.onclick);

        }else{

          if (vVar.onclick.indexOf("?")<=0){
            vVar.onclick += '?';
          }else{
            vVar.onclick += '&';
          }

          vVar.onclick += 'li='+vVar.id+'&lis='+vVar.ids;
          $('#'+vVar.id).attr('onclick',"$(this).hide(); $('#inicioTitulo,#inicioSubTitulo').html('').hide();$('#inicioCargando').show();$('#inicioContenido').html('').hide(); vfnCargar('"+vVar.onclick+"');   $(this).show(10); ");

//setTimeout(function(){  },3000);


        }
      }
    }
    return this;
  }

  $.fn.vfnCrearTabs = function(opciones) {
    var defaults = { tab:'1', col:'', opcion:'', colclass:'sm-6', click:'', titulo:'Titulo', alinear:'', icono:'', grid:'', activo:false, hidden:false };
    var vVar = $.fn.extend(defaults, opciones);
    vVar.activo = (vVar.activo) ? 'active':'';
    var contenido = "";
    if (vVar.tab==='1'){
 //https://www.w3schools.com/bootstrap/bootstrap_tabs_pills.asp
      $(this).html("<ul class='nav nav-tabs'></ul><div class='tab-content'></div>").addClass("nav-tabs-custom");
    }

    if ( (vVar.col==='' || vVar.col==='1') && vVar.tab.toLowerCase().indexOf("dropdown")<=-1 ){
      vVar.hidden = (vVar.hidden) ? 'style="display:none;"':'';
      contenido = "<li id='li"+vVar.tab+"' class='"+vVar.activo+"' "+vVar.hidden+" ><a aria-expanded='false' href='#tab"+vVar.tab+"' data-toggle='tab'><i class='fa fa-"+vVar.icono+"'></i> "+vVar.titulo+"</a></li>";
      $("#"+this.prop('id')+">ul").append(contenido);
      contenido = "<div id='tab"+vVar.tab+"' class='tab-pane "+vVar.activo+"'>";
      if (vVar.col==='1') contenido += "<div class='row'></div>";
      contenido += "</div>";
      $("#"+this.prop('id')+">.tab-content").append(contenido);

    }else if (vVar.tab.toLowerCase().indexOf("dropdown") > -1){
      if( vVar.opcion==='' ){
        contenido = "<li class='dropdown pull-"+vVar.alinear+"' id='"+vVar.tab+"'><a aria-expanded='false' class='dropdown-toggle' data-toggle='dropdown' href='#' class='text-muted'><i class='fa fa-"+vVar.icono+"'> </i> "+vVar.titulo+"<span class='caret'></span></a><ul class='dropdown-menu'></u></li>";
        $("#"+this.prop('id')+">ul").append(contenido);
      }else if( vVar.opcion.toLowerCase()==='linea' ){
        contenido = "<li role='presentation' class='divider'></li>";
        $("#"+this.prop('id')+">ul>#"+vVar.tab+">ul").append(contenido);
      }else if( vVar.opcion.toLowerCase()==='header' ){
        contenido = "<li role='presentation' class='dropdown-header'></li>";
        $("#"+this.prop('id')+">ul>#"+vVar.tab+">ul").append(contenido);
      }else{
        contenido = "<li role='presentation'><a role='menuitem' tabindex='-1' href='#' onClick="+vVar.click+"><i class='fa fa-"+vVar.icono+"'></i> "+vVar.titulo+"</a></li>";
        $("#"+this.prop('id')+">ul>#"+vVar.tab+">ul").append(contenido);
      }
    }

    if (vVar.col!==''){
      contenido = "<div id='tab"+vVar.tab+vVar.col+"' class='col-"+vVar.colclass+"'></div>";
      $("#"+this.prop('id')+">.tab-content>#tab"+vVar.tab+">.row").append(contenido);
    }

    if (vVar.grid!==''){
      contenido = "<div><table id='"+vVar.grid+"'></table></div><div id='"+vVar.grid+"Pag'></div>";
      if (vVar.col===''){
        $("#"+this.prop('id')+">.tab-content>#tab"+vVar.tab).append(contenido);
      }else{
        $("#"+this.prop('id')+">.tab-content>#tab"+vVar.tab+">.row>#tab"+vVar.tab+vVar.col).append(contenido);
      }
    }
    return this;
  }

  $.fn.vfnRequired = function(opciones) {
    var defaults = { grid:'', required:false, disabled:false };
    var v = $.fn.extend(defaults, opciones);

    if (v.grid!=='' && v.grid.indexOf("#")<0) {
      v.grid = "#"+v.grid;
    }
    var color = (v.disabled===false) ? 'white':'#F2F2F2';

    $(this).each(function( index, idS ) {
      $("#"+idS.id).prop({'disabled':v.disabled, 'required':v.required}).css({'background':color});
      if (v.grid!==''){
        $(v.grid).setColProp(idS.id, {editrules:{required: v.required }});
      }
    });
    return this;
  }




  // La que Esta Funcionando al Pelo
  $.fn.vfnEnabled = function(idS, xDisabled) {
    if ( arguments.length===0 ) {
      idS='', xDisabled=true;
    }else if ( arguments.length===1 && idS==='*' ){
      xDisabled=true;
    }else if (arguments.length===1 && idS!=='*') {
      xDisabled=idS; idS='';
    }

    var color = (!xDisabled) ? '#F2F2F2':'white';
    if ( idS==='*'){
      $("#FrmGrid_"+this.prop('id')+" input").prop('disabled',!xDisabled).css({'background':color});
      $("#FrmGrid_"+this.prop('id')+" select").prop('disabled',!xDisabled).css({'background':color});
      $("#FrmGrid_"+this.prop('id')+" textarea").prop('disabled',!xDisabled).css({'background':color});


      $("#FrmGrid_"+this.prop('id')+" [id*=_chosen").prop('disabled',!xDisabled).css({'background':color});


     //$("[id*=jsPanel").remove('');
    //idtguiafk_chosen

    }else{
      $(this).each(function( index, id ) {
        $("#"+id.id).prop({'disabled':!xDisabled}).css({'background':color});
      });
    }
    return this;
  }



  /* Setear Disabled a un Id o Varios */
  // Ejemplo: vfnSetDisabled("cedula,nombres");
  vfnSetDisabled = function(ids, disabled) {
    var color ='white';
    if (typeof(disabled)==='undefined') disabled='disabled';
    if (typeof(disabled)==="boolean"){
      if (disabled===true){
        disabled='disabled';
      }else{
        disabled='';
      }
    }

    color='white';
    if (disabled==='disabled') color='#F2F2F2';

    //if (typeof(disabled)==="boolean" && disabled===true) disabled='disabled';

    if (ids==='*'){

      $("input,select,.FormElement").prop('disabled',disabled).css({'background':color});

    }else{

      $.each( ids.split(','), function(index, item) {
        item = '#'+item.trim().replace('#','');
        $(item).prop({'disabled':disabled}).css({'background':color});
      });

    }
    return this;
  }
  $.fn.vfnSetDisabled = function(disabled) {
    if (typeof(disabled)==='undefined') disabled='disabled';
    var id = "#"+this.prop('id');
    vfnSetDisabled( id, disabled );
    return this;
  }
  /* fin Setear Disabled a un Id o Varios */




  /* Titulo de la Vista */
  vfnTitulo = function(opciones) {
    //http://fontawesome.io/examples/#
    var defaults = {
      titulo:'',
      subTitulo:'',
      icono:'home',
      url:'vSys/img/',
      tIcono:'fa',
      hlp:'',
      hlpTitle:'Ayuda'
    };
    var vVar = $.fn.extend(defaults, opciones);

    if ( vVar.titulo.indexOf("|") >= 0 ){
      vVar.subTitulo = vVar.titulo.split('|')[1];
      vVar.titulo    = vVar.titulo.split('|')[0];
    }

    $('#mnuIcoAyuda,#inicioLeer,#inicioTitulo,#inicioSubTitulo').hide();
    $('#mnuIcoAyuda').attr('onclick','');
    $('#inicioBody').removeClass('control-sidebar-slide-open');
    $("#inicioContenido2").html("");



    if (vVar.titulo!==''){
      $("#inicioTitulo").show().html("<i id='inicioTituloIcono' class='"+vVar.tIcono+" "+vVar.tIcono+"-"+vVar.icono+" "+vVar.tIcono+"-1x'></i>&nbsp;&nbsp;"+vVar.titulo);
    }
    if (vVar.subTitulo!==''){
      $("#inicioSubTitulo").show().html("&nbsp;&nbsp;"+vVar.subTitulo);
    }
    // Para que los Menus de los Tabs de Desplieguen hacia abajo
    $('.dropdown-toggle').dropdown();

    $('#inicioSesion').html('').hide();
    $('#inicioCaptch').hide();

    $("[id*=jsPanel").remove('');
    $("#phpJpanel").remove(); // Si he llamado un Php como Ayuda

    // Esto es para colocar el Color de los Formularios
    $(".card-header").addClass($("#sysSistema").data("skin-frm"));
    $("button").addClass($("#sysSistema").data("skin-frm-btn"));
    //$('#inicioTituloIcono').attr('onclick',"vfnGridResize();jError('Aviso|Elementos de la Pantalla Ajustados Automaticamente.');");
    //$('#inicioTituloIcono').attr({'onclick':"vfnGridResize();",'title':'Ajustar elementos de la Pantalla'});

    if (vVar.hlp!==''){
      if (vVar.hlpTitle==='Ayuda' && vVar.titulo!=='') vVar.hlpTitle = vVar.titulo;
      $("#mnuIcoAyuda").show().attr('onclick',"vfPanelAyuda({hlp:'"+vVar.hlp+"',hlpTitle:'"+vVar.hlpTitle+"'});");
    }
    // Si el Formulario Tiene Grafico debe llamarse #grafico y estar oculto
    $('#grafico').hide();
    return this;
  }
  /* fin Titulo de la Vista */

  /* Desactivar Opcion del Menu */
  vfnMenuEnabled = function(opciones) {
    var defaults = { li:'', lis:'', php:'', form:'' };
    var vVar = $.fn.extend(defaults, opciones);

    if ( vVar.form !== '' ){
      $.post("vSys/vfnValidarFormularioAjax.php",
        { form: vVar.form },
        function(datos){
          datos = $.parseJSON(datos);
          if ( datos.entrar ){
            if ( vVar.php !== '' ) vfnCargar(vVar.php);
          }else{
            if ( vVar.php !== '' ) {
              vfnPermiso({tf:false});
              vfnTitulo({titulo:"",icono:'lock'});
            }
            $("#"+vVar.li).remove();
            if ( vVar.lis !== '' ){
              if ( $("#"+vVar.lis+" li" ).size()===0) $("#"+vVar.lis).remove();
            }
          }
        }
      );
    }
    return this;
  }
  /* fin Desactivar Opcion del Menu */


  /* Desactivar Opcion del Menu */
  vfnMenuDisabled = function(opciones) {
    var defaults = { li:'', lis:'', form:'', soloChequeo:'' };
    var vVar = $.fn.extend(defaults, opciones);
    if ( vVar.form !== '' ){
      $.post("vSys/vfnValidarFormularioAjax.php",
        { form: vVar.form, soloChequeo: vVar.soloChequeo },
        function(datos){
          datos = $.parseJSON(datos);
          if ( !datos.entrar ){
            $("#"+vVar.li).remove();
            if ( vVar.lis !== '' ){
              if ( $("#"+vVar.lis+" li" ).size()===0) $("#"+vVar.lis).remove();
            }
          }
        }
      );
    }
    return this;
  }
  /* fin Desactivar Opcion del Menu */


  /* Cambiar Captcha */
  vfnCambiarCaptcha = function(xtrue,logintud) {
    if ( typeof(xtrue)==='undefined') xtrue='true';
    if ( typeof(logintud)==='undefined') logintud=5;
    vContrasena = generarPassword(logintud,"abcdefghijknmpqrstuvwxz23456789");
    /*
    var c6 = document.getElementById('btnCaptcha');
    var c6_context = c6.getContext('2d');
    c6_context.fillStyle = 'blue';
    c6_context.font = 'italic bold 20px sans-serif';
    c6_context.clearRect(0, 0, 100, 100);
    //c6_context.fillText(vContrasena, 0, 10);
    c6_context.fillText(vContrasena, 0, 15);
    */
    if ( xtrue==='true' ){
      $('#captcha').val('');
    }else{
      $('#captcha').val(vContrasena).hide();
    }
    $('#captcha2').val(vContrasena).hide();
    $('#btnCaptcha').html("<em><i><font size='3.5'><b style='color:red;letter-spacing:3pt;'>"+vContrasena+"</b></font></i></em>");
    //var my_random = (-15) + ( 15 - (-15) ) * Math.random() ;
    //$('#btnCaptcha').css({'-webkit-transform':'rotate('+my_random+'deg)'});
    return this;
  }
  /* fin Cambiar Captcha */

  generarPassword = function (longitud, chars){
    if (typeof(longitud)==='undefined') longitud=5;
    if (typeof(chars)==='undefined') chars="abcdefghijklmnopqrstuvwxyz0123456789";
    code = "";
    for (x=0; x < longitud; x++){
      rand = Math.floor(Math.random()*chars.length);
      code += chars.substr(rand, 1);
    }
    return code;
  }

  generarPassword2 = function(longitud,chars){
    if (typeof(longitud)==='undefined') longitud=5;
    if (typeof(chars)==='undefined') chars="abcdefghijklmnopqrstuvwxyz0123456789";
    code = "";
    for (x=0; x < longitud; x++){
      rand = Math.floor(Math.random()*chars.length);
      code += chars.substr(rand, 1);
    }
    return code;
  }


  /* Crear Archivo: Excel, Texto, Pdf */
  vfnDocumento = function(opciones) {
    var defaults = {
      php: '',
      archivo: '',
      html: true,
      listado: '',
      proceso: '',
      vGrid: '',
      datos: null,
      hoja: 1,
      tipo: 'Excel5',
      out: 'Excel5',
      orientacion: 'vertical',
      delimitador: '',
      sql: null,
      cParametros: null,
      vars: null,
      cHorizontal: true,
      cVertical: false,
      mArriba: 0.5,
      mDerecha: 0,
      mIzquierda: 0,
      mAbajo: 0.5,
      mCabeza: 0.25,
      mPie: 0.25
    };
    var vVar = $.fn.extend(defaults, opciones);

    //vfnAdvertencia("Si no se EJECUTA la acción favor VERIFICAR si están Bloqueadas las Ventanas Emergentes del Navegador.");
    $.ajax({
      async:true,
      type: "POST",
      dataType: "html",
      ContentType: "application/x-www-form-urlencoded",
      url: "vSys/vfnDocumento.php",
      data: { vVar },
      beforeSend: function() {
        $('#inicioCargando').show();
      },
      success: function(datos) {
        //vfnAdvertencia('');
        $('#inicioCargando').hide();
        $('#inicioControlador').html(datos);
      }
    });
    return this;
  }
  /* fin Crear Archivo: Excel Texto, Pdf */



  /* Abrir Libro de Excel */
  vfnExcel = function(opciones) {
    var defaults = {
      php: '',
      xls: '',
      listado: '',
      proceso: '',
      datos: null,
      hoja: 1,
      tipo: 'Excel5',
      out: 'Excel5',
      sql: null,
      cParametros: null,
      cHorizontal: true,
      cVertical: false,
      mArriba: 0.5,
      mDerecha: 0,
      mIzquierda: 0,
      mAbajo: 0.5,
      mCabeza: 0.25,
      mPie: 0.25
    };
    var vVar = $.fn.extend(defaults, opciones);

    if (vVar.xls==='') vVar.xls = vVar.php;

    //vfnAdvertencia("Si no se EJECUTA el Listado/Reporte, VERIFICAR si están Bloqueadas las Ventanas Emergentes del Navegador.");
    if (vVar.php!==''){
      $.ajax({
        async:true,
        type: "POST",
        dataType: "html",
        ContentType: "application/x-www-form-urlencoded",
        url: "vSys/vfnExcel.php",
        data: { vVar },
        beforeSend: function() {
          $('#inicioCargando').show();
        },
        success: function(datos) {
          vfnAdvertencia('');
          $('#inicioCargando').hide();
          $('#inicioControlador').html(datos);
        }
      });
    }else{
      jError('Falta Configurar el Archivo .php');
    }
    return this;
  }
  /* fin Abrir Libro de Excel */

// Abrir Documento de Word //
  vfnWord = function(opciones) {
    var defaults = {
      php: '',
      doc: 'Archivo.doc',
    };
    var vVar = $.fn.extend(defaults, opciones);

    $.ajax({
      async:true,
      type: "POST",
      dataType: "html",
      ContentType: "application/x-www-form-urlencoded",
      url: "vSys/vWord.php",
      data: { vVar },
      beforeSend: function() {
        $('#inicioCargando').show();
      },
      success: function(datos) {
        $('#inicioCargando').hide();
        $('#inicioControlador').html(datos);
      }
    });
    return this;
  }
// fin Abrir Documento de Word //


  vfnAjax = function (cGrid,mAjax){
    if (typeof(mAjax)==='undefined') mAjax={};
    if (typeof(mAjax['confirmar'])==='undefined'){
      $.post("vSys/mGridCT.php", {vGrid:cGrid,mAjax:mAjax},
        function(data){
          datos = $.parseJSON(data);
          $('#inicioControlador').html(datos.ejecutar);
        }
      );
    }else{
      jConfirmar(mAjax['confirmar'], function(){
        $.post("vSys/mGridCT.php", {vGrid:cGrid,mAjax:mAjax},
          function(data){
            datos = $.parseJSON(data);
            $('#inicioControlador').html(datos.ejecutar);
          }
        );
      });
    }
    return this;
  }

   vfnAjaxCorreo = function (cGrid,mAjax){
    if (typeof(mAjax)==='undefined') mAjax={};
    //if (typeof(mAjax['confirmar'])==='undefined'){
    $.post("vSys/sysCorreo.php", {vGrid:cGrid,mAjax:mAjax},
      function(data){
        if (data!==""){
          jError(data);
        }else{
          jAviso("<center>MENSAJE enviado correctamente al Correo.</center>") ;
        }
      }
    );
    return this;
  }

  vfnAjaxPermiso = function (frm){
    var varReturn;
    varReturn = {entrar:false, editar:false};
    $.post("vSys/mGridPermiso.php", {frm:frm},
      function(data){
        //return "<?php echo("+data+");?>;";
        alert('regreso');
        varReturn = {entrar:true, editar:true};
      }
    );
    return varReturn;
  }

  // El Mismo de Arriba pero el mAjax es un Formulario
  vfnAjaxFrm = function (cGrid,nForm){
    if ( nForm.indexOf("#") == -1 ) nForm = '#'+nForm;
    var fields = $(nForm).find('[disabled]');
    fields.prop('disabled',false);
    var mAjax = $(nForm).serializeFormJSON();
    fields.prop('disabled',true);
    vfnAjax(cGrid,mAjax);
    return this;
  }



  // var data = $(nombreFormulario).serializeFormJSON();
  $.fn.serializeFormJSON = function () {
    var o = {};
    var a = this.serializeArray();
    $.each(a, function () {
      if (o[this.name]) {
        if (!o[this.name].push) {
          o[this.name] = [o[this.name]];
        }
        o[this.name].push(this.value || '');
      } else {
        o[this.name] = this.value || '';
      }
    });
    //console.log( o);
    return o;
  };





  /* Mostrar Mensaje y Gif de Cargando */
  vfnCargando = function(vshow){
    if (typeof(vshow)==='undefined') vshow=true;
    if ( typeof vshow === 'string' ){
      msg   = vshow;
      if ( msg === '' ) msg = 'Cargando...';
      vshow = true;
    }else if ( typeof vshow === 'undefined' ){
      vshow = true;
    }
    if ( vshow ){
      $('#inicioCargando').show();
      $('#inicioCargandoMensaje').html(msg);
    }else{
      $('#inicioCargando').hide();
      $('#inicioCargandoMensaje').html('Cargando...');
    }
    return this;
  }
  /* fin Mostrar Mensaje y Gif de Cargando */

  // Formatear Numeros //
  // $("#number").vfnFormatoMonto();
  $.fn.vfnFormatoMonto = function(options) {
    //http://www.jose-aguilar.com/blog/formatear-numeros-con-jquery-pretty-number/
    var opts = $.extend({}, $.fn.vfnFormatoMonto.defaults, options);
    return this.each(function() {
      $this = $(this);
      var o = $.meta ? $.extend({}, opts, $this.data()) : opts;
      var str = $this.html();
      $this.html($this.html().toString().replace(new RegExp("(^\\d{"+($this.html().toString().length%3||-1)+"})(?=\\d{3})"),"$1"+o.delimiter).replace(/(\d{3})(?=\d)/g,"$1"+o.delimiter));
    });
  };
  $.fn.vfnFormatoMonto.defaults = {delimiter:'.'};
  // fin Formatear Numeros //



/*
  vfnVideo = function( video ) {
    setTimeout(function(){
        Shadowbox.open({
          //content: "<video controls autoplay width='100%' height='100%'><source src='sysCuerpoAgua/img/video.mp4' type='video/mp4'>Tu navegador no implementa el elemento <code>video</code></video>",
          //content: "<object id='swf_object' width='500' height='400' data='hola.wmv'></object>",
          player:  "html",
          title:   "Bienvenido",
          width:   810,
          height:  610
        });
        },50
    );
    return this;
  }

*/


  // Codificar Ciertos Caracteres
  $.fn.vfnEncode = function() {

    var xVal1 = $(this).val().trim();
    var xVal2 = $(this).val().toLowerCase().trim();

    xVal2 = xVal2.split("  ").join(' ');
    xVal2 = xVal2.split("  ").join(' ');

    xVal2 = xVal2.split('select').join('');
    xVal2 = xVal2.split('delete ').join('');
    xVal2 = xVal2.split('update').join('');
    xVal2 = xVal2.split('insert into').join('');

    xVal2 = xVal2.split('session').join('');
    xVal2 = xVal2.split('link').join('');

    xVal2 = xVal2.split('<meta').join('');
    xVal2 = xVal2.split('javascript').join('');
    xVal2 = xVal2.split('location').join('');
    xVal2 = xVal2.split('script').join('');
    xVal2 = xVal2.split('drop ').join('');
    xVal2 = xVal2.split(' from ').join('');
    xVal2 = xVal2.split('require').join('');
    xVal2 = xVal2.split('include').join('');
    xVal2 = xVal2.split('http').join('');
    xVal2 = xVal2.split('www').join('');
    xVal2 = xVal2.split('//').join('');
    xVal2 = xVal2.split('spam').join('');
    xVal2 = xVal2.split(';').join(',');
    xVal2 = xVal2.split('*').join('');

    xVal2 = xVal2.split('{').join('');
    xVal2 = xVal2.split('}').join('');
    xVal2 = xVal2.split('[').join('');
    xVal2 = xVal2.split(']').join('');
    xVal2 = xVal2.split('&').join('');
    xVal2 = xVal2.split('!').join('');
    xVal2 = xVal2.split("\n").join('');
    xVal2 = xVal2.split("\r").join('');
    xVal2 = xVal2.split('"').join('');
    xVal2 = xVal2.split("'").join('');
    xVal2 = xVal2.trim();

    $(this).val(xVal1).css({'color':'black'});

    if ( xVal1.length !== xVal2.length ) $(this).val(xVal2).css({color:'red'});
    return this;
  }
  // fin Codificar Ciertos Caracteres


  vfnFullScreen = function (){
    if (!document.fullscreenElement &&    // alternative standard method
        !document.mozFullScreenElement && !document.webkitFullscreenElement && !document.msFullscreenElement ) {  // current working methods
      if (document.documentElement.requestFullscreen) {
        document.documentElement.requestFullscreen();
      } else if (document.documentElement.msRequestFullscreen) {
        document.documentElement.msRequestFullscreen();
      } else if (document.documentElement.mozRequestFullScreen) {
        document.documentElement.mozRequestFullScreen();
      } else if (document.documentElement.webkitRequestFullscreen) {
        document.documentElement.webkitRequestFullscreen(Element.ALLOW_KEYBOARD_INPUT);
      }
    } else {
      if (document.exitFullscreen) {
        document.exitFullscreen();
      } else if (document.msExitFullscreen) {
        document.msExitFullscreen();
      } else if (document.mozCancelFullScreen) {
        document.mozCancelFullScreen();
      } else if (document.webkitExitFullscreen) {
        document.webkitExitFullscreen();
      }
    }
  }


// http://codeko.com/docs/oslgr/intro_jquery2/plugins.php

// http://www.nebaris.com/post/195/como-crear-un-plugin-jquery
// http://html5facil.com/tutoriales/como-crear-plugins-para-jquery/

// http://learn.jquery.com/plugins/basic-plugin-creation/

// TAB x Enter
// http://www.cristalab.com/tutoriales/convertir-un-enter-en-un-tab-con-javascript-y-jquery-c89132l/
// https://kodecl.wordpress.com/2010/09/23/detectar-tecla-enter-en-jquery-para-pasar-al-siguiente-campo-del-formulario/
/*
(function($) {
    $.fn.blink = function(options) {
        var defaults = {
            delay: 500
        };
        var options = $.extend(defaults, options);

        return this.each(function() {
            var obj = $(this);
            setInterval(function() {
                if ($(obj).css("visibility") == "visible") {
                    $(obj).css('visibility', 'hidden');
                }
                else {
                    $(obj).css('visibility', 'visible');
                }
            }, options.delay);
        });
    }
}(jQuery))

*/



})(jQuery);
