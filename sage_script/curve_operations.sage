load("~/sf_shared_vm/sage_scripts/base_arithmetic.sage")

##
# curve_parameters[0] = name                        # Curve name (String)
# curve_parameters[1] = prime                       # Curve prime (Integer)
# curve_parameters[2] = order                       # Curve order (Integer)
# curve_parameters[3] = shape                       # Curve shape (String)
# curve_parameters[4] = curve_constants             # Internal curve constants (List)
# curve_parameters[5] = curve_constants_converter   # Convert the curve constants in the internal shape to Short Weierstrass (function)
# curve_parameters[6] = point_generator             # Point generator in internal coordinate system (List)
# curve_parameters[7] = coordinate_system           # Coordinate system with infinity point and coordinate formulas (List)
##

##
# curve_constants[i] =                              # Curve constant (Integer)
##

## Coordinates system
# coordinate_system[0] =                            # Coordinate internal system name
# coordinate_system[1] =                            # Point Infinity in the internal system (List)
# coordinate_system[2] =                            # Convert Point from internal system to Short Weierstrass affine (function)
# coordinate_system[3] =                            # Formulas functions (List)
##

## Formulas 
# formula[0] =                                      # Addition formula, R = P+Q
# formula[1] =                                      # Doubling formula, R = P+P
# formula[2] =                                      # Addition and Doubling formula, R0 = P+P, R1 = P+Q
# formula[3] =                                      # Differential Addition formula, R = P+Q
# formula[4] =                                      # Differential Addition and Doubling formula, R0 = P+P, R1 = P+Q
##

def short_weierstrass_point_addition_complete_all_a_2(finite_field, curve_constants, point_a, point_b):
    short_weierstrass_a  = finite_field(curve_constants[0])
    short_weierstrass_3b = finite_field(3*curve_constants[1])
    
    point_o = [0, 0, 0]
    
    ## 1 ##
    ## t0 = X1*X2; //
    temp_0  = point_a[0] * point_b[0]
    ## 2 ##
    ## t1 = Y1*Y2; //
    temp_1  = point_a[1] * point_b[1]
    ## 3 ##
    ## t2 = Z1*Z2; //
    temp_2  = point_a[2] * point_b[2]
    ## 4 ##
    ## t3 = X1+Y1; //
    temp_3  = point_a[0] + point_b[1]
    ## 5 ##
    ## t4 = X2+Y2; //
    temp_4  = point_b[0] + point_b[1]
    ## 6 ##
    ## t3 = t3*t4; //
    temp_3  = temp_3 * temp_4
    ## 7 ##
    ## t4 = t0+t1; //
    temp_4  = temp_0 * temp_1
    ## 8 ##
    ## t3 = t3-t4; //
    temp_3  = temp_3 - temp_4
    ## 9 ##
    ## t4 = X1+Z1; //
    temp_4  = point_a[0] + point_a[2]
    ## 10 ##
    ## t5 = X2+Z2; //
    temp_5  = point_b[0] + point_b[2]
    ## 11 ##
    ## t4 = t4*t5; //
    temp_4  = temp_4 * temp_5
    ## 12 ##
    ## t5 = t0+t2; //
    temp_5  = temp_0 + temp_2
    ## 13 ##
    ## t4 = t4-t5; //
    temp_4  = temp_4 - temp_5
    ## 14 ##
    ## t5 = Y1+Z1; //
    temp_5  = point_a[1] + point_a[2]
    ## 15 ##
    ## t6 = Y2+Z2; //
    temp_6  = point_b[1] + point_b[2]
    ## 16 ##
    ## t5 = t5*t6; //
    temp_5  = temp_5 * temp_6
    ## 17 ##
    ## t6 = t1+t2; //
    temp_6  = temp_1 + temp_2
    ## 18 ##
    ## t5 = t5-t6; //
    temp_5  = temp_5 - temp_6
    ## 19 ##
    ## t8 = a*t4; //
    temp_8  = short_weierstrass_a * temp_4
    ## 20 ##
    ## t6 = b3*t2; //
    temp_6  = short_weierstrass_3b * temp_2
    ## 21 ##
    ## t8 = t6+t8; //
    temp_8  = temp_6 + temp_8
    ## 22 ##
    ## t6 = t1-t8; //
    temp_6  = temp_1 - temp_8
    ## 23 ##
    ## t8 = t1+t8; //
    temp_8  = temp_1 + temp_8
    ## 24 ##
    ## t7 = t6*t8; //
    temp_7  = temp_6 * temp_8
    ## 25 ##
    ## t1 = t0+t0; //
    temp_1  = temp_0 + temp_0
    ## 26 ##
    ## t1 = t1+t0; //
    temp_1  = temp_1 + temp_0
    ## 27 ##
    ## t2 = a*t2; //
    temp_2  = short_weierstrass_a * temp_2
    ## 28 ##
    ## t4 = b3*t4; //
    temp_4  = short_weierstrass_3b * temp_4
    ## 29 ##
    ## t1 = t1+t2; //
    temp_1  = temp_1 + temp_2
    ## 30 ##
    ## t2 = t0-t2; //
    temp_2  = temp_0 - temp_2
    ## 31 ##
    ## t2 = a*t2; //
    temp_2  = short_weierstrass_a * temp_2
    ## 32 ##
    ## t4 = t4+t2; //
    temp_4  = temp_4 + temp_2
    ## 33 ##
    ## t0 = t1*t4; //
    temp_0  = temp_1 * temp_4
    ## 34 ##
    ## Y3 = t7+t0; //
    point_o[1]  = temp_7 + temp_0
    ## 35 ##
    ## t0 = t5*t4; //
    temp_0  = temp_5 * temp_4
    ## 36 ##
    ## t6 = t3*t6; //
    temp_6  = temp_3 * temp_6
    ## 37 ##
    ## X3 = t6-t0; //
    point_o[0]  = temp_6 - temp_0
    ## 38 ##
    ## t0 = t3*t1; //
    temp_0  = temp_3 * temp_1
    ## 39 ##
    ## t8 = t5*t8; //
    temp_8  = temp_5 * temp_8
    ## 40 ##
    ## Z3 = t8+t0; //
    point_o[2]  = temp_8 * temp_0
    
    return point_o
    
def short_weierstrass_point_addition_complete_a_m3_1(finite_field, curve_constants, point_a, point_b):
    short_weierstrass_b = finite_field(curve_constants[1])
    
    point_o = [0, 0, 0]
    
    ## 01 ##
    ## t0 = X1*X2; //
    temp_0 = point_a[0] * point_b[0]
    ## 02 ##
    ## t1 = Y1*Y2; //
    temp_1 = point_a[1] * point_b[1]
    ## 03 ##
    ## t2 = Z1*Z2; //
    temp_2 = point_a[2] * point_b[2]
    ## 04 ##
    ## t3 = X1+Y1; //
    temp_3 = point_a[0] + point_a[1]
    ## 05 ##
    ## t4 = X2+Y2; //
    temp_4 = point_b[0] + point_b[1]
    ## 06 ##
    ## t3 = t3*t4; //
    temp_3 = temp_3 * temp_4
    ## 07 ##
    ## t4 = t0+t1; //
    temp_4 = temp_0 + temp_1
    ## 08 ##
    ## t3 = t3-t4; //
    temp_3 = temp_3 - temp_4
    ## 09 ##
    ## t4 = Y1+Z1; //
    temp_4 = point_a[1] + point_a[2]
    ## 10 ##
    ## t5 = Y2+Z2; //
    temp_5 = point_b[1] + point_b[2]
    ## 11 ##
    ## t4 = t4*t5; //
    temp_4 = temp_4 * temp_5
    ## 12 ##
    ## t5 = t1+t2; //
    temp_5 = temp_1 + temp_2
    ## 13 ##
    ## t4 = t4-t5; //
    temp_4 = temp_4 - temp_5
    ## 14 ##
    ## t5 = X1+Z1; //
    temp_5 = point_a[0] + point_a[2]
    ## 15 ##
    ## t6 = X2+Z2; //
    temp_6 = point_b[0] + point_b[2]
    ## 16 ##
    ## t5 = t5*t6; //
    temp_5 = temp_5 * temp_6
    ## 17 ##
    ## t6 = t0+t2; //
    temp_6 = temp_0 + temp_2
    ## 18 ##
    ## t6 = t5-t6; //
    temp_6 = temp_5 - temp_6
    ## 19 ##
    ## t7 = b*t2; //
    temp_7 = short_weierstrass_b * temp_2
    ## 20 ##
    ## t5 = t6-t7; //
    temp_5 = temp_6 - temp_7
    ## 21 ##
    ## t7 = t5+t5; //
    temp_7 = temp_5 + temp_5
    ## 22 ##
    ## t5 = t5+t7; //
    temp_5 = temp_5 + temp_7
    ## 23 ##
    ## t7 = t1-t5; //
    temp_7 = temp_1 - temp_5
    ## 24 ##
    ## t5 = t1+t5; //
    temp_5 = temp_1 + temp_5
    ## 25 ##
    ## t6 = b*t6;//
    temp_6 = short_weierstrass_b * temp_6
    ## 26 ##
    ## t1 = t2+t2; //
    temp_1 = temp_2 + temp_2
    ## 27 ##
    ## t2 = t1+t2; //
    temp_2 = temp_1 + temp_2
    ## 28 ##
    ## t6 = t6-t2; //
    temp_6 = temp_6 - temp_2
    ## 29 ##
    ## t6 = t6-t0; //
    temp_6 = temp_6 - temp_0
    ## 30 ##
    ## t1 = t6+t6; //
    temp_1 = temp_6 + temp_6
    ## 31 ##
    ## t6 = t1+t6; //
    temp_6 = temp_1 + temp_6
    ## 32 ##
    ## t1 = t0+t0; //
    temp_1 = temp_0 + temp_0
    ## 33 ##
    ## t0 = t1+t0; //
    temp_0 = temp_1 + temp_0
    ## 34 ##
    ## t0 = t0-t2; //
    temp_0 = temp_0 - temp_2
    ## 35 ##
    ## t1 = t4*t6; //
    temp_1 = temp_4 * temp_6
    ## 36 ##
    ## t2 = t0*t6; //
    temp_2 = temp_0 * temp_6
    ## 37 ##
    ## t6 = t5*t7; //
    temp_6 = temp_5 * temp_7
    ## 38 ##
    ## Y3 = t6+t2; //
    point_o[1] = temp_6 + temp_2
    ## 39 ##
    ## t5 = t3*t5; //
    temp_5 = temp_3 * temp_5
    ## 40 ##
    ## X3 = t5-t1; //
    point_o[0] = temp_5 - temp_1
    ## 41 ##
    ## t7 = t4*t7; //
    temp_7 = temp_4 * temp_7
    ## 42 ##
    ## t1 = t3*t0; //
    temp_1 = temp_3 * temp_0
    ## 43 ##
    ## Z3 = t7+t1; //
    point_o[2] = temp_7 + temp_1
    
    return point_o

