// first we will define the components
// ----------------------------------------------- 4*1 mux --------------------------------------------------- //
module mux(g,i0,i1,i2,i3,s0,s1);
  // determine input and output
  output wire g ;
  input wire i0,i1,i2,i3,s0,s1 ;

  // determine the wires that connect the inner components
  // the result of each and gate
  wire g0,g1,g2,g3 ;
  wire s0c , s1c ;

  // connect the inner components
  
  // the not gates of the selection inputs (complement of s0 and s1)
  not(s0c,s0) ;
  not(s1c,s1) ;

  // inner wires
  and(g0,i0,s0c,s1c) ;
  and(g1,i1,s0,s1c) ;
  and(g2,i2,s0c,s1) ;
  and(g3,i3,s0,s1) ;

  // output
  or(g,g0,g1,g2,g3) ;
endmodule
// ----------------------------------------------- FullAddder --------------------------------------------------- //
module FullAddder(sum,carry,a,b,c);
    output wire sum,carry;
    input wire a,b,c;
    wire o1,a1,a2;
    xor(o1,a,b);
    and(a1,a,b);
    and(a2,c,o1);
    xor(sum,o1,c);
    or(carry,a1,a2);
endmodule
// ----------------------------------------------- the main module --------------------------------------------------- //
module main(final0,final1,final2,carry ,s0,s1,a0,a1,a2,b0,b1,b2);
  // defin input & output
  input s0,s1,a0,a1,a2,b0,b1,b2 ;
  output final0,final1,final2,carry ;

  // internal wires
  // wire1 : is the wire after the and & not gate of the selections
  // wireA : is the wire before each full adder
  wire notB0 , notB1 , notB2 , wire1 , wireA0 , wireA1 , wireA2 ;   // and result
  wire temp ;       // to store s0&s1  
  wire g0 , g1 , g2 ;   // mux result
  wire c0 , c1 ; // intermediate carries
  reg one = 1 ;     // to store the value 1
  // initialize wires
  not(notB0,b0) ;
  not(notB1,b1) ;
  not(notB2,b2) ;
  and(temp,s0,s1) ;
  not(wire1,temp) ;
  and(wireA0,wire1,a0) ;
  and(wireA1,wire1,a1) ;
  and(wireA2,wire1,a2) ;
  // logic
  // if the selection inputs are s1=0 , s0=0  ---> output will be g = a-1
  // if the selection inputs are s1=0 , s0=1  ---> output will be g = a+b
  // if the selection inputs are s1=1 , s0=0  ---> output will be g = a-b
  // if the selection inputs are s1=1 , s0=1  ---> output will be g = -b
  
  // multiplixers call
  mux m0(g0,one,b0,notB0,notB0,s0,s1) ;
  mux m1(g1,one,b1,notB1,notB1,s0,s1) ;
  mux m2(g2,one,b2,notB2,notB2,s0,s1) ;

  // full adders call
  FullAddder f0(final0,c0,s1,g0,wireA0) ;
  FullAddder f1(final1,c1,c0,g1,wireA1) ;
  FullAddder f2(final2,carry,c1,g2,wireA2) ;

endmodule