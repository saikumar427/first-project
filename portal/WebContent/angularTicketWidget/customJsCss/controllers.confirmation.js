angular.module('ticketsapp.controllers.confirmation', [])
    .controller('confirmation', ['$scope', '$location', '$rootScope','$sce','$window','$timeout','$http','$compile',
        function($scope, $location, $rootScope,$sce,$window,$timeout,$http,$compile) {

            if ($location.search().eid) $rootScope.eid = $location.search().eid;
            else $location.url('/event');

            if ($location.search().tid) $rootScope.transactionId = $location.search().tid;
            else $location.url('/event?eid=' + $rootScope.eid);

            $rootScope.showTimeoutBar = false;
            $scope.config = '';
            $scope.templateHtml='';
            $scope.fbtype = '';
            $scope.ntsdata = {};
            $scope.display_ntscode ='';
            $scope.shareData = {};       
            $scope.emailData = {};
            $rootScope.pageLocation = 'Confirmation';
            
            	try{
                $rootScope.timeWatcher();
                }catch(err){
                }
            
            $scope.confirmationDetails = {
                confirmation_page_header: "Confirmation",
                htmltemplate : $rootScope.templateMsg
            };
      
            $scope.renderInnerHtml = function(){
            	if(document.getElementById('shareblock')){
            	$http.get($rootScope.baseUrl+'widgetsocialshare.jsp?timestamp='+(new Date()).getTime(), {
            		params :{
            			eid:$rootScope.eid,
                    	tid:$rootScope.transactionId,
            		}
            		
            	}).success(function(data, status, headers, config) {
            		$scope.shareData = data;
            		$scope.emailData.url = data.eventurl;
            		$scope.emailData.toemails='';
            		$scope.emailData.fromemail=data.email;
            		$scope.emailData.fromname=data.name
            		$scope.emailData.subject='';
            		$scope.emailData.personalmessage=data.msg;
            		$scope.emailData.captcha='';
            		$scope.emailData.formname='emailForm';
            		var $el = $($scope.shareData.sharehtml).appendTo('#shareblock');
            		$compile($el)($scope);
            	});
            	
            }
            	jQuery('#toplink a#reflink').on('click',function(event){
        			//$location.url($rootScope.serverAddress+'tktwidget/public/index.html/event?eid=' + $rootScope.eid);
        			window.location.href=$rootScope.serverAddress+'tktwidget/public/#/event?eid='+$rootScope.eid;
        			event.preventDefault();
        		});
            	
            	jQuery('#btmlink a').on('click',function(event){
        			//$location.url($rootScope.serverAddress+'tktwidget/public/index.html/event?eid=' + $rootScope.eid);
        			window.location.href=$rootScope.serverAddress+'tktwidget/public/#/event?eid='+$rootScope.eid;
        			event.preventDefault();
        		});
            	
            	jQuery('#submitBtn').on('click',function(event){
                	$scope.fbtype='fbattendee';
                	$scope.fbcommon();
        		});
            };
            
            
            $scope.emailContent = function(){
            	$scope.emailData.toemails = '';
            	$scope.emailData.captcha = '';
            var	htmldata="<img src='/home/images/images/close.png' id='ebeecreditsclose' class='imgclose' ng-click='hide()'>";
            	htmldata +="<div style='background-color:#f5f5f5'><br/><form name='emailForm'  ng-submit='checkEmailForm()' id='emailForm' style='padding-left:23px'>"
            		     +"<input type='hidden' name='url'  ng-model='emailData.url'/>To* :<br>"
            		     +"<textarea id='toheader' name='toemails' ng-model='emailData.toemails' placeholder='Enter emails with comma separated' style='width: 350px; height: 40px;'></textarea><br>"
            		     +" Your Email* :<br> <input type='text' name='fromemail' ng-model='emailData.fromemail'   style='width: 200px;'><br>"
            		     +"Your Name* : <br><input type='text' name='fromname' ng-model='emailData.fromname'   style='width: 200px;'><br>"
            		     +" Subject :<br><input type='text' id='mailsubject' name='subject' ng-model='emailData.subject' value='' style='width: 200px;'><br>"
            		     +"Message :<br> <textarea id='permsg' name='personalmessage' ng-model='emailData.personalmessage' style='width: 350px; height: 50px;'></textarea><br> <p align='center'>"
            		     +"<div id='emailcaptchamsg' style='display: none; color:red' >Enter Correct Code</div> Enter the code as shown below:<div width='100%' valign='top' style='padding:5px;'>"
            		     +"<table><tbody><tr><td valign='middle'><input type='text' valign='top' value='' size='8' name='captcha' ng-model='emailData.captcha'></td><td>"
            		     +"<img src='/home/images/ajax-loader.gif' alt='Captcha' id='emailcaptchaid'></td></tr></tbody></table></div><br>"
            		     +"<input type='hidden' name='formname'  ng-model='emailData.formname'/>"
            		     +"<div style='background-color:#f5f5f5'><div class='submitbtn-style' style='width:70px;float:left'><input type='submit' name='sendmsg' value='Send' class='fbsharebtn'> </div>"
            		     +"<div class='submitbtn-style' style='width:70px;float:left'><input type='button' ng-click='hide()'  class='fbsharebtn' value='Cancel'></div> </p></form></div></div>";
            	
            	document.getElementById('attendeeloginpopup').HTML='';
            	var $el = $(htmldata).appendTo('#attendeeloginpopup');
        		$compile($el)($scope);
            	
            	
            	//document.getElementById('attendeeloginpopup').innerHTML=htmldata;
            	if(document.getElementById("backgroundPopup"))
            		document.getElementById("backgroundPopup").style.display="block";
            	$window.scrollTo(0,0);
            	document.getElementById('ebeecreditsclose').style.marginTop='-15px';
            	document.getElementById('ebeecreditsclose').style.marginRight='-16px';
            	document.getElementById('ebeecreditsclose').style.cursor='pointer';
            	document.getElementById('attendeeloginpopup').style.width='auto';
            	document.getElementById('attendeeloginpopup').style.minWidth='435px';
            	document.getElementById('attendeeloginpopup').style.height='auto';
            	document.getElementById('attendeeloginpopup').style.top='18%';
            	document.getElementById('attendeeloginpopup').style.left='28%';	
            	document.getElementById('attendeeloginpopup').style.padding=0;
            //	document.getElementById('ebeecreditsclose').onclick=ccscreenclose;
            	document.getElementById('attendeeloginpopup').style.backgroundColor='#FFFFFF';
            	document.getElementById('attendeeloginpopup').style.display="block";
            	document.getElementById("emailcaptchaid").src="/captcha?fid=emailForm&pt="+new Date().getTime();
            };
            
            
            $scope.checkEmailForm = function(){
            	
            	//action='/portal/emailprocess/emailsend.jsp?UNITID=13579&id="+$rootScope.eid+"&purpose=INVITE_FRIEND_TO_EVENT'  method='post'
            	
            	
            	if (!document.emailForm.fromname.value) {
        			alert('Please enter your name.');
        			return false;
        		}
        		if (!document.emailForm.fromemail.value) {
        			alert('Please enter your email address.');
        			return false;
        		}
        		if (!document.emailForm.toemails.value) {
        		    alert('Please enter a valid email address in the To field.');
        			return false;
        		}
        		if (!document.emailForm.subject.value) {
        			alert('Please enter a subject for your message.');
        			return false;
        		}
        		if (!document.emailForm.personalmessage.value) {
        			alert('Please enter your message.');
        			return false;
        		}
        		if (!/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(document.emailForm.fromemail.value)){
        			alert('Your email address is not valid.');
        			return false;
        		}
        		  var toemail=document.emailForm.toemails.value;
        			var tokens = toemail.split(',');
        			//alert("jsonObjec::"+tokens);
        		for(var i=0; i<tokens.length; i++){
        			if (!/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(tokens[i])){
        				//alert(tokens[i] + ' is not a valid email address.');
        				return false;
        			}
        		}
        		
        		$http.get($rootScope.serverAddress+'emailprocess/emailsend.jsp?UNITID=13579&id='+$rootScope.eid+'&purpose=INVITE_FRIEND_TO_EVENT',{
            		params: $scope.emailData
            	}).success(function(data, status, headers, config) {
                	//$scope.getNTScoderesponse(data);
            		var restxt=data;
         		   if(restxt.indexOf("Error")>-1){
         		  		     document.getElementById('emailcaptchamsg').style.display='block';
         					 document.getElementById("emailcaptchaid").src="/home/images/ajax-loader.gif";
         					 document.getElementById("emailcaptchaid").src="/captcha?fid=emailForm&pt="+new Date().getTime();
         		  		     document.emailForm.sendmsg.value="Send";
         		     }
         		     else{
         		    	document.getElementById('attendeeloginpopup').innerHTML='';
         		    	var htmlcontent="<img src='/home/images/images/close.png' id='ebeecreditsclose' class='imgclose' ng-click='hide()'><center>"+restxt+"<br><input type='button' value='OK' ng-click='hide()'>";
         		    	var $el = $(htmlcontent).appendTo('#attendeeloginpopup');
                		$compile($el)($scope);
                		document.getElementById('ebeecreditsclose').style.marginTop='-15px';
                    	document.getElementById('ebeecreditsclose').style.marginRight='-16px';
         		    	
         				/*ebeepopup.setContent("<center>"+restxt+"<br><input type='button' value='OK' onclick='ebeepopup.hide()'>");
         				ebeepopup.show();*/
         		   }
            		
               });
        		
        		
            };
            
            $scope.hide = function(){
            	document.getElementById('attendeeloginpopup').removeAttribute("style");
            	document.getElementById('attendeeloginpopup').innerHTML='';
            	document.getElementById('attendeeloginpopup').style.display="none";
            	document.getElementById("backgroundPopup").style.display="none";
            };
            
            
            $scope.fbconfshare = function(){
            	//alert("fbconfshare");
            	$scope.fbtype='conffbshare';
            	$scope.fbcommon();
            };
            
            $scope.conftweet = function(){
            	var url="//images.eventbee.com/tweet/?event_id="+$rootScope.eid;
    			if($rootScope.serverAddress.indexOf('eventbee')<0)				
    			url=url+"&type=sandbox";
    			window.open(url,'','height=600,width=650');	
            };
            
            $scope.referral_link = "http://www.eventbee.com/event?eid=" + $rootScope.eid;
            $scope.orderNumber = '1000234';
            
            $scope.renderHtml = function(){
            	$scope.templateHtml = $sce.trustAsHtml($rootScope.templateMsg);
            	$timeout($scope.renderInnerHtml,10);
            };
            
            /* facebook share begins here */
            
            
            $scope.fbcommon = function(){
            	FB.login(function(response1){
            		 FB.api('/me', function(response) {
            							if(response.id!=undefined){
            							$scope.ntsdata["fbuid"]=response.id;
            							$scope.ntsdata["fbuname"]=response.name;
            								$scope.getNTScode(response, $rootScope.eid);
            								if($scope.fbtype=='fbattendee')
            								$scope.loginwithtoken(response.id);
            							}
            		                });
            						});
            };
            
            
            $scope.loginwithtoken = function(fbuid){
            	var url=$rootScope.serverAddress+'attendee/authtoken?fbuid='+fbuid;
                $http.get(url).success(function(data, status, headers, config) {
            	  	window.location.href=$rootScope.serverAddress+"attendee/mypurchases/home?aid="+data; 
            	});
                        
                        };
            
            
            
            
            
            $scope.getNTScode = function(response,eventid){
            	var fbid=response.id;
            	$http.get($rootScope.serverAddress+'embedded_reg/getntscode.jsp?timestamp='+(new Date()).getTime(),{
            		params: {
            		eid:eventid,
            		fbuserid:fbid,
            		fname:response["first_name"],
            		lname:response["last_name"],
            		email:response["email"],
            		network:'facebook'
            			}
            	}).success(function(data, status, headers, config) {
                	$scope.getNTScoderesponse(data);
               });
            };
            
            $scope.getNTScoderesponse = function(response){
            	var responsedata = response ;
            	var ntscode=responsedata.ntscode;
            	$scope.display_ntscode=responsedata["display_ntscode"];
            	if($scope.fbtype!='fbattendee'){
            		if($scope.fbtype=='conffbshare')
            			$scope.fbfeed();
            		else	
            			$scope.streamPublish('Eventbee', 'eventbee.com', 'hrefTitle', 'http://eventbee.com', "Share eventbee.com");
            		}
            	$scope.updateRegistrationNTSCode(ntscode);
            };
            
            
            $scope.fbfeed = function(){
            	var feedurl=$scope.getEventUrl($scope.display_ntscode);
            	var caption = $scope.shareData.caption;
            	FB.ui({	method: 'feed',
            			    name: $scope.shareData.linkname,
            			    link: feedurl,
            			    picture: $scope.shareData.eventlogo,
            			    caption: 'I registered for "'+caption+'" via Eventbee!',
            			    description: $scope.shareData.description
            			  },
            			  function(response) {
            			    if (response && response.post_id) {
            			     // alert('Post was published.');
            				 $scope.insertPromotion($rootScope.eid,'facebook');
            			    } else {
            			      //alert('Post was not published.');
            			    }
            			  }
            			);
            };
            $scope.getEventUrl = function(dntscode){
            	var linkurl=$scope.shareData.eventurl;
        		if(dntscode!=""){
        			if($scope.shareData.urltype=='short')
        			linkurl+="/n/"+dntscode;
        		else
        			linkurl+="&nts="+dntscode;
        		}
        		return linkurl;
            };
            
            
            var refreshPage = function(){
            	window.location.href=$rootScope.serverAddress+'tktwidget/public/#/event?eid='+$rootScope.eid;
            	//$location.url('/event?eid=' + $rootScope.eid);
            };
            
            
            $scope.insertPromotion = function(eid,network){
            	$http.get($rootScope.serverAddress+'socialnetworking/insertpromotion.jsp?timestamp='+(new Date()).getTime(), {
            		params:{eid:eid,name:$scope.ntsdata.fbuname,fbuid:$scope.ntsdata.fbuid,nts_code:$scope.display_ntscode,network:network}
              }).success(function(data, status, headers, config) {
              	//$scope.getNTScoderesponse(data);
            	  $scope.display_ntscode='';
              });
             };
            
            
            $scope.updateRegistrationNTSCode = function(ntscode){
            	$http.get($rootScope.serverAddress+'embedded_reg/updatentsaction.jsp?timestamp='+(new Date()).getTime(),{
            		params:{ntscode:ntscode,eid:$rootScope.eid,tid:$rootScope.transactionId}
            	});
            };
            
            /* facebook share ends here   */
            
        }
    ]);