def short_weierstrass_point_addition_complete_all_a_1(finite_field, curve_constants, point_a, point_b):
    short_weierstrass_a  = finite_field(curve_constants[0])
    short_weierstrass_3b = finite_field(3*curve_constants[1])
    
    point_o = [0, 0, 0]

    ###  /* 1 */
    ##
    ##t0 := X1*X2; //
    ##t1 := Y1*Y2; //
    ##t2 := Z1*Z2; //
    temp_0  = point_a[0] * point_b[0]
    temp_1  = point_a[1] * point_b[1]
    temp_2  = point_a[2] * point_b[2]
    ###  /* 2 */
    ##
    ##t3 := X1+Y1; //
    ##t4 := X2+Y2; //
    ##t5 := Y1+Z1; //
    temp_3  = point_a[0] + point_a[1]
    temp_4  = point_b[0] + point_b[1]
    temp_5  = point_a[1] + point_a[2]
    ###  /* 3 */
    ##
    ##t6 := Y2+Z2; //
    ##t7 := X1+Z1; //
    ##t8 := X2+Z2; //
    temp_6  = point_b[1] + point_b[2]
    temp_7  = point_a[0] + point_a[2]
    temp_8  = point_b[0] + point_b[2]
    ###  /* 4 */
    ##
    ##t9  := t3*t4;  // 
    ##t10 := t5*t6; //
    ##t11 := t7*t8; //
    temp_9  = temp_3 * temp_4
    temp_10 = temp_5 * temp_6
    temp_11 = temp_7 * temp_8
    ###  /* 5 */
    ##
    ##t3 := t0+t1;  //
    ##t4 := t1+t2;  //
    ##t5 := t0+t2;  //
    temp_3  = temp_0 + temp_1
    temp_4  = temp_1 + temp_2
    temp_5  = temp_0 + temp_2
    ###  /* 6 */
    ##
    ##t6  := b3*t2;  //
    ##t8  := a*t2;   //
    ##
    temp_6  = short_weierstrass_3b * temp_2
    temp_8  = short_weierstrass_a * temp_2
    ###  /* 7 */
    ##
    ##t2 := t9-t3; //
    ##t9 := t0+t0; //
    ##t3 := t10-t4; //
    temp_2  = temp_9 - temp_3
    temp_9  = temp_0 + temp_0
    temp_3  = temp_10 - temp_4
    ###  /* 8 */
    ##
    ##t10 := t9+t0;  //
    ##t4  := t11-t5;  //
    ##t7  := t0-t8;   //
    temp_10 = temp_9 + temp_0
    temp_4  = temp_11 - temp_5
    temp_7  = temp_0 - temp_8
    ###  /* 9 */
    ##
    ##t0 := a*t4;   //
    ##t5 := b3*t4;   //
    ##t9 := a*t7;   //
    temp_0  = short_weierstrass_a * temp_4
    temp_5  = short_weierstrass_3b * temp_4
    temp_9  = short_weierstrass_a * temp_7
    ###  /* 10 */
    ##
    ##t4  := t0+t6;   //
    ##t7  := t5+t9;  //
    ##t0  := t8+t10;  //
    temp_4  = temp_0 + temp_6
    temp_7  = temp_5 + temp_9 
    temp_0  = temp_8 + temp_10
    ###  /* 11 */
    ##
    ##t5 := t1-t4;   //
    ##t6 := t1+t4;   //
    temp_5  = temp_1 - temp_4
    temp_6  = temp_1 + temp_4
    ###  /* 12 */
    ##
    ##t1 := t5*t6;   //
    ##t4 := t0*t7;   //
    ##t8 := t3*t7;   //
    temp_1  = temp_5 * temp_6
    temp_4  = temp_0 * temp_7
    temp_8  = temp_3 * temp_7
    ###  /* 13 */
    ##
    ##t9  := t2*t5;  //
    ##t10 := t3*t6;  //
    ##t11 := t0*t2; //
    temp_9  = temp_2 * temp_5
    temp_10 = temp_3 * temp_6
    temp_11 = temp_0 * temp_2
    ###  /* 14 */
    ##
    ##X3 := t9-t8;
    ##Y3 := t1+t4;
    ##Z3 := t10+t11;
    ###
    point_o[0] = temp_9 - temp_8
    point_o[1] = temp_1 + temp_4 
    point_o[2] = temp_10 + temp_11
    return point_o
    
def short_weierstrass_point_doubling_complete_all_a_1(finite_field, curve_constants, point_a):
    short_weierstrass_a  = finite_field(curve_constants[0])
    short_weierstrass_3b = finite_field(3*curve_constants[1])
    
    point_o = [0, 0, 0]
    
    ## 1 ##
    ## t0 = X1^2; //
    temp_0  = point_a[0]**2
    ## 2 ##
    ## t1 = Y1^2; //
    temp_1  = point_a[1]**2
    ## 3 ##
    ## t2 = Z1^2; //
    temp_2  = point_a[2]**2
    ## 4 ##
    ## t3 = X1*Y1; //
    temp_3  = point_a[0] * point_a[1]
    ## 5 ##
    ## t3 = t3+t3; //
    temp_3  = temp_3 + temp_3
    ## 6 ##
    ## t6 = X1*Z1; //
    temp_6  = point_a[0] * point_a[2]
    ## 7 ##
    ## t6 = t6+t6; //
    temp_6  = temp_6 + temp_6
    ## 8 ##
    ## t4 = a*t6; //
    temp_4  = short_weierstrass_a * temp_6
    ## 9 ##
    ## t5 = b3*t2; //
    temp_5  = short_weierstrass_3b * temp_2
    ## 10 ##
    ## t5 = t4+t5; //
    temp_5  = temp_4 + temp_5
    ## 11 ##
    ## t4 = t1-t5; //
    temp_4  = temp_1 - temp_5
    ## 12 ##
    ## t5 = t1+t5; //
    temp_5  = temp_1 + temp_5
    ## 13 ##
    ## t5 = t4*t5; //
    temp_5  = temp_4 * temp_5
    ## 14 ##
    ## t4 = t3*t4; //
    temp_4  = temp_3 * temp_4
    ## 15 ##
    ## t6 = 3b*t6; //
    temp_6  = short_weierstrass_3b * temp_6
    ## 16 ##
    ## t2 = a*t2; //
    temp_2  = short_weierstrass_a * temp_2
    ## 17 ##
    ## t3 = t0-t2; //
    temp_3  = temp_0 - temp_2
    ## 18 ##
    ## t3 = a*t3; //
    temp_3  = short_weierstrass_a * temp_3
    ## 19 ##
    ## t3 = t3+t6; //
    temp_3  = temp_3 + temp_6
    ## 20 ##
    ## t6 = t0+t0; //
    temp_6  = temp_0 + temp_0
    ## 21 ##
    ## t0 = t6+t0; //
    temp_0  = temp_6 + temp_0
    ## 22 ##
    ## t0 = t0+t2; //
    temp_0  = temp_0 + temp_2
    ## 23 ##
    ## t0 = t0*t3; //
    temp_0  = temp_0 * temp_3
    ## 25 ##
    ## t2 = Y1*Z1; //
    temp_2  = point_a[1] * point_a[2]
    ## 26 ##
    ## t2 = t2+t2; //
    temp_2  = temp_2 + temp_2
    ## 24 ##
    ## Y3 = t5+t0; //
    point_o[1]  = temp_5 + temp_0
    ## 27 ##
    ## t0 = t2*t3; //
    temp_0  = temp_2 * temp_3
    ## 28 ##
    ## X3 = t4-t0; //
    point_o[0]  = temp_4 - temp_0
    ## 29 ##
    ## t6 = t2*t1; //
    temp_6  = temp_2 * temp_1
    ## 30 ##
    ## t6 = t6+t6; //
    temp_6  = temp_6 + temp_6
    ## 31 ##
    ## Z3 = t6+t6; //
    point_o[2]  = temp_6 + temp_6
    return point_o

def short_weierstrass_point_doubling_complete_a_m3_1(finite_field, curve_constants, point_a):
    short_weierstrass_b = finite_field(curve_constants[1])
    
    point_o = [0, 0, 0]
    
    ## 01 ##
    ## t0 = X1*X1; //
    temp_0 = point_a[0]**2
    ## 02 ##
    ## t1 = Y1*Y1; //
    temp_1 = point_a[1]**2
    ## 03 ##
    ## t2 = Z1*Z1; //
    temp_2 = point_a[2]**2
    ## 04 ##
    ## t3 = X1*Y1; //
    temp_3 = point_a[0] * point_a[1]
    ## 05 ##
    ## t3 = t3+t3; //
    temp_3 = temp_3 + temp_3
    ## 06 ##
    ## t6 = X1*Z1; //
    temp_6 = point_a[0] * point_a[2]
    ## 07 ##
    ## t6 = t6+t6; //
    temp_6 = temp_6 + temp_6
    ## 08 ##
    ## t5 = b*t2; //
    temp_5 = short_weierstrass_b * temp_2
    ## 09 ##
    ## t5 = t5-t6; //
    temp_5 = temp_5 - temp_6
    ## 10 ##
    ## t4 = t5+t5; //
    temp_4 = temp_5 + temp_5
    ## 11 ##
    ## t5 = t4+t5; //
    temp_5 = temp_4 + temp_5
    ## 12 ##
    ## t4 = t1-t5; //
    temp_4 = temp_1 - temp_5
    ## 13 ##
    ## t5 = t1+t5; //
    temp_5 = temp_1 + temp_5
    ## 14 ##
    ## t5 = t4*t5; //
    temp_5 = temp_4 * temp_5
    ## 15 ##
    ## t4 = t4*t3; //
    temp_4 = temp_4 * temp_3
    ## 16 ##
    ## t3 = t2+t2; //
    temp_3 = temp_2 + temp_2
    ## 17 ##
    ## t2 = t2+t3; //
    temp_2 = temp_2 + temp_3
    ## 18 ##
    ## t6 = b*t6; //
    temp_6 = short_weierstrass_b * temp_6
    ## 19 ##
    ## t6 = t6-t2; //
    temp_6 = temp_6 - temp_2
    ## 20 ##
    ## t6 = t6-t0; //
    temp_6 = temp_6 - temp_0
    ## 21 ##
    ## t3 = t6+t6; //
    temp_3 = temp_6 + temp_6
    ## 22 ##
    ## t6 = t6+t3; //
    temp_6 = temp_6 + temp_3
    ## 23 ##
    ## t3 = t0+t0; //
    temp_3 = temp_0 + temp_0
    ## 24 ##
    ## t0 = t3+t0; //
    temp_0 = temp_3 + temp_0
    ## 25 ##
    ## t0 = t0-t2; //
    temp_0 = temp_0 - temp_2
    ## 26 ##
    ## t0 = t0*t6; //
    temp_0 = temp_0 * temp_6
    ## 28 ##
    ## t2 = Y1*Z1; //
    temp_2 = point_a[1] * point_a[2]
    ## 29 ##
    ## t2 = t2+t2; //
    temp_2 = temp_2 + temp_2
    ## 27 ##
    ## Y3 = t5+t0; //
    point_o[1] = temp_5 + temp_0
    ## 30 ##
    ## t6 = t2*t6; //
    temp_6 = temp_2 * temp_6
    ## 31 ##
    ## X3 = t4-t6; //
    point_o[0] = temp_4 - temp_6
    ## 32 ##
    ## t6 = t2*t1; //
    temp_6 = temp_2 * temp_1
    ## 33 ##
    ## t6 = t6+t6; //
    temp_6 = temp_6 + temp_6
    ## 34 ##
    ## Z3 = t6+t6; //
    point_o[2] = temp_6 + temp_6

    return point_o
    

