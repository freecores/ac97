/////////////////////////////////////////////////////////////////////
////                                                             ////
////  WISHBONE AC 97 Controller Definitions                      ////
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
//  $Id: ac97_defines.v,v 1.1 2001-08-03 06:54:49 rudi Exp $
//
//  $Date: 2001-08-03 06:54:49 $
//  $Revision: 1.1 $
//  $Author: rudi $
//  $Locker:  $
//  $State: Exp $
//
// Change History:
//               $Log: not supported by cvs2svn $
//               Revision 1.1.1.1  2001/05/19 02:29:14  rudi
//               Initial Checkin
//
//
//
//

`timescale 1ns / 10ps

/////////////////////////////////////////////////////////////////////
// This AC97 Controller supports up to 6 Output and 3 Input Channels.
// Comment out the define statement for which channels you do not wish
// to support in your implementation. The main Left and Right channels
// are always supported. 

// Surround Left + Right
`define SURROUND	1

// Center Channel
`define CENTER		1

// LFE Channel
`define LFE		1

// Stereo Input
`define SIN		1

// Mono Microphone Input
`define MICIN		1

/////////////////////////////////////////////////////////////////////
//
// This define selects how the WISHBONE interface determines if
// the internal register file is selected.
// This should be a simple address decoder. "wb_addr_i" is the
// WISHBONE address bus (32 bits wide).
`define	REG_SEL		(wb_addr_i[31:29] == 3'h0)

/////////////////////////////////////////////////////////////////////
//
// This is a prescaler that generates a pulse every 250 nS.
// The value here should one less than the actually calculated
// value.
// For a 200 MHz wishbone clock, this value is 49 (50-1).
`define	AC97_250_PS	6'd49

/////////////////////////////////////////////////////////////////////
//
// AC97 Cold reset Must be asserted for at least 1uS. The AC97
// controller will stretch the reset pulse to at least 1uS.
// The reset timer is driven by the AC97_250_PS prescaler.
// This value should probably be never changed. Adjust the
// AC97_250_PS instead.
`define	AC97_RST_DEL	3'd4

/////////////////////////////////////////////////////////////////////
//
// This value indicates for how long the resume signaling (asserting sync)
// should be done. This counter is driven by the AC97_250_PS prescaler.
// This value times 250nS is the duration of the resume signaling.
// The actual value must be incremented by one, as we do not know
// the current state of the prescaler, and must somehow insure we
// meet the minimum 1uS length. This value should probably be never
// changed. Modify the AC97_250_PS instead.
`define AC97_RES_SIG	3'd5

/////////////////////////////////////////////////////////////////////
//
// If the bit clock is absent for at least two "predicted" bit
// clock periods (163 nS) we should signal "suspended".
// This value defines how many WISHBONE cycles must pass without
// any change on the bit clock input before we signal "suspended".
// For a 200 MHz WISHBONE clock this would be about (163/5) 33 cycles.
`define AC97_SUSP_DET	6'd33
