SELECT * FROM virtualhold vh WHERE vh.timestamp > '2017-06-21 0
0:00:00.0' AND vh.timestamp <= '2017-12-21 23:59:00.0' AND vh.channelId IN ('8008') AND vh.givenToAgent IN ('DevStig') order by vh.timestamp asc;


SELECT * FROM virtualhold vh 
WHERE vh.timestamp > '2017-05-21 00:00:00.0' 
AND vh.timestamp <= '2017-12-29 23:59:00.0' 
AND vh.channelId IN ('8008') 
order by vh.timestamp asc;

SELECT * FROM virtualhold vh 
WHERE vh.timestamp > '2017-06-21 00:00:00.0' 
AND vh.timestamp <= '2017-12-23 23:59:00.0' 
AND vh.channelId IN ('8008') AND vh.customerActivityId IN ('5046902','5067158','5067163','5067159') order by vh.timestamp asc;