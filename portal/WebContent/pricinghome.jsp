
<link type="text/css" rel="stylesheet" href="/main/css/bootstrap/bootstrap.min.css" />
<link type="text/css" rel="stylesheet" href="/main/css/bootstrap/style.css" />
<link rel="stylesheet" href="/main/slider/dist/powerange.css" />
  <link rel="stylesheet" href="/main/slider/style.css" />

<style>
body{
	margin-top:0px !important;
}
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
	text-align: center;
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

.caption_header_blue_faq{
	font-size: 32px;
	#font-weight: normal;
	#text-align: center;
	color:#428BCA;
}


.medium_desc_grey{
	color: #999999;
    font-size: 20px;
    text-align: center;
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
    margin: 48px;
	margin-top:15px;
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

slider-wrapper {
	margin : 24px 0 30px 30px !important
}


</style>
<div style="width: 100%; background-color: #FFFFFF;padding-top:32px;padding-bottom:32px;" class="container">
<button type="button" class="close" style="margin-top:-10px;margin-right:10px">&times;</button>
<div class="container">
		<div class="row">
			<div class="col-md-4">
				<div class="caption_header_blue" id="currentticket">Current
					Provider</div>
				<div></div>
				<div class="dropdown">
					<div class="subevent" id="eventbrite">				
	
						<span class="medium_desc_grey" style="padding: 12px;color:white">Eventbrite</span>
					</div>
					<div id="others" style="display: block">
						<div class="subevent" id="ticketleap">
							<span class="medium_desc_grey" style="padding: 12px;color:grey">Ticketleap</span>
						</div>
						<div class="subevent" id="ticketmaster">
							<span  class="medium_desc_grey" style="padding: 12px;color:grey">Ticketmaster</span>
						</div>
						<div class="subevent" id="other">
						<span class="medium_desc_grey" style="padding: 12px;color:grey;">Other&nbsp;&nbsp;<input type="text" size="2" class="input-field" id="pf"
							>&nbsp;%&nbsp;&nbsp;+&nbsp;$&nbsp;<input type="text" size="2"
							class="input-field" id="ff"></span>
						</div>
					</div>
				</div>
			</div>
			<div class="col-md-4">
				<div class="caption_header_blue" id="avgticketsprice">Ticket Price</div>
				<div></div>

				<div id="ticketsprice">
					<div class="row">
						<div class="col-md-4"></div>
						<div class="slider-wrapper vertical-wrapper col-md-4">
							<input type="text" class="js-vertical" />
						</div>
						<div class="avgtooltip"></div>
						<div class="col-md-4"></div>
					</div>
				</div>

			</div>
			<div class="col-md-4">
				<div class="caption_header_blue" id="ticketssold">Ticket Quantity</div>
				<div id="ticketscount">
					<div class="row">
						<div class="col-md-4"></div>
						<div class="slider-wrapper vertical-wrapper col-md-4">
							<input type="text" class="js-vertical-slider" />
						</div>
						<div class="avgtooltip"></div>
						<div class="col-md-4"></div>
					</div>
				</div>
			</div>
		</div>
		
		<div class="row">
			<div class="col-md-12 medium_desc_grey">
					You save <span id="savedamount"></span> by switching to Eventbee
					Basic Ticketing
			</div>			
		</div>
		
</div>
</div>
<script	src="//ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script src="/main/slider/dist/powerange.js"></script>

<script>

          var fixedfee;
         var pf;
         var vert;
         var initVert1;
         var elem;
         var initVert2;
		 var domain;
		 $(window).resize(function(){
		 parent.resizePriceIframe();		 
		 });
         $(document).ready(function() {          	   
        	    var avg;var num;
				domain='eventbrite';
        	    vert = document.querySelector('.js-vertical');
        	    initVert1 = new Powerange(vert, { min: 0, max: 1000, start: 100, vertical: true , callback : displayAvgTckt, dollar:true });
				avg=100;
				
        	    elem = document.querySelector('.js-vertical-slider');
        	    initVert2 = new Powerange(elem, {  min: 0,  max: 10000, start: 1000, vertical: true , callback : displayNumOfTckt }); 
				num=1000;
        	    function displayAvgTckt() {
				if(isNaN(vert.value) || vert.value=='undefined' || vert.value==undefined || isNaN(parseInt(vert.value, 10))){
				   vert.value=100; 
				}  avg=vert.value;	
              	  
              	  saveamount(avg,num);   
              	$('#ticketsprice').find('.avgtooltip').css('bottom',parseInt($('#ticketsprice').find('.range-handle').css('bottom'),10)+18);
              	$('#ticketsprice').find('.avgtooltip').html('$'+avg); 
              	}
				
               function displayNumOfTckt() {
			   if(isNaN(elem.value) || elem.value=='undefined' || elem.value==undefined || isNaN(parseInt(elem.value, 10))){
					elem.value=1000;
			   }  num=elem.value; 
             	 
             	  saveamount(avg,num);
             	 $('#ticketscount').find('.avgtooltip').css('bottom',parseInt($('#ticketscount').find('.range-handle').css('bottom'),10)+18);
             	$('#ticketscount').find('.avgtooltip').html(num);
             	}
               
              
               $('#eventbrite').css('background-color','#F27A28');
                fixedfee='0.99';
            	  pf='2.5';
         	   saveamount(avg,num);

               $('#eventbrite').click(function(){
			   domain='eventbrite';
              	 $('#ticketmaster').css('background-color','#F3F6FA');
              	$('#ticketmaster').find('span').css('color','grey');
              	 $('#ticketleap').css('background-color','#F3F6FA');
              	$('#ticketleap').find('span').css('color','grey');
              	 $('#other').css('background-color','#F3F6FA');
              	$('#other').find('span').css('color','grey');
              	 $('#eventbrite').css('background-color','#F27A28');
              	$('#eventbrite').find('span').css('color','white');
                  fixedfee='0.99';
            	  pf='2.5';
            	  $(vert).next("span").remove();            	            	   
              	 initVert1 = new Powerange(vert, { min: 0, max: 1000, start: 100, vertical: true , callback : displayAvgTckt, dollar:true, disable : false});
              	 $(elem).next("span").remove();            	            	   
         	     initVert2 = new Powerange(elem, { min: 0, max: 10000, start: 1000, vertical: true , callback : displayNumOfTckt, disable : false});
                   saveamount(avg,num);
                   $('.avgtooltip').show();
               });
               
               $('#ticketmaster').click(function(){
			   domain='ticketmaster';
              	 $('#eventbrite').css('background-color','#F3F6FA');
              	$('#eventbrite').find('span').css('color','grey');
              	 $('#ticketleap').css('background-color','#F3F6FA');
              	$('#ticketleap').find('span').css('color','grey');
              	 $('#other').css('background-color','#F3F6FA');
              	$('#other').find('span').css('color','grey');
              	 $('#ticketmaster').css('background-color','#F27A28');
              	$('#ticketmaster').find('span').css('color','white');          
                   document.getElementById('savedamount').innerHTML='<font color="#F27A28">$ZILLION</font>'; 
              		$(vert).next("span").remove();            	            	   
            	    initVert1 = new Powerange(vert, { min: 0, max: 1000, start: 100, vertical: true , callback : displayAvgTckt, dollar:true, disable : true});
            	    $(elem).next("span").remove();            	            	   
            	    initVert2 = new Powerange(elem, { min: 0, max: 10000, start: 1000, vertical: true , callback : displayNumOfTckt, disable : true});
            	  document.getElementById('savedamount').innerHTML='<font color="#F27A28">$ZILLION</font>'; 
            	  $('.avgtooltip').hide();
               });
               
               $('#ticketleap').click(function(){
			    domain='ticketleap';
              	 $('#ticketmaster').css('background-color','#F3F6FA');
              	$('#ticketmaster').find('span').css('color','grey');
              	 $('#eventbrite').css('background-color','#F3F6FA');
              	$('#eventbrite').find('span').css('color','grey');
              	 $('#other').css('background-color','#F3F6FA');
              	$('#other').find('span').css('color','grey');
              	 $('#ticketleap').css('background-color','#F27A28');
              	$('#ticketleap').find('span').css('color','white');
                  fixedfee='1';
            	  pf='2';
            	  $(vert).next("span").remove();            	            	   
             	 initVert1 = new Powerange(vert, { min: 0, max: 1000, start: 100, vertical: true , callback : displayAvgTckt, dollar:true, disable : false});
             	 $(elem).next("span").remove();            	            	   
         	    initVert2 = new Powerange(elem, { min: 0, max: 10000, start: 1000, vertical: true , callback : displayNumOfTckt, disable : false});
                   saveamount(avg,num);
                   $('.avgtooltip').show();
               });
               
               $('#other').click(function(){
			    domain='other';
              	 $('#ticketmaster').css('background-color','#F3F6FA');
              	$('#ticketmaster').find('span').css('color','grey');
              	 $('#ticketleap').css('background-color','#F3F6FA');
              	$('#ticketleap').find('span').css('color','grey');
              	 $('#eventbrite').css('background-color','#F3F6FA');
              	$('#eventbrite').find('span').css('color','grey');
              	 $('#other').css('background-color','#F27A28');
              	$('#other').find('span').css('color','white');
              	   fixedfee=document.getElementById("ff").value;                  
				  pf=document.getElementById("pf").value;
                  $(vert).next("span").remove();            	            	   
              	 initVert1 = new Powerange(vert, { min: 0, max: 1000, start: 100, vertical: true , callback : displayAvgTckt, dollar:true, disable : false});
              	 $(elem).next("span").remove();            	            	   
         	    initVert2 = new Powerange(elem, { min: 0, max: 10000, start: 1000, vertical: true , callback : displayNumOfTckt, disable : false});
                   saveamount(avg,num);
                   $('.avgtooltip').show();
               });
               
            
               
              $('#pf , #ff').keyup(function(evt){  
            	     if(isNumberKey(evt)){						
	            	  	  setTimeout(function(){            		  
	            		  fixedfee=document.getElementById("pf").value;
	                      pf=document.getElementById("ff").value;            		  
	            		  saveamount(avg,num);},10);
            	     }
            	     return isNumberKey(evt);
               });
              
              function isNumberKey(evt)
              {
            	  var charCode = (evt.which) ? evt.which : evt.keyCode;
                  if (charCode != 46 && charCode>31  && (charCode<48 || charCode>57))
                     return false;

                 return true;
              }
       });  
         
         
		 
		  function addCommas(nStr)
   {
       nStr += '';
       x = nStr.split('.');
       x1 = x[0];
       x2 = x.length > 1 ? '.' + x[1] : '';
       var rgx = /(\d+)(\d{3})/;
       while (rgx.test(x1)) {
           x1 = x1.replace(rgx, '$1' + ',' + '$2');
       }
       return x1 + x2;
   }
		 
        
        
         function saveamount(avg,num){
             var tktprice=avg;
            var tktcnt=num;           
            var savedamt;   
            var eventbeeamt;
            var amount=(tktcnt*tktprice*(pf/100))+(tktcnt*fixedfee);
			if(tktprice==0){
				eventbeeamt=0;
				if(domain=='eventbrite' || domain=='ticketleap'){
					amount=0;
				}		
			}
            else eventbeeamt=tktcnt*1;
           if(fixedfee=='' && pf=='' ){
        	   savedamt=0.00;
           }else{savedamt=amount-eventbeeamt;}
     	   document.getElementById('savedamount').innerHTML='<font color="#F27A28">$'+addCommas(savedamt.toFixed(0))+'</font>'; 
        }
        	 
		$('.close').click(function(){
			parent.slidedownFunc();
		});
</script>