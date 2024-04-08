import datetime

from api_exercise import APIService


# Test script for acquiring data from current year, with given minimum magnitude level
if __name__ == "__main__":
    api_url_base = "https://earthquake.usgs.gov/fdsnws/event/1/query?" #url base for api request
    service = APIService(api_url_base)                                 #initialize APIService instance with url base 
    start_time = datetime.datetime(datetime.datetime.now().year, 1, 1) #start datetime for current year
    end_time = datetime.datetime.now()                                 #end datetime as current time

    #set parameter dictionary
    params = {
        "format": "geojson",
        "starttime": start_time.strftime("%Y-%m-%d"),
        "endtime": end_time.strftime("%Y-%m-%d"),
        "minmagnitude": 6.5,
        "limit": 1000
        }
  
    service.params = params                                            #set the defined parameters to class APIService variable params 
    service.query_data()                                               #query data and save to APIService data variable
    service.print_fields(fields=["mag", "place"]) #print 

