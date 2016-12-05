def print_list_VHDL_memory(file, word_size, list_a, final_size, fill_value):
    for i in range (final_size):
        if(i >= len(list_a)):
            file.write((("{0:0"+str(word_size)+"b}").format(fill_value)))
            file.write('\n')
        else:
            file.write((("{0:0"+str(word_size)+"b}").format(list_a[i])))
            file.write('\n')

def print_value_VHDL_memory(file, word_size, value, final_size, fill_value):
    file.write((("{0:0"+str(word_size)+"b}").format(value)))
    file.write('\n')
    final_size = final_size - 1
    if(final_size > 0):
        for i in range (final_size):
            file.write((("{0:0"+str(word_size)+"b}").format(fill_value)))
            file.write('\n')
            
def load_list_VHDL_memory(file, word_size, final_size):
    list_a = [0 for i in range(final_size)]
    for i in range (final_size):
        list_a[i] = int(file.read(word_size), base=2)
        file.read(1) # throw away the \n
    return list_a
    
def load_value_VHDL_memory(file, word_size, final_size):
    value = int(file.read(word_size), base=2)
    file.read(1) # throw away the \n
    final_size = final_size - 1
    if(final_size > 0):
        for i in range (final_size):
            file.read(word_size + 1) # throw away the filling
    return value
            
def integer_to_list(word_size, list_size, a):
    list_a = [0 for i in range(list_size)]
    internal_word_modulus = 2**(word_size)
    j = a
    for i in range(list_size):
        list_a[i] = (j)%(internal_word_modulus)
        j = j//internal_word_modulus
    return list_a

def list_to_integer(word_size, list_size, list_a):
    a = 0
    internal_word_modulus = 2**(word_size)
    for i in range(list_size-1, -1, -1):
        a = a*internal_word_modulus
        a = a + list_a[i]
    return a

