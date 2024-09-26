

/*
NOTES:
  B --> multiplier
    This determines we either add a shifted version of the multiplicand to the accumulator or just shift without adding
  A --> Accumulator
    Holds intermiediate results of the multiplication as we add/subtract. 
    Should start at zero and accumulates shiftted multiplicand   
  S --> Multiplicand
    Number we are multiplying by the multiplier. Remains unchanged throughout the process. Shifted left by one
  After we are done multiplying the result should be stored in the Accumulator and Multiplier together. 
  X --> Carry bit
*/

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module controllerFSM (input logic Reset_Load_Clr, run, Clk, M_val,
                      output logic Shift, Add, Sub, Clr, LoadB);

    //declare signals curr_state, next_state of type enum
    enum logic [3:0] {START,LOADB,CXA,AS0,AS1,AS2,AS3,AS4,AS5,AS6,SS,HALT, HALT2} curr_state, next_state;

  logic [7:0] Bval;
  logic [7:0] Aval;
    //assign outputs based on state
    always_comb
    begin 
      unique case(curr_state)
        START: 
            begin
            Shift = 1'b0;
            Add = 1'b0;
            Sub = 1'b0;
            Clr = 1'b0;
            LoadB = 1'b0;  
          end
        LOADB:
          begin
            Shift = 1'b0;
            Add = 1'b0;
            Sub = 1'b0;
            Clr = 1'b0;
            LoadB = 1'b1;
            
          end
        CXA:
          begin
            Shift = 1'b0;
            Add = 1'b0;
            Sub = 1'b0;
            Clr = 1'b1; 
            LoadB = 1'b0; 
    
          end
        AS0:
          begin
            Shift = 1'b1;
             if(M_val == 1)
              Add = 1'b1;
            else
              Add = 1'b0;
              Sub = 1'b0;
              Clr = 1'b0;
              LoadB = 1'b0;  
          end
        AS1:
          begin
            Shift = 1'b1;
             if(M_val == 1)
              Add = 1'b1;
            else
              Add = 1'b0;
              Sub = 1'b0;
              Clr = 1'b0;
              LoadB = 1'b0;
          end
        AS2:
          begin
            Shift = 1'b1;
            if(M_val == 1)
              Add = 1'b1;
            else
              Add = 1'b0;
              Sub = 1'b0;
              Clr = 1'b0;  
              LoadB = 1'b0;
          end
        AS3:
          begin
            Shift = 1'b1;
             if(M_val == 1)
              Add = 1'b1;
            else
              Add = 1'b0;
              Sub = 1'b0;
              Clr = 1'b0;
              LoadB = 1'b0;  
          end
        AS4:
          begin
            Shift = 1'b1;
            if(M_val == 1)
              Add = 1'b1;
            else
              Add = 1'b0;
              Sub = 1'b0;
              Clr = 1'b0; 
              LoadB = 1'b0;
          end
        AS5:
          begin
            Shift = 1'b1; 
            if(M_val == 1)
              Add = 1'b1;
            else
              Add = 1'b0;
              Sub = 1'b0;
              Clr = 1'b0;
              LoadB = 1'b0;   
          end
        AS6:
          begin
            Shift = 1'b1;
             if(M_val == 1)
              Add = 1'b1;
            else
              Add = 1'b0; 
              Sub = 1'b0;
              Clr = 1'b0;
              LoadB = 1'b0; 
          end
        SS:
          begin
            Shift = 1'b1; 
            Add = 1'b0;
            Sub = 1'b1;
            Clr = 1'b0; 
            LoadB = 1'b0;
          end
        HALT:
          begin
            Shift = 1'b0;
            Add = 1'b0; 
            Sub = 1'b0;
            Clr = 1'b0;
            LoadB = 1'b0;
              
          end
          
          HALT2:
          begin
            Shift = 1'b0;
            Add = 1'b0; 
            Sub = 1'b0;
            Clr = 1'b0;
            LoadB = 1'b0;
              
          end
        default:  //default case, can also have default assignments 
          begin 
            Shift = 1'b0;
            Add = 1'b0; 
            Sub = 1'b0;
            Clr = 1'b0;
            LoadB = 1'b0;
          end
          endcase
    end

    ////////////////next state logic/////////////////////////////////////////////////////////////////////////////////
    always_comb
    begin
     next_state = curr_state;
       unique case(curr_state)
          START: 
          begin
            if(Reset_Load_Clr)
                next_state = LOADB;
         else 
           next_state = START;
              end

          LOADB: next_state = CXA;
         
          CXA:  
          begin
            if(run)
              next_state = AS0;
            else 
              next_state = CXA;
  end 
            AS0: next_state = AS1;  
            AS1: next_state = AS2;
            AS2: next_state = AS3;
            AS3: next_state = AS4;     
            AS4: next_state = AS5;          
            AS5: next_state = AS6;                 
            AS6: next_state = SS;           
            SS: next_state = HALT;

          HALT: 
          begin
           if (run==0) 
            next_state = HALT2;
         else 
           next_state = HALT;
           end
HALT2:
begin
if (run == 1)
    next_state = CXA;
else
    next_state = HALT2;
              end

          default: next_state = START;

        endcase
    end

    //update flip-flops
    always_ff @ (posedge Clk)
    begin
      if (Reset_Load_Clr)       //Asychronous Reset
        curr_state <= LOADB;       //A is the reset/start state
      else
        curr_state <= next_state;
    end
      
endmodule

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
