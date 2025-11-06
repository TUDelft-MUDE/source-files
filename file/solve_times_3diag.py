import numpy as np
import matplotlib.pyplot as plt
import time
import scipy.sparse as sp
import scipy.linalg as sla
import scipy.sparse.linalg as spla


def build_matrix(n):
    # Build the tridiagonal matrix of size n x n

    row_indices = np.append(np.append(range(n), range(n-1)), range(1, n))
    col_indices = np.append(np.append(range(n), range(1, n)), range(n-1))
    data = np.append(np.append(2 * np.ones(n), -1 * np.ones(n-1)), -1 * np.ones(n-1))
    matrix = sp.csr_matrix((data, (row_indices, col_indices)), shape=(n, n))

    return matrix


# Example usage: this is what the matrix and its inverse look like for n=10
# K10 = build_matrix(10).todense()
# Kinv = np.linalg.inv(K10)   
# fig, ax = plt.subplots(1, 2, figsize=(8,8))
# ax[0].matshow(K10)
# ax[0].set_title('Matrix K (n=10)')
# ax[1].matshow(Kinv)
# ax[1].set_title('Inverse of K (n=10)')
# plt.show()


sizes = [101, 201, 501, 1001, 2001, 5001, 10001, 20001, 50001, 100001, 200001, 500001, 1000001 ]

max_total = 120
max_single = 20
max_repeats = 10

inv_times = []
for n in sizes[:-1]:
    f = np.zeros(n)
    f[int(n/2)] = 1  # point source in the middle of the domain
    try:
        K = build_matrix(n).todense()
    except MemoryError:
        print("Memory Error at n=", n)
        break
    times = []
    for i in range(max_repeats):
        start_time = time.time()
        u = sla.inv(K) @ f
        times.append(time.time() - start_time)
        if sum(times) > max_total:
            break
    inv_times.append(min(times))
    print(f"n={n}, fastest from {i+1} repeats, time taken: {inv_times[-1]:.4f} seconds")
    if inv_times[-1] > max_single: 
        break

solve_times = []
for n in sizes:
    f = np.zeros(n)
    f[int(n/2)] = 1  # point source in the middle of the domain
    try:
        K = build_matrix(n).todense()
    except MemoryError:
        print("Memory Error at n=", n)
        break
    times = []
    for i in range(max_repeats):
        start_time = time.time()
        u = sla.solve(K, f)
        times.append(time.time() - start_time)
        if sum(times) > max_total:
            break
    solve_times.append(min(times))
    print(f"n={n}, fastest from {i+1} repeats, time taken: {solve_times[-1]:.4f} seconds")
    if solve_times[-1] > max_single: 
        break

spsolve_times = []
for n in sizes:
    f = np.zeros(n)
    f[int(n/2)] = 1  # point source in the middle of the domain
    Ksparse = build_matrix(n)
    times = []
    for i in range(max_repeats):
        start_time = time.time()
        u = spla.spsolve(Ksparse, f)
        times.append(time.time() - start_time)
        if sum(times) > max_total:
            break
    spsolve_times.append(min(times))
    print(f"n={n}, fastest from {i+1} repeats, time taken: {spsolve_times[-1]:.4f} seconds")
    if spsolve_times[-1] > max_single: 
        break

plt.figure
plt.loglog(sizes[:len(inv_times)], inv_times, label='Scipy inv', marker='o')
plt.loglog(sizes[:len(solve_times)], solve_times, label='Scipy solve', marker='o')
plt.loglog(sizes[:len(spsolve_times)], spsolve_times, label='Scipy sparse solve', marker='o')

xs = np.exp(np.linspace(6,8,10))
ys = xs**3/2e9
x2 = np.exp(np.linspace(6,12,10))
yn = x2/1e7
plt.loglog(xs,ys, 'k:', label='$n^3$ scaling')
plt.loglog(x2,yn, 'k--', label='$n$ scaling')
plt.xlabel('Matrix size $n$ [-]')
plt.ylabel('Time [s]')

plt.legend()
# plt.savefig('solve_times_3diag.png', dpi=300)
plt.show()
