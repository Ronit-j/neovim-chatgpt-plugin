class Duck:

    def __init__(self, name):
        self.name = name

    def quack(self):
        print("Quack")
       

def make_duck_quack(duck):
    duck.quack()

duck = Duck()
make_duck_quack(duck)
