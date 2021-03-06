`timescale 1ns / 1ps

module inst_cache(
    input         clk,
    input         rst,
    
    // axi
    // ar
    output [3 :0] arid   ,
    output [31:0] araddr ,
    output [7 :0] arlen  ,
    output [2 :0] arsize ,
    output [1 :0] arburst,
    output [1 :0] arlock ,
    output [3 :0] arcache,
    output [2 :0] arprot ,
    output        arvalid,
    input         arready,
    //r
    input  [3 :0] rid    ,
    input  [31:0] rdata  ,
    input  [1 :0] rresp ,
    input         rlast ,
    input         rvalid ,
    output        rready ,
    //aw
    output [3 :0] awid   ,
    output [31:0] awaddr ,
    output [7 :0] awlen  ,
    output [2 :0] awsize ,
    output [1 :0] awburst,
    output [1 :0] awlock ,
    output [3 :0] awcache,
    output [2 :0] awprot ,
    output        awvalid,
    input         awready,
    //w
    output [3 :0] wid    ,
    output [31:0] wdata  ,
    output [3 :0] wstrb  ,
    output        wlast  ,
    output        wvalid ,
    input         wready ,
    //b
    input  [3 :0] bid    ,
    input  [1 :0] bresp  ,
    input         bvalid ,
    output        bready ,
    
    // from cpu, sram like
    input         sram_req,
    input         sram_wr,
    input  [1:0]  sram_size,
    input  [31:0] sram_addr,
    input  [31:0] sram_wdata,
    output        sram_addr_ok,
    output        sram_data_ok,
    output [31:0] sram_rdata,
    
    input         sram_cache
    );
    
    reg[127:0] lru;
    
    wire work0, work1;
    wire hit0, hit1, hit;
    wire valid0, valid1, valid;
    wire[31:0] access_cache_addr;
    wire tag0_wen, tag1_wen;
    wire[20:0] tag_wdata;
    wire op0, op1;
    
    reg[31:0] sram_addr_r;
    always @ (posedge clk) begin
        if (sram_req == 1'b1) begin
            sram_addr_r <= sram_addr;
        end
    end
    reg sram_cache_r;
    always @ (posedge clk) begin
        if (sram_req == 1'b1) begin
            sram_cache_r <= sram_cache;
        end
    end
    
    icache_tag icache_tag_0(rst, clk, tag0_wen, tag_wdata, access_cache_addr, hit0, valid0, work0, op0);
    icache_tag icache_tag_1(rst, clk, tag1_wen, tag_wdata, access_cache_addr, hit1, valid1, work1, op1);
    
    wire[31:0] way0_0_rdata;
    wire[31:0] way0_1_rdata;
    wire[31:0] way0_2_rdata;
    wire[31:0] way0_3_rdata;
    wire[31:0] way0_4_rdata;
    wire[31:0] way0_5_rdata;
    wire[31:0] way0_6_rdata;
    wire[31:0] way0_7_rdata;
    wire[31:0] way1_0_rdata;
    wire[31:0] way1_1_rdata;
    wire[31:0] way1_2_rdata;
    wire[31:0] way1_3_rdata;
    wire[31:0] way1_4_rdata;
    wire[31:0] way1_5_rdata;
    wire[31:0] way1_6_rdata;
    wire[31:0] way1_7_rdata;
    
    wire[7:0] way0_wen;
    wire[7:0] way1_wen;
    wire[31:0] way_wdata;
    
    icache_data way0_0(clk, rst, 1'b1, {4{way0_wen[0]}}, way_wdata, access_cache_addr, way0_0_rdata);
    icache_data way0_1(clk, rst, 1'b1, {4{way0_wen[1]}}, way_wdata, access_cache_addr, way0_1_rdata);
    icache_data way0_2(clk, rst, 1'b1, {4{way0_wen[2]}}, way_wdata, access_cache_addr, way0_2_rdata);
    icache_data way0_3(clk, rst, 1'b1, {4{way0_wen[3]}}, way_wdata, access_cache_addr, way0_3_rdata);
    icache_data way0_4(clk, rst, 1'b1, {4{way0_wen[4]}}, way_wdata, access_cache_addr, way0_4_rdata);
    icache_data way0_5(clk, rst, 1'b1, {4{way0_wen[5]}}, way_wdata, access_cache_addr, way0_5_rdata);
    icache_data way0_6(clk, rst, 1'b1, {4{way0_wen[6]}}, way_wdata, access_cache_addr, way0_6_rdata);
    icache_data way0_7(clk, rst, 1'b1, {4{way0_wen[7]}}, way_wdata, access_cache_addr, way0_7_rdata);
    icache_data way1_0(clk, rst, 1'b1, {4{way1_wen[0]}}, way_wdata, access_cache_addr, way1_0_rdata);
    icache_data way1_1(clk, rst, 1'b1, {4{way1_wen[1]}}, way_wdata, access_cache_addr, way1_1_rdata);
    icache_data way1_2(clk, rst, 1'b1, {4{way1_wen[2]}}, way_wdata, access_cache_addr, way1_2_rdata);
    icache_data way1_3(clk, rst, 1'b1, {4{way1_wen[3]}}, way_wdata, access_cache_addr, way1_3_rdata);
    icache_data way1_4(clk, rst, 1'b1, {4{way1_wen[4]}}, way_wdata, access_cache_addr, way1_4_rdata);
    icache_data way1_5(clk, rst, 1'b1, {4{way1_wen[5]}}, way_wdata, access_cache_addr, way1_5_rdata);
    icache_data way1_6(clk, rst, 1'b1, {4{way1_wen[6]}}, way_wdata, access_cache_addr, way1_6_rdata);
    icache_data way1_7(clk, rst, 1'b1, {4{way1_wen[7]}}, way_wdata, access_cache_addr, way1_7_rdata);
    
    reg[31:0] wait_data;
    reg[2:0] write_counter;
    reg[3:0] work_state;
    parameter[3:0] state_reset = 4'b0000;
    parameter[3:0] state_lookup = 4'b0001;
    parameter[3:0] state_access_ram_0 = 4'b0010;
    parameter[3:0] state_access_ram_1 = 4'b0011;
    parameter[3:0] state_data_ready = 4'b0100;
    parameter[3:0] state_miss_access_ram_0 = 4'b0101;
    parameter[3:0] state_miss_access_ram_1 = 4'b0110;
    parameter[3:0] state_miss_update = 4'b0111;
    
    
    always @ (posedge clk) begin
        if (!rst) begin
            work_state <= state_reset;
            wait_data <= 32'b0;
            write_counter <= 3'b000;
        end else if (work_state == state_reset && sram_req == 1'b1) begin
            if ((work0 & work1) == 1'b1 && sram_cache == 1'b1) begin
                work_state <= state_lookup;
            end else begin
                work_state <= state_access_ram_0;
            end
        end else if (work_state == state_access_ram_0 && arready == 1'b1) begin
            work_state <= state_access_ram_1;
        end else if (work_state == state_access_ram_1 && rvalid) begin
            work_state <= state_data_ready;
            wait_data <= rdata;
        end else if (work_state == state_data_ready) begin // 
//            work_state <= state_reset;
            if (sram_req) begin
                if ((work0 & work1) == 1'b1 && sram_cache == 1'b1) begin
                    work_state <= state_lookup;
                end else begin
                    work_state <= state_access_ram_0;
                end
            end else work_state <= state_reset;
        end else if (work_state == state_lookup) begin // 
//            if (hit) work_state <= state_reset;
            if (hit) begin
                if (sram_req) begin
                    if ((work0 & work1) == 1'b1 && sram_cache == 1'b1) begin
                        work_state <= state_lookup;
                    end else begin
                        work_state <= state_access_ram_0;
                    end
                end else work_state <= state_reset;
            end
            else work_state <= state_miss_access_ram_0;
        end else if (work_state == state_miss_access_ram_0 && arready == 1'b1) begin
            work_state <= state_miss_access_ram_1;
        end else if (work_state == state_miss_access_ram_1) begin
            if (rvalid) begin
                write_counter <= write_counter + 1'b1;
                if (write_counter == sram_addr_r[4:2]) wait_data = rdata;
            end
            if (rlast && rvalid) begin
                write_counter <= 3'b000;
                work_state <= state_miss_update;
            end
        end else if (work_state == state_miss_update) begin
            work_state <= state_data_ready;
        end
    end
    
    always @ (posedge clk) begin
        if (!rst) begin
            lru = 128'b0;
        end else begin
            if (work_state == state_lookup) begin
                if (hit0 && valid0) lru[sram_addr_r[11:5]] <= 1'b1;
                else if (hit1 && valid1) lru[sram_addr_r[11:5]] <= 1'b0;
            end else if (work_state == state_miss_update) begin
                lru[sram_addr_r[11:5]] = ~lru[sram_addr_r[11:5]];
            end
        end
    end
    
    
    
    assign hit = (hit0 && valid0) || (hit1 && valid1);
    assign access_cache_addr = sram_req == 1'b1 ? sram_addr : sram_addr_r;
    wire[31:0] word_selection0, word_selection1;
    assign word_selection0 = (sram_addr_r[4:2] == 3'b000) ? way0_0_rdata :
                             (sram_addr_r[4:2] == 3'b001) ? way0_1_rdata :
                             (sram_addr_r[4:2] == 3'b010) ? way0_2_rdata :
                             (sram_addr_r[4:2] == 3'b011) ? way0_3_rdata :
                             (sram_addr_r[4:2] == 3'b100) ? way0_4_rdata :
                             (sram_addr_r[4:2] == 3'b101) ? way0_5_rdata :
                             (sram_addr_r[4:2] == 3'b110) ? way0_6_rdata :
                             (sram_addr_r[4:2] == 3'b111) ? way0_7_rdata : 32'b0;
    assign word_selection1 = (sram_addr_r[4:2] == 3'b000) ? way1_0_rdata :
                             (sram_addr_r[4:2] == 3'b001) ? way1_1_rdata :
                             (sram_addr_r[4:2] == 3'b010) ? way1_2_rdata :
                             (sram_addr_r[4:2] == 3'b011) ? way1_3_rdata :
                             (sram_addr_r[4:2] == 3'b100) ? way1_4_rdata :
                             (sram_addr_r[4:2] == 3'b101) ? way1_5_rdata :
                             (sram_addr_r[4:2] == 3'b110) ? way1_6_rdata :
                             (sram_addr_r[4:2] == 3'b111) ? way1_7_rdata : 32'b0;
    wire[31:0] hit_word;
    assign hit_word = (hit0 && valid0) ? word_selection0 :
                      (hit1 && valid1) ? word_selection1 : 32'b0;
                      
    assign way_wdata = rdata;
    assign way0_wen[0] = (work_state == state_miss_access_ram_1 && rvalid && lru[sram_addr_r[11:5]] == 1'b0 && write_counter == 3'b000) ? 1'b1 : 1'b0;
    assign way0_wen[1] = (work_state == state_miss_access_ram_1 && rvalid && lru[sram_addr_r[11:5]] == 1'b0 && write_counter == 3'b001) ? 1'b1 : 1'b0;
    assign way0_wen[2] = (work_state == state_miss_access_ram_1 && rvalid && lru[sram_addr_r[11:5]] == 1'b0 && write_counter == 3'b010) ? 1'b1 : 1'b0;
    assign way0_wen[3] = (work_state == state_miss_access_ram_1 && rvalid && lru[sram_addr_r[11:5]] == 1'b0 && write_counter == 3'b011) ? 1'b1 : 1'b0;
    assign way0_wen[4] = (work_state == state_miss_access_ram_1 && rvalid && lru[sram_addr_r[11:5]] == 1'b0 && write_counter == 3'b100) ? 1'b1 : 1'b0;
    assign way0_wen[5] = (work_state == state_miss_access_ram_1 && rvalid && lru[sram_addr_r[11:5]] == 1'b0 && write_counter == 3'b101) ? 1'b1 : 1'b0;
    assign way0_wen[6] = (work_state == state_miss_access_ram_1 && rvalid && lru[sram_addr_r[11:5]] == 1'b0 && write_counter == 3'b110) ? 1'b1 : 1'b0;
    assign way0_wen[7] = (work_state == state_miss_access_ram_1 && rvalid && lru[sram_addr_r[11:5]] == 1'b0 && write_counter == 3'b111) ? 1'b1 : 1'b0;
    assign way1_wen[0] = (work_state == state_miss_access_ram_1 && rvalid && lru[sram_addr_r[11:5]] == 1'b1 && write_counter == 3'b000) ? 1'b1 : 1'b0;
    assign way1_wen[1] = (work_state == state_miss_access_ram_1 && rvalid && lru[sram_addr_r[11:5]] == 1'b1 && write_counter == 3'b001) ? 1'b1 : 1'b0;
    assign way1_wen[2] = (work_state == state_miss_access_ram_1 && rvalid && lru[sram_addr_r[11:5]] == 1'b1 && write_counter == 3'b010) ? 1'b1 : 1'b0;
    assign way1_wen[3] = (work_state == state_miss_access_ram_1 && rvalid && lru[sram_addr_r[11:5]] == 1'b1 && write_counter == 3'b011) ? 1'b1 : 1'b0;
    assign way1_wen[4] = (work_state == state_miss_access_ram_1 && rvalid && lru[sram_addr_r[11:5]] == 1'b1 && write_counter == 3'b100) ? 1'b1 : 1'b0;
    assign way1_wen[5] = (work_state == state_miss_access_ram_1 && rvalid && lru[sram_addr_r[11:5]] == 1'b1 && write_counter == 3'b101) ? 1'b1 : 1'b0;
    assign way1_wen[6] = (work_state == state_miss_access_ram_1 && rvalid && lru[sram_addr_r[11:5]] == 1'b1 && write_counter == 3'b110) ? 1'b1 : 1'b0;
    assign way1_wen[7] = (work_state == state_miss_access_ram_1 && rvalid && lru[sram_addr_r[11:5]] == 1'b1 && write_counter == 3'b111) ? 1'b1 : 1'b0;
    
    assign tag0_wen = (work_state == state_miss_update && lru[sram_addr_r[11:5]] == 1'b0) ? 1'b1 : 1'b0;
    assign tag1_wen = (work_state == state_miss_update && lru[sram_addr_r[11:5]] == 1'b1) ? 1'b1 : 1'b0;
    assign tag_wdata = (work_state == state_miss_update) ? {1'b1, sram_addr_r[31:12]} : 21'b0;
    
    
    
    // axi singal
    assign arid    = 4'b0000;
    assign araddr  = (work_state == state_access_ram_0) ? sram_addr_r : 
                     (work_state == state_miss_access_ram_0) ? {sram_addr_r[31:5], 5'b00000} : 32'b0;
    assign arlen   = (sram_cache_r == 1'b1) ? 8'b0000_0111 : 8'b0000_0000;
    assign arsize  = 3'b010;
    assign arburst = (sram_cache_r == 1'b1) ? 2'b01 : 2'b00;
    assign arlock  = 2'b00;
    assign arcache = 4'b0000;
    assign arprot  = 3'b000;
    assign arvalid = (work_state == state_access_ram_0 || work_state == state_miss_access_ram_0) ? 1'b1 : 1'b0;

    assign rready  = 1'b1;
    
    assign sram_addr_ok = 1'b1;
    assign sram_data_ok = (work_state == state_data_ready) ? 1'b1 : 
                          (work_state == state_lookup) ? hit :1'b0;
    assign sram_rdata = (work_state == state_data_ready) ? wait_data :
                        (work_state == state_lookup) ? hit_word : 32'b0;
    
    // don't care
    assign awid    = 4'b0000;
    assign awaddr  = 32'b0;
    assign awlen   = 8'b0;
    assign awsize  = 3'b010;
    assign awburst = 2'b00;
    assign awlock  = 2'b00;
    assign awcache = 4'b0000;
    assign awprot  = 3'b000;
    assign awvalid = 1'b0;

    assign wid    = 4'b0000;
    assign wdata  = 32'b0;
    assign wstrb  = 4'b0000;
    assign wlast  = 1'b0;
    assign wvalid = 1'b0;
    
    assign bready = 1'b0;
    
endmodule
