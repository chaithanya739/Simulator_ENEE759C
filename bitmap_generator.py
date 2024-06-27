import scipy as sp
import numpy as np

A = np.array([[0,1,2,3], [4, 5, 6,0], [7, 8, 9, 0]])
B = np.array([[2,3,0,1],[0,2,3,0],[12,0,0,13],[0,0,0,0]])
csr_A = sp.sparse.csr_matrix(A)
csr_A_toarray = csr_A.todense()

#bitmap generator
def bitmap_generator(A):
    rows= len(A)
    columns = len(A[0])
    Bitmap_A = [[0]*columns for i in range(rows)]
    non_zero_A = []

    #for bitmap conversion
    for i in range(len(A)):
        for j in range(len(A[i])):
            if A[i][j] != 0:
                Bitmap_A[i][j] = 1

            else:
                Bitmap_A[i][j] = 0

    #for non zero in bitmap conversion
    for j in range(len(A[i])):
        for i in range(len(A)):
            if A[i][j] != 0:
                non_zero_A.append(A[i][j])

    
    return non_zero_A, Bitmap_A

def Transpose(B):
    rows = len(B)
    columns = len(B[0])
    Col_stor = [[0]*rows for i in range(columns)]
    for j in range(columns):
        for i in range(rows):
            Col_stor[j][i] = B[i][j]
    
    return Col_stor

non_zero_A, Bitmap_A =bitmap_generator(A)
Column_storing = Transpose(B)

non_zeroes_A, bitmap_A = bitmap_generator(A)
Transpose_B = Transpose(B)
non_zeroes_B, bitmap_B = bitmap_generator(B)

PE_scheduler (bitmap_A,bitmap_B,non_zeroes_A,non_zeroes_B,Number_of_ANDgates_per_PE)








