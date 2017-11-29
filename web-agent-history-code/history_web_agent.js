 //match virtualHoldData with summaryRows, if there is no matching, then the result is EMPTY
    const mapSummaryItems1 = (summaryRows, virtualHoldData, selectedGroupByOption, callState) => {

      var mergedArray=[];
      //var mergedObject = {};
      var mergeKey='groupValue';
      for(var i=0;i<virtualHoldData.length;i++){
        var valueKey = virtualHoldData[i][mergeKey];
        var index=findWithAttr(summaryRows,mergeKey,valueKey);
        if(index.length >0){
          var obj1= virtualHoldData[i];
          for(var j =0;j<index.length;j++){
            var mergedObject = {};
            console.log('index = ' + index[j]);
            var obj2=summaryRows[index[j]];
            for(var r in obj1){
              mergedObject[r]=obj1[r];
            }
            for(var r in obj2){
              if(!(r in obj1)){
                mergedObject[r]=obj2[r];
              }

            }
            mergedArray.push(mergedObject);
          }
        }
      }

      return mergedArray.map((summaryRow) => {
        const recalculated = recalculateStatistics([summaryRow], callState);
        return Object.assign({}, summaryRow, recalculated, {
          groupLabel: getGroupLabel(summaryRow, selectedGroupByOption)
        });
      });

      //return summaryRows.map((summaryRow) => {
        //const recalculated = recalculateStatistics([summaryRow], callState);
        //return Object.assign({}, summaryRow, recalculated, {
          //groupLabel: getGroupLabel(summaryRow, selectedGroupByOption)
        //});
      //});
    };

    //match virtualHoldData with summaryRows, if there is no matching, then the result is summaryRows
    const mapSummaryItems2 = (summaryRows, virtualHoldData, selectedGroupByOption, callState) => {

      var standardObject={
        averageDurationAnsweredCalls: 0,
        averageWaitTime: 0,
        averageWaitTimeUnansweredCalls: 0,
        groupBy: "queue",
        groupValue: "",
        longestDurationAnsweredCalls: 0,
        numberOfAnsweredCalls: 0,
        numberOfAnsweredCallsWithinTimeLimit: 0,
        numberOfCalls: 0,
        numberOfUnansweredCalls: 0,
        numberOfVirtualHolds: 0,
        totalDurationAnsweredCalls: 0,
        processedCalls: 0,
        unProcessedCalls: 0
      };
      var mergedArray=[];//the result of merging this two arrays is here
      //var mergedObject = {};
      var mergeKey='groupValue';//merge by groupValue
      var insertedList=[]//this indexes of the rows of summaryRows which was matched with one row of virtualHoldData

      //just insert the values of the rows of virtualHoldData which matched with one row of summaryRows
      for(var i=0;i<virtualHoldData.length;i++){
        var valueKey = virtualHoldData[i][mergeKey];
        var index=findWithAttr(summaryRows,mergeKey,valueKey);
        if(index.length >0){
          var obj1= virtualHoldData[i];
          for(var j =0;j<index.length;j++){//perhaps we dont need this loop, because there is no two objects with the same mergeKey ?!
            insertedList.push(index[j]);
            var mergedObject = {};
            console.log('index = ' + index[j]);
            var obj2=summaryRows[index[j]];
            for(var r in obj2){
              mergedObject[r]=obj2[r];
            }
            for(var r in obj1){
              if(!(r in obj2)){
                mergedObject[r]=obj1[r];
              }
            }
            mergedArray.push(mergedObject);
          }
        }
      }
      //Insert the rows of summaryRows which was not matched with rows from virtualHoldData
      var obj1= standardObject;
      for(var j =0;j<summaryRows.length ;j++){
        if(!(j in insertedList)){
          var mergedObject = {};
          var obj2=summaryRows[j];
          for(var r in obj2){
            mergedObject[r]=obj2[r];
          }
          for(var r in obj1){
            if(!(r in obj2)){
              mergedObject[r]=obj1[r];
            }
          }
          mergedArray.push(mergedObject);
        }
      }


      return mergedArray.map((summaryRow) => {
        const recalculated = recalculateStatistics([summaryRow], callState);
        return Object.assign({}, summaryRow, recalculated, {
          groupLabel: getGroupLabel(summaryRow, selectedGroupByOption)
        });
      });

      //return summaryRows.map((summaryRow) => {
      //const recalculated = recalculateStatistics([summaryRow], callState);
      //return Object.assign({}, summaryRow, recalculated, {
      //groupLabel: getGroupLabel(summaryRow, selectedGroupByOption)
      //});
      //});
    };


    //match virtualHoldData with summaryRows, if there is no matching, then the result is summaryRows
    const mapSummaryItems3 = (summaryRows, virtualHoldData, selectedGroupByOption, callState) => {

      //Default object values
      var standardObject={
        averageDurationAnsweredCalls: 0,
        averageWaitTime: 0,
        averageWaitTimeUnansweredCalls: 0,
        groupBy: selectedGroupByOption,
        groupValue: "",
        longestDurationAnsweredCalls: 0,
        numberOfAnsweredCalls: 0,
        numberOfAnsweredCallsWithinTimeLimit: 0,
        numberOfCalls: 0,
        numberOfUnansweredCalls: 0,
        numberOfVirtualHolds: 0,
        totalDurationAnsweredCalls: 0,
        processedCalls: 0,
        unProcessedCalls: 0
      };

      var mergedArray=[];         //the result of merging this two arrays is here
      var mergeKey='groupValue';  //merge by groupValue
      var obj1={},obj2={};        //in case of matching, these will have the matched objects from each array
      var insertedList=[];        //this indexes of the rows of summaryRows which was matched with one row of virtualHoldData


      //just insert the values of the rows of virtualHoldData which matched with one row of summaryRows
      for(var i=0;i<virtualHoldData.length;i++){
        var valueKey = virtualHoldData[i][mergeKey];
        var index = summaryRows.findIndex(x => x[mergeKey]==valueKey);  //get the index of the object x in the array summaryRows which has x[mergeKey]==valueKey
        if(index >= 0){
          insertedList.push(index);
          obj1=Object.assign({}, virtualHoldData[i]);       //cloning object, with this function we avoid
          obj2=Object.assign({}, summaryRows[index]);
          var mergedObject=Object.assign({}, obj1, obj2);   //merging objects with the same properties
          mergedArray.push(mergedObject);
        }
      }

      //Insert the rows of summaryRows which was not matched with rows from virtualHoldData
      obj1=Object.assign({}, standardObject);
      for(var j =0;j<summaryRows.length ;j++){
        if(!(insertedList.includes(j))){
          obj2=Object.assign({}, summaryRows[j]);
          var mergedObject=Object.assign({}, obj1, obj2);
          mergedArray.push(mergedObject);
        }
      }

      return mergedArray.map((summaryRow) => {
        const recalculated = recalculateStatistics([summaryRow], callState);
        return Object.assign({}, summaryRow, recalculated, {
          groupLabel: getGroupLabel(summaryRow, selectedGroupByOption)
        });
      });

    };

    //match virtualHoldData with summaryRows, if there is no matching, then the result is summaryRows
    const mapSummaryItems = (summaryRows, virtualHoldData, selectedGroupByOption, callState) => {

      var mergeKey='groupValue';  //merge by groupValue


      function findGroupValue(obj,attr,value) {
        return obj[attr]===value;
      }

      const mergedArray = summaryRows.map(obj => {
        const match= virtualHoldData.find( x => findGroupValue(x,mergeKey,obj[mergeKey]));
        if(match){
          return Object.assign({}, obj, match);
        }
        else{
          return obj;
        }
      });


      return mergedArray.map((summaryRow) => {
        const recalculated = recalculateStatistics([summaryRow], callState);
        return Object.assign({}, summaryRow, recalculated, {
          groupLabel: getGroupLabel(summaryRow, selectedGroupByOption)
        });
      });

    };

