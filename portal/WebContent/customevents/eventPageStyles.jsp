<style>
body {
	margin: 0 0 0 0;
	font-family: Tahoma, Geneva, sans-serif;
	background-position: top;
	background-color: <%=bodyBackgroundColor%>;
	
	<%if(!"".equals(bodyBackgroundImage)){%>
		background-image: url('<%=bodyBackgroundImage%>');
	<%}%>
	<%
		if("cover".equals(bodyBackgroundPosition)) {
			out.println("background-size:100% auto;");
			out.print("\tbackground-repeat:no-repeat;");
		} else
			out.print("background-repeat:"+bodyBackgroundPosition+";");
	%>
}

#whosAttending .widget-content #attendeeinfo ul hr{
    margin: 10px 0px;
}

.container {
	box-shadow:-60px 0px 100px -90px #000000, 60px 0px 100px -90px #000000;
	background-color: <%=backgroundRgba%> !important;
}
.header {
	  margin-bottom: 15px;
} 
h2{
	text-transform: capitalize;
}
.widget {
	margin:5px 2px  20px;
	position:relative;
	border:1px solid <%=border%>;
	width: 100%;
	-webkit-border-top-left-radius: <%=topLeft%>;
	-webkit-border-top-right-radius: <%=topRight%>;
	-webkit-border-bottom-right-radius: <%=bottomRight%>;
	-webkit-border-bottom-left-radius: <%=bottomLeft%>;
	-moz-border-radius-topleft: <%=topLeft%>;
	-moz-border-radius-topright: <%=topRight%>;
	-moz-border-radius-bottomright: <%=bottomRight%>;
	-moz-border-radius-bottomleft: <%=bottomLeft%>;
	border-top-left-radius: <%=topLeft%>;
	border-top-right-radius: <%=topRight%>;
	border-bottom-right-radius: <%=bottomRight%>;
	border-bottom-left-radius: <%=bottomLeft%>;
}
.widget h2{
    font-family:<%=headerTextFont%>;
	margin:0;
	font-size:<%=headerTextSize%>px;
	background-color:<%=header%>;
	color:<%=headerText%>;
	border-bottom:1px solid <%=border%>;
	padding:10px;
	-webkit-border-top-left-radius: <%=topLeft%>;
	-webkit-border-top-right-radius: <%=topRight%>;
	-moz-border-radius-topleft: <%=topLeft%>;
	-moz-border-radius-topright: <%=topRight%>;
	border-top-left-radius: <%=topLeft%>;
	border-top-right-radius: <%=topRight%>;
}
.widget-content{
	background-color:<%=content%>;
	color:<%=contentText%>;
	font-family:<%=contentTextFont%>;
	font-size:<%=contentTextSize%>px;
	line-height:20px;
	padding:15px;
	-webkit-border-bottom-right-radius: <%=bottomRight%>;
	-webkit-border-bottom-left-radius: <%=bottomLeft%>;
	-moz-border-radius-bottomright: <%=bottomRight%>;
	-moz-border-radius-bottomleft: <%=bottomLeft%>;
	border-bottom-right-radius: <%=bottomRight%>;
	border-bottom-left-radius: <%=bottomLeft%>;
	position: static;
	#overflow: hidden;
}

.widget-content-ntitle{
	-webkit-border-top-left-radius: <%=topLeft%>;
	-webkit-border-top-right-radius: <%=topRight%>;
	-moz-border-radius-topleft: <%=topLeft%>;
	-moz-border-radius-topright: <%=topRight%>;
	border-top-left-radius: <%=topLeft%>;
	border-top-right-radius: <%=topRight%>;
}

table{
	color:<%=contentText%>;
	font-family:<%=contentTextFont%>;
	font-size:<%=contentTextSize%>px;
}
.small {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 10px;
	font-weight: lighter;
	color:<%=contentTextFont%>;
	overflow: hidden;
}
.small_s{
	font-family: Verdana, Arial, Helvetica, sans-serif;
    font-size: 10px;
    font-weight: lighter;
    color: #666666;
}
hr {
	border: 0;
    height: 1px;
    background-image: -webkit-linear-gradient(left, rgba(0,0,0,0), <%=border%>, rgba(0,0,0,0)); 
    background-image:    -moz-linear-gradient(left, rgba(0,0,0,0), <%=border%>, rgba(0,0,0,0)); 
    background-image:     -ms-linear-gradient(left, rgba(0,0,0,0), <%=border%>, rgba(0,0,0,0)); 
    background-image:      -o-linear-gradient(left, rgba(0,0,0,0), <%=border%>, rgba(0,0,0,0)); 
}
#whosPromoting .widget .widget-content{
	overflow: auto;
}
#subForm{
	background-color:#fff;
}
.textWidgetImg img{
	max-width:100%;
}
#whosAttending img{
	max-width:100%;
}
#organizer img{
	max-width: 100%;
}
#captchaidmgr{
	width: 70px !important;
}

