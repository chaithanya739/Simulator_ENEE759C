def Scheduler(C0,C1,non_zero_buffer_A,non_zero_buffer_B,i,j,Number_of_ANDgates_per_PE,len_bitmap_buffer_A,len_bitmap_buffer_B):
    global Mul_cnt, Mul, result_mul, add_cnt, add_mult_cnt, add, result_add, multiplier_result, adder_result, bitmap_result, non_zero_index_B_cnt,non_zero_index_A_cnt
    global total_PEs, cycle_ratio_CEtoLE, Multoadd_ratio, Number_of_mul_counters, Number_of_adders,non_zero_A_temp_check, multiplier_adder_result,result_mul_add,status

    bitmap_result[i][j] = C0 or C1
          
            
    for s in range(cycle_ratio_CEtoLE):
            if (Mul_cnt[s] != 0):
                Mul_cnt[s] = Mul_cnt[s] + 1
            if(Mul_cnt[s] >= cycle_ratio_CEtoLE):
                Mul_cnt[s] = 0
                if(result_mul_add[s] == 0):
                    multiplier_result.append(result_mul[s])
                    result_mul[s] = 0
                else:
                    multiplier_adder_result.append(result_mul_add[s])
                    print("multiplier_adder_result_check",multiplier_adder_result)
                    result_mul_add[s] = 0
                    if (len(multiplier_adder_result) == Number_of_ANDgates_per_PE):
                        multiplier_result.append(0)

    for g in range(Multoadd_ratio):
        if (add_cnt[g] != 0):
            add_cnt[g] = add_cnt[g] + 1
        if (add_cnt[g] == Multoadd_ratio):
            adder_result.append(result_add[g])
            result_add[g] = 0
            add_cnt == 0
                    
            


    if(C0 == 1 and C1 == 0):
        non_zero_A_temp_check[0] = non_zero_A_temp_check[0] + 1

        if (j == len_bitmap_buffer_B-1):
            for s in range(Number_of_ANDgates_per_PE):
                non_zero_index_B_cnt[s] = 0 
            non_zero_index_A_cnt[0] = non_zero_index_A_cnt[0] + 1         
    

        # parallelize the Multipliers

        #indexing of non_zero buffer according to the bit map operation
           
        for s in range(cycle_ratio_CEtoLE):
            if Mul_cnt[s] == 0:
                
                result_mul[s] = Mul[s].operation(non_zero_buffer_A[0][non_zero_index_A_cnt[0]],non_zero_buffer_B[0][non_zero_index_B_cnt[0]])
                
                non_zero_index_B_cnt[0] = non_zero_index_B_cnt[0] + 1
                Mul_cnt[s] = Mul_cnt[s] + 1
                break

    if(C1 == 1 and C0 == 0):
        non_zero_A_temp_check[1] = non_zero_A_temp_check[1] + 1

        if (j == len_bitmap_buffer_B-1):
            
            for s in range(Number_of_ANDgates_per_PE):
                non_zero_index_B_cnt[s] = 0 
            non_zero_index_A_cnt[1] = non_zero_index_A_cnt[1] + 1

        #indexing of non_zero buffer according to the bit map operation

            

        for s in range(cycle_ratio_CEtoLE):
            if Mul_cnt[s] == 0:            
                result_mul[s] = Mul[s].operation(non_zero_buffer_A[1][non_zero_index_A_cnt[1]],non_zero_buffer_B[1][non_zero_index_B_cnt[1]])
                
                non_zero_index_B_cnt[1] = non_zero_index_B_cnt[1] + 1
                
                Mul_cnt[s] = Mul_cnt[s] + 1
                
                break
    
    if (C1 == 1 and C0 == 1):
        non_zero_A_temp_check[0] = non_zero_A_temp_check[0] + 1
        non_zero_A_temp_check[1] = non_zero_A_temp_check[1] + 1


        #indexing of non_zero buffer according to the bit map operation
        if (j == len_bitmap_buffer_B-1):
        
            for s in range(Number_of_ANDgates_per_PE):
                non_zero_index_B_cnt[s] = 0 
            non_zero_index_A_cnt[0] = non_zero_index_A_cnt[0] + 1
            non_zero_index_A_cnt[1] = non_zero_index_A_cnt[1] + 1

        print("inside the loop checking the counter values",non_zero_index_A_cnt,non_zero_index_B_cnt)

            

        for s in range(cycle_ratio_CEtoLE):
            if Mul_cnt[s] == 0:
                
                result_mul_add[s] = Mul[s].operation(non_zero_buffer_A[0][non_zero_index_A_cnt[0]],non_zero_buffer_B[0][non_zero_index_B_cnt[0]])
                non_zero_index_B_cnt[0] = non_zero_index_B_cnt[0] + 1
                Mul_cnt[s] = Mul_cnt[s] + 2
                
                break

        for s in range(cycle_ratio_CEtoLE):
            if Mul_cnt[s] == 0:
                result_mul_add[s] = Mul[s].operation(non_zero_buffer_A[1][non_zero_index_A_cnt[1]],non_zero_buffer_B[1][non_zero_index_B_cnt[1]])
                non_zero_index_B_cnt[1] = non_zero_index_B_cnt[1] + 1
                Mul_cnt[s] = Mul_cnt[s] + 1
                
                break

        for g in range(Multoadd_ratio):
            if (add_mult_cnt[g] == 0):
                add_mult_cnt[g] = add_mult_cnt[g] + 2
                break

        #indexing of non_zero buffer according to the bit map operation

    if(C1==0 and C0 == 0):
        if (j == len_bitmap_buffer_B-1):

            for s in range(Number_of_ANDgates_per_PE):
                non_zero_index_B_cnt[s] = 0
                if (non_zero_A_temp_check[s] != 0) :
                    non_zero_index_A_cnt[s] = non_zero_index_A_cnt[s] + 1
                    non_zero_A_temp_check[s] = 0
        


    for g in range(Multoadd_ratio):
        if (add_mult_cnt[g] != 0):
            add_mult_cnt[g] = add_mult_cnt[g] + 1

    for g in range(Multoadd_ratio):
        if (add_mult_cnt[g] == cycle_ratio_CEtoLE+2):
            add_mult_cnt[g] = 0
            if (add_cnt[g] == 0 and len(multiplier_adder_result) != 0):
                print("multiplier_adder_result while performing operation",multiplier_adder_result[-1],multiplier_adder_result[-2])
                result_add[g] = add[g].operation(multiplier_adder_result[-1],multiplier_adder_result[-2])
                multiplier_adder_result.pop()
                multiplier_adder_result.pop()
                add_cnt[g] = add_cnt[g] + 1
                break


    

    if (i== len_bitmap_buffer_A-1 and j == len_bitmap_buffer_B-1):
        for s in range(cycle_ratio_CEtoLE):
            if(result_mul[s]!=0):
                multiplier_result.append(result_mul[s])
        for g in range(Multoadd_ratio):
            if(len(multiplier_adder_result) != 0):
                result_add[g] = add[g].operation(multiplier_adder_result[-1],multiplier_adder_result[-2])
                multiplier_adder_result.pop()
                multiplier_adder_result.pop()
                adder_result.append(result_add[g])
                break

        for k in range(len(multiplier_result)):
            if (multiplier_result[k] == 0):
                multiplier_result[k] = adder_result[0]
                adder_result.pop(0)



    print("values for each function calling :")
    print("non_zero_index_A_cnt",non_zero_index_A_cnt)
    print("non_zero_index_B_cnt",non_zero_index_B_cnt)
    print("Mul_cnt",Mul_cnt)
    print("add_cnt",add_cnt)
    print("add_mult_cnt",add_mult_cnt)
    print("bitmap_result",bitmap_result)
    print("adder_result",adder_result)
    print("multiplier_result",multiplier_result)
    print("result_add",result_add)
    print("result_mul",result_mul)
    print("i,j",i,j)
    print("length of bit map buffer", len_bitmap_buffer_A,len_bitmap_buffer_B)
    print("result_mul_add",result_mul_add)
    print("result_add",result_add)
    print("multiplier_adder_result",multiplier_adder_result)
    print("multiplier_adder_result",multiplier_adder_result)
    print("            ")


                    
                    
    if (i== len_bitmap_buffer_A-1):
        status = 1
    else:
        status = 0

    return status 

                
        
        
            
        



        
