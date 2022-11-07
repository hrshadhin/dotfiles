import os
import requests
from requests.exceptions import ConnectionError, Timeout, TooManyRedirects
import json

url = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest'
coin_list = ['BTC', 'BCH', 'ETH', 'LTC', 'DASH', 'XMR']

parameters = {
  'symbol': ','.join(coin_list),
  'convert':'USD'
}
headers = {
  'Accepts': 'application/json',
  'X-CMC_PRO_API_KEY': os.getenv("COIN_MARKET_CAP_KEY", ""),
}


try:
    response = requests.get(url, params=parameters, headers=headers)
    json_response = response.json()
    if json_response['status']['error_code'] == 0 :
        coin_prices = {}
        for coin in coin_list:
            if coin in json_response['data']:
                coin_prices[coin] = round(json_response['data'][coin]['quote']['USD']['price'], 2)
        
        
        coin_prices = sorted(coin_prices.items(), key=lambda x: x[1], reverse=True)
        last_coin = len(coin_prices) - 1
        for index, coin in enumerate(coin_prices):
            k, v ,= coin
            if index == last_coin:
                print(f'└ {k} ▷ ${v}')
            else:
                print(f'├ {k} ▷ ${v}')
    else:
        print("Error: ", json_response['status']['error_message'])
except (ConnectionError, Timeout, TooManyRedirects) as e:
  print("Error: ",e)
