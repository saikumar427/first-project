angular.module('ticketsapp.controllers.confirmation', [])
    .controller('confirmation', ['$scope', '$location', '$rootScope','$sce','$window','$timeout','$http','$compile',
        function($scope, $location, $rootScope,$sce,$window,$timeout,$http,$compile) {

            if ($rootScope.eid) $rootScope.eid = $rootScope.eid;
            else $location.url('/event');
            $rootScope.pageLocation = 'Confirmation';
            if ($rootScope.transactionId) $rootScope.transactionId = $rootScope.transactionId;
            else $location.url('/event');
            $rootScope.css3 = 'active';$rootScope.css4 ="";
            $rootScope.showTimeoutBar = false;
            $scope.config = '';
            $scope.templateHtml='';
            $scope.fbtype = '';
            $scope.ntsdata = {};
            $scope.display_ntscode ='';
            $scope.shareData = {};       
            $scope.emailData = {};
            $scope.showEmail=true;
            $scope.shareonfacebookpop = false;
            
            /* i18n start */
            $scope.emailData.To= 'To';
        	$scope.emailData.YourEmail ='Your Email';
        	$scope.emailData.YourName ='Your Name';
        	$scope.emailData.Subject ='Subject';
        	$scope.emailData.Message ='Message';
        	$scope.emailData.EnterShownBelow ='Enter the code as shown below';
        	$scope.emailData.EnterCorrectCode ='Enter Correct Code';
        	$scope.emailData.EnterWithComms='Enter emails with comma separated';
        	$scope.emailData.Captcha='Captcha';
        	$scope.emailData.send='Send';
        	$scope.emailData.cancel='Cancel';
        	$scope.confirmData = {
        			backtoevent : 'Back To Event Page'
        	};
            /* i18n end */
        	
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
            	$http.get($rootScope.baseURL+'widgetsocialshare.jsp?timestamp='+(new Date()).getTime(), {
            		params :{
            			eid:$rootScope.eid,
                    	tid:$rootScope.transactionId,
            		}
            		
            	}).success(function(data, status, headers, config) {
            		$scope.shareData = data;
            		$scope.emailData.url = data.eventurl;
            		$scope.emailData.toemails='';
            		$scope.emailData.fromemail=data.email;
            		$scope.emailData.fromname=data.name;
            		$scope.emailData.subject='';
            		$scope.emailData.personalmessage=data.msg;
            		$scope.emailData.captcha='';
            		$scope.emailData.formname='emailForm';
            		var $el = $($scope.shareData.sharehtml).appendTo('#shareblock');
            		$compile($el)($scope);
            		$scope.tooltip();
            	});
            	
            }
            	/*jQuery('#toplink a#reflink').on('click',function(event){
        			window.location.href=$rootScope.serverAddress+'event?eid='+$rootScope.eid;
        			event.preventDefault();
        		});
            	
            	jQuery('#btmlink a').on('click',function(event){
        			window.location.href=$rootScope.serverAddress+'event?eid='+$rootScope.eid;
        			event.preventDefault();
        		});*/
            	
            	jQuery('#submitBtn').on('click',function(event){
                	$scope.fbtype='fbattendee';
                	$scope.fbcommon();
        		});
            };
            $scope.referral = function(){
            	$('#show_ref_link').toggle('slow', function() {
            	    // Animation complete.
            	  });
            };
            $scope.backToTickets = function(){
            	location.reload();
            };
            $scope.tooltip = function(){
            	$('#fbconfshare').tooltipster({
              		 content:$('<span>Facebook</span>'),
              	    fixedWidth:'100px',
              	    position: 'top'
              	    });
            	$('#conftweet').tooltipster({
             		 content:$('<span>Twitter</span>'),
             	    fixedWidth:'100px',
             	    position: 'top'
             	    });
            	$('#submitBtn').tooltipster({
             		 content:$('<span>Email</span>'),
             	    fixedWidth:'100px',
             	    position: 'top'
             	    });
            	$('#referralBtn').tooltipster({
             		 content:$('<span>Referrl link</span>'),
             	    fixedWidth:'100px',
             	    position: 'top'
             	    });
            	
            	
            	
            	
            };
            
            
            $scope.emailContent = function(){
            	$scope.showEmail=true;
            	$scope.emailData.toemails = '';
            	$scope.emailData.captcha = '';
            	$('#shareEventEmail').modal('show');
            	document.getElementById("emailcaptchaid").src="/captcha?fid=emailForm&pt="+new Date().getTime();
            	
            	var elements = document.getElementsByClassName("form-control");
    			for (var i = 0; i < elements.length; i++) {
    			    elements[i].oninvalid = function(e) {
    			        e.target.setCustomValidity("");
    			        if (!e.target.validity.valid) {
    			            e.target.setCustomValidity("Required field");
    			        }
    			    };
    			    elements[i].oninput = function(e) {
    			        e.target.setCustomValidity("");
    			    };
    			}
            };
            
            
            $scope.checkEmailForm = function(){
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
        		for(var i=0; i<tokens.length; i++){
        			if (!/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(tokens[i])){
        				return false;
        			}
        		}
        		
        		$http.get($rootScope.serverAddress+'emailprocess/emailsend.jsp?UNITID=13579&id='+$rootScope.eid+'&purpose=INVITE_FRIEND_TO_EVENT',{
            		params: $scope.emailData
            	}).success(function(data, status, headers, config) {
            		var restxt=data;
         		   	if(restxt.indexOf("Error")>-1){
     		  		     document.getElementById('emailcaptchamsg').style.display='block';
     					 document.getElementById("emailcaptchaid").src="/home/images/ajax-loader.gif";
     					 document.getElementById("emailcaptchaid").src="/captcha?fid=emailForm&pt="+new Date().getTime();
     		  		     document.emailForm.sendmsg.value="Send";
         		     }else{
         		    	 document.getElementById('attendeeloginpopup').innerHTML='';
         		    	 var htmlcontent = '<div class="text-center alert alert-success">'+restxt+'</div>';
         		    	 $('#shareEventEmailHtml').html(htmlcontent);
         		    	$scope.showEmail=false;
         		   }
            		
               });
            };
            
            
            $scope.hide = function(){
            	
            	//$('#shareEventEmailHtml').html('');
            	$('#shareEventEmail').modal('hide');
            	
            	document.getElementById('attendeeloginpopup').removeAttribute("style");
            	document.getElementById('attendeeloginpopup').innerHTML='';
            	document.getElementById('attendeeloginpopup').style.display="none";
            	document.getElementById("backgroundPopup").style.display="none";
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
            	if('Y'==$rootScope.eventDetailsList.fbsharepopup || 'Y' == $rootScope.eventDetailsList.nts_enable){
            		$scope.openSharePop();
            	}
            };
            $scope.openSharePop = function(){
            	var shareHtml = '<div class="col-md-12 col-sm-12 text-center">Publish to Facebook. Let your friends know that you are attending this event!</div><br><br><br>';
            	shareHtml = shareHtml + '<div class="text-center"><button type="button" class="btn btn-primary btn-sm" id="shareOnFacebook"><i class="fa fa-facebook"></i> | Share on Facebook</button></div>';
            	$('#shareonfacebookpopHtml').html(shareHtml);
            	$scope.shareonfacebookpop= true;
            	//$('#shareonfacebookpop').modal('show');
            	
            	$('#shareOnFacebook').click(function(){
                	$scope.fbconfshare();
                	//$('#shareonfacebookpop').modal('hide');
                	$scope.shareonfacebookpop= false;
                });
            };
            
            $scope.close_share = function(){
            	$scope.shareonfacebookpop= false;
            	//$('#shareonfacebookpop').modal('hide');
            };
            $scope.fbconfshare = function(){
            	$scope.fbtype='conffbshare';
            	$scope.fbcommon();
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
            
            
           /* var refreshPage = function(){
            	window.location.href=$rootScope.serverAddress+'/event?eid='+$rootScope.eid;
            };*/
            
            
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
