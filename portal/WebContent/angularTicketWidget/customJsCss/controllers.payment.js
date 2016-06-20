angular.module('ticketsapp.controllers.payment', [])
    .controller('payment', ['$scope', '$location', '$rootScope', '$http', '$timeout', '$interval', '$window',
        function($scope, $location, $rootScope, $http, $timeout, $interval,  $window) {
            if ($rootScope.eid) $rootScope.eid = $rootScope.eid;
            else $location.url('/event');
            $rootScope.css2 = 'active';
            $rootScope.css3 = "";
            $rootScope.css4 = "";
            if ($rootScope.transactionId) $rootScope.transactionId = $rootScope.transactionId;
            else $location.url('/event');

            $rootScope.showTimeoutBar = false;
            // $rootScope.totalMinutes = 15;
            $scope.paymentsData = {};
            $scope.loadingPayment = true;
            $scope.scheme = 'http';
            $scope.otherDisable = false;
            $scope.paypalDisable = false;
            $scope.ebeeDisable = false;
            $scope.sslserveraddress = '';
            $rootScope.pageLocation = 'Payments';
            $rootScope.backLinkWording = 'Back To Profile';
            $rootScope.fromPage = 'payments';
            /* $rootScope.millis = (+new Date) + ($rootScope.totalMinutes * 60 * 1000);
             $rootScope.timeRemaining = $rootScope.totalMinutes * 60000;*/
            
            
            try {
                $rootScope.timeWatcher();
            } catch (err) {}

            $rootScope.globalTimer = $interval(function() {
                $rootScope.timeRemaining = $rootScope.millis - (+new Date);
            }, 500);
            
            /* Summary start */
            $scope.summarydetails=false;
            $scope.abc=false;
            $scope.xyz=true;
            $scope.showSummary = function(){
            	$scope.abc=!$scope.abc;
            	$scope.xyz=!$scope.xyz;
            	$scope.summarydetails=!$scope.summarydetails;
            	if($scope.summarydetails)
            		$('#summarydetails').slideDown();
            	else
            		$('#summarydetails').slideUp();
            };
            /* Summary end */
            
            /*if(fbavailable){
			FB.getLoginStatus(function(response){
				if(response.authResponse){
					fbuid=response.authResponse.userID;
				}
			});
			}*/
            $scope.fbuid='';
            
            $http.get($rootScope.baseURL + 'getPaymentsJSON.jsp', {
                params: {
                    api_Key : '123',
                    event_id : $rootScope.eid,
                    transaction_id : $rootScope.transactionId,
                    regtype : $rootScope.eventDetailsList.registrationsource,
                    ntsenable : $rootScope.eventDetailsList.nts_enable,
                    referral_ntscode : $rootScope.eventDetailsList.referral_ntscode,
                    fbuid : $scope.fbuid
                }
            }).success(function(data, status, headers, config) {
                if (data.status == 'success') {
                    $scope.paymentsData = data;
                    if($scope.paymentsData.payment_details.length==3)$scope.arrow_side=true;
                    if($scope.paymentsData.payment_details.length==5)$scope.arrow_side1=true;
                    $scope.scheme = data.scheme;
                    $rootScope.totalMinutes = Number(data.timediffrence);
                    $rootScope.secondsRemaining = Number(data.secdiffrence);
                    //    $rootScope.totalMinutes = 0;
                    //  $rootScope.secondsRemaining = 25;
                    $rootScope.millis = (+new Date) + ($rootScope.totalMinutes * 60 * 1000) + ($rootScope.secondsRemaining * 1000);
                    $rootScope.timeRemaining = $rootScope.totalMinutes * 60000 + ($rootScope.secondsRemaining * 1000);
                    $scope.sslserveraddress = data.sslserveraddress;
                    $scope.loadingPayment = false;
                    $rootScope.showTimeoutBar = true;
                    $rootScope.backLinkWording = data.backbutton;
                    $scope.paymentsData.currency_format = data.currency_format;
                    $rootScope.timeWatcher = $rootScope.$watch('timeRemaining', function(newVal, oldVal) {
                        if (newVal < 0) {
                            $interval.cancel($rootScope.globalTimer);
                            $rootScope.timeWatcher();
                            $rootScope.timeOutBg = true;
                            // $window.location.href=$rootScope.serverAddress+'tktwidget/public/#/event?eid='+$rootScope.eid;
                        }
                    });
                } else {
                    //alert('Unknown error occured. Please try refreshing the page');
                    $location.url('/event');
                }
            }).error(function(data, status, headers, config) {
                $scope.loadingTransaction = false;
                //alert('Unknown error occured. Please try refreshing the page');
                $location.url('/event');
            });

            $scope.other = function(evt,data) {
                evt.target.blur();
                /*$dialogs.confirm('Please Confirm', 'Are you sure you want to continue?')
                .result
                .then(function(btn) {
                    $timeout(function() {
                        //$location.path('/event/confirmation');
                        $scope.otherDisable = true;
                        $scope.NoPaymentOrOther('other');

                    }, 200);
                }, function(btn) {});*/
                bootbox.dialog({
                	  message: data,
                	  title: "Please Confirm",
                	  buttons: {
                	    success: {
                	      label: "Continue",
                	      className: "btn-primary btn-sm",
                	      callback: function() {
                	    	  $timeout(function() {
                                  //$location.path('/event/confirmation');
                                  $scope.otherDisable = true;
                                  $scope.NoPaymentOrOther('other');

                              }, 200);
                	      }
                	    },
                	    danger: {
                	      label: "Cancel",
                	      className: "btn-primary btn-sm",
                	      callback: function() {
                	        //Example.show("uh oh, look out!");
                	    	//alert('canceld');
                	      }
                	    }
                	  }
                	});
                
            };

            $scope.cancel_order = function(){
            	bootbox.dialog({
              	  message: "Are you sure you want to cancel your order?",
              	  title: "",
              	  //size:"small",
              	  buttons: {
              	    success: {
              	      label: "Ok",
              	      className: "btn-primary btn-sm",
              	      callback: function() {
              	    	$http.get($rootScope.baseURL + 'delete_temp_locked_tickets.jsp', {
                            params: {
                                eid: $rootScope.eid,
                                tid: $rootScope.transactionId,
                                seating:$rootScope.isSeatingEvent == true ? 'y' : 'n'
                            }
                        }).success(function(data, status, headers, config) {
                        	try {
                        		if('EB' == $rootScope.eventDetailsList.context)
                            		$window.location.href = $rootScope.serverAddress + 'event?eid=' + $rootScope.eid;
                            	else if('web' == $rootScope.eventDetailsList.context)
                            		location.reload();
                        	}
                        	catch(err) { location.reload(); };
                           
                            $rootScope.timeOutBg = false;
                        }); 
              	      }
              	    },
              	    danger: {
              	      label: "Cancel",
              	      className: "btn-primary btn-sm",
              	      callback: function() {
              	        //Example.show("uh oh, look out!");
              	    	//alert('canceld');
              	      }
              	    }
              	  }
              	});
            };
            
            $scope.NoPaymentOrOther = function(paymenttype) {
                //alert("in no payment");
                $http.get($rootScope.serverAddress + 'embedded_reg/checkavailability.jsp?timestamp=' + (new Date()).getTime(), {
                    params: {
                        eid: $rootScope.eid,
                        paytype: paymenttype,
                        tid: $rootScope.transactionId,
                        scheme: $scope.scheme
                    }

                }).success(function(data, status, headers, config) {
                    $scope.PrcocesRegResponse(data);
                }).error(function(data, status, headers, config) {
                    alert("Tickets you have selected are currently not available");
                    $scope.otherDisable = false;
                });
            };

            $scope.PrcocesRegResponse = function(response) {
                var statusJson = response;
                var status = statusJson.status;
                if (status == 'Success') {
                    $scope.getConfirmation($rootScope.transactionId, $rootScope.eid);
                } else if (status == 'Fail' && statusJson.paymenttype == 'ebeecredits') {
                    //FillebeecreditDetails(statusJson.fbuserid);
                } else if (status == 'Fail' && statusJson.exceeded == 'true') {
                    //alert(statusJson.msg);
                    //hideimage_showpaysection();
                    //clickcount=0;
                } else
                    alert(statusJson.msg);
            };


            $scope.zero = function() {
                $scope.NoPaymentOrOther('nopayment');
            };

            $scope.isTotalZero = function() {
                if (!$scope.paymentsData.payment_details) return false;
                var value = $scope.paymentsData.payment_details[$scope.paymentsData.payment_details.length - 1].value;
                return !(parseFloat(value) > 0);
            };



            $scope.paypalPayment = function() {
                if (document.getElementById("backgroundPopup"))
                    document.getElementById("backgroundPopup").style.display = "block";
                $scope.addTabIndex();
                $scope.windowOpener();
            };



            var gPopupIsShown = false;
            var popupWin = "";
            var modelwin;
            var val = '';
            var paymentmode = '';

            $scope.windowOpener = function() {
                val = '';
                popupWin = "";
                paymentmode = $scope.paymentsData.paymentmode;
                $scope.paypalDisable = true;

                if (typeof(popupWin) != "object") {
                    popupWin = $window.open($scope.sslserveraddress + '/embedded_reg/checkavailability.jsp?tid=' + $rootScope.transactionId + '&eid=' + $rootScope.eid + '&paytype=' + paymentmode + '&scheme=' + $scope.scheme, 'Payment_' + $rootScope.transactionId, 'WIDTH=975,HEIGHT=600,RESIZABLE=No,SCROLLBARS=YES,TOOLBAR=NO,LEFT=150,TOP=100');
                    if (popupWin && popupWin.top) {} else {
                        alert("Pop-up blocker seem to have been enabled in your browser.\nFor completing registration, please change your Pop-up settings.");
                        if (document.getElementById("backgroundPopup"))
                            document.getElementById("backgroundPopup").style.display = "none";
                        $scope.removeTabIndex();
                        $scope.paypalDisable = false;
                        return;
                    }

                    val = 'register';
                    $scope.closeIt();
                } else {
                    if (!popupWin.closed) {
                        popupWin.location.href = url;
                    } else {
                        popupWin = $window.open($scope.sslserveraddress + '/embedded_reg/checkavailability.jsp?tid=' + $rootScope.transactionId + '&eid=' + $rootScope.eid + '&paytype=' + paymentmode + '&scheme=' + $scope.scheme, 'Payment_' + $rootScope.transactionId, 'WIDTH=975,HEIGHT=600,RESIZABLE=No,SCROLLBARS=YES,TOOLBAR=NO,LEFT=150,TOP=100');
                        $scope.closeIt();
                    }
                }
                popupWin.focus();
            };


            $scope.closeIt = function() {
                if (!popupWin.closed) {
                    var timeforpopup = $timeout(function() {
                        $scope.closeIt();
                    }, 1);

                    try {} catch (err) {}
                } else {
                    $scope.paypalDisable = false;
                    if (document.getElementById("backgroundPopup"))
                        document.getElementById("backgroundPopup").style.display = "none";
                    $scope.removeTabIndex();
                    if (paymentmode == 'paypalx')
                        $scope.getPaypalxStatus();
                    else {
                        $scope.paypalDisable = true;
                        $scope.getStatus();
                    }
                }
            };


            $scope.getPaypalxStatus = function() {
                $http.get($rootScope.serverAddress + 'embedded_reg/papalxstatus.jsp?timestamp=' + (new Date()).getTime(), {
                    params: {
                        eid: $rootScope.eid,
                        tid: $rootScope.transactionId
                    }
                }).success(function(data, status, headers, config) {
                    /*if(data.status=='Completed')
                    	$scope.getConfirmation(tid,eid);*/
                    $scope.PrcocesPaypalxResponse(data);

                }).error(function(data, status, headers, config) {
                    $scope.loadingTransaction = false;
                    alert('Unknown error occured. Please try refreshing the page');
                });

            };

            $scope.PrcocesPaypalxResponse = function(response) {
                /*data=response.responseText;
                var statusJson=eval('('+data+')');*/
                var statusJson = response;
                var status = statusJson.status;
                //setNewTransactionId(statusJson.tid);
                var tid = statusJson.tid;
                if (status == 'Completed') {
                    $scope.paypalDisable = true;
                    $scope.getConfirmation(tid, $rootScope.eid);
                    $scope.paypalDisable = false;
                } else if (status == 'INCOMPLETE' || status == 'PROCESSING' || status == 'EXPIRED') {
                    /*if(document.getElementById('imageLoad'))
                    document.getElementById('imageLoad').style.display='none';
                    document.getElementById('profile').style.display='none';
                    if(document.getElementById('profile'))
                    	document.getElementById('paymentsection').style.display='none';
                    if(document.getElementById('pageheader')){
                    	document.getElementById('pageheader').style.display='none';
                    }
                    document.getElementById('registration').style.display='block';
                    document.getElementById('registration').innerHTML=statusJson.msg;	*/
                } else if (status == 'CREATED' || status == 'INVALID') {
                    /*clickcount=0;
                    Element.hide('imageLoad');
                    loaded = true;
                    document.getElementById('paymentsection').style.display='block';*/
                } else {
                    /*clickcount=0;
                    Element.hide('imageLoad');
                    loaded = true;
                    document.getElementById('paymentsection').style.display='block';*/
                }
            };


            $scope.getStatus = function() {
                $http.get($rootScope.serverAddress + '/embedded_reg/checkstatus.jsp?timestamp=' + (new Date()).getTime(), {
                    params: {
                        tid: $rootScope.transactionId
                    }
                }).success(function(data, status, headers, config) {
                    //alert("success");
                    $scope.PrcocesgetStatusResponse(data);
                    /*if(data.status=='Completed')
                     	$scope.getConfirmation($rootScope.transactionId,$rootScope.eid);*/
                }).error(function(data, status, headers, config) {
                    $scope.ebeeDisable = false;
                    $scope.paypalDisable = false;
                    //failureJsonResponse();
                });
            };



            $scope.PrcocesgetStatusResponse = function(response) {
                //data=response.responseText;
                var statusJson = response;
                var status = statusJson.status;
                var hstatus = statusJson.hstatus;
                //   	setNewTransactionId(statusJson.tid);
                var tid = statusJson.tid;
                $rootScope.transactionId = tid;

                if (status == 'Completed') {
                    $scope.getConfirmation(tid, $rootScope.eid);
                } else if (status == 'Processing') {
                    //for google transaction
                    $scope.getConfirmation(tid, $rootScope.eid);
                } else if (status == 'waiting') {
                    //paypal not yet completed payment
                    $scope.getConfirmation(tid, $rootScope.eid);
                } else if (status == 'ccfatalerror') {
                    //Eventbee CC Fatal Error
                    refreshPage();
                } else if (paymentmode == 'paypal') {
                    //clickcount=0;
                    //hideimage_showpaysection();
                    //showContinueOptions(tid,eid);
                    $scope.ebeeDisable = false;
                    $scope.paypalDisable = false;
                } else if (hstatus == 'TimeOut') {
                    refreshPage();
                } else if (hstatus == 'Exceeded') {
                    refreshPage();
                } else {
                    //hideimage_showpaysection();
                    //clickcount=0;
                    $scope.ebeeDisable = false;
                    $scope.paypalDisable = false;
                }
            };

            $scope.addTabIndex = function() {
                $('button').each(function() {
                    $(this).attr('tabindex', '-1');
                });
                $('a.ng-binding').attr('tabindex', '-1');
            };

            $scope.removeTabIndex = function() {
                $('button').each(function() {
                    $(this).removeAttr('tabindex');
                });
                $('a.ng-binding').removeAttr('tabindex');
            };

            $scope.getConfirmation = function() {
                if (document.getElementById("backgroundPopup"))
                    document.getElementById("backgroundPopup").style.display = 'none';
                $scope.removeTabIndex();
                var eventdate = '';
                var seating_enabled_tkt_wedget = $scope.paymentsData.seatingenabled;
                var venueid = $scope.paymentsData.venueid;
                $http.get($rootScope.serverAddress + 'embedded_reg/done.jsp?timestamp=' + (new Date()).getTime(), {
                    params: {
                        eid: $rootScope.eid,
                        tid: $rootScope.transactionId,
                        eventdate: eventdate,
                        seatingenabled: seating_enabled_tkt_wedget,
                        venueid: venueid
                    }
                }).success(function(data, status, headers, config) {
                    $rootScope.timeOutBg = false;
                    $rootScope.templateMsg = data;
                    $location.path('/event/confirmation');
                }).error(function(data, status, headers, config) {
                    $scope.loadingTransaction = false;
                    $scope.ebeeDisable = false;
                    $scope.paypalDisable = false;
                    alert('Unknown error occured. Please try refreshing the page');
                });
            };

            // Eventbee CC Code Starts from here....

            $scope.eventbeeCC = function() {
                $scope.ebeeDisable = true;
                if (document.getElementById("backgroundPopup"))
                    document.getElementById("backgroundPopup").style.display = "block";
                $scope.addTabIndex();
                var ifurl = $scope.sslserveraddress + '/embedded_reg/checkavailability.jsp?tid=' + $rootScope.transactionId + '&eid=' + $rootScope.eid + '&paytype=CC&scheme=' + $scope.scheme;
                var htmldata = "<img src='/home/images/images/close.png' id='ebeecreditsclose' class='imgclose'  ><div id='paymentscreenload' ><center><table><tr><td height='100px'><img src='/home/images/ajax-loader.gif'></td></tr></table></center></div>";
                htmldata += "<iframe src='" + ifurl + "&resizeIFrame=true' id='cciframe'  scrolling='no'  style='width:550px;height:538px;display:none' frameborder='no' onload='showscreen()'></iframe>";

                document.getElementById('attendeeloginpopup').innerHTML = htmldata;
                if (document.getElementById("backgroundPopup"))
                    document.getElementById("backgroundPopup").style.display = "block";
                $window.scrollTo(0, 0);
                document.getElementById('ebeecreditsclose').style.marginTop = '-15px';
                document.getElementById('ebeecreditsclose').style.marginRight = '-16px';
                document.getElementById('ebeecreditsclose').style.cursor = 'pointer';
                document.getElementById('attendeeloginpopup').style.width = 'auto';
                document.getElementById('attendeeloginpopup').style.minWidth = '550px';
                document.getElementById('attendeeloginpopup').style.height = 'auto';
                document.getElementById('attendeeloginpopup').style.top = '10%';
                document.getElementById('attendeeloginpopup').style.left = '15%';
                document.getElementById('attendeeloginpopup').style.padding = 0;
                document.getElementById('ebeecreditsclose').onclick = ccscreenclose;
                document.getElementById('attendeeloginpopup').style.backgroundColor = '#FFFFFF';
                document.getElementById('attendeeloginpopup').style.display = "block";
            };

            window.showscreen = function() {
                if (document.getElementById("paymentscreenload"))
                    document.getElementById("paymentscreenload").style.display = "none";
                if (document.getElementById("cciframe"))
                    document.getElementById("cciframe").style.display = "block";
            };

            window.ccscreenclose = function() {
                //alert("in cc close method::");
                $scope.ebeeDisable = false;
                document.getElementById('attendeeloginpopup').removeAttribute("style");
                document.getElementById('attendeeloginpopup').innerHTML = '';
                document.getElementById('attendeeloginpopup').style.display = "none";
                document.getElementById("backgroundPopup").style.display = "none";
                $scope.removeTabIndex();
                $scope.getStatus();
            };

            // Eventbee CC code ends here....

            var refreshPage = function() {
                //alert("in clickeing refresh pages:::");
                $rootScope.timeOutBg = false;
                window.location.href = $rootScope.serverAddress + 'tktwidget/public/#/event?eid=' + $rootScope.eid;
                //$location.url('/event?eid=' + $rootScope.eid);
            };
        }
    ]);