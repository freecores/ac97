/////////////////////////////////////////////////////////////////////
////                                                             ////
////  WISHBONE AC 97 Controller                                  ////
////  Interrupt Logic                                            ////
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
//  $Id: ac97_int.v,v 1.1 2001-08-03 06:54:50 rudi Exp $
//
//  $Date: 2001-08-03 06:54:50 $
//  $Revision: 1.1 $
//  $Author: rudi $
//  $Locker:  $
//  $State: Exp $
//
// Change History:
//               $Log: not supported by cvs2svn $
//               Revision 1.1.1.1  2001/05/19 02:29:18  rudi
//               Initial Checkin
//
//
//
//

`include "ac97_defines.v"

module ac97_int(clk, rst,

		// Register File Interface
		int_set,

		// FIFO Interface
		cfg, status, full_empty, full, empty, re, we
		);

input		clk, rst;
output	[2:0]	int_set;

input	[7:0]	cfg;
input	[1:0]	status;
input		full_empty, full, empty, re, we;

////////////////////////////////////////////////////////////////////
//
// Local Wires
//

reg	[2:0]	int_set;

////////////////////////////////////////////////////////////////////
//
// Interrupt Logic
//

always @(posedge clk or negedge rst)
	if(!rst)	int_set[0] <= #1 0;
	else
	case(cfg[5:4])	// synopsys parallel_case full_case
			// 1/4 full/empty
	   0: int_set[0] <= #1 cfg[0] & (full_empty | (status == 2'd0));
			// 1/2 full/empty
	   1: int_set[0] <= #1 cfg[0] & (full_empty | (status[1] == 1'd0));
			// 3/4 full/empty
	   2: int_set[0] <= #1 cfg[0] & (full_empty | (status < 2'd3));	
	   3: int_set[0] <= #1 cfg[0] & full_empty;
	endcase

always @(posedge clk or negedge rst)
	if(!rst)	int_set[1] <= #1 0;
	else
	if(empty & re)	int_set[1] <= #1 1;

always @(posedge clk or negedge rst)
	if(!rst)	int_set[2] <= #1 0;
	else
	if(full & we)	int_set[2] <= #1 1;

endmodule