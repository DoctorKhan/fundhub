var app = angular.module('fundhubApp', []);

app.config(function($locationProvider) {
    $locationProvider.html5Mode(true);
});

app.controller("fundhubController", ['$scope', '$location', '$http', '$q', '$window', '$timeout', function($scope, $location, $http, $q, $window, $timeout) {
    $scope.accounts = [];
    $scope.account = "";
    $scope.balance = "";
    var fund;
    $scope.projects;
    $scope.projArr = [];
    var projArr = [];

    $scope.refreshBalance = function() {
	    fund = FundingHub.deployed();
/*
	    fund.getBalance.call($scope.account, {from: $scope.account})
		    .then(function(value) {
			    $timeout(function () {
				    $scope.balance = value.valueOf();
			    });
		    }).catch(function(e) {
			    console.log(e);
			    setStatus("Error getting balance; see log.");
		    });
		    */
	fund.getProjectInfo();
	$scope.projects = fund.call().getProjectInfo();
	console.log($scope.projects);
    };

    $window.onload = function () {
	    web3.eth.getAccounts(function(err, accs) {
		if (err != null) {
			alert("There was an error fetching your accounts.");
			return;
		}

		if (accs.length == 0) {
			alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.");
			return;
		}
		
		$scope.accounts = accs;
		$scope.account = $scope.accounts[0];
		// $scope.refreshBalance();
	    });

	    fund = FundingHub.deployed();
    } 

    $scope.createProject = function(targetAmt, projDeadline) {
    	
	    var deadline = Math.round((new Date("2015-04-17 10:12:12".replace('-','/'))).getTime() / 1000);
	    var targetEth = web3.toWei(targetAmt); 
	    var ownerAddr = $scope.account;
	    //console.log(deadline);
	    fund.NewProjectEvent().watch(function(error, result) {
		    if (error) {
			    console.log(error);
			    $timeout(function () {
				    $scope.userStatus = ("Could not create project.");
			    });
			    return;
		    }
		    $timeout(function() {
			    $scope.projArr.push(result['args']);
			});
		    projArr.push(result['args']);
		    console.log(result['args']);
	    });
	    fund.createProject(ownerAddr, targetEth, deadline, {from: $scope.account, gas:1000000}); 
    }

    $scope.contribute = function(amount, receiver) {

        setStatus("Initiating transaction... (please wait)");

        fund.contribute(receiver, amount, {
            from: $scope.account
        }).then(function() {
            setStatus("Transaction complete!");
            $scope.refreshBalance();
        }).catch(function(e) {
            console.log(e);
            setStatus("Error sending coin; see log.");
        });
    };

    $scope.browse = function() {
	    fund.getProjectInfo();
	    var event = fund.getProjectInfoEvent( {}, function(error, result) {
		      if (!error) {
			    $scope.projectsString = result.args.projectsString;
		     }
	    });

    }

}]);
