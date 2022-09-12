#include <unistd.h>
#include <string.h>
#include <stdio.h>
#include <fcntl.h> 
#include <stdlib.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>

typedef uint8_t  u8;
typedef uint16_t u16;
typedef uint32_t u32;

typedef int8_t   s8;
typedef int16_t  s16;
typedef int32_t  s32;
typedef int64_t  s64;

#define MAX_INPUT_VAR 20

#include <stdio.h>
#include <stdlib.h>
 
u8* substr(u8 *src, int m, int n) {

    int len = n - m;
    
    // allocate (len + 1) chars for destination (+1 for extra null character)
    u8 *dest = (char*)malloc(sizeof(u8) * (len + 1));
 
    // extracts characters between m'th and n'th index from source string
    // and copy them into the destination string
    for (int i = m; i < n && (*(src + i) != '\0'); i++)
    {
        *dest = *(src + i);
        dest++;
    }
 
    // null-terminate the destination string
    *dest = '\0';
 
    // return the destination string
    return dest - len;
}

/*void eval_func(FILE* h1) {
    if (h1) {
        fprintf(h1, " \n\tclk = !clk; \n\ttop->%s = clk; \n\ttop->eval();\n" , clk_var);
        fprintf(h1, " \n\tclk = !clk; \n\ttop->%s = clk; \n\ttop->eval();\n" , clk_var);
    }
}*/