#when img, #where img{
    max-width: 100%;
}





/* new chages start */
.groupTickets {
    border-left: 3px solid <%=border%>;
    padding-left: 5px;
    margin-left: -8px;
}

i.fa-plus-square,
i.fa-minus-square {
    cursor: pointer;
    color: <%=headerText%>;
    /* need to update */
}

.cut {
    text-decoration: line-through;
    color: #a94442;
    font-size: .95em;
}
.cutname {
    text-decoration: line-through;
}

.btn-font{
	font-size: <%=contentTextSize%>px;
	padding: 5px 5px;
}
.total-font{
	font-size:<%=headerTextSize%>px;
	font-family:<%=headerTextFont%>;
}
.global-btn{
	font-size: 16px;
    font-weight: 600;
    border-radius: 0px;
    font-family: League Gothic,Helvetica,Arial,sans-serif;
}
#shareblock .well{
	    background-color:<%=header%>;
	    border: 1px solid <%=border%>;
}

/* ------------------------------print button start------------------------------ */
.printBtn{
	background-color:<%=header%>;
	border: 2px solid <%=border%>;
    padding: 5px 10px;
    font-family: <%=headerTextFont%>;
    transition: all 0.5s;
}
.printBtn:hover{
	background-color: <%=content%>;
	transition: all 0.5s;
}
 @media print {
        div.for-print-footer {
            position: fixed;
            bottom: 0;
        }
    }
/* ------------------------------print button end------------------------------ */

/* ------------------------------popup close top button start------------------------------ */
#close-top{
	margin: 0px;
}
.modal-no-bottom{
	border: 0px;
}
/* ------------------------------popup close top button end------------------------------ */

/* ------------------------------ text-box title start-------------------------------------------------- */
.animate-show,
.animate-hide {
  -webkit-transition:all linear 1s;
  -moz-transition:all linear 1s;
  -ms-transition:all linear 1s;
  -o-transition:all linear 1s;
  transition:all linear 1s;
}

.animate-show.ng-hide-remove,
.animate-hide.ng-hide-add.ng-hide-add-active {
  opacity: 0;
  display: block !important;
}

.animate-hide.ng-hide-add,
.animate-show.ng-hide-remove.ng-hide-remove-active {
  opacity: 1;
  display: block !important;
}
.question-title{
	#font-weight: bold;
}
/* ------------------------------text-box title end-------------------------------------------------- */

/* ------------------------------confirmation page share email fb tweet start-------------------------------------------------- */
.social-facebook, .social-tweet, .social-email, .social-referral{
	#padding: 10px 20px;
    #border-radius: 25px;
    -webkit-border-radius: 25px;
    transition: all 0.5s;
    margin: 0px 5px;
    cursor: pointer;
    display: inline-block;
    width: 45px;
    height: 45px;
    font-size: 18px;
    box-shadow: 3px 3px 5px 0px rgba(0, 0, 0, 0.19);
}
.social-facebook{
    color: #FFFFFF;
    background-color: #4060A5;
}
	
.social-facebook:hover{
	color: #4060A5;
    background-color: #FFFFFF;
	transition: all 0.5s;
}

.social-tweet{
    color: #FFFFFF;
    background-color: #3CF;
}
	
.social-tweet:hover{
	color: #3CF;
    background-color: #FFFFFF;
	transition: all 0.5s;
}
.social-email{
    color: #FFFFFF;
    background-color: #DC4A38;
}
	
.social-email:hover{
	color: #DC4A38;
    background-color: #FFFFFF;
	transition: all 0.5s;
}

.social-referral{
	color: #FFFFFF;
    background-color: #ff9900;
}
.social-referral:hover{
	color: #ff9900;
    background-color: #FFFFFF;
	transition: all 0.5s;
}

#shareblock .fa{
	position: relative;
    top: 14px;
}
/* ------------------------------confirmation page share email fb tweet end-------------------------------------------------- */


/* -------------------------confirmation page ticket start----------------------------------------- */
.no-padding-th th{
	padding: 0px !important
}

.no-padding-td td{
	padding: 10px 0px !important
}
/* ------------------------------confirmation page ticket end-------------------------------------- */

/* ------------------------------group ticket title start------------------------------------------ */
.group-ticket-fieldset{
	border: 1px solid <%=border%>;
    margin: 0 2px;
    padding: 0.35em 0.625em 0.75em;
}

.group-ticket-legend{
	font-family:<%=contentTextFont%>;
	font-size:<%=contentTextSize%>px;
	width: auto;
	border-bottom: 0px;
	margin-bottom: 5px;
}
/* -----------------------------group ticket title start------------------------------------------- */

.form-control{
	height: 30px;
	#border-radius: 0px;
}
.order-summary{
	font-size:<%=headerTextSize%>px;
	#color:<%=headerText%>;
}
.sub-module{
	#border-left: 4px solid #ddd;
    padding: 0px 40px 0px 40px;
    #border-right: 4px solid #ddd;
}


