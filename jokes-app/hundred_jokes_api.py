from flask import Flask, jsonify
from bs4 import BeautifulSoup
import requests
import json

app = Flask(__name__)

@app.route('/api/jokes', methods=['GET'])
def _return_100_jokes():
    response = []

    # Collect 100 jokes from first 5 latest pages (20 jokes per page)
    for i in range(1, 6):
        jokes_20 = []
        source = requests.get(f'http://bash.org.pl/latest?page={i}').text
        soup = BeautifulSoup(source, 'html.parser')
        posts_20 = soup.find_all('div', class_="q post")
        for post in posts_20:
            joke_date = post.find('div', class_="right").text.strip()
            joke_id = post.find('a', class_="qid click").get_text()
            joke_text = post.find('div', class_="quote post-content post-body").get_text().strip()
            joke_dict = {
                'id': joke_id,
                'date': joke_date,
                'joke': joke_text
            }
            jokes_20.append(joke_dict)
        response += jokes_20
    
    return jsonify(response)
