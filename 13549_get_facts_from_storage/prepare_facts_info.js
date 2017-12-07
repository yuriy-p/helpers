var date1 = new Date("2017-11-13T00:00:00")
var date2 = new Date("2017-12-06T23:59:59")
db.parkingFacts.find({date: { $gte: date1.getTime(), $lte: date2.getTime() }}).forEach(function(fact){
     print('ID="'+fact._id+'"\nDATE="'+new Date(fact.date)+'"');
     print('overviewImage="'+fact.files.overviewImage+'"');
     print('vrpImage="'+fact.files.vrpImage+'"');
     print('sourceData="'+fact.files.sourceData+'"');
     print("getData\n");
})
