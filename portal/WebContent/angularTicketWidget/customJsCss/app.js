// DEFINE OUR APP AND INJECT DEPENDENCIES
angular.module('ticketsapp', [
    'ngRoute',
    'ngAnimate',
    'ngSanitize',
    'ticketsapp.controllers.tickets',
    'ticketsapp.controllers.profile',
    'ticketsapp.controllers.payment',
    'ticketsapp.controllers.confirmation',
    'ticketsapp.filters',
    'ticketsapp.services'
])

// GLOBAL CONFIGURATIONS
.config(['$routeProvider', '$locationProvider', '$sceDelegateProvider', '$provide',

    function($routeProvider, $locationProvider, $sceDelegateProvider, $provide) {

        $provide.decorator('$sniffer', ['$delegate', function($delegate) {
            $delegate.history = false;
            return $delegate;
        }]);

        $sceDelegateProvider.resourceUrlWhitelist([
            'self',
            '**'
        ]);

        //enable html5 mode
        $locationProvider.html5Mode(false);

        $routeProvider
            .when('/tickets', {
                templateUrl: '/angularTicketWidget/tickets.html',
                controller: 'tickets',
                reloadOnSearch: false
            })
            .when('/profile', {
                templateUrl: '/angularTicketWidget/profile.html',
                controller: 'profile',
                reloadOnSearch: false
            })
            .when('/payment', {
                templateUrl: '/angularTicketWidget/payment.html',
                controller: 'payment',
                reloadOnSearch: false
            })
            .when('/event/confirmation', {
                templateUrl: '/angularTicketWidget/confirmation.html',
                controller: 'confirmation',
                reloadOnSearch: false
            })
            .otherwise({
                redirectTo: '/tickets'
            });
    }
])


// ROOT SCOPE
.run(['$rootScope', '$location', '$window', '$document', '$http',
    function($rootScope, $location, $window, $document, $http) {
        $rootScope.back = function() {
        	
            if ($rootScope.pageLocation == 'Profiles') {
            	 $rootScope.getDetails();
                $location.path('/event');
            } else if ($rootScope.pageLocation == 'Payments') {
                //$location.search('tid',$rootScope.transactionId);
                $location.path('/profile/');
            } else if ($rootScope.pageLocation == 'Confirmation')
                $location.path('/payment/');
            else
                $location.path('/tickets');
        };

       
        $rootScope.baseUrl = 'http://localhost/tktwidget/registration/';
        $rootScope.serverAddress = 'http://localhost/';
        //$rootScope.eid = $location.search().eid;
        $rootScope.eid = eventid;
        $rootScope.fbUserData = {};
        $rootScope.transactionDetails = {};
        $rootScope.transactionId = '';
        /*  $rootScope.totalMinutes = 100;
          $rootScope.timeRemaining = 100;
          $rootScope.millis = (+new Date) + ($rootScope.totalMinutes * 60 * 1000);*/
        $rootScope.showTimeoutBar = false;
        $rootScope.isSeatingEvent = false;
        $rootScope.selectDate = '';
        $rootScope.templateMsg = '';
        $rootScope.timeWatcher;
        $rootScope.context = $location.search().context;
        $rootScope.pageLocation = 'Tickets';
        $rootScope.backLinkWording = 'Back To Tickets Page';
        $rootScope.fromPage = 'tickets';
        $rootScope.secondsRemaining = 00;
        $rootScope.globalTimer;
        $rootScope.timeOutBg = false;
        $rootScope.menuTitles = false;
        $rootScope.ticketsCost = '';
        $rootScope.currencyLbl = '';
        $rootScope.buyerAnswers;
        $rootScope.attendeeAnswers;
        $rootScope.ticketsAuthentication = false;
		$rootScope.pritoken ='';
		$rootScope.priorityType='';
		$rootScope.listid= '';
		$rootScope.ifPri = false;
        /*var sectime=$interval(function() {
            $rootScope.secondsRemaining = $rootScope.secondsRemaining - 1;
            if($rootScope.secondsRemaining<=0)
            	$rootScope.secondsRemaining=60;
        },1000);*/

        $rootScope.tryAgain = function() {
            $http.get($rootScope.serverAddress + 'embedded_reg/seating/delete_temp_locked_tickets.jsp', {
                params: {
                    eid: $rootScope.eid,
                    tid: $rootScope.transactionId
                }
            }).success(function(data, status, headers, config) {
                $window.location.href = $rootScope.serverAddress + 'event?eid=' + $rootScope.eid;
                $rootScope.timeOutBg = false;
            });
        };


        $rootScope.cancelTimeOut = function() {
            $window.location.href = $rootScope.serverAddress + 'event?eid=' + $rootScope.eid;
            $rootScope.timeOutBg = false;
        };


        /*if($rootScope.context!='FBApp'){
        $http.get($rootScope.baseUrl + 'getThemesJSON.jsp', {
            params: {
                eid: $rootScope.eid,
            }
        }).success(function(data, status, headers, config) {
           var css = document.createElement('style');
           css.type = 'text/css';
           var styles='';
           if(data.csstype=='htmlcss'){
        	   styles=data.css;
           }else{
           var bgtype='image';
           if(data.bg_type=='color')
        	   bgtype='color';
           		
           		if(bgtype=='color')
               styles = '.leftboxcontent{margin:'+data.boxmargin+';padding: '+data.boxpadding+';background-color: '+data.color+';}';
           		else
           	   styles = '.leftboxcontent{margin:'+data.boxmargin+';padding: '+data.boxpadding+';background: url("'+data.bgimageurl+'") repeat scroll 0 0 rgba(0, 0, 0, 0);}';
           	   styles += '.bodytextstyle{font: '+data.bodytextfontsize+' '+data.bodytextfonttype+';color: '+data.bodytextcolor+';}';
           	   styles += '.bodyheaders{color: '+data.bodytextcolor+';}';
           	   styles += '.small{color:'+data.smalltextcolor+';font-family:'+data.smalltextfonttype+';font-size:'+data.smalltextfontsize+';font-weight: lighter;}';
           }
           
           if (css.styleSheet) css.styleSheet.cssText = styles;
           else css.appendChild(document.createTextNode(styles));

           document.getElementsByTagName("head")[0].appendChild(css);
        }).error(function(data, status, headers, config) {
           
        });
        }*/
        // Facebook login
        window.fbAsyncInit = function() {
            FB.init({
                appId: '504743746255078',
                channelUrl: 'app/channel.html',
                status: true,
                cookie: true,
                xfbml: true
            });
        };

        (function(d) {
            var js,
                id = 'facebook-jssdk',
                ref = d.getElementsByTagName('script')[0];
            if (d.getElementById(id))
                return;
            js = d.createElement('script');
            js.id = id;
            js.async = true;
            js.src = "//connect.facebook.net/en_US/all.js";
            ref.parentNode.insertBefore(js, ref);
        }(document));

    }
]);