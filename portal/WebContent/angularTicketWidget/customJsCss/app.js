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

        // this is using..
        $rootScope.baseURL = 'http://localhost/ticketwidget/';
        
       // $rootScope.base_Url = 'http://localhost/tktwidget/registration/';
        $rootScope.serverAddress = 'http://localhost/';
        //$rootScope.eid = $location.search().eid;
        $rootScope.eid = eventid;
        $rootScope.waitListId = waitlistId;
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
        //$rootScope.context = $location.search().context;
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
		$rootScope.eventDetailsList = eventDetailsList;
		$rootScope.facebookNTSdetails='';
		//console.log($rootScope.eventDetailsList);
        /*var sectime=$interval(function() {
            $rootScope.secondsRemaining = $rootScope.secondsRemaining - 1;
            if($rootScope.secondsRemaining<=0)
            	$rootScope.secondsRemaining=60;
        },1000);*/

        $rootScope.tryAgain = function() {
            $http.get($rootScope.baseURL + 'delete_temp_locked_tickets.jsp', {
                params: {
                    eid: $rootScope.eid,
                    tid: $rootScope.transactionId,
                    seating:$rootScope.isSeatingEvent == true ? 'y' : 'n'
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


        // Facebook login
        /*  window.fbAsyncInit = function() {
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
        }(document)); */

    }
]);