
module l1_param_cache #(
  parameter Ways = 8, // power of 2
  parameter Sets = 8, // power of 2
  parameter Lru = ($clog2(Ways) - 1),
  parameter Set_index = ($clog2(Sets) - 1)
)
(
  input clk,
  input rst,
  /* Physical memory signals */
  input logic pmem_resp,
  input logic [255:0] pmem_rdata,
  output logic [31:0] pmem_address,
  output logic [255:0] pmem_wdata,
  output logic pmem_read,
  output logic pmem_write,

  /* CPU memory signals */
  input logic mem_read,
  input logic mem_write,
  input logic [3:0] mem_byte_enable_cpu,
  input logic [31:0] mem_address,
  input logic [31:0] mem_wdata_cpu,
  output logic mem_resp,
  output logic [31:0] mem_rdata_cpu
);

logic tag_load;
logic valid_load;
// logic valid_in[Ways];
logic valid_out[Ways];
logic dirty_load;
logic dirty_in;
logic dirty_out;

logic hit;
logic [1:0] writing;

logic [255:0] mem_wdata;
logic [255:0] mem_rdata;
logic [31:0] mem_byte_enable;

/* param lru */
logic lru_load[Ways];
logic [Lru : 0] lru_in[Ways];
logic [Lru : 0] lru_out[Ways];
logic [Lru : 0] lru_idx;
param_cache_control #(Ways, Lru) control (.*);
param_cache_datapath #(Ways, Lru, Sets, Set_index) datapath (.*);

line_adapter bus (
    .mem_wdata_line(mem_wdata),
    .mem_rdata_line(mem_rdata),
    .mem_wdata(mem_wdata_cpu),
    .mem_rdata(mem_rdata_cpu),
    .mem_byte_enable(mem_byte_enable_cpu),
    .mem_byte_enable_line(mem_byte_enable),
    .address(mem_address)
);

endmodule : l1_param_cache