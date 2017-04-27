//////////////////////////////////////////////////////////////////////
// Defines related to bus functional models
//////////////////////////////////////////////////////////////////////

`define FF_LOOP_DELAY           100
`define FF_MICROSECOND          1_000
`define FF_MILLISECOND          1_000_000
`define FF_SECOND               1_000_000_000

//////////////////////////////////////////////////////////////////////
// Paths to module with functions/tasks
//
`define FF_LOG                  testbench.ff_log
`define FF_UTILITIES            testbench.ff_utilities

//////////////////////////////////////////////////////////////////////
//
//`define FF_RESET_DUT          testbench.reset_dut

//////////////////////////////////////////////////////////////////////
// ARM HPS Accesses
//
`define FF_APB_READ             testbench.ff_apb_master_bfm.apb_read
`define FF_APB_WRITE            testbench.ff_apb_master_bfm.apb_write

//////////////////////////////////////////////////////////////////////
// LOGGING
//
`define FF_LOG_MSG              [256*8:1]

`define FF_SET_MAX_ERRORS       `FF_LOG.ff_set_max_errors
`define FF_SET_EXP_WARNING_CNT  `FF_LOG.ff_set_exp_warning_cnt
`define FF_SET_EXP_ERROR_CNT    `FF_LOG.ff_set_exp_error_cnt
`define FF_NOTE                 `FF_LOG.ff_note
`define FF_WARNING              `FF_LOG.ff_warning
`define FF_ERROR                `FF_LOG.ff_error
`define FF_TERMINATE            `FF_LOG.ff_terminate
`define FF_FATAL                `FF_LOG.ff_fatal
`define FF_FATAL_FUNC           `FF_LOG.ff_fatal_func

//////////////////////////////////////////////////////////////////////
// DPI Functions
//

//////////////////////////////////////////////////////////////////////
// Hardware defines
//
