
def Processing_element(Bitmap_A,Bitmap_B,non_zero_A,non_zero_B):
    bitmap_buffer_A = Bitmap_A
    bitmap_buffer_B = Bitmap_B
    non_zero_buffer_A = non_zero_A
    non_zero_buffer_B = non_zero_B
    len_bitmap_buffer_A = len(bitmap_buffer_A)
    len_bitmap_buffer_B = len(bitmap_buffer_B)
    global Mul_cnt, Mul, result_mul, add_cnt, add_mult_cnt, add, result_add, multiplier_result, adder_result, bitmap_result, non_zero_index_B_cnt,non_zero_index_A_cnt,non_zero_A_temp_check
    global Number_of_ANDgates_per_PE, result_mul_add,multiplier_adder_result

    Mul_cnt = [0 for i in range(cycle_ratio_CEtoLE)]
    result_mul = [0 for i in range(cycle_ratio_CEtoLE)]
    add_cnt = [0 for i in range(Multoadd_ratio)]
    add_mult_cnt = [0 for i in range(Multoadd_ratio)]
    result_add = [0 for i in range(Multoadd_ratio)]
    Mul = [0 for i in range(cycle_ratio_CEtoLE)]
    add = [0 for i in range(Multoadd_ratio)]
    result_mul_add = [0 for i in range(cycle_ratio_CEtoLE)]
    multiplier_adder_result = []

    multiplier_result = []
    adder_result = []
    bitmap_result = [[0]*len(Bitmap_B) for i in range(len(Bitmap_A))]

    non_zero_index_B_cnt = [0 for i in range(Number_of_ANDgates_per_PE)]
    non_zero_index_A_cnt = [0 for i in range(Number_of_ANDgates_per_PE)]
    non_zero_A_temp_check = [0 for i in range(Number_of_ANDgates_per_PE)]

    for k in range(cycle_ratio_CEtoLE):
        Mul[k] = Multiplier()


    for k in range(Multoadd_ratio):
        add[k] = Adder()

    LE1 = logical_element()
    LE2 = logical_element()
    #pipeline this
    for i in range(len(bitmap_buffer_A)):
        #parallel hardware units
        for j in range(len(bitmap_buffer_B)):
            #this loop has to be parallelized in HLS and here we are using multi-threading
            #for k in range(Number_of_ANDgates_per_PE/):
            #the number of C values is determined by number of defined AND gates
            C0 = LE1.operation(bitmap_buffer_A[i][0],bitmap_buffer_B[j][0])
            C1 = LE2.operation(bitmap_buffer_A[i][1],bitmap_buffer_B[j][1])

            #here MUL_1, MUL_2 are the array containing two elements for the inputs to the multiplier units
            

            status_1 = Scheduler(C0,C1,non_zero_buffer_A,non_zero_buffer_B,i,j,Number_of_ANDgates_per_PE,len_bitmap_buffer_A,len_bitmap_buffer_B)
            print("status", status_1)
            # bit_value_result_A is one then k = 0


    return status_1



            





