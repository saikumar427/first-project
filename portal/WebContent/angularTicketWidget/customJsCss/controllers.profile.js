angular.module('ticketsapp.controllers.profile', [])
    .controller('profile', ['$rootScope', '$scope', '$http', '$timeout', '$filter', '$location', '$interval', '$window',
        function($rootScope, $scope, $http, $timeout, $filter, $location, $interval, $window) {
    	$rootScope.pageLocation = 'Profiles';
            if ($rootScope.transactionId == '') {
                $location.url('/tickets');
            }
            try {
                $rootScope.timeWatcher();
            } catch (err) {}
            
            $rootScope.css = 'active';
            $rootScope.css1 = 'active';
            $rootScope.css2 = "";
            $rootScope.css3 = "";
            $rootScope.css4 = "";

            $rootScope.$on('eventName', function(event, args) {
                $scope.message = args.message;
                console.log($scope.message);
            });

            $rootScope.showTimeoutBar = false;
            $rootScope.globalTimer = $interval(function() {
                $rootScope.timeRemaining = $rootScope.millis - (+new Date);
            }, 500);

            $scope.suggestionData = [];
            $scope.pushTempData = function(ele) {
                $scope.suggestionData.push(ele);
            };
            $scope.complete = function() {
                $scope.data = $scope.eliminateDuplicates($scope.suggestionData);
                $(".suggestion-list").autocomplete({
                    source: $scope.data
                });
            };
            $scope.eliminateDuplicates = function(arr) {
                var i,
                    len = arr.length,
                    out = [],
                    obj = {};
                for (i = 0; i < len; i++) {
                    obj[arr[i]] = 0;
                }
                for (i in obj) {
                    out.push(i);
                }
                return out;
            };


            if ($rootScope.eid) $rootScope.eid = $rootScope.eid;
            else {
                $location.url('/tickets');
            }


            $http.get($rootScope.baseURL + 'getProfileJSON.jsp', {
                    params: {
                        api_key: '123',
                        event_id: $rootScope.eid,
                        transaction_id: $rootScope.transactionId
                    }
                })
                .success(function(data, status, headers, config) {
                    $scope.profileQuestions = data;
                    $scope.loadingQuestions = false;
                    $rootScope.menuTitles = true;
                    $rootScope.totalMinutes = Number(data.timediffrence);
                    $rootScope.secondsRemaining = Number(data.secdiffrence);
                    $rootScope.timeRemaining = ($rootScope.totalMinutes * 60000) + ($rootScope.secondsRemaining * 1000);
                    $rootScope.millis = (+new Date) + ($rootScope.totalMinutes * 60 * 1000) + ($rootScope.secondsRemaining * 1000);
                    $rootScope.showTimeoutBar = true;
                    $rootScope.backLinkWording = data.backbutton;
                    $scope.requiredError = data.Required;
                    if (data.enablepromotion == 'false'){
                    	$scope.promotionsDiv = false;
                    	$scope.promotions = false;
                    }else{
                    	$scope.promotions = true;
                    	$scope.promotionsDiv = true;
                    }
                    	
                    $rootScope.timeWatcher = $rootScope.$watch('timeRemaining', function(newVal, oldVal) {
                        if (newVal < 0) {
                            $interval.cancel($rootScope.globalTimer);
                            $rootScope.timeWatcher();
                           $rootScope.timeOutBg = true;
                            // $window.location.href=$rootScope.serverAddress+'tktwidget/public/#/event?eid='+$rootScope.eid;
                        }
                    });
                    $scope.applyBuyerDetails();
                })
                .error(function(data, status, headers, config) {
                    alert('Unknown error occured. Please try reloading the page.');
                });

            $scope.assignEmpty = function(Obj, qid) {
                if (!Obj[qid])
                    Obj[qid] = new Object();
            };
            
            $scope.applyBuyerDetails = function(){
            	$timeout(function() {
            		$scope.$apply(function() {
                        $scope.profileQuestions.buyer_questions[0].response = $rootScope.facebookNTSdetails.first_name;
                        $scope.profileQuestions.buyer_questions[1].response = $rootScope.facebookNTSdetails.last_name;
                        $scope.profileQuestions.buyer_questions[2].response = $rootScope.facebookNTSdetails.email;
                    });
            		
            		// set custom error message
        			var elements = document.getElementsByTagName("INPUT");
        			for (var i = 0; i < elements.length; i++) {
        			    elements[i].oninvalid = function(e) {
        			        e.target.setCustomValidity("");
        			        if (!e.target.validity.valid) {
        			            e.target.setCustomValidity("custom error required");
        			        }
        			    };
        			    elements[i].oninput = function(e) {
        			        e.target.setCustomValidity("");
        			    };
        			}
        			// set custom error message
            		
                },1000);
            };
            
            /* for collecting Temp data buyer and attendee start */
            $scope.buyerAnswers = $rootScope.buyerAnswers;
            $scope.attendeeAnswers = $rootScope.attendeeAnswers;
            $scope.isAnsStored=function(){
            	if($scope.buyerAnswers)
            		return true;
            	else
            		return false;
            };
            $scope.getBuyerAnswers=function(id,type){
                if(type == 'checkbox'){
              	  if($scope.buyerAnswers)
    	            	return $scope.buyerAnswers[''+id] ? $scope.buyerAnswers[''+id]['value'] : []; 	
                }else{ 
              	  if($scope.buyerAnswers){
  	            	return $scope.buyerAnswers[''+id] ? $scope.buyerAnswers[''+id]['value'] : '';
              	}
              	else
              		return "";
                }
              };
              $scope.isAttAnsStored=function(){
              	if($scope.attendeeAnswers)
              		return true;
              	else
              		return false;
              };
              $scope.getAttendeeAnswers=function(id,type,qtyindex,ticketid){
                  if(type == 'checkbox'){
                	  if($scope.attendeeAnswers && $scope.attendeeAnswers[''+ticketid] && (qtyindex <= $scope.attendeeAnswers[''+ticketid]['qty']))
      	            	return $scope.attendeeAnswers[''+ticketid] ? $scope.attendeeAnswers[''+ticketid]['qty_'+qtyindex][id] ['value'] : []; 	
                  }else{ 
                	  if($scope.attendeeAnswers && $scope.attendeeAnswers[''+ticketid] && (qtyindex <= $scope.attendeeAnswers[''+ticketid]['qty'])){
    	            	return $scope.attendeeAnswers[''+ticketid] ? $scope.attendeeAnswers[''+ticketid]['qty_'+qtyindex][id] ['value'] : '';
                	}
                	else
                		return "";
                  }
                };
                /* for collecting Temp data buyer and attendee start */
           /* $scope.getSubQuestions = function(mainQuestion){
            	angular.forEach(mainQuestion.options,function(eachOption,index){
            		if(eachOption.sub_questions){
            			angular.forEach(eachOption.sub_questions,function(subqns,keyval){
            				if(!($scope.subQuestionsArray.indexOf(subqns.id)>-1))
            					$scope.subQuestionsArray.push(subqns.id);
            			});
            		}
            	});
            };*/
            var buyer_info = {};
            var attendee_info = {};
            $rootScope.getDetails = function() {
            	buyer_info = {};
                attendee_info = {};
                //collect buyer_info
                angular.forEach($scope.profileQuestions.buyer_questions, function(item, index) {
                    switch (item.type) {
                        case 'text':
                            buyer_info[item.id] = {
                                value: item.response
                            }
                            break;
                        case 'textarea':
                            buyer_info[item.id] = {
                                value: item.response
                            }
                            break;
                        case 'radio':
                            buyer_info[item.id] = {
                                value: item.response
                            }
                            angular.forEach(item.options, function(eachVal, index) {
                                if(eachVal.sub_questions && eachVal.value==item.response){
                                	angular.forEach(eachVal.sub_questions,function(eachquestion,ind){
                                		if(eachquestion.type=='checkbox'){
                                			 var value = [];
                                             angular.forEach(Object.keys(eachquestion.response), function(el, index) {
                                                 if (eachquestion.response[el])
                                                     value.push(el);
                                             });
                                             if (value.length > 0)
                                                 buyer_info[eachquestion.id] = {
                                                     value: value
                                                 };
                                             else buyer_info[eachquestion.id] = {};
                                		}else
                                		buyer_info[eachquestion.id] = {value : eachquestion.response};
                                	});
                                }
                            });
                            break;
                        case 'checkbox':
                            var value = [];
                            angular.forEach(Object.keys(item.response), function(el, index) {
                                if (item.response[el])
                                    value.push(el);
                            });
                            if (value.length > 0)
                                buyer_info[item.id] = {
                                    value: value
                                };
                            else buyer_info[item.id] = {};
                            angular.forEach(item.options, function(eachVal, index) {
                            	if(eachVal.sub_questions && item.response.hasOwnProperty(eachVal.value)==item.response[eachVal.value]){
                            		angular.forEach(eachVal.sub_questions,function(eachquestion,ind){
                                 		if(eachquestion.type=='checkbox'){
                                 			 var value = [];
                                              angular.forEach(Object.keys(eachquestion.response), function(el, index) {
                                                  if (eachquestion.response[el])
                                                      value.push(el);
                                              });
                                              if (value.length > 0)
                                                  buyer_info[eachquestion.id] = {
                                                      value: value
                                                  };
                                              else buyer_info[eachquestion.id] = {};
                                 		}else
                                 		buyer_info[eachquestion.id] = {value : eachquestion.response};
                                 	});
                            	}
                            });
                            break;
                        case 'select':
                            buyer_info[item.id] = {
                                value: item.response
                            }
                            angular.forEach(item.options, function(eachVal, index) {
                                if(eachVal.sub_questions && eachVal.value==item.response){
                                	angular.forEach(eachVal.sub_questions,function(eachquestion,ind){
                                		if(eachquestion.type=='checkbox'){
                                			 var value = [];
                                             angular.forEach(Object.keys(eachquestion.response), function(el, index) {
                                                 if (eachquestion.response[el])
                                                     value.push(el);
                                             });
                                             if (value.length > 0)
                                                 buyer_info[eachquestion.id] = {
                                                     value: value
                                                 };
                                             else buyer_info[eachquestion.id] = {};
                                		}else
                                		buyer_info[eachquestion.id] = {value : eachquestion.response};
                                	});
                                }
                            });
                            break;
                    }
                });
                $rootScope.buyerAnswers=buyer_info;
                //console.log('buyer_info - '+JSON.stringify(buyer_info))

                //collect attendee_info
                angular.forEach($scope.profileQuestions.attendee_questions, function(ticket, index) {
                    var ticket_id = ticket.ticket_id;
                    attendee_info[ticket_id] = {
                        qty: ticket.profiles.length
                    };
                    angular.forEach(ticket.profiles, function(profile, index) {
                        (attendee_info[ticket_id])['qty_' + (index + 1)] = {};
                        var profileobj = (attendee_info[ticket_id])['qty_' + (index + 1)];
                        angular.forEach(profile.response, function(value, key) {
                            var val = [];
                            if (angular.isObject(value)) {
                                angular.forEach(value, function(v, k) {
                                    if (value[k])
                                        val.push(k);
                                });
                                if (val.length > 0)
                                    profileobj[key] = {
                                        value: val
                                    };
                                else profileobj[key] = {};
                            } else
                                profileobj[key] = {
                                    value: value
                                };
                        });
                    });
                });
                $rootScope.attendeeAnswers=attendee_info;
                //console.log('attndeee_info - '+JSON.stringify(attendee_info))

            };
            
            
            $scope.promotionsChange = function(data){
            	$scope.promotions = data;
            };
            
            $scope.sub = function(){
            	$scope.loadingSubmit = true;
            	$http.get($rootScope.baseURL + 'profileTicketStatus.jsp',{
            		params:{
            			api_Key: '123',
            			eventid : $rootScope.eid,
            			event_date : $rootScope.selectDate,
            			transaction_id: $rootScope.transactionId,
            			selected_tickets:$rootScope.eventDetailsList.selected_tickets,
            			seating_enabled: $rootScope.isSeatingEvent == true ? 'y' : 'n',
            			seatSectionId:$rootScope.eventDetailsList.seatSectionId
            		}
            	})
            	.success(function(data, status, headers, config){
            		if(data.status == 'success')
            			$scope.submitProfile();
            		else if(data.status == 'fail' && data.reason == 'noSeat'){
            			$scope.loadingSubmit = false;
            			alert('Selected seat not available. Please try again.');
            		}else{
            			$scope.loadingSubmit = false;
            			alert('Unknown error occured. Please try again.');
            		}
            	})
            	.error(function(data, status, headers, config) {
            		$scope.loadingSubmit = false;
                    alert('Unknown error occured. Please try again.');
                });
            };
            
            //final submit
            $scope.submitProfile = function() {
               // $scope.loadingSubmit = true;
                $rootScope.getDetails();
                $http.get($rootScope.baseURL + 'submitProfileInfo.jsp', {
                        params: {
                            api_Key: '123',
                            event_id: $rootScope.eid,
                            event_date: $rootScope.selectDate,
                            seating_enabled: $rootScope.isSeatingEvent == true ? 'y' : 'n',
                            transaction_id: $rootScope.transactionId,
                            buyer_info: JSON.stringify(buyer_info),
                            attendee_info: JSON.stringify(attendee_info),
                            enablepromotion: $scope.promotions == true ? 'yes' : 'no'
                        }
                    })
                    .success(function(data, status, headers, config) {
                        $scope.loadingSubmit = false;
                        if (data.status == 'success')
                            $location.path('/payment');
                        else
                            alert('Unknown error occured. Please try again.');
                    })
                    .error(function(data, status, headers, config) {
                        alert('Unknown error occured. Please try again.');
                    });
            };

            $scope.atleastOneTrue = function(response) {
                var result = false;
                angular.forEach(response, function(value, key) {
                    result = result || value;
                });
                return result;
            };

            // below code we r not using now 26-05-2016 
            //for copy buyer or attendee info TO attendee fields  : select box : code start (select box html code in tktwidget.war-profile.html)
            $scope.allProfiles = function() {
                var allProfiles = [];

                allProfiles.push({
                    ticketid: '',
                    profileid: 'Buyer Information',
                    copyFrom: 'buyerinfo'
                });

                angular.forEach($scope.profileQuestions.attendee_questions, function(item, index) {
                    for (var i = 0; i < item.profiles.length; i++)
                        allProfiles.push({
                            ticketname: item.ticket_name,
                            ticketid: item.ticket_id,
                            profileid: 'Profile #' + (i + 1),
                            response: item.profiles[i].response
                        });
                });
                return allProfiles;
            };
            $scope.copyResponse = function(from, to, toquestions) {

                if (from.copyFrom == 'buyerinfo') {
                    angular.forEach($scope.profileQuestions.buyer_questions, function(item, index) {
                        if ($filter('filter')(toquestions, {
                                id: item.id
                            }).length > 0)
                            to.response[item.id] = angular.copy(item.response);
                    });
                    return;
                }

                var fromquestions = $filter('filter')($scope.profileQuestions.attendee_questions, {
                    ticket_id: from.ticketid
                })[0].questions;

                angular.forEach(from.response, function(value, key) {
                    if ($filter('filter')(toquestions, {
                            id: key
                        }).length > 0)
                        to.response[key] = angular.copy(from.response[key]);
                });

                if (fromquestions.length != Object.keys(from.response).length)
                    angular.forEach(fromquestions, function(item, index) {
                        if (!(from.response).hasOwnProperty(item.id))
                            to.response[item.id] = undefined;
                    });
            };
          //for copy buyer info code select box code end
        
    	}
    ]);