//--------------------------------------

this.fetchQueueHistorySummary = function(successCallback, errorCallback){
      const queryParams = getSummaryQueryParams();

      this.pendingQueries.set('fetchQueueHistorySummaryRows', true);

      const dummyData1 = [{
        groupBy: "queue",
        groupValue: "9999", //match on this key
        processedCalls: 1,
        unprocessedCalls: 2
      },
        {
          groupBy: "queue",
          groupValue: "8001", //match on this key
          processedCalls: 3,
          unprocessedCalls: 4
        },
        {
          groupBy: "queue",
          groupValue: "8009", //match on this key
          processedCalls: 1,
          unprocessedCalls: 2
        },
        {
          groupBy: "agent",
          groupValue: "andre", //match on this key
          processedCalls: 5,
          unprocessedCalls: 6
        }
      ];


      function wrapInPromise(value) {
        const deferred = $q.defer();
        deferred.resolve({data: value});
        return deferred.promise;
      }

      const inboundSummaryPromise = $http.get('rest/inbound/history/summary', {params: queryParams} );
      const virtualHoldSummaryPromise = wrapInPromise(dummyData1); // We wait Api here, for now just dummy data ..
      $q.all([inboundSummaryPromise, virtualHoldSummaryPromise])
        .then(function(data) {
          const inboundData = data[0].data;
          const virtualHoldData = data[1].data; // = dummyData1
          that.summaryGroups = mapSummaryItems(inboundData, virtualHoldData, that.selectedGroupByOption, that.filter.state.value);
          that.statistics = recalculateStatistics(inboundData, that.filter.state.value);
          that.pendingQueries.set('fetchQueueHistorySummaryRows', false)
          if (successCallback) {
            successCallback(data[0].status, data[0].headers, data[0].config);
          }
        }, function(data, status, headers, config) {
          log.warn('ERROR: Fetching queue history summary failed.');
          that.pendingQueries.set('fetchQueueHistorySummaryRows', false)
          if (errorCallback) {
            errorCallback(status, headers, config);
          }
        });
    };



