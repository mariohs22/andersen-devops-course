from flask import Flask, json, request
app = Flask(__name__)

animals = {
    'Monkey':   '🐒',  # U+1F412
    'Gorilla':  '🦍',  # U+1F98D
    'Dog':      '🐕',  # U+1F415
    'Poodle':   '🐩',  # U+1F429
    'Raccoon':  '🦝',  # U+1F99D
    'Cat':      '🐈',  # U+1F408
    'Tiger':    '🐅',  # U+1F405
    'Leopard':  '🐆',  # U+1F406
    'Horse':    '🐎',  # U+1F40E
    'Zebra':    '🦓',  # U+1F993
    'Deer':     '🦌',  # U+1F98C
    'Ox':       '🐂',  # U+1F402
    'Water Buffalo': '🐃',  # U+1F403
    'Cow':      '🐄',  # U+1F404
    'Pig':      '🐖',  # U+1F416
    'Boar':     '🐗',  # U+1F417
    'Ram':      '🐏',  # U+1F40F
    'Ewe':      '🐑',  # U+1F411
    'Goat':     '🐐',  # U+1F410
    'Camel':    '🐪',  # U+1F42A
    'Two-Hump Camel': '🐫',  # U+1F42B
    'Lama':     '🦙',  # U+1F999
    'Giraffe':  '🦒',  # U+1F992
    'Elephant': '🐘',  # U+1F418
    'Rhinoceros': '🦏',  # U+1F98F
    'Hippopotamus': '🦛',  # U+1F99B
    'Mouse':    '🐁',  # U+1F401
    'Rat':      '🐀',  # U+1F400
    'Rabbit':   '🐇',  # U+1F407
    'Chipmunk': '🐿',  # U+1F43F
    'Hedgehog': '🦔',  # U+1F994
    'Bat':      '🦇',  # U+1F987
    'Koala':    '🐨',  # U+1F428
    'Kangaroo': '🦘',  # U+1F998
    'Badger':   '🦡',  # U+1F9A1
    'Turkey':   '🦃',  # U+1F983
    'Chicken':  '🐔',  # U+1F414
    'Rooster':  '🐓',  # U+1F413
    'Hatching Chick': '🐣',  # U+1F423
    'Baby Chick': '🐤',  # U+1F424
    'Bird':     '🐦',  # U+1F426
    'Penguin':  '🐧',  # U+1F427
    'Dove':     '🕊',  # U+1F54A
    'Eagle':    '🦅',  # U+1F985
    'Duck':     '🦆',  # U+1F986
    'Swan':     '🦢',  # U+1F9A2
    'Owl':      '🦉',  # U+1F989
    'Peacock':  '🦚',  # U+1F99A
    'Parrot':   '🦜',  # U+1F99C
    'Crocodile': '🐊',  # U+1F40A
    'Turtle':   '🐢',  # U+1F422
    'Lizard':   '🦎',  # U+1F98E
    'Snake':    '🐍',  # U+1F40D
    'Dragon':   '🐉',  # U+1F409
    'Sauropod': '🦕',  # U+1F995
    'T-Rex':    '🦖',  # U+1F996
    'Spouting Whale': '🐳',  # U+1F433
    'Whale':    '🐋',  # U+1F40B
    'Dolphin':  '🐬',  # U+1F42C
    'Fish':     '🐟',  # U+1F41F
    'Tropical Fish': '🐠',  # U+1F420
    'Blowfish': '🐡',  # U+1F421
    'Shark':    '🦈',  # U+1F988
    'Octopus':  '🐙',  # U+1F419
    'Spiral Shell': '🐚',  # U+1F41A
    'Snail':    '🐌',  # U+1F40C
    'Butterfly': '🦋',  # U+1F98B
    'Bug':      '🐛',  # U+1F41B
    'Ant':      '🐜',  # U+1F41C
    'Honeybee': '🐝',  # U+1F41D
    'Lady Beetle': '🐞',  # U+1F41E
    'Cricket':  '🦗',  # U+1F997
    'Spider':   '🕷',  # U+1F577
    'Scorpion': '🦂',  # U+1F982
    'Mosquito': '🦟',  # U+1F99F
    'Microbe':  '🦠'  # U+1F9A0
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
    result += "Made with ❤️ by Siarhei\n"

    return result


if __name__ == '__main__':
    app.run(host='0.0.0.0', debug=False)