int main(int argc, char* argv[]) {
    s32 opt;
    u8 *input_var, *stat_var = NULL;
    u8 NUMSTEPS = 0;
    u8 *in_var[MAX_INPUT_VAR] = {NULL}, *state_var, *top_module=NULL, *clk_var, *rst_var;
    u8 in_var_wid[MAX_INPUT_VAR], state_var_wid, rst_var_bool;
    static s8 InputPassed = 0;
    static u8 input_var_index = 0;

    //parse command line arg, -t topModuleName -c clkName -r rstName_0/1(0-neg rst, 1-pos rst) -i inputVarName_width -s stateVarName_width -N NumstepsValue
    while ((opt = getopt(argc, argv, "+i:s:N:t:c:r:")) > 0)
    
        switch (opt) {
        
            case 'c': /* clock name */
                if(clk_var) {
                    perror("Multiple -c options not supported\n");
                    break;
                }
                
                //printf("optarg= %s\n", optarg);
                clk_var = optarg;
                printf("clk_var= %s \n", clk_var);              
                break;
                
            case 'r': /* reset variable name + boolean type (represent pos reset(1) or neg reset(0) ) */
                if(rst_var) {
                    perror("Multiple -r options not supported\n"); 
                    break;  
                }
                
                rst_var = optarg;
                //input_var = reinterpret_cast<u8 *>(optarg);
                u8* trimr = strrchr(rst_var, '_'); //trim state_8 to "state" (state_var_name) and "8" (in_var_width)
                //printf("trims= %s\n", trims);
                              
                 if (trimr) {
                    rst_var = substr(rst_var, 0, (trimr-rst_var));
                    printf("rst_var= %s \n", rst_var);
                    
                    rst_var_bool = atoi(trimr + 1); //handle state variable width
                    printf("rst_var_bool= %d \n", rst_var_bool);                   
                }
                
                break;
                        
            case 'i': /* input variable name + width */
                input_var = optarg;
                //input_var = reinterpret_cast<u8 *>(optarg);
                u8* trimi = strrchr(input_var, '_'); //trimi in1_8 to "in1" (in_var_name) and "8" (in_var_width)
                //printf("trimi= %s\n", trimi);
                
                if(!trimi) perror("Unsupported -i command, -i inputVarName_width\n");
                else {
                    u8* s1 = substr(input_var, 0, (trimi-input_var));
                    //printf("s1= %s\n", s1);
                    in_var[InputPassed] = s1;
                    printf("invar[%d]= %s \n", InputPassed, in_var[InputPassed]);
                    
                    in_var_wid[InputPassed] = atoi(trimi + 1); //handle input width
                    printf("in_var_wid[%d]= %d \n", InputPassed, in_var_wid[InputPassed]);
                    
                    InputPassed++;
                }
                
                
                break;
                
            case 's': /* state variable name + width */
                if(stat_var) {
                    perror("Multiple -s options not supported\n"); 
                    break;  
                }
                
                stat_var = optarg;
                //input_var = reinterpret_cast<u8 *>(optarg);
                u8* trims = strrchr(stat_var, '_'); //trim state_8 to "state" (state_var_name) and "8" (in_var_width)
                //printf("trims= %s\n", trims);
                              
                 if (trims) {
                    u8* s2 = substr(stat_var, 0, (trims-stat_var));
                    //printf("s2= %s\n", s2);
                    state_var = s2;
                    printf("state_var= %s \n", state_var);
                    
                    state_var_wid = atoi(trims + 1); //handle state variable width
                    printf("state_var_wid= %d \n", state_var_wid);                   
                }
                
                break;
                
            case 'N': /* Numsteps Value */
                if(NUMSTEPS) {
                    perror("Multiple -N options not supported\n");
                    break;
                }
                
                //printf("optarg= %s\n", optarg);
                NUMSTEPS = atoi(optarg);
                printf("NUMSTEPS= %d \n", NUMSTEPS);              
                break;
                
            case 't': /* top mudle name */
                if(top_module) {
                    perror("Multiple -t options not supported\n");
                    break;
                }
                
                //printf("optarg= %s\n", optarg);
                top_module = optarg;
                printf("top_module= %s \n", top_module);              
                break;
                
            default:

                printf("Usage: %s -t topModuleName -c clkName -r rstName_0/1(0-neg rst, 1-pos rst) -i inputVarName_width -s stateVarName_width -N NumstepsValue\n", argv[0]);
        }
        
        FILE* fp = fopen("tb.cpp", "w");
        fprintf(fp, "%s", "\n");
        fclose(fp);
        
        FILE* h = fopen("tb.cpp", "a");
        
        /* add all library header*/
        u8* head = "#include <verilated.h> \n#include <verilated_vcd_c.h> \n#include <iostream> \n#include <fstream> \n#include <assert.h> \n#include <klee/klee.h> \n#include <set>";
        if (fwrite(head, 1, strlen(head), h) != strlen(head)) {
		        perror("Could not append head to file");
		        exit(1);
	      }
        
        /* add all verilator header*/
        fprintf(h, " \n\n#include \"V%s.h\n#include \"V%s__Syms.h\n\nusing namespace std;" , top_module, top_module);
        
        /* add #define macro and create Vtop*/ 
        fprintf(h, " \n\n#define NUMSTEPS %d \n#define MAX_CDATA 100 \n#define MAX_WDATA 50 \nV%s *top;\n\n", NUMSTEPS, top_module);
        
        
        
        /* Main function entry point*/
        fprintf(h, "%s", "\nint main(int argc, char **argv) {\n");
        fprintf(h, "%s", "\n\tstd::set<int> S; \n\tCData c[MAX_CDATA]; \n\tWData w[MAX_WDATA];\n");
        fprintf(h, " \n\ttop = new V%s; \n\tint clk = 1;\n" , top_module);
        
        fprintf(h, " \n\ttop->%s = %d;\n" , rst_var, rst_var_bool); //reset active
        fprintf(h, " \n\tclk = !clk; \n\ttop->%s = clk; \n\ttop->eval();\n \n\tclk = !clk; \n\ttop->%s = clk; \n\ttop->eval();\n" , clk_var, clk_var); //eval()
        fprintf(h, " \n\ttop->%s = %d;\n" , rst_var, !rst_var_bool); //reset de-active
        
        
        /*for loop, forward symbolic execution*/
        fprintf(h, "\n\tfor(int i=0; i<NUMSTEPS; i++) {\n"); 
        
        while (in_var[input_var_index]!=NULL) {
            fprintf(h, "\n\t\tklee_make_symbolic(&c[%d], sizeof(c[%d]), \"%sFirst)\";", input_var_index, input_var_index, in_var[input_var_index]);
            fprintf(h, " \n\t\tklee_assume(c[%d] >= 0 && c[%d] < %d);" , input_var_index, input_var_index, (u8)(pow(2, in_var_wid[input_var_index])));
            fprintf(h, "\n\t\ttop->%s = c[%d]; \n", in_var[input_var_index], input_var_index);
            input_var_index++;
        }
        fprintf(h, " \n\t\tclk = !clk; \n\t\ttop->%s = clk; \n\t\ttop->eval();\n \n\t\tclk = !clk; \n\t\ttop->%s = clk; \n\t\ttop->eval();\n" , clk_var, clk_var); //top->eval()
        fprintf(h, " \n\t\tklee_assume(top->%s->%s >= 0 && top->%s->%s < %d);\n" , top_module, state_var, top_module, state_var, (u8)(pow(2, state_var_wid)));     
        fprintf(h, "\t\tklee_add_metadata_globally(&S, top->%s->%s, c[0];\n" , top_module, state_var);
        fprintf(h, "\t}\n\n");
        u8 temp_var_index = input_var_index;
        
        /*abstract symbolic execution*/
        fprintf(h, "\n\tklee_make_symbolic(&st0, sizeof(st0), \"%s)\";", state_var);
        fprintf(h, " \n\tklee_assume(st0 >= 0 && st0 < %d);\n" ,(u8)(pow(2, state_var_wid)));
        fprintf(h, " \ttop->%s->%s = st0;\n" , top_module, state_var);
        
        fprintf(h, "\n\tklee_make_symbolic(&dest, sizeof(dest), \"dest)\";");
        fprintf(h, " \n\tklee_assume(dest >= 0 && dest < %d);\n\n" ,(u8)(pow(2, state_var_wid)));
        
        input_var_index = 0;
        while (in_var[input_var_index]!=NULL) {
            fprintf(h, "\n\tklee_make_symbolic(&c[%d], sizeof(c[%d]), \"%sSec)\";", input_var_index+temp_var_index, input_var_index+temp_var_index, in_var[input_var_index]);
            fprintf(h, " \n\tklee_assume(c[%d] >= 0 && c[%d] < %d);" , input_var_index+temp_var_index, input_var_index+temp_var_index, (u8)(pow(2, in_var_wid[input_var_index])));
            fprintf(h, "\n\ttop->%s = c[%d]; \n", in_var[input_var_index], input_var_index+temp_var_index);
            input_var_index++;
        }
        
        fprintf(h, " \n\tclk = !clk; \n\ttop->%s = clk; \n\ttop->eval();\n \n\tclk = !clk; \n\ttop->%s = clk; \n\ttop->eval();\n" , clk_var, clk_var); 
        
        fprintf(h, " \n\tklee_assume(top->%s->%s >= 0 && top->%s->%s < %d);\n" , top_module, state_var, top_module, state_var, (u8)(pow(2, state_var_wid)));
        
        fprintf(h, "\tklee_check_dontcare_transition_globally(&S, top->%s->%s, st0, dest, c[%d]);\n" , top_module, state_var, temp_var_index);
        
        fprintf(h, "}\n");
        fclose(h);
        
}