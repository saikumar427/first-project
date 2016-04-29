angular.module('ticketsapp.controllers.profile', [])
	.controller('profile', ['$rootScope', '$scope', '$http', '$timeout', '$filter', '$location', '$interval', '$window',
        function($rootScope, $scope, $http, $timeout, $filter, $location, $interval, $window) {
		if($rootScope.transactionId==''){
        	$location.url('/tickets');
        }
    	 	try{
            $rootScope.timeWatcher();
            }catch(err){
            }
            $rootScope.css = 'active';$rootScope.css1 = 'active';$rootScope.css2 ="";$rootScope.css3 ="";$rootScope.css4 ="";
            
            $rootScope.$on('eventName', function (event, args) {
            	 $scope.message = args.message;
            	 console.log($scope.message);
            	 });
            
            $rootScope.showTimeoutBar = false;
            $rootScope.globalTimer = $interval(function() {
                $rootScope.timeRemaining = $rootScope.millis - (+new Date);
            }, 500);
            var eleData='';
            $scope.profileData=[];
            $scope.pushTempData= function(ele){
            	if(undefined!=ele){
            		if ($scope.profileData.indexOf(ele) == -1) {
                		$scope.profileData.push(ele);
                		for(var i=0; i<$scope.profileData.length; i++){
                			eleData += "<option value="+'"'+$scope.profileData[i]+'"'+">";
                		}
                		document.getElementById('suggestions').innerHTML=eleData;
                		eleData='';
                	}
            	}
            };
              
            

            if ($rootScope.eid) $rootScope.eid = $rootScope.eid;
            else{
            	$location.url('/tickets');
            }
            	
            /*if ($location.search().tid) $rootScope.transactionId = $location.search().tid;
            else{
            	$location.url('/event?eid=' + $rootScope.eid);
            }*/
            
            $http.get($rootScope.baseUrl + 'getProfileJSON.jsp', {
                params: {
                    api_key: '123',
                    event_id: $rootScope.eid,
                    transaction_id: $rootScope.transactionId
                }
            })
                .success(function(data, status, headers, config) {
                    $scope.profileQuestions = data;
                    $scope.loadingQuestions = false;
                    $rootScope.menuTitles=true;
                    $rootScope.totalMinutes = Number(data.timediffrence);
                    $rootScope.secondsRemaining = Number(data.secdiffrence);
                    $rootScope.timeRemaining = ($rootScope.totalMinutes*60000) + ($rootScope.secondsRemaining*1000);
                    $rootScope.millis = (+new Date) + ($rootScope.totalMinutes * 60 * 1000) + ($rootScope.secondsRemaining*1000);
                    $rootScope.showTimeoutBar = true;
                    $rootScope.backLinkWording = data.backbutton;
                    if(data.enablepromotion=='false' && $scope.fromPage=='payments')
                    	$scope.promotions=false;
                    	
                    $rootScope.timeWatcher = $rootScope.$watch('timeRemaining', function(newVal, oldVal) {
                        if (newVal < 0) {
                            $interval.cancel($rootScope.globalTimer);
                            $rootScope.timeWatcher();
                            $rootScope.timeOutBg = true;
                           // $window.location.href=$rootScope.serverAddress+'tktwidget/public/#/event?eid='+$rootScope.eid;
                        }
                    });
                    
                })
                .error(function(data, status, headers, config) {
                    alert('Unknown error occured. Please try reloading the page.');
                });
            
            $scope.assignEmpty = function(Obj,qid){
            	if(!Obj[qid])
            		Obj[qid]=new Object();
            };
            

            $scope.fblogin = function() {
                var getUserInfo = function(response) {
                    if (response.authResponse) { // in case if we are logged in
                        FB.api('/me', function(response) {
                            $rootScope.fbUserData = response;
                            $scope.$apply(function() {
                                $scope.profileQuestions.buyer_questions[0].response = response.first_name;
                                $scope.profileQuestions.buyer_questions[1].response = response.last_name;
                                $scope.profileQuestions.buyer_questions[2].response = response.email;
                            });
                        });
                    } else {
                        FB.login(function(response) {
                            if (response.authResponse) {
                                //window.location.reload();
                            } else {}
                        }, {
                            scope: 'email'
                        });
                    }
                };
                FB.getLoginStatus(getUserInfo);
                FB.Event.subscribe('auth.statusChange', getUserInfo);
            };

            $scope.sub = function() {

                $scope.loadingSubmit = true;

                var buyer_info = {};
                var attendee_info = {};

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
                            break;
                        case 'select':
                            buyer_info[item.id] = {
                                value: item.response
                            }
                            break;
                    }
                });

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

                //alert("promotion value is::"+$scope.promotions);
                $http.get($rootScope.baseUrl + 'submitProfileInfo.jsp', {
                    params: {
                        api_Key: '123',
                        event_id: $rootScope.eid,
                        event_date: $rootScope.selectDate,
                        seating_enabled: $rootScope.isSeatingEvent==true?'y':'n',
                        transaction_id: $rootScope.transactionId,
                        buyer_info: JSON.stringify(buyer_info),
                        attendee_info: JSON.stringify(attendee_info),
                        enablepromotion : $scope.promotions == true ? 'yes':'no'
                    }
                })
                    .success(function(data, status, headers, config) {
                        $scope.loadingSubmit = false;
                        if (data.status == 'success')
                        //$location.url('/event/payment?eid=' + $rootScope.eid + '&tid=' + $rootScope.transactionId);
                            $location.path('/event/payment');
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

            $scope.allProfiles = function() {
                var allProfiles = [];

                allProfiles.push({
                    ticketid: '',
                    profileid: 'Buyer Information',
                    copyFrom: 'buyerinfo'
                });

                angular.forEach($scope.profileQuestions.attendee_questions, function(item, index) {
                    for (i = 0; i < item.profiles.length; i++)
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

        }
    ]);