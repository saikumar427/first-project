<%@include file="getresourcespath.jsp" %>
<%@include file="common.jsp" %>
<%@include file="/columbia/props.jsp" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
   "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head profile="http://gmpg.org/xfn/11">
<meta name="verify-v1" content="/2obWcBcvVqISVfmAFOvfTgJIfdxFfmMOe+TE8pbDJg=" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<META Http-Equiv="Cache-Control" Content="no-cache">
<META Http-Equiv="Pragma" Content="no-cache">
<META Http-Equiv="Expires" Content="0">
<title><%=getPropValue("title",lang) %></title>
<meta name="Description" content="<%=getPropValue("description" ,lang) %>" />
<meta name="Keywords" content="<%=getPropValue("keywords" ,lang) %>"/><link rel="canonical" href="http://www.eventbee.com" />
<link rel="icon" href="<%=resourceaddress%>/main/images/favicon.ico" type="image/x-icon" />
<link rel="shortcut icon" href="<%=resourceaddress%>/main/images/favicon.ico" type="image/x-icon" />
<link type="text/css" rel="stylesheet" href="/main/css/bootstrap/bootstrap.min.css" />
<!-- <link type="text/css" rel="stylesheet" href="/main/css/select2.css" /> -->
<link type="text/css" rel="stylesheet" href="<%=resourceaddress%>/main/css/bootstrap/style-min.css" />
<link type="text/css" rel="stylesheet" href="/main/font-awesome-4.0.3/css/font-awesome.min.css" />
<script src="<%=resourceaddress%>/main/js/jquery-1.11.2.min.js"></script>
<script src="<%=resourceaddress%>/main/js/jquery.inview.min.js"></script>
<script src="<%=resourceaddress%>/main/user/login?lang=<%=lang%>"></script>
<link href="/columbia/css/homepage.css?id=1" rel="stylesheet"/>
  <script type="text/javascript" src="js/jquery.js"></script>
  <script type="text/javascript" src="/main/homepage/js/background.cycle.js"></script>
  <script src="<%=resourceaddress%>/main/user/login?lang=<%=lang%>"></script>
		<script>
			$(document).ready(function(){
				if (Modernizr.touch) {
					// show the close overlay button
					$(".close-overlay").removeClass("hidden");
					// handle the adding of hover class when clicked
					$(".img").click(function(e){
						if (!$(this).hasClass("hover")) {
							$(this).addClass("hover");
						}
					});
					// handle the closing of the overlay
					$(".close-overlay").click(function(e){
						e.preventDefault();
						e.stopPropagation();
						if ($(this).closest(".img").hasClass("hover")) {
							$(this).closest(".img").removeClass("hover");
						}
					});
					} else {
					// handle the mouseenter functionality
					$(".img").mouseenter(function(){
						$(this).addClass("hover");
						//$(this).find('img').css({ 'max-width': '25%'});
						//$(this).find('.setTop').css({'margin-top':'30px'});
					})
					// handle the mouseleave functionality
					.mouseleave(function(){ 
						$(this).removeClass("hover");
						//$(this).find('img').css({ 'max-width': '100%'});
						//$(this).find('.setTop').css({'margin-top':'0px'});
					});
					
				}
			});
		</script>
<style>
			#myDropdown label {
			font-weight: normal !important;
			}
			#myDropdown lable:hover{
			border:none !important;
			}
			
			#myDropdown a {
			color: #333;
			}
			
			#myDropdown a:hover {
			color: #333;
			border:transparent;
			}
			#myDropdown a:focus, #myDropdown a:hover {
                color: #23527c ;
                text-decoration:none;
            }
</style>
		<style>

