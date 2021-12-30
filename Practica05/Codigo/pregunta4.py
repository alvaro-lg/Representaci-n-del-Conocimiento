import numpy as np
import matplotlib.pyplot as plt

plt.rcParams["figure.figsize"] = [7.50, 6]
plt.rcParams["figure.autolayout"] = True

MAX_ITERS = 15

# Probabilidad de ir a una pagina cualquiera
d = 0.01 #las paginas se quedan sin usuarios muy rapido
#d = 0.7 #con valor mas alto usuario navega mas

# Matriz de adyacencia de graph1
M1 = np.array([[0, 0.5, 0.5, 0],
               [0, 0, 0.5, 0.5],
               [0, 0.5, 0, 0.5],
               [1, 0, 0, 0]
              ])

# Matriz de adyacencia de graph2
M2 = np.array([[0, 0.33, 0.33, 0.33],
               [0, 0, 0.5, 0.5],
               [0, 0.5, 0, 0.5],
               [1, 0, 0, 0]
              ])

# Distribucion de probabilidad graph1
v1 = np.array([1/7, 2/7, 2/7, 2/7])

# Distribucion de probabilidad graph2
v2 = np.array([1/8, 2/8, 2/8, 3/8])

def nextIter(v, M):
    return v @ M

# Arrays con la evolución de los valores de las probabilidades
probs1 = v1.copy().T
probs2 = v2.copy().T

# Cálculo de la evolucion de las probabilidades graph1 condicionada con d
for i in range(MAX_ITERS):
    v1 = nextIter(v1*d, M1)
    probs1 = np.vstack((probs1, v1.T))

# Cálculo de la evolucion de las probabilidades graph2 condicionada con d
for i in range(MAX_ITERS):
    v2 = nextIter(v2*d, M2)
    probs2 = np.vstack((probs2, v2.T))

# Ploteo de la evolución de las probabilidades
figure, axis = plt.subplots(2, 1)

axis[0].set_title("Evolución de las probabilidades graph1 con d = " + str(d))

axis[1].set_title("Evolución de las probabilidades graph2 con d = " + str(d))

# Plot graph1
for i in range(probs1.shape[1]):
    print(probs1[:,i])
    axis[0].plot(probs1[:,i], label="Pagina " + chr(i + 65))

# Plot graph2
for i in range(probs2.shape[1]):
    print(probs2[:,i])
    axis[1].plot(probs2[:,i], label="Pagina " + chr(i + 65))

axis[0].legend(loc="right")
axis[1].legend(loc="right")
plt.show()
