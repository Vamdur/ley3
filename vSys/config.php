;<?php die('Abusador...'); ?>

[Sistema]


  ; Iconos
    sysIcon=fa

  ; Logo
    sysIconLogo=logo.png
    sysIconLogoLogin=logoLogin.png

  ; Captcha Personal
    sysCaptcha='false'

  ; ReCapcha de Google
    sysReCaptcha='false'

  ; Tiempo de Expiración de la Sesión Expresada en Minutos
    sysExpiraSesion=60

  ; Presenta Mapas
    sysMapas='false'

  ; Presenta Graficos
    sysGraficos='false'

  ; Presenta Videos
    sysVideos='false'

  ; Dias Límite para Bloqueo a Usuarios del Sistema no Logueados (Nunca=0)
    sysBloqueoUsuario=365

  ; Dias Límite para Bloqueo a Personas no Logueados (Nunca=0)
    sysBloqueoPersona=365

  ; Permite Varias Sesiones Activas
    sysSesion='false'

  ; Tamaño en kB de las Fotos
    sysFotoKb   = 2500
    sysImagenKb = 1000

[Entorno]

  ; Tipo Menu
    sysMenu=LTE3

  ; Color del Entorno: blue, black, purple, green, red, yellow.
  ; bg-gray-light, bg-white, bg-primary, bg-warning, bg-info, bg-danger, bg-success
    sysSkin=bg-primary

  ; Colores Entorno Admin-LTE3
  ; bg-gray-light, bg-white, bg-primary, bg-warning, bg-info, bg-danger, bg-success
    sysSkinLogo=bg-primary

  ; Si le Colocas -light se hace blanco el Menu
  ; sidebar-light-primary, sidebar-light-warning, sidebar-light-info, sidebar-light-danger, sidebar-light-success
  ; sidebar-dark-primary,  sidebar-dark-warning,  sidebar-dark-info,  sidebar-dark-danger,  sidebar-dark-success
    sysSkinMenu=sidebar-light-danger

  ; Ventana de Ayuda
  ; primary, warning, info, danger, success
    sysSkinAyuda=info

  ; Formularios que no son del Grid
    sysSkinFrm=bg-primary
    sysSkinFrmBtn=bg-primary

  ; Ventana jsPanel
  ; default, primary, secondary, info, success, warning, danger, light, dark
    sysSkinPanel=primary

[Grid]
  ; Color del Grid: redmond, blitzer, cupertino, le-frog,
  ;                 overcast, smoothness, south-street, start, sunny
    sysSkinJqGrid=redmond

  ; Colores Botones segun el Entorno
    sysSkinJqGridBtn=bg-primary

  ; Iconos fontAwesome, jQueryUI
  ;sysIconSet=fontAwesome


[Red]
  sysProxy=http://10.10.2.79:8080

[Correo]

  ; Correo por Defecto
    sysCorreoDefault=@minea.gob.ve

  ; Correo del Administrador
    sysCorreoAdministrador=aduarte@minea.gob.ve
    sysCorreoAdministradorPassword=sist$$44

    sysHostCorreo=10.10.2.41

    ;sysCorreoAdministrador=sistemas.minec@gmail.com;
    ;sysCorreoAdministradorPassword=minec$$07;


; Como Utilizar
; $vSysConfig = Sistema::varSistema();
; // echo var_export($vSysConfig,true);
; // if ($vSysConfig["sysGraficos"])
