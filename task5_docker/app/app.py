from flask import Flask, json, request
app = Flask(__name__)

animals = {
    'Monkey':   'ð',  # U+1F412
    'Gorilla':  'ðĶ',  # U+1F98D
    'Dog':      'ð',  # U+1F415
    'Poodle':   'ðĐ',  # U+1F429
    'Raccoon':  'ðĶ',  # U+1F99D
    'Cat':      'ð',  # U+1F408
    'Tiger':    'ð',  # U+1F405
    'Leopard':  'ð',  # U+1F406
    'Horse':    'ð',  # U+1F40E
    'Zebra':    'ðĶ',  # U+1F993
    'Deer':     'ðĶ',  # U+1F98C
    'Ox':       'ð',  # U+1F402
    'Water Buffalo': 'ð',  # U+1F403
    'Cow':      'ð',  # U+1F404
    'Pig':      'ð',  # U+1F416
    'Boar':     'ð',  # U+1F417
    'Ram':      'ð',  # U+1F40F
    'Ewe':      'ð',  # U+1F411
    'Goat':     'ð',  # U+1F410
    'Camel':    'ðŠ',  # U+1F42A
    'Two-Hump Camel': 'ðŦ',  # U+1F42B
    'Lama':     'ðĶ',  # U+1F999
    'Giraffe':  'ðĶ',  # U+1F992
    'Elephant': 'ð',  # U+1F418
    'Rhinoceros': 'ðĶ',  # U+1F98F
    'Hippopotamus': 'ðĶ',  # U+1F99B
    'Mouse':    'ð',  # U+1F401
    'Rat':      'ð',  # U+1F400
    'Rabbit':   'ð',  # U+1F407
    'Chipmunk': 'ðŋ',  # U+1F43F
    'Hedgehog': 'ðĶ',  # U+1F994
    'Bat':      'ðĶ',  # U+1F987
    'Koala':    'ðĻ',  # U+1F428
    'Kangaroo': 'ðĶ',  # U+1F998
    'Badger':   'ðĶĄ',  # U+1F9A1
    'Turkey':   'ðĶ',  # U+1F983
    'Chicken':  'ð',  # U+1F414
    'Rooster':  'ð',  # U+1F413
    'Hatching Chick': 'ðĢ',  # U+1F423
    'Baby Chick': 'ðĪ',  # U+1F424
    'Bird':     'ðĶ',  # U+1F426
    'Penguin':  'ð§',  # U+1F427
    'Dove':     'ð',  # U+1F54A
    'Eagle':    'ðĶ',  # U+1F985
    'Duck':     'ðĶ',  # U+1F986
    'Swan':     'ðĶĒ',  # U+1F9A2
    'Owl':      'ðĶ',  # U+1F989
    'Peacock':  'ðĶ',  # U+1F99A
    'Parrot':   'ðĶ',  # U+1F99C
    'Crocodile': 'ð',  # U+1F40A
    'Turtle':   'ðĒ',  # U+1F422
    'Lizard':   'ðĶ',  # U+1F98E
    'Snake':    'ð',  # U+1F40D
    'Dragon':   'ð',  # U+1F409
    'Sauropod': 'ðĶ',  # U+1F995
    'T-Rex':    'ðĶ',  # U+1F996
    'Spouting Whale': 'ðģ',  # U+1F433
    'Whale':    'ð',  # U+1F40B
    'Dolphin':  'ðŽ',  # U+1F42C
    'Fish':     'ð',  # U+1F41F
    'Tropical Fish': 'ð ',  # U+1F420
    'Blowfish': 'ðĄ',  # U+1F421
    'Shark':    'ðĶ',  # U+1F988
    'Octopus':  'ð',  # U+1F419
    'Spiral Shell': 'ð',  # U+1F41A
    'Snail':    'ð',  # U+1F40C
    'Butterfly': 'ðĶ',  # U+1F98B
    'Bug':      'ð',  # U+1F41B
    'Ant':      'ð',  # U+1F41C
    'Honeybee': 'ð',  # U+1F41D
    'Lady Beetle': 'ð',  # U+1F41E
    'Cricket':  'ðĶ',  # U+1F997
    'Spider':   'ð·',  # U+1F577
    'Scorpion': 'ðĶ',  # U+1F982
    'Mosquito': 'ðĶ',  # U+1F99F
    'Microbe':  'ðĶ '  # U+1F9A0
}


def get_animal_emoji(animal):
    try:
        return animals[animal.title()]
    except:
        return animal.title()


@app.route('/', methods=['GET', 'POST'])
def get_query():
    data = request.get_data()
    try:
        data = json.loads(data)
        r_animal = data["animal"]
        r_sound = data["sound"]
        r_count = int(float(data["count"]))
        if r_count <= 0:
            raise ValueError('"count" parameter must be 1 or greater')

    except:
        return "Bad query or some parameter(s) missing.\nPlease, use GET or POST JSON query like {\"animal\":\"cow\", \"sound\":\"moooo\", \"count\": 3}"

    result = ""
    for _ in range(r_count):
        result += get_animal_emoji(r_animal) + " says " + r_sound + "\n"
    result += "Made with âĪïļ by Siarhei\n"

    return result


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