def generate_base_arithmetic(word_size, prime_size_bits, number_of_bits_added, use_integer_mode, prime = 0):
    arithmetic_parameters = [0 for i in range(20)]
    if(prime == 0):
    # No prime has been chosen, generate one on the fly
        prime = random_prime(2**prime_size_bits, True, 2**(prime_size_bits-1))
    number_of_bits = (((prime_size_bits+number_of_bits_added) + (word_size-1))//word_size)*word_size
    number_of_words = number_of_bits//word_size
    
    r = 2**(number_of_bits)
    r_mod_prime = r % prime
    r2 = (r_mod_prime * r_mod_prime) % prime
    value_d,r_inverse,n_line = xgcd(r, -prime)
    if(r_inverse < 0):
        r_inverse = r_inverse + prime
    if(n_line < 0):
        n_line = n_line + r   
    
    
    arithmetic_parameters[0]  = word_size                                                # Word size
    arithmetic_parameters[1]  = prime_size_bits                                          # Prime size
    arithmetic_parameters[2]  = prime                                                    # Prime n (integer representation)
    arithmetic_parameters[3]  = integer_to_list(word_size, number_of_words, prime)       # Prime n (list representation)
    arithmetic_parameters[4]  = 2**(number_of_bits_added - 3)                            # Correction Factor during subtraction
    arithmetic_parameters[5]  = number_of_bits_added                                     # Number of bits added
    arithmetic_parameters[6]  = number_of_bits                                           # Montgomery constant R number of bits
    arithmetic_parameters[7]  = number_of_words                                          # Number of words on Montgomery constant R and others variables
    arithmetic_parameters[8]  = r                                                        # Montgomery constant R (integer representation)
    arithmetic_parameters[9]  = integer_to_list(word_size, number_of_words+1, r)         # Montgomery constant R (list representation)
    arithmetic_parameters[10] = r_mod_prime                                              # Montgomery constant R mod n (integer representation)
    arithmetic_parameters[11] = integer_to_list(word_size, number_of_words, r_mod_prime) # Montgomery constant R mod n (list representation)
    arithmetic_parameters[12] = r2                                                       # Montgomery constant R^2 mod n (integer representation)
    arithmetic_parameters[13] = integer_to_list(word_size, number_of_words, r2)          # Montgomery constant R^2 mod n (list representation)
    arithmetic_parameters[14] = r_inverse                                                # Montgomery constant R^(-1) (integer representation)
    arithmetic_parameters[15] = n_line                                                   # Montgomery constant n'     (integer representation)
    arithmetic_parameters[16] = (n_line) % (2**(word_size))                              # Montgomery constant n' mod 2^(word size) (integer representation)
    arithmetic_parameters[17] = integer_to_list(word_size, number_of_words, 1)           # Constant 1 (list representation)
    arithmetic_parameters[18] = use_integer_mode                                         # Computation mode Integer Mode (True), List Mode (False)   
    arithmetic_parameters[19] = 2**word_size                                             # Internal word modulus
    
    
    if(use_integer_mode):
        return base_arithmetic_integer(arithmetic_parameters, 0)
    return base_arithmetic_list(arithmetic_parameters, arithmetic_parameters[17])
    
    
def test_montgomery_function_single_interaction(base_arithmetic, a, b, c, d):
    n = base_arithmetic.arithmetic_parameters[2]
    r2 = base_arithmetic.arithmetic_parameters[12]
    r_inverse = base_arithmetic.arithmetic_parameters[14]
    error_computations = False
    
    ar2 = ((a*r2)*r_inverse)%(n)
    br2 = ((b*r2)*r_inverse)%(n)
    cr2 = ((c*r2)*r_inverse)%(n)
    dr2 = ((d*r2)*r_inverse)%(n)
    or2 = (ar2*br2*r_inverse)%(n)
    o = (or2*1*r_inverse)%(n)
    qr2 = (ar2*ar2*r_inverse)%(n)
    q = (qr2*1*r_inverse)%(n)
    v = (a+b)%n
    u = (a-b)%n
    s = (c+d)%n
    w = (c-d)%n
    x = ((a+b)*(c-d))%(n)
    y = ((a+b)*c-d)%(n)
    z = ((a+b)*(c+d))%(n)
    p = ((a-b)*(c+d))%(n)
    test_a   = base_arithmetic(a)
    test_b   = base_arithmetic(b)
    test_c   = base_arithmetic(c)
    test_d   = base_arithmetic(d)
    test_o   = test_a * test_b
    test_q   = test_a * test_a
    test_v   = test_a + test_b
    test_u   = test_a - test_b
    test_s   = test_c + test_d
    test_w   = test_c - test_d
    test_x1  = test_a + test_b
    test_x2  = test_c - test_d
    test_x   = test_x1 * test_x2
    test_y1  = test_a + test_b
    test_y2  = test_y1 * test_c
    test_y   = test_y2 - test_d
    test_z1  = test_a + test_b
    test_z2  = test_c + test_d
    test_z   = test_z1 * test_z2
    test_p1  = test_a - test_b
    test_p2  = test_c + test_d
    test_p   = test_p1 * test_p2
    if(o != test_o.get_value()):
        error_computations = True
    if(q != test_q.get_value()):
        error_computations = True
    if(v != test_v.get_value()):
        error_computations = True
    if(u != test_u.get_value()):
        error_computations = True
    if(s != test_s.get_value()):
        error_computations = True
    if(w != test_w.get_value()):
        error_computations = True
    if(x != test_x.get_value()):
        error_computations = True
    if(y != test_y.get_value()):
        error_computations = True
    if(z != test_z.get_value()):
        error_computations = True
    if(p != test_p.get_value()):
        error_computations = True
    if(error_computations):
        print("Seed: " + str(initial_seed()))
        print("")
        print("prime =       " + str(n))
        print("test a =      " + str(a))
        print("test b =      " + str(b))
        print("test c =      " + str(c))
        print("test d =      " + str(d))
        print("a*b")
        print("true o =                 " + str((a*b)%n))
        print("mont o =                 " + str(o))
        print("computed o =             " + str(test_o.get_value()))
        print("computed o mod prime  =  " + str(test_o.get_value() % n))
        print("a^2")
        print("true q =                 " + str((a*a)%n))
        print("mont q =                 " + str(q))
        print("computed q =             " + str(test_q.get_value()))
        print("computed q mod prime  =  " + str(test_q.get_value() % n))
        print("a+b")
        print("true v =                 " + str((a+b)%n))
        print("computed v =             " + str(test_v.get_value()))
        print("computed v mod prime  =  " + str(test_v.get_value() % n))
        print("a-b")
        print("true u =                 " + str((a-b)%n))
        print("computed u =             " + str(test_u.get_value()))
        print("computed u mod prime  =  " + str(test_u.get_value() % n))
        print("c+d")
        print("true s =                 " + str((c+d)%n))
        print("computed s =             " + str(test_s.get_value()))
        print("computed s mod prime  =  " + str(test_s.get_value() % n))
        print("c-d")
        print("true w =                 " + str((c-d)%n))
        print("computed w =             " + str(test_w.get_value()))
        print("computed w mod prime  =  " + str(test_w.get_value() % n))
        print("(a+b)*(c-d)")
        print("true x =                 " + str(((a+b)*(c-d))%n))
        print("computed x =             " + str(test_x.get_value()))
        print("computed x mod prime  =  " + str(test_x.get_value() % n))
        print("(a+b)*c-d")
        print("true y =                 " + str(((a+b)*c-d)%n))
        print("computed y =             " + str(test_y.get_value()))
        print("computed y mod prime  =  " + str(test_y.get_value() % n))
        print("(a+b)*(c+d)")
        print("true z =                 " + str(((a+b)*(c+d))%n))
        print("computed z =             " + str(test_z.get_value()))
        print("computed z mod prime  =  " + str(test_z.get_value() % n))
        print("(a-b)*(c+d)")
        print("true p =                 " + str(((a-b)*(c+d))%n))
        print("computed p =             " + str(test_p.get_value()))
        print("computed p mod prime  =  " + str(test_p.get_value() % n))
        print("")
        return 1
    return 0

def test_montgomery_function_special_mode_single_interaction(base_arithmetic, extended_arithmetic, a, b, c, d):
    n = base_arithmetic.arithmetic_parameters[2]
    r2 = base_arithmetic.arithmetic_parameters[12]
    test_r2 = extended_arithmetic.get_r2()
    test_1 = base_arithmetic.get_1()
    r_inverse = base_arithmetic.arithmetic_parameters[14]
    error_computations = False
    
    ar2 = ((a*r2)*r_inverse)%(n)
    br2 = ((b*r2)*r_inverse)%(n)
    cr2 = ((c*r2)*r_inverse)%(n)
    dr2 = ((d*r2)*r_inverse)%(n)
    or2 = (ar2*br2*r_inverse)%(n)
    o = (or2*1*r_inverse)%(n)
    qr2 = (ar2*ar2*r_inverse)%(n)
    q = (qr2*1*r_inverse)%(n)
    v = (a+b)%n
    u = (a-b)%n
    s = (c+d)%n
    w = (c-d)%n
    x = ((a+b)*(c-d))%(n)
    y = ((a+b)*c-d)%(n)
    z = ((a+b)*(c+d))%(n)
    p = ((a-b)*(c+d))%(n)
    test_a = extended_arithmetic(a)
    test_b = extended_arithmetic(b)
    test_c = extended_arithmetic(c)
    test_d = extended_arithmetic(d)
    test_ar2 = test_a * test_r2
    test_br2 = test_b * test_r2
    test_cr2 = test_c * test_r2
    test_dr2 = test_d * test_r2
    test_or2 = test_ar2 * test_br2
    test_o   = base_arithmetic(test_or2.get_value(True)) * test_1
    test_qr2 = test_ar2 * test_ar2
    test_q   = base_arithmetic(test_qr2.get_value(True)) * test_1
    test_vr2 = test_ar2 + test_br2
    test_v = base_arithmetic(test_vr2.get_value(True)) * test_1
    test_ur2 = test_ar2 - test_br2
    test_u = base_arithmetic(test_ur2.get_value(True)) * test_1
    test_sr2 = test_cr2 + test_dr2
    test_s = base_arithmetic(test_sr2.get_value(True)) * test_1
    test_wr2 = test_cr2 - test_dr2
    test_w = base_arithmetic(test_wr2.get_value(True)) * test_1
    test_x1r2 = test_ar2 + test_br2
    test_x2r2 = test_cr2 - test_dr2
    test_xr2 = test_x1r2 * test_x2r2
    test_x = base_arithmetic(test_xr2.get_value(True)) * test_1
    test_y1r2 = test_ar2 + test_br2
    test_y2r2 = test_y1r2 * test_cr2
    test_yr2 = test_y2r2 - test_dr2
    test_y = base_arithmetic(test_yr2.get_value(True)) * test_1
    test_z1r2 = test_ar2 + test_br2
    test_z2r2 = test_cr2 + test_dr2
    test_zr2 = test_z1r2 * test_z2r2
    test_z = base_arithmetic(test_zr2.get_value(True)) * test_1
    test_p1r2 = test_ar2 - test_br2
    test_p2r2 = test_cr2 + test_dr2
    test_pr2 = test_p1r2 * test_p2r2
    test_p = base_arithmetic(test_pr2.get_value(True)) * test_1
    if(o != test_o.value_integer):
        error_computations = True
    if(q != test_q.value_integer):
        error_computations = True
    if(v != test_v.value_integer):
        error_computations = True
    if(u != test_u.value_integer):
        error_computations = True
    if(s != test_s.value_integer):
        error_computations = True
    if(w != test_w.value_integer):
        error_computations = True
    if(x != test_x.value_integer):
        error_computations = True
    if(y != test_y.value_integer):
        error_computations = True
    if(z != test_z.value_integer):
        error_computations = True
    if(p != test_p.value_integer):
        error_computations = True
    if(error_computations):
        print("Seed: " + str(initial_seed()))
        print("")
        print("prime =       " + str(n))
        print("test a =      " + str(a))
        print("test b =      " + str(b))
        print("test c =      " + str(c))
        print("test d =      " + str(d))
        print("a*b")
        print("true o =                 " + str((a*b)%n))
        print("mont o =                 " + str(o))
        print("computed o =             " + str(test_o.value_integer))
        print("computed o mod prime  =  " + str(test_o.value_integer % n))
        print("a^2")
        print("true q =                 " + str((a*a)%n))
        print("mont q =                 " + str(q))
        print("computed q =             " + str(test_q.value_integer))
        print("computed q mod prime  =  " + str(test_q.value_integer % n))
        print("a+b")
        print("true v =                 " + str((a+b)%n))
        print("computed v =             " + str(test_v.value_integer))
        print("computed v mod prime  =  " + str(test_v.value_integer % n))
        print("a-b")
        print("true u =                 " + str((a-b)%n))
        print("computed u =             " + str(test_u.value_integer))
        print("computed u mod prime  =  " + str(test_u.value_integer % n))
        print("c+d")
        print("true s =                 " + str((c+d)%n))
        print("computed s =             " + str(test_s.value_integer))
        print("computed s mod prime  =  " + str(test_s.value_integer % n))
        print("c-d")
        print("true w =                 " + str((c-d)%n))
        print("computed w =             " + str(test_w.value_integer))
        print("computed w mod prime  =  " + str(test_w.value_integer % n))
        print("(a+b)*(c-d)")
        print("true x =                 " + str(((a+b)*(c-d))%n))
        print("computed x =             " + str(test_x.value_integer))
        print("computed x mod prime  =  " + str(test_x.value_integer % n))
        print("(a+b)*c-d")
        print("true y =                 " + str(((a+b)*c-d)%n))
        print("computed y =             " + str(test_y.value_integer))
        print("computed y mod prime  =  " + str(test_y.value_integer % n))
        print("(a+b)*(c+d)")
        print("true z =                 " + str(((a+b)*(c+d))%n))
        print("computed z =             " + str(test_z.value_integer))
        print("computed z mod prime  =  " + str(test_z.value_integer % n))
        print("(a-b)*(c+d)")
        print("true p =                 " + str(((a-b)*(c+d))%n))
        print("computed p =             " + str(test_p.value_integer))
        print("computed p mod prime  =  " + str(test_p.value_integer % n))
        print("")
        return 1
    return 0

def test_montgomery_function_biggest_value(word_size, prime_size_bits, number_of_bits_added, integer_mode=False, n=0):
    base_arithmetic = generate_base_arithmetic(word_size, prime_size_bits, number_of_bits_added, integer_mode, n)
    n = base_arithmetic.get_prime()
    
    a = n-1
    b = n-1
    c = n-1
    d = 0
    
    test_montgomery_function_single_interaction(base_arithmetic, a, b, c, d)
    print "Finished"


def test_montgomery_function(word_size, prime_size_bits, number_of_bits_added, number_of_tests, integer_mode=False, n=0):
    base_arithmetic = generate_base_arithmetic(word_size, prime_size_bits, number_of_bits_added, integer_mode, n)
    n = base_arithmetic.get_prime()
    number_of_errors = 0
    if(integer_mode):
        print "Starting " + str(number_of_tests) + " tests in Integer Mode"
    else:
        print "Starting " + str(number_of_tests) + " tests in List Mode"

    for i in xrange(number_of_tests):
        if((i % 1000) == 0):
            print "Iteration " + str(i)
        a = Integer(randrange(0,n))
        b = Integer(randrange(0,n))
        c = Integer(randrange(0,n))
        d = Integer(randrange(0,n))
        
        number_of_errors += test_montgomery_function_single_interaction(base_arithmetic, a, b, c, d)
    print "Number of errors " + str(number_of_errors)
    print "Finished"

def test_montgomery_function_special_mode(word_size, prime_size_bits, number_of_bits_added, number_of_tests, integer_mode=False, n=0):
    base_arithmetic = generate_base_arithmetic(word_size, prime_size_bits, number_of_bits_added + word_size, integer_mode, n)
    n = base_arithmetic.get_prime()
    n_line_zero = base_arithmetic.arithmetic_parameters[16]
    special_n = n * n_line_zero
    extended_arithmetic = generate_base_arithmetic(word_size, prime_size_bits+word_size, number_of_bits_added, integer_mode, special_n)
    number_of_errors = 0
    if(integer_mode):
        print "Starting " + str(number_of_tests) + " tests in Integer Mode"
    else:
        print "Starting " + str(number_of_tests) + " tests in List Mode"
    for i in range(number_of_tests):
        if((i % 1000) == 0):
            print "Iteration " + str(i)
        a = Integer(randrange(0,n))
        b = Integer(randrange(0,n))
        c = Integer(randrange(0,n))
        d = Integer(randrange(0,n))
        
        number_of_errors += test_montgomery_function_special_mode_single_interaction(base_arithmetic, extended_arithmetic, a, b, c, d)
    print "Number of errors " + str(number_of_errors)
    print "Finished"

    
def print_VHDL_finite_field_tests(VHDL_memory_file_name, base_arithmetic, VHDL_values_address_file_name=""):
    
    VHDL_memory_file = open(VHDL_memory_file_name, 'w')
    if VHDL_values_address_file_name:
        VHDL_values_address_file = open(VHDL_values_address_file_name, 'w')
        begin_name_position_string = "external_memory_base_address_"
        end_name_position_string = " : integer := "
        end_number_position_string = ";"

    word_size = base_arithmetic.arithmetic_parameters[0]
    Montgomery_n = base_arithmetic.arithmetic_parameters[2]
    Montgomery_r = base_arithmetic.arithmetic_parameters[8]
    Montgomery_list_n = base_arithmetic.arithmetic_parameters[3]
    Montgomery_n_num_words = base_arithmetic.arithmetic_parameters[7]
    Montgomery_r2 = base_arithmetic.arithmetic_parameters[12]
    Montgomery_r_inverse = base_arithmetic.arithmetic_parameters[14]
    Montgomery_list_r2 = base_arithmetic.arithmetic_parameters[13]
    Montgomery_n_line_zero = base_arithmetic.arithmetic_parameters[16]
    Montgomery_list_1 = base_arithmetic.arithmetic_parameters[17]
    
    Test_a = Integer(randrange(0,Montgomery_n))
    Test_b = Integer(randrange(0,Montgomery_n))
    Test_c = Integer(randrange(0,Montgomery_n))
    Test_d = Integer(randrange(0,Montgomery_n))
    #print("Test value a = " + str(Test_a))
    #print("Test value b = " + str(Test_b))
    #print("Test value c = " + str(Test_c))
    #print("Test value d = " + str(Test_d))
    Test_ar2 = ((Test_a*Montgomery_r2)*Montgomery_r_inverse)%(Montgomery_n)
    Test_br2 = ((Test_b*Montgomery_r2)*Montgomery_r_inverse)%(Montgomery_n)
    Test_cr2 = ((Test_c*Montgomery_r2)*Montgomery_r_inverse)%(Montgomery_n)
    Test_dr2 = ((Test_d*Montgomery_r2)*Montgomery_r_inverse)%(Montgomery_n)
    Test_o = ((Test_a+Test_b)*(Test_c-Test_d))%(Montgomery_n)
    Test_y = Test_cr2 - Test_dr2
    if(Test_y < 0):
        Test_y = Test_y + Montgomery_r
    list_y = integer_to_list(word_size, Montgomery_n_num_words, Test_y)
    list_a = base_arithmetic(Test_a)
    list_b = base_arithmetic(Test_b)
    list_c = base_arithmetic(Test_c)
    list_d = base_arithmetic(Test_d)

    list_ar2 = list_a.get_value(False, False)
    list_br2 = list_b.get_value(False, False)
    list_cr2 = list_c.get_value(False, False)
    list_dr2 = list_d.get_value(False, False)
    list_o1 = list_a + list_b
    list_o1r2 = list_o1.get_value(False, False)
    list_o2 = list_c - list_d
    list_o2r2 = list_o2.get_value(False, False)
    list_o = list_o1 * list_o2
    list_or2 = list_o.get_value(False, False)
    list_a = list_a.get_value(True, False)
    list_b = list_b.get_value(True, False)
    list_c = list_c.get_value(True, False)
    list_d = list_d.get_value(True, False)
    list_o = list_o.get_value(True, False)
    if VHDL_values_address_file_name:
        position = 0
        VHDL_values_address_file.write(begin_name_position_string + "n" + end_name_position_string + str(position) + end_number_position_string + "\n")
    print_list_VHDL_memory(VHDL_memory_file, word_size, Montgomery_list_n, Montgomery_n_num_words, 0)
    if VHDL_values_address_file_name:
        position += Montgomery_n_num_words
        VHDL_values_address_file.write(begin_name_position_string + "n_line" + end_name_position_string + str(position) + end_number_position_string + "\n")
    print_value_VHDL_memory(VHDL_memory_file, word_size, Montgomery_n_line_zero, 1, 0)
    if VHDL_values_address_file_name:
        position += 1
        VHDL_values_address_file.write(begin_name_position_string + "r2" + end_name_position_string + str(position) + end_number_position_string + "\n")
    print_list_VHDL_memory(VHDL_memory_file, word_size, Montgomery_list_r2, Montgomery_n_num_words, 0)
    if VHDL_values_address_file_name:
        position += Montgomery_n_num_words
        VHDL_values_address_file.write(begin_name_position_string + "1" + end_name_position_string + str(position) + end_number_position_string + "\n")
    print_list_VHDL_memory(VHDL_memory_file, word_size, Montgomery_list_1, Montgomery_n_num_words, 0)
    if VHDL_values_address_file_name:
        position += Montgomery_n_num_words
        VHDL_values_address_file.write(begin_name_position_string + "a" + end_name_position_string + str(position) + end_number_position_string + "\n")
    print_list_VHDL_memory(VHDL_memory_file, word_size, list_a, Montgomery_n_num_words, 0)
    if VHDL_values_address_file_name:
        position += Montgomery_n_num_words
        VHDL_values_address_file.write(begin_name_position_string + "b" + end_name_position_string + str(position) + end_number_position_string + "\n")
    print_list_VHDL_memory(VHDL_memory_file, word_size, list_b, Montgomery_n_num_words, 0)
    if VHDL_values_address_file_name:
        position += Montgomery_n_num_words
        VHDL_values_address_file.write(begin_name_position_string + "c" + end_name_position_string + str(position) + end_number_position_string + "\n")
    print_list_VHDL_memory(VHDL_memory_file, word_size, list_c, Montgomery_n_num_words, 0)
    if VHDL_values_address_file_name:
        position += Montgomery_n_num_words
        VHDL_values_address_file.write(begin_name_position_string + "d" + end_name_position_string + str(position) + end_number_position_string + "\n")
    print_list_VHDL_memory(VHDL_memory_file, word_size, list_d, Montgomery_n_num_words, 0)
    if VHDL_values_address_file_name:
        position += Montgomery_n_num_words
        VHDL_values_address_file.write(begin_name_position_string + "ar2" + end_name_position_string + str(position) + end_number_position_string + "\n")
    print_list_VHDL_memory(VHDL_memory_file, word_size, list_ar2, Montgomery_n_num_words, 0)
    if VHDL_values_address_file_name:
        position += Montgomery_n_num_words
        VHDL_values_address_file.write(begin_name_position_string + "br2" + end_name_position_string + str(position) + end_number_position_string + "\n")
    print_list_VHDL_memory(VHDL_memory_file, word_size, list_br2, Montgomery_n_num_words, 0)
    if VHDL_values_address_file_name:
        position += Montgomery_n_num_words
        VHDL_values_address_file.write(begin_name_position_string + "cr2" + end_name_position_string + str(position) + end_number_position_string + "\n")
    print_list_VHDL_memory(VHDL_memory_file, word_size, list_cr2, Montgomery_n_num_words, 0)
    if VHDL_values_address_file_name:
        position += Montgomery_n_num_words
        VHDL_values_address_file.write(begin_name_position_string + "dr2" + end_name_position_string + str(position) + end_number_position_string + "\n")
    print_list_VHDL_memory(VHDL_memory_file, word_size, list_dr2, Montgomery_n_num_words, 0)
    if VHDL_values_address_file_name:
        position += Montgomery_n_num_words
        VHDL_values_address_file.write(begin_name_position_string + "ar2_br2" + end_name_position_string + str(position) + end_number_position_string + "\n")
    print_list_VHDL_memory(VHDL_memory_file, word_size, list_o1r2, Montgomery_n_num_words, 0)
    if VHDL_values_address_file_name:
        position += Montgomery_n_num_words
        VHDL_values_address_file.write(begin_name_position_string + "cr2_dr2" + end_name_position_string + str(position) + end_number_position_string + "\n")
    print_list_VHDL_memory(VHDL_memory_file, word_size, list_o2r2, Montgomery_n_num_words, 0)
    if VHDL_values_address_file_name:
        position += Montgomery_n_num_words
        VHDL_values_address_file.write(begin_name_position_string + "or2" + end_name_position_string + str(position) + end_number_position_string + "\n")
    print_list_VHDL_memory(VHDL_memory_file, word_size, list_or2, Montgomery_n_num_words, 0)
    if VHDL_values_address_file_name:
        position += Montgomery_n_num_words
        VHDL_values_address_file.write(begin_name_position_string + "o" + end_name_position_string + str(position) + end_number_position_string + "\n")
    print_list_VHDL_memory(VHDL_memory_file, word_size, list_o, Montgomery_n_num_words, 0)
    if VHDL_values_address_file_name:
        position += Montgomery_n_num_words
        VHDL_values_address_file.write(begin_name_position_string + "y" + end_name_position_string + str(position) + end_number_position_string + "\n")
    print_list_VHDL_memory(VHDL_memory_file, word_size, list_y, Montgomery_n_num_words, 0)
    if VHDL_values_address_file_name:
        VHDL_values_address_file.close()
    VHDL_memory_file.close()
    #print("Finished")
    
def print_VHDL_all_finite_field_tests(begin_field_size, end_field_size, word_size, number_of_bits_added=5):
    biggest_begin_field_size = ((begin_field_size + (word_size - 1))//word_size)*word_size - number_of_bits_added
    biggest_end_field_size = ((end_field_size + (word_size - 1))//word_size)*word_size - number_of_bits_added
    begin_file_name = "finite_field_"
    end_memory_file_name = "_test.dat"
    end_values_address_file_name = "_test_address.dat"
    for i in range(biggest_begin_field_size, (biggest_end_field_size + word_size), word_size):
        VHDL_values_address_file_name = begin_file_name + str(i-(word_size-1)) + "_to_" + str(i) + end_values_address_file_name
        VHDL_memory_file_name = begin_file_name + str(i-(word_size-1)) + "_to_" + str(i) + end_memory_file_name
        base_arithmetic = generate_base_arithmetic(word_size, i, number_of_bits_added, False)
        print_VHDL_finite_field_tests(VHDL_memory_file_name, base_arithmetic, VHDL_values_address_file_name)
    print("Finished")
    
def print_VHDL_all_extensive_finite_field_tests(number_of_tests, begin_field_size, end_field_size, word_size, number_of_bits_added=5):
    biggest_begin_field_size = ((begin_field_size + (word_size - 1))//word_size)*word_size - number_of_bits_added
    biggest_end_field_size = ((end_field_size + (word_size - 1))//word_size)*word_size - number_of_bits_added
    begin_folder_name = "finite_field_"
    end_folder_name = "_extensive_tests"
    begin_file_name = "finite_field_"
    middle_memory_file_name = "_test_"
    end_memory_file_name = ".dat"
    for i in range(biggest_begin_field_size, (biggest_end_field_size + word_size), word_size):
        VHDL_folder_name = begin_folder_name + str(i-(word_size-1)) + "_to_" + str(i) + end_folder_name
        if not os.path.isdir(VHDL_folder_name):
            os.makedirs(VHDL_folder_name)
        for j in range(number_of_tests):
            VHDL_memory_file_name = VHDL_folder_name + "/" + begin_file_name + str(i-(word_size-1)) + "_to_" + str(i) + middle_memory_file_name + str(j) + end_memory_file_name
            base_arithmetic = generate_base_arithmetic(word_size, i, number_of_bits_added, False)
            print_VHDL_finite_field_tests(VHDL_memory_file_name, base_arithmetic)
    print("Finished")
    
def load_VHDL_finite_field_tests(VHDL_memory_file_name, word_size, prime_size_bits, number_of_bits_added):
    VHDL_load_file = open(VHDL_memory_file_name, 'r')
    
    error_computations = False
    
    number_of_bits = (((prime_size_bits+number_of_bits_added) + (word_size-1))//word_size)*word_size
    Montgomery_n_num_words = number_of_bits//word_size
    
    Montgomery_list_n = load_list_VHDL_memory(VHDL_load_file, word_size, Montgomery_n_num_words)
    Montgomery_n = list_to_integer(word_size, Montgomery_n_num_words, Montgomery_list_n)
    
    base_arithmetic = generate_base_arithmetic(word_size, prime_size_bits, number_of_bits_added, False, Montgomery_n)
    
    Montgomery_n_line_zero = load_value_VHDL_memory(VHDL_load_file, word_size, 1)
    Montgomery_list_r2 = load_list_VHDL_memory(VHDL_load_file, word_size, Montgomery_n_num_words)
    Montgomery_list_1 = load_list_VHDL_memory(VHDL_load_file, word_size, Montgomery_n_num_words)

    list_a    = load_list_VHDL_memory(VHDL_load_file, word_size, Montgomery_n_num_words)
    list_b    = load_list_VHDL_memory(VHDL_load_file, word_size, Montgomery_n_num_words)
    list_c    = load_list_VHDL_memory(VHDL_load_file, word_size, Montgomery_n_num_words)
    list_d    = load_list_VHDL_memory(VHDL_load_file, word_size, Montgomery_n_num_words)
    
    list_ar2  = load_list_VHDL_memory(VHDL_load_file, word_size, Montgomery_n_num_words)
    list_br2  = load_list_VHDL_memory(VHDL_load_file, word_size, Montgomery_n_num_words)
    list_cr2  = load_list_VHDL_memory(VHDL_load_file, word_size, Montgomery_n_num_words)
    list_dr2  = load_list_VHDL_memory(VHDL_load_file, word_size, Montgomery_n_num_words)
    list_o1r2 = load_list_VHDL_memory(VHDL_load_file, word_size, Montgomery_n_num_words)
    list_o2r2 = load_list_VHDL_memory(VHDL_load_file, word_size, Montgomery_n_num_words)
    list_or2  = load_list_VHDL_memory(VHDL_load_file, word_size, Montgomery_n_num_words)
    list_o    = load_list_VHDL_memory(VHDL_load_file, word_size, Montgomery_n_num_words)
    
    VHDL_load_file.close()
    
    test_list_a = base_arithmetic(list_a)
    test_list_b = base_arithmetic(list_b)
    test_list_c = base_arithmetic(list_c)
    test_list_d = base_arithmetic(list_d)
    
    
    test_list_ar2  = test_list_a.get_value(False, False)
    test_list_br2  = test_list_b.get_value(False, False)
    test_list_cr2  = test_list_c.get_value(False, False)
    test_list_dr2  = test_list_d.get_value(False, False)
    test_list_o1   = test_list_a + test_list_b
    test_list_o1r2 = test_list_o1.get_value(False, False)
    test_list_o2   = test_list_c - test_list_d
    test_list_o2r2 = test_list_o2.get_value(False, False)
    test_list_o    = test_list_o1*test_list_o2
    test_list_or2  = test_list_o.get_value(False, False)
    test_list_o    = test_list_o.get_value(True, False)
    
    if(list_ar2  != test_list_ar2):
        error_computations = True
    if(list_br2  != test_list_br2):
        error_computations = True
    if(list_cr2  != test_list_cr2):
        error_computations = True
    if(list_dr2  != test_list_dr2):
        error_computations = True
    if(list_o1r2 != test_list_o1r2):
        error_computations = True
    if(list_o2r2 != test_list_o2r2):
        error_computations = True
    if(list_or2  != test_list_or2):
        error_computations = True
    if(list_o    != test_list_o):
        error_computations = True
    if(error_computations):
        print("Seed: " + str(initial_seed()))
        print("")
        print("prime =       " + str(Montgomery_n))
        print("test a =      " + str(list_a))
        print("test b =      " + str(list_b))
        print("test c =      " + str(list_c))
        print("test d =      " + str(list_d))
        print("ar2 = a*r2")
        print("file ar2 =                 " + str(list_ar2))
        print("computed ar2 =             " + str(test_list_ar2))
        print("br2 = b*r2")
        print("file br2 =                 " + str(list_br2))
        print("computed br2 =             " + str(test_list_br2))
        print("cr2 = c*r2")
        print("file cr2 =                 " + str(list_cr2))
        print("computed cr2 =             " + str(test_list_cr2))
        print("dr2 = d*r2")
        print("file dr2 =                 " + str(list_dr2))
        print("computed dr2 =             " + str(test_list_dr2))
        print("o1r2 = ar2+br2")
        print("file o1r2 =                " + str(list_o1r2))
        print("computed o1r2 =            " + str(test_list_o1r2))
        print("o2r2 = cr2-dr2")
        print("file o2r2 =                " + str(list_o2r2))
        print("computed o2r2 =            " + str(test_list_o2r2))
        print("or2 = o1r2*o2r2")
        print("file or2 =                 " + str(list_or2))
        print("computed or2 =             " + str(test_list_or2))
        print("o = or2*1")
        print("file o =                   " + str(list_o))
        print("computed o =               " + str(test_list_o))
        print("")


class base_arithmetic_integer:
                   
    def value_to_VHDL_memory_string(self, final_size, fill_value):
        word_size = self.arithmetic_parameters[0]
        result = ""
        for i in range (final_size):
            if(i >= len(self.value_list)):
                result += (("{0:0"+str(word_size)+"b}").format(fill_value))
                result += '\n'
            else:
                result += (("{0:0"+str(word_size)+"b}").format(self.value_list[i]))
                result += '\n'
        return result    
    
    def __init__(self, arithmetic_parameters, value=0, enterDomain=True):
        # Copy arithmetic parameters
        self.arithmetic_parameters = list(arithmetic_parameters)
        self.value = value
        
        if(isinstance(value, base_arithmetic_integer)):
            self.value = value.value
            enterDomain = False
        elif(isinstance(value, list)):
            self.value = list_to_integer(arithmetic_parameters[0], arithmetic_parameters[7], value)
        else:
            self.value = value
        
        if(enterDomain):
            self.value = self._montgomery_enter_domain(self.value)
        
    def __call__(self, value=0, enterDomain=True):
        return self.__class__(self.arithmetic_parameters, value, enterDomain)
    
    def __str__(self):
        return str(self._montgomery_remove_domain(self.value))
            
    def __repr__(self):
        return self.__str__()
        
    def __add__(self, other):
        result = self._montgomery_addition(self.value, other.value)
        return self.__class__(self.arithmetic_parameters, result, False)
        
    def __sub__(self, other):
        result = self._montgomery_subtraction(self.value, other.value)
        return self.__class__(self.arithmetic_parameters, result, False)
        
    def __mul__(self, other):
        if(self.value == other.value):
            result = self._montgomery_squaring(self.value)
        else:
            result = self._montgomery_multiplication(self.value, other.value)
        return self.__class__(self.arithmetic_parameters, result, False)
        
    def __div__(self, other):
        divisor = other._montgomery_inversion(other.value)
        result = self._montgomery_multiplication(self.value, divisor)
        return self.__class__(self.arithmetic_parameters, result, False)
    
    def __floordiv__(self, other):
        divisor = other._montgomery_inversion(other.value)
        result = self._montgomery_multiplication(self.value, divisor)
        return self.__class__(self.arithmetic_parameters, result, False)
        
    def __pow__(self, other):
        if(other < 0):
            result = self._montgomery_inversion(self.value)
            other = 0 - other
        else:
            result = self.value
        if(other == 0):
            result = self.arithmetic_parameters[10]
        elif(other == 2):
            result = self._montgomery_squaring(result)
        elif(other != 1):
            result = self._montgomery_exponentiation(result, other)
        return self.__class__(self.arithmetic_parameters, result, False)

    def get_prime(self):
        return self.arithmetic_parameters[2]
        
    def get_value(self, removeDomain=True):
        if(removeDomain):
            return self._montgomery_remove_domain(self.value)
        else:
            return self.value
        
    def _montgomery_multiplication(self, a, b):
        r = self.arithmetic_parameters[8]
        n = self.arithmetic_parameters[2]
        n_line = self.arithmetic_parameters[15]
        r_inverse = self.arithmetic_parameters[14]
        product = a*b
        m = (product*n_line) % r
        result = ((product + n*m)//r) % r
        return result
    
    def _montgomery_squaring(self, a):
        r = self.arithmetic_parameters[8]
        n = self.arithmetic_parameters[2]
        n_line = self.arithmetic_parameters[15]
        r_inverse = self.arithmetic_parameters[14]
        product = (a)**2
        m = (product*n_line) % r
        result = ((product + n*m)//r) % r
        return result
           
    def _montgomery_addition(self, a, b):
        r = self.arithmetic_parameters[8]
        n = self.arithmetic_parameters[2]
        result = (a+b) % r
        return result

    def _montgomery_subtraction(self, a, b):
        r = self.arithmetic_parameters[8]
        n = self.arithmetic_parameters[2]
        normalization_factor = self.arithmetic_parameters[4] 
        result = (a-b+normalization_factor*n) % r
        return result
    
    def _montgomery_enter_domain(self, a):
        r2 = self.arithmetic_parameters[12]
        result = self._montgomery_multiplication(a, r2)
        return result

    def _montgomery_remove_domain(self, a):    
        result = self._montgomery_multiplication(a, 1)
        return result
        
    def _montgomery_exponentiation(self, a, expoent):
        square = a
        result = self.arithmetic_parameters[10]
        while expoent != 0:
            if(Mod(expoent,2) == 1):
                result = self._montgomery_multiplication(result, square)
            square = self._montgomery_squaring(square)
            expoent = expoent//2
        return result
        
    def _montgomery_inversion(self, a):
        expoent = self.arithmetic_parameters[2] - 2
        result = self._montgomery_exponentiation(a, expoent)   
        return result
        
        
class base_arithmetic_list:
                   
    def value_to_VHDL_memory_string(self, final_size, fill_value):
        word_size = self.arithmetic_parameters[0]
        result = ""
        for i in range (final_size):
            if(i >= len(self.value_list)):
                result += (("{0:0"+str(word_size)+"b}").format(fill_value))
                result += '\n'
            else:
                result += (("{0:0"+str(word_size)+"b}").format(self.value_list[i]))
                result += '\n'
        return result    
    
    def __init__(self, arithmetic_parameters, value=[0], enterDomain=True):
        # Define which internal functions to use
        self._montgomery_multiplication = self._montgomery_multiplication_CIOS
        self._montgomery_squaring = self._montgomery_squaring_multiplication
        
        # Copy arithmetic parameters
        self.arithmetic_parameters = list(arithmetic_parameters)
        if(isinstance(value, base_arithmetic_list)):
            self.value = list(value.value)
            enterDomain = False
        elif(isinstance(value, list)):
            self.value = list(value)
        else:
            self.value = integer_to_list(arithmetic_parameters[0], arithmetic_parameters[7], value)
        
        if(enterDomain):
            self.value = self._montgomery_enter_domain(self.value)
        
    def __call__(self, value=0, enterDomain=True):
        return self.__class__(self.arithmetic_parameters, value, enterDomain)
    
    def __str__(self):
        return str(list_to_integer(self.arithmetic_parameters[0], self.arithmetic_parameters[7], self._montgomery_remove_domain(self.value)))
            
    def __repr__(self):
        return self.__str__()
        
    def __add__(self, other):
        result = self._montgomery_addition(self.value, other.value)
        return self.__class__(self.arithmetic_parameters, result, False)
        
    def __sub__(self, other):
        result = self._montgomery_subtraction(self.value, other.value)
        return self.__class__(self.arithmetic_parameters, result, False)
        
    def __mul__(self, other):
        if(self.value == other.value):
            result = self._montgomery_squaring(self.value)
        else:
            result = self._montgomery_multiplication(self.value, other.value)
        return self.__class__(self.arithmetic_parameters, result, False)

    def __div__(self, other):
        divisor = other._montgomery_inversion(other.value)
        result = self._montgomery_multiplication(self.value, divisor)
        return self.__class__(self.arithmetic_parameters, result, False)
        
    def __floordiv__(self, other):
        divisor = other._montgomery_inversion(other.value)
        result = self._montgomery_multiplication(self.value, divisor)
        return self.__class__(self.arithmetic_parameters, result, False)
        
    def __pow__(self, other):
        if(other < 0):
            result = self._montgomery_inversion(self.value)
            other = 0 - other
        else:
            result = self.value
        if(other == 0):
            result = self.arithmetic_parameters[11]
        elif(other == 2):
            result = self._montgomery_squaring(result)
        elif(other != 1):
            result = self._montgomery_exponentiation(result, other)
        return self.__class__(self.arithmetic_parameters, result, False)
          
    def get_value(self, removeDomain=True, integerMode=True):
        if(removeDomain):
            result = self._montgomery_remove_domain(self.value)
        else:
            result = self.value
        if(integerMode):
            return list_to_integer(self.arithmetic_parameters[0], self.arithmetic_parameters[7], result)
        return result
    
    def get_prime(self):
        return self.arithmetic_parameters[2]

    def _montgomery_multiplication_CIOS(self, a, b):
        word_size = self.arithmetic_parameters[0]
        internal_word_modulus = self.arithmetic_parameters[19]
        num_words = self.arithmetic_parameters[7]
        n = self.arithmetic_parameters[3]
        n_line_zero = self.arithmetic_parameters[16]
        t = [0 for i in range(num_words)]
        t_carry_0 = 0
        t_carry_1 = 0
        C = 0
        C_S = 0
        m = 0
        for i in range(num_words):
            C = 0
            for j in range(num_words):
                C_S = t[j] + a[j]*b[i] + C
                t[j] = C_S%(internal_word_modulus)
                C = C_S//(internal_word_modulus)
            C_S = t_carry_0 + C
            C = C_S//(internal_word_modulus)
            t_carry_0 = C_S%(internal_word_modulus)
            t_carry_1 = C
            m = ((t[0] * n_line_zero))%(internal_word_modulus)
            C_S = t[0] + m*n[0]
            C = C_S//(internal_word_modulus)
            for j in range(1, num_words):
                C_S = t[j] + m*n[j] + C
                t[j-1] = C_S%(internal_word_modulus)
                C = C_S//(internal_word_modulus)
            C_S = t_carry_0 + C
            t[num_words-1] = C_S%(internal_word_modulus)
            C = C_S//(internal_word_modulus)
            t_carry_0 = t_carry_1 + C
        return t
    
    def _montgomery_multiplication_FIOS(self, a, b):
        word_size = self.arithmetic_parameters[0]
        num_words = self.arithmetic_parameters[7]
        internal_word_modulus = self.arithmetic_parameters[19]
        n = self.arithmetic_parameters[3]
        n_line_zero = self.arithmetic_parameters[16]
        t = [0 for i in range(num_words)]
        t_carry_0 = 0
        C1 = 0
        C2 = 0
        C_S = 0
        S = 0
        m = 0
        for i in range(num_words):
            C_S = t[0] + a[0]*b[i]
            S = C_S%(internal_word_modulus)
            C1 = C_S//(internal_word_modulus)
            m = ((S * n_line_zero))%(internal_word_modulus)
            C_S = S + n[0]*m
            C2 = C_S//(internal_word_modulus)
            for j in range(1,num_words):
                C_S = t[j] + a[j]*b[i] + C1
                S = C_S%(internal_word_modulus)
                C1 = C_S//(internal_word_modulus)
                C_S = S + n[j]*m + C2
                t[j-1] = C_S%(internal_word_modulus)
                C2 = C_S//(internal_word_modulus)
            C_S = t_carry_0 + C1
            S = C_S%(internal_word_modulus)
            C1 = C_S//(internal_word_modulus)
            C_S = S + C2
            t[num_words-1] = C_S%(internal_word_modulus)
            C2 = C_S//(internal_word_modulus)
            t_carry_0 = C1+C2
        return t
    
    def _montgomery_multiplication_SOS(self, a, b):
        word_size = self.arithmetic_parameters[0]
        internal_word_modulus = self.arithmetic_parameters[19]
        num_words = self.arithmetic_parameters[7]
        n = self.arithmetic_parameters[3]
        n_line_zero = self.arithmetic_parameters[16]
        t = [0 for i in range(2*num_words)]
        C = 0
        C_S = 0
        S = 0
        m = 0
        for i in range(num_words):
            C = 0
            for j in range(num_words):
                C_S = t[i+j] + a[j]*b[i] + C
                S = C_S%(internal_word_modulus)
                C = C_S//(internal_word_modulus)
                t[i+j] = S
            t[i+num_words] = C
        for i in range(num_words):
            m = (t[0]*n_line_zero)%(internal_word_modulus)
            C_S = t[0] + m*n[0]
            C = C_S//(internal_word_modulus)
            for j in range(1,num_words):
                C_S = t[j] + m*n[j] + C
                S = C_S%(internal_word_modulus)
                C = C_S//(internal_word_modulus)
                t[j-1] = S
            for j in range(num_words, 2*num_words - i):
                C_S = t[j] + C
                S = C_S%(internal_word_modulus)
                C = C_S//(internal_word_modulus)
                t[j-1] = S
        return t[0:num_words]

    def _montgomery_multiplication_FIPS(self, a, b):
        word_size = self.arithmetic_parameters[0]
        internal_word_modulus = self.arithmetic_parameters[19]
        num_words = self.arithmetic_parameters[7]
        n = self.arithmetic_parameters[3]
        n_line_zero = self.arithmetic_parameters[16]
        acc = 0 # Should be 3 times word size
        acc_size = word_size*3
        m = [0 for i in range(num_words)]
        C = 0
        C_S = 0
        S = 0
        for i in range(num_words):
            for j in range(i):
                C_S = acc + a[j]*b[i-j]
                acc = C_S%(internal_word_modulus)
                C_S = acc + m[j]*n[i-j]
                acc = C_S%(internal_word_modulus)
            C_S = acc + a[i]*b[0]
            S = C_S%(internal_word_modulus)
            acc = C_S%(internal_word_modulus)
            m[i] = (S*n_line_zero)%(internal_word_modulus)
            C_S = acc + m[i]*n[0]
            acc = C_S%(internal_word_modulus)
            acc = acc//(internal_word_modulus)
        for i in range(num_words, 2*num_words):
            for j in range(i-num_words+1, num_words):
                C_S = acc + a[j]*b[i-j]
                acc = C_S%(internal_word_modulus)
                C_S = acc + m[j]*n[i-j]
                acc = C_S%(internal_word_modulus)
            m[i-num_words] = acc%(internal_word_modulus)
            acc = acc//(internal_word_modulus)
        return m
    
    def _montgomery_multiplication_CIHS(self, a, b):
        word_size = self.arithmetic_parameters[0]
        internal_word_modulus = self.arithmetic_parameters[19]
        num_words = self.arithmetic_parameters[7]
        n = self.arithmetic_parameters[3]
        n_line_zero = self.arithmetic_parameters[16]
        t = [0 for i in range(num_words)]
        t_carry_0 = 0
        t_carry_1 = 0
        m = 0
        C = 0
        C_S = 0
        S = 0
        for i in range(num_words):
            C = 0
            for j in range(num_words - i):
                C_S = t[i+j] + a[j]*b[i]+C
                S = C_S%(internal_word_modulus)
                C = C_S//(internal_word_modulus)
                t[i+j] = S
            C_S = t_carry_0 + C
            t_carry_0 = C_S%(internal_word_modulus)
            C = C_S//(internal_word_modulus)
            t_carry_1 = t_carry_1 + C
        for i in range(num_words):
            m = (t[0]*n_line_zero)%(internal_word_modulus)
            C_S = t[0] + m*n[0]
            C = C_S//(internal_word_modulus)
            for j in range(1,num_words):
                C_S = t[j] + m*n[j]+C
                S = C_S%(internal_word_modulus)
                C = C_S//(internal_word_modulus)
                t[j-1] = S
            C_S = t_carry_0 + C
            t[num_words-1] = C_S%(internal_word_modulus)
            C = C_S//(internal_word_modulus)
            C_S = t_carry_1 + C
            t_carry_0 = C_S%(internal_word_modulus)
            t_carry_1 = 0
            for j in range(i+1,num_words):
                C_S = t[num_words-1] + b[j]*a[num_words-j+i]
                S = C_S%(internal_word_modulus)
                C = C_S//(internal_word_modulus)
                t[num_words-1] = S
                C_S = t_carry_0 + C
                t_carry_0 = C_S%(internal_word_modulus)
                C = C_S//(internal_word_modulus)
                t_carry_1 = t_carry_1 + C
        return t
           
    def _montgomery_squaring_SOS(self, a):
        word_size = self.arithmetic_parameters[0]
        internal_word_modulus = self.arithmetic_parameters[19]
        num_words = self.arithmetic_parameters[7]
        n = self.arithmetic_parameters[3]
        n_line_zero = self.arithmetic_parameters[16]
        t = [0 for i in range(2*num_words)]
        C = 0
        C_S = 0
        S = 0
        m = 0
        for i in range(num_words):
            C_S = t[i+i] + a[i]*a[i]
            S = C_S%(internal_word_modulus)
            C = C_S//(internal_word_modulus)
            t[i+i] = S
            for j in range(i+1,num_words):
                C_S = t[i+j] + 2*a[j]*a[i] + C
                S = C_S%(internal_word_modulus)
                C = C_S//(internal_word_modulus)
                t[i+j] = S
            t[i+num_words] = C
        for i in range(num_words):
            m = (t[0]*n_line_zero)%(internal_word_modulus)
            C_S = t[0] + m*n[0]
            C = C_S//(internal_word_modulus)
            for j in range(1,num_words):
                C_S = t[j] + m*n[j] + C
                S = C_S%(internal_word_modulus)
                C = C_S//(internal_word_modulus)
                t[j-1] = S
            for j in range(num_words, 2*num_words - i):
                C_S = t[j] + C
                S = C_S%(internal_word_modulus)
                C = C_S//(internal_word_modulus)
                t[j-1] = S
        return t[0:num_words]
    
    def _montgomery_squaring_CIOS(self, a):
        word_size = self.arithmetic_parameters[0]
        internal_word_modulus = self.arithmetic_parameters[19]
        num_words = self.arithmetic_parameters[7]
        n = self.arithmetic_parameters[3]
        n_line_zero = self.arithmetic_parameters[16]
        t = [0 for i in range(num_words)]
        t_carry_0 = 0
        t_carry_1 = 0
        C = 0
        C_S = 0
        m = 0
        for i in range(num_words):
            C_S = t[i] + a[i]*a[i]
            t[i] = C_S%(internal_word_modulus)
            C = C_S//(internal_word_modulus)
            for j in range(i+1,num_words):
                C_S = t[j] + 2*a[j]*a[i] + C
                t[j] = C_S%(internal_word_modulus)
                C = C_S//(internal_word_modulus)
            C_S = t_carry_0 + C
            C = C_S//(internal_word_modulus)
            t_carry_0 = C_S%(internal_word_modulus)
            t_carry_1 = C
            m = ((t[0] * n_line_zero))%(internal_word_modulus)
            C_S = t[0] + m*n[0]
            C = C_S//(internal_word_modulus)
            for j in range(1, num_words):
                C_S = t[j] + m*n[j] + C
                t[j-1] = C_S%(internal_word_modulus)
                C = C_S//(internal_word_modulus)
            C_S = t_carry_0 + C
            t[num_words-1] = C_S%(internal_word_modulus)
            C = C_S//(internal_word_modulus)
            t_carry_0 = t_carry_1 + C
        return t
        
    def _montgomery_squaring_multiplication(self, a):
        return self._montgomery_multiplication(a, a)
        
    def _montgomery_addition(self, a, b):
        word_size = self.arithmetic_parameters[0]
        internal_word_modulus = self.arithmetic_parameters[19]
        num_words = self.arithmetic_parameters[7]
        t = [0 for i in range(num_words)]
        C = 0
        C_S = 0
        for i in range(num_words):
            C_S = a[i] + b[i] + C
            t[i] = C_S%(internal_word_modulus)
            C = C_S//(internal_word_modulus)
        return t

    def _montgomery_subtraction(self, a, b):
        word_size = self.arithmetic_parameters[0]
        internal_word_modulus = self.arithmetic_parameters[19]
        num_words = self.arithmetic_parameters[7]
        n = self.arithmetic_parameters[3]
        normalization_factor = self.arithmetic_parameters[4]
        t = [0 for i in range(num_words)]
        C = 0
        C_S = 0
        for i in range(num_words):
            C_S = a[i] - b[i] + C + normalization_factor*n[i]
            t[i] = C_S%(internal_word_modulus)
            C = C_S//(internal_word_modulus)
        return t
    
    def _montgomery_addition_normalized(self, a, b):
        word_size = self.arithmetic_parameters[0]
        internal_word_modulus = self.arithmetic_parameters[19]
        num_words = self.arithmetic_parameters[7]
        n = self.arithmetic_parameters[3]
        t = [0 for i in range(num_words)]
        u = [0 for i in range(num_words)]
        C = 0
        C_S = 0
        for i in range(num_words):
            C_S = a[i] + b[i] + C
            t[i] = C_S%(internal_word_modulus)
            C = C_S//(internal_word_modulus)
        #t[num_words] = C
        C = 0
        for i in range(num_words):
            C_S = t[i] - n[i] + C
            u[i] = C_S%(internal_word_modulus)
            C = C_S//(internal_word_modulus)
        #u[num_words] = t[num_words] + C
        if (u[num_words-1] < 0):
            return t
        else:
            return u

    def _montgomery_subtraction_normalized(self, a, b):
        word_size = self.arithmetic_parameters[0]
        internal_word_modulus = self.arithmetic_parameters[19]
        num_words = self.arithmetic_parameters[7]
        n = self.arithmetic_parameters[3]
        t = [0 for i in range(num_words)]
        u = [0 for i in range(num_words)]
        C = 0
        C_S = 0
        for i in range(num_words):
            C_S = a[i] - b[i] + C
            t[i] = C_S%(internal_word_modulus)
            C = C_S//(internal_word_modulus)
        #t[num_words] = C
        C = 0
        for i in range(num_words):
            C_S = t[i] + n[i] + C
            u[i] = C_S%(internal_word_modulus)
            C = C_S//(internal_word_modulus)
        #u[num_words] = t[num_words] + C
        if (t[num_words-1] < 0):
            return u
        else:
            return t
           
    def _montgomery_enter_domain(self, a):
        r2 = self.arithmetic_parameters[13]
        result = self._montgomery_multiplication(a, r2)
        return result
    
    def _montgomery_remove_domain(self, a):
        value_1 = self.arithmetic_parameters[17]
        result = self._montgomery_multiplication(a, value_1)
        return result
        
    def _montgomery_exponentiation(self, a, expoent):
        square = a
        result = self.arithmetic_parameters[11]
        while expoent != 0:
            if(Mod(expoent,2) == 1):
                result = self._montgomery_multiplication(result, square)
            square = self._montgomery_squaring(square)
            expoent = expoent//2
        return result
        
    def _montgomery_inversion(self, a):
        expoent = self.arithmetic_parameters[2] - 2
        result = self._montgomery_exponentiation(a, expoent)   
        return result
        