angular.module('ticketsapp.controllers.rsvptickets', [])
    .controller('rsvptickets', ['$scope', '$http', '$location', '$timeout', '$rootScope', '$window', '$sce', '$filter', '$interval',
        function($scope, $http, $location, $timeout, $rootScope, $window, $sce, $filter, $interval) {
    	$scope.dropDisble=true;
    	$scope.dropDisbleMay=true;
    	$scope.rsvprecurring="";
    	$scope.attendlimit="";
    	$scope.moreDivClick=false;
    	$scope.notsurelimit="";
    	$scope.otherProfileDiv=false;
    	$http.get($rootScope.baseURL+ 'rsvpoptions.jsp',{
    		params:{
    			eventid:$rootScope.eid
    		}	 
    	 })
         .success(function(data, status, headers, config) {
        	 $rootScope.rsvpData=data;
        	
        	 if(data.do_continue){
        	 $scope.formSH=true;
        	 $scope.selectError=false;
        	 $scope.promotionsectionCheck='yes';
        	 $scope.rsvpEventStatus=data.rsvpstatus;
        	 $rootScope.do_continue=data.do_continue;
        	 $scope.isRecirring=data.rsvprecurring;
        	 $scope.rsvprecurring=data.rsvprecurring;
        	 $scope.isNotAttend=data.notattendingallowed=="Y"?true:false;
        	 $scope.isMaybeAttend=data.notsurelimitallowed=="0"?false:true;
        	 $scope.attendlimit=data.attendlimitallowed;
        	 $scope.notsurelimit=data.notsurelimitallowed;
        	 $scope.notattenAllowed=data.notattendingallowed;
        	 $scope.attending=data.attendingLbl;
        	 $scope.maybe=data.mayBeLbl;
        	 $scope.notAttending=data.notAttendLbl;
        	 $scope.radioButtons=true;
        	 $scope.defaultmsg="Select Count";
        	 $scope.promotionsection=data.promotionsection;
        	 $scope.promotionCheckBox=data.promotionsection=='No'?false:true;
        	 $scope.backToSelectDate=false;
        	 $scope.attOpt=false;
    		 $scope.mayOpt=false;
        	 if($scope.notattenAllowed=='N' && $scope.notsurelimit=='0' && $scope.attendlimit=='1' && $scope.isRecirring!="Y"){
            	 $scope.OneAttendee=true;
            	 $scope.profileHide=true;
            	 $scope.validate(1,0,'yes');
             }
        	 
        	 if($scope.isRecirring=="Y"){
        		 $scope.selected = {value: 1000};     
        		 $scope.selected1 = {value: 1000};
        		 $scope.radioButtons=false;
        		 $scope.date_default_option=data.defaultDrop;
        		 $scope.selectmsg=data.rsvprecdateslable;
        		 $rootScope.selectDate=data.dates;
        		 $scope.moreDates=$rootScope.selectDate.length;
        		 $scope.moreDiv=false;
        		 $scope.moreDivClick1=false;
        		 if($scope.moreDates>10)
        			 $scope.moreDiv=true;
        		 /*$scope.$watch('selectedDate.value', function(newVal, oldVal) {
                     if (newVal == null){
                    	 $scope.radioButtons=false;
                     }
                     if (newVal){
                         $rootScope.eventDate = newVal;
                         $scope.radioButtons=true;
                         $scope.profileDiv=false;
                         $scope.notsureattend=0;
                         $scope.sureattend=0;
                         $scope.rsvpRecurring=false;
                         $scope.dropDisbleMay=$scope.dropDisble=true;
                         if($scope.notattenAllowed=='N' && $scope.notsurelimit=='0' && $scope.attendlimit=='1'){
                        	 $scope.OneAttendee=true;
                        	 $scope.profileHide=true;
                        	 $scope.validate(1,0,'yes');
                         }
                         
                     }
                 });*/
        		 }
        	 
        	 }
        	 else{
        		 $scope.selectError=true;
        		 $scope.reason=data.reason;
        	 }
        	 
        })
        .error(function(data, status, headers, config) {
            alert('Unknown error occured. Please try reloading the page.');
        });
    	
    	 $scope.validate=function(sureattend,notsureattend,option){
    		 $scope.loadingQuestions=false;
    		 $scope.profileDiv=true;
    		 if(sureattend==null || notsureattend==null ){
    			 $scope.notsureattend=0;notsureattend=0;
    			 $scope.profileDiv=false;
    			 return;
    		 }
    		 if(sureattend==0 && notsureattend==0){
    			 $scope.attOpt=false;
    			 $scope.mayOpt=false;
    			 $scope.dropDisbleMay=$scope.dropDisble=true;
    		 }
    		 $scope.sureattend=sureattend;
    		 $scope.notsureattend=notsureattend;
    		 $scope.option=option;
    		 $http.get($rootScope.baseURL+ 'rsvpquestionsjson.jsp',{
    	    		params:{
    	    			eventid:$rootScope.eid,
    	    			sureattend:sureattend,
    	    			notsureattend:notsureattend,
    	    			option:option,
    	    			rsvp_event_date:$rootScope.eventDate
    	    		}	 
    	    	 })
    	    	 .success(function(data, status, headers, config) {
    	    		 	$scope.questionsData=data;
    	    		 	$scope.dataq=[0];
    	    		 	$scope.pCount=false;
    	    		 	$scope.rsvpstatus=data.Available;
    	    		 	$scope.serveradd=data.serveraddress;
    	    		 	$scope.profileQuestions=[];
    	    		 	$scope.otherQuestions=[];
    	    		 	$scope.questions=[];
    	    		 	$scope.profiles=[];
    	    		 	$scope.arribsetid=data.arribsetid;
    	    		 	$scope.rsvpsharepopup=data.showsharepopup;
    	    		 	if($scope.rsvpstatus == 'NO'){
    	    				$scope.rsvpcompleted();
    	    		 	}
    	    		 	else{
    	    		 		$scope.formSH=false;
    	    		 		if($scope.option=='no'){
    	    		 			$scope.notAttquestions=data.questions;
    	    		 			$scope.pCount=true;
    	    		 			$scope.profileHide=true;
    	    		 			$scope.profileName="Not Attending Profile";
    	    		 			$scope.questions.push($scope.questionsData.p_fname);
    	    		 			$scope.questions.push($scope.questionsData.p_lname);
    	    		 			$scope.questions.push($scope.questionsData.p_email);
    	    		 			$scope.otherProfileDiv=false;
    	    		 			$scope.profiles.push({"response":{}});
    	    		 			if($scope.questionsData.buyer_questions!=undefined){
    	    		 				angular.forEach($scope.questionsData.buyer_questions,function(eachquestion,ind){
    	    		 					$scope.questions.push(eachquestion);
    	    		 				});
    	    		 			}
    	    		 			$scope.profileQuestions.push(({'questions': $scope.questions,'profiles':{"response":{}}}));
    	    		 			console.log(JSON.stringify($scope.profileQuestions));
    	    		 		}else if($scope.option=='yes'){
    	    		 			$scope.profileHide=false;
    	    		 			if(sureattend==1 && $scope.attendlimit==1 || $scope.notsurelimit==1 && notsureattend==1)$scope.profileHide=true;
    	    		 			 $scope.surequestions=data.surequestions;
    	    		 			$scope.notsurequestions=data.notsurequestions;
    	    		 			$scope.notAttquestions=data.questions;
    	    		 			$scope.profileName="Profile";
    	    		 			if($scope.sureattend!=0){
    	    		 				$scope.profileQuestionsobj=[];
    	    		 				for(var i=0;i<$scope.sureattend;i++){
    	    		 					$scope.profiles.push({"response":{}});
    	    		 					$scope.profileQuestionsobj.push(i);
    	    		 				}
    	    		 				$scope.dataq=$scope.profileQuestionsobj;
    	    		 				$scope.questions.push($scope.questionsData.s_fname);
        	    		 			$scope.questions.push($scope.questionsData.s_lname);
        	    		 			$scope.questions.push($scope.questionsData.s_email);
        	    		 			if($scope.questionsData.attendee_questions!=undefined){
        	    		 				angular.forEach($scope.questionsData.attendee_questions,function(eachquestion,ind){
        	    		 					$scope.questions.push(eachquestion);
        	    		 				});
        	    		 			}
        	    		 			$scope.profileQuestions.push({'questions': $scope.questions,'profiles': $scope.profiles});
        	    		 				$scope.othrtDataq=[];
        	    		 			if($scope.questionsData.buyer_questions!=undefined){
        	    		 				$scope.otherProfileDiv=true;
        	    		 				angular.forEach($scope.questionsData.buyer_questions,function(eachquestion,ind){
        	    		 					$scope.othrtDataq.push(ind);
        	    		 					$scope.otherQuestions.push(eachquestion);
        	    		 				});
        	    		 			}
        	    		 			console.log("profile : "+JSON.stringify($scope.profileQuestions));
        	    		 			console.log("otherQuestions : "+JSON.stringify($scope.otherQuestions));
    	    		 			}else if($scope.notsureattend!=0){
    	    		 				$scope.profileName="Profile";
    	    		 				$scope.profileQuestionsobj=[];
    	    		 				for(var i=0;i<$scope.notsureattend;i++){
    	    		 					$scope.profiles.push({"response":{},attendee_key: "",seat_code: "NA"});
    	    		 					$scope.profileQuestionsobj.push(i);
    	    		 				}
    	    		 				$scope.dataq=$scope.profileQuestionsobj;
    	    		 				$scope.questions.push($scope.questionsData.ns_fname);
        	    		 			$scope.questions.push($scope.questionsData.ns_lname);
        	    		 			$scope.questions.push($scope.questionsData.ns_email);
        	    		 			if($scope.questionsData.attendee_questions!=undefined){
        	    		 				angular.forEach($scope.questionsData.attendee_questions,function(eachquestion,ind){
        	    		 					$scope.questions.push(eachquestion);
        	    		 				});
        	    		 			}
        	    		 			$scope.profileQuestions.push(({'questions': $scope.questions,'profiles': $scope.profiles}));
        	    		 			if($scope.questionsData.buyer_questions!=undefined){
        	    		 				$scope.otherProfileDiv=true;
        	    		 				angular.forEach($scope.questionsData.buyer_questions,function(eachquestion,ind){
        	    		 					$scope.otherQuestions.push(eachquestion);
        	    		 				});
        	    		 			}
        	    		 			console.log("profile : "+JSON.stringify($scope.profileQuestions));
        	    		 			console.log("otherQuestions : "+JSON.stringify($scope.otherQuestions));
    	    		 			}
    	    		 		}
    	    		 		$scope.loadingQuestions=false;
    	    		 	}
    	    	 });
    	    	 
    			
    	 };
    	 $scope.promotionCheck=function(proCheck){
    		 $scope.promotionsectionCheck=proCheck==false?'no' : 'yes';
    	 };
    	 $scope.sub=function(){
    		 var buyer_info = {};
             var attendee_info = {};
            	 angular.forEach($scope.profileQuestions[0].profiles, function(item, index) {
            		 angular.forEach($scope.sureattend!=0?$scope.surequestions:$scope.notsureattend!=0?$scope.notsurequestions:$scope.notAttquestions, function(item1, index1) {
            			 var ind=index;ind++;
            			 var name=$scope.sureattend!=0?"q_s_"+item1+"_"+ind:$scope.notsureattend!=0?"q_ns_"+item1+"_"+ind:"q_p_"+item1;
            			 buyer_info[name]=$scope.profileQuestions[0].profiles[index].response[item1];	
            		 });
            	 });
            	 angular.forEach($scope.otherQuestions, function(item, index) {
            		 angular.forEach($scope.notAttquestions, function(item1, index1) {
            			 if(item1!="fname" &&  item1!="lname" &&item1!="email"){
            				 var name="q_p_"+item.id;
            				 buyer_info[name]=item.response;
            			 }
            		 });
            	 });
            	 console.log(JSON.stringify(buyer_info));
            	 $http.get('http://localhost/angularTicketWidget/rsvp/rsvprecprofilesubmit.jsp', {
                     params: {
                    	 eventid:$rootScope.eid,
                    	 selectedoption:$scope.option,
                    	 rsvp_event_date: $rootScope.eventDate,
                    	 sure:$scope.sureattend,
                    	 notsure:$scope.notsureattend,
                    	 rsvpsuspended:$scope.rsvpEventStatus,
                         buyer_info: JSON.stringify(buyer_info),
                         arribsetid:$scope.arribsetid,
                         enablepromotion: $scope.promotionsection == 'NO' ? 'no' : $scope.promotionsectionCheck
                     }
                 })
                  .success(function(submitData, status, headers, config) {
                	  $scope.ordernumber=submitData.ordernumber;
                	  $scope.emailid=submitData.emailid;
                	  $scope.statusAvailable=submitData.Available;
                	  $scope.submitDataMsg=submitData.Msg;
                	  $scope.submitStatus=submitData.Status;
                	  $scope.responsetype=submitData.responsetype;
                	  $scope.transactionid=submitData.transactionid;
                	  if($scope.submitStatus=="Success")
                		  if($scope.responsetype=="N"){
                			  $scope.confirmationPage=true;
                	  		  $scope.confirmationPageData=$scope.submitDataMsg+"<br/><br/><a href='' onClick='refreshPage()' align='center'>Back To Event Page</a>";
                		  }
                		  else	  
		                 	  $http.get('http://localhost/angularTicketWidget/rsvp/rsvpconformation.jsp', {
		                         params: {
		                        	 eventid:$rootScope.eid,
		                        	 rsvp_event_date: $rootScope.eventDate,
		                        	 sure:$scope.sureattend,
		                        	 notsure:$scope.notsureattend,
		                        	 transactionid:$scope.transactionid,
		                        	 emailid:$scope.emailid,
		                        	 ordernumber:$scope.ordernumber,
		                         }
		                     }).success(function(submitData, status, headers, config) {
		                    	 $scope.confirmationPage=true;
		                    	 $scope.confirmationPageData=submitData;
		                     });
                  });
    	 };
    	 $scope.rsvpcompleted=function(){
    		    $scope.formSH=true;
    		 	var sure=$scope.attendlimit;
    			var ntsure =$scope.notsurelimit;
    			var rec=$scope.rsvprecurring;
    			var na=$scope.notattenAllowed;
    			if(na == 'null'){
    			na='N';
    			}
    			if(sure !='1' || ntsure != '0' || rec != 'null' || na != 'N'){
    				alert("Attendee count exceeded max available limit");
    			}
    			return false;
    	 }
    	 $scope.dateClick=function(date,ix){
    		 if(ix==1)$scope.selected1 = {value: 1000};
    		 else if(ix==2)$scope.selected = {value: 1000};
    		 $scope.isRecirring=false;
    		 $scope.backToSelectDate=true;
    		 $scope.selectedDate=date;
    		 $rootScope.eventDate = date;
             $scope.radioButtons=true;
             $scope.profileDiv=false;
             $scope.notsureattend=0;
             $scope.sureattend=0;
             $scope.rsvpRecurring=false;
             $scope.dropDisbleMay=$scope.dropDisble=true;
             $scope.loadingQuestions=true;
             if($scope.notattenAllowed=='N' && $scope.notsurelimit=='0' && $scope.attendlimit=='1'){
            	 $scope.OneAttendee=true;
            	 $scope.profileHide=true;
            	 $scope.validate(1,0,'yes');
             }
             
    	 };
    	 $scope.moreDivClick =function(){
    		 $scope.moreDiv=false;
    		 $scope.moreDivClick1=true;
    	 };
    	 $scope.refresh = function(){
    		 $scope.active=true;
    		 $scope.isRecirring=true;
    		 $scope.radioButtons=false;
    		 $scope.moreDiv=false;
    		 $scope.moreDivClick1=true;
    	 };
    	 
    	 $scope.getList=function(range,disable){
    		 if($scope.notsurelimit=='1' && disable=="maybeAttend"){
    			 $scope.mayOpt=false;
    			 $scope.attOpt=false;
            	 $scope.validate(0,1,'yes');
            	 return;
             }
    		 if($scope.attendlimit=='1' && disable=="attend"){
    			 $scope.attOpt=false;
    			 $scope.mayOpt=false;
            	 $scope.validate(1,0,'yes');
            	 return;
             }
    		 if(disable=="attend"){
    			 $scope.attOpt=true;
    			 $scope.mayOpt=false;
    			 $scope.dropDisble=false;
    			 $scope.notsureattend=0;
    			 $scope.dropDisbleMay=true;
    			 $scope.profileDiv=false;
    		 }
    		 else if(disable="maybeAttend"){
    			 $scope.attOpt=false;
    			 $scope.mayOpt=true;
    			 $scope.dropDisble=true;
    			 $scope.sureattend=0;
    			 $scope.dropDisbleMay=false;
    			 $scope.profileDiv=false;
    		 }
    			 
    		 $scope.list = [];
             for (var i = 1; i <= range; i++){
                 $scope.list.push(i);
             }
    	 }
    	 
    }
    ]).filter('dateFormat', function() {
        return function(x) {
        	//24 June 2016 09:00 AM-10:00 AM (Fri)          Mon, Apr 29, 7PM
        	var date=x;
        	if(x=="" || x==null)return "";
        	   var day =  date.split("(")[1].split(")")[0]+", ";//Mon, 
        	   var month=date.split(" ")[1]+" "+date.split(" ")[0]+", ";//Apr 29,
        	   var time=date.split(" ")[3].split(":")[0];
        	        if(time.charAt(0)=="0")
        	        	time=time.charAt(1);
               var amPm =date.split(" ")[4].split("-")[0]; //AM
               x=day+month+time+amPm;
            return x;
        };
    });