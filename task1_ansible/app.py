from flask import Flask, json, request, jsonify
app = Flask(__name__)

# Install flask: https://flask.palletsprojects.com/en/2.0.x/installation/
# POST: {"animal":"cow", "sound":"moooo", "count": 3}


@app.route('/', methods=['GET', 'POST'])
def get_query():
    data = request.get_data()
    try:
        data = json.loads(data)
        r_animal = data["animal"]
        r_sound = data["sound"]
        r_count = data["count"]

    except:
        return "Bad query or some parameter(s) missing. Please, use JSON query like {\"animal\":\"cow\", \"sound\":\"moooo\", \"count\": 3}"

    for _ in range(r_count):
        print("\U0001F40E " + r_animal + " says " + r_sound)

    return "DONE"


if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=True)
