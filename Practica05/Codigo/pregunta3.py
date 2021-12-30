import numpy as np
import matplotlib.pyplot as plt

plt.rcParams["figure.figsize"] = [7.50, 3.50]
plt.rcParams["figure.autolayout"] = True

MAX_ITERS = 50

# Matriz de adyacencia con pesos entre las distintas páginas web
M = np.array([[0, 1, 0, 0, 0, 0],
              [0, 0, 1, 0, 0, 0],
              [0, 0, 0, 1, 0, 0],
              [0, 0, 0, 0, 1, 0],
              [0, 0, 0, 0, 0, 1],
              [1, 0, 0, 0, 0, 0],
])

# Distribucion de probabilidad segun enlaces por pagina
v = np.array([0.1, 0.1, 0.1, 0.1, 0.1, 0.5])

def nextIter(v, M):
    return v @ M

# Array con la evolución de los valores de las probabilidades
probs = v.copy().T

# Cálculo de la evolucion de las probabilidades
for i in range(MAX_ITERS):
    v = nextIter(v, M)
    probs = np.vstack((probs, v.T))

# Ploteo de la evolución de las probabilidades
plt.title("Evolución de las probabilidades")

for i in range(probs.shape[1]):
    print(probs[:,i])
    plt.plot(probs[:,i], label="Pagina " + chr(i + 65))

plt.xlabel('Valores de t')
plt.ylabel('Valor de P(X(t))')
plt.legend()
plt.savefig("out.png")
plt.show()
