/////////////////////////////////////////////////////////////////////
////                                                             ////
////  WISHBONE AC 97 Controller                                  ////
////  Output FIFO                                                ////
////                                                             ////
////                                                             ////
////  Author: Rudolf Usselmann                                   ////
////          rudi@asics.ws                                      ////
////                                                             ////
////                                                             ////
////  Downloaded from: http://www.opencores.org/cores/ac97_ctrl/ ////
////                                                             ////
/////////////////////////////////////////////////////////////////////
////                                                             ////
//// Copyright (C) 2001 Rudolf Usselmann                         ////
////                    rudi@asics.ws                            ////
////                                                             ////
//// This source file may be used and distributed without        ////
//// restriction provided that this copyright statement is not   ////
//// removed from the file and that any derivative work contains ////
//// the original copyright notice and the associated disclaimer.////
////                                                             ////
////     THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY     ////
//// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED   ////
//// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS   ////
//// FOR A PARTICULAR PURPOSE. IN NO EVENT SHALL THE AUTHOR      ////
//// OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,         ////
//// INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES    ////
//// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE   ////
//// GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR        ////
//// BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF  ////
//// LIABILITY, WHETHER IN  CONTRACT, STRICT LIABILITY, OR TORT  ////
//// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT  ////
//// OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE         ////
//// POSSIBILITY OF SUCH DAMAGE.                                 ////
////                                                             ////
/////////////////////////////////////////////////////////////////////

//  CVS Log
//
//  $Id: ac97_out_fifo.v,v 1.1 2001-08-03 06:54:50 rudi Exp $
//
//  $Date: 2001-08-03 06:54:50 $
//  $Revision: 1.1 $
//  $Author: rudi $
//  $Locker:  $
//  $State: Exp $
//
// Change History:
//               $Log: not supported by cvs2svn $
//               Revision 1.1.1.1  2001/05/19 02:29:16  rudi
//               Initial Checkin
//
//
//
//

`include "ac97_defines.v"

module ac97_out_fifo(clk, rst, en, mode, din, we, dout, re, status, full, empty);

input		clk, rst;
input		en;
input	[1:0]	mode;
input	[31:0]	din;
input		we;
output	[19:0]	dout;
input		re;
output	[1:0]	status;
output		full;
output		empty;


////////////////////////////////////////////////////////////////////
//
// Local Wires
//

reg	[31:0]	mem[0:3];

reg	[2:0]	wp;
reg	[3:0]	rp;

wire	[2:0]	wp_p1;

reg	[1:0]	status;
reg	[19:0]	dout;
wire	[31:0]	dout_tmp;
wire	[15:0]	dout_tmp1;
wire		m16b;
reg		empty;

////////////////////////////////////////////////////////////////////
//
// Misc Logic
//

assign m16b = (mode == 2'h0);	// 16 Bit Mode

always @(posedge clk)
	if(!en)		wp <= #1 0;
	else
	if(we)		wp <= #1 wp_p1;

assign wp_p1 = wp + 1;

always @(posedge clk)
	if(!en)		rp <= #1 0;
	else
	if(re & m16b)	rp <= #1 rp + 1;
	else
	if(re & !m16b)	rp <= #1 rp + 2;

always @(posedge clk)
	status <= #1 (wp[1:0] - rp[2:1]) - 1;

wire	[3:0]	rp_p1 = rp[3:0] + 1;

always @(posedge clk)
	empty <= #1 (rp_p1[3:1] == wp[2:0]) & (m16b ? rp_p1[0] : 1'b1);

assign full  = (wp[1:0] == rp[2:1]) & (wp[2] != rp[3]);

// Fifo Output
assign dout_tmp = mem[ rp[2:1] ];

// Fifo Output Half Word Select
assign dout_tmp1 = rp[0] ? dout_tmp[31:16] : dout_tmp[15:0];

always @(posedge clk)
	if(!en)		dout <= #1 20'h0;
	else
	if(re)
		case(mode)	// synopsys parallel_case full_case
		   0: dout <= #1 {dout_tmp1, 4'h0};		// 16 Bit Output
		   1: dout <= #1 {dout_tmp[17:0], 2'h0};	// 18 bit Output
		   2: dout <= #1 dout_tmp[19:0];		// 20 Bit Output
		endcase


always @(posedge clk)
	if(we)	mem[wp[1:0]] <= #1 din;

endmodule
