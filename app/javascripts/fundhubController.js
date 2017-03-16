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

    function setStatus(msg) {
	$timeout(function() {
		$scope.status = msg;
	});
    }

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
	    
	    fund.NewProjectEvent().watch(function(error, result) {
		    if (error) {
			    console.log(error);
			    return;
		    }

		    $timeout(function() {
			    $scope.projArr.push(result.args);
			});
		    console.log(result['args']);
	    });

	fund.ContributeEvent().watch(function (error, result) {
		if (error) {
			console.log(error);
			$timeout(function() {
				setStatus("Contribution failed. See log.");
			});
		} else {

			var index = result.args.i
		}
	});

	    fund.getProjectInfo();
    } 

    $scope.createProject = function(targetAmt, projDeadline) {
    	    setStatus("Creating new project...");	
	    var deadline = Math.round((new Date("2015-04-17 10:12:12".replace('-','/'))).getTime() / 1000);
	    var targetEth = web3.toWei(targetAmt); 
	    var ownerAddr = $scope.account;
	    //console.log(deadline);
	    fund.createProject(ownerAddr, targetEth, deadline, {from: $scope.account, gas:1000000}); 
	    setStatus("");
    }

    $scope.contribute = function(amount, receiver) {

        setStatus("Initiating transaction... (please wait)");

        var projectAddress = receiver;
	var contributor = $scope.account;
	var amtWei = web3.toWei(amount);

	fund.contribute(projectAddress, contributor, {from: contributor, value: amtWei, gas:1000000})
        .then(function() {
            setStatus("Transaction complete!");
            //$scope.refreshBalance();
	    var projFound = false;
	    for (var ii = 0; ii < $scope.projArr.length; ii++) {
		    if (projectAddress.toString() == $scope.projArr[ii].newProjectAddr.toString()) {
			    $scope.projArr[ii].raisedAmt += amtWei;
			    projFound = true;
		    }
		}
	    if (projFound != true) {
		    consle.log("Unable to find project to update raised.");
	    }
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
