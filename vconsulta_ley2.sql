--
-- PostgreSQL database dump
--

-- Dumped from database version 9.3.25
-- Dumped by pg_dump version 11.5 (Ubuntu 11.5-3.pgdg18.04+1)

-- Started on 2021-02-18 21:23:25 -04

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 8 (class 2615 OID 417085)
-- Name: vsistema; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA vsistema;


ALTER SCHEMA vsistema OWNER TO postgres;

--
-- TOC entry 2329 (class 0 OID 0)
-- Dependencies: 8
-- Name: SCHEMA vsistema; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA vsistema IS 'Configuracion';


--
-- TOC entry 216 (class 1255 OID 417087)
-- Name: vfnedad(date, date); Type: FUNCTION; Schema: vsistema; Owner: postgres
--

CREATE FUNCTION vsistema.vfnedad(pd_fecha_ini date, pd_fecha_fin date, OUT pn_edad integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
BEGIN
pn_edad := FLOOR(((DATE_PART('YEAR',pd_fecha_fin)-DATE_PART('YEAR',pd_fecha_ini))* 372 + (DATE_PART('MONTH',pd_fecha_fin) - DATE_PART('MONTH',pd_fecha_ini))*31 + (DATE_PART('DAY',pd_fecha_fin)-DATE_PART('DAY',pd_fecha_ini)))/372);
END;
$$;


ALTER FUNCTION vsistema.vfnedad(pd_fecha_ini date, pd_fecha_fin date, OUT pn_edad integer) OWNER TO postgres;

--
-- TOC entry 217 (class 1255 OID 417088)
-- Name: vfngenerar_password(integer); Type: FUNCTION; Schema: vsistema; Owner: postgres
--

CREATE FUNCTION vsistema.vfngenerar_password(integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$ 
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
 $_$;


ALTER FUNCTION vsistema.vfngenerar_password(integer) OWNER TO postgres;

--
-- TOC entry 218 (class 1255 OID 417089)
-- Name: vfnvusuario(integer); Type: FUNCTION; Schema: vsistema; Owner: postgres
--

CREATE FUNCTION vsistema.vfnvusuario(pin_usuario integer, OUT pout_usuario text) RETURNS text
    LANGUAGE plpgsql
    AS $$
  DECLARE
  vRst Record;
BEGIN
   FOR vRst IN SELECT nombres1, apellidos1 FROM dpersona WHERE idpersona=pin_usuario ORDER BY idpersona LOOP
       pout_usuario := vRst.apellidos1 || ' ' || vRst.nombres1;
   END LOOP;
END;
$$;


ALTER FUNCTION vsistema.vfnvusuario(pin_usuario integer, OUT pout_usuario text) OWNER TO postgres;

--
-- TOC entry 174 (class 1259 OID 417207)
-- Name: dconsulta_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dconsulta_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dconsulta_seq OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 203 (class 1259 OID 423174)
-- Name: dconsulta; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dconsulta (
    idconsulta integer DEFAULT nextval('public.dconsulta_seq'::regclass) NOT NULL,
    cedulafk bigint NOT NULL,
    idaspectofk integer NOT NULL,
    idpropuestafk integer NOT NULL,
    propuesta text,
    fpropuesta timestamp without time zone DEFAULT now(),
    numero character varying,
    numero2 character varying,
    numero3 character varying,
    ipmaquina1 character varying,
    ipmaquina2 character varying,
    fpersona2 timestamp without time zone DEFAULT (to_char(now(), 'YYYY-MM-DD HH24:MI'::text))::timestamp without time zone
);


ALTER TABLE public.dconsulta OWNER TO postgres;

--
-- TOC entry 172 (class 1259 OID 417091)
-- Name: dpersona_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dpersona_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.dpersona_seq OWNER TO postgres;

--
-- TOC entry 173 (class 1259 OID 417093)
-- Name: dpersona; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dpersona (
    idpersona integer DEFAULT nextval('public.dpersona_seq'::regclass) NOT NULL,
    nacionalidad character varying(1) DEFAULT 'V'::character varying,
    cedula bigint NOT NULL,
    apellidos1 character varying(100) NOT NULL,
    apellidos2 character varying(100),
    nombres1 character varying(100),
    nombres2 character varying(100),
    fnacimiento date,
    sexo character varying(1) DEFAULT 'x'::character varying,
    correo character varying(50),
    clave character varying(32) DEFAULT md5(vsistema.vfngenerar_password(8)),
    celular character varying,
    bloqueo boolean DEFAULT false,
    ipdir character varying(15),
    login character varying(15),
    flogin timestamp without time zone DEFAULT (to_char(now(), 'YYYY-MM-DD HH24:MI'::text))::timestamp without time zone,
    foto boolean DEFAULT true,
    direccion text,
    institucion character varying,
    fax character varying,
    idparroquiafk integer,
    ciudad character varying,
    pregunta character varying,
    respuesta character varying,
    campo05 character varying,
    campo06 character varying,
    campo07 character varying,
    re boolean DEFAULT false,
    idpersona1 integer,
    idpersona2 integer,
    fpersona1 timestamp without time zone DEFAULT (to_char(now(), 'YYYY-MM-DD HH24:MI'::text))::timestamp without time zone,
    fpersona2 timestamp without time zone DEFAULT (to_char(now(), 'YYYY-MM-DD HH24:MI'::text))::timestamp without time zone
);


ALTER TABLE public.dpersona OWNER TO postgres;

--
-- TOC entry 196 (class 1259 OID 422140)
-- Name: nestado_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nestado_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nestado_seq OWNER TO postgres;

--
-- TOC entry 200 (class 1259 OID 422155)
-- Name: nestado; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nestado (
    idestado integer DEFAULT nextval('public.nestado_seq'::regclass) NOT NULL,
    idpaisfk integer NOT NULL,
    estado character varying(100) NOT NULL,
    ciudad character varying(100),
    latitud character varying(20),
    longitud character varying(20),
    idpersona2 integer,
    fpersona2 timestamp without time zone DEFAULT (to_char(now(), 'YYYY-MM-DD HH24:MI'::text))::timestamp without time zone
);


ALTER TABLE public.nestado OWNER TO postgres;

--
-- TOC entry 197 (class 1259 OID 422142)
-- Name: nmunicipio_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nmunicipio_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nmunicipio_seq OWNER TO postgres;

--
-- TOC entry 201 (class 1259 OID 422164)
-- Name: nmunicipio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nmunicipio (
    idmunicipio integer DEFAULT nextval('public.nmunicipio_seq'::regclass) NOT NULL,
    idestadofk integer NOT NULL,
    municipio character varying(100) NOT NULL,
    latitud character varying(20),
    longitud character varying(20),
    idpersona2 integer,
    fpersona2 timestamp without time zone DEFAULT (to_char(now(), 'YYYY-MM-DD HH24:MI'::text))::timestamp without time zone
);


ALTER TABLE public.nmunicipio OWNER TO postgres;

--
-- TOC entry 195 (class 1259 OID 422138)
-- Name: npais_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.npais_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.npais_seq OWNER TO postgres;

--
-- TOC entry 199 (class 1259 OID 422146)
-- Name: npais; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.npais (
    idpais integer DEFAULT nextval('public.npais_seq'::regclass) NOT NULL,
    pais character varying(100) NOT NULL,
    latitud character varying(20),
    longitud character varying(20),
    idpersona2 integer,
    fpersona2 timestamp without time zone DEFAULT (to_char(now(), 'YYYY-MM-DD HH24:MI'::text))::timestamp without time zone
);


ALTER TABLE public.npais OWNER TO postgres;

--
-- TOC entry 198 (class 1259 OID 422144)
-- Name: nparroquia_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nparroquia_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.nparroquia_seq OWNER TO postgres;

--
-- TOC entry 202 (class 1259 OID 422178)
-- Name: nparroquia; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nparroquia (
    idparroquia integer DEFAULT nextval('public.nparroquia_seq'::regclass) NOT NULL,
    idmunicipiofk integer NOT NULL,
    parroquia character varying(100) NOT NULL,
    latitud character varying(20),
    longitud character varying(20),
    idpersona2 integer,
    fpersona2 timestamp without time zone DEFAULT (to_char(now(), 'YYYY-MM-DD HH24:MI'::text))::timestamp without time zone
);


ALTER TABLE public.nparroquia OWNER TO postgres;

--
-- TOC entry 175 (class 1259 OID 417556)
-- Name: vbitacora_seq; Type: SEQUENCE; Schema: vsistema; Owner: postgres
--

CREATE SEQUENCE vsistema.vbitacora_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE vsistema.vbitacora_seq OWNER TO postgres;

--
-- TOC entry 176 (class 1259 OID 417558)
-- Name: vbitacora; Type: TABLE; Schema: vsistema; Owner: postgres
--

CREATE TABLE vsistema.vbitacora (
    idbitacora integer DEFAULT nextval('vsistema.vbitacora_seq'::regclass) NOT NULL,
    tabla character varying(30),
    idpk integer,
    descripcion text,
    idpersona1 integer,
    idpersona2 integer,
    fpersona2 timestamp without time zone DEFAULT (to_char(now(), 'YYYY-MM-DD HH24:MI'::text))::timestamp without time zone
);


ALTER TABLE vsistema.vbitacora OWNER TO postgres;

--
-- TOC entry 177 (class 1259 OID 417566)
-- Name: vcomun; Type: TABLE; Schema: vsistema; Owner: postgres
--

CREATE TABLE vsistema.vcomun (
    idcomun integer NOT NULL,
    comun character varying,
    concepto text,
    descripcion text,
    tipo character varying(15) DEFAULT 'Text'::character varying,
    fijo boolean DEFAULT false,
    idpersona2 integer,
    fpersona2 timestamp without time zone DEFAULT (to_char(now(), 'YYYY-MM-DD HH24:MI'::text))::timestamp without time zone
);


ALTER TABLE vsistema.vcomun OWNER TO postgres;

--
-- TOC entry 178 (class 1259 OID 417575)
-- Name: vformulario_seq; Type: SEQUENCE; Schema: vsistema; Owner: postgres
--

CREATE SEQUENCE vsistema.vformulario_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE vsistema.vformulario_seq OWNER TO postgres;

--
-- TOC entry 179 (class 1259 OID 417577)
-- Name: vformulario; Type: TABLE; Schema: vsistema; Owner: postgres
--

CREATE TABLE vsistema.vformulario (
    idformulario integer DEFAULT nextval('vsistema.vformulario_seq'::regclass) NOT NULL,
    formulario character varying(100) NOT NULL,
    descripcion text NOT NULL,
    activo boolean DEFAULT true,
    fijo7 boolean DEFAULT false,
    mt boolean DEFAULT false,
    idpersona2 integer,
    fpersona2 timestamp without time zone DEFAULT (to_char(now(), 'YYYY-MM-DD HH24:MI'::text))::timestamp without time zone,
    re boolean DEFAULT false,
    fb boolean DEFAULT false
);


ALTER TABLE vsistema.vformulario OWNER TO postgres;

--
-- TOC entry 180 (class 1259 OID 417590)
-- Name: vips_seq; Type: SEQUENCE; Schema: vsistema; Owner: postgres
--

CREATE SEQUENCE vsistema.vips_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE vsistema.vips_seq OWNER TO postgres;

--
-- TOC entry 181 (class 1259 OID 417592)
-- Name: vips; Type: TABLE; Schema: vsistema; Owner: postgres
--

CREATE TABLE vsistema.vips (
    idip integer DEFAULT nextval('vsistema.vips_seq'::regclass) NOT NULL,
    ip character varying(15) NOT NULL,
    idpersona1 integer,
    fpersona1 timestamp without time zone DEFAULT (to_char(now(), 'YYYY-MM-DD HH24:MI'::text))::timestamp without time zone,
    fpersona2 timestamp without time zone,
    vezin integer DEFAULT 1,
    vezout integer DEFAULT 0
);


ALTER TABLE vsistema.vips OWNER TO postgres;

--
-- TOC entry 182 (class 1259 OID 417599)
-- Name: vrol_seq; Type: SEQUENCE; Schema: vsistema; Owner: postgres
--

CREATE SEQUENCE vsistema.vrol_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE vsistema.vrol_seq OWNER TO postgres;

--
-- TOC entry 183 (class 1259 OID 417601)
-- Name: vrol; Type: TABLE; Schema: vsistema; Owner: postgres
--

CREATE TABLE vsistema.vrol (
    idrol integer DEFAULT nextval('vsistema.vrol_seq'::regclass) NOT NULL,
    rol character varying(100) NOT NULL,
    condicion text,
    activo boolean DEFAULT true,
    fijo boolean DEFAULT false,
    idpersona1 integer,
    idpersona2 integer,
    fpersona1 timestamp without time zone DEFAULT (to_char(now(), 'YYYY-MM-DD HH24:MI'::text))::timestamp without time zone,
    fpersona2 timestamp without time zone DEFAULT (to_char(now(), 'YYYY-MM-DD HH24:MI'::text))::timestamp without time zone
);


ALTER TABLE vsistema.vrol OWNER TO postgres;

--
-- TOC entry 184 (class 1259 OID 417612)
-- Name: vrolformulario_seq; Type: SEQUENCE; Schema: vsistema; Owner: postgres
--

CREATE SEQUENCE vsistema.vrolformulario_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE vsistema.vrolformulario_seq OWNER TO postgres;

--
-- TOC entry 194 (class 1259 OID 419025)
-- Name: vrolformulario; Type: TABLE; Schema: vsistema; Owner: postgres
--

CREATE TABLE vsistema.vrolformulario (
    idrolformulario integer DEFAULT nextval('vsistema.vrolformulario_seq'::regclass) NOT NULL,
    idrolfk integer NOT NULL,
    idformulariofk integer NOT NULL,
    incluir boolean DEFAULT false,
    editar boolean DEFAULT false,
    eliminar boolean DEFAULT false,
    borrar boolean DEFAULT false,
    imprimir boolean DEFAULT false,
    procesar boolean DEFAULT false,
    administrar boolean DEFAULT false,
    fijo boolean DEFAULT false,
    idpersona1 integer,
    idpersona2 integer,
    fpersona1 timestamp without time zone DEFAULT (to_char(now(), 'YYYY-MM-DD HH24:MI'::text))::timestamp without time zone,
    fpersona2 timestamp without time zone DEFAULT (to_char(now(), 'YYYY-MM-DD HH24:MI'::text))::timestamp without time zone
);


ALTER TABLE vsistema.vrolformulario OWNER TO postgres;

--
-- TOC entry 185 (class 1259 OID 417628)
-- Name: vrolusuario_seq; Type: SEQUENCE; Schema: vsistema; Owner: postgres
--

CREATE SEQUENCE vsistema.vrolusuario_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE vsistema.vrolusuario_seq OWNER TO postgres;

--
-- TOC entry 186 (class 1259 OID 417630)
-- Name: vrolusuario; Type: TABLE; Schema: vsistema; Owner: postgres
--

CREATE TABLE vsistema.vrolusuario (
    idrolusuario integer DEFAULT nextval('vsistema.vrolusuario_seq'::regclass) NOT NULL,
    idrolfk integer DEFAULT 11,
    idusuariofk integer,
    prioridad integer DEFAULT 0 NOT NULL,
    activo boolean DEFAULT true,
    fijo boolean DEFAULT false,
    idpersona1 integer,
    idpersona2 integer,
    fpersona1 timestamp without time zone DEFAULT (to_char(now(), 'YYYY-MM-DD HH24:MI'::text))::timestamp without time zone,
    fpersona2 timestamp without time zone DEFAULT (to_char(now(), 'YYYY-MM-DD HH24:MI'::text))::timestamp without time zone
);


ALTER TABLE vsistema.vrolusuario OWNER TO postgres;

--
-- TOC entry 187 (class 1259 OID 417640)
-- Name: vtablas_seq; Type: SEQUENCE; Schema: vsistema; Owner: postgres
--

CREATE SEQUENCE vsistema.vtablas_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE vsistema.vtablas_seq OWNER TO postgres;

--
-- TOC entry 188 (class 1259 OID 417642)
-- Name: vtablas; Type: TABLE; Schema: vsistema; Owner: postgres
--

CREATE TABLE vsistema.vtablas (
    idtipo integer DEFAULT nextval('vsistema.vtablas_seq'::regclass) NOT NULL,
    descripcion text NOT NULL,
    fijo boolean DEFAULT true,
    fijo7 boolean DEFAULT false,
    comentario character varying,
    idpersona2 integer,
    fpersona2 timestamp without time zone DEFAULT (to_char(now(), 'YYYY-MM-DD HH24:MI'::text))::timestamp without time zone
);


ALTER TABLE vsistema.vtablas OWNER TO postgres;

--
-- TOC entry 189 (class 1259 OID 417652)
-- Name: vtablas2_seq; Type: SEQUENCE; Schema: vsistema; Owner: postgres
--

CREATE SEQUENCE vsistema.vtablas2_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE vsistema.vtablas2_seq OWNER TO postgres;

--
-- TOC entry 190 (class 1259 OID 417654)
-- Name: vtablas2; Type: TABLE; Schema: vsistema; Owner: postgres
--

CREATE TABLE vsistema.vtablas2 (
    idcodigo integer DEFAULT nextval('vsistema.vtablas2_seq'::regclass) NOT NULL,
    idtipofk integer NOT NULL,
    idtexto character varying(20),
    descripcion text,
    orden integer DEFAULT 1,
    fijo boolean DEFAULT false,
    fijo7 boolean DEFAULT false,
    condicion text DEFAULT 'N'::text,
    re boolean DEFAULT false,
    idpersona1 integer,
    idpersona2 integer,
    fpersona1 timestamp without time zone DEFAULT (to_char(now(), 'YYYY-MM-DD HH24:MI'::text))::timestamp without time zone,
    fpersona2 timestamp without time zone DEFAULT (to_char(now(), 'YYYY-MM-DD HH24:MI'::text))::timestamp without time zone
);


ALTER TABLE vsistema.vtablas2 OWNER TO postgres;

--
-- TOC entry 191 (class 1259 OID 417668)
-- Name: vusuario; Type: TABLE; Schema: vsistema; Owner: postgres
--

CREATE TABLE vsistema.vusuario (
    idusuario integer NOT NULL,
    usuario character varying DEFAULT (to_char(now(), 'YYYY-MM-DD HH24:MI'::text))::timestamp without time zone,
    activo boolean DEFAULT true,
    clave character varying(32) DEFAULT md5(vsistema.vfngenerar_password(8)),
    clave2 character varying(32) DEFAULT md5(vsistema.vfngenerar_password(8)),
    clave3 character varying(32) DEFAULT md5(vsistema.vfngenerar_password(8)),
    fijo7 boolean DEFAULT false,
    condicion text,
    iniciales character varying(7),
    campo01 character varying(1),
    campo02 character varying(1),
    campo03 character varying(1),
    campo04 character varying(1),
    campo05 character varying(1),
    idpersona1 integer,
    idpersona2 integer,
    fpersona1 timestamp without time zone DEFAULT (to_char(now(), 'YYYY-MM-DD HH24:MI'::text))::timestamp without time zone,
    fpersona2 timestamp without time zone DEFAULT (to_char(now(), 'YYYY-MM-DD HH24:MI'::text))::timestamp without time zone
);


ALTER TABLE vsistema.vusuario OWNER TO postgres;

--
-- TOC entry 192 (class 1259 OID 417682)
-- Name: vvideo_seq; Type: SEQUENCE; Schema: vsistema; Owner: postgres
--

CREATE SEQUENCE vsistema.vvideo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE vsistema.vvideo_seq OWNER TO postgres;

--
-- TOC entry 193 (class 1259 OID 417684)
-- Name: vvideo; Type: TABLE; Schema: vsistema; Owner: postgres
--

CREATE TABLE vsistema.vvideo (
    idvideo integer DEFAULT nextval('vsistema.vvideo_seq'::regclass) NOT NULL,
    nvideo character varying NOT NULL,
    cvideo character varying DEFAULT 'videos'::character varying NOT NULL,
    tvideo character varying(1) DEFAULT 'M'::character varying,
    idpersona1 integer,
    fpersona1 timestamp without time zone DEFAULT (to_char(now(), 'YYYY-MM-DD HH24:MI'::text))::timestamp without time zone
);


ALTER TABLE vsistema.vvideo OWNER TO postgres;

--
-- TOC entry 2322 (class 0 OID 423174)
-- Dependencies: 203
-- Data for Name: dconsulta; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dconsulta (idconsulta, cedulafk, idaspectofk, idpropuestafk, propuesta, fpropuesta, numero, numero2, numero3, ipmaquina1, ipmaquina2, fpersona2) FROM stdin;
\.


--
-- TOC entry 2292 (class 0 OID 417093)
-- Dependencies: 173
-- Data for Name: dpersona; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dpersona (idpersona, nacionalidad, cedula, apellidos1, apellidos2, nombres1, nombres2, fnacimiento, sexo, correo, clave, celular, bloqueo, ipdir, login, flogin, foto, direccion, institucion, fax, idparroquiafk, ciudad, pregunta, respuesta, campo05, campo06, campo07, re, idpersona1, idpersona2, fpersona1, fpersona2) FROM stdin;
8	V	17588974	Bagnarol	Caceres	Giovanni	Biaggio	1986-12-06	M	irosoturale@gmail.com	8f14e45fceea167a5a36dedd4bea2543		f	\N	gbagnarol	2020-12-02 00:00:00	t	\N	\N	\N	782	\N	\N	 	\N	\N	\N	f	\N	\N	\N	\N
9	V	6866452	Chaustre	Cardenas	Jose	Gregorio	1965-12-23	M	jchaustre@gmail.com	8f14e45fceea167a5a36dedd4bea2543		f	\N	6866452	2020-12-02 00:00:00	t	\N	\N	\N	782	\N	\N	 	\N	\N	\N	f	\N	\N	\N	\N
7	V	8760097	Duarte	Valera	Ambrosio	Urbano	1967-12-07	M	vamdur@gmail.com	14bfa6bb14875e45bba028a21ed38046		f	 	8760097	2021-02-17 00:00:00	t	Guatire	Minec		286	Guatire	mascota	8bf8e9fc35f3b50aef2f992d0d8f0678	\N	\N	\N	f	\N	\N	\N	\N
\.


--
-- TOC entry 2319 (class 0 OID 422155)
-- Dependencies: 200
-- Data for Name: nestado; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nestado (idestado, idpaisfk, estado, ciudad, latitud, longitud, idpersona2, fpersona2) FROM stdin;
16	1	Monagas	\N	\N	\N	\N	2021-02-16 16:48:00
19	1	Sucre	\N	\N	\N	\N	2021-02-16 16:48:00
3	1	Anzoátegui	\N	\N	\N	\N	2021-02-16 16:48:00
5	1	Aragua	\N	\N	\N	\N	2021-02-16 16:48:00
13	1	Lara	\N	\N	\N	\N	2021-02-16 16:48:00
22	1	Yaracuy	\N	\N	\N	\N	2021-02-16 16:48:00
17	1	Nueva Esparta	\N	\N	\N	\N	2021-02-16 16:48:00
24	1	Vargas	\N	\N	\N	\N	2021-02-16 16:48:00
23	1	Zulia	\N	\N	\N	\N	2021-02-16 16:48:00
15	1	Miranda	\N	\N	\N	\N	2021-02-16 16:48:00
21	1	Trujillo	\N	\N	\N	\N	2021-02-16 16:48:00
14	1	Mérida	\N	\N	\N	\N	2021-02-16 16:48:00
20	1	Táchira	\N	\N	\N	\N	2021-02-16 16:48:00
4	1	Apure	\N	\N	\N	\N	2021-02-16 16:48:00
6	1	Barinas	\N	\N	\N	\N	2021-02-16 16:48:00
18	1	Portuguesa	\N	\N	\N	\N	2021-02-16 16:48:00
9	1	Cojedes	\N	\N	\N	\N	2021-02-16 16:48:00
8	1	Carabobo	\N	\N	\N	\N	2021-02-16 16:48:00
12	1	Guárico	\N	\N	\N	\N	2021-02-16 16:48:00
7	1	Bolívar	\N	\N	\N	\N	2021-02-16 16:48:00
10	1	Delta Amacuro	\N	\N	\N	\N	2021-02-16 16:48:00
11	1	Falcón	\N	\N	\N	\N	2021-02-16 16:48:00
1	1	Distrito Capital	\N	\N	\N	\N	2021-02-16 16:48:00
2	1	Amazonas	\N	\N	\N	\N	2021-02-16 16:48:00
25	1	Territorio Insular	\N	\N	\N	\N	2021-02-16 16:48:00
26	2	Perú	\N	\N	\N	\N	2021-02-16 16:48:00
27	3	Inglaterra	\N	\N	\N	\N	2021-02-16 16:48:00
28	4	Francia	\N	\N	\N	\N	2021-02-16 16:48:00
29	5	España	\N	\N	\N	\N	2021-02-16 16:48:00
30	6	Ecuador	\N	\N	\N	\N	2021-02-16 16:48:00
31	7	Argentina	\N	\N	\N	\N	2021-02-16 16:48:00
32	8	Chile	\N	\N	\N	\N	2021-02-16 16:48:00
33	9	Mexico	\N	\N	\N	\N	2021-02-16 16:48:00
\.


--
-- TOC entry 2320 (class 0 OID 422164)
-- Dependencies: 201
-- Data for Name: nmunicipio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nmunicipio (idmunicipio, idestadofk, municipio, latitud, longitud, idpersona2, fpersona2) FROM stdin;
263	1	Libertador	\N	\N	\N	2021-02-16 16:48:00
161	2	Atabapo	\N	\N	\N	2021-02-16 16:48:00
162	2	Atures	\N	\N	\N	2021-02-16 16:48:00
163	2	Autana	\N	\N	\N	2021-02-16 16:48:00
164	2	Manapiare	\N	\N	\N	2021-02-16 16:48:00
165	2	Maroa	\N	\N	\N	2021-02-16 16:48:00
166	2	Rio Negro	\N	\N	\N	2021-02-16 16:48:00
167	3	Anaco	\N	\N	\N	2021-02-16 16:48:00
168	3	Aragua	\N	\N	\N	2021-02-16 16:48:00
169	3	Bolivar	\N	\N	\N	2021-02-16 16:48:00
170	3	Bruzual	\N	\N	\N	2021-02-16 16:48:00
171	3	Cajigal	\N	\N	\N	2021-02-16 16:48:00
172	3	Carvajal	\N	\N	\N	2021-02-16 16:48:00
173	3	Freites	\N	\N	\N	2021-02-16 16:48:00
174	3	Guanipa	\N	\N	\N	2021-02-16 16:48:00
175	3	Guanta	\N	\N	\N	2021-02-16 16:48:00
176	3	Independencia	\N	\N	\N	2021-02-16 16:48:00
177	3	Libertad	\N	\N	\N	2021-02-16 16:48:00
178	3	Lic. Diego Bautista Urbaneja	\N	\N	\N	2021-02-16 16:48:00
179	3	Mc Gregor	\N	\N	\N	2021-02-16 16:48:00
180	3	Miranda	\N	\N	\N	2021-02-16 16:48:00
181	3	Monagas	\N	\N	\N	2021-02-16 16:48:00
182	3	Peñalver	\N	\N	\N	2021-02-16 16:48:00
183	3	Piritu	\N	\N	\N	2021-02-16 16:48:00
184	3	San Juan de Capistrano	\N	\N	\N	2021-02-16 16:48:00
185	3	Santa Ana	\N	\N	\N	2021-02-16 16:48:00
186	3	Simon Rodriguez	\N	\N	\N	2021-02-16 16:48:00
187	3	Sotillo	\N	\N	\N	2021-02-16 16:48:00
188	4	Achaguas	\N	\N	\N	2021-02-16 16:48:00
189	4	Biruaca	\N	\N	\N	2021-02-16 16:48:00
190	4	Muñoz	\N	\N	\N	2021-02-16 16:48:00
191	4	Paez	\N	\N	\N	2021-02-16 16:48:00
192	4	Pedro Camejo	\N	\N	\N	2021-02-16 16:48:00
193	4	Romulo Gallegos	\N	\N	\N	2021-02-16 16:48:00
194	4	San Fernando	\N	\N	\N	2021-02-16 16:48:00
195	5	Bolivar	\N	\N	\N	2021-02-16 16:48:00
196	5	Camatagua	\N	\N	\N	2021-02-16 16:48:00
197	5	Francisco Linares Alcantara	\N	\N	\N	2021-02-16 16:48:00
198	5	Girardot	\N	\N	\N	2021-02-16 16:48:00
199	5	Jose Angel Lamas	\N	\N	\N	2021-02-16 16:48:00
200	5	Jose Felix Ribas	\N	\N	\N	2021-02-16 16:48:00
201	5	Jose Rafael Revenga	\N	\N	\N	2021-02-16 16:48:00
202	5	Libertador	\N	\N	\N	2021-02-16 16:48:00
203	5	Mario Briceño Iragorry	\N	\N	\N	2021-02-16 16:48:00
204	5	Ocumare de la Costa de Oro	\N	\N	\N	2021-02-16 16:48:00
205	5	San Casimiro	\N	\N	\N	2021-02-16 16:48:00
206	5	San Sebastian	\N	\N	\N	2021-02-16 16:48:00
207	5	Santiago Mariño	\N	\N	\N	2021-02-16 16:48:00
208	5	Santos Michelena	\N	\N	\N	2021-02-16 16:48:00
209	5	Sucre	\N	\N	\N	2021-02-16 16:48:00
210	5	Tovar	\N	\N	\N	2021-02-16 16:48:00
211	5	Urdaneta	\N	\N	\N	2021-02-16 16:48:00
212	5	Zamora	\N	\N	\N	2021-02-16 16:48:00
213	6	Alberto Arvelo Torrealba	\N	\N	\N	2021-02-16 16:48:00
214	6	Andres Eloy Blanco	\N	\N	\N	2021-02-16 16:48:00
215	6	Antonio Jose de Sucre	\N	\N	\N	2021-02-16 16:48:00
216	6	Arismendi	\N	\N	\N	2021-02-16 16:48:00
217	6	Barinas	\N	\N	\N	2021-02-16 16:48:00
218	6	Bolivar	\N	\N	\N	2021-02-16 16:48:00
219	6	Cruz Paredes	\N	\N	\N	2021-02-16 16:48:00
220	6	Obispos	\N	\N	\N	2021-02-16 16:48:00
221	6	Pedraza	\N	\N	\N	2021-02-16 16:48:00
222	6	Rojas	\N	\N	\N	2021-02-16 16:48:00
223	6	Sosa	\N	\N	\N	2021-02-16 16:48:00
224	6	Zamora	\N	\N	\N	2021-02-16 16:48:00
225	7	Caroni	\N	\N	\N	2021-02-16 16:48:00
226	7	Cedeño	\N	\N	\N	2021-02-16 16:48:00
227	7	El Callao	\N	\N	\N	2021-02-16 16:48:00
228	7	Gran Sabana	\N	\N	\N	2021-02-16 16:48:00
229	7	Heres	\N	\N	\N	2021-02-16 16:48:00
230	7	Padre Pedro Chien	\N	\N	\N	2021-02-16 16:48:00
231	7	Piar	\N	\N	\N	2021-02-16 16:48:00
232	7	Raul Leoni	\N	\N	\N	2021-02-16 16:48:00
233	7	Roscio	\N	\N	\N	2021-02-16 16:48:00
234	7	Sifontes	\N	\N	\N	2021-02-16 16:48:00
235	7	Sucre	\N	\N	\N	2021-02-16 16:48:00
236	8	Bejuma	\N	\N	\N	2021-02-16 16:48:00
237	8	Carlos Arvelo	\N	\N	\N	2021-02-16 16:48:00
238	8	Diego Ibarra	\N	\N	\N	2021-02-16 16:48:00
239	8	Guacara	\N	\N	\N	2021-02-16 16:48:00
240	8	Juan Jose Mora	\N	\N	\N	2021-02-16 16:48:00
241	8	Libertador	\N	\N	\N	2021-02-16 16:48:00
242	8	Los Guayos	\N	\N	\N	2021-02-16 16:48:00
243	8	Miranda	\N	\N	\N	2021-02-16 16:48:00
244	8	Montalban	\N	\N	\N	2021-02-16 16:48:00
245	8	Naguanagua	\N	\N	\N	2021-02-16 16:48:00
246	8	Puerto Cabello	\N	\N	\N	2021-02-16 16:48:00
247	8	San Diego	\N	\N	\N	2021-02-16 16:48:00
248	8	San Joaquin	\N	\N	\N	2021-02-16 16:48:00
249	8	Valencia	\N	\N	\N	2021-02-16 16:48:00
250	9	Anzoategui	\N	\N	\N	2021-02-16 16:48:00
251	9	Falcon	\N	\N	\N	2021-02-16 16:48:00
252	9	Girardot	\N	\N	\N	2021-02-16 16:48:00
253	9	Lima Blanco	\N	\N	\N	2021-02-16 16:48:00
254	9	Pao de San Juan Bautista	\N	\N	\N	2021-02-16 16:48:00
255	9	Ricaurte	\N	\N	\N	2021-02-16 16:48:00
256	9	Romulo Gallegos	\N	\N	\N	2021-02-16 16:48:00
257	9	San Carlos	\N	\N	\N	2021-02-16 16:48:00
258	9	Tinaco	\N	\N	\N	2021-02-16 16:48:00
259	10	Antonio Diaz	\N	\N	\N	2021-02-16 16:48:00
260	10	Casacoima	\N	\N	\N	2021-02-16 16:48:00
261	10	Pedernales	\N	\N	\N	2021-02-16 16:48:00
262	10	Tucupita	\N	\N	\N	2021-02-16 16:48:00
264	11	Acosta	\N	\N	\N	2021-02-16 16:48:00
265	11	Bolivar	\N	\N	\N	2021-02-16 16:48:00
266	11	Buchivacoa	\N	\N	\N	2021-02-16 16:48:00
267	11	Cacique Manaure	\N	\N	\N	2021-02-16 16:48:00
268	11	Carirubana	\N	\N	\N	2021-02-16 16:48:00
269	11	Colina	\N	\N	\N	2021-02-16 16:48:00
270	11	Dabajuro	\N	\N	\N	2021-02-16 16:48:00
271	11	Democracia	\N	\N	\N	2021-02-16 16:48:00
273	11	Federacion	\N	\N	\N	2021-02-16 16:48:00
274	11	Jacura	\N	\N	\N	2021-02-16 16:48:00
275	11	Los Taques	\N	\N	\N	2021-02-16 16:48:00
276	11	Mauroa	\N	\N	\N	2021-02-16 16:48:00
277	11	Miranda	\N	\N	\N	2021-02-16 16:48:00
278	11	Monseñor Iturriza	\N	\N	\N	2021-02-16 16:48:00
279	11	Palmasola	\N	\N	\N	2021-02-16 16:48:00
280	11	Petit	\N	\N	\N	2021-02-16 16:48:00
281	11	Piritu	\N	\N	\N	2021-02-16 16:48:00
282	11	San Francisco	\N	\N	\N	2021-02-16 16:48:00
283	11	Silva	\N	\N	\N	2021-02-16 16:48:00
284	11	Sucre	\N	\N	\N	2021-02-16 16:48:00
285	11	Tocopero	\N	\N	\N	2021-02-16 16:48:00
286	11	Union	\N	\N	\N	2021-02-16 16:48:00
287	11	Urumaco	\N	\N	\N	2021-02-16 16:48:00
288	11	Zamora	\N	\N	\N	2021-02-16 16:48:00
289	12	Camaguan	\N	\N	\N	2021-02-16 16:48:00
290	12	Chaguaramas	\N	\N	\N	2021-02-16 16:48:00
291	12	El Socorro	\N	\N	\N	2021-02-16 16:48:00
292	12	Infante	\N	\N	\N	2021-02-16 16:48:00
293	12	Las Mercedes	\N	\N	\N	2021-02-16 16:48:00
294	12	Mellado	\N	\N	\N	2021-02-16 16:48:00
295	12	Miranda	\N	\N	\N	2021-02-16 16:48:00
296	12	Monagas	\N	\N	\N	2021-02-16 16:48:00
297	12	Ortiz	\N	\N	\N	2021-02-16 16:48:00
298	12	Ribas	\N	\N	\N	2021-02-16 16:48:00
299	12	Roscio	\N	\N	\N	2021-02-16 16:48:00
300	12	San Geronimo de Guayabal	\N	\N	\N	2021-02-16 16:48:00
301	12	San Jose de Guaribe	\N	\N	\N	2021-02-16 16:48:00
302	12	Santa Maria de Ipire	\N	\N	\N	2021-02-16 16:48:00
303	12	Zaraza	\N	\N	\N	2021-02-16 16:48:00
304	13	Andres Eloy Blanco	\N	\N	\N	2021-02-16 16:48:00
305	13	Crespo	\N	\N	\N	2021-02-16 16:48:00
306	13	Iribarren	\N	\N	\N	2021-02-16 16:48:00
307	13	Jimenez	\N	\N	\N	2021-02-16 16:48:00
308	13	Moran	\N	\N	\N	2021-02-16 16:48:00
309	13	Palavecino	\N	\N	\N	2021-02-16 16:48:00
310	13	Simon Planas	\N	\N	\N	2021-02-16 16:48:00
311	13	Torres	\N	\N	\N	2021-02-16 16:48:00
312	13	Urdaneta	\N	\N	\N	2021-02-16 16:48:00
313	14	Alberto Adriani	\N	\N	\N	2021-02-16 16:48:00
314	14	Andres Bello	\N	\N	\N	2021-02-16 16:48:00
315	14	Antonio Pinto Salinas	\N	\N	\N	2021-02-16 16:48:00
316	14	Aricagua	\N	\N	\N	2021-02-16 16:48:00
317	14	Arzobispo Chacon	\N	\N	\N	2021-02-16 16:48:00
318	14	Campo Elias	\N	\N	\N	2021-02-16 16:48:00
319	14	Caracciolo Parra Olmedo	\N	\N	\N	2021-02-16 16:48:00
320	14	Cardenal Quintero	\N	\N	\N	2021-02-16 16:48:00
321	14	Guaraque	\N	\N	\N	2021-02-16 16:48:00
322	14	Julio Cesar Salas	\N	\N	\N	2021-02-16 16:48:00
323	14	Justo Briceño	\N	\N	\N	2021-02-16 16:48:00
324	14	Libertador	\N	\N	\N	2021-02-16 16:48:00
325	14	Miranda	\N	\N	\N	2021-02-16 16:48:00
326	14	Obispo Ramos de Lora	\N	\N	\N	2021-02-16 16:48:00
327	14	Padre Noguera	\N	\N	\N	2021-02-16 16:48:00
328	14	Pueblo Llano	\N	\N	\N	2021-02-16 16:48:00
329	14	Rangel	\N	\N	\N	2021-02-16 16:48:00
330	14	Rivas Davila	\N	\N	\N	2021-02-16 16:48:00
331	14	Santos Marquina	\N	\N	\N	2021-02-16 16:48:00
332	14	Sucre	\N	\N	\N	2021-02-16 16:48:00
333	14	Tovar	\N	\N	\N	2021-02-16 16:48:00
334	14	Tulio Febres Cordero	\N	\N	\N	2021-02-16 16:48:00
335	14	Zea	\N	\N	\N	2021-02-16 16:48:00
1	15	Acevedo	\N	\N	\N	2021-02-16 16:48:00
2	15	Andres Bello	\N	\N	\N	2021-02-16 16:48:00
3	15	Baruta	\N	\N	\N	2021-02-16 16:48:00
4	15	Brion	\N	\N	\N	2021-02-16 16:48:00
5	15	Buroz	\N	\N	\N	2021-02-16 16:48:00
6	15	Carrizal	\N	\N	\N	2021-02-16 16:48:00
7	15	Chacao	\N	\N	\N	2021-02-16 16:48:00
8	15	Cristobal Rojas	\N	\N	\N	2021-02-16 16:48:00
9	15	El Hatillo	\N	\N	\N	2021-02-16 16:48:00
10	15	Guaicaipuro	\N	\N	\N	2021-02-16 16:48:00
11	15	Independencia	\N	\N	\N	2021-02-16 16:48:00
12	15	Lander	\N	\N	\N	2021-02-16 16:48:00
13	15	Los Salias	\N	\N	\N	2021-02-16 16:48:00
14	15	Paez	\N	\N	\N	2021-02-16 16:48:00
15	15	Paz Castillo	\N	\N	\N	2021-02-16 16:48:00
16	15	Pedro Gual	\N	\N	\N	2021-02-16 16:48:00
17	15	Plaza	\N	\N	\N	2021-02-16 16:48:00
18	15	Simon Bolivar	\N	\N	\N	2021-02-16 16:48:00
19	15	Sucre	\N	\N	\N	2021-02-16 16:48:00
20	15	Urdaneta	\N	\N	\N	2021-02-16 16:48:00
21	15	Zamora	\N	\N	\N	2021-02-16 16:48:00
22	16	Acosta	\N	\N	\N	2021-02-16 16:48:00
23	16	Aguasay	\N	\N	\N	2021-02-16 16:48:00
24	16	Bolivar	\N	\N	\N	2021-02-16 16:48:00
25	16	Caripe	\N	\N	\N	2021-02-16 16:48:00
26	16	Cedeño	\N	\N	\N	2021-02-16 16:48:00
27	16	Ezequiel Zamora	\N	\N	\N	2021-02-16 16:48:00
28	16	Libertador	\N	\N	\N	2021-02-16 16:48:00
29	16	Maturin	\N	\N	\N	2021-02-16 16:48:00
30	16	Piar	\N	\N	\N	2021-02-16 16:48:00
31	16	Punceres	\N	\N	\N	2021-02-16 16:48:00
32	16	Santa Barbara	\N	\N	\N	2021-02-16 16:48:00
33	16	Sotillo	\N	\N	\N	2021-02-16 16:48:00
34	16	Uracoa	\N	\N	\N	2021-02-16 16:48:00
35	17	Antolin del Campo	\N	\N	\N	2021-02-16 16:48:00
36	17	Arismendi	\N	\N	\N	2021-02-16 16:48:00
37	17	Diaz	\N	\N	\N	2021-02-16 16:48:00
38	17	Garcia	\N	\N	\N	2021-02-16 16:48:00
39	17	Gomez	\N	\N	\N	2021-02-16 16:48:00
40	17	Maneiro	\N	\N	\N	2021-02-16 16:48:00
41	17	Marcano	\N	\N	\N	2021-02-16 16:48:00
42	17	Mariño	\N	\N	\N	2021-02-16 16:48:00
43	17	Peninsula de Macanao	\N	\N	\N	2021-02-16 16:48:00
44	17	Tubores	\N	\N	\N	2021-02-16 16:48:00
45	17	Villalba	\N	\N	\N	2021-02-16 16:48:00
46	18	Agua Blanca	\N	\N	\N	2021-02-16 16:48:00
47	18	Araure	\N	\N	\N	2021-02-16 16:48:00
48	18	Esteller	\N	\N	\N	2021-02-16 16:48:00
49	18	Guanare	\N	\N	\N	2021-02-16 16:48:00
50	18	Guanarito	\N	\N	\N	2021-02-16 16:48:00
51	18	Monseñor Jose Vicente de Unda	\N	\N	\N	2021-02-16 16:48:00
52	18	Ospino	\N	\N	\N	2021-02-16 16:48:00
53	18	Paez	\N	\N	\N	2021-02-16 16:48:00
54	18	Papelon	\N	\N	\N	2021-02-16 16:48:00
55	18	San Genaro de Boconoito	\N	\N	\N	2021-02-16 16:48:00
56	18	San Rafael de Onoto	\N	\N	\N	2021-02-16 16:48:00
57	18	Santa Rosalia	\N	\N	\N	2021-02-16 16:48:00
58	18	Sucre	\N	\N	\N	2021-02-16 16:48:00
59	18	Turen	\N	\N	\N	2021-02-16 16:48:00
60	19	Andres Eloy Blanco	\N	\N	\N	2021-02-16 16:48:00
61	19	Andres Mata	\N	\N	\N	2021-02-16 16:48:00
62	19	Arismendi	\N	\N	\N	2021-02-16 16:48:00
63	19	Benitez	\N	\N	\N	2021-02-16 16:48:00
64	19	Bermudez	\N	\N	\N	2021-02-16 16:48:00
65	19	Bolivar	\N	\N	\N	2021-02-16 16:48:00
66	19	Cajigal	\N	\N	\N	2021-02-16 16:48:00
67	19	Cruz Salmeron Acosta	\N	\N	\N	2021-02-16 16:48:00
68	19	Libertador	\N	\N	\N	2021-02-16 16:48:00
69	19	Mariño	\N	\N	\N	2021-02-16 16:48:00
70	19	Mejia	\N	\N	\N	2021-02-16 16:48:00
71	19	Montes	\N	\N	\N	2021-02-16 16:48:00
72	19	Ribero	\N	\N	\N	2021-02-16 16:48:00
73	19	Sucre	\N	\N	\N	2021-02-16 16:48:00
74	19	Valdez	\N	\N	\N	2021-02-16 16:48:00
75	20	Andres Bello	\N	\N	\N	2021-02-16 16:48:00
76	20	Antonio Romulo Costa	\N	\N	\N	2021-02-16 16:48:00
77	20	Ayacucho	\N	\N	\N	2021-02-16 16:48:00
78	20	Bolivar	\N	\N	\N	2021-02-16 16:48:00
79	20	Cardenas	\N	\N	\N	2021-02-16 16:48:00
80	20	Cordoba	\N	\N	\N	2021-02-16 16:48:00
81	20	Fernandez Feo	\N	\N	\N	2021-02-16 16:48:00
82	20	Francisco de Miranda	\N	\N	\N	2021-02-16 16:48:00
83	20	Garcia de Hevia	\N	\N	\N	2021-02-16 16:48:00
84	20	Guasimos	\N	\N	\N	2021-02-16 16:48:00
85	20	Independencia	\N	\N	\N	2021-02-16 16:48:00
86	20	Jauregui	\N	\N	\N	2021-02-16 16:48:00
87	20	Jose Maria Vargas	\N	\N	\N	2021-02-16 16:48:00
88	20	Junin	\N	\N	\N	2021-02-16 16:48:00
89	20	Libertad	\N	\N	\N	2021-02-16 16:48:00
90	20	Libertador	\N	\N	\N	2021-02-16 16:48:00
91	20	Panamericano	\N	\N	\N	2021-02-16 16:48:00
92	20	Lobatera	\N	\N	\N	2021-02-16 16:48:00
93	20	Michelena	\N	\N	\N	2021-02-16 16:48:00
94	20	Pedro Maria Ureña	\N	\N	\N	2021-02-16 16:48:00
95	20	Rafael Urdaneta	\N	\N	\N	2021-02-16 16:48:00
96	20	Samuel Dario Maldonado	\N	\N	\N	2021-02-16 16:48:00
97	20	San Cristobal	\N	\N	\N	2021-02-16 16:48:00
98	20	San Judas Tadeo	\N	\N	\N	2021-02-16 16:48:00
99	20	Seboruco	\N	\N	\N	2021-02-16 16:48:00
100	20	Simon Rodriguez	\N	\N	\N	2021-02-16 16:48:00
101	20	Sucre	\N	\N	\N	2021-02-16 16:48:00
102	20	Torbes	\N	\N	\N	2021-02-16 16:48:00
103	20	Uribante	\N	\N	\N	2021-02-16 16:48:00
104	21	Andres Bello	\N	\N	\N	2021-02-16 16:48:00
105	21	Bocono	\N	\N	\N	2021-02-16 16:48:00
106	21	Bolivar	\N	\N	\N	2021-02-16 16:48:00
107	21	Candelaria	\N	\N	\N	2021-02-16 16:48:00
108	21	Carache	\N	\N	\N	2021-02-16 16:48:00
109	21	Escuque	\N	\N	\N	2021-02-16 16:48:00
110	21	Jose Felipe Marquez Cañizalez	\N	\N	\N	2021-02-16 16:48:00
111	21	Juan Vicente Campo Elias	\N	\N	\N	2021-02-16 16:48:00
112	21	La Ceiba	\N	\N	\N	2021-02-16 16:48:00
113	21	Miranda	\N	\N	\N	2021-02-16 16:48:00
114	21	Monte Carmelo	\N	\N	\N	2021-02-16 16:48:00
115	21	Motatan	\N	\N	\N	2021-02-16 16:48:00
116	21	Pampan	\N	\N	\N	2021-02-16 16:48:00
117	21	Pampanito	\N	\N	\N	2021-02-16 16:48:00
118	21	Rafael Rangel	\N	\N	\N	2021-02-16 16:48:00
119	21	San Rafael de Carvajal	\N	\N	\N	2021-02-16 16:48:00
120	21	Sucre	\N	\N	\N	2021-02-16 16:48:00
121	21	Trujillo	\N	\N	\N	2021-02-16 16:48:00
122	21	Urdaneta	\N	\N	\N	2021-02-16 16:48:00
123	21	Valera	\N	\N	\N	2021-02-16 16:48:00
125	22	Aristides Bastidas	\N	\N	\N	2021-02-16 16:48:00
126	22	Bolivar	\N	\N	\N	2021-02-16 16:48:00
127	22	Bruzual	\N	\N	\N	2021-02-16 16:48:00
128	22	Cocorote	\N	\N	\N	2021-02-16 16:48:00
129	22	Independencia	\N	\N	\N	2021-02-16 16:48:00
130	22	Jose Antonio Paez	\N	\N	\N	2021-02-16 16:48:00
131	22	La Trinidad	\N	\N	\N	2021-02-16 16:48:00
132	22	Manuel Monge	\N	\N	\N	2021-02-16 16:48:00
133	22	Nirgua	\N	\N	\N	2021-02-16 16:48:00
134	22	Peña	\N	\N	\N	2021-02-16 16:48:00
135	22	San Felipe	\N	\N	\N	2021-02-16 16:48:00
136	22	Sucre	\N	\N	\N	2021-02-16 16:48:00
137	22	Urachiche	\N	\N	\N	2021-02-16 16:48:00
138	22	Veroes	\N	\N	\N	2021-02-16 16:48:00
139	23	Almirante Padilla	\N	\N	\N	2021-02-16 16:48:00
140	23	Baralt	\N	\N	\N	2021-02-16 16:48:00
141	23	Cabimas	\N	\N	\N	2021-02-16 16:48:00
142	23	Catatumbo	\N	\N	\N	2021-02-16 16:48:00
143	23	Colon	\N	\N	\N	2021-02-16 16:48:00
144	23	Francisco Javier Pulgar	\N	\N	\N	2021-02-16 16:48:00
145	23	Jesus Enrique Lossada	\N	\N	\N	2021-02-16 16:48:00
146	23	Jesus Maria Semprum	\N	\N	\N	2021-02-16 16:48:00
147	23	La Cañada de Urdaneta	\N	\N	\N	2021-02-16 16:48:00
148	23	Lagunillas	\N	\N	\N	2021-02-16 16:48:00
149	23	Machiques de Perija	\N	\N	\N	2021-02-16 16:48:00
150	23	Mara	\N	\N	\N	2021-02-16 16:48:00
151	23	Maracaibo	\N	\N	\N	2021-02-16 16:48:00
152	23	Miranda	\N	\N	\N	2021-02-16 16:48:00
153	23	Paez	\N	\N	\N	2021-02-16 16:48:00
154	23	Rosario de Perija	\N	\N	\N	2021-02-16 16:48:00
155	23	San Francisco	\N	\N	\N	2021-02-16 16:48:00
156	23	Santa Rita	\N	\N	\N	2021-02-16 16:48:00
157	23	Simon Bolivar	\N	\N	\N	2021-02-16 16:48:00
158	23	Sucre	\N	\N	\N	2021-02-16 16:48:00
159	23	Valmore Rodriguez	\N	\N	\N	2021-02-16 16:48:00
124	24	Vargas	\N	\N	\N	2021-02-16 16:48:00
336	25	Aves de Barlovento y Aves de Sotavento	\N	\N	\N	2021-02-16 16:48:00
337	25	Isla Borracha	\N	\N	\N	2021-02-16 16:48:00
338	25	Isla la Blanquilla	\N	\N	\N	2021-02-16 16:48:00
339	25	Archipielago Los testigos	\N	\N	\N	2021-02-16 16:48:00
340	25	Archipielago de los Frailes	\N	\N	\N	2021-02-16 16:48:00
341	25	Archipielago de los Roques	\N	\N	\N	2021-02-16 16:48:00
342	25	La Tortuga	\N	\N	\N	2021-02-16 16:48:00
272	11	Falcón	\N	\N	\N	2021-02-16 16:48:00
160	2	Alto Orinoco	\N	\N	\N	2021-02-16 16:48:00
343	26	Perú	\N	\N	\N	2021-02-16 16:48:00
344	27	Inglaterra	\N	\N	\N	2021-02-16 16:48:00
345	28	Francia	\N	\N	\N	2021-02-16 16:48:00
346	29	España	\N	\N	\N	2021-02-16 16:48:00
347	30	Ecuador	\N	\N	\N	2021-02-16 16:48:00
348	31	Argentina	\N	\N	\N	2021-02-16 16:48:00
349	32	Chile	\N	\N	\N	2021-02-16 16:48:00
350	33	Mexico	\N	\N	\N	2021-02-16 16:48:00
\.


--
-- TOC entry 2318 (class 0 OID 422146)
-- Dependencies: 199
-- Data for Name: npais; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.npais (idpais, pais, latitud, longitud, idpersona2, fpersona2) FROM stdin;
1	Venezuela	\N	\N	\N	2021-02-16 16:48:00
\.


--
-- TOC entry 2321 (class 0 OID 422178)
-- Dependencies: 202
-- Data for Name: nparroquia; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nparroquia (idparroquia, idmunicipiofk, parroquia, latitud, longitud, idpersona2, fpersona2) FROM stdin;
232	1	Araguita	\N	\N	\N	2021-02-16 16:48:00
233	1	Arevalo González	\N	\N	\N	2021-02-16 16:48:00
234	1	Capaya	\N	\N	\N	2021-02-16 16:48:00
235	1	Caucagua	\N	\N	\N	2021-02-16 16:48:00
236	1	El Cafe	\N	\N	\N	2021-02-16 16:48:00
237	1	Marizapa	\N	\N	\N	2021-02-16 16:48:00
238	1	Panaquire	\N	\N	\N	2021-02-16 16:48:00
239	1	Ribas	\N	\N	\N	2021-02-16 16:48:00
240	2	Cumbo	\N	\N	\N	2021-02-16 16:48:00
241	2	San Jose de Barlovento	\N	\N	\N	2021-02-16 16:48:00
242	3	Baruta	\N	\N	\N	2021-02-16 16:48:00
243	3	El Cafetal	\N	\N	\N	2021-02-16 16:48:00
244	3	Las Minas de Baruta	\N	\N	\N	2021-02-16 16:48:00
245	4	Curiepe	\N	\N	\N	2021-02-16 16:48:00
246	4	Higuerote	\N	\N	\N	2021-02-16 16:48:00
247	4	Tacarigua	\N	\N	\N	2021-02-16 16:48:00
248	5	Mamporal	\N	\N	\N	2021-02-16 16:48:00
249	6	Carrizal	\N	\N	\N	2021-02-16 16:48:00
250	7	Chacao	\N	\N	\N	2021-02-16 16:48:00
251	8	Charallave	\N	\N	\N	2021-02-16 16:48:00
252	8	Las Brisas	\N	\N	\N	2021-02-16 16:48:00
253	9	El Hatillo	\N	\N	\N	2021-02-16 16:48:00
254	10	Altragracia de la M	\N	\N	\N	2021-02-16 16:48:00
255	10	Cecilio Acosta	\N	\N	\N	2021-02-16 16:48:00
256	10	El Jarillo	\N	\N	\N	2021-02-16 16:48:00
257	10	Los Teques	\N	\N	\N	2021-02-16 16:48:00
258	10	Paracotos	\N	\N	\N	2021-02-16 16:48:00
259	10	San Pedro	\N	\N	\N	2021-02-16 16:48:00
260	10	Tacata	\N	\N	\N	2021-02-16 16:48:00
261	11	El Cartanal	\N	\N	\N	2021-02-16 16:48:00
262	11	Sta Teresa del Tuy	\N	\N	\N	2021-02-16 16:48:00
263	12	La Democracia	\N	\N	\N	2021-02-16 16:48:00
264	12	Ocumare del Tuy	\N	\N	\N	2021-02-16 16:48:00
265	12	Santa Barbara	\N	\N	\N	2021-02-16 16:48:00
266	13	San Antonio de los Altos	\N	\N	\N	2021-02-16 16:48:00
267	14	El Guapo	\N	\N	\N	2021-02-16 16:48:00
268	14	Paparo	\N	\N	\N	2021-02-16 16:48:00
269	14	Rio Chico	\N	\N	\N	2021-02-16 16:48:00
270	14	San Fernando del Guapo	\N	\N	\N	2021-02-16 16:48:00
271	14	Tacarigua de la Laguna	\N	\N	\N	2021-02-16 16:48:00
272	15	Santa Lucia	\N	\N	\N	2021-02-16 16:48:00
273	16	Cupira	\N	\N	\N	2021-02-16 16:48:00
274	16	Machurucuto	\N	\N	\N	2021-02-16 16:48:00
275	17	Guarenas	\N	\N	\N	2021-02-16 16:48:00
276	18	San Francisco de Yare	\N	\N	\N	2021-02-16 16:48:00
277	18	San Antonio de Yare	\N	\N	\N	2021-02-16 16:48:00
278	19	Caucaguita	\N	\N	\N	2021-02-16 16:48:00
279	19	Filas de Mariches	\N	\N	\N	2021-02-16 16:48:00
280	19	La Dolorita	\N	\N	\N	2021-02-16 16:48:00
281	19	Leoncio Martinez	\N	\N	\N	2021-02-16 16:48:00
282	19	Petare	\N	\N	\N	2021-02-16 16:48:00
283	20	Cua	\N	\N	\N	2021-02-16 16:48:00
284	20	Nueva Cua	\N	\N	\N	2021-02-16 16:48:00
285	21	Bolivar	\N	\N	\N	2021-02-16 16:48:00
286	21	Guatire	\N	\N	\N	2021-02-16 16:48:00
287	22	San Antonio	\N	\N	\N	2021-02-16 16:48:00
288	22	San Francisco	\N	\N	\N	2021-02-16 16:48:00
289	23	Aguasay	\N	\N	\N	2021-02-16 16:48:00
290	24	Caripito	\N	\N	\N	2021-02-16 16:48:00
291	25	Caripe	\N	\N	\N	2021-02-16 16:48:00
292	25	El Guacharo	\N	\N	\N	2021-02-16 16:48:00
293	25	La Guanota	\N	\N	\N	2021-02-16 16:48:00
294	25	Sabana de Piedra	\N	\N	\N	2021-02-16 16:48:00
295	25	San Agustin	\N	\N	\N	2021-02-16 16:48:00
296	25	Teresen	\N	\N	\N	2021-02-16 16:48:00
297	26	Areo	\N	\N	\N	2021-02-16 16:48:00
298	26	Caicara	\N	\N	\N	2021-02-16 16:48:00
299	26	San Felix	\N	\N	\N	2021-02-16 16:48:00
300	26	Viento Fresco	\N	\N	\N	2021-02-16 16:48:00
301	27	El Tejero	\N	\N	\N	2021-02-16 16:48:00
302	27	Punta de Mata	\N	\N	\N	2021-02-16 16:48:00
303	28	Chaguaramas	\N	\N	\N	2021-02-16 16:48:00
304	28	Las Alhuacas	\N	\N	\N	2021-02-16 16:48:00
305	28	Tabasca	\N	\N	\N	2021-02-16 16:48:00
306	28	Temblador	\N	\N	\N	2021-02-16 16:48:00
307	29	Alto de los Godos	\N	\N	\N	2021-02-16 16:48:00
308	29	Boqueron	\N	\N	\N	2021-02-16 16:48:00
309	29	El Corozo	\N	\N	\N	2021-02-16 16:48:00
310	29	El Furrial	\N	\N	\N	2021-02-16 16:48:00
311	29	Jusepin	\N	\N	\N	2021-02-16 16:48:00
312	29	La Pica	\N	\N	\N	2021-02-16 16:48:00
313	29	Las Cocuizas	\N	\N	\N	2021-02-16 16:48:00
314	29	San Simon	\N	\N	\N	2021-02-16 16:48:00
315	29	Santa Cruz	\N	\N	\N	2021-02-16 16:48:00
316	29	San Vicente	\N	\N	\N	2021-02-16 16:48:00
317	30	Aparicio	\N	\N	\N	2021-02-16 16:48:00
318	30	Aragua	\N	\N	\N	2021-02-16 16:48:00
319	30	Chaguaramal	\N	\N	\N	2021-02-16 16:48:00
320	30	El Pinto	\N	\N	\N	2021-02-16 16:48:00
321	30	Guanaguana	\N	\N	\N	2021-02-16 16:48:00
322	30	La Toscana	\N	\N	\N	2021-02-16 16:48:00
323	30	Taguaya	\N	\N	\N	2021-02-16 16:48:00
324	31	Cachipo	\N	\N	\N	2021-02-16 16:48:00
325	31	Quiriquire	\N	\N	\N	2021-02-16 16:48:00
326	32	Santa Barbara	\N	\N	\N	2021-02-16 16:48:00
327	33	Barrancas	\N	\N	\N	2021-02-16 16:48:00
328	33	Los Barrancos de Fajardo	\N	\N	\N	2021-02-16 16:48:00
329	34	Uracoa	\N	\N	\N	2021-02-16 16:48:00
330	35	CM. La Plaza de Paraguachi	\N	\N	\N	2021-02-16 16:48:00
331	36	La Asuncion	\N	\N	\N	2021-02-16 16:48:00
332	37	San Juan Bautista	\N	\N	\N	2021-02-16 16:48:00
333	37	Zabala	\N	\N	\N	2021-02-16 16:48:00
334	38	Francisco Fajardo	\N	\N	\N	2021-02-16 16:48:00
335	38	Valle Esp Santo	\N	\N	\N	2021-02-16 16:48:00
336	39	Bolivar	\N	\N	\N	2021-02-16 16:48:00
337	39	Guevara	\N	\N	\N	2021-02-16 16:48:00
338	39	Matasiete	\N	\N	\N	2021-02-16 16:48:00
339	39	Santa Ana	\N	\N	\N	2021-02-16 16:48:00
340	39	Sucre	\N	\N	\N	2021-02-16 16:48:00
341	40	Aguirre	\N	\N	\N	2021-02-16 16:48:00
342	40	Pampatar	\N	\N	\N	2021-02-16 16:48:00
343	41	Adrian	\N	\N	\N	2021-02-16 16:48:00
344	41	Juan Griego	\N	\N	\N	2021-02-16 16:48:00
345	42	Porlamar	\N	\N	\N	2021-02-16 16:48:00
346	43	Boca del Rio	\N	\N	\N	2021-02-16 16:48:00
347	43	San Francisco	\N	\N	\N	2021-02-16 16:48:00
348	44	Los Barales	\N	\N	\N	2021-02-16 16:48:00
349	44	Punta de Piedras	\N	\N	\N	2021-02-16 16:48:00
350	45	San Pedro de Coche	\N	\N	\N	2021-02-16 16:48:00
351	45	Vicente Fuentes	\N	\N	\N	2021-02-16 16:48:00
352	46	Agua Blanca	\N	\N	\N	2021-02-16 16:48:00
353	47	Araure	\N	\N	\N	2021-02-16 16:48:00
354	47	Rio Acarigua	\N	\N	\N	2021-02-16 16:48:00
355	48	Piritu	\N	\N	\N	2021-02-16 16:48:00
356	48	Uveral	\N	\N	\N	2021-02-16 16:48:00
357	49	Cordoba	\N	\N	\N	2021-02-16 16:48:00
358	49	Guanare	\N	\N	\N	2021-02-16 16:48:00
359	49	San Jose de la Montaña	\N	\N	\N	2021-02-16 16:48:00
360	49	San Juan Guanaguanare	\N	\N	\N	2021-02-16 16:48:00
361	49	Virgen de la Coromoto	\N	\N	\N	2021-02-16 16:48:00
362	50	Divina Pastora	\N	\N	\N	2021-02-16 16:48:00
363	50	Guanarito	\N	\N	\N	2021-02-16 16:48:00
364	50	Trinidad de la Capilla	\N	\N	\N	2021-02-16 16:48:00
365	51	Chabasquen	\N	\N	\N	2021-02-16 16:48:00
366	51	Peña Blanca	\N	\N	\N	2021-02-16 16:48:00
367	52	Aparicion	\N	\N	\N	2021-02-16 16:48:00
368	52	La Estacion	\N	\N	\N	2021-02-16 16:48:00
369	52	Ospino	\N	\N	\N	2021-02-16 16:48:00
370	53	Acarigua	\N	\N	\N	2021-02-16 16:48:00
371	53	Payara	\N	\N	\N	2021-02-16 16:48:00
372	53	Pimpinela	\N	\N	\N	2021-02-16 16:48:00
373	53	Ramon Peraza	\N	\N	\N	2021-02-16 16:48:00
374	54	Caño Delgadito	\N	\N	\N	2021-02-16 16:48:00
375	54	Papelon	\N	\N	\N	2021-02-16 16:48:00
376	55	Antolin Tovar Aquino	\N	\N	\N	2021-02-16 16:48:00
377	55	Boconoito	\N	\N	\N	2021-02-16 16:48:00
378	56	San Rafael de Onoto	\N	\N	\N	2021-02-16 16:48:00
379	56	Santa Fe	\N	\N	\N	2021-02-16 16:48:00
380	56	Thermo Morles	\N	\N	\N	2021-02-16 16:48:00
381	57	El Playon	\N	\N	\N	2021-02-16 16:48:00
382	57	Florida	\N	\N	\N	2021-02-16 16:48:00
383	58	Biscucuy	\N	\N	\N	2021-02-16 16:48:00
384	58	Concepcion	\N	\N	\N	2021-02-16 16:48:00
385	58	San Jose de Saguaz	\N	\N	\N	2021-02-16 16:48:00
386	58	San Rafael Palo Alzado	\N	\N	\N	2021-02-16 16:48:00
387	58	Uvencio a Velasquez	\N	\N	\N	2021-02-16 16:48:00
388	58	Villa Rosa	\N	\N	\N	2021-02-16 16:48:00
389	59	Canelones	\N	\N	\N	2021-02-16 16:48:00
390	59	San Isidro Labrador	\N	\N	\N	2021-02-16 16:48:00
391	59	Santa Cruz	\N	\N	\N	2021-02-16 16:48:00
392	59	Villa Bruzual	\N	\N	\N	2021-02-16 16:48:00
393	60	Mariño	\N	\N	\N	2021-02-16 16:48:00
394	60	Romulo Gallegos	\N	\N	\N	2021-02-16 16:48:00
395	61	San Jose de Areocuar	\N	\N	\N	2021-02-16 16:48:00
396	61	Tavera Acosta	\N	\N	\N	2021-02-16 16:48:00
397	62	Antonio Jose de Sucre	\N	\N	\N	2021-02-16 16:48:00
398	62	El Morro de Pto Santo	\N	\N	\N	2021-02-16 16:48:00
399	62	Puerto Santo	\N	\N	\N	2021-02-16 16:48:00
400	62	Rio Caribe	\N	\N	\N	2021-02-16 16:48:00
401	62	San Juan Galdonas	\N	\N	\N	2021-02-16 16:48:00
402	63	El Pilar	\N	\N	\N	2021-02-16 16:48:00
403	63	El Rincon	\N	\N	\N	2021-02-16 16:48:00
404	63	Gral Fco. A Vasquez	\N	\N	\N	2021-02-16 16:48:00
405	63	Guaraunos	\N	\N	\N	2021-02-16 16:48:00
406	63	Tunapuicito	\N	\N	\N	2021-02-16 16:48:00
407	63	Union	\N	\N	\N	2021-02-16 16:48:00
408	64	Bolivar	\N	\N	\N	2021-02-16 16:48:00
409	64	Macarapana	\N	\N	\N	2021-02-16 16:48:00
410	64	Santa Catalina	\N	\N	\N	2021-02-16 16:48:00
411	64	Santa Rosa	\N	\N	\N	2021-02-16 16:48:00
412	64	Santa Teresa	\N	\N	\N	2021-02-16 16:48:00
413	65	Mariguitar	\N	\N	\N	2021-02-16 16:48:00
414	66	Libertad	\N	\N	\N	2021-02-16 16:48:00
415	66	Paujil	\N	\N	\N	2021-02-16 16:48:00
416	66	Yaguaraparo	\N	\N	\N	2021-02-16 16:48:00
417	67	Araya	\N	\N	\N	2021-02-16 16:48:00
418	67	Chacopata	\N	\N	\N	2021-02-16 16:48:00
419	67	Manicuare	\N	\N	\N	2021-02-16 16:48:00
420	68	Campo Elias	\N	\N	\N	2021-02-16 16:48:00
421	68	Tunapuy	\N	\N	\N	2021-02-16 16:48:00
422	69	Campo Claro	\N	\N	\N	2021-02-16 16:48:00
423	69	Irapa	\N	\N	\N	2021-02-16 16:48:00
424	69	Marabal	\N	\N	\N	2021-02-16 16:48:00
425	69	San Antonio de Irapa	\N	\N	\N	2021-02-16 16:48:00
426	69	Soro	\N	\N	\N	2021-02-16 16:48:00
427	70	San Ant del Golfo	\N	\N	\N	2021-02-16 16:48:00
428	71	Arenas	\N	\N	\N	2021-02-16 16:48:00
429	71	Aricagua	\N	\N	\N	2021-02-16 16:48:00
430	71	Cocollar	\N	\N	\N	2021-02-16 16:48:00
431	71	Cumanacoa	\N	\N	\N	2021-02-16 16:48:00
432	71	San Fernando	\N	\N	\N	2021-02-16 16:48:00
433	71	San Lorenzo	\N	\N	\N	2021-02-16 16:48:00
434	72	Cariaco	\N	\N	\N	2021-02-16 16:48:00
435	72	Catuaro	\N	\N	\N	2021-02-16 16:48:00
436	72	Rendon	\N	\N	\N	2021-02-16 16:48:00
437	72	Santa Cruz	\N	\N	\N	2021-02-16 16:48:00
438	72	Santa Maria	\N	\N	\N	2021-02-16 16:48:00
439	73	Altagracia	\N	\N	\N	2021-02-16 16:48:00
440	73	Ayacucho	\N	\N	\N	2021-02-16 16:48:00
441	73	Gran Mariscal	\N	\N	\N	2021-02-16 16:48:00
442	73	Raul Leoni	\N	\N	\N	2021-02-16 16:48:00
443	73	San Juan	\N	\N	\N	2021-02-16 16:48:00
444	73	Santa Ines	\N	\N	\N	2021-02-16 16:48:00
445	73	Valentin Valiente	\N	\N	\N	2021-02-16 16:48:00
446	74	Bideau	\N	\N	\N	2021-02-16 16:48:00
447	74	Cristobal Colon	\N	\N	\N	2021-02-16 16:48:00
448	74	Guiria	\N	\N	\N	2021-02-16 16:48:00
449	74	Punta de Piedra	\N	\N	\N	2021-02-16 16:48:00
450	75	Cordero	\N	\N	\N	2021-02-16 16:48:00
451	76	Las Mesas	\N	\N	\N	2021-02-16 16:48:00
452	77	Colon	\N	\N	\N	2021-02-16 16:48:00
453	77	Rivas Berti	\N	\N	\N	2021-02-16 16:48:00
454	77	San Pedro del Rio	\N	\N	\N	2021-02-16 16:48:00
455	78	Isaias Medina Angarita	\N	\N	\N	2021-02-16 16:48:00
456	78	Juan Vicente Gomez	\N	\N	\N	2021-02-16 16:48:00
457	78	Palotal	\N	\N	\N	2021-02-16 16:48:00
458	78	San Ant del Tachira	\N	\N	\N	2021-02-16 16:48:00
459	79	 Amenodoro Rangel Lamu	\N	\N	\N	2021-02-16 16:48:00
460	79	La Florida	\N	\N	\N	2021-02-16 16:48:00
461	79	Tariba	\N	\N	\N	2021-02-16 16:48:00
462	80	Sta. Ana del Tachira	\N	\N	\N	2021-02-16 16:48:00
463	81	Alberto Adriani	\N	\N	\N	2021-02-16 16:48:00
464	81	CM. San Rafael del Pinal	\N	\N	\N	2021-02-16 16:48:00
465	81	Santo Domingo	\N	\N	\N	2021-02-16 16:48:00
466	82	San Jose de Bolivar	\N	\N	\N	2021-02-16 16:48:00
467	83	Boca de Grita	\N	\N	\N	2021-02-16 16:48:00
468	83	Jose Antonio Paez	\N	\N	\N	2021-02-16 16:48:00
469	83	La Fria	\N	\N	\N	2021-02-16 16:48:00
470	84	Palmira	\N	\N	\N	2021-02-16 16:48:00
471	85	Capacho Nuevo	\N	\N	\N	2021-02-16 16:48:00
472	85	Juan German Roscio	\N	\N	\N	2021-02-16 16:48:00
473	85	Roman Cardenas	\N	\N	\N	2021-02-16 16:48:00
474	86	Emilio C. Guerrero	\N	\N	\N	2021-02-16 16:48:00
475	86	La Grita	\N	\N	\N	2021-02-16 16:48:00
476	86	Mons. Miguel a Salas	\N	\N	\N	2021-02-16 16:48:00
477	87	El Cobre	\N	\N	\N	2021-02-16 16:48:00
478	88	Bramon	\N	\N	\N	2021-02-16 16:48:00
479	88	La Petrolea	\N	\N	\N	2021-02-16 16:48:00
480	88	Quinimari	\N	\N	\N	2021-02-16 16:48:00
481	88	Rubio	\N	\N	\N	2021-02-16 16:48:00
482	89	Capacho Viejo	\N	\N	\N	2021-02-16 16:48:00
483	89	Cipriano Castro	\N	\N	\N	2021-02-16 16:48:00
484	89	Manuel Felipe Rugeles	\N	\N	\N	2021-02-16 16:48:00
485	90	Abejales	\N	\N	\N	2021-02-16 16:48:00
486	90	Doradas	\N	\N	\N	2021-02-16 16:48:00
487	90	Emeterio Ochoa	\N	\N	\N	2021-02-16 16:48:00
488	90	San Joaquin de Navay	\N	\N	\N	2021-02-16 16:48:00
492	91	Coloncito	\N	\N	\N	2021-02-16 16:48:00
493	91	La Palmita	\N	\N	\N	2021-02-16 16:48:00
489	92	Constitucion	\N	\N	\N	2021-02-16 16:48:00
490	92	Lobatera	\N	\N	\N	2021-02-16 16:48:00
491	93	Michelena	\N	\N	\N	2021-02-16 16:48:00
494	94	Nueva Arcadia	\N	\N	\N	2021-02-16 16:48:00
495	94	Ureña	\N	\N	\N	2021-02-16 16:48:00
496	95	Delicias	\N	\N	\N	2021-02-16 16:48:00
497	96	Bocono	\N	\N	\N	2021-02-16 16:48:00
498	96	Hernandez	\N	\N	\N	2021-02-16 16:48:00
499	96	La Tendida	\N	\N	\N	2021-02-16 16:48:00
500	97	Dr. Fco. Romero Lobo	\N	\N	\N	2021-02-16 16:48:00
501	97	La Concordia	\N	\N	\N	2021-02-16 16:48:00
502	97	Pedro Maria Morantes	\N	\N	\N	2021-02-16 16:48:00
503	97	San Sebastian	\N	\N	\N	2021-02-16 16:48:00
504	97	San Juan Bautista	\N	\N	\N	2021-02-16 16:48:00
505	98	Umuquena	\N	\N	\N	2021-02-16 16:48:00
506	99	Seboruco	\N	\N	\N	2021-02-16 16:48:00
507	100	San Simon	\N	\N	\N	2021-02-16 16:48:00
508	101	Eleazar Lopez Contrera	\N	\N	\N	2021-02-16 16:48:00
509	101	Queniquea	\N	\N	\N	2021-02-16 16:48:00
510	101	San Pablo	\N	\N	\N	2021-02-16 16:48:00
511	102	San Josecito	\N	\N	\N	2021-02-16 16:48:00
1137	102	Torbes	\N	\N	\N	2021-02-16 16:48:00
512	103	Cardenas	\N	\N	\N	2021-02-16 16:48:00
513	103	Juan Pablo Peñaloza	\N	\N	\N	2021-02-16 16:48:00
514	103	Potosi	\N	\N	\N	2021-02-16 16:48:00
515	103	Pregonero	\N	\N	\N	2021-02-16 16:48:00
1	104	Araguaney	\N	\N	\N	2021-02-16 16:48:00
2	104	El Jaguito	\N	\N	\N	2021-02-16 16:48:00
3	104	La Esperanza	\N	\N	\N	2021-02-16 16:48:00
4	104	Santa Isabel	\N	\N	\N	2021-02-16 16:48:00
5	105	Ayacucho	\N	\N	\N	2021-02-16 16:48:00
6	105	Bocono	\N	\N	\N	2021-02-16 16:48:00
7	105	Burbusay	\N	\N	\N	2021-02-16 16:48:00
8	105	El Carmen	\N	\N	\N	2021-02-16 16:48:00
9	105	General Rivas	\N	\N	\N	2021-02-16 16:48:00
10	105	Guaramacal	\N	\N	\N	2021-02-16 16:48:00
11	105	La Vega de Guaramacal	\N	\N	\N	2021-02-16 16:48:00
12	105	Monseñor Jauregui	\N	\N	\N	2021-02-16 16:48:00
13	105	Mosquey	\N	\N	\N	2021-02-16 16:48:00
14	105	Rafael Rangel	\N	\N	\N	2021-02-16 16:48:00
15	105	San Jose	\N	\N	\N	2021-02-16 16:48:00
16	105	San Miguel	\N	\N	\N	2021-02-16 16:48:00
17	106	Cheregue	\N	\N	\N	2021-02-16 16:48:00
18	106	Granados	\N	\N	\N	2021-02-16 16:48:00
19	106	Sabana Grande	\N	\N	\N	2021-02-16 16:48:00
20	107	Arnoldo Gabaldon	\N	\N	\N	2021-02-16 16:48:00
21	107	Bolivia	\N	\N	\N	2021-02-16 16:48:00
22	107	Carrillo	\N	\N	\N	2021-02-16 16:48:00
23	107	Cegarra	\N	\N	\N	2021-02-16 16:48:00
24	107	Chejende	\N	\N	\N	2021-02-16 16:48:00
25	107	Manuel Salvador Ulloa	\N	\N	\N	2021-02-16 16:48:00
26	107	San Jose	\N	\N	\N	2021-02-16 16:48:00
27	108	Carache	\N	\N	\N	2021-02-16 16:48:00
28	108	Cuicas	\N	\N	\N	2021-02-16 16:48:00
29	108	La Concepcion	\N	\N	\N	2021-02-16 16:48:00
30	108	Panamericana	\N	\N	\N	2021-02-16 16:48:00
31	108	Santa Cruz	\N	\N	\N	2021-02-16 16:48:00
32	109	Escuque	\N	\N	\N	2021-02-16 16:48:00
33	109	La Union	\N	\N	\N	2021-02-16 16:48:00
34	109	Sabana Libre	\N	\N	\N	2021-02-16 16:48:00
35	109	Santa Rita	\N	\N	\N	2021-02-16 16:48:00
36	110	Antonio Jose de Sucre	\N	\N	\N	2021-02-16 16:48:00
37	110	El Socorro	\N	\N	\N	2021-02-16 16:48:00
38	110	Los Caprichos	\N	\N	\N	2021-02-16 16:48:00
39	111	Arnoldo Gabaldon	\N	\N	\N	2021-02-16 16:48:00
40	111	Campo Elias	\N	\N	\N	2021-02-16 16:48:00
41	112	El Progreso	\N	\N	\N	2021-02-16 16:48:00
42	112	La Ceiba	\N	\N	\N	2021-02-16 16:48:00
43	112	Santa Apolonia	\N	\N	\N	2021-02-16 16:48:00
44	112	Tres de Febrero	\N	\N	\N	2021-02-16 16:48:00
45	113	Agua Caliente	\N	\N	\N	2021-02-16 16:48:00
46	113	Agua Santa	\N	\N	\N	2021-02-16 16:48:00
47	113	El Cenizo	\N	\N	\N	2021-02-16 16:48:00
48	113	El Dividive	\N	\N	\N	2021-02-16 16:48:00
49	113	Valerita	\N	\N	\N	2021-02-16 16:48:00
50	114	Buena Vista	\N	\N	\N	2021-02-16 16:48:00
51	114	Monte Carmelo	\N	\N	\N	2021-02-16 16:48:00
52	114	Sta Maria del Horcon	\N	\N	\N	2021-02-16 16:48:00
53	115	El Baño	\N	\N	\N	2021-02-16 16:48:00
54	115	Jalisco	\N	\N	\N	2021-02-16 16:48:00
55	115	Motatan	\N	\N	\N	2021-02-16 16:48:00
56	116	Flor de Patria	\N	\N	\N	2021-02-16 16:48:00
57	116	La Paz	\N	\N	\N	2021-02-16 16:48:00
58	116	PamPan	\N	\N	\N	2021-02-16 16:48:00
59	116	Santa Ana	\N	\N	\N	2021-02-16 16:48:00
60	117	La Concepcion	\N	\N	\N	2021-02-16 16:48:00
61	117	Pampanito	\N	\N	\N	2021-02-16 16:48:00
62	117	Pampanito II	\N	\N	\N	2021-02-16 16:48:00
63	118	Betijoque	\N	\N	\N	2021-02-16 16:48:00
64	118	El Cedro	\N	\N	\N	2021-02-16 16:48:00
65	118	Jose G Hernandez	\N	\N	\N	2021-02-16 16:48:00
66	118	La Pueblita	\N	\N	\N	2021-02-16 16:48:00
67	119	Antonio N Briceño	\N	\N	\N	2021-02-16 16:48:00
68	119	Campo Alegre	\N	\N	\N	2021-02-16 16:48:00
69	119	Carvajal	\N	\N	\N	2021-02-16 16:48:00
70	119	Jose Leonardo Suarez	\N	\N	\N	2021-02-16 16:48:00
71	120	El Paraiso	\N	\N	\N	2021-02-16 16:48:00
72	120	Junin	\N	\N	\N	2021-02-16 16:48:00
73	120	Sabana de Mendoza	\N	\N	\N	2021-02-16 16:48:00
74	120	Valmore Rodriguez	\N	\N	\N	2021-02-16 16:48:00
75	121	Andres Linares	\N	\N	\N	2021-02-16 16:48:00
76	121	Chiquinquira	\N	\N	\N	2021-02-16 16:48:00
77	121	Cristobal Mendoza	\N	\N	\N	2021-02-16 16:48:00
78	121	Cruz Carrillo	\N	\N	\N	2021-02-16 16:48:00
79	121	Matriz	\N	\N	\N	2021-02-16 16:48:00
80	121	Monseñor Carrillo	\N	\N	\N	2021-02-16 16:48:00
81	121	Tres Esquinas 	\N	\N	\N	2021-02-16 16:48:00
82	122	Cabimbu	\N	\N	\N	2021-02-16 16:48:00
83	122	Jajo	\N	\N	\N	2021-02-16 16:48:00
84	122	La Mesa	\N	\N	\N	2021-02-16 16:48:00
85	122	La Quebrada	\N	\N	\N	2021-02-16 16:48:00
86	122	Santiago	\N	\N	\N	2021-02-16 16:48:00
87	122	Tuñame	\N	\N	\N	2021-02-16 16:48:00
88	123	Juan Ignacio Montilla	\N	\N	\N	2021-02-16 16:48:00
89	123	La Beatriz	\N	\N	\N	2021-02-16 16:48:00
90	123	La Puerta	\N	\N	\N	2021-02-16 16:48:00
91	123	Mendoza	\N	\N	\N	2021-02-16 16:48:00
92	123	Mercedes Diaz	\N	\N	\N	2021-02-16 16:48:00
93	123	San Luis	\N	\N	\N	2021-02-16 16:48:00
94	124	Caraballeda	\N	\N	\N	2021-02-16 16:48:00
95	124	Carayaca	\N	\N	\N	2021-02-16 16:48:00
96	124	Carlos Soublette	\N	\N	\N	2021-02-16 16:48:00
97	124	Caruao	\N	\N	\N	2021-02-16 16:48:00
98	124	Catia La Mar	\N	\N	\N	2021-02-16 16:48:00
99	124	El Junko	\N	\N	\N	2021-02-16 16:48:00
100	124	La Guaira	\N	\N	\N	2021-02-16 16:48:00
101	124	Macuto	\N	\N	\N	2021-02-16 16:48:00
102	124	Maiquetia	\N	\N	\N	2021-02-16 16:48:00
103	124	Naiguata	\N	\N	\N	2021-02-16 16:48:00
104	124	Raul Leoni	\N	\N	\N	2021-02-16 16:48:00
105	125	San Pablo	\N	\N	\N	2021-02-16 16:48:00
106	126	Aroa	\N	\N	\N	2021-02-16 16:48:00
107	127	Campo Elias	\N	\N	\N	2021-02-16 16:48:00
108	127	Chivacoa	\N	\N	\N	2021-02-16 16:48:00
109	128	Cocorote	\N	\N	\N	2021-02-16 16:48:00
110	129	Independencia	\N	\N	\N	2021-02-16 16:48:00
111	130	Sabana de Parra	\N	\N	\N	2021-02-16 16:48:00
112	131	Boraure	\N	\N	\N	2021-02-16 16:48:00
113	132	Yumare	\N	\N	\N	2021-02-16 16:48:00
114	133	Nirgua	\N	\N	\N	2021-02-16 16:48:00
115	133	Salom	\N	\N	\N	2021-02-16 16:48:00
116	133	Temerla	\N	\N	\N	2021-02-16 16:48:00
117	134	San Andres	\N	\N	\N	2021-02-16 16:48:00
118	134	Yaritagua	\N	\N	\N	2021-02-16 16:48:00
119	135	Albarico	\N	\N	\N	2021-02-16 16:48:00
120	135	San Felipe	\N	\N	\N	2021-02-16 16:48:00
121	135	San Javier	\N	\N	\N	2021-02-16 16:48:00
122	136	Guama	\N	\N	\N	2021-02-16 16:48:00
123	137	Urachiche	\N	\N	\N	2021-02-16 16:48:00
124	138	El Guayabo	\N	\N	\N	2021-02-16 16:48:00
125	138	Farriar	\N	\N	\N	2021-02-16 16:48:00
126	139	Isla de Toas	\N	\N	\N	2021-02-16 16:48:00
127	139	Monagas	\N	\N	\N	2021-02-16 16:48:00
128	140	General Urdaneta	\N	\N	\N	2021-02-16 16:48:00
129	140	Libertador	\N	\N	\N	2021-02-16 16:48:00
130	140	Manuel Guanipa Matos	\N	\N	\N	2021-02-16 16:48:00
131	140	Marcelino Briceño	\N	\N	\N	2021-02-16 16:48:00
132	140	Pueblo Nuevo	\N	\N	\N	2021-02-16 16:48:00
133	140	San Timoteo	\N	\N	\N	2021-02-16 16:48:00
134	141	Ambrosio	\N	\N	\N	2021-02-16 16:48:00
135	141	Aristides Calvani	\N	\N	\N	2021-02-16 16:48:00
136	141	Carmen Herrera	\N	\N	\N	2021-02-16 16:48:00
137	141	German Rios Linares	\N	\N	\N	2021-02-16 16:48:00
138	141	Jorge Hernandez	\N	\N	\N	2021-02-16 16:48:00
139	141	La Rosa	\N	\N	\N	2021-02-16 16:48:00
140	141	Punta Gorda	\N	\N	\N	2021-02-16 16:48:00
141	141	Romulo Betancourt	\N	\N	\N	2021-02-16 16:48:00
142	141	San Benito	\N	\N	\N	2021-02-16 16:48:00
143	142	Encontrados	\N	\N	\N	2021-02-16 16:48:00
144	142	Udon Perez	\N	\N	\N	2021-02-16 16:48:00
145	143	Moralito	\N	\N	\N	2021-02-16 16:48:00
146	143	San Carlos del Zulia	\N	\N	\N	2021-02-16 16:48:00
147	143	Santa Barbara	\N	\N	\N	2021-02-16 16:48:00
148	143	Santa Cruz del Zulia	\N	\N	\N	2021-02-16 16:48:00
149	143	Urribarri	\N	\N	\N	2021-02-16 16:48:00
150	144	Carlos Quevedo	\N	\N	\N	2021-02-16 16:48:00
151	144	Francisco J Pulgar	\N	\N	\N	2021-02-16 16:48:00
152	144	Simon Rodriguez	\N	\N	\N	2021-02-16 16:48:00
153	145	Jose Ramon Yepez	\N	\N	\N	2021-02-16 16:48:00
154	145	La Concepcion	\N	\N	\N	2021-02-16 16:48:00
155	145	Mariano Parra Leon	\N	\N	\N	2021-02-16 16:48:00
156	145	San Jose	\N	\N	\N	2021-02-16 16:48:00
157	146	Bari	\N	\N	\N	2021-02-16 16:48:00
158	146	Jesus M Semprum	\N	\N	\N	2021-02-16 16:48:00
159	147	Andres Bello (Km 48);	\N	\N	\N	2021-02-16 16:48:00
160	147	Chiquinquira	\N	\N	\N	2021-02-16 16:48:00
161	147	Concepcion	\N	\N	\N	2021-02-16 16:48:00
162	147	El Carmelo	\N	\N	\N	2021-02-16 16:48:00
163	147	Potreritos	\N	\N	\N	2021-02-16 16:48:00
164	148	Alonso de Ojeda	\N	\N	\N	2021-02-16 16:48:00
165	148	Campo Lara	\N	\N	\N	2021-02-16 16:48:00
166	148	Eleazar Lopez C	\N	\N	\N	2021-02-16 16:48:00
167	148	Libertad	\N	\N	\N	2021-02-16 16:48:00
168	148	Venezuela	\N	\N	\N	2021-02-16 16:48:00
169	149	Bartolome de las Casas	\N	\N	\N	2021-02-16 16:48:00
170	149	Libertad	\N	\N	\N	2021-02-16 16:48:00
171	149	Rio Negro	\N	\N	\N	2021-02-16 16:48:00
172	149	San Jose de Perija	\N	\N	\N	2021-02-16 16:48:00
173	150	La Sierrita	\N	\N	\N	2021-02-16 16:48:00
174	150	Las Parcelas	\N	\N	\N	2021-02-16 16:48:00
175	150	Luis de Vicente	\N	\N	\N	2021-02-16 16:48:00
176	150	Mons. Marcos Sergio G	\N	\N	\N	2021-02-16 16:48:00
177	150	Ricaurte	\N	\N	\N	2021-02-16 16:48:00
178	150	San Rafael	\N	\N	\N	2021-02-16 16:48:00
179	150	Tamare	\N	\N	\N	2021-02-16 16:48:00
180	151	Antonio Borjas Romero	\N	\N	\N	2021-02-16 16:48:00
181	151	Bolivar	\N	\N	\N	2021-02-16 16:48:00
182	151	Cacique Mara	\N	\N	\N	2021-02-16 16:48:00
183	151	Caracciolo Parra Perez	\N	\N	\N	2021-02-16 16:48:00
184	151	Cecilio Acosta	\N	\N	\N	2021-02-16 16:48:00
185	151	Chiquinquira	\N	\N	\N	2021-02-16 16:48:00
186	151	Coquivacoa	\N	\N	\N	2021-02-16 16:48:00
187	151	Cristo de Aranza	\N	\N	\N	2021-02-16 16:48:00
188	151	Francisco Eugenio B	\N	\N	\N	2021-02-16 16:48:00
189	151	Idelfonzo Vasquez	\N	\N	\N	2021-02-16 16:48:00
190	151	Juana de Avila	\N	\N	\N	2021-02-16 16:48:00
191	151	Luis Hurtado Higuera	\N	\N	\N	2021-02-16 16:48:00
192	151	Manuel Dagnino	\N	\N	\N	2021-02-16 16:48:00
193	151	Olegario Villalobos	\N	\N	\N	2021-02-16 16:48:00
194	151	Raul Leoni	\N	\N	\N	2021-02-16 16:48:00
195	151	San Isidro	\N	\N	\N	2021-02-16 16:48:00
196	151	Santa Lucia	\N	\N	\N	2021-02-16 16:48:00
197	151	Venancio Pulgar	\N	\N	\N	2021-02-16 16:48:00
198	152	Altagracia	\N	\N	\N	2021-02-16 16:48:00
199	152	Ana Maria Campos 	\N	\N	\N	2021-02-16 16:48:00
200	152	Faria	\N	\N	\N	2021-02-16 16:48:00
201	152	San Antonio	\N	\N	\N	2021-02-16 16:48:00
202	152	San Jose	\N	\N	\N	2021-02-16 16:48:00
203	153	Alta Guajira	\N	\N	\N	2021-02-16 16:48:00
204	153	Elias Sanchez Rubio	\N	\N	\N	2021-02-16 16:48:00
205	153	Goajira	\N	\N	\N	2021-02-16 16:48:00
206	153	Sinamaica	\N	\N	\N	2021-02-16 16:48:00
207	154	Donaldo Garcia	\N	\N	\N	2021-02-16 16:48:00
208	154	El Rosario	\N	\N	\N	2021-02-16 16:48:00
209	154	Sixto Zambrano	\N	\N	\N	2021-02-16 16:48:00
210	155	Domitila Flores	\N	\N	\N	2021-02-16 16:48:00
211	155	El Bajo	\N	\N	\N	2021-02-16 16:48:00
212	155	Francisco Ochoa	\N	\N	\N	2021-02-16 16:48:00
213	155	Los Cortijos	\N	\N	\N	2021-02-16 16:48:00
214	155	Marcial Hernandez	\N	\N	\N	2021-02-16 16:48:00
215	155	San Francisco	\N	\N	\N	2021-02-16 16:48:00
216	156	El Mene	\N	\N	\N	2021-02-16 16:48:00
217	156	Jose Cenovio Urribarr	\N	\N	\N	2021-02-16 16:48:00
218	156	Pedro Lucas Urribarri	\N	\N	\N	2021-02-16 16:48:00
219	156	Santa Rita	\N	\N	\N	2021-02-16 16:48:00
220	157	Manuel Manrique	\N	\N	\N	2021-02-16 16:48:00
221	157	Rafael Maria Baralt	\N	\N	\N	2021-02-16 16:48:00
222	157	Rafael Urdaneta	\N	\N	\N	2021-02-16 16:48:00
223	158	Bobures	\N	\N	\N	2021-02-16 16:48:00
224	158	El Batey	\N	\N	\N	2021-02-16 16:48:00
225	158	Gibraltar	\N	\N	\N	2021-02-16 16:48:00
226	158	Heras	\N	\N	\N	2021-02-16 16:48:00
227	158	M. Arturo Celestino A	\N	\N	\N	2021-02-16 16:48:00
228	158	Romulo Gallegos	\N	\N	\N	2021-02-16 16:48:00
229	159	La Victoria	\N	\N	\N	2021-02-16 16:48:00
230	159	Rafael Urdaneta	\N	\N	\N	2021-02-16 16:48:00
231	159	Raul Cuenca	\N	\N	\N	2021-02-16 16:48:00
783	160	La Esmeralda	\N	\N	\N	2021-02-16 16:48:00
784	160	Marawaka	\N	\N	\N	2021-02-16 16:48:00
785	160	Mavaca	\N	\N	\N	2021-02-16 16:48:00
786	160	Sierra Parima	\N	\N	\N	2021-02-16 16:48:00
787	161	Caname	\N	\N	\N	2021-02-16 16:48:00
788	161	San Fernando de Ataba	\N	\N	\N	2021-02-16 16:48:00
789	161	Ucata	\N	\N	\N	2021-02-16 16:48:00
790	161	Yapacana	\N	\N	\N	2021-02-16 16:48:00
791	162	Fernando Giron Tovar	\N	\N	\N	2021-02-16 16:48:00
792	162	Luis Alberto Gomez	\N	\N	\N	2021-02-16 16:48:00
793	162	Parhueña	\N	\N	\N	2021-02-16 16:48:00
794	162	Platanillal	\N	\N	\N	2021-02-16 16:48:00
795	163	Guayapo	\N	\N	\N	2021-02-16 16:48:00
796	163	Isla de Raton	\N	\N	\N	2021-02-16 16:48:00
797	163	Munduapo	\N	\N	\N	2021-02-16 16:48:00
798	163	Samariapo	\N	\N	\N	2021-02-16 16:48:00
799	163	Sipapo	\N	\N	\N	2021-02-16 16:48:00
800	164	Alto Ventuari	\N	\N	\N	2021-02-16 16:48:00
801	164	Bajo Ventuari	\N	\N	\N	2021-02-16 16:48:00
802	164	Medio Ventuari	\N	\N	\N	2021-02-16 16:48:00
803	164	San Juan de Manapiare	\N	\N	\N	2021-02-16 16:48:00
804	165	Comunidad	\N	\N	\N	2021-02-16 16:48:00
805	165	Maroa	\N	\N	\N	2021-02-16 16:48:00
806	165	Victorino	\N	\N	\N	2021-02-16 16:48:00
807	166	Casiquiare	\N	\N	\N	2021-02-16 16:48:00
808	166	Cocuy	\N	\N	\N	2021-02-16 16:48:00
809	166	San Carlos de Rio Negro	\N	\N	\N	2021-02-16 16:48:00
810	166	Solano	\N	\N	\N	2021-02-16 16:48:00
811	167	Anaco	\N	\N	\N	2021-02-16 16:48:00
812	167	San Joaquin	\N	\N	\N	2021-02-16 16:48:00
813	168	Aragua de Barcelona	\N	\N	\N	2021-02-16 16:48:00
814	168	Cachipo	\N	\N	\N	2021-02-16 16:48:00
815	169	Bergantin	\N	\N	\N	2021-02-16 16:48:00
816	169	Caigua	\N	\N	\N	2021-02-16 16:48:00
817	169	El Carmen	\N	\N	\N	2021-02-16 16:48:00
818	169	El Pilar	\N	\N	\N	2021-02-16 16:48:00
819	169	Naricual	\N	\N	\N	2021-02-16 16:48:00
820	169	San Cristobal	\N	\N	\N	2021-02-16 16:48:00
821	170	Clarines	\N	\N	\N	2021-02-16 16:48:00
822	170	Guanape	\N	\N	\N	2021-02-16 16:48:00
823	170	Sabana de Uchire	\N	\N	\N	2021-02-16 16:48:00
824	171	Onoto	\N	\N	\N	2021-02-16 16:48:00
825	171	San Pablo	\N	\N	\N	2021-02-16 16:48:00
826	172	Santa Barbara	\N	\N	\N	2021-02-16 16:48:00
827	172	Valle Guanape	\N	\N	\N	2021-02-16 16:48:00
828	173	Cantaura	\N	\N	\N	2021-02-16 16:48:00
829	173	Libertador	\N	\N	\N	2021-02-16 16:48:00
830	173	Santa Rosa	\N	\N	\N	2021-02-16 16:48:00
831	173	Urica	\N	\N	\N	2021-02-16 16:48:00
832	174	San Jose de Guanipa	\N	\N	\N	2021-02-16 16:48:00
833	175	Chorreron	\N	\N	\N	2021-02-16 16:48:00
834	175	Guanta	\N	\N	\N	2021-02-16 16:48:00
835	176	Mamo	\N	\N	\N	2021-02-16 16:48:00
836	176	Soledad	\N	\N	\N	2021-02-16 16:48:00
837	177	El Carito	\N	\N	\N	2021-02-16 16:48:00
838	177	San Mateo	\N	\N	\N	2021-02-16 16:48:00
839	177	Santa Ines	\N	\N	\N	2021-02-16 16:48:00
840	178	El Morro	\N	\N	\N	2021-02-16 16:48:00
841	178	Lecherias	\N	\N	\N	2021-02-16 16:48:00
842	179	El Chaparro	\N	\N	\N	2021-02-16 16:48:00
843	179	Tomas Alfaro Calatrava	\N	\N	\N	2021-02-16 16:48:00
844	180	Atapirire	\N	\N	\N	2021-02-16 16:48:00
845	180	Boca del Pao	\N	\N	\N	2021-02-16 16:48:00
846	180	El Pao	\N	\N	\N	2021-02-16 16:48:00
847	180	Pariaguan	\N	\N	\N	2021-02-16 16:48:00
848	181	Mapire	\N	\N	\N	2021-02-16 16:48:00
849	181	Piar	\N	\N	\N	2021-02-16 16:48:00
850	181	Santa Clara	\N	\N	\N	2021-02-16 16:48:00
851	181	San Diego de Cabrutica	\N	\N	\N	2021-02-16 16:48:00
852	181	Uverito	\N	\N	\N	2021-02-16 16:48:00
853	181	Zuata	\N	\N	\N	2021-02-16 16:48:00
854	182	Puerto Piritu	\N	\N	\N	2021-02-16 16:48:00
855	182	San Miguel	\N	\N	\N	2021-02-16 16:48:00
856	182	Sucre	\N	\N	\N	2021-02-16 16:48:00
857	183	Piritu	\N	\N	\N	2021-02-16 16:48:00
858	183	San Francisco	\N	\N	\N	2021-02-16 16:48:00
859	184	Boca de Chavez	\N	\N	\N	2021-02-16 16:48:00
860	184	Boca de Uchire	\N	\N	\N	2021-02-16 16:48:00
861	185	Pueblo Nuevo	\N	\N	\N	2021-02-16 16:48:00
862	185	Santa Ana	\N	\N	\N	2021-02-16 16:48:00
863	186	El Tigre	\N	\N	\N	2021-02-16 16:48:00
864	187	Cm. Puerto la Cruz	\N	\N	\N	2021-02-16 16:48:00
865	187	Pozuelos	\N	\N	\N	2021-02-16 16:48:00
866	188	Achaguas	\N	\N	\N	2021-02-16 16:48:00
867	188	Apurito	\N	\N	\N	2021-02-16 16:48:00
868	188	El Yagual	\N	\N	\N	2021-02-16 16:48:00
869	188	Guachara	\N	\N	\N	2021-02-16 16:48:00
870	188	Mucuritas	\N	\N	\N	2021-02-16 16:48:00
871	188	Queseras del Medio	\N	\N	\N	2021-02-16 16:48:00
872	189	Biruaca	\N	\N	\N	2021-02-16 16:48:00
873	190	Bruzual	\N	\N	\N	2021-02-16 16:48:00
874	190	Mantecal	\N	\N	\N	2021-02-16 16:48:00
875	190	Quintero	\N	\N	\N	2021-02-16 16:48:00
876	190	Rincon Hondo	\N	\N	\N	2021-02-16 16:48:00
877	190	San Vicente	\N	\N	\N	2021-02-16 16:48:00
878	191	Aramendi	\N	\N	\N	2021-02-16 16:48:00
879	191	El Amparo	\N	\N	\N	2021-02-16 16:48:00
880	191	Guasdualito	\N	\N	\N	2021-02-16 16:48:00
881	191	San Camilo	\N	\N	\N	2021-02-16 16:48:00
882	191	Urdaneta	\N	\N	\N	2021-02-16 16:48:00
883	192	Codazzi	\N	\N	\N	2021-02-16 16:48:00
884	192	Cunaviche	\N	\N	\N	2021-02-16 16:48:00
885	192	San Juan de Payara	\N	\N	\N	2021-02-16 16:48:00
886	193	Elorza	\N	\N	\N	2021-02-16 16:48:00
887	193	La Trinidad	\N	\N	\N	2021-02-16 16:48:00
888	194	El Recreo	\N	\N	\N	2021-02-16 16:48:00
889	194	Peñalver	\N	\N	\N	2021-02-16 16:48:00
890	194	San Fernando	\N	\N	\N	2021-02-16 16:48:00
891	194	San Rafael de Atamaica 	\N	\N	\N	2021-02-16 16:48:00
892	195	San Mateo	\N	\N	\N	2021-02-16 16:48:00
893	196	Camatagua	\N	\N	\N	2021-02-16 16:48:00
894	196	Carmen de Cura	\N	\N	\N	2021-02-16 16:48:00
895	197	Francisco de Miranda	\N	\N	\N	2021-02-16 16:48:00
896	197	Mons Feliciano G	\N	\N	\N	2021-02-16 16:48:00
897	197	Santa Rita	\N	\N	\N	2021-02-16 16:48:00
898	198	Andres Eloy Blanco	\N	\N	\N	2021-02-16 16:48:00
899	198	Choroni	\N	\N	\N	2021-02-16 16:48:00
900	198	Joaquin Crespo	\N	\N	\N	2021-02-16 16:48:00
901	198	Jose Casanova Godoy	\N	\N	\N	2021-02-16 16:48:00
902	198	Las Delicias	\N	\N	\N	2021-02-16 16:48:00
903	198	Los Tacariguas	\N	\N	\N	2021-02-16 16:48:00
904	198	Madre Ma de San Jose	\N	\N	\N	2021-02-16 16:48:00
905	198	Pedro Jose Ovalles	\N	\N	\N	2021-02-16 16:48:00
906	199	Santa Cruz	\N	\N	\N	2021-02-16 16:48:00
907	200	Castor Nieves Rios	\N	\N	\N	2021-02-16 16:48:00
908	200	Las Guacamayas	\N	\N	\N	2021-02-16 16:48:00
909	200	La Victoria	\N	\N	\N	2021-02-16 16:48:00
910	200	Pao de Zarate	\N	\N	\N	2021-02-16 16:48:00
911	200	Zuata	\N	\N	\N	2021-02-16 16:48:00
912	201	El Consejo	\N	\N	\N	2021-02-16 16:48:00
913	202	Palo Negro	\N	\N	\N	2021-02-16 16:48:00
914	202	San Martin de Porres	\N	\N	\N	2021-02-16 16:48:00
915	203	Caña de Azucar	\N	\N	\N	2021-02-16 16:48:00
916	203	El Limon	\N	\N	\N	2021-02-16 16:48:00
917	204	Ocumare de la Costa	\N	\N	\N	2021-02-16 16:48:00
918	205	Guiripa	\N	\N	\N	2021-02-16 16:48:00
919	205	Ollas de Caramacate	\N	\N	\N	2021-02-16 16:48:00
920	205	San Casimiro	\N	\N	\N	2021-02-16 16:48:00
921	205	Valle Morin	\N	\N	\N	2021-02-16 16:48:00
922	206	San Sebastian	\N	\N	\N	2021-02-16 16:48:00
923	207	Alfredo Pacheco M	\N	\N	\N	2021-02-16 16:48:00
924	207	Arevalo Aponte	\N	\N	\N	2021-02-16 16:48:00
925	207	Chuao	\N	\N	\N	2021-02-16 16:48:00
926	207	Saman de Guere	\N	\N	\N	2021-02-16 16:48:00
927	207	Turmero	\N	\N	\N	2021-02-16 16:48:00
1136	207	La Morita	\N	\N	\N	2021-02-16 16:48:00
928	208	Las Tejerias	\N	\N	\N	2021-02-16 16:48:00
929	208	Tiara	\N	\N	\N	2021-02-16 16:48:00
930	209	Bella Vista	\N	\N	\N	2021-02-16 16:48:00
931	209	Cagua	\N	\N	\N	2021-02-16 16:48:00
932	210	Colonia Tovar	\N	\N	\N	2021-02-16 16:48:00
933	211	Barbacoas	\N	\N	\N	2021-02-16 16:48:00
934	211	Las Peñitas	\N	\N	\N	2021-02-16 16:48:00
935	211	San Francisco de Cara	\N	\N	\N	2021-02-16 16:48:00
936	211	Taguay	\N	\N	\N	2021-02-16 16:48:00
937	212	Augusto Mijares	\N	\N	\N	2021-02-16 16:48:00
938	212	Magdaleno	\N	\N	\N	2021-02-16 16:48:00
939	212	San Francisco de Asis	\N	\N	\N	2021-02-16 16:48:00
940	212	Valles de Tucutunemo	\N	\N	\N	2021-02-16 16:48:00
941	212	Villa de Cura	\N	\N	\N	2021-02-16 16:48:00
942	213	Rodriguez Dominguez	\N	\N	\N	2021-02-16 16:48:00
943	213	Sabaneta	\N	\N	\N	2021-02-16 16:48:00
944	214	El Canton	\N	\N	\N	2021-02-16 16:48:00
945	214	Puerto Vivas	\N	\N	\N	2021-02-16 16:48:00
946	214	Santa Cruz de Guacas	\N	\N	\N	2021-02-16 16:48:00
947	215	Andres Bello	\N	\N	\N	2021-02-16 16:48:00
948	215	Nicolas Pulido	\N	\N	\N	2021-02-16 16:48:00
949	215	Ticoporo	\N	\N	\N	2021-02-16 16:48:00
950	216	Arismendi	\N	\N	\N	2021-02-16 16:48:00
951	216	Guadarrama	\N	\N	\N	2021-02-16 16:48:00
952	216	La Union	\N	\N	\N	2021-02-16 16:48:00
953	216	San Antonio	\N	\N	\N	2021-02-16 16:48:00
954	217	Alfredo A Larriva	\N	\N	\N	2021-02-16 16:48:00
955	217	Alto Barinas	\N	\N	\N	2021-02-16 16:48:00
956	217	Barinas	\N	\N	\N	2021-02-16 16:48:00
957	217	Corazon de Jesus	\N	\N	\N	2021-02-16 16:48:00
958	217	Dominga Ortiz P	\N	\N	\N	2021-02-16 16:48:00
959	217	El Carmen	\N	\N	\N	2021-02-16 16:48:00
960	217	Juan A Rodriguez D	\N	\N	\N	2021-02-16 16:48:00
961	217	Manuel P Fajardo	\N	\N	\N	2021-02-16 16:48:00
962	217	Ramon I Mendez	\N	\N	\N	2021-02-16 16:48:00
963	217	Romulo Betancourt	\N	\N	\N	2021-02-16 16:48:00
964	217	San Silvestre	\N	\N	\N	2021-02-16 16:48:00
965	217	Santa Ines	\N	\N	\N	2021-02-16 16:48:00
966	217	Santa Lucia	\N	\N	\N	2021-02-16 16:48:00
967	217	Torunos	\N	\N	\N	2021-02-16 16:48:00
968	218	Altamira	\N	\N	\N	2021-02-16 16:48:00
969	218	Barinitas	\N	\N	\N	2021-02-16 16:48:00
970	218	Calderas	\N	\N	\N	2021-02-16 16:48:00
971	219	Barrancas	\N	\N	\N	2021-02-16 16:48:00
972	219	El Socorro	\N	\N	\N	2021-02-16 16:48:00
973	219	Masparrito	\N	\N	\N	2021-02-16 16:48:00
974	220	El Real	\N	\N	\N	2021-02-16 16:48:00
975	220	La Luz	\N	\N	\N	2021-02-16 16:48:00
976	220	Los Guasimitos	\N	\N	\N	2021-02-16 16:48:00
977	220	Obispos	\N	\N	\N	2021-02-16 16:48:00
978	221	Ciudad Bolivia	\N	\N	\N	2021-02-16 16:48:00
979	221	Ignacio Briceño	\N	\N	\N	2021-02-16 16:48:00
980	221	Jose Felix Ribas	\N	\N	\N	2021-02-16 16:48:00
981	221	Paez	\N	\N	\N	2021-02-16 16:48:00
982	222	Dolores	\N	\N	\N	2021-02-16 16:48:00
983	222	Libertad	\N	\N	\N	2021-02-16 16:48:00
984	222	Palacio Fajardo	\N	\N	\N	2021-02-16 16:48:00
985	222	Santa Rosa	\N	\N	\N	2021-02-16 16:48:00
986	223	Ciudad de Nutrias	\N	\N	\N	2021-02-16 16:48:00
987	223	El Regalo	\N	\N	\N	2021-02-16 16:48:00
988	223	Puerto de Nutrias	\N	\N	\N	2021-02-16 16:48:00
989	223	Santa Catalina	\N	\N	\N	2021-02-16 16:48:00
990	224	Jose Ignacio del Pumar	\N	\N	\N	2021-02-16 16:48:00
991	224	Pedro Briceño Mendez	\N	\N	\N	2021-02-16 16:48:00
992	224	Ramon Ignacio Mendez	\N	\N	\N	2021-02-16 16:48:00
993	224	Santa Barbara	\N	\N	\N	2021-02-16 16:48:00
994	225	Cachamay	\N	\N	\N	2021-02-16 16:48:00
995	225	Chirica	\N	\N	\N	2021-02-16 16:48:00
996	225	Dalla Costa	\N	\N	\N	2021-02-16 16:48:00
997	225	Once de Abril	\N	\N	\N	2021-02-16 16:48:00
998	225	Pozo Verde	\N	\N	\N	2021-02-16 16:48:00
999	225	Simon Bolivar	\N	\N	\N	2021-02-16 16:48:00
1000	225	Unare	\N	\N	\N	2021-02-16 16:48:00
1001	225	Universidad	\N	\N	\N	2021-02-16 16:48:00
1002	225	Vista Al Sol	\N	\N	\N	2021-02-16 16:48:00
1003	225	Yocoima	\N	\N	\N	2021-02-16 16:48:00
1004	226	Altagracia	\N	\N	\N	2021-02-16 16:48:00
1005	226	Ascension Farreras	\N	\N	\N	2021-02-16 16:48:00
1006	226	Caicara del Orinoco	\N	\N	\N	2021-02-16 16:48:00
1007	226	Guaniamo	\N	\N	\N	2021-02-16 16:48:00
1008	226	La Urbana	\N	\N	\N	2021-02-16 16:48:00
1009	226	Pijiguaos	\N	\N	\N	2021-02-16 16:48:00
1010	227	El Callao	\N	\N	\N	2021-02-16 16:48:00
1011	228	Ikabaru	\N	\N	\N	2021-02-16 16:48:00
1012	228	Santa Elena de Uairen	\N	\N	\N	2021-02-16 16:48:00
1013	229	Agua Salada	\N	\N	\N	2021-02-16 16:48:00
1014	229	Catedral	\N	\N	\N	2021-02-16 16:48:00
1015	229	Jose Antonio Paez	\N	\N	\N	2021-02-16 16:48:00
1016	229	La Sabanita	\N	\N	\N	2021-02-16 16:48:00
1017	229	Marhuanta	\N	\N	\N	2021-02-16 16:48:00
1018	229	Orinoco	\N	\N	\N	2021-02-16 16:48:00
1019	229	Panapana	\N	\N	\N	2021-02-16 16:48:00
1020	229	Vista Hermosa	\N	\N	\N	2021-02-16 16:48:00
1021	229	Zea	\N	\N	\N	2021-02-16 16:48:00
1022	230	El Palmar	\N	\N	\N	2021-02-16 16:48:00
1023	231	Andres Eloy Blanco	\N	\N	\N	2021-02-16 16:48:00
1024	231	Pedro Cova	\N	\N	\N	2021-02-16 16:48:00
1025	231	Upata	\N	\N	\N	2021-02-16 16:48:00
1026	232	Barceloneta	\N	\N	\N	2021-02-16 16:48:00
1027	232	Ciudad Piar	\N	\N	\N	2021-02-16 16:48:00
1028	232	San Francisco	\N	\N	\N	2021-02-16 16:48:00
1029	232	Santa Barbara	\N	\N	\N	2021-02-16 16:48:00
1030	233	Guasipati	\N	\N	\N	2021-02-16 16:48:00
1031	233	Salom	\N	\N	\N	2021-02-16 16:48:00
1032	234	Dalla Costa	\N	\N	\N	2021-02-16 16:48:00
1033	234	San Isidro	\N	\N	\N	2021-02-16 16:48:00
1034	234	Tumeremo	\N	\N	\N	2021-02-16 16:48:00
1035	235	Aripao	\N	\N	\N	2021-02-16 16:48:00
1036	235	Guarataro	\N	\N	\N	2021-02-16 16:48:00
1037	235	Las Majadas	\N	\N	\N	2021-02-16 16:48:00
1038	235	Maripa	\N	\N	\N	2021-02-16 16:48:00
1039	235	Moitaco	\N	\N	\N	2021-02-16 16:48:00
1040	236	Bejuma	\N	\N	\N	2021-02-16 16:48:00
1041	236	Canoabo	\N	\N	\N	2021-02-16 16:48:00
1042	236	Simon Bolivar	\N	\N	\N	2021-02-16 16:48:00
1043	237	Belen	\N	\N	\N	2021-02-16 16:48:00
1044	237	Guigue	\N	\N	\N	2021-02-16 16:48:00
1045	237	Tacarigua	\N	\N	\N	2021-02-16 16:48:00
1046	238	 Aguas Calientes	\N	\N	\N	2021-02-16 16:48:00
1047	238	Mariara	\N	\N	\N	2021-02-16 16:48:00
1048	239	Ciudad Alianza	\N	\N	\N	2021-02-16 16:48:00
1049	239	Guacara	\N	\N	\N	2021-02-16 16:48:00
1050	239	Yagua	\N	\N	\N	2021-02-16 16:48:00
1051	240	Moron	\N	\N	\N	2021-02-16 16:48:00
1052	240	Urama	\N	\N	\N	2021-02-16 16:48:00
1053	241	Urbana Independencia	\N	\N	\N	2021-02-16 16:48:00
1054	241	Urbana Tocuyito	\N	\N	\N	2021-02-16 16:48:00
1055	242	Urbana Los Guayos	\N	\N	\N	2021-02-16 16:48:00
1056	243	Miranda	\N	\N	\N	2021-02-16 16:48:00
1057	244	Montalban	\N	\N	\N	2021-02-16 16:48:00
1058	245	Naguanagua	\N	\N	\N	2021-02-16 16:48:00
1059	246	Bartolome Salom	\N	\N	\N	2021-02-16 16:48:00
1060	246	Borburata	\N	\N	\N	2021-02-16 16:48:00
1061	246	Democracia	\N	\N	\N	2021-02-16 16:48:00
1062	246	Fraternidad	\N	\N	\N	2021-02-16 16:48:00
1063	246	Goaigoaza	\N	\N	\N	2021-02-16 16:48:00
1064	246	Juan Jose Flores	\N	\N	\N	2021-02-16 16:48:00
1065	246	Patanemo	\N	\N	\N	2021-02-16 16:48:00
1066	246	Union	\N	\N	\N	2021-02-16 16:48:00
1067	247	Urbana San Diego	\N	\N	\N	2021-02-16 16:48:00
1068	248	San Joaquin	\N	\N	\N	2021-02-16 16:48:00
1069	249	Candelaria	\N	\N	\N	2021-02-16 16:48:00
1070	249	Catedral	\N	\N	\N	2021-02-16 16:48:00
1071	249	El Socorro	\N	\N	\N	2021-02-16 16:48:00
1072	249	Miguel Peña	\N	\N	\N	2021-02-16 16:48:00
1073	249	Negro Primero	\N	\N	\N	2021-02-16 16:48:00
1074	249	Rafael Urdaneta	\N	\N	\N	2021-02-16 16:48:00
1075	249	San Blas	\N	\N	\N	2021-02-16 16:48:00
1076	249	San Jose	\N	\N	\N	2021-02-16 16:48:00
1077	249	Santa Rosa	\N	\N	\N	2021-02-16 16:48:00
1078	250	Cojedes	\N	\N	\N	2021-02-16 16:48:00
1079	250	Juan de Mata Suarez	\N	\N	\N	2021-02-16 16:48:00
1080	251	Tinaquillo	\N	\N	\N	2021-02-16 16:48:00
1081	252	El Baul	\N	\N	\N	2021-02-16 16:48:00
1082	252	Sucre	\N	\N	\N	2021-02-16 16:48:00
1083	253	La Aguadita	\N	\N	\N	2021-02-16 16:48:00
1084	253	Macapo	\N	\N	\N	2021-02-16 16:48:00
1085	254	El Pao	\N	\N	\N	2021-02-16 16:48:00
1086	255	El Amparo	\N	\N	\N	2021-02-16 16:48:00
1087	255	Libertad de Cojedes	\N	\N	\N	2021-02-16 16:48:00
1088	256	Romulo Gallegos	\N	\N	\N	2021-02-16 16:48:00
1089	257	Juan Angel Bravo	\N	\N	\N	2021-02-16 16:48:00
1090	257	Manuel Manrique	\N	\N	\N	2021-02-16 16:48:00
1091	257	San Carlos de Austria	\N	\N	\N	2021-02-16 16:48:00
1092	258	Gral/Jefe Jose L Silva	\N	\N	\N	2021-02-16 16:48:00
1093	259	Almirante Luis Brion	\N	\N	\N	2021-02-16 16:48:00
1094	259	Aniceto Lugo	\N	\N	\N	2021-02-16 16:48:00
1095	259	Curiapo	\N	\N	\N	2021-02-16 16:48:00
1096	259	Manuel Renaud	\N	\N	\N	2021-02-16 16:48:00
1097	259	Padre Barral	\N	\N	\N	2021-02-16 16:48:00
1098	259	Santos de Abelgas	\N	\N	\N	2021-02-16 16:48:00
1099	260	5 de Julio	\N	\N	\N	2021-02-16 16:48:00
1100	260	Imataca	\N	\N	\N	2021-02-16 16:48:00
1101	260	Juan Bautista Arismendi	\N	\N	\N	2021-02-16 16:48:00
1102	260	Manuel Piar	\N	\N	\N	2021-02-16 16:48:00
1103	260	Romulo Gallegos	\N	\N	\N	2021-02-16 16:48:00
1104	261	Luis B Prieto Figuero	\N	\N	\N	2021-02-16 16:48:00
1105	261	Pedernales	\N	\N	\N	2021-02-16 16:48:00
1106	262	Jose Vidal Marcano	\N	\N	\N	2021-02-16 16:48:00
1107	262	Juan Millan	\N	\N	\N	2021-02-16 16:48:00
1108	262	Leonardo Ruiz Pineda	\N	\N	\N	2021-02-16 16:48:00
1109	262	MCL. Antonio J de Sucre	\N	\N	\N	2021-02-16 16:48:00
1110	262	Mons. Argimiro Garcia	\N	\N	\N	2021-02-16 16:48:00
1111	262	San Jose	\N	\N	\N	2021-02-16 16:48:00
1112	262	San Rafael	\N	\N	\N	2021-02-16 16:48:00
1113	262	Virgen del Valle	\N	\N	\N	2021-02-16 16:48:00
1114	263	23 de Enero	\N	\N	\N	2021-02-16 16:48:00
1115	263	Altagracia	\N	\N	\N	2021-02-16 16:48:00
1116	263	Antimano	\N	\N	\N	2021-02-16 16:48:00
1117	263	Candelaria	\N	\N	\N	2021-02-16 16:48:00
1118	263	Caricuao	\N	\N	\N	2021-02-16 16:48:00
1119	263	Catedral	\N	\N	\N	2021-02-16 16:48:00
1120	263	Coche	\N	\N	\N	2021-02-16 16:48:00
1121	263	El Junquito	\N	\N	\N	2021-02-16 16:48:00
1122	263	El Paraiso	\N	\N	\N	2021-02-16 16:48:00
1123	263	El Recreo	\N	\N	\N	2021-02-16 16:48:00
1124	263	El Valle	\N	\N	\N	2021-02-16 16:48:00
1125	263	La Pastora	\N	\N	\N	2021-02-16 16:48:00
1126	263	La Vega	\N	\N	\N	2021-02-16 16:48:00
1127	263	Macarao	\N	\N	\N	2021-02-16 16:48:00
1128	263	San Agustin	\N	\N	\N	2021-02-16 16:48:00
1129	263	San Benardino	\N	\N	\N	2021-02-16 16:48:00
1130	263	San Jose	\N	\N	\N	2021-02-16 16:48:00
1131	263	San Juan	\N	\N	\N	2021-02-16 16:48:00
1132	263	San Pedro	\N	\N	\N	2021-02-16 16:48:00
1133	263	Santa Rosalia	\N	\N	\N	2021-02-16 16:48:00
1134	263	Santa Teresa	\N	\N	\N	2021-02-16 16:48:00
1135	263	Sucre	\N	\N	\N	2021-02-16 16:48:00
516	264	Capadare	\N	\N	\N	2021-02-16 16:48:00
517	264	La Pastora	\N	\N	\N	2021-02-16 16:48:00
518	264	Libertador	\N	\N	\N	2021-02-16 16:48:00
519	264	San Juan de los Cayos	\N	\N	\N	2021-02-16 16:48:00
520	265	Aracua	\N	\N	\N	2021-02-16 16:48:00
521	265	La Peña	\N	\N	\N	2021-02-16 16:48:00
522	265	San Luis	\N	\N	\N	2021-02-16 16:48:00
523	266	Bariro	\N	\N	\N	2021-02-16 16:48:00
524	266	Borojo	\N	\N	\N	2021-02-16 16:48:00
525	266	Capatarida	\N	\N	\N	2021-02-16 16:48:00
526	266	Guajiro	\N	\N	\N	2021-02-16 16:48:00
527	266	Seque	\N	\N	\N	2021-02-16 16:48:00
528	266	Zazarida	\N	\N	\N	2021-02-16 16:48:00
529	267	Yaracal	\N	\N	\N	2021-02-16 16:48:00
530	268	Carirubana	\N	\N	\N	2021-02-16 16:48:00
531	268	Norte	\N	\N	\N	2021-02-16 16:48:00
532	268	Punta Cardon	\N	\N	\N	2021-02-16 16:48:00
533	268	Santa Ana	\N	\N	\N	2021-02-16 16:48:00
534	269	Acurigua	\N	\N	\N	2021-02-16 16:48:00
535	269	Guaibacoa	\N	\N	\N	2021-02-16 16:48:00
536	269	Las Calderas	\N	\N	\N	2021-02-16 16:48:00
537	269	La Vela de Coro	\N	\N	\N	2021-02-16 16:48:00
538	269	Macoruca	\N	\N	\N	2021-02-16 16:48:00
539	270	Dabajuro	\N	\N	\N	2021-02-16 16:48:00
540	271	Agua Clara	\N	\N	\N	2021-02-16 16:48:00
541	271	Avaria	\N	\N	\N	2021-02-16 16:48:00
542	271	Pedregal	\N	\N	\N	2021-02-16 16:48:00
543	271	Piedra Grande	\N	\N	\N	2021-02-16 16:48:00
544	271	Purureche	\N	\N	\N	2021-02-16 16:48:00
545	272	Adaure	\N	\N	\N	2021-02-16 16:48:00
546	272	Adicora	\N	\N	\N	2021-02-16 16:48:00
547	272	Baraived	\N	\N	\N	2021-02-16 16:48:00
548	272	Buena Vista	\N	\N	\N	2021-02-16 16:48:00
549	272	El Hato	\N	\N	\N	2021-02-16 16:48:00
550	272	El Vinculo	\N	\N	\N	2021-02-16 16:48:00
551	272	Jadacaquiva	\N	\N	\N	2021-02-16 16:48:00
552	272	Moruy	\N	\N	\N	2021-02-16 16:48:00
553	272	Pueblo Nuevo	\N	\N	\N	2021-02-16 16:48:00
554	273	Agua Larga	\N	\N	\N	2021-02-16 16:48:00
555	273	Churuguara	\N	\N	\N	2021-02-16 16:48:00
556	273	El Pauji	\N	\N	\N	2021-02-16 16:48:00
557	273	Independencia	\N	\N	\N	2021-02-16 16:48:00
558	273	Maparari	\N	\N	\N	2021-02-16 16:48:00
559	274	Agua Linda	\N	\N	\N	2021-02-16 16:48:00
560	274	Araurima	\N	\N	\N	2021-02-16 16:48:00
561	274	Jacura	\N	\N	\N	2021-02-16 16:48:00
562	275	Judibana	\N	\N	\N	2021-02-16 16:48:00
563	275	Los Taques	\N	\N	\N	2021-02-16 16:48:00
564	276	Casigua	\N	\N	\N	2021-02-16 16:48:00
565	276	Mene de Mauroa	\N	\N	\N	2021-02-16 16:48:00
566	276	San Felix	\N	\N	\N	2021-02-16 16:48:00
567	277	Guzman Guillermo	\N	\N	\N	2021-02-16 16:48:00
568	277	Mitare	\N	\N	\N	2021-02-16 16:48:00
569	277	Rio Seco	\N	\N	\N	2021-02-16 16:48:00
570	277	Sabaneta	\N	\N	\N	2021-02-16 16:48:00
571	277	San Antonio	\N	\N	\N	2021-02-16 16:48:00
572	277	San Gabriel	\N	\N	\N	2021-02-16 16:48:00
573	277	Santa Ana	\N	\N	\N	2021-02-16 16:48:00
574	278	Boca de Tocuyo	\N	\N	\N	2021-02-16 16:48:00
575	278	Chichiriviche	\N	\N	\N	2021-02-16 16:48:00
576	278	Tocuyo de la Costa	\N	\N	\N	2021-02-16 16:48:00
577	279	Palma Sola	\N	\N	\N	2021-02-16 16:48:00
578	280	Cabure	\N	\N	\N	2021-02-16 16:48:00
579	280	Colina	\N	\N	\N	2021-02-16 16:48:00
580	280	Carimagua	\N	\N	\N	2021-02-16 16:48:00
581	281	Piritu	\N	\N	\N	2021-02-16 16:48:00
582	281	San Jose de la Costa	\N	\N	\N	2021-02-16 16:48:00
583	282	Mirimire	\N	\N	\N	2021-02-16 16:48:00
584	283	Boca de Aroa	\N	\N	\N	2021-02-16 16:48:00
585	283	Tucacas	\N	\N	\N	2021-02-16 16:48:00
586	284	Pecaya	\N	\N	\N	2021-02-16 16:48:00
587	284	Sucre	\N	\N	\N	2021-02-16 16:48:00
588	285	Tocopero	\N	\N	\N	2021-02-16 16:48:00
589	286	El Charal	\N	\N	\N	2021-02-16 16:48:00
590	286	Las Vegas del Tuy	\N	\N	\N	2021-02-16 16:48:00
591	286	Sta. Cruz de Bucaral	\N	\N	\N	2021-02-16 16:48:00
592	287	Bruzual	\N	\N	\N	2021-02-16 16:48:00
593	287	Urumaco	\N	\N	\N	2021-02-16 16:48:00
594	288	La Cienaga	\N	\N	\N	2021-02-16 16:48:00
595	288	La Soledad	\N	\N	\N	2021-02-16 16:48:00
596	288	Pueblo Cumarebo	\N	\N	\N	2021-02-16 16:48:00
597	288	Puerto Cumarebo	\N	\N	\N	2021-02-16 16:48:00
598	288	Zazarida	\N	\N	\N	2021-02-16 16:48:00
599	289	Camaguan	\N	\N	\N	2021-02-16 16:48:00
600	289	Puerto Miranda	\N	\N	\N	2021-02-16 16:48:00
601	289	Uverito	\N	\N	\N	2021-02-16 16:48:00
602	290	Chaguaramas	\N	\N	\N	2021-02-16 16:48:00
603	291	El Socorro	\N	\N	\N	2021-02-16 16:48:00
604	292	Espino	\N	\N	\N	2021-02-16 16:48:00
605	292	Valle de la Pascua	\N	\N	\N	2021-02-16 16:48:00
606	293	Cabruta	\N	\N	\N	2021-02-16 16:48:00
607	293	Las Mercedes	\N	\N	\N	2021-02-16 16:48:00
608	293	Sta. Rita de Manapire	\N	\N	\N	2021-02-16 16:48:00
609	294	El Sombrero	\N	\N	\N	2021-02-16 16:48:00
610	294	Sosa	\N	\N	\N	2021-02-16 16:48:00
611	295	Calabozo	\N	\N	\N	2021-02-16 16:48:00
612	295	El Calvario	\N	\N	\N	2021-02-16 16:48:00
613	295	El Rastro	\N	\N	\N	2021-02-16 16:48:00
614	295	Guardatinajas	\N	\N	\N	2021-02-16 16:48:00
615	296	Altagracia de Orituco	\N	\N	\N	2021-02-16 16:48:00
616	296	Lezama	\N	\N	\N	2021-02-16 16:48:00
617	296	Libertad de Orituco	\N	\N	\N	2021-02-16 16:48:00
618	296	Paso Real de Macaira	\N	\N	\N	2021-02-16 16:48:00
619	296	San Francisco de Macaira	\N	\N	\N	2021-02-16 16:48:00
620	296	San Rafael de Orituco	\N	\N	\N	2021-02-16 16:48:00
621	296	Soublette	\N	\N	\N	2021-02-16 16:48:00
622	297	Ortiz	\N	\N	\N	2021-02-16 16:48:00
623	297	San Francisco de Tiznados	\N	\N	\N	2021-02-16 16:48:00
624	297	San Jose de Tiznados	\N	\N	\N	2021-02-16 16:48:00
625	297	San Lorenzo de Tiznados	\N	\N	\N	2021-02-16 16:48:00
626	298	San Rafael de Laya	\N	\N	\N	2021-02-16 16:48:00
627	298	Tucupido	\N	\N	\N	2021-02-16 16:48:00
628	299	Cantagallo	\N	\N	\N	2021-02-16 16:48:00
629	299	Parapara	\N	\N	\N	2021-02-16 16:48:00
630	299	San Juan de los Morros	\N	\N	\N	2021-02-16 16:48:00
631	300	Cazorla	\N	\N	\N	2021-02-16 16:48:00
632	300	Guayabal	\N	\N	\N	2021-02-16 16:48:00
633	301	San Jose de Guaribe	\N	\N	\N	2021-02-16 16:48:00
634	302	Altamira	\N	\N	\N	2021-02-16 16:48:00
635	302	Santa Maria de Ipire	\N	\N	\N	2021-02-16 16:48:00
636	303	San Jose de Unare	\N	\N	\N	2021-02-16 16:48:00
637	303	Zaraza	\N	\N	\N	2021-02-16 16:48:00
638	304	Pio Tamayo	\N	\N	\N	2021-02-16 16:48:00
639	304	Qbda. Honda de Guache	\N	\N	\N	2021-02-16 16:48:00
640	304	Yacambu	\N	\N	\N	2021-02-16 16:48:00
641	305	Freitez	\N	\N	\N	2021-02-16 16:48:00
642	305	Jose Maria Blanco	\N	\N	\N	2021-02-16 16:48:00
643	306	Aguedo F. Alvarado	\N	\N	\N	2021-02-16 16:48:00
644	306	Buena Vista	\N	\N	\N	2021-02-16 16:48:00
645	306	Catedral	\N	\N	\N	2021-02-16 16:48:00
646	306	El Cuji	\N	\N	\N	2021-02-16 16:48:00
647	306	Juan de Villegas	\N	\N	\N	2021-02-16 16:48:00
648	306	Juarez	\N	\N	\N	2021-02-16 16:48:00
649	306	La Concepcion	\N	\N	\N	2021-02-16 16:48:00
650	306	Santa Rosa	\N	\N	\N	2021-02-16 16:48:00
651	306	Tamaca	\N	\N	\N	2021-02-16 16:48:00
652	306	Union	\N	\N	\N	2021-02-16 16:48:00
653	307	Crnel. Mariano Peraza	\N	\N	\N	2021-02-16 16:48:00
654	307	Cuara	\N	\N	\N	2021-02-16 16:48:00
655	307	Diego de Lozada	\N	\N	\N	2021-02-16 16:48:00
656	307	Jose Bernardo Dorante	\N	\N	\N	2021-02-16 16:48:00
657	307	Juan B Rodriguez	\N	\N	\N	2021-02-16 16:48:00
658	307	Paraiso de San Jose	\N	\N	\N	2021-02-16 16:48:00
659	307	San Miguel	\N	\N	\N	2021-02-16 16:48:00
660	307	Tintorero	\N	\N	\N	2021-02-16 16:48:00
661	308	Anzoategui	\N	\N	\N	2021-02-16 16:48:00
662	308	Bolivar	\N	\N	\N	2021-02-16 16:48:00
663	308	Guarico	\N	\N	\N	2021-02-16 16:48:00
664	308	Hilario Luna y Luna	\N	\N	\N	2021-02-16 16:48:00
665	308	Humocaro Alto	\N	\N	\N	2021-02-16 16:48:00
666	308	Humocaro Bajo	\N	\N	\N	2021-02-16 16:48:00
667	308	La Candelaria	\N	\N	\N	2021-02-16 16:48:00
668	308	Moran	\N	\N	\N	2021-02-16 16:48:00
669	309	Agua Viva	\N	\N	\N	2021-02-16 16:48:00
670	309	Cabudare	\N	\N	\N	2021-02-16 16:48:00
671	309	Jose G. Bastidas	\N	\N	\N	2021-02-16 16:48:00
672	310	Buria	\N	\N	\N	2021-02-16 16:48:00
673	310	Gustavo Vegas Leon	\N	\N	\N	2021-02-16 16:48:00
674	310	Sarare	\N	\N	\N	2021-02-16 16:48:00
675	311	Altagracia	\N	\N	\N	2021-02-16 16:48:00
676	311	Antonio Diaz	\N	\N	\N	2021-02-16 16:48:00
677	311	Camacaro	\N	\N	\N	2021-02-16 16:48:00
678	311	Castañeda	\N	\N	\N	2021-02-16 16:48:00
679	311	Cecilio Zubillaga	\N	\N	\N	2021-02-16 16:48:00
680	311	Chiquinquira	\N	\N	\N	2021-02-16 16:48:00
681	311	El Blanco	\N	\N	\N	2021-02-16 16:48:00
682	311	Espinoza Los Monteros	\N	\N	\N	2021-02-16 16:48:00
683	311	Heriberto Arroyo	\N	\N	\N	2021-02-16 16:48:00
684	311	Lara	\N	\N	\N	2021-02-16 16:48:00
685	311	Las Mercedes	\N	\N	\N	2021-02-16 16:48:00
686	311	Manuel Morillo	\N	\N	\N	2021-02-16 16:48:00
687	311	Monta A Verde	\N	\N	\N	2021-02-16 16:48:00
688	311	Montes de Oca	\N	\N	\N	2021-02-16 16:48:00
689	311	Reyes Vargas	\N	\N	\N	2021-02-16 16:48:00
690	311	Torres	\N	\N	\N	2021-02-16 16:48:00
691	311	Trinidad Samuel	\N	\N	\N	2021-02-16 16:48:00
692	312	Moroturo	\N	\N	\N	2021-02-16 16:48:00
693	312	San Miguel	\N	\N	\N	2021-02-16 16:48:00
694	312	Siquisique	\N	\N	\N	2021-02-16 16:48:00
695	312	Xaguas	\N	\N	\N	2021-02-16 16:48:00
696	313	Gabriel Picon G.	\N	\N	\N	2021-02-16 16:48:00
697	313	Hector Amable Mora	\N	\N	\N	2021-02-16 16:48:00
698	313	Jose Nucete Sardi	\N	\N	\N	2021-02-16 16:48:00
699	313	Presidente Betancourt	\N	\N	\N	2021-02-16 16:48:00
700	313	Presidente Paez	\N	\N	\N	2021-02-16 16:48:00
701	313	Presidente Romulo Gallegos	\N	\N	\N	2021-02-16 16:48:00
702	313	Pulido Mendez	\N	\N	\N	2021-02-16 16:48:00
703	314	La Azulita	\N	\N	\N	2021-02-16 16:48:00
704	315	Mesa Bolivar	\N	\N	\N	2021-02-16 16:48:00
705	315	Mesa de las Palmas	\N	\N	\N	2021-02-16 16:48:00
706	315	Sta. Cruz de Mora	\N	\N	\N	2021-02-16 16:48:00
707	316	Aricagua	\N	\N	\N	2021-02-16 16:48:00
708	316	San Antonio	\N	\N	\N	2021-02-16 16:48:00
709	317	Canagua	\N	\N	\N	2021-02-16 16:48:00
710	317	Capuri	\N	\N	\N	2021-02-16 16:48:00
711	317	Chacanta	\N	\N	\N	2021-02-16 16:48:00
712	317	El Molino	\N	\N	\N	2021-02-16 16:48:00
713	317	Guaimaral	\N	\N	\N	2021-02-16 16:48:00
714	317	Mucuchachi	\N	\N	\N	2021-02-16 16:48:00
715	317	Mucutuy	\N	\N	\N	2021-02-16 16:48:00
716	318	Acequias	\N	\N	\N	2021-02-16 16:48:00
717	318	Fernandez Peña	\N	\N	\N	2021-02-16 16:48:00
718	318	Jaji	\N	\N	\N	2021-02-16 16:48:00
719	318	La Mesa	\N	\N	\N	2021-02-16 16:48:00
720	318	Matriz	\N	\N	\N	2021-02-16 16:48:00
721	318	Montalban	\N	\N	\N	2021-02-16 16:48:00
722	318	San Jose	\N	\N	\N	2021-02-16 16:48:00
723	319	Florencio Ramirez	\N	\N	\N	2021-02-16 16:48:00
724	319	Tucani	\N	\N	\N	2021-02-16 16:48:00
725	320	Las Piedras	\N	\N	\N	2021-02-16 16:48:00
726	320	Santo Domingo	\N	\N	\N	2021-02-16 16:48:00
727	321	Guaraque	\N	\N	\N	2021-02-16 16:48:00
728	321	Mesa de Quintero	\N	\N	\N	2021-02-16 16:48:00
729	321	Rio Negro	\N	\N	\N	2021-02-16 16:48:00
730	322	Arapuey	\N	\N	\N	2021-02-16 16:48:00
731	322	Palmira	\N	\N	\N	2021-02-16 16:48:00
732	323	San Cristobal de T	\N	\N	\N	2021-02-16 16:48:00
733	323	Torondoy	\N	\N	\N	2021-02-16 16:48:00
734	324	Antonio Spinetti Dini	\N	\N	\N	2021-02-16 16:48:00
735	324	Arias	\N	\N	\N	2021-02-16 16:48:00
736	324	Caracciolo Parra P	\N	\N	\N	2021-02-16 16:48:00
737	324	Domingo Peña	\N	\N	\N	2021-02-16 16:48:00
738	324	El Llano	\N	\N	\N	2021-02-16 16:48:00
739	324	El Morro	\N	\N	\N	2021-02-16 16:48:00
740	324	Gonzalo Picon Febres	\N	\N	\N	2021-02-16 16:48:00
741	324	Jacinto Plaza	\N	\N	\N	2021-02-16 16:48:00
742	324	Juan Rodriguez Suarez	\N	\N	\N	2021-02-16 16:48:00
743	324	Lasso de la Vega	\N	\N	\N	2021-02-16 16:48:00
744	324	Los Nevados	\N	\N	\N	2021-02-16 16:48:00
745	324	Mariano Picon Salas	\N	\N	\N	2021-02-16 16:48:00
746	324	Milla	\N	\N	\N	2021-02-16 16:48:00
747	324	Osuna Rodriguez	\N	\N	\N	2021-02-16 16:48:00
748	324	Sagrario	\N	\N	\N	2021-02-16 16:48:00
749	325	Andres Eloy Blanco	\N	\N	\N	2021-02-16 16:48:00
750	325	La Venta	\N	\N	\N	2021-02-16 16:48:00
751	325	Piñango	\N	\N	\N	2021-02-16 16:48:00
752	325	Timotes	\N	\N	\N	2021-02-16 16:48:00
753	326	Eloy Paredes	\N	\N	\N	2021-02-16 16:48:00
754	326	R de Alcazar	\N	\N	\N	2021-02-16 16:48:00
755	326	Santa Elena de Arenales	\N	\N	\N	2021-02-16 16:48:00
756	327	Sta. Maria de Caparo	\N	\N	\N	2021-02-16 16:48:00
757	328	Pueblo Llano	\N	\N	\N	2021-02-16 16:48:00
758	329	Cacute	\N	\N	\N	2021-02-16 16:48:00
759	329	La Toma	\N	\N	\N	2021-02-16 16:48:00
760	329	Mucuchies	\N	\N	\N	2021-02-16 16:48:00
761	329	Mucuruba	\N	\N	\N	2021-02-16 16:48:00
762	329	San Rafael	\N	\N	\N	2021-02-16 16:48:00
763	330	Bailadores	\N	\N	\N	2021-02-16 16:48:00
764	330	Geronimo Maldonado	\N	\N	\N	2021-02-16 16:48:00
765	331	Tabay	\N	\N	\N	2021-02-16 16:48:00
766	332	Chiguara	\N	\N	\N	2021-02-16 16:48:00
767	332	Estanques	\N	\N	\N	2021-02-16 16:48:00
768	332	Lagunillas	\N	\N	\N	2021-02-16 16:48:00
769	332	La Trampa	\N	\N	\N	2021-02-16 16:48:00
770	332	Pueblo Nuevo del Sur	\N	\N	\N	2021-02-16 16:48:00
771	332	San Juan	\N	\N	\N	2021-02-16 16:48:00
772	333	El Amparo	\N	\N	\N	2021-02-16 16:48:00
773	333	El Llano	\N	\N	\N	2021-02-16 16:48:00
774	333	San Francisco	\N	\N	\N	2021-02-16 16:48:00
775	333	Tovar	\N	\N	\N	2021-02-16 16:48:00
776	334	Independencia	\N	\N	\N	2021-02-16 16:48:00
777	334	Maria C Palacios	\N	\N	\N	2021-02-16 16:48:00
778	334	Nueva Bolivia	\N	\N	\N	2021-02-16 16:48:00
779	334	Santa Apolonia	\N	\N	\N	2021-02-16 16:48:00
780	335	Caño el Tigre	\N	\N	\N	2021-02-16 16:48:00
781	335	Zea	\N	\N	\N	2021-02-16 16:48:00
1139	336	Aves	\N	\N	\N	2021-02-16 16:48:00
1140	337	Borracha	\N	\N	\N	2021-02-16 16:48:00
1141	338	La Blanquilla	\N	\N	\N	2021-02-16 16:48:00
1142	339	Los Testigos	\N	\N	\N	2021-02-16 16:48:00
1143	340	Los Frailes	\N	\N	\N	2021-02-16 16:48:00
1138	341	Los Roques	\N	\N	\N	2021-02-16 16:48:00
1144	342	La Tortuga	\N	\N	\N	2021-02-16 16:48:00
782	160	Huachamacare	\N	\N	\N	2021-02-16 16:48:00
1145	343	Perú	\N	\N	\N	2021-02-16 16:48:00
1146	344	Inglaterra	\N	\N	\N	2021-02-16 16:48:00
1147	345	Francia	\N	\N	\N	2021-02-16 16:48:00
1148	346	España	\N	\N	\N	2021-02-16 16:48:00
1149	347	Ecuador	\N	\N	\N	2021-02-16 16:48:00
1150	348	Argentina	\N	\N	\N	2021-02-16 16:48:00
1151	349	Chile	\N	\N	\N	2021-02-16 16:48:00
1152	350	Mexico	\N	\N	\N	2021-02-16 16:48:00
\.


--
-- TOC entry 2295 (class 0 OID 417558)
-- Dependencies: 176
-- Data for Name: vbitacora; Type: TABLE DATA; Schema: vsistema; Owner: postgres
--

COPY vsistema.vbitacora (idbitacora, tabla, idpk, descripcion, idpersona1, idpersona2, fpersona2) FROM stdin;
\.


--
-- TOC entry 2296 (class 0 OID 417566)
-- Dependencies: 177
-- Data for Name: vcomun; Type: TABLE DATA; Schema: vsistema; Owner: postgres
--

COPY vsistema.vcomun (idcomun, comun, concepto, descripcion, tipo, fijo, idpersona2, fpersona2) FROM stdin;
\.


--
-- TOC entry 2298 (class 0 OID 417577)
-- Dependencies: 179
-- Data for Name: vformulario; Type: TABLE DATA; Schema: vsistema; Owner: postgres
--

COPY vsistema.vformulario (idformulario, formulario, descripcion, activo, fijo7, mt, idpersona2, fpersona2, re, fb) FROM stdin;
1	sistema	Sistema	t	t	f	\N	2020-12-02 00:00:00	f	f
2	syspersonas	Sistema - Personas	t	t	f	\N	2020-12-02 00:00:00	f	f
4	sysusuarios	Sistema - Usuarios	t	t	f	\N	2020-12-02 00:00:00	f	f
5	sysfotos	Sistema - Fotos	t	t	f	\N	2020-12-02 00:00:00	f	f
6	sysrolesusuarios	Sistema - Roles/Usuarios	t	t	f	\N	2020-12-02 00:00:00	f	f
7	sysroles	Sistema - Roles	t	t	f	\N	2020-12-02 00:00:00	f	f
8	sysrolesformularios	Sistema - Roles/Formularios	t	t	f	\N	2020-12-02 00:00:00	f	f
9	sysformularios	Sistema - Formularios	t	t	f	\N	2020-12-02 00:00:00	f	f
10	systablascomunes	Sistema - Tablas Comunes	t	t	f	\N	2020-12-02 00:00:00	f	f
11	syspermisologia	Sistema - Permisologia	t	t	f	\N	2020-12-02 00:00:00	f	f
3	systablasgenericas	Sistema - Tablas Genericas	t	t	f	\N	2020-12-02 00:00:00	f	f
12	propuestas	Propuestas	t	t	f	\N	2021-02-11 21:08:00	f	f
13	mispropuestas	Propuestas Usuarios Externos	t	t	f	\N	2021-02-18 20:32:03.4449	f	f
\.


--
-- TOC entry 2300 (class 0 OID 417592)
-- Dependencies: 181
-- Data for Name: vips; Type: TABLE DATA; Schema: vsistema; Owner: postgres
--

COPY vsistema.vips (idip, ip, idpersona1, fpersona1, fpersona2, vezin, vezout) FROM stdin;
\.


--
-- TOC entry 2302 (class 0 OID 417601)
-- Dependencies: 183
-- Data for Name: vrol; Type: TABLE DATA; Schema: vsistema; Owner: postgres
--

COPY vsistema.vrol (idrol, rol, condicion, activo, fijo, idpersona1, idpersona2, fpersona1, fpersona2) FROM stdin;
1	Administrador	\N	t	t	\N	\N	2021-02-11 16:14:00	2021-02-11 16:14:00
2	Usuarios Externos	\N	t	t	\N	\N	2021-02-17 07:40:00	2021-02-18 17:22:37.140722
\.


--
-- TOC entry 2313 (class 0 OID 419025)
-- Dependencies: 194
-- Data for Name: vrolformulario; Type: TABLE DATA; Schema: vsistema; Owner: postgres
--

COPY vsistema.vrolformulario (idrolformulario, idrolfk, idformulariofk, incluir, editar, eliminar, borrar, imprimir, procesar, administrar, fijo, idpersona1, idpersona2, fpersona1, fpersona2) FROM stdin;
3	1	1	t	t	t	t	t	t	t	t	\N	\N	2021-02-18 20:37:34.39138	2021-02-18 20:37:34.39138
4	1	9	t	t	t	t	t	t	t	t	\N	\N	2021-02-18 20:37:40.085409	2021-02-18 20:37:40.085409
5	1	5	t	t	t	t	t	t	t	t	\N	\N	2021-02-18 20:37:48.248858	2021-02-18 20:37:48.248858
6	1	11	t	t	t	t	t	t	t	t	\N	\N	2021-02-18 20:37:53.761615	2021-02-18 20:37:53.761615
7	1	2	t	t	t	t	t	t	t	t	\N	\N	2021-02-18 20:37:59.012979	2021-02-18 20:37:59.012979
8	1	7	t	t	t	t	t	t	t	t	\N	\N	2021-02-18 20:38:05.376456	2021-02-18 20:38:05.376456
9	1	8	t	t	t	t	t	t	t	t	\N	\N	2021-02-18 20:38:11.144384	2021-02-18 20:38:11.144384
10	1	6	t	t	t	t	t	t	t	t	\N	\N	2021-02-18 20:38:21.581369	2021-02-18 20:38:21.581369
11	1	10	t	t	t	t	t	t	t	t	\N	\N	2021-02-18 20:38:27.613857	2021-02-18 20:38:27.613857
13	1	4	t	t	t	t	t	t	t	t	\N	\N	2021-02-18 20:38:41.067218	2021-02-18 20:38:41.067218
2	1	12	f	f	f	f	t	t	t	t	\N	\N	2021-02-18 17:22:07.320713	2021-02-18 20:39:43.288914
1	2	13	t	t	f	t	f	f	f	t	\N	\N	2021-02-17 07:40:00	2021-02-17 07:40:00
12	1	13	t	t	f	t	f	f	f	t	\N	\N	2021-02-18 21:16:08.11191	2021-02-18 21:16:08.11191
14	1	3	t	t	t	t	t	t	t	t	\N	\N	2021-02-18 21:19:00	2021-02-18 21:19:41.434616
\.


--
-- TOC entry 2305 (class 0 OID 417630)
-- Dependencies: 186
-- Data for Name: vrolusuario; Type: TABLE DATA; Schema: vsistema; Owner: postgres
--

COPY vsistema.vrolusuario (idrolusuario, idrolfk, idusuariofk, prioridad, activo, fijo, idpersona1, idpersona2, fpersona1, fpersona2) FROM stdin;
1	1	9	0	t	t	\N	\N	2021-02-18 14:10:00	2021-02-18 14:10:00
2	1	8	0	t	f	\N	\N	2021-02-18 14:10:00	2021-02-18 14:10:00
\.


--
-- TOC entry 2307 (class 0 OID 417642)
-- Dependencies: 188
-- Data for Name: vtablas; Type: TABLE DATA; Schema: vsistema; Owner: postgres
--

COPY vsistema.vtablas (idtipo, descripcion, fijo, fijo7, comentario, idpersona2, fpersona2) FROM stdin;
1	 Ninguno	t	t	\N	\N	2020-12-02 00:00:00
3	Propuestas	f	t	\N	\N	2020-12-02 00:00:00
4	Aspectos	f	t	\N	\N	2021-02-17 04:58:00
\.


--
-- TOC entry 2309 (class 0 OID 417654)
-- Dependencies: 190
-- Data for Name: vtablas2; Type: TABLE DATA; Schema: vsistema; Owner: postgres
--

COPY vsistema.vtablas2 (idcodigo, idtipofk, idtexto, descripcion, orden, fijo, fijo7, condicion, re, idpersona1, idpersona2, fpersona1, fpersona2) FROM stdin;
1	3	\N	1 - Modificar	1	f	f	N	f	\N	\N	2021-02-11 20:06:00	2021-02-11 20:06:00
3	3	\N	3 - Sugerir	3	f	f	N	f	\N	\N	2021-02-11 20:06:00	2021-02-11 20:06:00
4	3	\N	4 - Incluir	4	f	f	N	f	\N	\N	2021-02-11 20:06:00	2021-02-11 20:06:00
5	3	\N	5 - Eliminar	5	f	f	N	f	\N	\N	2021-02-11 20:07:00	2021-02-11 20:07:00
0	1	Ninguno	Ninguno	1	t	f	N	f	\N	\N	2020-12-02 00:00:00	2020-12-02 00:00:00
6	4	\N	Considerando	1	f	f	N	f	\N	\N	2021-02-17 04:59:00	2021-02-17 04:59:00
7	4	\N	Artículo	2	f	f	N	f	\N	\N	2021-02-17 04:59:00	2021-02-17 04:59:00
2	3	\N	2 - Definir/Aclarar	2	f	f	N	f	\N	\N	2021-02-11 20:06:00	2021-02-11 20:06:00
10	4	\N	Disposición Transitoria	5	f	f	N	f	\N	\N	2021-02-17 05:00:00	2021-02-17 05:00:00
11	4	\N	Disposición Final	6	f	f	N	f	\N	\N	2021-02-17 05:00:00	2021-02-17 05:00:00
12	4	\N	Observación General	7	f	f	N	f	\N	\N	2021-02-17 05:01:00	2021-02-17 05:01:00
\.


--
-- TOC entry 2310 (class 0 OID 417668)
-- Dependencies: 191
-- Data for Name: vusuario; Type: TABLE DATA; Schema: vsistema; Owner: postgres
--

COPY vsistema.vusuario (idusuario, usuario, activo, clave, clave2, clave3, fijo7, condicion, iniciales, campo01, campo02, campo03, campo04, campo05, idpersona1, idpersona2, fpersona1, fpersona2) FROM stdin;
7	Ambrosio Duarte	t	22aa3d2668ddebae09734057849a52d5	261a7d80916532797f8735dd198d4ada	0da49eb33f29a8f813fb1ec58d087b4f	t	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-12-02 00:00:00	2020-12-02 00:00:00
9	Chaustre Jose	t	ccadc258a5b905f243f27ff0985c1cfc	261a7d80916532797f8735dd198d4ada	1d16f4ab31e9b9f047b37552f2491f33	t		\N	\N	\N	\N	\N	\N	\N	\N	2020-12-02 00:00:00	2020-12-02 00:00:00
8	Giovanni Bagnarol	t	902a0f3b14e82a2534253dd09ce01361	8e2fb27ed6e37428695d2b6e3f6580ef	6f9d69e1d9136ae087b2602062f500fd	f	\N	\N	\N	\N	\N	\N	\N	\N	\N	2020-12-02 00:00:00	2020-12-02 00:00:00
\.


--
-- TOC entry 2312 (class 0 OID 417684)
-- Dependencies: 193
-- Data for Name: vvideo; Type: TABLE DATA; Schema: vsistema; Owner: postgres
--

COPY vsistema.vvideo (idvideo, nvideo, cvideo, tvideo, idpersona1, fpersona1) FROM stdin;
\.


--
-- TOC entry 2331 (class 0 OID 0)
-- Dependencies: 174
-- Name: dconsulta_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dconsulta_seq', 1, true);


--
-- TOC entry 2332 (class 0 OID 0)
-- Dependencies: 172
-- Name: dpersona_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dpersona_seq', 9, true);


--
-- TOC entry 2333 (class 0 OID 0)
-- Dependencies: 196
-- Name: nestado_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nestado_seq', 33, true);


--
-- TOC entry 2334 (class 0 OID 0)
-- Dependencies: 197
-- Name: nmunicipio_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nmunicipio_seq', 350, true);


--
-- TOC entry 2335 (class 0 OID 0)
-- Dependencies: 195
-- Name: npais_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.npais_seq', 1, true);


--
-- TOC entry 2336 (class 0 OID 0)
-- Dependencies: 198
-- Name: nparroquia_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nparroquia_seq', 1152, true);


--
-- TOC entry 2337 (class 0 OID 0)
-- Dependencies: 175
-- Name: vbitacora_seq; Type: SEQUENCE SET; Schema: vsistema; Owner: postgres
--

SELECT pg_catalog.setval('vsistema.vbitacora_seq', 1, true);


--
-- TOC entry 2338 (class 0 OID 0)
-- Dependencies: 178
-- Name: vformulario_seq; Type: SEQUENCE SET; Schema: vsistema; Owner: postgres
--

SELECT pg_catalog.setval('vsistema.vformulario_seq', 13, true);


--
-- TOC entry 2339 (class 0 OID 0)
-- Dependencies: 180
-- Name: vips_seq; Type: SEQUENCE SET; Schema: vsistema; Owner: postgres
--

SELECT pg_catalog.setval('vsistema.vips_seq', 1, true);


--
-- TOC entry 2340 (class 0 OID 0)
-- Dependencies: 182
-- Name: vrol_seq; Type: SEQUENCE SET; Schema: vsistema; Owner: postgres
--

SELECT pg_catalog.setval('vsistema.vrol_seq', 2, true);


--
-- TOC entry 2341 (class 0 OID 0)
-- Dependencies: 184
-- Name: vrolformulario_seq; Type: SEQUENCE SET; Schema: vsistema; Owner: postgres
--

SELECT pg_catalog.setval('vsistema.vrolformulario_seq', 14, true);


--
-- TOC entry 2342 (class 0 OID 0)
-- Dependencies: 185
-- Name: vrolusuario_seq; Type: SEQUENCE SET; Schema: vsistema; Owner: postgres
--

SELECT pg_catalog.setval('vsistema.vrolusuario_seq', 2, true);


--
-- TOC entry 2343 (class 0 OID 0)
-- Dependencies: 189
-- Name: vtablas2_seq; Type: SEQUENCE SET; Schema: vsistema; Owner: postgres
--

SELECT pg_catalog.setval('vsistema.vtablas2_seq', 12, true);


--
-- TOC entry 2344 (class 0 OID 0)
-- Dependencies: 187
-- Name: vtablas_seq; Type: SEQUENCE SET; Schema: vsistema; Owner: postgres
--

SELECT pg_catalog.setval('vsistema.vtablas_seq', 4, true);


--
-- TOC entry 2345 (class 0 OID 0)
-- Dependencies: 192
-- Name: vvideo_seq; Type: SEQUENCE SET; Schema: vsistema; Owner: postgres
--

SELECT pg_catalog.setval('vsistema.vvideo_seq', 1, true);


--
-- TOC entry 2150 (class 2606 OID 423185)
-- Name: dconsulta pk_dconsulta; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dconsulta
    ADD CONSTRAINT pk_dconsulta PRIMARY KEY (idconsulta);


--
-- TOC entry 2094 (class 2606 OID 417698)
-- Name: dpersona pk_dpersona; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dpersona
    ADD CONSTRAINT pk_dpersona PRIMARY KEY (idpersona);


--
-- TOC entry 2138 (class 2606 OID 422161)
-- Name: nestado pk_nestado; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nestado
    ADD CONSTRAINT pk_nestado PRIMARY KEY (idestado);


--
-- TOC entry 2142 (class 2606 OID 422170)
-- Name: nmunicipio pk_nmunicipio; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nmunicipio
    ADD CONSTRAINT pk_nmunicipio PRIMARY KEY (idmunicipio);


--
-- TOC entry 2134 (class 2606 OID 422152)
-- Name: npais pk_npais; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.npais
    ADD CONSTRAINT pk_npais PRIMARY KEY (idpais);


--
-- TOC entry 2146 (class 2606 OID 422184)
-- Name: nparroquia pk_nparroquia; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nparroquia
    ADD CONSTRAINT pk_nparroquia PRIMARY KEY (idparroquia);


--
-- TOC entry 2152 (class 2606 OID 423187)
-- Name: dconsulta uq_dconsulta; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dconsulta
    ADD CONSTRAINT uq_dconsulta UNIQUE (cedulafk, idaspectofk, idpropuestafk, numero, numero2, numero3);


--
-- TOC entry 2096 (class 2606 OID 417700)
-- Name: dpersona uq_dpersona1; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dpersona
    ADD CONSTRAINT uq_dpersona1 UNIQUE (cedula);


--
-- TOC entry 2140 (class 2606 OID 422163)
-- Name: nestado uq_nestado; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nestado
    ADD CONSTRAINT uq_nestado UNIQUE (idpaisfk, estado);


--
-- TOC entry 2144 (class 2606 OID 422172)
-- Name: nmunicipio uq_nmunicipio; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nmunicipio
    ADD CONSTRAINT uq_nmunicipio UNIQUE (idestadofk, municipio);


--
-- TOC entry 2136 (class 2606 OID 422154)
-- Name: npais uq_npais; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.npais
    ADD CONSTRAINT uq_npais UNIQUE (pais);


--
-- TOC entry 2148 (class 2606 OID 422186)
-- Name: nparroquia uq_nparroquia; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nparroquia
    ADD CONSTRAINT uq_nparroquia UNIQUE (idmunicipiofk, parroquia);


--
-- TOC entry 2098 (class 2606 OID 417808)
-- Name: vbitacora pk_vbitacora; Type: CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vbitacora
    ADD CONSTRAINT pk_vbitacora PRIMARY KEY (idbitacora);


--
-- TOC entry 2100 (class 2606 OID 417810)
-- Name: vcomun pk_vcomun; Type: CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vcomun
    ADD CONSTRAINT pk_vcomun PRIMARY KEY (idcomun);


--
-- TOC entry 2102 (class 2606 OID 417812)
-- Name: vformulario pk_vformulario; Type: CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vformulario
    ADD CONSTRAINT pk_vformulario PRIMARY KEY (idformulario);


--
-- TOC entry 2106 (class 2606 OID 417814)
-- Name: vips pk_vips; Type: CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vips
    ADD CONSTRAINT pk_vips PRIMARY KEY (idip);


--
-- TOC entry 2110 (class 2606 OID 417816)
-- Name: vrol pk_vrol; Type: CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vrol
    ADD CONSTRAINT pk_vrol PRIMARY KEY (idrol);


--
-- TOC entry 2130 (class 2606 OID 419149)
-- Name: vrolformulario pk_vrolformulario; Type: CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vrolformulario
    ADD CONSTRAINT pk_vrolformulario PRIMARY KEY (idrolformulario);


--
-- TOC entry 2114 (class 2606 OID 417820)
-- Name: vrolusuario pk_vrolusuario; Type: CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vrolusuario
    ADD CONSTRAINT pk_vrolusuario PRIMARY KEY (idrolusuario);


--
-- TOC entry 2118 (class 2606 OID 417822)
-- Name: vtablas pk_vtablas; Type: CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vtablas
    ADD CONSTRAINT pk_vtablas PRIMARY KEY (idtipo);


--
-- TOC entry 2122 (class 2606 OID 417824)
-- Name: vtablas2 pk_vtablas2; Type: CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vtablas2
    ADD CONSTRAINT pk_vtablas2 PRIMARY KEY (idcodigo);


--
-- TOC entry 2124 (class 2606 OID 417826)
-- Name: vusuario pk_vusuario; Type: CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vusuario
    ADD CONSTRAINT pk_vusuario PRIMARY KEY (idusuario);


--
-- TOC entry 2126 (class 2606 OID 417828)
-- Name: vvideo pk_vvideo; Type: CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vvideo
    ADD CONSTRAINT pk_vvideo PRIMARY KEY (idvideo);


--
-- TOC entry 2104 (class 2606 OID 417830)
-- Name: vformulario uq_vformulario; Type: CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vformulario
    ADD CONSTRAINT uq_vformulario UNIQUE (formulario);


--
-- TOC entry 2108 (class 2606 OID 417832)
-- Name: vips uq_vips; Type: CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vips
    ADD CONSTRAINT uq_vips UNIQUE (ip, idpersona1);


--
-- TOC entry 2112 (class 2606 OID 417834)
-- Name: vrol uq_vrol; Type: CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vrol
    ADD CONSTRAINT uq_vrol UNIQUE (rol);


--
-- TOC entry 2132 (class 2606 OID 419151)
-- Name: vrolformulario uq_vrolformulario; Type: CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vrolformulario
    ADD CONSTRAINT uq_vrolformulario UNIQUE (idrolfk, idformulariofk);


--
-- TOC entry 2116 (class 2606 OID 417838)
-- Name: vrolusuario uq_vrolusuario; Type: CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vrolusuario
    ADD CONSTRAINT uq_vrolusuario UNIQUE (idrolfk, idusuariofk);


--
-- TOC entry 2120 (class 2606 OID 417840)
-- Name: vtablas uq_vtablas; Type: CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vtablas
    ADD CONSTRAINT uq_vtablas UNIQUE (descripcion);


--
-- TOC entry 2128 (class 2606 OID 417842)
-- Name: vvideo uq_vvideo; Type: CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vvideo
    ADD CONSTRAINT uq_vvideo UNIQUE (nvideo);


--
-- TOC entry 2181 (class 2606 OID 423188)
-- Name: dconsulta fk_dconsulta_dpersona; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dconsulta
    ADD CONSTRAINT fk_dconsulta_dpersona FOREIGN KEY (cedulafk) REFERENCES public.dpersona(cedula) ON UPDATE CASCADE;


--
-- TOC entry 2182 (class 2606 OID 423193)
-- Name: dconsulta fk_dconsulta_vtablas2_1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dconsulta
    ADD CONSTRAINT fk_dconsulta_vtablas2_1 FOREIGN KEY (idaspectofk) REFERENCES vsistema.vtablas2(idcodigo) ON UPDATE CASCADE;


--
-- TOC entry 2183 (class 2606 OID 423198)
-- Name: dconsulta fk_dconsulta_vtablas2_2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dconsulta
    ADD CONSTRAINT fk_dconsulta_vtablas2_2 FOREIGN KEY (idpropuestafk) REFERENCES vsistema.vtablas2(idcodigo) ON UPDATE CASCADE;


--
-- TOC entry 2155 (class 2606 OID 422643)
-- Name: dpersona fk_dpersona_nparroquia; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dpersona
    ADD CONSTRAINT fk_dpersona_nparroquia FOREIGN KEY (idparroquiafk) REFERENCES public.nparroquia(idparroquia) ON UPDATE CASCADE;


--
-- TOC entry 2153 (class 2606 OID 421709)
-- Name: dpersona fk_dpersona_usuario1; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dpersona
    ADD CONSTRAINT fk_dpersona_usuario1 FOREIGN KEY (idpersona1) REFERENCES public.dpersona(idpersona) ON UPDATE CASCADE;


--
-- TOC entry 2154 (class 2606 OID 421714)
-- Name: dpersona fk_dpersona_usuario2; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dpersona
    ADD CONSTRAINT fk_dpersona_usuario2 FOREIGN KEY (idpersona2) REFERENCES public.dpersona(idpersona) ON UPDATE CASCADE;


--
-- TOC entry 2179 (class 2606 OID 422173)
-- Name: nmunicipio fk_nmunicipio; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nmunicipio
    ADD CONSTRAINT fk_nmunicipio FOREIGN KEY (idestadofk) REFERENCES public.nestado(idestado) ON UPDATE CASCADE;


--
-- TOC entry 2180 (class 2606 OID 422187)
-- Name: nparroquia fk_nparroquia; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nparroquia
    ADD CONSTRAINT fk_nparroquia FOREIGN KEY (idmunicipiofk) REFERENCES public.nmunicipio(idmunicipio) ON UPDATE CASCADE;


--
-- TOC entry 2156 (class 2606 OID 418450)
-- Name: vbitacora fk_vbitacora_usuario1; Type: FK CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vbitacora
    ADD CONSTRAINT fk_vbitacora_usuario1 FOREIGN KEY (idpersona1) REFERENCES public.dpersona(idpersona) ON UPDATE CASCADE;


--
-- TOC entry 2157 (class 2606 OID 418455)
-- Name: vbitacora fk_vbitacora_usuario2; Type: FK CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vbitacora
    ADD CONSTRAINT fk_vbitacora_usuario2 FOREIGN KEY (idpersona2) REFERENCES public.dpersona(idpersona) ON UPDATE CASCADE;


--
-- TOC entry 2158 (class 2606 OID 418460)
-- Name: vcomun fk_vcomun_usuario2; Type: FK CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vcomun
    ADD CONSTRAINT fk_vcomun_usuario2 FOREIGN KEY (idpersona2) REFERENCES public.dpersona(idpersona) ON UPDATE CASCADE;


--
-- TOC entry 2159 (class 2606 OID 418465)
-- Name: vformulario fk_vformulario_usuario2; Type: FK CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vformulario
    ADD CONSTRAINT fk_vformulario_usuario2 FOREIGN KEY (idpersona2) REFERENCES public.dpersona(idpersona) ON UPDATE CASCADE;


--
-- TOC entry 2160 (class 2606 OID 418470)
-- Name: vips fk_vips_usuario1; Type: FK CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vips
    ADD CONSTRAINT fk_vips_usuario1 FOREIGN KEY (idpersona1) REFERENCES public.dpersona(idpersona) ON UPDATE CASCADE;


--
-- TOC entry 2161 (class 2606 OID 418475)
-- Name: vrol fk_vrol_usuario1; Type: FK CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vrol
    ADD CONSTRAINT fk_vrol_usuario1 FOREIGN KEY (idpersona1) REFERENCES public.dpersona(idpersona) ON UPDATE CASCADE;


--
-- TOC entry 2162 (class 2606 OID 418480)
-- Name: vrol fk_vrol_usuario2; Type: FK CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vrol
    ADD CONSTRAINT fk_vrol_usuario2 FOREIGN KEY (idpersona2) REFERENCES public.dpersona(idpersona) ON UPDATE CASCADE;


--
-- TOC entry 2175 (class 2606 OID 419739)
-- Name: vrolformulario fk_vrolformualrio_vrol; Type: FK CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vrolformulario
    ADD CONSTRAINT fk_vrolformualrio_vrol FOREIGN KEY (idrolfk) REFERENCES vsistema.vrol(idrol) ON UPDATE CASCADE;


--
-- TOC entry 2176 (class 2606 OID 419744)
-- Name: vrolformulario fk_vrolformulario_usuario1; Type: FK CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vrolformulario
    ADD CONSTRAINT fk_vrolformulario_usuario1 FOREIGN KEY (idpersona1) REFERENCES public.dpersona(idpersona) ON UPDATE CASCADE;


--
-- TOC entry 2177 (class 2606 OID 419749)
-- Name: vrolformulario fk_vrolformulario_usuario2; Type: FK CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vrolformulario
    ADD CONSTRAINT fk_vrolformulario_usuario2 FOREIGN KEY (idpersona2) REFERENCES public.dpersona(idpersona) ON UPDATE CASCADE;


--
-- TOC entry 2178 (class 2606 OID 419754)
-- Name: vrolformulario fk_vrolformulario_vformulario; Type: FK CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vrolformulario
    ADD CONSTRAINT fk_vrolformulario_vformulario FOREIGN KEY (idformulariofk) REFERENCES vsistema.vformulario(idformulario) ON UPDATE CASCADE;


--
-- TOC entry 2163 (class 2606 OID 418505)
-- Name: vrolusuario fk_vrolusuario_usuario1; Type: FK CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vrolusuario
    ADD CONSTRAINT fk_vrolusuario_usuario1 FOREIGN KEY (idpersona1) REFERENCES public.dpersona(idpersona) ON UPDATE CASCADE;


--
-- TOC entry 2164 (class 2606 OID 418510)
-- Name: vrolusuario fk_vrolusuario_usuario2; Type: FK CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vrolusuario
    ADD CONSTRAINT fk_vrolusuario_usuario2 FOREIGN KEY (idpersona2) REFERENCES public.dpersona(idpersona) ON UPDATE CASCADE;


--
-- TOC entry 2165 (class 2606 OID 418515)
-- Name: vrolusuario fk_vrolusuario_vrol; Type: FK CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vrolusuario
    ADD CONSTRAINT fk_vrolusuario_vrol FOREIGN KEY (idrolfk) REFERENCES vsistema.vrol(idrol) ON UPDATE CASCADE;


--
-- TOC entry 2166 (class 2606 OID 418520)
-- Name: vrolusuario fk_vrolusuario_vusuario; Type: FK CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vrolusuario
    ADD CONSTRAINT fk_vrolusuario_vusuario FOREIGN KEY (idusuariofk) REFERENCES vsistema.vusuario(idusuario) ON UPDATE CASCADE;


--
-- TOC entry 2168 (class 2606 OID 418525)
-- Name: vtablas2 fk_vtablas2_usuario1; Type: FK CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vtablas2
    ADD CONSTRAINT fk_vtablas2_usuario1 FOREIGN KEY (idpersona1) REFERENCES public.dpersona(idpersona) ON UPDATE CASCADE;


--
-- TOC entry 2169 (class 2606 OID 418530)
-- Name: vtablas2 fk_vtablas2_usuario2; Type: FK CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vtablas2
    ADD CONSTRAINT fk_vtablas2_usuario2 FOREIGN KEY (idpersona2) REFERENCES public.dpersona(idpersona) ON UPDATE CASCADE;


--
-- TOC entry 2170 (class 2606 OID 418535)
-- Name: vtablas2 fk_vtablas2_vtablas; Type: FK CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vtablas2
    ADD CONSTRAINT fk_vtablas2_vtablas FOREIGN KEY (idtipofk) REFERENCES vsistema.vtablas(idtipo) ON UPDATE CASCADE;


--
-- TOC entry 2167 (class 2606 OID 418540)
-- Name: vtablas fk_vtablas_usuario2; Type: FK CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vtablas
    ADD CONSTRAINT fk_vtablas_usuario2 FOREIGN KEY (idpersona2) REFERENCES public.dpersona(idpersona) ON UPDATE CASCADE;


--
-- TOC entry 2171 (class 2606 OID 418545)
-- Name: vusuario fk_vusuario_dpersona; Type: FK CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vusuario
    ADD CONSTRAINT fk_vusuario_dpersona FOREIGN KEY (idusuario) REFERENCES public.dpersona(idpersona) ON UPDATE CASCADE;


--
-- TOC entry 2172 (class 2606 OID 418550)
-- Name: vusuario fk_vusuario_usuario1; Type: FK CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vusuario
    ADD CONSTRAINT fk_vusuario_usuario1 FOREIGN KEY (idpersona1) REFERENCES public.dpersona(idpersona) ON UPDATE CASCADE;


--
-- TOC entry 2173 (class 2606 OID 418555)
-- Name: vusuario fk_vusuario_usuario2; Type: FK CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vusuario
    ADD CONSTRAINT fk_vusuario_usuario2 FOREIGN KEY (idpersona2) REFERENCES public.dpersona(idpersona) ON UPDATE CASCADE;


--
-- TOC entry 2174 (class 2606 OID 418560)
-- Name: vvideo fk_vvideo_usuario1; Type: FK CONSTRAINT; Schema: vsistema; Owner: postgres
--

ALTER TABLE ONLY vsistema.vvideo
    ADD CONSTRAINT fk_vvideo_usuario1 FOREIGN KEY (idpersona1) REFERENCES public.dpersona(idpersona) ON UPDATE CASCADE;


--
-- TOC entry 2328 (class 0 OID 0)
-- Dependencies: 7
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- TOC entry 2330 (class 0 OID 0)
-- Dependencies: 8
-- Name: SCHEMA vsistema; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA vsistema FROM PUBLIC;
REVOKE ALL ON SCHEMA vsistema FROM postgres;
GRANT ALL ON SCHEMA vsistema TO postgres;
GRANT ALL ON SCHEMA vsistema TO PUBLIC;


-- Completed on 2021-02-18 21:23:26 -04

--
-- PostgreSQL database dump complete
--