.footertabheader{
       color: #B0B0B0;
       font-family: 'Open Sans', sans-serif;
}
.footerlinks a, .footertab a{
         color: #ccc;
         font-size: 12px;
         line-height: 200%;
}
.top-gap{
	margin-top:7px;
}
.fa-facebook {
    background: transparent none repeat scroll 0 0;
    border: 0 none;
    color: #ccc;
    padding: 0;
}
.fa-twitter {
    background: transparent none repeat scroll 0 0;
    border: 0 none;
    color: #ccc;
    padding: 0;
</style>

<style type="text/css">
    body{
    	margin-top:0px !important;
    }
		.footerlinks a, .footertab a {
			color: #ccc;
			font-size: 12px;
			line-height: 200%;
		}
        .form-control-signup {
            background: transparent !important;
            border-top: none !important;
            border-left: none !important;
            border-right: none !important;
            border-radius: 0px !important;
            box-shadow: none;
            color: #fff !important;
            padding-left: 0px;
			font-size:13px;
        }
		 .form-control{
			font-size:13px !important;
		 }
		input:-webkit-autofill,textarea:-webkit-autofill, select:-webkit-autofill {
		    padding-left: 0px;
            border-color: #fff !important;
            background: transparent !important;
            border-top: none !important;
            border-left: none !important;
            border-right: none !important;
            border-radius: 0px !important;
            box-shadow: none !important;
            color: #fff !important;
            outline: none !important;
		}
		.help-block{
			background:#9d2d3a !important;
			color:#fff !important;
			font-size:12px;
			padding-left:10px;
		}        
        .has-error .form-control-feedback {
            color: #df0101 !important;
        }        
        .form-control-signup::-moz-placeholder {
            color: #e4e4e4 !important;
            opacity: 1;
        }		
		.form-control-signup:focus::-moz-placeholder {
            color: #e4e4e4 !important;
            opacity: 1;
        }		
		
		.form-control-signup::-webkit-input-placeholder { /* Chrome/Opera/Safari */
			color: #e4e4e4 !important;
            opacity: 1;
		}
		.form-control-signup::-moz-placeholder { /* Firefox 19+ */
			color: #e4e4e4 !important;
            opacity: 1;
		}
		.form-control-signup:-ms-input-placeholder { /* IE 10+ */
			color: #e4e4e4 !important;
            opacity: 1;
		}
		.form-control-signup:-moz-placeholder { /* Firefox 18- */
			color: #e4e4e4 !important;
            opacity: 1;
			}
        .form-control-signup:focus {
            padding-left: 0px;
            border-color: #fff;
            background: transparent !important;
            border-top: none !important;
            border-left: none !important;
            border-right: none !important;
            border-radius: 0px !important;
            box-shadow: none !important;
            color: #fff !important;
            outline: none !important;
        }        
        .has-error .checkbox,
        .has-error .checkbox-inline,
        .has-error .control-label,
        .has-error .help-block,
        .has-error .radio,
        .has-error .radio-inline,
        .has-error.checkbox label,
        .has-error.checkbox-inline label,
        .has-error.radio label,
        .has-error.radio-inline label {
            color: #df0101;
            #background: transparent !important;
            border-top: none !important;
            border-left: none !important;
            border-right: none !important;
            border-radius: 0px !important;
            box-shadow: none;
            #color: #fff !important;
            #padding-left: 0px;
            text-align: left !important;
        }        
        .has-success .form-control-feedback {
            color: #04b404;
        }        
        .has-success .form-control {
            background: transparent !important;
            border-top: none !important;
            border-left: none !important;
            border-right: none !important;
            border-radius: 0px !important;
            box-shadow: none;
            border-color: #fff !important;
            color: #fff !important;
            padding-left: 0px;
        }        
        .has-error .form-control {
            #color: #df0101;
            background: transparent !important;
            border-top: none !important;
            border-left: none !important;
            border-right: none !important;
            border-radius: 0px !important;
            border-color: #fff !important;
            box-shadow: none;
            color: #fff !important;
            padding-left: 0px;
            text-align: left !important;
        }        
        .fixed {
            background-color: #eeeeee;
            border: medium none;
            display: none;
            position: fixed;
            top: 0;
            z-index: 999999999;
        }        
        .section_header {
            color: #999999;
            font-size: 42px;
            font-weight: 500;
        }        
        .main_header_orange {
            color: #f27d2f;
            font-size: 42px;
            font-weight: 800;
            text-align: center;
        }        
        .caption_header_blue {
            color: #428bca;
            font-size: 32px;
            text-align: center;
        }        
        .select-active {
            background: #ddd none repeat scroll 0 0 !important;
            color: #000 !important;
        }        
        .select-active:hover {
            background: #ddd none repeat scroll 0 0 !important;
            color: #000 !important;
        }        
        .caption_header_blue_faq {
            color: #428bca;
            font-size: 32px;
        }        
        .medium_desc_grey {
            color: #999999;
            font-size: 20px;
        }        
        .normal_desc_grey {
            color: #333333;
            font-size: 14px;
            text-align: center;
        }        
        .normal_desc_grey_ans {
            color: #333333;
            font-size: 14px;
        }        
        .dropdown {
            background-color: white;
            border: 1px solid white;
            border-radius: 11px;
            height: 182px;
            margin: 26px;
            width: 212px;
        }        
        .subevent {
            background-color: #f3f6fa;
            border: 1px solid #f3f6fa;
            border-radius: 27px;
            color: #ffffff;
            cursor: pointer;
            height: 45px;
            margin: 7px;
            padding: 5px;
            width: 315px;
        }        
        .textbox {
            margin: 10px;
            padding-left: 30px;
        }        
        .input-field {
            background-color: #ffffff;
            border: medium none #ffffff;
            height: 30px;
            width: 50px;
        }        
        .avgtooltip {
            background-color: #f27a28;
            bottom: 18px;
            box-shadow: 0 0 1px 1px #dddddd;
            color: #ffffff;
            left: 218px;
            padding: 17px 0 5px;
            position: absolute;
            text-align: center;
            width: 50px;
        }        
        .range-max {
            font-size: 20px;
        }        
        .range-min {
            font-size: 20px;
        }        
        li {}        
        .media-heading > a {
            color: #428bca;
            text-decoration: none;
        }        
        h1,h2,h3,h4,h5,h6 {
            font-family: Muli-Regular;
        }        
        .media-body > h4,
        .media-body > .h4 {
            font-size: 18px;
        }        
        .media-body > p {
            font-size: 14px;
            font-family: Muli-Regular;
        }        
        @font-face {
            font-family: "Heiti TC";
            src: url("http://db.onlinewebfonts.com/t/91764cfbfb9049ea89665b0ac8f0ee41.eot");
            src: url("http://db.onlinewebfonts.com/t/91764cfbfb9049ea89665b0ac8f0ee41.eot?#iefix") format("embedded-opentype"), url("http://db.onlinewebfonts.com/t/91764cfbfb9049ea89665b0ac8f0ee41.woff2") format("woff2"), url("http://db.onlinewebfonts.com/t/91764cfbfb9049ea89665b0ac8f0ee41.woff") format("woff"), url("http://db.onlinewebfonts.com/t/91764cfbfb9049ea89665b0ac8f0ee41.ttf") format("truetype"), url("http://db.onlinewebfonts.com/t/91764cfbfb9049ea89665b0ac8f0ee41.svg#Heiti TC") format("svg");
        }		
    </style>

<style>
.fixed{
  top:0;
 position:fixed;
  display:none;
  border:none;
  z-index:999999999;
  background-color:#EEEEEE;
}

.section_header{
	font-size: 42px;
	font-weight:500;	
	color: #999999;
}


.main_header_orange{
	font-size: 42px;
	font-weight:800;
	text-align: center;
	color: #F27D2F;
}

.caption_header_blue{
	font-size:32px;
	#font-weight: normal;
	text-align: center;
	color: #428BCA;
}

.select-active{
	background:#ddd !important;
	color:#000 !important;
}
.select-active:hover{
	background:#ddd !important;
	color:#000 !important;
}
.caption_header_blue_faq{
	font-size: 32px;
	#font-weight: normal;
	#text-align: center;
	color:#428BCA;
}


.medium_desc_grey{
	color: #999999;
    font-size: 20px;    
}

.normal_desc_grey{
	 color: #333333;
    font-size: 14px;
    text-align:center;
}

.normal_desc_grey_ans{
	 color: #333333;
    font-size: 14px;
}


.dropdown{
	background-color: white;
    border: 1px solid white;
    border-radius: 11px 11px 11px 11px;
    height: 182px;
    margin: 26px;
    width: 212px;
}

.subevent{
	border: 1px solid #F3F6FA;
	background-color: #F3F6FA;
    border-radius: 27px 27px 27px 27px;
    cursor: pointer;
    height: 45px;
    margin: 7px;
    padding: 5px;
    width: 315px;
    color:#ffffff;
}

.textbox{
    margin: 10px;
    padding-left: 30px;    
}

.input-field{
	background-color: #FFFFFF;
    border: medium none #FFFFFF;
    height: 30px;
    width: 50px;
}



.avgtooltip{
	background-color: #F27A28;
    bottom: 18px;
    box-shadow: 0 0 1px 1px #DDDDDD;
    color: #FFFFFF;
    left: 218px;
    padding: 17px 0 5px;
    position: absolute;
    text-align: center;
    width: 50px;
}


.range-max{
	font-size:20px;
}

.range-min{
	font-size:20px;
}

li{
	list-type:desc;
}


</style>

</head>
<!--[if lt IE 9]>
<script src="<%=resourceaddress%>/main/js/html5shiv.js"></script>
<script src="<%=resourceaddress%>/main/js/respond.min.js"></script>
<![endif]-->
<s:set name="I18N_CODE" value="I18N_CODE"></s:set>
<s:set name="I18N_CODE_PATH" value="I18N_CODE_PATH"></s:set>
<script src="<%=resourceaddress%>/main/js/i18n/<%=lang%>/footerjson.js"></script> 
<body id="page-top" class="index site-wrapper">
<!-- responsive navbar
===============================-->
<div>
        <!-- Navigation -->
       <div class="image-div" id="main-img" style="padding:0px;">
			<div class="layer">
            <nav class="navbar navbar-default" role="navigation">
                <div class="container" style="width:100%">

                    <div class="navbar-header ">
                        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                            <span class="icon-bar"></span>
                        </button>
                        <a class="navbar-brand " style="padding-top:0px;padding-bottom:0px;" href="/es-co"><img src="/main/homepage/img/logo.png" /></a>
                    </div>
                    <div class="navbar-collapse collapse">
                        <ul class="nav navbar-nav nav-list " style="float:none !important;">
                            <li class="active-class"><a onclick="showPlatform();" class="font-class">PLATAFORMA</a></li>
                            <li><a class="font-class" onclick="showPricing();">PRECIOS</a></li>
                            <li><a class="font-class" onclick="showSignup();">REGISTRARSE</a></li>
                            <li class="navbar-right"><a href="javascript:;" id="contact" class="font-class">CONTACTO</a></li>
                            <li class="navbar-right"><a href="/main/user/login?lang=es-co" id="sinbtn" class="font-class">INICIAR SESION</a></li>
                        </ul>
                    </div>
                </div>
            </nav>
            <!-- Header -->
            <header class="img-div fullscreen-platform" id="platform">
                <div class="content-a">
                    <div class="content-b">
                        <div class="container">
                            <div class="intro-text platform-intro">
                                <div class="row">
                                    <div class="col-lg-7 col-md-6 col-sm-12 col-xs-12">
                                        <div class="block-text-platform padding-text">
                                            <div class="intro-lead-in intro-lead-in-platform" style="color: #e4e4e4;font-family:Muli-ExtraLight !important;">Plataforma galardonada</div>
											<div class="intro-lead-in intro-lead-in-platform" style="color: #e4e4e4;font-family:Muli-ExtraLight !important;">en venta de tiquetes</div>
                                        </div>
                                    </div>
                                    <div class="col-lg-4 col-md-5 col-sm-12 col-xs-12">
                                        <div class="block-box-platform block padding-box" id="platform_div">
                                            <div class="intro-lead-in-right intro-lead-in-right-platform" style="font-family:Muli-Light !important;">Te presentamos</div>
											<div class="intro-lead-in-right intro-lead-in-right-platform" style="font-family:Muli-Light !important;">Eventbee Business</div><br/>
                                            <a href="/main/eventbee-for-business/es-co" class="page-scroll btn btn-xz" 
                                            style="border-radius:0px !important;font-family: Montserrat Light !important;font-size:12px;text-transform:uppercase;">CONOCE MÀS</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </header>
            <header class="img-div  fullscreen-pricing" id="pricing" style="display:none;">
                <div class="content-a">
                    <div class="content-b">
                        <div class="container">
                            <div class="intro-text  pricing-intro" id="platform">
                                <div class="row">
                                    <div class="col-lg-7 col-md-6 col-sm-12 col-xs-12">
                                        <div class="block-text-pricing padding-text">
                                            <div class="intro-lead-in intro-lead-in-signup " style="color: #e4e4e4;font-family:Muli-ExtraLight !important;">Ahorra en grande con</div>
                                            <div class="intro-lead-in intro-lead-in-signup " style="color: #e4e4e4;font-family:Muli-ExtraLight !important;">nuestras tarifas fijas</div>
                                        </div>
                                    </div>
                                    <div class="col-lg-4 col-md-5 col-sm-12 col-xs-12">
                                        <div class="block-box-pricing block padding-box" id="pricing_tab" style="font-family:Muli-Light !important;">
                                            <div>
                                                <ul style="list-style:none;display:inline;padding-left:0px;">
                                                    <li style="display:inline-block;margin-right:8px;">
                                                        <div class="price-tag" style="font-family:Muli-Light !important;">Venta de tiquetes Básico</div>
                                                    </li>
                                                   <li style="display:inline-block;">
                                                        <div class="colored-circle"><span style="font-size: 16px;
    position: relative;
    right: 1px;top:24px;">COP3.000</span>
                                                            <br/><span style="font-size:12px;position:relative;top:22px;">por tiquete</span></div>
                                                    </li>
                                                </ul>
                                            </div>
                                            <hr class="hr-line" />
                                            <ul style="list-style:none;display:inline;padding-left:0px;">
                                                <li class="margin-class" style="display:inline-block;">
                                                    <div class="no-colored-circle"><span style="font-size: 14px;left:0px;position: relative;top: 24px;">COP4.500</span></div>Pro</li>
                                                <li class="margin-class" style="display:inline-block;">
                                                    <div class="no-colored-circle"><span style="font-size: 14px;left:0px;position: relative;top: 24px;">COP6.000</span></div>Avanzado</li>
                                                <li style="display:inline-block;">
                                                    <div class="no-colored-circle"><span style="font-size: 14px;left:-4px;position: relative;top: 24px;">COP10.000</span></div>Business</li>
                                            </ul>
                                            <br/>

                                            <div style="clear:both;"></div>
                                            <br/>
                                            <a href="/main/pricing/es-co" class="page-scroll btn btn-xz" 
                                            style="border-radius:0px !important;font-family: Montserrat Light !important;font-size:12px;text-transform:uppercase;">CONOCE MÀS</a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </header>
            <header class="img-div fullscreen-signup" id="signup" style="display:none;">
                <div class="content-a">
                    <div class="content-b">
                        <div class="container">
                            <div class="intro-text signup-intro">
                                <div class="row">
                                    <div class="col-lg-7 col-md-6 col-sm-12 col-xs-12">
                                        <div class="block-text-signup padding-text">
                                            <div class="intro-lead-in intro-lead-in-signup" style="color: #e4e4e4;font-family:Muli-ExtraLight !important;">Respaldada por más de 50.000 administradores</div>
                                            <div class="intro-lead-in intro-lead-in-signup" style="color: #e4e4e4;font-family:Muli-ExtraLight !important;">de eventos en todo el mundo</div>
                                        </div>
                                    </div>
                                    <div class="col-lg-4 col-md-5 col-sm-12 col-xs-12">
                                        <div class="block-box-signup block padding-box" id="platform_div">
                                             <form id="signupform" name="signupform" action="/main/user/signup!hmPgSignUpProcess" method="post" 
                                             style="margin-bottom:0px;" class="form-horizontal" >
                                             	<div class="form-group">
                                                    <div class="col-xs-12">
													
                                                        <input type="text" id="emailid" class="form-control form-control-signup" placeholder="Correo electrónico para verificación de la cuenta" name="email"/>
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="col-xs-12">
														
                                                        <input type="text" id="beeid" class="form-control form-control-signup" placeholder="Bee ID - Ingresa 4 - 20 caracteres alfanuméricos" name="beeId" />
                                                    </div>
                                                </div>
                                                <div class="form-group">
                                                    <div class="col-xs-12">
														
                                                        <input type="password" id="pwdid" class="form-control form-control-signup" placeholder="Contraseña - Ingresa 4 - 20 caracteres" name="password" />
                                                    </div>
                                                </div>
                                                <br/>
                                                <div class="form-group">
                                                    <div class="col-xs-12 col-xs-offset-0">
														
														
                                                        <button type="button" id="signupbtn"  class="btn btn-default btn-xz" 
                                                        style="border-radius:0px !important;font-family: Montserrat Light !important;font-size:12px;text-transform:uppercase;">Registrarse</button>
                                                    </div>
                                                </div>
												<div class="form-group">
                                                    <div class="col-xs-12 col-xs-offset-0">
													<label style="font-size:12px;font-weight:normal;text-align:left;">Al hacer click en el botón Registrarse, confirmo que acepto los <a href="http://www.eventbee.com/main/termsofservice/es-co" style="color:#5388c4;" target="_blank">Términos de Servicio</a> de Eventbee
                                        </label>
                                                </div>
                                                </div>
												<div class="form-group"  style="text-align: left;color:red;margin-left: 0;margin-right: 0;">
                                                	<div class="col-xs-12 col-xs-offset-0" id="signupflderrors" style="padding-top:2px;padding-bottom:2px;font-size:12px;font-weight:normal;background:red;color:#fff;visibility:hidden;text-align:left;">
														&nbsp;
                                                    </div>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </header>
			</div>
        </div>
        <section style="padding: 8px 8px;background:#f3f6fa;">
            <div class="container">
                <div class="row text-center">
                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6">
                        <h4  style=";margin-bottom:12px;"><a class="service-heading" href="/main/how-it-works/es-co">Cómo funciona</a></h4>
                    </div>
                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6">
                        <h4 style="margin-bottom:12px;"><a class="service-heading" href="/main/faq/es-co">FAQ</a></h4>
                    </div>
                    <div class="col-lg-4 col-md-4 col-sm-6 col-xs-6">
                        <h4 style="margin-bottom:12px;"><a class="service-heading" href="javascript:;" id="getTickets">Obtener mis tiquetes</a></h4>
                    </div>
                    <!--<div class="col-lg-3 col-md-3 col-sm-6 col-xs-6">
                        <h4 class="service-heading find-events" style="margin-bottom:12px;">Encontrar eventos</h4>
                        <form class="searchform" style="display:none;margin-bottom:0px;" method="post" action="/main/search" id="searchform" name="searchevent">
                            <div class="input-group">
                                <input type="text" placeholder="Ingresa el nombre del evento o el lugar..." id="searchcontent" name="searchcontent" class="form-control">
                                <span class="input-group-btn">

 <button id="searchevtbtn" type="submit" style="text-transform:uppercase;border-radius:0px !important;font-family: Montserrat Light !important;text-transform:uppercase;font-size:12px;" class="btn btn-default btn-xy">Go</button>
</span></div>
                        </form>

                    </div>  -->
                </div>
            </div>
        </section>

<div class="container" style="background-color: #474747; width: 100%;">
<!-- <hr style="margin: 0; background-color: #606060; height: 1px; border-top: 1px solid #282828;"> -->
<style>
   .select2-container .select2-choice > .select2-chosen { text-align: center;
    padding-left: 25px;}
    </style>
    <%if(lang.equals("es-co")){%>
      <style>
   .select2-chosen{
   	 background-image: url("<%=resourceaddress%>/main/images/flags/flag_colombia.png");
   	 background-repeat:no-repeat;
   	 #background-size:25px 27px;
   	 background-position:center left;
   }
    </style>
   <%} %>
   <%if(lang.equals("es-es")){%>
      <style>
   .select2-chosen{
   	 background-image: url("<%=resourceaddress%>/main/images/flags/spainFlag.png");
   	 background-repeat:no-repeat;
   	 #background-size:25px 27px;
   	 background-position:center left;
   }
    </style>
   <%} %>
    <%if(lang.equals("es-mx")){%>
    <style>
   .select2-chosen{
   	 background-image: url("<%=resourceaddress%>/main/images/flags/flag_mexico.png");
   	 background-repeat:no-repeat;
   	 #background-size:25px 27px;
   	 background-position:center left;
   }
    </style>
   <%} %>
    
     <%if(lang.equals("en-us")){%>
    <style>
   .select2-chosen{
   	 background-image: url("<%=resourceaddress%>/main/images/flags/flag_united_states.png");
   	 background-repeat:no-repeat;
   	 #background-size:25px 27px;
   	 background-position:center left;
   }
    </style>
   <%} %>
	<div class="container footer">
	     
		<div class="row" style="margin: 0 auto; padding-bottom: 0px;">
				<div class="col-md-4">&nbsp;</div>
				<div class="col-md-4">&nbsp;</div>
				<div class="col-md-9 col-sm-9 " style="margin: 0 auto; padding-bottom: 10px;">
				<div class="col-md-4">
			<%-- <a>
		 <select name="" style="width:200px;height:36px !important;line-height:35px !important;margin-top:10px !important;padding: 0px !important;" id="states" onchange="languageClick(value)"> 
		   	<option value="es-co" <%if(lang.equals("es-co")){%>selected='selected' class="select-active"<%} %>>Colombia - Spanish</option>
		   	<option value="es-mx" <%if(lang.equals("es-mx")){%>selected='selected' class="select-active"<%} %>>Mexico - Spanish</option>     
		    <option value="en-us" <%if(lang.equals("en-us")){%>selected='selected' class="select-active"<%} %>>United States - English</option>             
		</select>      
			</a>  --%>
			</div>
		</div>
		<!-- <div class="row" style="margin: 0 auto; padding-bottom: 10px;">
			<div class="row" id="rootDiv">
			</div>
		</div> -->
		<div class="col-md-9 col-sm-9 " style="margin: 0 auto; padding-bottom: 10px;">
		<div class="row" id="rootDiv">
			</div>
		</div>
		<div class="col-md-3 col-sm-3" style="margin-top:16px;">
		 <%-- <a>
		 <select name="" style="width:200px;height:36px !important;line-height:35px !important;margin-top:10px !important;padding: 0px !important;" id="states" onchange="languageClick(value)"> 
		   	<option value="es-co" <%if(lang.equals("es-co")){%>selected='selected' class="select-active"<%} %>>Colombia - Spanish</option>
			<option value="es-mx" <%if(lang.equals("es-mx")){%>selected='selected' class="select-active"<%} %>>Mexico - Spanish</option> 
		   	<option value="es-es" <%if(lang.equals("es-es")){%>selected='selected' class="select-active"<%} %>>Spain - Spanish</option>			
		    <option value="en-us" <%if(lang.equals("en-us")){%>selected='selected' class="select-active"<%} %>>United States - English</option>             
		</select>      
			</a>  --%> 
			 <a><select   class="states"  name="" id="myDropdown" onchange="languageClick(value)" >
			<option value="es-co" data-imagesrc="/main/images/flags/flag_colombia.png" <%if(lang.equals("es-co")){%>selected='selected' class="select-active"<%} %>>Colombia - Spanish</option>
			<option value="es-mx" data-imagesrc="/main/images/flags/flag_mexico.png" <%if(lang.equals("es-mx")){%>selected='selected' class="select-active"<%} %>>Mexico - Spanish</option> 
			<option value="es-es" data-imagesrc="/main/images/flags/spainFlag.png" <%if(lang.equals("es-es")){%>selected='selected' class="select-active"<%} %>>Spain - Spanish</option>
			<option value="en-us" data-imagesrc="/main/images/flags/flag_united_states.png" <%if(lang.equals("en-us")){%>selected='selected' class="select-active"<%} %>>United States - English</option>
		</select></a> 		
		</div>
		
		
	</div>
</div>

<hr style="margin: 0; background-color: #606060; height: 1px; border-top: 1px solid #282828;" />

<div class="container" style="background-color: #474747; width: 100%;">
	<div class="container footer">
		<div class="row" style="margin: 0 auto; padding-top: 15px;">
			<div class="row">
				<center>
					<span style="font-size: 12px; color: #ccc"><%=getPropValue("copyright_eventbee_all_right_reserved" ,lang) %> </span>
				</center>
				<span class="footerlinks" style="font-size: 0.7em" id="lowerlinks">
					<center>
						 <a href="/main/privacystatement<%=getSlashLinkPath(lang)%>">
						<%=getPropValue("privacy_statement" ,lang) %></a> 
						<span style="color: #ccc"> |</span>   
						<a
							href="/main/termsofservice<%=getSlashLinkPath(lang)%>"><%=getPropValue("term_of_services" ,lang) %></a>
				
					</center>
				</span>
				<center>
					<span style="font-size: 12px; color: #ccc"><%=getPropValue("with_backing_magr_world_records_sales_promotion" ,lang) %></span>
				</center>
			</div>
			<br />
		</div>
	</div>
</div>
</div>
<!-- modal dialog
===========================-->	        
<div class="container copy">
<div class="row">
<div class="col-md-12">
<!-- Modal -->
<div class="modal" id="myModal" tabindex="-1" role="dialog" aria-hidden="true">
<div class="modal-dialog">
<div class="modal-content">
<div class="modal-header">
<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
<h4 class="modal-title"></h4>
</div>
<div class="modal-body">
<iframe id="popup" src="" width="100%"  style="height:430px" frameborder="0"></iframe>
</div></div></div></div></div>
</div></div>


<script src="<%=resourceaddress%>/main/js/bootstrap.min.js"></script>
<!-- <script src="/main/js/select2.js"></script>  -->
 <script type="text/javascript" src="/main/js/dropdown/ddslick.js"></script>
<script src="/main/homepage/js/agency.js"></script> 
<script src="/main/homepage/js/modernizr.js"></script>
<!-- <script>
        $(document).ready(function() {
            $("#states").select2();   
        });
</script> -->
<script>
var langins='<%=lang%>';
      $(document).ready(function() {
        	 $('#myDropdown').ddslick({
        		onSelected: function(selectedData){
        			console.log(JSON.stringify(selectedData.selectedData.value));
        			if(selectedData.selectedData.value!=langins){  
        				languageClick(selectedData.selectedData.value);
        			}
        				
        		}   
        	}); 
        	
        });
</script>
	<script>
$(document).ready(function(){
	fillHTML();
	
	$('.fscaret').css({"left":"47px","margin-left":"-15px","z-index": "1"});
}); 

$('#eventSites').on('click', 'li', function(){
    $('#eventSites li').removeClass('active-site');
    $(this).addClass('active-site');
    
});
</script>
<script>
  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-60215903-1', 'auto');
  ga('send', 'pageview');

function signUpFormValidate(){
		var beeid = $("#beeid").val().trim(); 
		var pwd = $("#pwdid").val().trim();  
		var email = $("#emailid").val().trim();  
		
		if(email==''){
			$("#signupflderrors").html("Por favor ingresa tu correo electrónico.");
			$("#signupflderrors").css('visibility','visible');
			$('#emailid').css('border-color','red');
			$('#emailid').focus();
			return false;  
		}else{
			var mailformat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;  
			if(!email.match(mailformat)){ 
				$("#signupflderrors").html("Por favor ingresa un Correo Electrónico válido.");
				$("#signupflderrors").css('visibility','visible');
				$('#emailid').css('border-color','red');
				$('#emailid').focus();
				return false;  
			}  
		}
		
		if(beeid==''){  
			$("#signupflderrors").html("Por favor elige tu Bee ID.");
			$("#signupflderrors").css('visibility','visible');
			$('#beeid').css('border-color','red');
			$('#beeid').focus();
		 return false;
		}else{
			var letters = /^[0-9a-zA-Z_]+$/;  
			if(!beeid.match(letters)){ 
				$("#signupflderrors").html("Espacios, guiones, y caracteres especiales no son permitidos.");
				$("#signupflderrors").css('visibility','visible');
				$('#beeid').css('border-color','red');
				$('#beeid').focus();
				return false;  
			}else if(beeid.length<4||beeid.length>20){
				$("#signupflderrors").html("La Bee ID debe contener de 4 a 20 caracteres alfanuméricos.");
				$("#signupflderrors").css('visibility','visible');
				$('#beeid').css('border-color','red');
				$('#beeid').focus();
				return false;  
			}
		}
		
		if(pwd==''){
			$("#signupflderrors").html("Por favor elige tu contraseña.");
			$("#signupflderrors").css('visibility','visible');
			$('#pwdid').css('border-color','red');
			$('#pwdid').focus();
		 return false;
		}else if(pwd.length<4||pwd.length>20){
				$("#signupflderrors").html("La contraseña debe contener de 4 a 20 caracteres.");
				$("#signupflderrors").css('visibility','visible');
				$('#pwdid').css('border-color','red');
				$('#pwdid').focus();
				return false;  
		}
		
		$("#signupflderrors").html("&nbsp;");
		$("#signupflderrors").css('visibility','hidden');
		
		return true;
	}

$( "#signupbtn" ).click(function() {
	$(this).attr("disabled", "disabled");
	$(this).css('background-color','#428bca');
	if(!signUpFormValidate()){
		$(this).removeAttr('disabled');
		return false;
	}
$.ajax({
       		  url: "/main/user/signup!hmPgSignUpProcess",
       		  type: "post",
       		  data: $("#signupform").serialize(),
       		  success: function(response) {
       			  var obj=JSON.parse(response);
       			  if(obj.status.lastIndexOf("success")>-1){
       				$('#signupbtn').removeAttr('disabled');
       		    	window.location.href="/main/user/signup!hmPgSignUpActivation";
       			  }else{
       				  var str="";
       				  var inputId="";
       				  if('email' in obj){
   						str=""+obj.email;
   						inputId="emailid";
   					  }else if('beeId' in obj){
       					str=""+obj.beeId;
       					inputId="beeid";
       				  }else if('password' in obj){
       					str=""+obj.password;
       					inputId="pwdid";
       				  }else  if('ip' in obj){
       					str=""+obj.ip;
       				  }
       				  $("#signupflderrors").css('visibility','visible');
       				  $("#signupflderrors").html(str);
       				  $('#'+inputId).css('border-color','red');
       				  $('#'+inputId).focus();
       				  $('#signupbtn').removeAttr('disabled');
       			  }
       		  },
       		  error: function(xhr) {
       		    alert('error');
       		  }
       		});
});

       		$("#signupform input").keyup(function(){
       			$('#beeid').css('border-color','white');
       			$('#pwdid').css('border-color','white');
       			$('#emailid').css('border-color','white');
       			$("#signupflderrors").html("&nbsp;");
       			$("#signupflderrors").css('visibility','hidden');
       		});

var executingModule = "slideup";
function closediv(){
$('#myModal').modal('hide');
}

$(function(){
var raddress='<%=resourceaddress%>';
var j=0;
$(document).on('keyup','#searchcontent',function(){
//$('#searchcontent').keyup(function(){
var sc=$('#searchcontent').val();
sc=sc.replace(/^(?:\s)*/g,'').replace(/(?:\s)*$/g,'');
/* if(sc.length<=3)
$('#searchevtbtn').attr('disabled','disabled');
else
$('#searchevtbtn').removeAttr('disabled');	 */		
});


$( "#searchform" ).submit(function(){
	var sc=$('#searchcontent').val();
	sc=sc.replace(/^(?:\s)*/g,'').replace(/(?:\s)*$/g,'');
	if(sc.length<=2){
		alert('Please Enter atleast 3 characters to search');
	//$('#searchevtbtn').attr('disabled','disabled');
	return false;
	}else{
	//$('#searchevtbtn').removeAttr('disabled');
	return true;
	}	
});


$(document).one('inview','#fevents', function (event, visible) {

if (visible){
++j;
if(j==1){
$.ajax({
url: "/main/home/newgetevents.jsp?type=event&timestamp="+(new Date()).getTime(),
}).done(showFeaturedEvents);
}
}
});

$('#pricingimg').bind('inview', function (event, visible) {
if (visible){
$("#pricingimg a").children('img').attr('src',raddress+'/main/images/pricing.jpg');
$('#pricingimg').unbind();
}});
$('#fundsimg').bind('inview', function (event, visible) {
if (visible){
$("#fundsimg a").children('img').attr('src',raddress+'/main/images/funds.jpg');
$('#fundsimg').unbind();
}});
function showFeaturedEvents(response){
var data="<div class=\"row\">";
var json=eval('('+response+')');
for(var i=0;i<json.fevents.length;i++){
       if(i%2==0)data=data+"<div align=\"center\"  class=\"col-md-6 col-sm-6\">";
       data=data+"<div class=\"media\"><a class=\"pull-left\" href="+json.fevents[i].link+" target=\"_blank\"><img class=\"media-object\" src="+json.fevents[i].logo+" alt=\""+json.fevents[i].en+"\" width=\"90px\" height=\"90px\"/></a><div class=\"media-body\"><h4 class=\"media-heading\"><a target=\"_blank\" href="+json.fevents[i].link+">"+json.fevents[i].en+"</a></h4><p>"+json.fevents[i].dt+"<br>"+json.fevents[i].adrs+"</p></div></div>";
	   if(i%2==0) data=data+"<br>";
	   else data=data+"<br><br></div>";
}
data=data+"</div>";
if($('#featuredevents'))
$('#featuredevents').html(data);
//$('#fevents').unbind();
try{
$( ".joiner" ).remove();	
run('Right');
}catch(err){
	
}
} 
$(document).on('click','#contact',function() {
$('.modal-title').html('Contactar a Eventbee');
$('#myModal').on('show.bs.modal', function () {

$('iframe#popup').attr("src",'/main/user/homepagesupportemail.jsp');
$('iframe#popup').css("height","440px"); 
});
$('#myModal').modal('show');
});
$(document).on('click','#getTickets',function() {
$('.modal-title').html('Obtener mis tiquetes');
$('#myModal').on('show.bs.modal', function () {

$('iframe#popup').attr("src",'/main/user/homepagemytickets.jsp');
$('iframe#popup').css("height","435px");
});
$('#myModal').modal('show');
});
$('#myModal').modal({
backdrop: 'static',
keyboard: false,
show:false
});
$(document).on('hide.bs.modal','#myModal', function () {
$('iframe#popup').attr("src",'');
$('#myModal .modal-body').html('<iframe id="popup" src="" width="100%" style="height:440px" frameborder="0"></iframe>');
});
function showButtons(response){
 if(response.indexOf('false')>-1){
    $('#sinbtn').html('<a href="/main/user/login?lang=es-co">INICIAR SESION</a>');
	$('#supbtn').html('<a href="/main/user/signup?lang=es-co"><button class="btn btn-primary">REGISTRARSE</button></a>');
   }else{
    $('#sinbtn').html('<a href="/main/myevents/home?lang=es-co">Mi cuenta</a>');
	$('#supbtn').html('<a href="/main/user/logout?lang=es-co"><button class="btn btn-primary">Cerrar sesión</button></a>');
   }
}
$.ajax({
url: "/main/getUserToken.jsp",
}).done(showButtons);


var calculatorHeight=$("#calculator").height();
var height=$("#pricingimg").height();
 $("#calculator").css("display",'none');

 $(document).on('click','#pricingimg',function(){
	if(executingModule=='slidedown')return;	
			 executingModule = "slideup";
			 $("#calculator").css("display",'block');
			 $("#slidedownimg").css("display",'block');
			  $("#calculator").css("position",'relative');
			   $("#pricingimg").css("position",'absolute');
			   
		   	$( "#pricingimg").slideUp(1500, function() {
         	 
			 $("#calculator").css("z-index","1");
			    $("#calculator").css("position",'relative');
			    $("#pricingimg").css("position",'absolute');
				executingModule="";				
				// $("#pricingimg").css("display",'block');
        	});
			
}); 

 $(document).on('click','#slidedownimg',function(){
     
	slidedownFunc();
	 });
	 
	 
	 

});


function slidedownFunc(){
executingModule = "slidedown";
	 $("#calculator").css("z-index","-1");
	 
	$('#pricingimg').slideDown(1500,function(){
			  $("#pricingimg").css("position",'relative');
		        $("#calculator").css("display",'none');
				$("#slidedownimg").css("display",'none');
				executingModule="";
	});
}
      $('#avgticketsprice').height( $('#ticketssold').height());
         $('#currentticket').height($('#ticketssold').height());     
        

$('.find-events').click(function() {
    $('.find-events').slideUp('slow');
    $('.searchform').slideDown('slow');
});

$('.nav-list').on('click', 'li', function() {
    $('.nav-list li').removeClass('active-class');
    $('.nav-list li').removeClass('active');
    $(this).addClass('active-class');
});

var viewportHeight = $(window).height();
$(document).ready(function() {
});
$(window).resize(function() {
    var viewportHeight = $(window).height();
});
$('.find-events').click(function() {
    $('.find-events').slideUp('slow');
    $('.searchform').slideDown('slow');
});

$('.nav-list').on('click', 'li', function() {
    $('.nav-list li').removeClass('active-class');
    $('.nav-list li').removeClass('active');
    $(this).addClass('active-class');
});

/*function showPricing() {           
    $('.find-events').slideDown('slow');
    $('.searchform').slideUp('slow');
	$('#main-img').removeClass('image-div');
	$('#main-img').addClass('image-div1');
	$('#main-img').removeClass('image-div2');
	$('#platform').hide();
    $('#pricing').show();
    $('#signup').hide();
}

function showPlatform() {
	$('#main-img').removeClass('image-div2');
	$('#main-img').removeClass('image-div1');
	$('#main-img').addClass('image-div');
    $('.find-events').slideDown('slow');
    $('.searchform').slideUp('slow');
    $('#platform').show();
    $('#pricing').hide();
    $('#signup').hide();
}

function showSignup() {  
	$('#main-img').removeClass('image-div');
	$('#main-img').removeClass('image-div1');
	$('#main-img').addClass('image-div2');
    $('.find-events').slideDown('slow');
    $('.searchform').slideUp('slow');
    $('#signup').show();
    $('#platform').hide();
    $('#pricing').hide();
    $('#emailid').focus();
}	*/	

function showPricing() {  
			isPaused = false;
            $('.find-events').slideDown('slow');
            $('.searchform').slideUp('slow');
			$('#platform').hide();
            $('#pricing').show();
            $('#signup').hide();  		
        }

        function showPlatform() {
			isPaused = false;
			$('.find-events').slideDown('slow');
            $('.searchform').slideUp('slow');
            $('#platform').show();
            $('#pricing').hide();
            $('#signup').hide(); 		
        }

        function showSignup() { 
			$('.find-events').slideDown('slow');
            $('.searchform').slideUp('slow');
            $('#signup').show();
			$('#platform').hide();
            $('#pricing').hide();
			 $('#emailid').focus();
			
        }		
				 
				 function changeBackground() {
			   $(".image-div").backgroundCycle({
                   imageUrls: [
                    '/main/homepage/img/yoga-1366.jpeg',  
                    '/main/homepage/img/cooking2-1366.jpg',
                    '/main/homepage/img/yoga2-1366.jpg',					
                    '/main/homepage/img/cooking3-1366.jpg',
                    '/main/homepage/img/cooking-1366.jpg',
                    '/main/homepage/img/dance4-1366.jpg',
					'/main/homepage/img/running3-1366.jpg', 
                    '/main/homepage/img/running2-1366.jpg',
                    '/main/homepage/img/meeting2-1366.jpg',
                    '/main/homepage/img/running-1366.jpg',
                    '/main/homepage/img/meeting-1366.jpg', 
					'/main/homepage/img/livemusic-1366.jpeg',
                    '/main/homepage/img/livemusic2-1366.jpeg',
                    '/main/homepage/img/fitness-1366.jpg',
                    '/main/homepage/img/dance5-1366.jpg',  
                    '/main/homepage/img/livemusic3-1366.jpg',
                   ],
                   backgroundSize: SCALING_MODE_COVER
                });				
			}
			   
			$(document).ready(function() {
				changeBackground();  				
			}); 
			
			$('.immediate_access').click(function(){
				location.href="/main/sell-event-tickets-with-paypal-stripe-braintree-authorize-net";
			});
			$('.facebook').click(function(){
				window.open('http://apps.facebook.com/eventbeeticketing', '_blank');
			});
			$('.gift').click(function(){
				location.href="/main/eventbee-ticketing-kindle-promotion";
			});

			function fillHTML(){
				
				var html="<br/>";
				for(var i=0;i<i18nFooter.sections.length;i++)
					{
					
					
					var eachSection=i18nFooter.sections[i];
					html+='<div class="col-md-'+eachSection.grids+'">';
				
					for(var j=0;j<eachSection.subsections.length;j++)
						{
						var eachSubSection=eachSection.subsections[j];
						html+='<span class="footertabheader">'+ 
									'<h4>'+
											'<strong>'+eachSubSection.title+'</strong>'+
									'</h4>'+
								'</span>';
						for(var k=0;k<eachSubSection.sublinks.length;k++){
							var eachSubLink=eachSubSection.sublinks[k];
							if(eachSubLink.type=="text"){
							
								
								 if(eachSubLink.strong)
				  	                  html+=' <strong>';
								  if(eachSubLink.i18n_include==false)
									  html+='<span class="footertab"><a href="'+eachSubLink.href+'"';
								else	
									html+='<span class="footertab"><a href="'+eachSubLink.href+'<%= getSlashLinkPath(lang) %>"';  
								   	
								     if(eachSubLink.target)
					  	                  html+=' target="'+eachSubLink.target+'"';
							    	   html+='>';
								   	if(eachSubLink.limg)
					  	                  html+=eachSubLink.limg;
								   	html+=eachSubLink.label+'</a></span>';
								   	
								    if(eachSubLink.strong)
					  	                  html+=' </strong>';
								   	
								    html+='<br/>';
								   
					  	                
							}
						    else if(eachSubLink.type=="img")
							{
						    	html+='<a href="'+eachSubLink.href+'"'; 
								    	if(eachSubLink.target)
					  	                  html+=' target="'+eachSubLink.target+'"';
							    	  html+='>'+
						    				'<img src="'+eachSubLink.src+'"';
							    					if(eachSubLink.width)
							    	                  html+=' width="'+eachSubLink.width+'"';
							    					if(eachSubLink.class_name)
								    	                  html+=' class="'+eachSubLink.class_name+'"';
						    	            html+='/>'+
						    		        '</a> <br/>';
						    }
						}
							
					}	
					
					html+='</div>';
					document.getElementById("rootDiv").innerHTML=html;
				
				}
				
			}
</script>
<script>
$('#beeid').keypress(function (e) {
	   var regex = new RegExp("^[a-zA-Z0-9_]+$");
	   var str = String.fromCharCode(!e.charCode ? e.which : e.charCode);
	   if (regex.test(str)) {
	       return true;
	   }

	   e.preventDefault();
	   return false;
	});
</script>
<!-- Facebook Conversion Code for fb-homepage -->
<script>(function() {
  var _fbq = window._fbq || (window._fbq = []);
  if (!_fbq.loaded) {
    var fbds = document.createElement('script');
    fbds.async = true;
    fbds.src = '//connect.facebook.net/en_US/fbds.js';
    var s = document.getElementsByTagName('script')[0];
    s.parentNode.insertBefore(fbds, s);
    _fbq.loaded = true;
  }
})();
window._fbq = window._fbq || [];
window._fbq.push(['track', '6019644693365', {'value':'0.00','currency':'USD'}]);	
</script>
<noscript><img height="1" width="1" alt="" style="display:none" src="https://www.facebook.com/tr?ev=6019644693365&amp;cd[value]=0.00&amp;cd[currency]=USD&amp;noscript=1" /></noscript>
</div>
</body>
</html>
