<style>
	body{
		background-color: <%=content%>;
		color:<%=contentText%>;
		font-family:<%=contentTextFont%>;
		font-size:<%=contentTextSize%>px;
		line-height:20px;
		padding:15px;
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
/* ------------------------------print button start------------------------------ */

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


/* ------------------------------For top menu start-------------------------------------------------- */
	#conformation{
		border-right: 1px solid <%=border%>;
	}
	.margin-right-left{
		    margin: 0px -13px 0px -6px;	
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
	    width: 24.8%;
	    margin: 0px 0px 0px -7px!important; 
	    #text-indent: 15px;
	    position: relative;
		border:0px solid #FFFFFF;
		border-top: 1px solid <%=border%>;
		/* ganesh */
		#margin: 0 -2px 0px 0 !important;
		
	}
	.test-arrow> ul li:before {
		border-color: transparent transparent transparent <%=border%>;
	    border-style: solid;
	    border-width: 18px 0 18px 18px;
	    content: " ";
	    height: 0;
	    left: 1px;
	    position: absolute;
	    width: 0;
	    z-index: 0
	}
	.test-arrow> ul li:first-child:before {
	    border-color: transparent;
	}
	.test-arrow> ul li a:after {
		border-color: transparent transparent transparent <%=header%>;
	    border-style: solid;
	    border-width: 18px 0 17px 17px;
	    content: " ";
	    height: 0;
	    position: absolute;
	    right: -15px;
	    width: 0;
	    z-index: 10;
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
	/* Large Devices, Wide Screens */
	/* @media only screen and (max-width : 1200px) {
		.small-Icon{
			display: none;
		}
	} */
	/* Medium Devices, Desktops */
	/* @media only screen and (max-width : 992px) {
		.small-Icon{
			display: none;
		}
	} */
	
	/* Small Devices, Tablets */
	@media only screen and (max-width : 768px) {
		.small-Title{
			display:none;
	   	}
	   	.small-Icon{
			display: show;
		}
	   	.small-Icon{
	   		    margin: 10px 0px;
	   	}
	}
	/* Extra Small Devices, Phones */ 
	@media only screen and (max-width : 540px) {
		.small-Title{
			display:none;
		}
	   	.small-Icon{
			display: show;
		}
	}
	/* Extra Small Devices, Phones */ 
	@media only screen and (max-width : 480px) {
		.small-Title{
			display:none;
	   	}
	   	.small-Icon{
			display: show;
		}
	}
	/* Custom, iPhone Retina */ 
	@media only screen and (max-width : 320px) {
		.small-Title{
			display:none;
	   	}
	   	.small-Icon{
			display: show;
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
</style>