"""
Sample firebase cloud functions
"""

# cloud functions for firebase
from firebase_functions import https_fn
# firebase admin module to access cloud firestore things
from firebase_admin import firestore, initialize_app

import google.cloud.firestore
import requests
import json
from dotenv import load_dotenv
import os

# define magic strings here for now
REQ_TEXT_KEY = 'text'
ENV_API_KEY = 'API_KEY'
PLACES_API_URL = 'https://places.googleapis.com/v1/places:searchText'

firebase_app = initialize_app()

@https_fn.on_request()
def find_by_text_search(req: https_fn.Request) -> https_fn.Response:
    """Fetches place by Google Places API text-search

    See more here
    https://developers.google.com/maps/documentation/places/web-service/text-search

    Args: TODO
    Returns: TODO
    Raises: TODO
    """

    query = req.args.get(REQ_TEXT_KEY)
    if query is None:
        return https_fn.Response("No text query provided", status=400)

    firestore_client: google.cloud.firestore.Client = firestore.client()

    # pls write API key in .env file
    load_dotenv()
    api_key = os.getenv(ENV_API_KEY)

    # json headers and payload below
    headers = {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': api_key,
        'X-Goog-FieldMask': 'places.id,places.attributions,places.name,places.displayName' # for these masks, the requests are free :) but we need to get more info than this
    }
    data = {
        "textQuery": query
    }

    print(headers)
    print(data)

    places_response = requests.post(
        PLACES_API_URL, 
        headers=headers,
        json=data
    )

    return json.dumps(places_response.json(), indent=4)