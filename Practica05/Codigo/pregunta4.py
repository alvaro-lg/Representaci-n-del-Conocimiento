import numpy as np
import matplotlib.pyplot as plt

plt.rcParams["figure.figsize"] = [7.50, 3.50]
plt.rcParams["figure.autolayout"] = True

MAX_ITERS = 100

# Probabilidad de salto aleator
d = 0.01

# Matriz de adyacencia con pesos entrer las distintas páginas web
M = np.array([[0, 1, 0, 0, 0, 0],
              [0, 0, 1, 0, 0, 0],
              [0, 0, 0, 1, 0, 0],
              [0, 0, 0, 0, 1, 0],
              [0, 0, 0, 0, 0, 1],
              [1, 0, 0, 0, 0, 0],
])

M = M + d
sums = np.sum(M, axis=1)
M_new = np.array([])

for i in range(len(sums)):
    M_new = np.hstack((M_new, (M[i,:] / sums[i])))

M = np.split(M_new, M.shape[0])

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
