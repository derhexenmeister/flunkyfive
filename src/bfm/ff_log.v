//////////////////////////////////////////////////////////////////////
// Test logging facility
//////////////////////////////////////////////////////////////////////
`include "timescale.vh"
`include "ff_bfm_defines.vh"

module ff_log();

integer warning_cnt;
integer error_cnt;
integer max_error_cnt;

integer exp_warning_cnt;
integer exp_error_cnt;

initial begin
    warning_cnt             = 0;
    error_cnt               = 0;
    max_error_cnt           = 1000;

    exp_warning_cnt         = 0;
    exp_error_cnt           = 0;
end

//////////
// Set the maximum number of errors allowed before the simulation is
// terminated
//
task ff_set_max_errors;
    input [31:0]    max_errors;

    /////

    reg             in_use;
begin
    if (in_use === 1'b1) `FF_FATAL("ff_set_max_errors: in_use = 1");
    in_use = 1'b1;

    $display("ff_set_max_errors: max_errors = %0d", max_errors);
    max_error_cnt = max_errors;

    in_use = 1'b0;
end
endtask

//////////
// Set the expected number of warnings
//
task ff_set_exp_warning_cnt;
    input [31:0]    warning_cnt;

    /////

    reg             in_use;
begin
    if (in_use === 1'b1) `FF_FATAL("ff_set_exp_warning_cnt: in_use = 1");
    in_use = 1'b1;

    $display("ff_set_exp_warning_cnt: warning_cnt = %0d", warning_cnt);
    exp_warning_cnt = warning_cnt;

    in_use = 1'b0;
end
endtask

//////////
// Set the expected number of errors (for specialized testing)
//
task ff_set_exp_error_cnt;
    input [31:0]    error_cnt;

    /////

    reg             in_use;
begin
    if (in_use === 1'b1) `FF_FATAL("ff_set_exp_error_cnt: in_use = 1");
    in_use = 1'b1;

    $display("ff_set_exp_error_cnt: error_cnt = %0d", error_cnt);
    exp_error_cnt = error_cnt;

    in_use = 1'b0;
end
endtask

//////////
// A warning occured
//
task ff_warning;
    input `FF_LOG_MSG    msg;

    /////

    reg                 in_use;
begin
    if (in_use === 1'b1) `FF_FATAL("ff_warning: in_use = 1");
    in_use = 1'b1;

    warning_cnt = warning_cnt + 1;
    $display(">>>>>>>>>> FF_WARNING: %0s (warning_cnt = %0d) at: %t", msg, warning_cnt, $time);

    in_use = 1'b0;
end
endtask

//////////
// An error occured
//
task ff_error;
    input `FF_LOG_MSG    msg;

    /////

    reg                 in_use;
begin
    if (in_use === 1'b1) `FF_FATAL("ff_error: in_use = 1");
    in_use = 1'b1;

    error_cnt = error_cnt + 1;
    if (error_cnt === max_error_cnt) begin
        $display(">>>>>>>>>> FF_ERROR: maximum error count reached at: %t", $time);
        ff_fatal(msg);
    end
    else begin
        $display(">>>>>>>>>> FF_ERROR: %0s (error_cnt = %0d) at: %t", msg, error_cnt, $time);
    end
    in_use = 1'b0;
end
endtask

//////////
// The testbench is terminating the simulation because the test completed
//
task ff_terminate;
begin
    if ((warning_cnt !== exp_warning_cnt) || (error_cnt !== exp_error_cnt)) begin
        $display(">>>>>>>>>> FF_TERMINATE: simulation failed (warning_cnt = %0d, exp_warning_cnt = %0d, error_cnt = %0d, exp_error_cnt = %0d) at: %t",
                 warning_cnt, exp_warning_cnt, error_cnt, exp_error_cnt, $time);
    end
    else begin
        if ((warning_cnt == 0) && (exp_warning_cnt == 0) && (error_cnt == 0) && (exp_error_cnt == 0)) begin
            $display(">>>>>>>>>> FF_TERMINATE: simulation passed at: %t", $time);
        end
        else begin
            $display(">>>>>>>>>> FF_TERMINATE: simulation passed (warning_cnt = %0d, exp_warning_cnt = %0d, error_cnt = %0d, exp_error_cnt = %0d) at: %t",
                 warning_cnt, exp_warning_cnt, error_cnt, exp_error_cnt, $time);
        end
    end

    $finish;
end
endtask

//////////
// Display a message in a standard greppable format
//
task ff_note;
    input `FF_LOG_MSG    msg;

    /////

    reg                 in_use;
begin
    if (in_use === 1'b1) `FF_FATAL("ff_note: in_use = 1");
    in_use = 1'b1;

    $display(">>>>>>>>>> FF_NOTE: %0s at: %t", msg, $time);

    in_use = 1'b0;
end
endtask

//////////
// The testbench is terminating immediately due to a fatal error
//
task ff_fatal;
    input `FF_LOG_MSG    msg;
begin
    $display(">>>>>>>>>> FF_FATAL: simulation failed (%0s) at: %t", msg, $time);
    $finish;
end
endtask

function ff_fatal_func;
    input `FF_LOG_MSG    msg;
begin
    $display(">>>>>>>>>> FF_FATAL_FUNC: simulation failed (%0s) at: %t", msg, $time);
    $finish;
    ff_fatal_func = 1'b0;
end
endfunction

endmodule
