import random

def jugar_adivinanza():
    # Generar un número aleatorio entre 1 y 100
    numero_secreto = random.randint(1, 100)
    intentos = 0

    print("¡Bienvenido al juego de adivinanzas!")
    print("Estoy pensando en un número entre 1 y 100.")

    while True:
        intentos += 1
        # Pedir al jugador que ingrese un número
        guess = int(input("Intento #{}: ¿Cuál crees que es el número? ".format(intentos)))


        





