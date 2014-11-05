app = angular.module("app", [])
app.controller "AmqTopicsController", [
  "$scope"
  "$http"
  ($scope, $http) ->
    $scope.messages = []
    $scope.topics = []

    $http.get("http://adfs.hill30.com:8161/api/jolokia/read/org.apache.activemq:type=Broker,brokerName=localhost",
      withCredentials: true
    ).success((data, status, headers, config) ->
      console.log data
      for topic in data.value.Topics
        $scope.topics.push topic.objectName.split("destinationName=")[1].split(",destinationType")[0]
      #$scope.topics = data.value.Topics
    ).error (data, status, headers, config) ->
      console.log data

    $scope.getLastMessage = () ->
      url = "http://adfs.hill30.com:8161/api/message/#{$scope.currentTopic}?type=topic&clientId=consumerA"
      $http.get(url,
        withCredentials: true
      ).success((data, status, headers, config) ->
        console.log data
        $scope.messages.push data
      ).error (data, status, headers, config) ->
        console.log data

    $scope.setTopic = (topic) ->
      if topic != $scope.currentTopic
        $scope.messages = [] 
        $scope.currentTopic = topic

]