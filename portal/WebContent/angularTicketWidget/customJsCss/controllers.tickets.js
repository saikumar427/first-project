angular.module('ticketsapp.controllers.tickets', [])
    .controller('tickets', ['$scope', '$http', '$location', '$timeout', '$rootScope', '$window', '$sce', '$filter', '$interval',
        function($scope, $http, $location, $timeout, $rootScope, $window, $sce, $filter, $interval) {
            $rootScope.showTimeoutBar = false;
            $rootScope.css = 'active';
            $rootScope.css2 = "";
            $rootScope.css3 = "";
            $rootScope.css4 = "";
            $rootScope.css1 = "";
            $scope.seats = {};
            $scope.priorityData;
            $scope.loadSeating = false;
            $scope.allTickets = [];
            $scope.availabelTickets = [];
            $scope.allSectionObj = {};
            $scope.venuePath = '';
            $scope.venueName = '';
            $scope.discountApplied = false;
            $rootScope.backLinkWording = 'Back To Tickets Page';
            $rootScope.totalMinutes = 100;
            $rootScope.timeRemaining = 100;
            $rootScope.millis = (+new Date) + ($rootScope.totalMinutes * 60 * 1000);
            $rootScope.fromPage = 'tickets';
            $scope.eventMetadata = {
                date_select_label: 'Loading dates...'
            };
            $scope.sectionId = '';
            $scope.ticketsData = {
                items: []
            };
            $scope.highVolume;
            $scope.ticketsUnavailable = false;
            $scope.eventMetadata.is_priority = false;
            $scope.loadingMetadata = true;
            $scope.feecolrequeired = 'Y';
            $scope.priorityData = '';
            $scope.prioritykey1 = '';
            $scope.prioritykey2 = '';
            $scope.prioritylist = '';
            $scope.selectedPriority = '';
            $scope.selectLabel1 = '';
            $scope.selectLabel2 = '';
            $scope.no_of_flds = '';
            $scope.selectError = '';
            $scope.tempDate = '';
            $scope.allSeats = '';
            $scope.groupDetails = '';
            $scope.groupTicketSelection = '';

            try {
                $interval.cancel($rootScope.globalTimer);
                $rootScope.timeWatcher();
            } catch (err) {}

            $scope.widthCh = function() {

            };

            /* meta data start */
            if ($rootScope.eid)
                $http.get('http://localhost/ticketwidget/getEventMetaData.jsp?api_key=123&event_id=' + $rootScope.eid)
                .success(function(data, status, headers, config) {
                    $rootScope.showTimeoutBar = false;
                    $scope.eventMetadata = data;
                    $scope.loadingMetadata = false;
                    if ($rootScope.ticketsAuthentication)
                        $scope.eventMetadata.is_priority = false;
                    $scope.venueid = data.venueid;
                    $rootScope.isSeatingEvent = data.has_seating;
                    if (!$scope.eventMetadata.do_continue) {
                        if ($scope.eventMetadata.remaintime)
                            $scope.highVolume($scope.eventMetadata.remaintime);
                        return;
                    }
                    if ($scope.eventMetadata.is_priority && !$scope.eventMetadata.is_recurring) {
                        $scope.eventMetadata.is_priority = true;
                        $scope.getPriorityReg();
                        return;
                    } else if ($scope.eventMetadata.is_priority && $scope.eventMetadata.is_recurring) {
                        $scope.eventMetadata.is_priority = true;
                        $scope.getPriorityReg();
                        $scope.getRecDate();
                        return;
                    } else if ($scope.eventMetadata.is_recurring) {
                        $scope.getRecDate();
                        return;
                    } else
                        $scope.getTicketSection();

                })
                .error(function(data, status, headers, config) {
                    alert('Unknown error occured. Please try reloading the page.');
                });
            else {
                $scope.loadingMetadata = false;
                $scope.eventMetadata.message = 'Event unavailable';
            }
            /* meta data start */

            /*highVolume start*/
            $scope.highVolume = function(min) {
                $timeout(function() {
                    $location.path('/event');
                }, min + '000');
            };
            /*highVolume end*/

            /*Priority registration start*/
            $scope.getPriorityReg = function() {
                $http.get('http://localhost/ticketwidget/PriorityRegBlock.jsp?eid=' + $rootScope.eid)
                    .success(function(data, status, headers, config) {
                        $scope.priorityData = data;
                        if ($scope.priorityData.list_data.length == 1) {
                            $scope.selectLabel1 = $scope.priorityData.list_data[0].label1;
                            $scope.selectLabel2 = $scope.priorityData.list_data[0].label2;
                            $scope.no_of_flds = $scope.priorityData.list_data[0].no_of_flds;
                            $rootScope.listid = $scope.priorityData.list_data[0].list_id;
                        }
                    })
                    .error(function() {
                        alert('Unknown error occured. Please try reloading the page.');
                    });
            };
            $scope.$watch('prioritylist', function(nVal, oVal) {
                if (nVal == null) {
                    $scope.selectLabel1 = '';
                    $scope.selectLabel2 = '';
                }
                if (nVal) {
                    var index = selectIdex.selectedIndex;
                    $scope.selectedPriority = $scope.priorityData.list_data[index - 1];
                    $scope.selectLabel1 = $scope.selectedPriority.label1;
                    $scope.selectLabel2 = $scope.selectedPriority.label2;
                    $scope.no_of_flds = $scope.selectedPriority.no_of_flds;
                    $rootScope.listid = $scope.selectedPriority.list_id;

                }
            });
            $scope.submitPriority = function() {
                $http.get('http://localhost/ticketwidget/PriorityRegFormAction.jsp', {
                        params: {
                            eid: $rootScope.eid,
                            listId: $rootScope.listid,
                            prioritykey1: $scope.prioritykey1,
                            prioritykey2: $scope.prioritykey2,
                            noofflds: $scope.no_of_flds,
                            evtdate: $rootScope.selectDate
                        }
                    })
                    .success(function(data, status, headers, config) {
                        $scope.resultPriorityReg = data;
                        $rootScope.pritoken = $scope.resultPriorityReg.prireg_token;
                        if ($scope.resultPriorityReg.status == 'success') {
                            $rootScope.listid = $scope.resultPriorityReg.pri_list_id;

                            $rootScope.eventDetailsList.priregtoken = $scope.resultPriorityReg.prireg_token;
                            $rootScope.eventDetailsList.prilistid = $scope.resultPriorityReg.pri_list_id;

                            $rootScope.ifPri = true;
                            $rootScope.priorityType = 'Continue';
                            $scope.getTicketSection();
                            $rootScope.ticketsAuthentication = true;
                        }

                    })
                    .error(function(data, status, headers, config) {

                    });
            };
            $scope.skipPriority = function() {
                if ($scope.eventMetadata.is_recurring) {
                    if (!$scope.tempDate) {
                        $scope.selectError = 'Please select date';
                        return;
                    }
                }
                $scope.selectError = '';
                $rootScope.ticketsAuthentication = true;
                $rootScope.priorityType = 'Skip';
                $rootScope.ifPri = true;
                $scope.getTicketSection();
            };


            $scope.priorityTimeCheck = function() {

                if ($scope.resultPriorityReg.prireg_token != '' && $scope.resultPriorityReg.pri_list_id != '' && $scope.resultPriorityReg.limit_type != 'UNLIMIT') {
                    $http.get('http://localhost/ticketwidget/PriorityTimeCheck.jsp?timestamp=' + (new Date()).getTime(), {
                            params: {
                                eid: $rootScope.eid,
                                listId: $scope.resultPriorityReg.pri_list_id,
                                priToken: $scope.resultPriorityReg.prireg_token
                            }
                        })
                        .success(function(data, status, headers, config) {
                            $scope.priTimeCheckData = data;
                            if (!$scope.priTimeCheckData.expired) {
                                $scope.timeCheckShow = props.try_again;
                                return 'false';
                            }
                        })
                        .error(function(data, status, headers, config) {
                            //alert('Unknown error occured. Please try refreshing the page');
                        });
                }
            };
            $scope.close_priTimeCheck = function() {
                $scope.timeCheckShow = '';
                window.location.reload();
            };
            /*Priority registration end*/

            /*rec date start*/
            $scope.getRecDate = function() {
                $scope.$watch('selectedDate.value', function(newVal, oldVal) {
                    $scope.tempDate = newVal;
                    if (newVal == null) {
                        $scope.ticketsData = {
                            items: []
                        };
                    }
                    $scope.seatingdata = {
                        allsections: []
                    };
                    $scope.seats = {};
                    $scope.noofcols = '';
                    $scope.noofrows = '';
                    $scope.backgroundCSS = {};

                    if (newVal) {
                        $rootScope.selectDate = newVal;
                        $rootScope.ticketsAuthentication = true;
                        if (!$scope.eventMetadata.is_priority) {
                            $rootScope.ticketsAuthentication = true;
                            $scope.getTicketSection();
                        }
                    }
                });
                if ($rootScope.selectDate) {
                    $scope.selectedDate = {
                        "name": $rootScope.selectDate,
                        "value": $rootScope.selectDate
                    };
                }
            };
            /*rec date end*/

            /* Ticket data start */
            $scope.getTicketSection = function() {
                $scope.loadingTickets = true;
                $http.get('http://localhost/ticketwidget/getEventTickets.jsp', {
                        params: {
                            api_key: 123,
                            seating_enable: $rootScope.isSeatingEvent,
                            event_id: $rootScope.eid,
                            transaction_id: $rootScope.transactionId,
                            event_date: $rootScope.selectDate,
                            Priregtoken: $rootScope.pritoken,
                            Priregtype: $rootScope.priorityType,
                            Prilistid: $rootScope.listid,
                            ticketurl: null,
                            wid: $rootScope.waitListId

                        }
                    })
                    .success(function(data, status, headers, config) {
                        $scope.eventMetadata.is_priority = false;
                        $scope.ticketsData = data;
                        $scope.loadingMetadata = false;
                        $scope.ticketsData.currency = data.currency;
                        $rootScope.currencyLbl = data.currency;
                        $scope.showDesc = $scope.ticketsData.ticket_desc_mode != 'collapse';
                        $scope.showGroupDesc = $scope.ticketsData.ticket_group_desc_mode != 'collapse';
                        $scope.feecolrequeired = data.feecolrequeired;
                        $scope.loadingTickets = false;
                        $rootScope.totalMinutes = Number(data.timeremaining);
                        $rootScope.timeRemaining = Number(data.timeremaining);
                        $rootScope.secondsRemaining = 0;
                        $rootScope.millis = (+new Date) + ($rootScope.totalMinutes * 60 * 1000);
                        if ($scope.ticketsData.items.length == 0 && !$scope.eventMetadata.is_recurring)
                            $scope.ticketsUnavailable = true;
                        if ($scope.ticketsData.items.length == 0)
                            $scope.ticketsUnavailable = true;


                        if ($rootScope.eventDetailsList.discountcode) {
                            $scope.discountCode = $rootScope.eventDetailsList.discountcode;
                            $timeout(function() {
                                $scope.applyDiscount();
                            });
                            $scope.discountAppliedFromURL = true;
                        }
                        /*if (!$scope.discountAppliedFromURL && $location.search().discountCode) {
                            $scope.discountCode = $location.search().discountCode;
                            $timeout(function() {
                                $scope.applyDiscount();
                            });
                            $scope.discountAppliedFromURL = true;
                        }*/

                        var temp = $scope.discountsData;

                        $timeout(function() {
                            $scope.discountsData = {};
                        });
                        $timeout(function() {
                            $scope.discountsData = temp;
                        });

                        //code for seating event  

                        if ($rootScope.isSeatingEvent) {
                            $scope.loadSeating = true;
                            $http.get('http://localhost/ticketwidget/getSeatingInfo.jsp?&timestamp=' + new Date().getTime(), {
                                    params: {
                                        eid: $rootScope.eid,
                                        tid: $rootScope.transactionId,
                                        venueid: $scope.venueid,
                                        evtdate: $rootScope.selectDate
                                    }
                                })
                                .success(function(seatingdata, seatingstatus, seatingheaders, seatingconfig) {
                                    $scope.loadSeating = false;
                                    $scope.seatingdata = seatingdata;
                                    $scope.allSections = seatingdata.allsectionid;
                                    $scope.seatSectionId = seatingdata.allsectionid[0];
                                    $scope.sectionId = seatingdata.allsectionid[0];
                                    $scope.venuePath = seatingdata.venuepath;
                                    $scope.venueName = seatingdata.venuelinklabel;
                                    $scope.allSectionObj = seatingdata.allsectionidnames;
                                    //alert("json::"+JSON.stringify($scope.allSectionObj));
                                    $scope.seats = seatingdata.allsections[0];
                                    $scope.allSeats = seatingdata.allsections[0].completeseats;
                                    $scope.groupTicketSelection = seatingdata.seatticketgroupdetails;
                                    $scope.groupDetails = seatingdata.seatticketgroupdetails.seatgrouptable;
                                    $scope.backgroundCSS = {
                                            'background-image': 'url(' + $scope.seats.background_image + ')'
                                        },
                                        $scope.noofcols = seatingdata.allsections[0].noofcols;
                                    $scope.noofrows = seatingdata.allsections[0].noofrows;
                                });
                        }

                        var allTicketIds = '';
                        for (var i = 0; i < $scope.ticketsData.items.length; i++) {
                            if ($scope.ticketsData.items.length - 1 != i)
                                allTicketIds = allTicketIds + $scope.ticketsData.items[i].id + ',';
                            else
                                allTicketIds = allTicketIds + $scope.ticketsData.items[i].id;
                        };
                        $rootScope.ticketsIds = allTicketIds;
                    })
                    .error(function(data, status, headers, config) {
                        alert('Unknown error occured. Please try reloading the page.');
                    });
            };
            /* Ticket data end */

            /*Wait list start*/
            $scope.showWaitPop = false;
            $scope.waitListData = {};
            $scope.wait_select = 0;
            $scope.waitListData.pattern = /.+\@.+\..+/;
            $scope.userWaitListDetails = {};
            $scope.waitListResponse = '';
            $scope.waitlistPop = function(tname, tid, lmt) {
                $scope.waitListData.tktName = tname;
                $scope.waitListData.waitlistQty = $scope.getWaitlistQty(lmt);
                $scope.waitListData.tktId = tid;
                $scope.showWaitPop = true;
                $scope.waitListData.showBtn = true;
            };
            $scope.getWaitlistQty = function(Q) {
                var list = [0];
                try {
                    var waitMax = parseInt(Q);
                    var waitMin = 1;
                    for (var i = waitMin; i <= waitMax && waitMax != 0; i++)
                        list.push(parseInt(i));

                } catch (error) {}
                return list;
            };
            $scope.submitWaitList = function() {

                if (!$scope.userWaitListDetails.name && !$scope.userWaitListDetails.email) {
                    $scope.waitListData.error = 'fields Required';
                    return;
                } else {
                    $scope.waitListData.error = '';
                    var data = {
                        name: $scope.userWaitListDetails.name,
                        email: $scope.userWaitListDetails.email,
                        phone: $scope.userWaitListDetails.mnumber
                    };
                    var tktDetails = [{
                        ticket_id: $scope.waitListData.tktId,
                        ticket_name: $scope.waitListData.tktName,
                        qty: $scope.wait_select
                    }];
                    $http.get('http://localhost/ticketwidget/createwaitlist.jsp', {
                        params: {
                            event_id: $rootScope.eid,
                            user_details: data,
                            tickets_info: [tktDetails],
                            notes: $scope.userWaitListDetails.message,
                            event_date: $rootScope.selectDate
                        }

                    }).success(function(data, status, headers, config) {
                        $scope.waitListResponse = data;
                        if ('success' == $scope.waitListResponse.status) {
                            $scope.waitListResponse.msg = props.wl_confirm_msg;
                            $scope.waitListData.showBtn = false;
                            $timeout(function() {
                                $scope.waitListResponse.status = '';
                            }, 5000);
                            $scope.getTicketSection();
                        }
                    }).error(function(data, status, headers, config) {
                        alert('error');
                    });
                }
            };
            $scope.closeWaitList = function() {
                $scope.showWaitPop = false;
            };
            /*Wait list end*/

            $scope.close_condition = function() {
                $scope.conditional_ticketing = '';
            };

            $scope.discountAppliedFromURL = false;

            $scope.ticketGroups = {};
            $scope.$watch('ticketsData', function(newval) {
                angular.forEach(newval.items, function(item) {
                    if (item.type == 'group') {
                        angular.forEach(item.tickets, function(grouptkt) {
                            $scope.ticketGroups[grouptkt.id] = item.name;
                        });
                    }
                });
            });

            $scope.setSection = function(sectionId) {
                $scope.seats = $filter('filter')($scope.seatingdata.allsections, {
                    sectionid: sectionId
                })[0];
                $scope.backgroundCSS = {
                        'background-image': 'url(' + $scope.seats.background_image + ')'
                    },
                    $scope.sectionId = sectionId;
                $scope.noofcols = $scope.seats.noofcols;
                $scope.noofrows = $scope.seats.noofrows;
            };


            $scope.scrollToSeats = function() {
                $('html, body').animate({
                    scrollTop: $('#seatingsection').offset().top
                }, 700);
            };


            $scope.getQtyOptions = function(min, max, tktSelected) {
                var options = [0];
                try {
                    var tempMin = parseInt(min);
                    var tempMax = parseInt(max);
                    if (tempMin == 0 && tempMax == 0 && parseInt(tktSelected) > 0) {
                        for (var j = 1; j <= parseInt(tktSelected); j++)
                            options.push(parseInt(j));
                        return options;
                    }
                    for (var i = tempMin; i <= tempMax && tempMax != 0; i++)
                        options.push(parseInt(i));

                } catch (err) {}
                return options;
            };


            $scope.total = function() {
                var total = 0;
                angular.forEach($scope.ticketsData.items, function(item, index) {
                    if (item.type == 'ticket') {
                        if (item.is_donation == 'n') {
                            total += (parseFloat(item.charging_price) + parseFloat(item.charging_fee)) * parseFloat(item.ticket_selected);
                        } else if (item.is_donation == 'y') {
                            if (item.donation_amount)
                                total += parseFloat(item.donation_amount);
                        }
                    } else if (item.type == 'group') {
                        angular.forEach(item.tickets, function(item, index) {
                            if (item.is_donation == 'n') {
                                total += (parseFloat(item.charging_price) + parseFloat(item.charging_fee)) * parseFloat(item.ticket_selected);
                            } else if (item.is_donation == 'y') {
                                if (item.donation_amount)
                                    total += parseFloat(item.donation_amount);
                            }
                        });
                    }
                });
                return total;
            };

            $scope.atleastOneTicketSelected = function() {
                var ticketsSelected = 0;
                angular.forEach($scope.ticketsData.items, function(item, index) {
                    if (item.type == 'ticket') {
                        if (item.is_donation == 'n')
                            if (item.ticket_selected > 0)
                                ticketsSelected++;
                    } else if (item.type == 'group') {
                        angular.forEach(item.tickets, function(item, index) {
                            if (item.is_donation == 'n')
                                if (item.ticket_selected > 0)
                                    ticketsSelected++;
                        });
                    }
                });
                return ticketsSelected > 0;
            };

            $scope.isEmpty = function(obj) {
                return angular.equals({}, obj);
            };

            $scope.parseFloat = function(value) {
                return parseFloat(value);
            };

            // discounts
            $scope.discountsData = {};
            $scope.loadingDiscount = false;

            $scope.applyDiscount = function() {
                if (!$scope.discountCode) {
                    $scope.discountsData = {};
                    return;
                }
                $scope.loadingDiscount = true;
                var trasactionid = '';
                if ($location.search().tid)
                    trasactionid = $location.search().tid;
                $http.get('http://localhost/ticketwidget/applyDiscount.jsp', {
                        params: {
                            api_key: '123',
                            event_id: $rootScope.eid,
                            code: $scope.discountCode,
                            tid: trasactionid,
                            evtdate: $rootScope.selectDate
                        }
                    }).success(function(data, status, headers, config) {
                        //alert("the data is::"+JSON.stringify(data));
                        $scope.discountsData = data;
                        $scope.loadingDiscount = false;
                        if (data.status == 'fail')
                            $scope.discountApplied = false;
                        else
                            $scope.discountApplied = true;

                    })
                    .error(function(data, status, headers, config) {});

            };

            $scope.$watch('discountsData', function(newValue, oldValue) {
                angular.forEach($scope.ticketsData.items, function(ticketItem, index) {

                    if (ticketItem.type == "ticket") {
                        ticketItem.charging_price = ticketItem.actual_price;
                        ticketItem.charging_fee = ticketItem.actual_fee;
                    }

                    if (ticketItem.type == "group") {
                        angular.forEach(ticketItem.tickets, function(ticketItem, index) {
                            ticketItem.charging_price = ticketItem.actual_price;
                            ticketItem.charging_fee = ticketItem.actual_fee;
                        });
                    }

                });

                angular.forEach(newValue.disc_details, function(discount, index) {

                    angular.forEach($scope.ticketsData.items, function(ticketItem, index) {

                        if (ticketItem.type == "ticket") {
                            if (ticketItem.id == discount.ticketid)
                                ticketItem.charging_price = discount.final_price;
                            if (parseFloat(ticketItem.charging_price) == 0)
                                ticketItem.charging_fee = "0.00";
                        }

                        if (ticketItem.type == "group") {
                            angular.forEach(ticketItem.tickets, function(ticketItem, index) {
                                if (ticketItem.id == discount.ticketid)
                                    ticketItem.charging_price = discount.final_price;
                                if (parseFloat(ticketItem.charging_price) == 0)
                                    ticketItem.charging_fee = "0.00";
                            });
                        }

                    });

                });

            });

            $scope.loadingTransaction = false;
            
            /* Seating start */
            $scope.getSeatImage = function(seat) {
                if (seat) {
                    if (seat.type) {
                        if (seat.type == 'NA') {
                            return '/main/images/seatingimages/lightgray_blank.png';
                        } else {
                            if (seat.type.indexOf('SO') > -1) {
                                return '/main/images/seatingimages/lightgray_sold.png';
                            } else {
                                if (seat.type.indexOf('Hold') > -1)
                                    return '/main/images/seatingimages/lightgray_exclaimation.png';
                                var found = isTicketExists(seat);
                                if (found)
                                    return '/main/images/seatingimages/' + seat.type + '.png';
                                else
                                    return '/main/images/seatingimages/lightgray_blank.png';
                            }
                        }
                    } else {
                        return '/main/images/seatingimages/lightgray_blank.png';
                    }
                }
            };
            $scope.seatingMultTicket = '';
            $scope.clickSeat = function(seat, seatIndex) {
                if (seat && seat.type && !(seat.type.indexOf('SO') > -1) && !(seat.type.indexOf('Hold') > -1) && !(seat.type.indexOf('NA') > -1) && seat.ticketids && isTicketAvailable(seat)) {
                    var tktids = removeNotAvailableTickets(seat.ticketids);
                    if (tktids.length > 1) {
                        var htmlData = '<table>';
                        if (seat.seatSelected) {
                            seat.seatSelected = false;
                            for (var i = 0; i < tktids.length; i++) {
                                var tktID = tktids[i];
                                var groupName = $scope.ticketGroups[tktID] == undefined ? "" : " (" + $scope.ticketGroups[tktID] + ")";
                                htmlData = htmlData + '<tr><td><input type="radio"  name="selticketid" id="selticketid" value="' + tktID + '"></td><td>' + $scope.seats.completeseats.ticketnameids[tktID] + ' ' + groupName + '</td></tr>';
                            }
                            htmlData = htmlData + '</table>';
                            //htmlData=htmlData+"<br/><center><input type='button' value='Select Ticket' id='accept'>&nbsp;&nbsp;<input type='button' value='Cancel' id='reject' ></center><br/>";
                            $scope.seatingMultTicket = true;
                            document.getElementById('seatingMultTicket').innerHTML = htmlData;
                            $scope.seatAccept = function() {
                                $scope.multiSeatSelect(seat, seatIndex);
                            };
                        } else {
                            $scope.clickSeatChecking(seat.selectedTkt, 'removeseat', seat, seatIndex);
                        }
                    } else {
                        if (seat.seatSelected) {
                            $scope.clickSeatChecking(tktids[0], 'addseat', seat, seatIndex);
                        } else {
                            $scope.clickSeatChecking(tktids[0], 'removeseat', seat, seatIndex);
                        }
                    }
                }

            };
            $scope.multiSeatSelectClose = function() {
                $scope.seatingMultTicket = false;
            };
            $scope.multiSeatSelect = function(seat, seatIndex) {
                var selectedtktid = '';
                var selticktemp = '';
                selticktemp = document.getElementsByName('selticketid');
                for (var i = 0; i < selticktemp.length; i++) {
                    if (selticktemp[i].checked) {
                        selectedtktid = selticktemp[i].value;
                    }
                }
                $scope.seatingMultTicket = false;
                if (selectedtktid != '') {
                    seat.seatSelected = true;
                    $scope.clickSeatChecking(selectedtktid, 'addseat', seat, seatIndex);
                }
            };


            $scope.clickSeatChecking = function(ticketSelected, type, seat, seatIndex) {
                var ticketMaxQty = '';
                var availTkt = $scope.selecttedTicketQty;
                if ($scope.groupDetails == undefined)
                    $scope.getSelectedTicketid(ticketSelected, type, seat, seatIndex);
                else {
                    var isCheck = seat['seatSelected'];
                    var singleGrp = '';
                    angular.forEach($scope.groupDetails, function(value, key) {
                        if (value.indexOf(seatIndex) > -1)
                            singleGrp = value;
                    });
                    // if group seat selection
                    if (singleGrp.length > 0) {
                    	angular.forEach($scope.ticketsData.items, function(eachItem, index) {
                            if (eachItem.type == 'ticket') {
                                if (ticketSelected == eachItem.id) {
                                    ticketMaxQty = eachItem.max;
                                }
                            } else {
                                angular.forEach(eachItem.tickets, function(eachTktInGroup, grpIndex) {
                                    if (eachTktInGroup.id == selectedId) {
                                        ticketMaxQty = eachTktInGroup.max;
                                    }
                                });
                            }
                        });
                        if (isCheck) {
                            var d = availTkt + singleGrp.length;
                            if (d < ticketMaxQty) {
                                for (var j = 0; j < singleGrp.length; j++) {
                                    var s_ID = singleGrp[j];
                                    var nameId = 's_' + singleGrp[j].split('_')[1] + '_' + singleGrp[j].split('_')[2];
                                    var sendObj = $scope.allSeats[nameId];
                                    $scope.seats.completeseats[nameId].seatSelected = isCheck;
                                    $scope.seats.completeseats[nameId].selectedTkt = ticketSelected;
                                    var temp = {
                                        'ticketids': sendObj['ticketids'],
                                        'seatcode': sendObj['seatcode'],
                                        'type': sendObj['type'],
                                        'seatSelected': isCheck
                                    };
                                    $scope.getSelectedTicketid(ticketSelected, type, temp, s_ID);
                                    //$scope.clickSeat(temp,s_ID);
                                }
                            } else {
                                seat.seatSelected = false;
                                //$scope.seats.completeseats[seatIndex].seatSelected = false;
                                alert('What you are selected ticket is group seat selection ticket.');
                            }
                        } else {
                        	//alert(JSON.stringify(singleGrp));
                            for (var j = 0; j < singleGrp.length; j++) {
                                var s_ID = singleGrp[j];
                               // console.log(s_ID);
                                var nameId = 's_' + singleGrp[j].split('_')[1] + '_' + singleGrp[j].split('_')[2];
                                var sendObj = $scope.allSeats[nameId];
                                $scope.seats.completeseats[nameId].seatSelected = isCheck;
                                $scope.seats.completeseats[nameId].selectedTkt = '';
                                var temp = {
                                    'ticketids': sendObj['ticketids'],
                                    'seatcode': sendObj['seatcode'],
                                    'type': sendObj['type'],
                                    'seatSelected': isCheck
                                };
                                $scope.getSelectedTicketid(ticketSelected, type, temp, s_ID);
                                //$scope.clickSeat(temp,s_ID);
                            }
                        }
                    } else
                        $scope.getSelectedTicketid(ticketSelected, type, seat, seatIndex);
                    //$scope.clickSeat(seat,seatIndex);
                }

            };


            $scope.getLayOutImage = function() {
                //alert("the image url is::"+$scope.venuePath);
                var topPos = $window.pageYOffset + 140;
                var popUpData = '<a style="cursor:pointer" id="imgclose"><img src="/home/images/images/close.png" style="border: 0 none;float: right;margin-right: -15px;margin-top: -16px;"></a>' +
                    '<iframe width="100%" height="100%" src="' + $scope.venuePath + '" resizeiframe="true" frameborder="0" allowfullscreen=""></iframe>';
                document.getElementById('attendeeloginpopup').innerHTML = popUpData;
                document.getElementById("attendeeloginpopup").style.display = "block";
                if (document.getElementById("backgroundPopup")) {
                    document.getElementById("backgroundPopup").style.display = "block";
                    var body = document.body,
                        html = document.documentElement;
                    var height = Math.max(body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight, html.offsetHeight);
                    document.getElementById("backgroundPopup").style.height = height + 'px';
                    document.getElementById('attendeeloginpopup').style.display = "block";
                    document.getElementById('attendeeloginpopup').style.width = '550px';
                    document.getElementById('attendeeloginpopup').style.height = '500px';
                    document.getElementById('attendeeloginpopup').style.top = topPos + 'px';
                    document.getElementById('attendeeloginpopup').style.left = '30%';
                    document.getElementById('attendeeloginpopup').style.padding = 0;
                    document.getElementById('imgclose').onclick = rejectclose;
                }
            };


            function removeNotAvailableTickets(seattkts) {
                var tktIDs = [];
                for (var i = seattkts.length - 1; i >= 0; i--)
                    if ($scope.availabelTickets.indexOf(seattkts[i]) > -1)
                        tktIDs.push(seattkts[i]);
                return tktIDs;
            }


            function isTicketExists(seat) {
                var isexits = false;
                for (var i = 0; i < seat.ticketids.length; i++) {
                    if ($scope.allTickets.indexOf(seat.ticketids[i]) > -1) {
                        isexits = true;
                        break;
                    }
                }
                return isexits;
            }


            function isTicketAvailable(seat) {
                var isexits = false;
                for (var i = 0; i < seat.ticketids.length; i++)
                    if ($scope.availabelTickets.indexOf(seat.ticketids[i]) > -1)
                        return true;
                return isexits;
            }



            function rejectclose(seat) {
                if (document.getElementById("backgroundPopup"))
                    document.getElementById("backgroundPopup").style.display = 'none';
                document.getElementById('attendeeloginpopup').style.display = "none";
            }


            $scope.initSectionId = function() {
            	//alert("json::"+JSON.stringify($scope.allSectionObj));
            	/*angular.forEach($scope.allSectionObj, function(key, value){
            		alert(key+'_'+value);
            	});*/
                $scope.sectionId = Object.keys($scope.allSectionObj)[0].toString();
            };

            $scope.getSectionsLength = function() {
                return Object.keys($scope.allSectionObj).length;
            };
            $scope.selecttedTicketQty = 0;
            //for -> When from profile to tickets page previously selected tickets
            $rootScope.seatTempIndexs ;
            
            $scope.getSelectedTicketid = function(selectedId, type, seat, seatIndex) {
            	
                angular.forEach($scope.ticketsData.items, function(eachItem, index) {
                    if (eachItem.type == 'ticket') {
                        if (selectedId == eachItem.id) {
                            if (type == 'addseat') {
                                if (eachItem.ticket_selected < eachItem.max) {
                                    eachItem.ticket_selected = eachItem.ticket_selected + 1;
                                    $scope.selecttedTicketQty = eachItem.ticket_selected;
                                    //console.log(selectedId);
                                    seat.selectedTkt = selectedId;
                                    //console.log(JSON.stringify(seat));
                                    
                                    if($rootScope.transactionId)
                                    	eachItem.seatIndexes = $rootScope.seatTempIndexs;
                                    
                                    if (eachItem.seatIndexes)
                                        eachItem.seatIndexes.push(seatIndex);
                                    else {
                                        eachItem.seatIndexes = [];
                                        eachItem.seatIndexes.push(seatIndex);
                                    }
                                    
                                    $rootScope.seatTempIndexs = eachItem.seatIndexes;
                                    
                                    if (eachItem.min > eachItem.ticket_selected)
                                        alert("for \"" + eachItem.name + "\", you need to select minimum of " + eachItem.min + " seats");

                                } else {
                                    alert("maximum quantity reached for \"" + eachItem.name + "\" ticket type ");
                                    seat.seatSelected = false;
                                    seat.selectedTkt = '';
                                }
                            } else {
                                eachItem.ticket_selected = eachItem.ticket_selected - 1;
                                eachItem.ticket_selected = eachItem.ticket_selected <= 0 ? 0 : eachItem.ticket_selected;
                                $scope.selecttedTicketQty = eachItem.ticket_selected;
                                seat.selectedTkt = '';
                                
                                if($rootScope.transactionId)
                                	eachItem.seatIndexes = $rootScope.seatTempIndexs;
                                eachItem.seatIndexes.splice(eachItem.seatIndexes.indexOf(seatIndex), 1);
                                
                                $scope.seatIndexs = eachItem.seatIndexes;
                                
                                if (eachItem.min > 1 && eachItem.min > eachItem.ticket_selected)
                                    alert("you need to select mininmum of " + eachItem.min + " for \"" + eachItem.name + "\" ticket type");
                            }
                        }
                    } else {
                        angular.forEach(eachItem.tickets, function(eachTktInGroup, grpIndex) {
                            if (eachTktInGroup.id == selectedId) {
                                if (type == 'addseat') {
                                    if (eachTktInGroup.ticket_selected < eachTktInGroup.max) {
                                        eachTktInGroup.ticket_selected = eachTktInGroup.ticket_selected + 1;
                                        seat.selectedTkt = selectedId;
                                        if (eachTktInGroup.seatIndexes)
                                            eachTktInGroup.seatIndexes.push(seatIndex);
                                        else {
                                            eachTktInGroup.seatIndexes = [];
                                            eachTktInGroup.seatIndexes.push(seatIndex);
                                        }
                                        if (eachTktInGroup.min > eachTktInGroup.ticket_selected)
                                            alert("for \"" + eachTktInGroup.name + "\", you need to select minimum of " + eachTktInGroup.min + " seats");
                                    } else {
                                        alert("maximum quantity reached for \"" + eachTktInGroup.name + "\" ticket type ");
                                        seat.seatSelected = false;
                                        seat.selectedTkt = '';
                                    }
                                } else {
                                    eachTktInGroup.ticket_selected = eachTktInGroup.ticket_selected - 1;
                                    eachTktInGroup.ticket_selected = eachTktInGroup.ticket_selected <= 0 ? 0 : eachTktInGroup.ticket_selected;
                                    seat.selectedTkt = '';
                                    eachTktInGroup.seatIndexes.splice(eachTktInGroup.seatIndexes.indexOf(seatIndex), 1);
                                    if (eachTktInGroup.min > 1 && eachTktInGroup.min > eachTktInGroup.ticket_selected)
                                        alert("you need to select mininmum of " + eachTktInGroup.min + " for \"" + eachTktInGroup.name + "\" ticket type");
                                }

                            }
                        });
                    }

                });
                $timeout(function() {});
            };

            $scope.showSeatDetails = function(seat, mouseevent) {
            	//console.log(JSON.stringify(seat));
                $scope.showPopup = true;
                if (seat) {
                    $scope.popupStyle = {
                        position: 'absolute',
                        left: (mouseevent.pageX - 125) + 'px',
                        top: (mouseevent.pageY - 160) + 'px'
                    };
                    //console.log(mouseevent.pageX+' - '+mouseevent.pageY);
                    //console.log(JSON.stringify($scope.popupStyle));
                    if (seat.type && isTicketExists(seat) && isTicketAvailable(seat)) {
                        if (seat.type.indexOf('SO') > -1) {
                            $scope.tooltipHtml = '&nbsp;Seat Number : ' + seat.seatcode + '&nbsp;<br/><font color=#FF0000><b>&nbsp;Sold Out</b></font>';
                        } else if (seat.type.indexOf('Hold') > -1) {
                            $scope.tooltipHtml = '&nbsp;Seat Number : ' + seat.seatcode + '&nbsp;<br/><font color=#FF0000><b>&nbsp;This seat is currently on hold</b></font>';
                        } else if (seat.type == 'NA') {
                            $scope.tooltipHtml = '&nbsp;Seat Number : ' + seat.seatcode + '&nbsp;<br/><font color=#FF0000><b>&nbsp;Not Available</b></font>';
                        } else {
                            var currentlyselectedTkt = '';
                            //alert(seat.selectedTkt);
                            if (seat.selectedTkt && seat.selectedTkt != '') {
                                var groupName = $scope.ticketGroups[seat.selectedTkt] == undefined ? "" : " (" + $scope.ticketGroups[seat.selectedTkt] + ")";
                               // console.log(JSON.stringify($scope.seats.completeseats.ticketnameids)+ ' - '+seat.selectedTkt);
                                var tktname = $scope.seats.completeseats.ticketnameids[seat.selectedTkt];
                                currentlyselectedTkt = '<b>&nbsp;<u><br/>&nbsp;Current Selection:</u></b><br/><ul><li>' + tktname + '' + groupName + '</li></ul></br>';
                            }
                            $scope.tooltipHtml = '&nbsp;Seat Number : ' + seat.seatcode + '&nbsp;' + currentlyselectedTkt + '<br/><b>&nbsp;<u>Available for Tickets:</u></b>&nbsp;' + getAvaiTickets(seat);
                        }
                    } else {
                        if (seat.type && seat.type.indexOf('SO') > -1)
                            $scope.tooltipHtml = '&nbsp;Seat Number : ' + seat.seatcode + '&nbsp;<br/><font color=#FF0000><b>&nbsp;Sold Out</b></font>';
                        else
                            $scope.tooltipHtml = '&nbsp;Seat Number : ' + seat.seatcode + '&nbsp;<br/><font color=#FF0000><b>&nbsp;Not Available</b></font>';
                    }
                } else $scope.showPopup = false;

                //console.log($scope.tooltipHtml);
            };


            $scope.pushTickets = function(tktId, availabilityMsg) {
                $scope.allTickets.push(tktId);
                if (availabilityMsg == '')
                    $scope.availabelTickets.push(tktId);
            };


            $scope.getImageCss = function(seat) {
                if (seat.type && isTicketExists(seat) && isTicketAvailable(seat)) {
                    if (seat.type.indexOf('SO') > -1 || seat.type.indexOf('Hold') > -1 || seat.type == 'NA')
                        return false;
                    else
                        return true;
                } else
                    return false;

            };


            $scope.hideSeatDetails = function() {
                $scope.showPopup = false;
            };

            function getTicketMsg(tktid) {
                var isMsg = false;
                if ($scope.availabelTickets.indexOf(tktid) > -1)
                    isMsg = true;
                return isMsg;
            }


            var getAvaiTickets = function(seat) {
                var applicableTids = seat.ticketids;
                var temp = '<ul>';
                for (var tktid in applicableTids) {
                    if ($scope.allTickets.indexOf(applicableTids[tktid]) > -1 && getTicketMsg(applicableTids[tktid])) {
                        var groupName = $scope.ticketGroups[applicableTids[tktid]] == undefined ? "" : " (" + $scope.ticketGroups[applicableTids[tktid]] + ")";
                        temp = temp + '<li>' + $scope.seats.completeseats.ticketnameids[applicableTids[tktid]] + '' + groupName + '</li>';
                    }
                }
                temp = temp + '</ul>';
                return temp;
            };

            $scope.getColSize = function() {
                var colTemp = [];
                var i = Number($scope.noofcols);
                var tempi = i + 1;
                for (i = 1; i < tempi; i++) {
                    colTemp.push(i);
                }
                return colTemp;
            };

            $scope.getRowSize = function() {
                var rowTemp = [];
                var i = Number($scope.noofrows);
                var tempi = i + 1;
                for (i = 1; i < tempi; i++) {
                    rowTemp.push(i);
                }
                return rowTemp;
            };


            $scope.buy = function() {
                var flag;
                /* priorityTimeCheck start */
                if ('Continue' == $rootScope.priorityType) {
                    flag = $scope.priorityTimeCheck();
                    if ('false' == flag)
                        return;
                }
                /* priorityTimeCheck end */

                var alertMsgCount = 0;
                var finalTickets = {
                    selected_tickets: [],
                    api_Key: '123'
                };
                angular.forEach($scope.ticketsData.items, function(item, index) {
                    if (item.type == 'ticket') {
                        if (item.is_donation == 'n') {
                            if (item.ticket_selected > 0 && (item.min > item.ticket_selected)) {
                                alert("for \"" + item.name + "\", the minimum seats quantity is " + item.min + ",you selected only " + item.ticket_selected + " seats");
                                alertMsgCount++;
                            }
                            if (item.ticket_selected > 0)
                                finalTickets.selected_tickets.push({
                                    ticket_id: item.id,
                                    qty: item.ticket_selected,
                                    seat_ids: item.seatIndexes = item.seatIndexes == undefined ? [] : item.seatIndexes
                                });
                        } else if (item.is_donation == 'y') {
                            if (item.donation_amount)
                                finalTickets.selected_tickets.push({
                                    ticket_id: item.id,
                                    amount: item.donation_amount
                                });
                        }
                    } else if (item.type == 'group') {
                        angular.forEach(item.tickets, function(item, index) {
                            if (item.is_donation == 'n') {
                                if (item.ticket_selected > 0 && (item.min > item.ticket_selected)) {
                                    alert("for \"" + item.name + "\", the minimum seats quantity is " + item.min + ",you selected only " + item.ticket_selected + " seats");
                                    alertMsgCount++;
                                }
                                if (item.ticket_selected > 0)
                                    finalTickets.selected_tickets.push({
                                        ticket_id: item.id,
                                        qty: item.ticket_selected,
                                        seat_ids: item.seatIndexes = item.seatIndexes == undefined ? [] : item.seatIndexes
                                    });
                            } else if (item.is_donation == 'y') {
                                if (item.donation_amount)
                                    finalTickets.selected_tickets.push({
                                        ticket_id: item.id,
                                        amount: item.donation_amount
                                    });
                            }
                        });
                    }
                });

                finalTickets.discountCode = $scope.discountsData.disc_code;
                finalTickets.event_id = $rootScope.eid;
                if ($scope.eventMetadata.is_recurring) {
                    $rootScope.eventDetailsList.event_date = $scope.selectedDate.value;
                    //finalTickets.event_date = $scope.selectedDate.value;
                } else
                    $rootScope.eventDetailsList.event_date = '';

                //console.log($rootScope.eventDetailsList);
                //alert( $rootScope.context);
                if (alertMsgCount == 0) {
                    $scope.loadingTransaction = true;
                    /*$http.get($rootScope.baseUrl + 'setTicketQuantities.jsp', {*/
                    $http.get('http://localhost/ticketwidget/setTicketQuantities.jsp', {
                        params: {
                            api_Key: finalTickets.api_Key,
                            disc_code: finalTickets.discountCode,
                            event_id: finalTickets.event_id,
                            selected_tickets: JSON.stringify(finalTickets.selected_tickets),
                            ticket_ids: $rootScope.ticketsIds,
                            transaction_id: ($rootScope.transactionId) ? $rootScope.transactionId : '',
                            event_details: $rootScope.eventDetailsList

                        }
                    }).success(function(data, status, headers, config) {
                        //console.log("the final data is::"+JSON.stringify(data));
                        $scope.loadingTransaction = false;
                        //console.log(JSON.stringify(data));
                        if (data.status == 'success') {
                            $rootScope.ticketsCost = data.details.tickets_cost;
                            $('#tickets .widget h2').hide();
                            $rootScope.menuTitles = true;
                            $scope.loadingTransaction = true;
                            $rootScope.transactionDetails = data.details;
                            //$location.search('eid', $rootScope.eid);
                            $rootScope.transactionId = $rootScope.transactionDetails.tid;
                            //$location.search('tid', $rootScope.transactionDetails.tid);
                            if ($scope.discountApplied)
                                $location.search('discountCode', $scope.discountCode);
                            else
                                $location.search('discountCode', null);

                            if ($scope.eventMetadata.is_recurring)
                                $rootScope.selectDate = $rootScope.selectDate;
                            else
                                $rootScope.selectDate = '';

                            $location.path('/profile');
                        } else if (data.status = 'fail' && data.reason == 'conditional_ticketing') {
                            var dataList = '<ul>';
                            for (var j = 0; data.errors.length > j; j++) {
                                dataList = dataList + '<li>' + data.errors[j] + '</li>';
                            }
                            dataList = dataList + '</ul>';
                            $scope.conditional_ticketing = dataList;
                        } else if (data.status == 'fail' && data.reason == 'event-level-qty-criteria') {
                            $scope.loadingTransaction = false;
                            var avalbleQty = data.details.remaining_qty <= 0 ? 0 : data.details.remaining_qty;
                            alert('For "' + data.details.eventname + '" selected quantity is ' + data.details.selected_qty + ' and currently available quantity is ' + avalbleQty);
                        } else if (data.status == 'fail' && data.reason == 'Applied code is Unavailable') {
                            var agree = confirm(data.reason);
                            $scope.discountApplied = false;
                            $scope.discountsData = {};
                            if (agree) {
                                $scope.buy();
                            }

                        } else {
                            $scope.loadingTransaction = false;
                            alert('Unknown error occured. Please try again');
                        }

                    }).error(function(data, status, headers, config) {
                        $scope.loadingTransaction = false;
                        alert('Unknown error occured. Please try refreshing the page');
                    });
                }
            };
        }
    ]);