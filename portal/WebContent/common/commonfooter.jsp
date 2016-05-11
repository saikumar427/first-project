<script src="/main/js/i18n/en-us/footerjson.js?id=1"></script>
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
.select-active{
	background:#ddd !important;
	color:#000 !important;
}
.select-active:hover{
	background:#ddd !important;
	color:#000 !important;
}
#rootDiv a:hover {
   text-decoration: underline !important;
}

.footerlinks a:hover {
   text-decoration: underline !important;
}
</style>
<div class="container" style="background-color: #474747; width: 100%;">
	<div class="container footer">
		<div class="row" style="margin: 0 auto; padding-bottom: 10px;">
			<div class="row" id="rootDiv">
				
				
			</div>
		</div>
	</div>
</div>
<hr
	style="margin: 0; background-color: #606060; height: 1px; border-top: 1px solid #282828;">
<div class="container" style="background-color: #474747; width: 100%;">
	<div class="container footer">
		<div class="row" style="margin: 0 auto; padding-top: 15px;">
			<div class="row">
				<center>
					<span style="font-size: 12px; color: #ccc">Copyright 2003-2016. Eventbee Inc. All Rights Reserved.</span>
				</center>
				<span class="footerlinks" style="font-size: 0.7em">
					<center>
						<a href="/main/privacystatement/en-us">Privacy Statement</a> <span style="color: #ccc"> |</span>   <a
							href="/main/termsofservice/en-us">Terms Of Service</a>
					</center>
				</span>
				<center><span style="font-size: 12px; color: #ccc">Trusted by 50,000+ Event Managers all over the world for their Online Registration, Event Ticketing and Event Promotion needs!
				</center></span>
			</div>
			<br />
		</div>
	</div>
</div>
<script>
(function fillHTML(){
	var html="<br>";
	for(var i=0;i<i18nFooter.sections.length;i++){
		var eachSection=i18nFooter.sections[i];
		html+='<div class="col-md-'+eachSection.grids+'">';
		
		
		
		for(var j=0;j<eachSection.subsections.length;j++){
			var eachSubSection=eachSection.subsections[j];
			
			if(eachSubSection.title=='search'){
				html+='<span id="dropDown"></span>';
			}else{

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
						   	 html+='<span class="footertab"><a href="'+eachSubLink.href+'/en-us"';
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
				    else if(eachSubLink.type=="img"){
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
	
			}	
		html+='</div><!--grid div close -->';
		document.getElementById("rootDiv").innerHTML=html;
	}
})();
</script>
