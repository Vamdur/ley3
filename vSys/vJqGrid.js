(function ($) {

  /* Para Chequear si es o no un JSON */
  isJSON = function (something) {
    if (typeof something != 'string')
      something = JSON.stringify(something);
    try {
      JSON.parse(something);
      return true;
    } catch (e) {
      return false;
    }
  }


  /* Crear la Tabla Grid */
  vfnCrearGrid = function(opciones) {
    if ( isJSON(opciones) ){
      var defaults = {id:'vacio', div:'vacio', hide:false};
    }else{
      var defaults = {id:opciones, div:'vacio', hide:false};
    }

    var vVar = $.fn.extend(defaults, opciones);

    if (vVar.hide) {
      vVar.hide = 'display:none;';
    }else{
      vVar.hide = 'display:block;';
    }

    if (vVar.div==='vacio') { vVar.div = 'div'+vVar.id; }
    if ( $('#'+vVar.div).length <= 0 ){
      // Si No Existe el Div lo Crea
      document.getElementById("inicioContenido").innerHTML += "<div class='col-lg-12' id='"+vVar.div+"' ></div>";
    }
    vVar.div = vVar.div.trim().replace('#','');
    $("#"+vVar.div).append('<div class="" style="'+vVar.hide+'"  ><table id="'+vVar.id+'"></table></div><div id="'+vVar.id+'Pag"></div>');
    return this;
  }

  /* Crear la Tabla del SubGrid */
  vfnCrearSubGrid = function(opciones) {
    var defaults = {id:'vacio',collapse:true};
    var vVar = $.fn.extend(defaults, opciones);
    if ( vVar.collapse ){
      var elGridSuperior = "#"+vVar.id.slice(0,vVar.id.indexOf('_'));
      var rowIds = $(elGridSuperior).jqGrid('getDataIDs');
      $.each(rowIds, function (index, rowId) {
        $(elGridSuperior).jqGrid("collapseSubGridRow",rowId);
      });
    }

    $("#"+vVar.id).html("<table id='"+vVar.id+"_t' class='scroll'  ></table><div id='p_"+vVar.id+"_t' class='scroll'></div>");
    return { id:'#'+vVar.id+'_t', id2:vVar.id+'_t_top', pager:'#p_'+vVar.id+'_t' };
  }

initDateEdit = function (elem) {
                    setTimeout(function () {
                        $(elem).datepicker({
                            format: 'dd-mm-yyyy',
                            autoSize: true,
                            showOn: 'button', // it dosn't work in searching dialog
                            changeYear: true,
                            changeMonth: true,
                            showButtonPanel: true,
                            showWeek: true,
                            todayBtn:true
                        });
                    }, 100);
                };

initDateTimeEdit = function (elem) {
                    setTimeout(function () {
                        $(elem).datepicker({
                            dateFormat: 'dd-mm-YY',
                            autoSize: true,
                            //showOn: 'button', // it dosn't work in searching dialog
                            changeYear: true,
                            changeMonth: true,
                            showButtonPanel: true,
                            showWeek: true
                        });
                    }, 100);
                };




  initDateSearch = function (elem, options) {
    var self = this;
    setTimeout(function () {
                        $(elem).datepicker({
                            format: 'yyyy-mm-dd',
                            autoSize: true,
                            showOn: 'button', // it dosn't work in searching dialog
                            changeYear: true,
                            changeMonth: true,
                            showButtonPanel: true,
                            showWeek: true,
                            todayBtn:true
                        });
                    }, 100);
  };

  initDateSearchw = function (elem, options) {
    var self = this;
    setTimeout(function () {
      initDateEdit.call(self, elem, options);
    }, 50);
  };

      /*
  initDateSearch = function (elem) {
    setTimeout(function () {
      initDateEdit(elem);
    }, 100);
  };*/

  /* Registro Seleccionado */
  $.fn.vfnGridSelRow = function() {
    return $('#'+this.prop('id')).jqGrid('getGridParam',"selrow");
  }

  /* Data del Registro Seleccionado*/
  $.fn.vfnGridRowData = function(idRow) {
    var gridC = '#'+this.prop('id');
    gridC = gridC.replace("##","#");
    if (typeof(idRow)==='undefined') {
      idRow = $(gridC).jqGrid('getGridParam','selrow');
    }
    return $(gridC).jqGrid('getRowData',idRow);
  }

  $.fn.vfnGridAll = function(data,msg) {
    if (typeof(msg)==='undefined') { msg='Todos'; }
    return $("#"+this.prop('id')+"Pag_center .ui-pg-selbox option[value='"+msg+"']").val(data.records);
  }

  /* Resize Automatico del Grid */
  //https://stackoverflow.com/questions/875225/resize-jqgrid-when-browser-is-resized
  vfnGridResize = function() {
    if (grids = $('.ui-jqgrid-btable:visible')) {
      grids.each(function(index){
        var gridId = $(this).attr('id');
        gridWidth = parseInt($('#gbox_'+gridId).parent().width())-5;
    //    gridHeight = parseInt($('.content-wrapper').height()-250);

//var tt = $('.ui-jqgrid-toppager').height();
//alert( tt );
//var winHeight = $(window).height();

 // alert('window:'+winHeight+' grid:'+gridHeight+ ' resta:'+(winHeight-gridHeight) )   ;
/*

var kk , kk1;
kk = $('.content-wrapper').height();
kk1 = $('#divSysCargarPhp2').height();


//= $('#Nomina').outerHeight();
//kk = $('#Nomina').parents().height();
alert( kk );
alert( kk1 );

*/
 //   p.height = $('.content-wrapper').height()-80;
//var padreSuperior=$(this).closest('fieldsed');


//if (vfnExiste( $('#'+gridId).closest('#phpJpanel') )) {
//alert( 'existe '+gridId );
//}


        $('#'+gridId).jqGrid("setGridWidth",gridWidth);
      //  $('#'+gridId).jqGrid("setGridHeight",gridHeight);
      });
    }
    return this;
  }

  /* Usuarios */
  vfnGridVerUsuarios = function(grid) {
    var gridC = '#'+grid;
    for (var i = 1; i <= 4; i++) {
      if ( $(gridC+'_idusuario'+i).length > 0){
        if ( $(gridC+'_idusuario'+i).is(":visible")){
          $(gridC).jqGrid('hideCol',['idusuario'+i,'fpersona'+i]);
        }else{
          $(gridC).jqGrid('showCol',['idusuario'+i,'fpersona'+i]);
        }
      }else if ( $(gridC+'_idpersona'+i).length > 0){
        if ( $(gridC+'_idpersona'+i).is(":visible")){
          $(gridC).jqGrid('hideCol',['idpersona'+i,'fpersona'+i]);
        }else{
          $(gridC).jqGrid('showCol',['idpersona'+i,'fpersona'+i]);
        }
      }
    }
    return true;
  }

  vfnGridPermiso = function(opciones) {
    var defaults = { op:{entrar:true, mt:false, pb:true, fb:false }, msg:'', div:'#inicioContenido' };
    var vVar = $.fn.extend(defaults, opciones);

    if ( vVar.div.indexOf('#') == -1 ) vVar.div = '#'+vVar.div;
    if ( vVar.op.mt===true ){
      vfnAviso({taviso:'Mantenimiento', msg:vVar.msg});
    }else if ( vVar.op.entrar===false ){
      vfnAviso({taviso:'SinPermiso', msg:vVar.msg});
    }else if ( vVar.op.pb===false ){
      vfnAviso({taviso:'Seguridad', msg:vVar.msg});
    }else if ( vVar.op.fb===true ){
      vfnAviso({taviso:'Bloqueo', msg:vVar.msg});
      return;
    }else{
      return;
    }

    if (vVar.div==='#inicioContenido'){
      $('#inicioTitulo,#inicioSubTitulo,'+vVar.div).html('');
    }
    event.stopPropagation();
    return false;
  }


  /* Mensaje Informativo del GRID */
  vfnGridInfo = function(mensaje) {
    if ( typeof(mensaje)==='undefined') { mensaje=''; }
    //$('.binfo').show().text(mensaje);
    $('.binfo').show().html("<b><i>"+mensaje+"</i></b>");
    return this;
  }

  /* Resize Automatico del Grid */
  $.fn.vfnGridWidth = function(grid) {
    var grid =  this.prop('id').slice(0, this.prop('id').indexOf('_'));
    $('#'+this.prop('id')).jqGrid('setGridWidth', $('#gbox_'+grid).parent().width()-50 );
 //   $('#'+this.prop('id')).setGridWidth( $('#gbox_'+grid).parent().width()-100 );
    return;
  }

  /* Contraer el SubGrid Expandido Antes de Abrir Otro */
  $.fn.vfnGridCollapsed = function(id) {
    var grid = '#'+this.prop('id');
    var rowIds = $(grid).jqGrid('getDataIDs');
    $.each(rowIds, function (index, rowId) {
      if (id!=rowId) $(grid).collapseSubGridRow(rowId);
    });
    return this;
  }

  /* Ocultar los Botones segun una Condicion */
  $.fn.vfnGridBED2 = function(id,btn,i) {
    if (typeof(btn)==='undefined') { btn = 'del'; }
    if (typeof(i)==='undefined')   { i = 1; }
    var grid = this.prop('id');
    var rD = $('#'+grid).jqGrid("getRowData",id);
    if (rD['idpersona'+i]!==$('#sysUsuario').data('id')){
      $("#"+btn+"_"+grid+"_top").hide();
    }
    return this;
  }

  $.fn.vfnChosen = function(opciones) {
    var defaults = {width:'95%', min:1, max:7, theme:'classic', placeholder:" ", multiple:false };
    var vVar = $.fn.extend(defaults, opciones);
    if (vVar.multiple){
      $('#'+this.prop('id')+" option[value=''").remove();
    }
    $('#'+this.prop('id')).chosen({
      width: vVar.width
    }).css('zIndex',999000);
    return;
  }

  $.fn.vfnSelect2 = function(opciones) {
    var defaults = {width:'90%', min:1, max:7, theme:'classic', placeholder:" ", multiple:false };
    var vVar = $.fn.extend(defaults, opciones);

//$('#'+this.prop('id')).prop('type','select').prop('role','combobox');

    $('#'+this.prop('id')).select2({
      theme: vVar.theme,
      placeholder: vVar.placeholder,
      minimumSelectionLength: vVar.min,
      maximumSelectionLength: vVar.max,
      tokenSeparators: [',',' '],
      multiple: vVar.multiple,
      width: vVar.width,
      tags: true,
    }).on('select2:select', function (evt) {
      var element = evt.params.data.element;
      var $element = $(element);
      $element.detach();
      $(this).append($element);
      $(this).trigger("change");
    });
       // $('#'+this.prop('id')).addClass('js0-example-basic-multiple').addClass('ui-widget select');

    //$('#'+this.prop('id')).addClass('ui-widget select');
    //$('#'+this.prop('id')).attr({'multiple':vVar.multiple});
    return;
  }


  // Seleccionar Primer Registro
  $.fn.vfnGridRow1 = function( ) {
    var gridC = '#'+this.prop('id');
    gridC = gridC.replace("##","#");
    $(gridC).jqGrid('setSelection',$(gridC).jqGrid('getDataIDs')[0]);
    return this;
  }


  /* Re-Configuracion EditUrl del Grid */
  $.fn.vfnGridEditUrl = function(cadena) {
    if (typeof(cadena)==='undefined') { cadena = ''; }
    var gridC = '#'+this.prop('id');
    if (cadena===''){
      cadena = $(gridC).jqGrid('getGridParam','url');
      cadena = cadena.slice(0, cadena.indexOf('&'));
    }else{
      cadena = "vSys/mGridCT.php?vGrid="+cadena;
    }
    $(gridC).jqGrid('setGridParam',{ editurl: cadena });
    return this;
  }

  /* Configuracion Inicial del Grid */
  $.fn.vfnGridConfigurar = function(opciones) {
    var defaults = {
      width:'auto',
      height:'auto',
      showUser:true,
      fechas:false,
      refresh:true,
      labels:true,
      toolbar:true,
      rowList:true,
      titlebarClose:false,
      toppager:true,
      addLine:false,
      editLine:false,
      delLine:false,
      pager:true,
      pagCenter:true,
      searchOper:true,
      bindKeys:true,
      hlp:'',
      hlpTitle:'Ayuda',
      hlpIcon:'',
      re:false,
      reMsg:'Activar / Desactivar',
      reGrid:'',
      reData:'',
      reCell:'1',
      iconAdd:'',
      iconEdit:'',
      iconDel:'',
      iconRe:'ban',
      tAdd:'',
      tEdit:'',
      tDel:'',
      tRe:'',
      gHeader:false
    }

    var vVar  = $.fn.extend(defaults, opciones);
    var grid  = this.prop('id');
    var gridC = "#"+this.prop('id');
    var cadena;
/*
    var gHeader;
    if(vVar.gHeader){


      gHeader:[
        {c:'idpersona1', n:2, t:vfnFa('file-o','Incluyó')},
        {c:'idpersona2', n:2, t:vfnFa('pencil','Actualizó')},
      ];


     $(gridC).jqGrid('setGroupHeaders',{
        groupHeaders:[
          {startColumnName:'tmonto1',    numberOfColumns:4, titleText:'Montos'},
          {startColumnName:'idpersona1', numberOfColumns:2, titleText:vfnFa('file-o','Incluyó')},
          {startColumnName:'idpersona2', numberOfColumns:2, titleText:vfnFa('pencil','Actualizó')},
        ]
      });

    }
/*
$("#Nomina").jqGrid('inlineNav', '#NominaPag', {
        edittext: "Edit",
        addtext: "Add",
        savetext: "Save",
        canceltext: "Cancel",
        addParams: { position: "afterSelected" }
    });
*/
/*
    if (vVar.addLine || vVar.editLine || vVar.delLine){
      $(gridC).jqGrid('inlineNav',gridC+'Pag', { add:vVar.addLine, edit:vVar.editLine, addParams:{position:"first"}} );

      $(gridC+"_iladd").insertAfter('#add_'+grid+'_top');
      $(gridC+"_iledit").insertAfter(gridC+'_iladd');
      $(gridC+"_ilsave").insertAfter(gridC+'_iledit');
      $(gridC+"_ilcancel").insertAfter(gridC+'_ilsave');
      //if (vVar.editLine) { $("#edit_"+grid+"_top").remove(); }
      //if (vVar.delLine)  { $("#del_"+grid+"_top").remove(); }
    }
*/
    var btn = 'add,edit,del,search,refresh';
    $.each(btn.split(","),function(index,item){
      $("#"+item+"_"+grid+"_top").removeClass('ui-pg-button').addClass('btn ui-widget-header '+$("#sysSistema").data("skin-jqgrid-btn")).css({'border':'2px solid #808080'});
      $("#"+item+"_"+grid+"_top>.ui-pg-div>span").css({'color':'black','font-size':'16px'});
    });
/*
    var btn = 'add,edit,cancel,save';
    $.each(btn.split(","),function(index, item){
      $(gridC+'_il'+item).removeClass('ui-pg-button').addClass('btn ui-widget-header '+$("#sysSistema").data("skin-jqgrid-btn")).css({'border':'2px solid #808080'});
      $(gridC+'_il'+item+">.ui-pg-div>span").css({'color':'black','font-size':'16px'});
    });
*/
    if ($("#sysSistema").data("desktop")==='mobil'){
       vVar.hlp='';
       vVar.showUser=false;
    }

    if (vVar.iconAdd!=='') { $("#add_"+grid+"_top>.ui-pg-div>span").removeClass('fa-file-o').addClass('fa-'+vVar.iconAdd); }
    if (vVar.tAdd!=='')    { $("#add_"+grid+"_top span").removeClass('fa-fw').html("<b style='font-size:x-small'>&nbsp;"+vVar.tAdd+"</b>"); }
    if (vVar.iconEdit!==''){ $("#edit_"+grid+"_top>.ui-pg-div>span").removeClass('fa-pencil').addClass('fa-'+vVar.iconEdit); }
    if (vVar.tEdit!=='')   { $("#edit_"+grid+"_top span").removeClass('fa-fw').html("<b style='font-size:x-small'>&nbsp;"+vVar.tEdit+"</b>"); }
    if (vVar.iconDel!=='') { $("#del_"+grid+"_top>.ui-pg-div>span").removeClass('fa-cut').addClass('fa-'+vVar.iconDel); }
    if (vVar.tDel!=='')    { $("#del_"+grid+"_top span").removeClass('fa-fw').html("<b style='font-size:x-small'>&nbsp;"+vVar.tDel+"</b>"); }

    $(gridC).jqGrid('hideCol',['idpersona1','idpersona2','idpersona3','idpersona4']);
    $(gridC).jqGrid('hideCol',['idusuario1','idusuario2','idusuario3','idusuario4']);
    $(gridC).jqGrid('hideCol',['fpersona1', 'fpersona2', 'fpersona3', 'fpersona4']);

    // Barra de Busqueda
    $(gridC).jqGrid('filterToolbar');

    // Declarar la Paginacion
    if ( $(gridC).jqGrid('getGridParam','pager')==='' ) { $(gridC).jqGrid('setGridParam',{'pager':gridC+'Pag'}); }

    $(gridC+"_toppager_center").remove();
    $(gridC+"_toppager_right").remove();
    $(gridC+"Pag_left").html('');
    $("[id*=_t_left]").html('');


/*
    if ( $(gridC+"_toppager").length === 1 ){
      $(gridC+"_toppager_center").remove();
      $(gridC+"_toppager_right").html('');
      $(gridC+"_t_toppager_right").html('');
      $(gridC+"Pag_left").html('');
      $(gridC+"_left").empty().html('');
      $("[id*=_t_left]").empty().html('');
    }
*/


    if (!vVar.toppager) { $(gridC+"_toppager").hide();  }

    var xScroll = $(gridC).jqGrid('getGridParam','scroll');
//.fm-button
    if (xScroll==='1' || xScroll===true || xScroll==='true' ){
//$('#especies').jqGrid('setGridParam',{rowNum:50, height:'auto'});
      //if (xScroll==='1' || xScroll==='true'){
        //vVar.height='auto';
        //$(gridC).jqGrid('setGridParam',{rowNum:500000, height:'auto'});
        //var xx = $(gridC).jqGrid('getGridParam','rowNum');
        //alert('Scroll '+ xScroll );
        //alert('rowNum '+ xx );
      //}
//
      //$(gridC+"Pag").hide();
     // $(gridC+"Pag").css('height','100%');
     // $(gridC+"Pag_center").hide();

      //var subgridC = gridC;
      //subgridC = subgridC.replace('#','');

      //$(gridC+"_t").hide();
      //$('#p_'+subgridC).hide();
     // $('#p_'+subgridC+'_center').remove();
   //   $('#p_'+subgridC).css('height','100%');

    }
    //$(gridC+"Pag_left").hide();//.remove().html('');
    //$(gridC+"Pag_center").hide();//.remove().html('');
    //$(gridC+"Pag_right").hide();//.remove().html('');

    if (vVar.re){
      $("#refresh_"+grid+"_top").clone().insertBefore('#'+grid+'_toppager_left>.ui-pg-table>.ui-jqgrid-disablePointerEvents').attr({"id":"re_"+grid+"_top"}).prop({'align':'right','title':'Activar/Desactivar'});
      $("#re_"+grid+"_top").show().attr('onclick',"vfnGridFormularioDel({grid:'"+grid+"', oper:'Activar', msg:'"+vVar.reMsg+"', data:'"+vVar.reData+"', cell:'"+vVar.reCell+"', xoGrid:'"+vVar.reGrid+"'});");
      $("#re_"+grid+"_top>.ui-pg-div>span").removeClass('fa-refresh').addClass('fa-'+vVar.iconRe);
      if (vVar.tRe!=='') { $("#re_"+grid+"_top span").removeClass('fa-fw').html("<b style='font-size:x-small'>&nbsp;"+vVar.tRe+"</b>"); }
    }

    if (vVar.hlp!==''){
      $.ajax({
        type:"POST",
        url:"vSys/sysAyuda.php",
        dataType:"json",
        data:{hlp:vVar.hlp},
        success: function(datos){
          if (datos.yes){
            $("#refresh_"+grid+"_top").clone().insertBefore("#refresh_"+grid+"_top").attr({"id":"btnAyuda_"+grid+"_top"}).prop({'align':'right','title':'Ayuda'});
            $("#btnAyuda_"+grid+"_top span").removeClass('fa-refresh').addClass('fa-question');
            $("#btnAyuda_"+grid+"_top").show().attr('onclick',"vfPanelAyuda({hlp:'"+datos.hlp+"',hlpIcon:'"+vVar.hlpIcon+"',hlpTitle:'"+vVar.hlpTitle+"'});");
          }
        }
      });
    }

    if (vVar.showUser){
      $("#refresh_"+grid+"_top").clone().insertBefore("#refresh_"+grid+"_top").attr({"id":"btnVerUsuarios_"+grid+"_top"}).prop({'align':'right','title':'ver/Ocultar Usuarios Involucrados'});
      $("#btnVerUsuarios_"+grid+"_top span").removeClass('fa-refresh').addClass('fa-user-plus');
      $("#btnVerUsuarios_"+grid+"_top").show().attr('onclick',"vfnGridVerUsuarios('"+grid+"');");
    }

    //$("#refresh_"+grid+"_top").clone().insertAfter("#refresh_"+grid+"_top").attr({"id":"btnSalir_"+grid+"_top"}).prop({'align':'right','title':'Regresar'});
    //$("#btnSalir_"+grid+"_top span").removeClass('fa-refresh').addClass('fa-times');

    //var estilo = "display:none1; color:black; text-align:left; padding:10px; border-radius:7px; margin-top:5px; margin-bottom:5px; width:100%;table-layout:fixed;height:100%;";
    //$("#gview_"+grid+" .ui-jqgrid-title").append("<div id='"+grid+"_Ayuda' style='"+estilo+" #A9A9A9; background-color:#F5F5F5; text-align:justify; text-justify:inter-word;'></div>");

    var estilo = "padding:5px; width:100%; table-layout:fixed; height:100%;";
      //#A9A9A9; background-color:#F5F5F5; text-align:justify; text-justify:inter-word;

    $("#pg_"+grid+"_toppager").append("<div id='"+grid+"_mytop' style='"+estilo+" text-align:right;'></div>");
    $("<div id='"+grid+"_myfoot' style='"+estilo+" text-align:left;'></div>").insertBefore("#pg_"+grid+"Pag .ui-pg-table");

    // Barra de Busqueda
    if (vVar.bindKeys) { $(gridC).jqGrid('bindKeys'); }

    cadena = $(gridC).jqGrid('getGridParam','editurl');
    if ( cadena !== null ){
      if ( cadena.indexOf(".php") == -1 ){
        if ( cadena.indexOf("vGrid=") == -1 ){
          cadena = "vSys/mGridCT.php?vGrid="+cadena;
        }else{
          cadena = "vSys/mGridCT.php?"+cadena;
        }
      }
      $(gridC).jqGrid('setGridParam',{ editurl: cadena });
    }

    // Congelar Columnas
    $(gridC).jqGrid('setFrozenColumns');

    if (vVar.height==='auto'){
      //$(gridC).setGridHeight("auto").setGridWidth("auto");
    }else{
      //$(gridC).setGridHeight( $("#content-wrapper").height() - (230 + vVar.height) );
    }

    if (!vVar.refresh) { $('#refresh_'+grid+'_top').hide(); }

    if (!vVar.toolbar) { $(gridC)[0].toggleToolbar(); }
    if (!vVar.rowList) { $("#gbox_"+grid+" .ui-pg-selbox").remove(); }
    if (!vVar.titlebarClose) { $("#gbox_"+grid+" .ui-jqgrid-titlebar-close").hide(); }

    if (!vVar.pagCenter) { $(gridC+'Pag_center').remove(); $("[id*=_t_center]").html(''); }
    if (!vVar.pager)     { $(gridC+'Pag').remove(); $("[id*=pg_p_]").html(''); }


//    if (vVar.searchOper) { $("#gbox_"+grid+" .ui-search-toolbar .ui-search-oper").hide(); }

//    if (!vVar.labels) { $("#gbox_"+grid+" .ui-jqgrid-labels").hide(); }

    $("[id*=gs_] option[value='']").html('Todos');

   // $(".ui-jqgrid-disablePointerEvents").remove();
    $('.footrow').css({'font-size':'1.1em'});

    if (vVar.fechas){
      $(gridC).vfnGridBoton({id:'xfdesde', texto:'Fecha:', tipo:'date'})
              .vfnGridBoton({id:'xfhasta', texto:'~ ',     tipo:'date'});
      $('#xfdesde,#xfhasta').val($.datepicker.formatDate("dd-mm-yy",new Date())).datepicker('update').datepicker('setEndDate','0d');
    }

    return this;
  }

  /* Crear un Boton, Select, Checkbox, Text en el Grid */
  $.fn.vfnGridBoton = function(opciones) {
    var defaults = { titulo:'', id:'Boton', icono:'gear', texto:'', placeholder:'',
                     tipo:'button', valor:'', readonly:false, enabled:true, size:8,
                     click:'', width:'20%', vtrue:true, br:false, hidden:false, align:'',
                     fontSize:'', textAlign:'left', color:'' };
    var vVar = $.fn.extend(defaults, opciones);
    if (vVar.vtrue){
      var grid = this.prop('id');
      var detalle;
      var idBtn = 'btn'+vVar.id+'_'+this.prop('id')+'_top';
      var idBtn2;

      if (vVar.align==='derecha')   { vVar.align='right'; }
      if (vVar.align==='izquierda') { vVar.align='left'; }
      if (vVar.align==='cabecera')  { vVar.align='mytop'; }
      if (vVar.align==='pie')       { vVar.align='myfoot'; }

      if (vVar.tipo==='button')   { vVar.tipo='boton'; }
      if (vVar.tipo==='text' )    { vVar.tipo='texto'; }
      if (vVar.tipo==='date' )    { vVar.tipo='fecha'; }
      if (vVar.tipo==='checkbox') { vVar.tipo='check'; }

      if (vVar.tipo==='label' && vVar.align==='' ){
        vVar.align='myfoot';
      }

      if (vVar.tipo==='boton'){
        idBtn2 ='#'+vVar.align+'_'+grid+'_top';
        if (vVar.align==='') {
          idBtn2 = '#'+grid+'_toppager_left>.ui-pg-table>.ui-jqgrid-disablePointerEvents';
          if (!vfnExiste(idBtn2)){
            idBtn2 = '#btnAyuda_'+grid+'_top';
            if (!vfnExiste(idBtn2)){
              idBtn2 = '#refresh_'+grid+'_top';
            }
          }
        }
      }else{
        if (vVar.align==='left' || vVar.align==='myfoot' ) {
          vVar.align='myfoot';
        }else{
          vVar.align='mytop';
        }
      }

      if (vVar.align==='mytop')  { idBtn2 = "#"+grid+"_mytop"; }
      if (vVar.align==='myfoot') { idBtn2 = "#"+grid+"_myfoot"; }

      if (vVar.tipo==='boton'){

        $("#refresh_"+grid+"_top").clone().insertBefore(idBtn2).attr({"id":idBtn}).prop({'title':vVar.titulo });

        if (vVar.mt===true){ vVar.titulo += "\nEN MANTENIMIENTO."; }

        $("#"+idBtn+" span").removeClass('fa-refresh').addClass('fa-'+vVar.icono);
        $("#"+idBtn).addClass('miBotonGrid');
        if (vVar.texto!==''){
          $("#"+idBtn+" span").removeClass('fa-fw').html("<b style='font-size:x-small'>&nbsp;"+vVar.texto+"</b>");
        }

      }else if (vVar.tipo==='select' || vVar.tipo==='cbo'){

        if (vVar.tipo==='cbo'){ idBtn=vVar.id; }

        detalle = "<span><b>&nbsp;<i>"+vVar.texto+"</i>&nbsp;</b><select id='"+idBtn+"' style='text-align:left;border: 2px solid #808080;' data-width='fit' class='ui-widget-header ui-corner-all'></select></span>";
        $(detalle).appendTo(idBtn2);

        vVar.tipo='cbo';

      }else if (vVar.tipo==='texto' || vVar.tipo==='fecha'){

        if (vVar.tipo==='fecha') { vVar.size=10; }

        idBtn = vVar.id;
        detalle = "<span id='"+idBtn+"Span'><b>&nbsp;&nbsp;<i>"+vVar.texto+"</i></b>&nbsp;<input size='"+vVar.size+"' id='"+idBtn+"' name='"+idBtn+"' role='textbox' class='ui-corner-all' type='text'>&nbsp;</span>";

        if (vVar.br) { detalle = detalle+'<br>'; }

        $(detalle).appendTo(idBtn2);
        $('#'+idBtn).css({'text-align':vVar.textAlign});

        if (vVar.tipo==='fecha'){
          $('#xfdesde').attr('placeholder','Desde');
          $('#xfhasta').attr('placeholder','Hasta');
          $('#'+idBtn).datepicker({clearBtn:true, todayBtn:true});
        }

        $('#'+idBtn).val(vVar.valor);

      }else if (vVar.tipo==='check' || vVar.tipo==='check7'){

        if (vVar.tipo==='check7') { idBtn=vVar.id; vVar.tipo='check';}

        if (vVar.textAlign==='left'){
          detalle = "<span style=''><b><i>"+vVar.texto+"</i></b>&nbsp;&nbsp;<input id='"+idBtn+"' name='"+idBtn+"' type='checkbox'> &nbsp;</span>";
        }else{
          detalle = "<span style=''>&nbsp;<input id='"+idBtn+"' name='"+idBtn+"' type='checkbox'>&nbsp;&nbsp;<b><i>"+vVar.texto+"</i></b>&nbsp;&nbsp;</span>";
        }
        $(detalle).appendTo(idBtn2);

      }else if (vVar.tipo==='label'){

        detalle = "<label style=''><b><i>"+vVar.texto+"</i></b></label>";
        $(detalle).appendTo(idBtn2);

      }

      idBtn = '#'+idBtn;

      if (vVar.tipo==='cbo'){
        if (vVar.valor===''){
          vVar.valor=":Seleccionar";
        }
        if (vVar.valor!==''){
          var numbers = vVar.valor.split(';');
          for(var i = 0; i < numbers.length; i++){
            $(idBtn).append(new Option( numbers[i].split(':')[1] , numbers[i].split(':')[0]));
          }
        }
        $(idBtn).change(function(e){
          if ($.isFunction(vVar.click) ) {vVar.click.call(this,e);}
          return false;
        });
      }else if (vVar.tipo==='check'){
        $(idBtn).change(function(e){
          if ($.isFunction(vVar.click) ) {vVar.click.call(this,e);}
          return false;
        });
      }else if (vVar.tipo==='boton'){
        $(idBtn).click(function(e){
          if ($.isFunction(vVar.click) ) {vVar.click.call(this,e);}
          return false;
        });
      }

      if (vVar.enabled===false)  { $(idBtn).prop({'disabled':'disabled'}); }
      if (vVar.hidden===true)    { $(idBtn).hide(); }
      if (vVar.readonly===true)  { $(idBtn).prop({'readonly':true}); }
      if (vVar.fontSize!=='')    { $(idBtn).css({'font-size':vVar.fontSize+'px'}); }
      if (vVar.placeholder!=='') { $(idBtn).attr({'placeholder':vVar.placeholder}); }

    }
    return this;
  }

  /* Crear un Boton en el Formulario del Grid
    $('#elInput').vfnGridBoton2({titulo:'Incluir', hidden:false, vtrue:true,
      click: function(){ alert('aqui '+this.id); }
    });
  */
  $.fn.vfnGridBoton2 = function(opciones) {
    var defaults = { id:'', titulo:'', icono:'file-o', texto:'', click:'',
                     vtrue:true, hidden:true, sombra:false };
    var vVar = $.fn.extend(defaults, opciones);

    if (vVar.vtrue){
      var btnDesde = this.prop('id');
      if (vVar.id==='') {
        vVar.id = 'btn'+btnDesde;
      }

      $("#cData").clone().insertAfter("#"+btnDesde).attr({"id":vVar.id}).prop({'title':vVar.titulo});
      $("<b>&nbsp;&nbsp;</b>").insertAfter("#"+btnDesde);

      if (vVar.texto!=='') { vVar.texto = '&nbsp;'+vVar.texto; }
      $('#'+vVar.id+' .fm-button-text').html(vVar.texto);
      $('#'+vVar.id+' .fm-button-icon').removeClass('fa-undo').removeClass('text-danger').addClass('fa-'+vVar.icono);
      if (vVar.sombra) { $('#'+vVar.id).addClass('btnSombra'); }
      if (vVar.hidden) { $('#'+vVar.id).hide(); }

      $('#'+vVar.id).click(function(e){
        if ($.isFunction(vVar.click) ) {vVar.click.call(this,e);}
        return false;
      });

    }
    return this;
  }

  /* Ocultar los Botones de Edit y Delete y Otros */
  $.fn.vfnGridBED = function(xArg1,xArg2) {
    var grid = this.prop('id');
    var xArgC;
    if ( arguments.length===0 ) {
      xArg1 = true;
      xArg2 = 0;
    }else if ( arguments.length===1 && typeof(xArg1)==="boolean" ){
      xArg2 = 0;
    }else if (arguments.length===1 && typeof(xArg1)!=="boolean" ) {
      xArg2 = xArg1;
      xArg1 = true;
      if (typeof(xArg2)==="object") { xArg1 = false; }
    }else if ( arguments.length===2 && typeof(xArg1)!=="boolean" ){
       xArgC = xArg1;
       xArg1 = xArg2;
       xArg2 = xArgC;
    }

    if (typeof(xArg2)==="object"){
      $('#sysVar').data('records',xArg2.records);
    }else if (typeof(xArg2)==="string"){
    }

    if (xArg1){
      $("[id$='"+grid+"_top']~.miBotonGrid").show();
      //$("[id$='"+grid+"_top']").show();
      $("#edit_"+grid+"_top").show();
      $("#del_"+grid+"_top").show();
      $("#re_"+grid+"_top").show();
      $("#user_"+grid+"_top").show();
    }else{
      //~
      $("[id$='"+grid+"_top']~.miBotonGrid").hide();
      //$("[id$='"+grid+"_top']").hide();
      //$("[id*='btnFijo']").show();
      $("#edit_"+grid+"_top").hide();
      $("#del_"+grid+"_top").hide();
      $("#re_"+grid+"_top").hide();
      $("#user_"+grid+"_top").hide();
    }
    $("#add_"+grid+"_top, #refresh_"+grid+"_top, #btnAyuda_"+grid+"_top").show();
    $("[id*='btnFijo']").show();

    vfnGridResize();

    if (typeof(xArg2)==="string" || typeof(xArg2)==="number"){
      return $('#'+grid).vfnGridRowData();
    }else{
      return this;
    }

  }


  vfnGridFormulario = function( opciones ) {
    var defaults = {  frm:'', center:false, caption:'', info:'', infoTop:'',
                      sData:true, dData:true, pData:false, nData:false,
                      sDataRemove:false, dDataRemove:false,
                      tsData:vfnFa('floppy-o','Guardar'), tdData:vfnFa('check','Aceptar'),
                      teData:vfnFa('ban','Cancelar'), tcData:vfnFa('ban','Cancelar'),
                      trHide:'', trRemove:'', disabled:'', enabled:'',
                      height:0, top:0, width:480, labelBold:false,
                      msg:'Desea BORRAR ?' };
    var vVar = $.fn.extend(defaults, opciones);

    viewform = vVar.frm[0].id;
    elForm = vVar.frm[0].id;
    elForm = elForm.replace("FrmGrid_", "#gbox_");
    elForm = elForm.replace("DelTbl_",  "#gbox_");
    viewform = viewform.replace("FrmGrid_", "#editmod");
    viewform = viewform.replace("DelTbl_", "#delmod");


    var elGrid =  elForm.replace("#gbox_","");

    $("#editmod"+elGrid).css('width',vVar.width);
    if (vVar.height!==0) { $("#FrmGrid_"+elGrid).css('height',vVar.height); }
    $(viewform).css('visibility', 'hidden');
    setTimeout(function () {
      if (vVar.center){
        $(viewform).css('left', ($(document).width() / 2) - ($(viewform).width() / 2));
      }
      if (vVar.top!==0 ){
        $(viewform).css('top', vVar.top);
      }
      $(viewform).css('visibility','visible');
    });
    $("#vid, #cedula, #cedulafk").css({"font-size":'18px'});
    $(":input").vfnEnter();
    $('#tr_vid').hide();

    // Verificar tambien en la afterSubmit:  de jquery.jqGrid.js
    $(".delmsg").show(); // Mensaje de Borrado

   // $('#nData').addClass('btnSombra').css('width','30').html(vfnFa('arrow-right'));
   // $('#pData').addClass('btnSombra').css('width','30').html(vfnFa('arrow-left'));

   // $('#sData,#cData,#dData,#eData').removeClass('fm-button-icon-left');

    $('#pData,#nData').hide();

    if (!vVar.sData)      { $('#sData').hide(); }
    if (vVar.sDataRemove) { $('#sData').remove(); }
    if (!vVar.dData)      { $('#dData').hide(); }
    if (vVar.dDataRemove) { $('#dData').remove(); }
    if (vVar.pData)       { $('#pData').show().attr('title','Anterior'); }
    if (vVar.nData)       { $('#nData').show().attr('title','Siguiente'); }

    vfnGridTrRemove(vVar.trRemove);
    vfnGridTrHide(vVar.trHide);

    if (vVar.caption!=='') { $("#edithd"+elGrid+" .ui-jqdialog-title").html(''+vVar.caption); }

    if (vVar.disabled!==''){
      if (vVar.disabled==='*'){
        $('#'+elGrid).vfnEnabled(vVar.disabled,false);
      }else{
        $(vVar.disabled).vfnEnabled(false);
      }
    }

    if (vVar.enabled!=='') { $(vVar.enabled).vfnEnabled(); }

    if (vVar.labelBold)    { $('.CaptionTD').css('font-weight','bold'); }

    if (vVar.info!=='')    { $('.binfo').show(); $('.bottominfo').text(vVar.info);  }
    if (vVar.infoTop!=='') { $('#FormError').show(); $('#FormError .ui-state-error').text(vVar.infoTop);  }

    return this;
  }


  $.fn.vfnGridFormularioAjax = function( misOpciones ) {
    misOpciones = $.extend(misOpciones, {grid:this.prop('id')});
    vfnGridFormularioDel( misOpciones );
    return this;
  }

  vfnGridFormularioDel = function( opciones ) {
    var defaults = { frm:'', grid:'', xoGrid:'', caption:"Confirmar", oper:'Editar', msg:'Desea BORRAR el Registro', cell:'0', data:'', width:300 };
    var vVar = $.fn.extend(defaults, opciones);

    if ( vVar.grid===''){
      var grid = '#'+$("[id^=delmod]").attr("id").replace('delmod','');
    }else{
      var grid = '#'+vVar.grid;
    }

    vVar.msg = "<b>"+vVar.msg;

    var idRow = $(grid).jqGrid('getGridParam',"selrow");

    if (vVar.data!==''){
      var rD = $(grid).vfnGridRowData(idRow);
      vVar.msg += "<br><span class='text-danger' style='font-size:1.25em;'>";
      $.each( vVar.data.split(","), function(index, item) {
        if (item.indexOf('-')){
          vVar.msg += rD[item]+' ';
        }else{
          vVar.msg += ' '+item.replace('-','')+' ';
        }
      });
      vVar.msg += " ?</span>";
    }else if (vVar.cell!==''){
      vVar.msg += "<br><span class='text-danger' style='font-size:1.25em;'>";
      $.each( vVar.cell.split(","), function(index, item) {
        if (item.indexOf('-')){
          vVar.msg +=  $( grid+" #"+idRow).find('td').eq(item).text()+' ';
        }else{
          vVar.msg += ' '+item.replace('-','')+' ';
        }
      });
      vVar.msg += " ?</span>";
    }

    if ( vVar.grid===''){
      vVar.msg = "<br>"+vVar.msg+"</b><br><br>";
      $("td.delmsg",vVar.frm).html(vVar.msg);
    }else{
      vVar.msg += "</b>";
      vVar.msg= vVar.msg.replace("Desea BORRAR el Registro","Desea PROCESAR la Acción");

      $(grid).jqGrid("delGridRow",idRow,
        { modal:true, drag:true, width:vVar.width,
          msg: vVar.msg, caption:vVar.caption,
          serializeDelData: function(postdata) {
            return {id:postdata.id,oper:vVar.oper,xoGrid:vVar.xoGrid,rDatos:$(grid).vfnGridRowData(postdata.id)};
          },
          beforeShowForm: function(form) {
            vfnGridFormulario({frm:form});
          }
        }
      );
    }
    return this;
  }










/// Revisar desde aqui


  /* Crear una Linea de Separacion con Mensaje en un Formulario */
  $.fn.vfnGridLinea = function(msg) {
    if ( typeof(msg)==='undefined') { msg=''; }
    if ( msg.indexOf("|")<=0 ){
      $("<tr id='tr_"+this.prop('id')+"_1' style='border-top: 2px solid #cdd0d4;' class='FormData'><td colspan='4' align='center' ><b>"+msg+"</b></td></tr>").insertAfter("#tr_"+this.prop('id'));
    }else{
      $("<tr id='tr_"+this.prop('id')+"_1' style='border-top: 2px solid #cdd0d4;' class='FormData'><td align='center' colspan='2' ><b>"+msg.split('|')[0]+"</b></td><td align='center' colspan='2' ><b>"+msg.split('|')[1]+"</b></td></tr>").insertAfter("#tr_"+this.prop('id'));
    }
    return this;
  }

  /* Titulo del Formulario */
  vfnGridFrmTitle = function(msg) {
    if (typeof(msg)==='undefined') { msg=''; }
    $('.ui-jqdialog-title').html(msg);
    return this;
  }

  /* Mensaje de Error en el Formulario */
  vfnGridFrmError = function(msg) {
    if (typeof(msg)==='undefined') { msg=''; }
    $("#FormError").hide();
    if (msg!==''){
      $("#FormError>td").html('&nbsp;&nbsp;'+msg).show();
      $("#FormError").show();
    }
    return this;
  }

  /* Ocultar/Mostrar TR del Formulario */
  vfnGridTrHide = function(tr,xhide) {
    if (typeof(tr)==='undefined') { tr = ''; }
    if (typeof(xhide)==='undefined') { xhide = true; }

    tr = tr.replace("#tr_","").trim();
    tr = tr.replace("tr_","").trim();
    tr = tr.replace(" ","").trim();

    $.each( tr.split(","), function(index, item) {
      item = "#tr_"+item.trim();
      $(item).hide();
      if (!xhide) { $(item).show(); }
    });
    return this;
  }

  /* Remover TR del Formulario */
  vfnGridTrRemove = function(tr) {
    if (typeof(tr)==='undefined') { tr = ''; }
    tr = tr.replace("#tr_","").trim();
    tr = tr.replace("tr_","").trim();
    tr = tr.replace(" ","").trim();

    $.each( tr.split(","), function(index, item) {
      item = "#tr_"+item.trim();
      $(item).remove();
    });
    return this;
  }




  /* Configuracion Width del GRID */
  $.fn.vfnGridWidth2 = function( ancho ) {
    if ( typeof ancho==='undefined' ) ancho2 = 0;
    if (ancho!==-1) $('#'+this.prop('id')).setGridWidth( $("#content-wrapper").width() - (50 + ancho), true );
    return this;
  }
  /* Configuracion Heigth del GRID */
  $.fn.vfnGridHeight = function( alto ) {
    if ( typeof alto==='undefined' ) alto = 0;
    if (alto!==-1 ) $('#'+this.prop('id')).setGridHeight( $("#content-wrapper").height() - (230 + alto), true);
    return this;
  }

  /* Reload del GRID */
  $.fn.vfnGridReload = function() {
    $('#'+this.prop('id')).trigger('reloadGrid');
    return this;
  }

  $.fn.vfnGridBEDRemove = function() {
    var grid = this.prop('id');
    $("#refresh_"+grid+"_top").clone().insertBefore("#refresh_"+grid+"_top").attr({"id":"btnRefrescar"+grid}).prop({'align':'right','title':'Refrescar Datos'});
    $("[id*=_"+grid+"_top] button").hide();
    return this;
  }




  /* Borrar Opciones Existentes en un Combo Grid */
  $.vfnActualizarComboGrid = function( grid, id ) {
    if ( grid.indexOf("#") == -1 ) grid = "#"+grid;
    var rows = $(grid).jqGrid('getRowData');
    for(var i = 0; i < rows.length; i++){
      var row = rows[i];
      //$("#idestado option[value='"+row['idestado']+"'").remove();
      $("#"+id+" option[value='"+row[id]+"'").remove();
    }
    return this;
  }
  /* Mensajes */





  $.fn.vfnGridSetState = function(xtrue) {
    if (typeof(xtrue)==='undefined') { xtrue=true; }
    var grid = '#'+this.prop('id');
//    xtrue = xtrue ? 'visible' : 'hidden';
    $(grid).jqGrid('setGridState',(xtrue ? 'visible' : 'hidden'));
    return this;
  }

  // Esconder los Selectores de Igualdad del Grid
  $.fn.vfnGridHideSearchOper = function(xth,xtrue) {
    var grid = this.prop('id');
    if (typeof(xth)==='undefined')   { xth=0; }
    if (typeof(xtrue)==='undefined') { xtrue=true; }
    if ( xtrue ){
      if (xth===0){
        $("#gbox_"+grid+" .ui-search-toolbar .ui-search-oper").hide();
      }else{
        $("#gbox_"+grid+" .ui-search-toolbar th:eq("+xth+") .ui-search-oper").hide();
      }
    }else{
      if (xth===0){
        $("#gbox_"+grid+" .ui-search-toolbar .ui-search-oper").show();
      }else{
        $("#gbox_"+grid+" .ui-search-toolbar th:eq("+xth+") .ui-search-oper").show();
      }
    }
    return this;
  }

  /* Asignar una Imagen a un Boton */
  vfnGridSetImagen = function(img,size){
    if (typeof(img)==='undefined') img='search';
    if (typeof(size)==='undefined') size='25';
    var cadena;
    if ( img.indexOf("glyphicon-") >= 0 ){
      cadena = "<i class='glyphicon "+img+"'></i>";
    }else if ( img.indexOf(".png")  >= 0 ||
               img.indexOf(".jpg")  >= 0 ||
               img.indexOf(".jpeg") >= 0 ||
               img.indexOf(".gif")  >= 0 ){
      cadena = "<img src='vSys/img/"+img+"' width="+size+"px height="+size+"px/>";
    }else{
      //cadena = "<i class='fa fa-"+img+"' style='font-size:24px;'></i>";
      cadena = "<button type='button' data-loading-text='Leyendo...' class='btn btn-primary'><i style='font-size:22px;' class='fa fa-"+img+"'></i></button>";
    }
    return cadena;
  }

  /* Asignar un Valor por Defecto a un Campo */
  $.fn.vfnGridSetColProp = function( cadena ) {
    var campoValor = cadena.split("=");
    $('#'+this.prop('id')).setColProp( campoValor[0], { editoptions: { defaultValue: campoValor[1] }});
  return this;
  }

  /* Cambiar el Url y reloadGrid ( */
  $.fn.vfnGridSetUrl = function( opciones ) {
    var defaults = { url:'vSys/mGrid.php', vGrid:'', condicion:'id=0', fechas:false };
    var vVar = $.fn.extend(defaults, opciones);
    var grid = this.prop('id');
    if ( grid.indexOf("#") == -1 ) grid = '#'+grid;

    if (vVar.fechas && vfnExiste('#xfdesde')){
      vVar.condicion  = 'xfdesde='+$('#xfdesde').val();
      if (vfnExiste('#xfhasta')){
        vVar.condicion += '&xfhasta='+$('#xfhasta').val();
      }
    }

    vVar.url = vVar.url+'?vGrid='+vVar.vGrid+'&'+vVar.condicion;
    $(grid).jqGrid('setGridParam',{ url:vVar.url})
           .jqGrid('setGridParam',{page:1})
           .jqGrid("resetSelection")
           .trigger('reloadGrid');

    return this;
  }


  /* Colocar el Registro del Grid en Color Segun Condicion
    Las fechas debe ponerlas en Formato Y-m-d
    $('#grid').vfnGridRowColor({data:data, condicion:'activo=f',color:'yellow',fondo:'red', celda:'apellidos1|nombres1'});
    $('#grid').vfnGridRowColor({data:data, condicion:'activo=t',color:'red', celda:'cedula', size:'12pt' });
  */
  $.fn.vfnGridRowColor = function ( opciones ) {

    var defaults = { data:null, condicion:'re=t', color:'red', fondo:'#fabeb1', celda:'', size:'', blink:false, hide:false, subgrid:false };

    var vVar = $.fn.extend(defaults, opciones);
    var grid = this.prop('id');
    var separador = '|';

    if ( vVar.celda.indexOf(",")>=0 ) separador=',';

    if ( grid.indexOf("#") == -1 ) grid = '#'+grid;

    if ( $(grid).jqGrid("getGridParam","reccount") !== 0 ) {
      var igual = '=';
      if ( vVar.condicion.indexOf("=null") >= 0 ) igual = '=';
      if ( vVar.condicion.indexOf("=nulo") >= 0 ) igual = '=';
      if ( vVar.condicion.indexOf(">")  >= 0 ) igual = '>';
      if ( vVar.condicion.indexOf(">=") >= 0 ) igual = '>=';
      if ( vVar.condicion.indexOf("<")  >= 0 ) igual = '<';
      if ( vVar.condicion.indexOf("<=") >= 0 ) igual = '<=';
      if ( vVar.condicion.indexOf("<>") >= 0 ) igual = '!=';
      if ( vVar.condicion.indexOf("!=") >= 0 ) igual = '!=';

      var campo = vVar.condicion.split(igual)[0];
      var valor = vVar.condicion.split(igual)[1];

      if (valor==='null' || valor==='nulo' || valor==='nula'){
        igual = 'null';
      }

      $.each(vVar.data.rows,function(i,item){

        bTd = '#'+vVar.data.rows[i].id ;

        cTd = vVar.data.rows[i].cell[campo];

        if( ( igual==='='  && cTd === valor ) ||
            ( igual==='null' && cTd === null ) ||
            ( igual==='null' && cTd === '' ) ||
            ( igual==='!=' && cTd !== valor ) ||
            ( igual==='>=' && cTd >=  valor ) ||
            ( igual==='>'  && cTd >   valor ) ||
            ( igual==='<'  && cTd <   valor ) ||
            ( igual==='<=' && cTd <=  valor )
           ){
          if (vVar.celda!==''){
            $.each( vVar.celda.split(separador), function(index, item) {
             //  $('#YourGridId').jqGrid('setRowData', rowIds[i], false, "CSSClass");

              $(grid).jqGrid('setCell',vVar.data.rows[i].id, item,"",{'color':vVar.color});
              if (vVar.fondo!=='') $(grid).jqGrid('setCell',vVar.data.rows[i].id, item,"",{'background-color':vVar.fondo});
              if (vVar.size!=='') $(grid).jqGrid('setCell',vVar.data.rows[i].id, item,"",{'font-size':vVar.size});
             // if (vVar.blink) $(grid).jqGrid('setCell',vVar.data.rows[i].id, item,"",{'font-size':vVar.size}); // .addClass('blinkText');
            });
          }else{
            if (vVar.subgrid){
              vVar.color=''; vVar.fondo='';
              $(bTd+" td.sgcollapsed",grid).unbind('click').html(' '+vfnFa('arrow-circle-o-right text-danger') ).addClass('ui-state-disabled');
            }
            $(bTd).find('td').css({color:vVar.color});
            if (vVar.fondo!=='') $(bTd).find('td').css({'background-color':vVar.fondo});
            if (vVar.size!=='') $(bTd).find('td').css({'font-size':vVar.size});
            //if (vVar.blink) $(bTd).addClass('blinkText');
            if (vVar.hide) $(bTd).css('display','none');
          }
        }
      });
    }
    return this;
  }

  //http://myjqgrid.blogspot.com/2013/08/validar-cualquier-campo-presente-en-el_1.html

  vfnGridValidarMonto = function (value,colname){
    // Como Usarla
    // editrules:{ custom:true, number:true, custom_func:vfnGridValidarMonto }
    if(!isNaN(value)){
      if(parseFloat(value)==0){
        return[false,colname+": Debe Ingresar un Monto."];
      }else{
        return[true,""];
      }
    }else{
      return [false,colname+": Debe Ingresar un Monto."];
    }
  }



  $.fn.vfnGridCambiarGrupo = function(evt) {
    var element = evt.params.data.element;
    var $element = $(element);
    $element.detach();
    $('#'+this.prop('id')).append($element);
    $('#'+this.prop('id')).trigger("change");
    return;
  }

  $.fn.vfnGridAgrupar = function(grupo) {
    var elGrid = '#'+this.prop('id');
    grupo = ''+grupo;
    grupo = grupo.toLowerCase().trim();
    $(elGrid).jqGrid('groupingRemove',true);
    if (grupo!==''){
      var i = grupo.split(',');
      if ( i.length===1 ) $(elGrid).jqGrid('groupingGroupBy',[ i[0].trim() ]);
      if ( i.length===2 ) $(elGrid).jqGrid('groupingGroupBy',[ i[0].trim(),i[1].trim() ]);
      if ( i.length===3 ) $(elGrid).jqGrid('groupingGroupBy',[ i[0].trim(),i[1].trim(),i[2].trim() ]);
      if ( i.length===4 ) $(elGrid).jqGrid('groupingGroupBy',[ i[0].trim(),i[1].trim(),i[2].trim(),i[3].trim() ]);
      if ( i.length===5 ) $(elGrid).jqGrid('groupingGroupBy',[ i[0].trim(),i[1].trim(),i[2].trim(),i[3].trim(),i[4].trim() ]);
      if ( i.length===6 ) $(elGrid).jqGrid('groupingGroupBy',[ i[0].trim(),i[1].trim(),i[2].trim(),i[3].trim(),i[4].trim(),i[5].trim() ]);
      if ( i.length===7 ) $(elGrid).jqGrid('groupingGroupBy',[ i[0].trim(),i[1].trim(),i[2].trim(),i[3].trim(),i[4].trim(),i[5].trim(),i[6].trim() ]);
    }
    return;
  }

/*
//https://www.it-swarm-es.tech/es/php/equivalente-php-funcion-number-format-en-jqueryjavascript/1068983124/
function number_formatd(number,decimals,dec_point,thousands_sep) {
    number  = number*1;//makes sure `number` is numeric value
    var str = number.toFixed(decimals?decimals:0).toString().split('.');
    var parts = [];
    for ( var i=str[0].length; i>0; i-=3 ) {
        parts.unshift(str[0].substring(Math.max(0,i-3),i));
    }
    str[0] = parts.join(thousands_sep?thousands_sep:',');
    return str.join(dec_point?dec_point:'.');
}
*/




  // QUITAR LUEGO de Todos los Sistemas

  $.fn.vfnGridBorrarRegistro = function() {
    jAdvertencia('Cambiar vfnGridBorrarRegistro()<br>por vfnGridFormularioAjax()');
    return;
  }

  vfnPermiso = function(opciones) {
    vfnGridPermiso(opciones);
    jAdvertencia('Cambiar vfnPermiso()<br>por vfnGridPermiso()');
    return this;
  }

  $.fn.vfnGridSeparadorRemove = function() {
    //$(".ui-jqgrid-disablePointerEvents").remove();
    jAdvertencia('Quitar vfnGridSeparadorRemove() ');
    return this;
  }

  vfnGridCentrarFormulario = function( form, centrar ) {
    jAdvertencia('Cambiar vfnGridCentrarFormulario()<br>por vfnGridFormulario');
    return this;
  }

  $.fn.vfnGridPrimerRegistro = function( ) {
    jAdvertencia('Cambiar vfnGridPrimerRegistro()<br>por vfnGridRow1()');
    return this;
  }

  vfnGridErrorFormulario = function(msg) {
    jAdvertencia('Cambiar vfnGridErrorFormulario()<br>por vfnGridFrmError()');
    return this;
  }

  $.fn.vfnGridBtn = function(opciones) {
    jAdvertencia('Cambiar vfnGridBtn()<br>por vfnGridBoton()');
    return this;
  }

  $.fn.vfnGridBtn2 = function(opciones) {
    jAdvertencia('Cambiar vfnGridBtn2()<br>por vfnGridBoton2()');
    return this;
  }

  $.fn.vfnGridSetMensaje = function(detalle) {
    jAdvertencia('Quitar vfnGridSetMensaje()');
    return this;
  }

  $.fn.vfnGridColorRegistro = function ( opciones ) {
    jAdvertencia('Cambiar<br><br>vfnGridColorRegistro() -> vfnGridRowColor()');
    return this;
  }

})(jQuery);