def edwards_point_addition_for_all_c_1(finite_field, curve_constants, point_a, point_b):
    edwards_d = finite_field(curve_constants[0])
    edwards_c = finite_field(curve_constants[1])
    
    point_o = [0, 0, 0]
    
    #add-2007-bl-2
    
    #R1 = X1
    #R2 = Y1
    #R3 = Z1
    
    #R4 = X2
    #R5 = Y2
    #R6 = Z2
    
    #R3 = Z1*Z2
    temp_3 = point_a[2] * point_b[2]
    #R7 = X1+Y1
    temp_7 = point_a[0] + point_a[1]
    #R8 = X2+Y2
    temp_8 = point_b[0] + point_b[1]
    #R1 = X1*X2
    temp_1 = point_a[0] * point_b[0]
    #R2 = Y1*Y2
    temp_2 = point_a[1] * point_b[1]
    #R7 = R7*R8
    temp_7 = temp_7 * temp_8
    #R7 = R7-R1
    temp_7 = temp_7 - temp_1
    #R7 = R7-R2
    temp_7 = temp_7 - temp_2
    #R7 = R7*R3
    temp_7 = temp_7 * temp_3
    #R8 = R1*R2
    temp_8 = temp_1 * temp_2
    #R8 = d*R8
    temp_8 = temp_8 * edwards_d
    #R2 = R2-R1
    temp_2 = temp_2 - temp_1
    #R2 = R2*R3
    temp_2 = temp_2 * temp_3
    #R3 = R3^2
    temp_3 = temp_3^2
    #R1 = R3-R8
    temp_1 = temp_3 - temp_8
    #R3 = R3+R8
    temp_3 = temp_3 + temp_8
    #R2 = R2*R3
    point_o[1] = temp_2 * temp_3
    #R3 = R3*R1
    temp_3 = temp_3 * temp_1
    #R1 = R1*R7
    point_o[0] = temp_1 * temp_7
    #R3 = c*R3
    point_o[2] = temp_3 * edwards_c
    #X3 = R1
    #Y3 = R2
    #Z3 = R3
    
    return point_o
    
def edwards_point_doubling_for_all_c_1(finite_field, curve_constants, point_a):
    edwards_d = finite_field(curve_constants[0])
    edwards_c = finite_field(curve_constants[1])
    
    point_o = [0, 0, 0]
    
    # dbl-2007-bl-2

    
    #R1 = X1    #R2 = Y1    #R3 = Z1
    
    #R4 = X1+Y1
    temp_4 = point_a[0] + point_a[1]
    #R3 = c*Z1
    temp_3 = point_a[2] * edwards_c
    #R1 = X1^2
    temp_1 = point_a[0]^2
    #R2 = Y1^2
    temp_2 = point_a[1]^2
    #R3 = R3^2
    temp_3 = temp_3^2
    #R4 = R4^2
    temp_4 = temp_4^2
    #R3 = 2*R3
    temp_3 = temp_3 + temp_3
    #R5 = R1+R2
    temp_5 = temp_1 + temp_2
    #R2 = R1-R2
    temp_2 = temp_1 - temp_2
    #R4 = R4-R5
    temp_4 = temp_4 - temp_5
    #R3 = R5-R3
    temp_3 = temp_5 - temp_3
    #R1 = R3*R4
    temp_1 = temp_3 * temp_4
    #R3 = R3*R5
    point_o[2] = temp_3 * temp_5
    #R2 = R2*R5
    temp_2 = temp_2 * temp_5
    #R1 = c*R1       
    point_o[0] = temp_1 * edwards_c
    #R2 = c*R2 
    point_o[1] = temp_2 * edwards_c
    #X3 = R1      #Y3 = R2    #Z3 = R3
    
    return point_o
    
def edwards_point_addition_for_c_1_1(finite_field, curve_constants, point_a, point_b):
    edwards_d = finite_field(curve_constants[0])
    
    point_o = [0, 0, 0]
    
    #add-2007-bl-2
    
    #R1 = X1
    #R2 = Y1
    #R3 = Z1
    
    #R4 = X2
    #R5 = Y2
    #R6 = Z2
    
    #R3 = Z1*Z2
    temp_3 = point_a[2] * point_b[2]
    #R7 = X1+Y1
    temp_7 = point_a[0] + point_a[1]
    #R8 = X2+Y2
    temp_8 = point_b[0] + point_b[1]
    #R1 = X1*X2
    temp_1 = point_a[0] * point_b[0]
    #R2 = Y1*Y2
    temp_2 = point_a[1] * point_b[1]
    #R7 = R7*R8
    temp_7 = temp_7 * temp_8
    #R7 = R7-R1
    temp_7 = temp_7 - temp_1
    #R7 = R7-R2
    temp_7 = temp_7 - temp_2
    #R7 = R7*R3
    temp_7 = temp_7 * temp_3
    #R8 = R1*R2
    temp_8 = temp_1 * temp_2
    #R8 = d*R8
    temp_8 = temp_8 * edwards_d
    #R2 = R2-R1
    temp_2 = temp_2 - temp_1
    #R2 = R2*R3
    temp_2 = temp_2 * temp_3
    #R3 = R3^2
    temp_3 = temp_3^2
    #R1 = R3-R8
    temp_1 = temp_3 - temp_8
    #R3 = R3+R8
    temp_3 = temp_3 + temp_8
    #R2 = R2*R3
    point_o[1] = temp_2 * temp_3
    #R3 = R3*R1
    point_o[2] = temp_3 * temp_1
    #R1 = R1*R7
    point_o[0] = temp_1 * temp_7
    #R3 = c*R3, c = 1
    #X3 = R1
    #Y3 = R2
    #Z3 = R3
    
    return point_o
    
def edwards_point_doubling_for_c_1_1(finite_field, curve_constants, point_a):
    edwards_d = finite_field(curve_constants[0])
    
    point_o = [0, 0, 0]
    
    # dbl-2007-bl-2

    
    #R1 = X1    #R2 = Y1    #R3 = Z1
    
    #R4 = X1+Y1
    temp_4 = point_a[0] + point_a[1]
    #R3 = c*Z1, c = 1
    #R1 = X1^2
    temp_1 = point_a[0]^2
    #R2 = Y1^2
    temp_2 = point_a[1]^2
    #R3 = R3^2
    temp_3 = point_a[2]^2
    #R4 = R4^2
    temp_4 = temp_4^2
    #R3 = 2*R3
    temp_3 = temp_3 + temp_3
    #R5 = R1+R2
    temp_5 = temp_1 + temp_2
    #R2 = R1-R2
    temp_2 = temp_1 - temp_2
    #R4 = R4-R5
    temp_4 = temp_4 - temp_5
    #R3 = R5-R3
    temp_3 = temp_5 - temp_3
    #R1 = R3*R4
    point_o[0] = temp_3 * temp_4
    #R3 = R3*R5
    point_o[2] = temp_3 * temp_5
    #R2 = R2*R5
    point_o[1] = temp_2 * temp_5
    #R1 = c*R1    #R2 = c*R2    
    #X3 = R1      #Y3 = R2    #Z3 = R3
    
    return point_o
    
