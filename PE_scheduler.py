def PE_scheduler(Bitmap_A,Bitmap_B,non_zero_A,non_zero_B,Number_of_ANDgates_per_PE):
    global status, completion_status
    Number_of_ANDgates_per_PE
    bitmap_buffer_A = Bitmap_A
    bitmap_buffer_B = Bitmap_B
    non_zero_buffer_A = non_zero_A
    non_zero_buffer_B = non_zero_B
    req_PEs = int(len(bitmap_buffer_A[0])/(Number_of_ANDgates_per_PE))
    available_PEs = total_PEs - req_PEs
    non_zero_count_A = 0
    non_zero_count_B = 0
    non_zero_A_divisons_per_col = [] 
    non_zero_B_divisons_per_col = []
    buffer_A_per_PE = [[[0 for k in range(Number_of_ANDgates_per_PE)] for j in range(len(bitmap_buffer_A))] for i in range(req_PEs)] #dividing the matrix vertically according to the number of and gates per PE
    buffer_B_per_PE = [[[0 for k in range(Number_of_ANDgates_per_PE)] for j in range(len(bitmap_buffer_B))] for i in range(req_PEs)] # This is for matrix B
    non_zero_A_per_PE = []
    non_zero_B_per_PE = []
    completion_status = []
    for i in range(req_PEs):
        
    #bitvalues and non-zero values assigning for matrix A
         
        for j in range(Number_of_ANDgates_per_PE):
            non_zero_temp_A = []
            non_zero_temp_B = []
            for k in range(len(bitmap_buffer_A)):
                buffer_A_per_PE[i][k][j] = bitmap_buffer_A[k][j+i*Number_of_ANDgates_per_PE]  # allocating the bitmap values to the allocated buffer per PE
                if(bitmap_buffer_A[k][j+i*Number_of_ANDgates_per_PE] != 0):
                    non_zero_temp_A.append(non_zero_buffer_A[non_zero_count_A])
                    non_zero_count_A = non_zero_count_A + 1
            non_zero_A_divisons_per_col.append(non_zero_temp_A)
                


            #bitvalues and non-zero values assigning for matrix B

            for f in range(len(bitmap_buffer_B)):
                buffer_B_per_PE[i][f][j] = bitmap_buffer_B[f][j+i*Number_of_ANDgates_per_PE]
                if(bitmap_buffer_B[f][j+i*Number_of_ANDgates_per_PE] != 0):
                    non_zero_temp_B.append(non_zero_buffer_B[non_zero_count_B])
                    non_zero_count_B = non_zero_count_B + 1
            non_zero_B_divisons_per_col.append(non_zero_temp_B)


    non_zero_temp_A_PE = []
    non_zero_temp_B_PE = []
    counter_PE_A = 0
    counter_PE_B = 0

    #assigning non-zeroes to their corresponding PEs
    for i in non_zero_A_divisons_per_col:
        non_zero_temp_A_PE.append(i)
        counter_PE_A = counter_PE_A + 1
        if counter_PE_A >= Number_of_ANDgates_per_PE:
            non_zero_A_per_PE.append(non_zero_temp_A_PE)
            non_zero_temp_A_PE = []
            counter_PE_A = 0

    for i in non_zero_B_divisons_per_col:
        non_zero_temp_B_PE.append(i)
        counter_PE_B = counter_PE_B + 1
        if counter_PE_B >= Number_of_ANDgates_per_PE:
            non_zero_B_per_PE.append(non_zero_temp_B_PE)
            non_zero_temp_B_PE = []
            counter_PE_B = 0



    #non_zero_A_per_PE, non_zero_B_per_PE provides insight which non- zeroes should go where
    #Bitmap_A_per_PE, Bitmap_B_per_PE provides insight about what are the bitmap values should go where
    #Now we should assign these values to the respective PEs and request the complete status 

    

    filled_PEs = 0
    req_PEs_counter = req_PEs
    print("req_PEs",req_PEs)
    
    #this loop can be executed in parallel in HLS
    while(req_PEs_counter !=0):
        while(filled_PEs <= available_PEs and filled_PEs != req_PEs):
            if(req_PEs <= available_PEs):
                print("buffer_A_per_PE[filled_PEs],buffer_B_per_PE[filled_PEs],non_zero_A_per_PE[filled_PEs],non_zero_B_per_PE[filled_PEs]",buffer_A_per_PE[filled_PEs],buffer_B_per_PE[filled_PEs],non_zero_A_per_PE[filled_PEs],non_zero_B_per_PE[filled_PEs])
                status = Processing_element(buffer_A_per_PE[filled_PEs],buffer_B_per_PE[filled_PEs],non_zero_A_per_PE[filled_PEs],non_zero_B_per_PE[filled_PEs])
                completion_status.append(status)
                print("completion_Status",completion_status)
                req_PEs_counter = req_PEs_counter-1
                filled_PEs = filled_PEs+1
                print("filled_PEs,req_PEs_counter",filled_PEs,req_PEs_counter)
            else:
                req_PEs_counter = available_PEs
                available_PEs = available_PEs - req_PEs
        for i in range(req_PEs):
            if(completion_status[i] == 1):
                filled_PEs = filled_PEs-1 
                    




     
    
