`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.10.2021 13:22:18
// Design Name: 
// Module Name: chenille
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
///////////////////////////////////////////////////////////////////////////
module chenille(
	input clock_in,// 100MHZ
	input stop,// switch pour mettre en pause ou en marche le chenillard
	input reset,// pour reseter
	input load_mem,// pour afficher le contenu de la memoire
	input save,// pour memoriser
	input load_sw,// pour afficher la valeur des switch 
	input [7:0] sw,// swith a afficher apres load_sw
	output reg [7:0] led 
    );
	 
	reg clock_out;// 500ms
	reg [24:0] counter = 28'd0;
	parameter DIVISOR = 25'd50000000; // le diviseur de frequence
	parameter CLIGNOTNBR = 4'd8; // nbr de fois a clignoter apres un reset
	reg [3:0] i = 4'd0; // compte les clignotement apres reset
	reg mem_out; // signal interne ordonant l'affichage de mem
	reg [7:0] sauvegarde; // memoir contenant la valeur sauvegarder
	reg [7:0] state_mem; // etat du chenillard avant de charger memoire
	reg confirmation_mem;// confirme si charger memoir, permet de recharger state_mem
	reg sw_out;// signal interne ordonant l'affichage de sw 
	reg [7:0] state_sw;// etat du chenillard avant de charger switch
	reg confirmation_sw;//confirme si charger sw, permet de recharger state_sw
	
////////////////////////////////////////////////////////////////////////////
	always @(posedge clock_in) begin
		if(stop) clock_out <= 0;
		else begin
			counter <= counter + 25'd1;         								 ////diviseur de frequence
			if(counter>=(DIVISOR-1))
				counter <= 25'd0;
			clock_out <= (counter<DIVISOR/2)?1'b1:1'b0;
		end 
	end 	
////////////////////////////////////////////////////////////////////////
	
		always @(posedge clock_out) begin
		if(reset) begin //  on teste si on apuyer le bouton du reset
			led <= 0; // on remet les led a 0;
			i <= CLIGNOTNBR; // on initialise le nombre de clignotement
		end
		else if(i != 3'd0) begin  // tant que le nombre de clignotement n'est pas epuiser
			led <= {8{~led[0]}}; // on clignote
			i <= i - 4'd1; 
		end
		else if(mem_out == 1) begin // si on appuis sur load_mem
			led <= sauvegarde; // on charge la valeur sauvegarger 
			confirmation_mem <= 1; // on confirme qu'on est passé par le bloc load mem
		end
		else if(sw_out == 1) begin // si on veut afficher sw
			led <= sw;                         									//////// fonctionnement general
			confirmation_sw <= 1;
		end
		else begin
			if(confirmation_mem == 1) begin // si on a afficher mem et on veut reprendre le fonctionemen normel
				led <= state_mem;
				confirmation_mem <= 0;
			end
			else if(confirmation_sw == 1) begin // si on a afficher sw et on veut reprendre le fonctionement normal
				led <= state_sw;
				confirmation_sw <= 0;
			end
			else begin
				if(led == 0) led <= 8'b10000000; // basic chenille par decalage de led
				else led <= led >> 1;
			end
		end
	end
////////////////////////////////////////////////////////////////////////////
	
		always @(posedge clock_in) begin
		case({load_mem, stop}) 
		2'b10 : mem_out <= 1; 
		2'b01 : mem_out <= 0;       												///gestion de la mise a zero et a 1 du signal de charger mememoir (bascule RS)
		2'b11 : mem_out <= 1;
		2'b00 : mem_out <= mem_out;
		endcase
	end 
//////////////////////////////////////////////////////////////////////////
	
	always @(posedge load_mem) begin
		state_mem <= led; // on sauvegarde l'etat de led avant de charger la memmoire
	end
	
	always @(posedge save) begin
		sauvegarde <= led;// on sauvegarde la valeur qu'on veut en apuyant sur le bouton save
	end
/////////////////////////////////////////////////////////////////////////
		always @(posedge clock_in) begin
		case({load_sw, stop}) 
		2'b10 : sw_out <= 1;
		2'b01 : sw_out <= 0;   ///gestion de la mise a zero et a 1 du signal de charger sw (bascule RS)
		2'b11 : sw_out <= 1;
		2'b00 : sw_out <= sw_out;
		endcase
	end
//////////////////////////////////////////////////////////////////////////////////

	always @(negedge load_sw) begin
		state_sw <= led; // on sauvegarde l'etat de led avant de charger la memmoire
	end
	
endmodule
