app = angular.module("app", [])
app.controller "AmqTopicsController", [
  "$scope"
  "$http"
  ($scope, $http) ->
    $scope.messages = []
    $scope.sources = []

    $scope.getSource = (source) ->
      $http.get("http://#{$scope.host}/api/jolokia/read/org.apache.activemq:type=Broker,brokerName=localhost",
        withCredentials: true
      ).success((data, status, headers, config) ->
        console.log data
        $scope.source = source
        $scope.sources = []
        if source == 'topic'
          for topic in data.value.Topics
            $scope.sources.push topic.objectName.split("destinationName=")[1].split(",destinationType")[0]
        else 
          for queue in data.value.Queues
            $scope.sources.push queue.objectName.split("destinationName=")[1].split(",destinationType")[0]

        #$scope.topics = data.value.Topics
      ).error (data, status, headers, config) ->
        console.log data

    $scope.getLastMessage = () ->
      url = "http://adfs.hill30.com:8161/api/message/#{$scope.currentSource}?type=#{$scope.source}&clientId=consumerA"
      $http.get(url,
        withCredentials: true
      ).success((data, status, headers, config) ->
        console.log data
        $scope.messages.push data
      ).error (data, status, headers, config) ->
        console.log data

    $scope.setSource = (source) ->
      if source != $scope.currentSource
        $scope.messages = [] 
        $scope.currentSource = source

]