.active .grand-total{
	font-weight: bold;
	background-color: <%=header%>;
	<%-- border:1px solid <%=border%>; --%>
    padding-top: 10px;
    padding-bottom: 10px;
    color:<%=headerText%>;
}
#no-bottom .modal-footer{
	border: 0px;
	text-align: center;
	padding-top: 0px;
}
#no-bottom .modal-header{
	border-bottom: 0px;
	padding-bottom: 0px;
}


/* start--- */


/* ------------------------------For top menu start-------------------------------------------------- */
#conformation{
	border-right: 1px solid <%=border%>;
}
.margin-right-left{
	    #margin: 0 -24px 0 -17px;
}
#tickets .widget-content{
	padding: 0px !important;
}
.test-arrow> ul {
   	padding:0px;
	width:100%;
	text-align: center;
	    font-size: 14px;
} 
.test-arrow> ul li {
    display: inline-block;
    #height: 30px;
    height: 0px;
    line-height: 35px;
    width: 25%;
    margin: 0 -2px 0 -2px !important;
    #text-indent: 15px;
    position: relative;
	border:0px solid #FFFFFF;
	
	/* ganesh */
	#margin: 0 -2px 0px 0 !important;
	
}
.test-arrow> ul li:before {
	border-color: transparent transparent transparent <%=border%>;
    border-style:solid;
    border-width: 18px 0 18px 18px;
    content: " ";
    height: 0;
    left: 0px;
    position: absolute;
    width: 0;
    z-index: 0
}
.test-arrow ul{
	margin-bottom:7px !important;
}
#leftList{
	margin:0 15px 15px 15px !important;
}
.test-arrow> ul li:first-child:before {
    border-color: transparent;
}
.alert {
    font-size: 12px;
    padding: 15px;
    margin-bottom: 30px;
    border: 1px solid transparent;
    border-radius: 0px;
}
.test-arrow> ul li a:after {
	border-color: transparent transparent transparent <%=header%>;
    border-style: solid;
    border-width: 18px 0 17px 18px;
    content: " ";
    height: 0;
    position: absolute;
    right: -17px;
    width: 0;
    z-index: 10;
    top: 0px;
}

.test-arrow > ul {
    font-size: 12px;
    padding: 0;
    text-align: center;
    width: 100%;
}
.test-arrow> ul li.active a {
    background: <%=content%>;
    z-index: 100;
}
.test-arrow> ul li.active a:after {
    border-left-color: <%=content%>;
}
.test-arrow> ul li a {
    display: block;
    background: <%=header%>;
	border:1px solid  <%=border%>;
	border-top: 0px;
	border-right:transparent;
}
.test-arrow> ul li a:hover {
    #background: <%=border%>;
}
.test-arrow> ul li a:hover:after {
   # border-color: transparent transparent transparent <%=border%>; 
}
.test-arrow > ul li a:last-child :after{
	border-color:transparent;
}
.test-arrow li:last-child a::after,
.test-arrow li:last-child a::before{
    content: none;
}
.steps-icon{
	font-size: 18px !important;
	position: relative;
	top: 8px;
}
ul > li> a{
	height: 35px;
}

@media only screen and (max-width : 1648px) {
.steps-icon{
    display:none;
   }
    }
    
    
    @media only screen and (max-width : 1424px) {
.steps-icon{
    display:none;
   }
    }

    /* Large Devices, Wide Screens */
    @media only screen and (max-width : 1200px) {
.steps-icon{
    display:none;
   }
    }

    /* Medium Devices, Desktops */
    @media only screen and (max-width : 992px) {
.steps-icon{
    display:none;
   }
    }

    /* Small Devices, Tablets */
    @media only screen and (max-width : 768px) {
.hide-on-small{
    #display:none;
    #font-size:10px;
   }
   .steps-icon{
    display:none;
   }
    }
 /* Extra Small Devices, Phones */ 
    @media only screen and (max-width : 540px) {
.hide-on-small{
    display:none;
   }
   .steps-icon{
   display:block;
    font-size:16px;
   }
    }
    /* Extra Small Devices, Phones */ 
    @media only screen and (max-width : 480px) {
.hide-on-small{
    display:none;
   }
   .steps-icon{
    display:block;
    font-size:18px;
   }
    }

    /* Custom, iPhone Retina */ 
    @media only screen and (max-width : 320px) {
         .hide-on-small{
    display:none;
   }
   .steps-icon{
    display:block;
    font-size:18px;
   }
    }


 #tickets .widget-content{
 	padding: 0px 15px 15px 15px;
 }   
/*  .ticket-title{
 	background-color: #F5F5F5;
    padding: 9px;
    font-size: 14px;
    border-bottom: 1px solid #ddd;
 } */
.test-arrow a {
	font-size:<%=headerTextSize%>px;
	font-family:<%=headerTextFont%>;
    color:<%=headerText%>;
}
/* ------------------------------For top menu end-------------------------------------------------- */













</style>