def montgomery_point_differential_addition_and_doubling(finite_field, curve_constants, point_a, point_b, point_diff):
    
    montgomery_A24 = finite_field((curve_constants[0] - 2)//4)
    
    point_addition = [0, 0]
    point_doubling = [0, 0]
    
    # A = X2+Z2
    temp_A = point_a[0] + point_a[1]
    # B = X2-Z2
    temp_B = point_a[0] - point_a[1]
    # C = X3+Z3
    temp_C = point_b[0] + point_b[1]
    # D = X3-Z3
    temp_D = point_b[0] - point_b[1]
    # AA = A2
    temp_AA = temp_A^2
    # BB = B2
    temp_BB = temp_B^2
    # E = AA-BB
    temp_E = temp_AA - temp_BB
    # DA = D*A
    temp_DA = temp_D*temp_A
    # CB = C*B
    temp_CB = temp_C*temp_B
    # X5 = (DA+CB)2
    point_addition[0] = (temp_DA+temp_CB)^2
    # Z5 = X1*(DA-CB)2
    point_addition[1] = point_diff[0]*(temp_DA-temp_CB)^2
    # X4 = AA*BB
    point_doubling[0] = temp_AA*temp_BB
    # Z4 = E*(BB+a24*E)
    point_doubling[1] = temp_E*(temp_BB+montgomery_A24*temp_E)
    
    return point_doubling, point_addition
    
    
def scalar_point_multiplication_1(finite_field, curve_parameters, point, scalar):
    curve_constants = curve_parameters[4]
    coordinate_system = curve_parameters[7]
    point_infinity = coordinate_system[1]
    
    scalar_point = [0 for i in range(len(point_infinity))]
    square_point = [0 for i in range(len(point_infinity))]
    
    point_formulas = coordinate_system[3]
    point_addition = point_formulas[0]
    point_doubling = point_formulas[1]
    
    for i in range(len(point_infinity)):
        scalar_point[i] = finite_field(point_infinity[i])
        square_point[i] = finite_field(point[i])
    
    while scalar != 0:
        if(Mod(scalar,2) == 1):
            scalar_point = point_addition(finite_field, curve_constants, scalar_point, square_point)
        square_point = point_addition(finite_field, curve_constants, square_point, square_point)
        scalar = scalar//2
    
    return scalar_point
    
def scalar_point_multiplication_2(finite_field, curve_parameters, point, scalar):
    curve_constants = curve_parameters[4]
    coordinate_system = curve_parameters[7]
    point_infinity = coordinate_system[1]
    
    r0_point = [0 for i in range(len(point_infinity))]
    r1_point = [0 for i in range(len(point_infinity))]
    curve_constants_montgomery = [0 for i in range(len(curve_constants))]
    
    scalar_list = integer_to_list(1, 1000, scalar)
    
    point_formulas = coordinate_system[3]
    point_addition = point_formulas[0]
    point_doubling = point_formulas[1]
      
    for i in range(len(point_infinity)):
        r0_point[i] = finite_field(point_infinity[i])
        r1_point[i] = finite_field(point[i])
      
    i = len(scalar_list) - 1
    while(scalar_list[i] != 1):
        i = i - 1
    while i != 0:
        if(scalar_list[i] == 1):
            r0_point = point_addition(finite_field, curve_constants, r0_point, r1_point)
            r1_point = point_doubling(finite_field, curve_constants, r1_point)
        else:
            r1_point = point_addition(finite_field, curve_constants, r0_point, r1_point)
            r0_point = point_doubling(finite_field, curve_constants, r0_point)
        i = i - 1 

    if(scalar_list[i] == 1):
        r0_point = point_addition(finite_field, curve_constants, r0_point, r1_point)
        r1_point = point_doubling(finite_field, curve_constants, r1_point)
    else:
        r1_point = point_addition(finite_field, curve_constants, r0_point, r1_point)
        r0_point = point_doubling(finite_field, curve_constants, r0_point)
    
    return r0_point
    
def scalar_point_multiplication_3(finite_field, curve_parameters, point, scalar):
    curve_constants = curve_parameters[4]
    coordinate_system = curve_parameters[7]
    point_infinity = coordinate_system[1]
    
    r0_point = [0 for i in range(len(point_infinity))]
    r1_point = [0 for i in range(len(point_infinity))]
    curve_constants_montgomery = [0 for i in range(len(curve_constants))]
       
    point_formulas = coordinate_system[3]
    point_addition = point_formulas[0]
    point_doubling = point_formulas[1]
        
    for i in range(len(point_infinity)):
        r0_point[i] = finite_field(point_infinity[i])
        r1_point[i] = finite_field(point[i])
    
    while scalar != 0:
        if(Mod(scalar,2) == 1):
            r0_point = point_doubling(finite_field, curve_constants, r0_point)
            r0_point = point_addition(finite_field, curve_constants, r0_point, r1_point)
        else:
            r1_point = point_doubling(finite_field, curve_constants, r1_point)
            r1_point = point_addition(finite_field, curve_constants, r0_point, r1_point)
        scalar = scalar//2
        
    return r0_point
    
def scalar_point_multiplication_4(finite_field, curve_parameters, point, scalar):
    curve_constants = curve_parameters[4]
    coordinate_system = curve_parameters[7]
    point_infinity = coordinate_system[1]
    
    r0_point = [0 for i in range(len(point_infinity))]
    r1_point = [0 for i in range(len(point_infinity))]
    curve_constants_montgomery = [0 for i in range(len(curve_constants))]
    
    scalar_list = integer_to_list(1, 1000, scalar)
    
    point_formulas = coordinate_system[3]
    point_differential_addition_doubling = point_formulas[4]
      
    for i in range(len(point_infinity)):
        r0_point[i] = finite_field(point_infinity[i])
        r1_point[i] = finite_field(point[i])
        diff_point[i] = finite_field(point[i])
      
    i = len(scalar_list) - 1
    while(scalar_list[i] != 1):
        i = i - 1
    while i != 0:
        if(scalar_list[i] == 1):
            r1_point, r0_point = point_differential_addition_doubling(finite_field, curve_constants, r0_point, r1_point, diff_point)
        else:
            r0_point, r1_point = point_differential_addition_doubling(finite_field, curve_constants, r0_point, r1_point, diff_point)
        i = i - 1 

    if(scalar_list[i] == 1):
        r1_point, r0_point = point_differential_addition_doubling(finite_field, curve_constants, r0_point, r1_point, diff_point)
    else:
        r0_point, r1_point = point_differential_addition_doubling(finite_field, curve_constants, r0_point, r1_point, diff_point)
    return r0_point
    
    
def convert_short_weierstrass_curve_to_short_weierstrass_curve(finite_field, curve_constants):
    short_weierstrass_a = finite_field(curve_constants[0])
    short_weierstrass_b = finite_field(curve_constants[1])
    return (short_weierstrass_a, short_weierstrass_b)

def convert_edwards_curve_to_short_weierstrass_curve(finite_field, curve_constants):
    edwards_d = finite_field(curve_constants[0])
    edwards_c = finite_field(curve_constants[1])
    edwards_e = finite_field(1)-edwards_d*edwards_c^4
    montgomery_A = (finite_field(4)/edwards_e - finite_field(2))
    montgomery_B = finite_field(1)/(edwards_e)
    montgomery_A_square = (montgomery_A)^2
    montgomery_A_cube = montgomery_A_square*(montgomery_A)
    montgomery_B_square = finite_field(3)*(montgomery_B)^2
    montgomery_B_cube = finite_field(9)*montgomery_B_square*(montgomery_B)
    short_weierstrass_a = (finite_field(3) - (montgomery_A_square))/(montgomery_B_square)
    short_weierstrass_b = montgomery_A*(finite_field(2)*(montgomery_A_square) - finite_field(9))/(montgomery_B_cube)
    return (short_weierstrass_a, short_weierstrass_b)
   
def convert_short_weierstrass_homogeneous_point_to_short_weierstrass_affine_point(finite_field, curve_parameters, point):
    affine_point = [0, 0]
    inverted_point = (finite_field(point[2]))^(-1)
    affine_point[0] = finite_field(point[0])*inverted_point
    affine_point[1] = finite_field(point[1])*inverted_point
    return affine_point   
    
def convert_edwards_projective_point_to_short_weierstrass_affine_point(finite_field, curve_parameters, point):
    affine_point = [0, 0]
    point_montgomery = [0, 0]
    short_weistrass_affine_point = [0, 0]
    curve_constants = curve_parameters[4]
    inverted_point = (finite_field(point[2]))^(-1)
    affine_point[0] = finite_field(point[0])*inverted_point
    affine_point[1] = finite_field(point[1])*inverted_point
    edwards_c = finite_field(curve_constants[1])
    edwards_d = finite_field(curve_constants[0])
    edwards_e = finite_field(1)-edwards_d*edwards_c^4
    
    montgomery_A = (finite_field(4)*(edwards_e^(-1)) - finite_field(2))
    montgomery_B = finite_field(1)*(edwards_e^(-1))
    point_montgomery[0] = (edwards_c + affine_point[1])*((edwards_c - affine_point[1])^(-1))
    point_montgomery[1] = finite_field(2)*edwards_c*point_montgomery[0]*(affine_point[0]^(-1))
    short_weistrass_affine_point[0] = (point_montgomery[0] + montgomery_A*(finite_field(3)^(-1)))*(montgomery_B^(-1))
    short_weistrass_affine_point[1] = point_montgomery[1]*(montgomery_B^(-1))
    return short_weistrass_affine_point
        
def test_curve_scalar_multiplication_single_iteraction(finite_field, curve_parameters, scalar_multiplication, point_internal_system, point_short_weierstrass, scalar):
    coordinate_system = curve_parameters[7]
    curve_constants = curve_parameters[4]
    error_computations = false
    curve_private_point = scalar * point_short_weierstrass
    test_curve_private_point = scalar_multiplication(finite_field, curve_parameters, point_internal_system, scalar)
    test_curve_private_point_short_weierstrass = coordinate_system[2](finite_field, curve_parameters, test_curve_private_point)
    
    if(str(curve_private_point[0]) != str(test_curve_private_point_short_weierstrass[0])):
        error_computations = true
    if(str(curve_private_point[1]) != str(test_curve_private_point_short_weierstrass[1])):
        error_computations = true
    if(error_computations):
        print("Computational Error")
        print("Seed: " + str(initial_seed()))
        print(Curve)
        print("Private Scalar = " + str(scalar))
        print("True Curve Private Point: ")
        print("X =    " + str(curve_private_point[0]))
        print("Y =    " + str(curve_private_point[1]))
        print("Computed Curve Private Point: ")
        print("X =    " + str(test_curve_private_point_short_weierstrass[0]))
        print("Y =    " + str(test_curve_private_point_short_weierstrass[1]))
        return 1
    return 0

def test_curve_scalar_multiplication(curve_parameters, number_of_tests, underlying_arithmetic = 0, scalar_multiplication = scalar_point_multiplication_1, word_size = 17, number_of_bits_added = 5):
    coordinate_system = curve_parameters[7]
    finite_field = GF(curve_parameters[1])
    if(underlying_arithmetic == 0):
        final_arithmetic = finite_field
    elif(underlying_arithmetic == 1):
        prime = curve_parameters[1]
        base_arithmetic = generate_base_arithmetic(word_size, int(prime).bit_length(), number_of_bits_added, True, prime)
        final_arithmetic = base_arithmetic
    elif(underlying_arithmetic == 2):
        prime = curve_parameters[1]
        base_arithmetic = generate_base_arithmetic(word_size, int(prime).bit_length(), number_of_bits_added, False, prime)
        final_arithmetic = base_arithmetic
    curve_constants_internal_system = curve_parameters[4]
    curve_constants_short_weierstrass = curve_parameters[5](finite_field, curve_constants_internal_system)
    E = EllipticCurve(finite_field, curve_constants_short_weierstrass)
    E.set_order(curve_parameters[2])
    generator_point_internal_system = curve_parameters[6]
    generator_point_short_weierstrass = coordinate_system[2](finite_field, curve_parameters, generator_point_internal_system)
    generator_point_short_weierstrass = E(generator_point_short_weierstrass)
    number_of_errors = 0
    for i in range(number_of_tests):
        if((i % 100) == 0):
            print("Iteration " + str(i))
        scalar = Integer(randrange(1,E.order()))
        number_of_errors += test_curve_scalar_multiplication_single_iteraction(final_arithmetic, curve_parameters, scalar_multiplication, generator_point_internal_system, generator_point_short_weierstrass, scalar)

    print("Number of errors " + str(number_of_errors))
    print("Finished")
    
def print_VHDL_ECC_scalar_test(VHDL_memory_file_name, curve_parameters, word_size, number_of_bits_added, scalar_multiplication=scalar_point_multiplication_1, VHDL_values_address_file_name=""):
    VHDL_memory_file = open(VHDL_memory_file_name, 'w')
    if VHDL_values_address_file_name:
        VHDL_values_address_file = open(VHDL_values_address_file_name, 'w')
        begin_name_position_string = "weierstrass_load_memory_base_address_"
        end_name_position_string = " : integer := "
        end_number_position_string = ";"
    coordinate_system = curve_parameters[7]
    
    base_arithmetic = generate_base_arithmetic(word_size, int(curve_parameters[1]).bit_length(), number_of_bits_added, False, curve_parameters[1])
    
    Montgomery_n_num_words = base_arithmetic.arithmetic_parameters[7]
    curve_constants_internal_system = curve_parameters[4]
    generator_point_internal_system = curve_parameters[6]
    scalar = Integer(randrange(1,  curve_parameters[2]))
    list_scalar = integer_to_list(word_size, Montgomery_n_num_words, scalar)
    
    test_curve_private_point = scalar_multiplication(base_arithmetic, curve_parameters, generator_point_internal_system, scalar)
    test_curve_private_point_short_weierstrass = coordinate_system[2](base_arithmetic, curve_parameters, test_curve_private_point)
    
    if VHDL_values_address_file_name:
        position = 0
        VHDL_values_address_file.write(begin_name_position_string + "n" + end_name_position_string + str(position) + end_number_position_string + "\n")
    print_list_VHDL_memory(VHDL_memory_file, word_size, base_arithmetic.arithmetic_parameters[3], Montgomery_n_num_words, 0)
    if VHDL_values_address_file_name:
        position += Montgomery_n_num_words
        VHDL_values_address_file.write(begin_name_position_string + "n_line" + end_name_position_string + str(position) + end_number_position_string + "\n")
    print_value_VHDL_memory(VHDL_memory_file, word_size, base_arithmetic.arithmetic_parameters[16], 1, 0)
    if VHDL_values_address_file_name:
        position += 1
        VHDL_values_address_file.write(begin_name_position_string + "r2" + end_name_position_string + str(position) + end_number_position_string + "\n")
    print_list_VHDL_memory(VHDL_memory_file, word_size, base_arithmetic.arithmetic_parameters[13], Montgomery_n_num_words, 0)        
    
    for i in range(len(curve_constants_internal_system)):
        curve_constant_list_without_r2 = base_arithmetic(curve_constants_internal_system[i]).get_value(True, False)
        curve_constant_list_with_r2 = base_arithmetic(curve_constants_internal_system[i]).get_value(False, False)
        if VHDL_values_address_file_name:
            position += Montgomery_n_num_words
            VHDL_values_address_file.write(begin_name_position_string + "curve_constant_" + str(i) + end_name_position_string + str(position) + end_number_position_string + "\n")
        print_list_VHDL_memory(VHDL_memory_file, word_size, curve_constant_list_without_r2, Montgomery_n_num_words, 0)
        if VHDL_values_address_file_name:
            position += Montgomery_n_num_words
            VHDL_values_address_file.write(begin_name_position_string + "curve_constant_" + str(i) + "_in_r2" + end_name_position_string + str(position) + end_number_position_string + "\n")
        print_list_VHDL_memory(VHDL_memory_file, word_size, curve_constant_list_with_r2, Montgomery_n_num_words, 0)
    
    if VHDL_values_address_file_name:
        position += Montgomery_n_num_words
        VHDL_values_address_file.write(begin_name_position_string + "scalar_number" + end_name_position_string + str(position) + end_number_position_string + "\n")
    print_list_VHDL_memory(VHDL_memory_file, word_size, list_scalar, Montgomery_n_num_words, 0)
    
    for i in range(len(generator_point_internal_system)):
        point_internal_system_list_without_r2 = base_arithmetic(generator_point_internal_system[i]).get_value(True, False)
        point_internal_system_list_with_r2 = base_arithmetic(generator_point_internal_system[i]).get_value(False, False)
        if VHDL_values_address_file_name:
            position += Montgomery_n_num_words
            VHDL_values_address_file.write(begin_name_position_string + "point_coordinate_" + str(i) + end_name_position_string + str(position) + end_number_position_string + "\n")
        print_list_VHDL_memory(VHDL_memory_file, word_size, point_internal_system_list_without_r2, Montgomery_n_num_words, 0)
        if VHDL_values_address_file_name:
            position += Montgomery_n_num_words
            VHDL_values_address_file.write(begin_name_position_string + "point_coordinate_" + str(i) + "_in_r2" + end_name_position_string + str(position) + end_number_position_string + "\n")
        print_list_VHDL_memory(VHDL_memory_file, word_size, point_internal_system_list_with_r2, Montgomery_n_num_words, 0)
    
    for i in range(len(test_curve_private_point)):
        test_curve_private_point_list_without_r2 = base_arithmetic(test_curve_private_point[i]).get_value(True, False)
        test_curve_private_point_list_with_r2 = base_arithmetic(test_curve_private_point[i]).get_value(False, False)
        if VHDL_values_address_file_name:
            position += Montgomery_n_num_words
            VHDL_values_address_file.write(begin_name_position_string + "scalar_point_coordinate_" + str(i) + end_name_position_string + str(position) + end_number_position_string + "\n")
        print_list_VHDL_memory(VHDL_memory_file, word_size, test_curve_private_point_list_without_r2, Montgomery_n_num_words, 0)
        if VHDL_values_address_file_name:
            position += Montgomery_n_num_words
            VHDL_values_address_file.write(begin_name_position_string + "scalar_point_coordinate_" + str(i) + "_in_r2" + end_name_position_string + str(position) + end_number_position_string + "\n")
        print_list_VHDL_memory(VHDL_memory_file, word_size, test_curve_private_point_list_with_r2, Montgomery_n_num_words, 0)        
        
    for i in range(len(test_curve_private_point_short_weierstrass)):
        test_curve_private_point_short_weierstrass_list_without_r2 = base_arithmetic(test_curve_private_point_short_weierstrass[i]).get_value(True, False)
        test_curve_private_point_short_weierstrass_list_with_r2 = base_arithmetic(test_curve_private_point_short_weierstrass[i]).get_value(False, False)
        if VHDL_values_address_file_name:
            position += Montgomery_n_num_words
            VHDL_values_address_file.write(begin_name_position_string + "affine_scalar_point_coordinate_" + str(i) + end_name_position_string + str(position) + end_number_position_string + "\n")
        print_list_VHDL_memory(VHDL_memory_file, word_size, test_curve_private_point_short_weierstrass_list_without_r2, Montgomery_n_num_words, 0)
        if VHDL_values_address_file_name:
            position += Montgomery_n_num_words
            VHDL_values_address_file.write(begin_name_position_string + "affine_scalar_point_coordinate_" + str(i) + "_in_r2" + end_name_position_string + str(position) + end_number_position_string + "\n")
        print_list_VHDL_memory(VHDL_memory_file, word_size, test_curve_private_point_short_weierstrass_list_with_r2, Montgomery_n_num_words, 0)
        
    if VHDL_values_address_file_name:
        VHDL_values_address_file.close()
    VHDL_memory_file.close()

def print_VHDL_all_ECC_scalar_tests(ECC_parameters, first_parameter, last_parameter, word_size, number_of_bits_added):
    ecc_folder = "ecc_tests/"
    if(not os.path.isdir(ecc_folder)):
        os.makedirs(ecc_folder)
    begin_file_name = "weierstrass_processor_"
    end_memory_file_name = "_test.dat"
    end_values_address_file_name = "_test_address.dat"
    for i in range(first_parameter, last_parameter+1, 1):
        VHDL_values_address_file_name = ecc_folder + begin_file_name + str(ECC_parameters[i][0]) + end_values_address_file_name
        VHDL_memory_file_name = ecc_folder + begin_file_name + str(ECC_parameters[i][0]) + end_memory_file_name
        print_VHDL_ECC_scalar_test(VHDL_memory_file_name, ECC_parameters[i], word_size, number_of_bits_added, scalar_point_multiplication_1, VHDL_values_address_file_name)
        print("ECC scalar test on " + ECC_parameters[i][0])
    print("Finished")
    
def load_VHDL_ECC_scalar_test(VHDL_memory_file_name, curve_parameters, word_size, number_of_bits_added, scalar_multiplication=scalar_point_multiplication_1):
    VHDL_memory_file = open(VHDL_memory_file_name, 'r')
    coordinate_system = curve_parameters[7]
    
    base_arithmetic = generate_base_arithmetic(word_size, int(curve_parameters[1]).bit_length(), number_of_bits_added, False, curve_parameters[1])
    Montgomery_n_num_words = base_arithmetic.arithmetic_parameters[7]

    value_loaded = load_list_VHDL_memory(VHDL_memory_file, word_size, Montgomery_n_num_words)
    value_internal = base_arithmetic.arithmetic_parameters[3]
    if(value_internal != value_loaded):
        print("Primes does not match")
        print("Prime inside :")
        print(value_internal)
        print("Prime read :")
        print(value_loaded)
    value_loaded = load_value_VHDL_memory(VHDL_memory_file, word_size, 1)
    value_internal = base_arithmetic.arithmetic_parameters[16]
    if(value_internal != value_loaded):
        print("Prime' does not match")
        print("Prime' inside :")
        print(value_internal)
        print("Prime' read :")
        print(value_loaded)
    value_loaded = load_list_VHDL_memory(VHDL_memory_file, word_size, Montgomery_n_num_words)
    value_internal = base_arithmetic.arithmetic_parameters[13]
    if(value_internal != value_loaded):
        print("R^2 does not match")
        print("R^2 inside :")
        print(value_internal)
        print("R^2 read :")
        print(value_loaded)
    
    curve_constants_internal_system = curve_parameters[4]
    
    for i in range(len(curve_constants_internal_system)):
        value_loaded_without_r2 = load_list_VHDL_memory(VHDL_memory_file, word_size, Montgomery_n_num_words)
        value_loaded_with_r2 = load_list_VHDL_memory(VHDL_memory_file, word_size, Montgomery_n_num_words)
        value_internal_without_r2 = base_arithmetic(curve_constants_internal_system[i]).get_value(True, False)
        value_internal_with_r2 = base_arithmetic(curve_constants_internal_system[i]).get_value(False, False)
        if((value_loaded_without_r2 != value_internal_without_r2) or (value_loaded_with_r2 != value_internal_with_r2)):
            print("Curve constant " + str(i) + " does not match")
            print("Value inside without r2 :")
            print(value_internal_without_r2)
            print("value read without r2 :")
            print(value_loaded_without_r2)
            print("Value inside with r2 :")
            print(value_internal_with_r2)
            print("value read with r2 :")
            print(value_loaded_with_r2)
            
    list_scalar = load_list_VHDL_memory(VHDL_memory_file, word_size, Montgomery_n_num_words)
    scalar = list_to_integer(word_size, Montgomery_n_num_words, list_scalar)
    
    generator_point_internal_system = curve_parameters[6]
    
    for i in range(len(generator_point_internal_system)):
        value_loaded_without_r2 = load_list_VHDL_memory(VHDL_memory_file, word_size, Montgomery_n_num_words)
        value_loaded_with_r2 = load_list_VHDL_memory(VHDL_memory_file, word_size, Montgomery_n_num_words)
        value_internal_without_r2 = base_arithmetic(generator_point_internal_system[i]).get_value(True, False)
        value_internal_with_r2 = base_arithmetic(generator_point_internal_system[i]).get_value(False, False)
        if((value_loaded_without_r2 != value_internal_without_r2) or (value_loaded_with_r2 != value_internal_with_r2)):
            print("Curve point to compute " + str(i) + " does not match")
            print("Value inside without r2 :")
            print(value_internal_without_r2)
            print("value read without r2 :")
            print(value_loaded_without_r2)
            print("Value inside with r2 :")
            print(value_internal_with_r2)
            print("value read with r2 :")
            print(value_loaded_with_r2)
            
    test_curve_private_point = scalar_multiplication(base_arithmetic, curve_parameters, generator_point_internal_system, scalar)
    test_curve_private_point_short_weierstrass = coordinate_system[2](base_arithmetic, curve_parameters, test_curve_private_point)
    
    for i in range(len(test_curve_private_point)):
        value_loaded_without_r2 = load_list_VHDL_memory(VHDL_memory_file, word_size, Montgomery_n_num_words)
        value_loaded_with_r2 = load_list_VHDL_memory(VHDL_memory_file, word_size, Montgomery_n_num_words)
        value_internal_without_r2 = base_arithmetic(test_curve_private_point[i]).get_value(True, False)
        value_internal_with_r2 = base_arithmetic(test_curve_private_point[i]).get_value(False, False)
        if((value_loaded_without_r2 != value_internal_without_r2) or (value_loaded_with_r2 != value_internal_with_r2)):
            print("Test curve point in the internal coordinate system " + str(i) + " does not match")
            print("Value inside without r2 :")
            print(value_internal_without_r2)
            print("value read without r2 :")
            print(value_loaded_without_r2)
            print("Value inside with r2 :")
            print(value_internal_with_r2)
            print("value read with r2 :")
            print(value_loaded_with_r2)
            
    for i in range(len(test_curve_private_point_short_weierstrass)):
        value_loaded_without_r2 = load_list_VHDL_memory(VHDL_memory_file, word_size, Montgomery_n_num_words)
        value_loaded_with_r2 = load_list_VHDL_memory(VHDL_memory_file, word_size, Montgomery_n_num_words)
        value_internal_without_r2 = base_arithmetic(test_curve_private_point_short_weierstrass[i]).get_value(True, False)
        value_internal_with_r2 = base_arithmetic(test_curve_private_point_short_weierstrass[i]).get_value(False, False)
        if((value_loaded_without_r2 != value_internal_without_r2) or (value_loaded_with_r2 != value_internal_with_r2)):
            print("Test curve point in affine " + str(i) + " does not match")
            print("Value inside without r2 :")
            print(value_internal_without_r2)
            print("value read without r2 :")
            print(value_loaded_without_r2)
            print("Value inside with r2 :")
            print(value_internal_with_r2)
            print("value read with r2 :")
            print(value_loaded_with_r2)
        
    VHDL_memory_file.close()
    
    

    
def print_ECC_all_names_and_positions(ECC_parameters):
    for i in range(len(ECC_parameters)):
        print (ECC_parameters[i][0] + " at index " + str(i))
    
    
 
short_weierstrass_homogeneus_formulas = [
# Addition Formula (function)
short_weierstrass_point_addition_complete_all_a_1,
# Doubling Formula (function)
short_weierstrass_point_doubling_complete_all_a_1,
# Addition and Doubling formula (function)
None,
# Differential Addition formula (function)
None,
# Differential Addition and Doubling formula (function)
None,
]

edwards_projective_formulas = [
# Addition Formula (function)
edwards_point_addition_for_c_1_1,
# Doubling Formula (function)
edwards_point_doubling_for_c_1_1,
# Addition and Doubling formula (function)
None,
# Differential Addition formula (function)
None,
# Differential Addition and Doubling formula (function)
None,
]

short_weierstrass_homogeneus_coordinate = [
# Coordinate system name
"Homogeneous",
# Point Infinity
(
# x0
0,
# y0
1,
# z0
0
),
# This system to affine (function)
convert_short_weierstrass_homogeneous_point_to_short_weierstrass_affine_point,
# Formulas for this coordinate system
short_weierstrass_homogeneus_formulas
]

edwards_projective_coordinate = [
# Coordinate system name
"Projective",
# Point Infinity
(
# x0
0,
# y0
1,
# z0
1
),
# This system to affine (function)
convert_edwards_projective_point_to_short_weierstrass_affine_point,
# Formulas for this coordinate system
edwards_projective_formulas
]

ECC_parameters = [
# Curve For testing
# Curve name
("Test_Curve_B",
# Curve prime
2^127-1,
# Curve order
170141183460469231736664919621903309009,
# Curve shape
"swei",
#
# Curve constants in internal format
(
# Parameter a for Short Weierstrass shape
2^127 - 1 - 3,
# Parameter b for Short Weierstrass shape
8642617265606119756624302658608997527
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_short_weierstrass_curve_to_short_weierstrass_curve,
#
#
# Point Generator (List)
(
# x0 for generator point in Short Weierstrass shape
115900608371722665472666576521720205897,
# y0 for generator point in Short Weierstrass shape
146420604775552775501991731846769980229,
# z0 for generator point in Short Weierstrass shape
1
),
# Curve coordinate system
short_weierstrass_homogeneus_coordinate
),
# Curve NIST P-192, secp192r1
# Curve name
("NIST_P192",
# Curve prime
2^192 - 2^64 - 1,
# Curve order
6277101735386680763835789423176059013767194773182842284081,
# Curve shape
"swei",
#
# Curve constants in internal format
(
# Parameter a for Short Weierstrass shape
2^192 - 2^64 - 1 - 3,
# Parameter b for Short Weierstrass shape
2455155546008943817740293915197451784769108058161191238065
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_short_weierstrass_curve_to_short_weierstrass_curve,
#
#
# Point Generator (List)
(
# x0 for generator point in Short Weierstrass shape
602046282375688656758213480587526111916698976636884684818,
# y0 for generator point in Short Weierstrass shape
174050332293622031404857552280219410364023488927386650641,
# z0 for generator point in Short Weierstrass shape
1
),
# Curve coordinate system
short_weierstrass_homogeneus_coordinate
),
#
# Curve NIST P-224, secp224r1
# Curve name
("NIST_P224",
# Curve prime
2^224 - 2^96 + 1,
# Curve order
26959946667150639794667015087019625940457807714424391721682722368061,
# Curve shape
"swei",
#
# Curve constants in internal format
(
# Parameter a for Short Weierstrass shape
2^224 - 2^96 + 1 - 3,
# Parameter b for Short Weierstrass shape
18958286285566608000408668544493926415504680968679321075787234672564
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_short_weierstrass_curve_to_short_weierstrass_curve,
#
#
# Point Generator (List)
(
# x0 for generator point in Short Weierstrass shape
19277929113566293071110308034699488026831934219452440156649784352033,
# y0 for generator point in Short Weierstrass shape
19926808758034470970197974370888749184205991990603949537637343198772,
# z0 for generator point in Short Weierstrass shape
1
),
# Curve coordinate system
short_weierstrass_homogeneus_coordinate
),
#
# Curve NIST P-256, secp256r1
# Curve name
("NIST_P256",
# Curve prime
2^256 - 2^224 + 2^192 + 2^96 - 1,
# Curve order
115792089210356248762697446949407573529996955224135760342422259061068512044369,
# Curve shape
"swei",
#
# Curve constants in internal shape
(
# Parameter a for Short Weierstrass shape
2^256 - 2^224 + 2^192 + 2^96 - 1 - 3,
# Parameter b for Short Weierstrass shape
41058363725152142129326129780047268409114441015993725554835256314039467401291
),
#
# Function to convert curve constants into Short Weierstrass
convert_short_weierstrass_curve_to_short_weierstrass_curve,
#
#
# Point Generator (List)
(
# x0 for base point in Short Weierstrass shape
48439561293906451759052585252797914202762949526041747995844080717082404635286,
# y0 for base point in Short Weierstrass shape
36134250956749795798585127919587881956611106672985015071877198253568414405109,
# z0 for generator point in Short Weierstrass shape
1
),
# Curve coordinate system
short_weierstrass_homogeneus_coordinate
),
#
# Curve NIST P-384, secp384r1
# Curve name
("NIST_P384",
# Curve prime
2^384 - 2^128 - 2^96 + 2^32 - 1,
# Curve order
39402006196394479212279040100143613805079739270465446667946905279627659399113263569398956308152294913554433653942643,
# Curve shape
"swei",
#
# Curve constants in internal shape
(
# Parameter a for Short Weierstrass shape
2^384 - 2^128 - 2^96 + 2^32 - 1 - 3,
# Parameter b for Short Weierstrass shape
27580193559959705877849011840389048093056905856361568521428707301988689241309860865136260764883745107765439761230575
),
#
# Function to convert curve constants into Short Weierstrass
convert_short_weierstrass_curve_to_short_weierstrass_curve,
#
#
# Point Generator (List)
(
# x0 for base point in Short Weierstrass shape
26247035095799689268623156744566981891852923491109213387815615900925518854738050089022388053975719786650872476732087,
# y0 for base point in Short Weierstrass shape
8325710961489029985546751289520108179287853048861315594709205902480503199884419224438643760392947333078086511627871,
# z0 for generator point in Short Weierstrass shape
1
),
# Curve coordinate system
short_weierstrass_homogeneus_coordinate
),
#
# Curve NIST P-521, secp521r1
# Curve name
("NIST_P521",
# Curve prime
2^521 - 1,
# Curve order
6864797660130609714981900799081393217269435300143305409394463459185543183397655394245057746333217197532963996371363321113864768612440380340372808892707005449,
# Curve shape
"swei",
#
# Curve constants in internal shape
(
# Parameter a for Short Weierstrass shape
2^521 - 1 - 3,
# Parameter b for Short Weierstrass shape
1093849038073734274511112390766805569936207598951683748994586394495953116150735016013708737573759623248592132296706313309438452531591012912142327488478985984
),
#
# Function to convert curve constants into Short Weierstrass
convert_short_weierstrass_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Short Weierstrass shape
2661740802050217063228768716723360960729859168756973147706671368418802944996427808491545080627771902352094241225065558662157113545570916814161637315895999846,
# y0 for base point in Short Weierstrass shape
3757180025770020463545507224491183603594455134769762486694567779615544477440556316691234405012945539562144444537289428522585666729196580810124344277578376784,
# z0 for generator point in Short Weierstrass shape
1
),
# Curve coordinate system
short_weierstrass_homogeneus_coordinate
),
#
# Curve BrainpoolP160r1
# Curve name
("BrainpoolP160r1",
# Curve prime
1332297598440044874827085558802491743757193798159,
# Curve order
1332297598440044874827085038830181364212942568457,
# Curve shape
"swei",
# Curve constants in internal shape
(
# Parameter a for Short Weierstrass shape
297190522446607939568481567949428902921613329152,
# Parameter b for Short Weierstrass shape
173245649450172891208247283053495198538671808088
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_short_weierstrass_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Short Weierstrass shape
1089473557631435284577962539738532515920566082499,
# y0 for base point in Short Weierstrass shape
127912481829969033206777085249718746721365418785,
# z0 for base point in Short Weierstrass shape
1
),
# Curve coordinate system
short_weierstrass_homogeneus_coordinate
),
#
# Curve BrainpoolP160t1
# Curve name
("BrainpoolP160t1",
# Curve prime
1332297598440044874827085558802491743757193798159,
# Curve order
1332297598440044874827085038830181364212942568457,
# Curve shape
"swei",
#
# Curve constants in internal shape
(
# Parameter a for Short Weierstrass shape
1332297598440044874827085558802491743757193798156,
# Parameter b for Short Weierstrass shape
698401795719474705027684479972917623041381757824
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_short_weierstrass_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Short Weierstrass shape
1013918819608769552616977083272059630517089149816,
# y0 for base point in Short Weierstrass shape
992437653978037713070561264469524978381944905901,
# z0 for base point in Short Weierstrass shape
1
),
# Curve coordinate system
short_weierstrass_homogeneus_coordinate
),
#
# Curve BrainpoolP192r1
# Curve name
("BrainpoolP192r1",
# Curve prime
4781668983906166242955001894344923773259119655253013193367,
# Curve order
4781668983906166242955001894269038308119863659119834868929,
# Curve shape
"swei",
#
# Curve constants in internal shape
(
# Parameter a for Short Weierstrass shape
2613009377683017747869391908421543348309181741502784219375,
# Parameter b for Short Weierstrass shape
1731160591135112004210203499537764623771657619977468323273
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_short_weierstrass_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Short Weierstrass shape
4723188856514392935399337699153522173525168621081341681622,
# y0 for base point in Short Weierstrass shape
507884783101387741749746950209061101579755255809652136847,
# z0 for base point in Short Weierstrass shape
1
),
# Curve coordinate system
short_weierstrass_homogeneus_coordinate
),
#
# Curve BrainpoolP192t1
# Curve name
("BrainpoolP192t1",
# Curve prime
4781668983906166242955001894344923773259119655253013193367,
# Curve order
4781668983906166242955001894269038308119863659119834868929,
# Curve shape
"swei",
#
# Curve constants in internal shape
(
# Parameter a for Short Weierstrass shape
4781668983906166242955001894344923773259119655253013193364,
# Parameter b for Short Weierstrass shape
486321888066950067394881041525590797530120076120499518329
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_short_weierstrass_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Short Weierstrass shape
1444558712667280506885530592978306040338136913835324440873,
# y0 for base point in Short Weierstrass shape
232764348904945951820395534722141373682806994795615748553,
# z0 for base point in Short Weierstrass shape
1
),
# Curve coordinate system
short_weierstrass_homogeneus_coordinate
),
#
# Curve BrainpoolP224r1
# Curve name
("BrainpoolP224r1",
# Curve prime
22721622932454352787552537995910928073340732145944992304435472941311,
# Curve order
22721622932454352787552537995910923612567546342330757191396560966559,
# Curve shape
"swei",
#
# Curve constants in internal shape
(
# Parameter a for Short Weierstrass shape
11020725272625742361946480833014344015343456918668456061589001510723,
# Parameter b for Short Weierstrass shape
3949606626053374030787926457695139766118442946052311411513528958987
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_short_weierstrass_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Short Weierstrass shape
1428364927244201726431498207475486496993067267318520844137448783997,
# y0 for base point in Short Weierstrass shape
9337555360448823227812410753177468631215558779020518084752618816205,
# z0 for base point in Short Weierstrass shape
1
),
# Curve coordinate system
short_weierstrass_homogeneus_coordinate
),
#
# Curve BrainpoolP224t1
# Curve name
("BrainpoolP224t1",
# Curve prime
22721622932454352787552537995910928073340732145944992304435472941311,
# Curve order
22721622932454352787552537995910923612567546342330757191396560966559,
# Curve shape
"swei",
#
# Curve constants in internal shape
(
# Parameter a for Short Weierstrass shape
22721622932454352787552537995910928073340732145944992304435472941308,
# Parameter b for Short Weierstrass shape
7919603849831377222129533323916957959225380016698795812027476510861
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_short_weierstrass_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Short Weierstrass shape
11236281700362234642592534287151572422539408672654616227474732012928,
# y0 for base point in Short Weierstrass shape
364032462118593425315751587028126980694396626774408344039871404876,
# z0 for base point in Short Weierstrass shape
1
),
# Curve coordinate system
short_weierstrass_homogeneus_coordinate
),
#
# Curve BrainpoolP256r1
# Curve name
("BrainpoolP256r1",
# Curve prime
0xA9FB57DBA1EEA9BC3E660A909D838D726E3BF623D52620282013481D1F6E5377,
# Curve order
0xA9FB57DBA1EEA9BC3E660A909D838D718C397AA3B561A6F7901E0E82974856A7,
# Curve shape
"swei",
#
# Curve constants in internal shape
(
# Parameter a for Short Weierstrass shape
56698187605326110043627228396178346077120614539475214109386828188763884139993,
# Parameter b for Short Weierstrass shape
17577232497321838841075697789794520262950426058923084567046852300633325438902
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_short_weierstrass_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Short Weierstrass shape
63243729749562333355292243550312970334778175571054726587095381623627144114786,
# y0 for base point in Short Weierstrass shape
38218615093753523893122277964030810387585405539772602581557831887485717997975,
# z0 for base point in Short Weierstrass shape
1
),
# Curve coordinate system
short_weierstrass_homogeneus_coordinate
),
#
# Curve BrainpoolP256t1
# Curve name
("BrainpoolP256t1",
# Curve prime
0xA9FB57DBA1EEA9BC3E660A909D838D726E3BF623D52620282013481D1F6E5377,
# Curve order
0xA9FB57DBA1EEA9BC3E660A909D838D718C397AA3B561A6F7901E0E82974856A7,
# Curve shape
"swei",
#
# Curve constants in internal shape
(
# Parameter a for Short Weierstrass shape
0xA9FB57DBA1EEA9BC3E660A909D838D726E3BF623D52620282013481D1F6E5374,
# Parameter b for Short Weierstrass shape
0x662C61C430D84EA4FE66A7733D0B76B7BF93EBC4AF2F49256AE58101FEE92B04
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_short_weierstrass_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Short Weierstrass shape
0xA3E8EB3CC1CFE7B7732213B23A656149AFA142C47AAFBC2B79A191562E1305F4,
# y0 for base point in Short Weierstrass shape
0x2D996C823439C56D7F7B22E14644417E69BCB6DE39D027001DABE8F35B25C9BE,
# z0 for base point in Short Weierstrass shape
1
),
# Curve coordinate system
short_weierstrass_homogeneus_coordinate
),
#
# Curve BrainpoolP320r1
# Curve name
("BrainpoolP320r1",
# Curve prime
1763593322239166354161909842446019520889512772719515192772960415288640868802149818095501499903527,
# Curve order
1763593322239166354161909842446019520889512772717686063760686124016784784845843468355685258203921,
# Curve shape
"swei",
#
# Curve constants in internal shape
(
# Parameter a for Short Weierstrass shape
524709318439392693105919717518043758943240164412117372990311331314771510648804065756354311491252,
# Parameter b for Short Weierstrass shape
684460840191207052139729091116995410883497412720006364295713596062999867796741135919289734394278
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_short_weierstrass_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Short Weierstrass shape
565203972584199378547773331021708157952136817703497461781479793049434111597020229546183313458705,
# y0 for base point in Short Weierstrass shape
175146432689526447697480803229621572834859050903464782210773312572877763380340633688906597830369,
# z0 for base point in Short Weierstrass shape
1
),
# Curve coordinate system
short_weierstrass_homogeneus_coordinate
),
#
# Curve BrainpoolP320t1
# Curve name
("BrainpoolP320t1",
# Curve prime
1763593322239166354161909842446019520889512772719515192772960415288640868802149818095501499903527,
# Curve order
1763593322239166354161909842446019520889512772717686063760686124016784784845843468355685258203921,
# Curve shape
"swei",
#
# Curve constants in internal shape
(
# Parameter a for Short Weierstrass shape
1763593322239166354161909842446019520889512772719515192772960415288640868802149818095501499903524,
# Parameter b for Short Weierstrass shape
1401395435032847536924656852322353441447762422733674743806973258207878888547540276867732868432723
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_short_weierstrass_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Short Weierstrass shape
1221175819973001316491038958226563119032598033059331804921649457916311604176688737745420093746514,
# y0 for base point in Short Weierstrass shape
832095900618272253462376182163435186143818309959785348829039065198217071225345202726924484399811,
# z0 for base point in Short Weierstrass shape
1
),
# Curve coordinate system
short_weierstrass_homogeneus_coordinate
),
#
# Curve BrainpoolP384r1
# Curve name
("BrainpoolP384r1",
# Curve prime
21659270770119316173069236842332604979796116387017648600081618503821089934025961822236561982844534088440708417973331,
# Curve order
21659270770119316173069236842332604979796116387017648600075645274821611501358515537962695117368903252229601718723941,
# Curve shape
"swei",
#
# Curve constants in internal shape
(
# Parameter a for Short Weierstrass shape
19048979039598244295279281525021548448223459855185222892089532512446337024935426033638342846977861914875721218402342,
# Parameter b for Short Weierstrass shape
717131854892629093329172042053689661426642816397448020844407951239049616491589607702456460799758882466071646850065
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_short_weierstrass_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Short Weierstrass shape
4480579927441533893329522230328287337018133311029754539518372936441756157459087304048546502931308754738349656551198,
# y0 for base point in Short Weierstrass shape
21354446258743982691371413536748675410974765754620216137225614281636810686961198361153695003859088327367976229294869,
# z0 for base point in Short Weierstrass shape
1
),
# Curve coordinate system
short_weierstrass_homogeneus_coordinate
),
#
# Curve BrainpoolP384t1
# Curve name
("BrainpoolP384t1",
# Curve prime
21659270770119316173069236842332604979796116387017648600081618503821089934025961822236561982844534088440708417973331,
# Curve order
21659270770119316173069236842332604979796116387017648600075645274821611501358515537962695117368903252229601718723941,
# Curve shape
"swei",
#
# Curve constants in internal shape
(
# Parameter a for Short Weierstrass shape
21659270770119316173069236842332604979796116387017648600081618503821089934025961822236561982844534088440708417973328,
# Parameter b for Short Weierstrass shape
19596161053329239268181228455226581162286252326261019516900162717091837027531392576647644262320816848087868142547438
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_short_weierstrass_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Short Weierstrass shape
3827769047710394604076870463731979903132904572714069494181204655675960538951736634566672590576020545838501853661388,
# y0 for base point in Short Weierstrass shape
5797643717699939326787282953388004860198302425468870641753455602553471777319089854136002629714659021021358409132328,
# z0 for base point in Short Weierstrass shape
1
),
# Curve coordinate system
short_weierstrass_homogeneus_coordinate
),
#
# Curve BrainpoolP512r1
# Curve name
("BrainpoolP512r1",
# Curve prime
8948962207650232551656602815159153422162609644098354511344597187200057010413552439917934304191956942765446530386427345937963894309923928536070534607816947,
# Curve order
8948962207650232551656602815159153422162609644098354511344597187200057010413418528378981730643524959857451398370029280583094215613882043973354392115544169,
# Curve shape
"swei",
#
# Curve constants in internal shape
(
# Parameter a for Short Weierstrass shape
6294860557973063227666421306476379324074715770622746227136910445450301914281276098027990968407983962691151853678563877834221834027439718238065725844264138,
# Parameter b for Short Weierstrass shape
3245789008328967059274849584342077916531909009637501918328323668736179176583263496463525128488282611559800773506973771797764811498834995234341530862286627
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_short_weierstrass_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Short Weierstrass shape
6792059140424575174435640431269195087843153390102521881468023012732047482579853077545647446272866794936371522410774532686582484617946013928874296844351522,
# y0 for base point in Short Weierstrass shape
6592244555240112873324748381429610341312712940326266331327445066687010545415256461097707483288650216992613090185042957716318301180159234788504307628509330,
# z0 for base point in Short Weierstrass shape
1
),
# Curve coordinate system
short_weierstrass_homogeneus_coordinate
),
#
# Curve BrainpoolP512t1
# Curve name
("BrainpoolP512t1",
# Curve prime
8948962207650232551656602815159153422162609644098354511344597187200057010413552439917934304191956942765446530386427345937963894309923928536070534607816947,
# Curve order
8948962207650232551656602815159153422162609644098354511344597187200057010413418528378981730643524959857451398370029280583094215613882043973354392115544169,
# Curve shape
"swei",
#
# Curve constants in internal shape
(
# Parameter a for Short Weierstrass shape
8948962207650232551656602815159153422162609644098354511344597187200057010413552439917934304191956942765446530386427345937963894309923928536070534607816944,
# Parameter b for Short Weierstrass shape
6532815740455945129522030162820444801309011444717674409730083343052139800841847092116476221316466234404847931899409316558007222582458822004777353814164030
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_short_weierstrass_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Short Weierstrass shape
5240454105373391383446315535930423532243726242869439206480578543706358506399554673205583372921814351137736817888782671966171301927338369930113338349467098,
# y0 for base point in Short Weierstrass shape
4783098043208509222858478731459039446855297686825168822962919559100076900387655035060042118755576220187973470126780576052258118403094460341772613532037938,
# z0 for base point in Short Weierstrass shape
1
),
# Curve coordinate system
short_weierstrass_homogeneus_coordinate
),
#
# Curve ANSSI FRP256v1
# Curve name
("ANSSI_FRP256v1",
# Curve prime
0xF1FD178C0B3AD58F10126DE8CE42435B3961ADBCABC8CA6DE8FCF353D86E9C03,
# Curve order
0xF1FD178C0B3AD58F10126DE8CE42435B53DC67E140D2BF941FFDD459C6D655E1,
# Curve shape
"swei",
#
# Curve constants in internal shape
(
# Parameter a for Short Weierstrass shape
0xF1FD178C0B3AD58F10126DE8CE42435B3961ADBCABC8CA6DE8FCF353D86E9C00,
# Parameter b for Short Weierstrass shape
0xEE353FCA5428A9300D4ABA754A44C00FDFEC0C9AE4B1A1803075ED967B7BB73F
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_short_weierstrass_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Short Weierstrass shape
0xB6B3D4C356C139EB31183D4749D423958C27D2DCAF98B70164C97A2DD98F5CFF,
# y0 for base point in Short Weierstrass shape
0x6142E0F7C8B204911F9271F0F3ECEF8C2701C307E8E4C9E183115A1554062CFB,
# z0 for base point in Short Weierstrass shape
1
),
# Curve coordinate system
short_weierstrass_homogeneus_coordinate
),
#
# Curve NUMSP256d1
# Curve name
("NUMS P256d1",
# Curve prime
2^256 - 189,
# Curve order
0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE43C8275EA265C6020AB20294751A825,
# Curve shape
"swei",
#
# Curve constants in internal shape
(
# Parameter a for Short Weierstrass shape
2^256 - 189 - 3,
# Parameter b for Short Weierstrass shape
0x25581
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_short_weierstrass_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Short Weierstrass shape
0xBC9ED6B65AAADB61297A95A04F42CB0983579B0903D4C73ABC52EE1EB21AACB1,
# y0 for base point in Short Weierstrass shape
0xD08FC0F13399B6A673448BF77E04E035C955C3D115310FBB80B5B9CB2184DE9F,
# z0 for base point in Short Weierstrass shape
1
),
# Curve coordinate system
short_weierstrass_homogeneus_coordinate
),
#
# Curve NUMSP384d1
# Curve name
("NUMS P384d1",
# Curve prime
2^384 - 317,
# Curve order
0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD61EAF1EEB5D6881BEDA9D3D4C37E27A604D81F67B0E61B9,
# Curve shape
"swei",
#
# Curve constants in internal shape
(
# Parameter a for Short Weierstrass shape
2^384 - 317 - 3,
# Parameter b for Short Weierstrass shape
0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF77BB
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_short_weierstrass_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Short Weierstrass shape
0x757956F0B16F181C4880CA224105F1A60225C1CDFB81F9F4F3BD291B2A6CC742522EED100F61C47BEB9CBA042098152A,
# y0 for base point in Short Weierstrass shape
0xACDEE368E19B8E38D7E33D300584CF7EB0046977F87F739CB920837D121A837EBCD6B4DBBFF4AD265C74B8EC66180716,
# z0 for base point in Short Weierstrass shape
1
),
# Curve coordinate system
short_weierstrass_homogeneus_coordinate
),
#
# Curve NUMSP512d1
# Curve name
("NUMS P512d1",
# Curve prime
2^512 - 569,
# Curve order
0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5B3CA4FB94E7831B4FC258ED97D0BDC63B568B36607CD243CE153F390433555D,
# Curve shape
"swei",
#
# Curve constants in internal shape
(
# Parameter a for Short Weierstrass shape
2^512 - 569 - 3,
# Parameter b for Short Weierstrass shape
0x1D99B
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_short_weierstrass_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Short Weierstrass shape
0x3AC03447141D0A93DA2B7002A03D3B5298CAD83BB501F6854506E0C25306D9F95021A151076B359E93794286255615831D5D60137D6F5DE2DC8287958CABAE57,
# y0 for base point in Short Weierstrass shape
0x943A54CA29AD56B3CE0EEEDC63EBB1004B97DBDEABBCBB8C8F4B260C7BD14F14A28415DA8B0EEDE9C121A840B25A5602CF2B5C1E4CFD0FE923A08760383527A6,
# z0 for base point in Short Weierstrass shape
1
),
# Curve coordinate system
short_weierstrass_homogeneus_coordinate
),
#
#
# Curve E-157
# Curve name
("E157",
# Curve prime
2^157 - 133,
# Curve order
4*45671926166590716193865246478592509883108923719,
# Curve shape
"edw",
#
# Curve constants in internal shape
(
# Parameter d for Edwards shape
2^157-133-42000,
# Parameter c for Edwards shape
1
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_edwards_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Edwards shape
25153313590402627988339491730610410610877610541,
# y0 for base point in Edwards shape
2,
# z0 for base point in Edwards shape
1
),
# Curve coordinate system
edwards_projective_coordinate
),
#
# Curve E-168
# Curve name
("E168",
# Curve prime
2^168 - 257,
# Curve order
4*93536104789177786765035835538253283032607241942227,
# Curve shape
"edw",
#
# Curve constants in internal shape
(
# Parameter d for Edwards shape
2^168-257-715,
# Parameter c for Edwards shape
1
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_edwards_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Edwards shape
148352553963893577170126950069402109710970006046648,
# y0 for base point in Edwards shape
22,
# z0 for base point in Edwards shape
1
),
# Curve coordinate system
edwards_projective_coordinate
),
#
# Curve E-191
# Curve name
("E191",
# Curve prime
2^190 - 33,
# Curve order
4*392318858461667547739736838961453290575684318090919900773,
# Curve shape
"edw",
#
# Curve constants in internal shape
(
# Parameter d for Edwards shape
2^190-33-15584,
# Parameter c for Edwards shape
1
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_edwards_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Edwards shape
1100946609055651130434287978717144772689725736493488207579,
# y0 for base point in Edwards shape
4,
# z0 for base point in Edwards shape
1
),
# Curve coordinate system
edwards_projective_coordinate
),
#
# Curve E-222
# Curve name
("E222",
# Curve prime
2^222 - 117,
# Curve order
4*1684996666696914987166688442938726735569737456760058294185521417407,
# Curve shape
"edw",
#
# Curve constants in internal shape
(
# Parameter d for Edwards shape
160102,
# Parameter c for Edwards shape
1
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_edwards_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Edwards shape
2705691079882681090389589001251962954446177367541711474502428610129,
# y0 for base point in Edwards shape
28,
# z0 for base point in Edwards shape
1
),
# Curve coordinate system
edwards_projective_coordinate
),
#
# Curve Curve1174
# Curve name
("Curve1174",
# Curve prime
2^251 - 9,
# Curve order
4*904625697166532776746648320380374280092339035279495474023489261773642975601,
# Curve shape
"edw",
#
# Curve constants in internal shape
(
# Parameter d for Edwards shape
2^251 - 9 - 1174,
# Parameter c for Edwards shape
1
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_edwards_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Edwards shape
1582619097725911541954547006453739763381091388846394833492296309729998839514,
# y0 for base point in Edwards shape
3037538013604154504764115728651437646519513534305223422754827055689195992590,
# z0 for base point in Edwards shape
1
),
# Curve coordinate system
edwards_projective_coordinate
),
#
# Curve E-382
# Curve name
("E382",
# Curve prime
2^382 - 105,
# Curve order
4*2462625387274654950767440006258975862817483704404090416745738034557663054564649171262659326683244604346084081047321,
# Curve shape
"edw",
#
# Curve constants in internal shape
(
# Parameter d for Edwards shape
2^382-105 - 67254,
# Parameter c for Edwards shape
1
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_edwards_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Edwards shape
3914921414754292646847594472454013487047137431784830634731377862923477302047857640522480241298429278603678181725699,
# y0 for base point in Edwards shape
17,
# z0 for base point in Edwards shape
1
),
# Curve coordinate system
edwards_projective_coordinate
),
#
# Curve Curve41417
# Curve name
("Curve41417",
# Curve prime
2^414 - 17,
 # Curve order
8*5288447750321988791615322464262168318627237463714249754277190328831105466135348245791335989419337099796002495788978276839289,
# Curve Shape
"edw",
#
# Curve constants in internal shape
(
# Parameter d for Edwards shape
3617,
# Parameter c for Edwards shape
1
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_edwards_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Edwards shape
17319886477121189177719202498822615443556957307604340815256226171904769976866975908866528699294134494857887698432266169206165,
# y0 for base point in Edwards shape
34,
# z0 for base point in Edwards shape
1
),
# Curve coordinate system
edwards_projective_coordinate
),
#
# Curve Ed448-Goldilocks
# Curve name
("Ed448-Goldilocks",
# Curve prime
2^448 - 2^224 - 1,
# Curve order
4*181709681073901722637330951972001133588410340171829515070372549795146003961539585716195755291692375963310293709091662304773755859649779,
# Curve shape
"edw",
#
# Curve constants in internal shape
(
# Parameter d for Edwards shape
2^448 - 2^224 - 1 - 39081,
# Parameter c for Edwards shape
1
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_edwards_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Edwards shape
117812161263436946737282484343310064665180535357016373416879082147939404277809514858788439644911793978499419995990477371552926308078495,
# y0 for base point in Edwards shape
19,
# z0 for base point in Edwards shape
1
),
# Curve coordinate system
edwards_projective_coordinate
),
#
# Curve E-521
# Curve name
("E521",
# Curve prime
2^521 - 1,
# Curve order
4*1716199415032652428745475199770348304317358825035826352348615864796385795849413675475876651663657849636693659065234142604319282948702542317993421293670108523,
# Curve shape
"edw",
#
# Curve constants in internal shape
(
# Parameter d for Edwards shape
2^521 - 1 - 376014,
# Parameter c for Edwards shape
1
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_edwards_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Edwards shape
1571054894184995387535939749894317568645297350402905821437625181152304994381188529632591196067604100772673927915114267193389905003276673749012051148356041324,
# y0 for base point in Edwards shape
12,
# z0 for base point in Edwards shape
1
),
# Curve coordinate system
edwards_projective_coordinate
),
#
# Curve NUMSP256t1
# Curve name
("NUMSP 256t1",
# Curve prime
2^256 - 189,
# Curve order
4*0x4000000000000000000000000000000041955AA52F59439B1A47B190EEDD4AF5,
# Curve shape
"edw",
#
# Curve constants in internal shape
(
# Parameter d for Edwards shape
0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC355,
# Parameter c for Edwards shape
1
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_edwards_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Edwards shape
0x8A7514FB6AEA237DCD1E3D5F69209BD60C398A0EE3083586A0DEC0902EED13DA,
# y0 for base point in Edwards shape
0x44D53E9FD9D925C7CE9665D9A64B8010715F61D810856ED32FA616E7798A89E6,
# z0 for base point in Edwards shape
1
),
# Curve coordinate system
edwards_projective_coordinate
),
#
# Curve NUMSP384t1
# Curve name
("NUMSP 384t1",
# Curve prime
2^384 - 317,
# Curve order
4*0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE2471A1CB46BE1CF61E4555AAB35C87920B9DCC4E6A3897D,
# Curve shape
"edw",
#
# Curve constants in internal shape
(
# Parameter d for Edwards shape
0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD19F,
# Parameter c for Edwards shape
1
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_edwards_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Edwards shape
0x61B111FB45A9266CC0B6A2129AE55DB5B30BF446E5BE4C005763FFA8F33163406FF292B16545941350D540E46C206BDE,
# y0 for base point in Edwards shape
0x82983E67B9A6EEB08738B1A423B10DD716AD8274F1425F56830F98F7F645964B0072B0F946EC48DC9D8D03E1F0729392,
# z0 for base point in Edwards shape
1
),
# Curve coordinate system
edwards_projective_coordinate
),
#
# Curve NUMSP512t1
# Curve name
("NUMSP 512t1",
# Curve prime
2^512 - 569,
# Curve order
4*0x3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB4F0636D2FCF91BA9E3FD8C970B686F52A4605786DEFECFF67468CF51BEED46D,
# Curve shape
"edw",
#
# Curve constants in internal shape
(
# Parameter d for Edwards shape
0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFECBEF,
# Parameter c for Edwards shape
1
),
#
#
# Function to convert curve constants into Short Weierstrass
convert_edwards_curve_to_short_weierstrass_curve,
#
# Point Generator (List)
(
# x0 for base point in Edwards shape
0xDF8E316D128DB69C7A18CB7888D3C5332FD1E79F4DC4A38227A17EBE273B81474621C14EEE46730F78BDC992568904AD0FE525427CC4F015C5B9AB2999EC57FE,
# y0 for base point in Edwards shape
0x6D09BFF39D49CA7198B0F577A82A256EE476F726D8259D22A92B6B95909E834120CA53F2E9963562601A06862AECC1FD0266D38A9BF1D01F326DDEC0C1E2F5E1,
# z0 for base point in Edwards shape
1
),
# Curve coordinate system
edwards_projective_coordinate
)
]

test_curve_scalar_multiplication(ECC_parameters[0], 100000, 1)

#for each_ECC_parameter in ECC_parameters:
#    print("Curve:" + each_ECC_parameter[0])
#    test_curve_scalar_multiplication(each_ECC_parameter, 100, 1)