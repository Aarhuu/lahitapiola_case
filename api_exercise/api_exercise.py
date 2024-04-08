import json

import requests

class APIService():
    """
    Service for fetching data from given api_url, and printing selected fields

    Attributes:

    api_url : str
        Url of the api endpoint as string WITHOUT parameters
    params : dict[str|float|int]
        Parameter dictionary with keys and params in used in api request
    data : dict
        Acquired data from api get request if request successful

        
    Methods:

    query_data:
        Performs a get request to the specified api endpoint with set parameters, and saves response content to class variable self._data. 
        Raises an exception if:
         1. Response code was not 200
         2. There was an issue with connection
         3. Data acquired from request could not be parsed in utf-8 format
    print_fields(fields : list[str]):
        Prints given fields of all rows of acquired data in format 'field: field_value'. 
        Raises exception if fields entries are not string or fields is not found in data.

    """

    def __init__(self, api_url: str, params: dict[str|float|int] = {}) -> None:
        self._api_url: str = api_url
        self._params: dict[str|float|int] = params
        self._data: dict = {}

    @property
    def api_url(self):
        return self._api_url
    
    @api_url.setter
    def api_url(self, url_str: str):
        if type(url_str) != str:
            raise ValueError("Api url needs to be a string! Given api url was of type:", type(url_str))
        self._api_url = url_str

    @property
    def params(self):
        return self._params
    
    @params.setter
    def params(self, param_dict: dict[str|float|int]):
        if type(param_dict) != dict:
            raise ValueError("Params needs to be a dictionary! Given api url was of type:", type(param_dict))

        elif not all(type(elem) in [str, float, int] for elem in param_dict.values()):
            types = [type(elem) for elem in param_dict.items()]
            raise ValueError("Paramemer dictionary values needs to be string, integer or float format! Given dictionary of type:", types)
        self._params = param_dict

    def query_data(self):
        if len(self._params) == 0:
            res = requests.get(self._api_url)
        else:
            params_str = []
            for k, v in self.params.items():
                params_str.append(str(k) + "=" + str(v))
            params_str = "&".join(params_str)
            query_url = self._api_url + params_str

            try:
                res = requests.get(query_url)
                if res.status_code == 200:
                    try:
                        self._data = json.loads(res.content.decode("utf-8"))
                    except Exception as e:
                        raise Exception("Error with parsing response data:", e)
                else:
                    raise Exception("Api request failed: ", res.content)
            except requests.exceptions.RequestException as e:
                raise Exception(e)

    def print_fields(self, fields: list[str]):
        if len(self._data) == 0:
            raise Exception("Dataset is empty! Run a valid query first.")
        elif type(fields) != list:
            raise ValueError("Invalid type for fields! Should be a list of strings, given was", type(fields))
        elif len(fields) == 0:
            raise ValueError("Fields list is empty!")
        elif not all(type(elem) == str for elem in fields):
            raise ValueError("Features should all be in string format! Given features:", [(f, type(f)) for f in fields])
        try:
            for row in self._data["features"]:
                output_str = ""
                for elem in fields:
                    output_str += elem  + ": " + str(row["properties"][elem]) + ", "
                print(output_str)
        except Exception as e:
            print("Error acquiring field data from field", e)



