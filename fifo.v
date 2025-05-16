module fifo(
    input wire clk,
    input wire rstn,
    input wire wr_en,
    input wire rd_en,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    output full,
    output empty
);

// wr_en = 1 -> Dado no data_in é guardado na posição do buffer indicada por w_ptr
// rd_en = 1 -> Dado na posição do buffer indicada por r_ptr é enviado para data_out
// full = 1 -> Buffer está cheio, não é possível escrever
// empty = 1 -> Buffer está vazio, não é possível ler
// Profundidade de 4 posições, então 2 bits para endereçar

reg [7:0] buffer [3:0]; // Buffer de 4 posições
reg [1:0] w_ptr, r_ptr; // Ponteiros de escrita e leitura
//reg [4:0] count; // Contador de elementos no buffer
assign full = ((w_ptr + 1 == r_ptr) || (w_ptr == 3 && r_ptr == 0)); // Buffer cheio (ponteiro de escrita na posição anterior ao ponteiro de leitura)
assign empty = (w_ptr == r_ptr); // Buffer vazio (ponteiros na mesma posição)

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        w_ptr <= 2'b00; // Ponteiro de escrita na posição 0
        r_ptr <= 2'b00; // Ponteiro de leitura na posição 0
        //count <= 0; // Contador zerado
        data_out <= 8'bx; // Dado de saída indefinido
    end else begin
        if (wr_en && !full) begin
            buffer[w_ptr] <= data_in; // Armazena o dado na posição w_ptr
            w_ptr <= w_ptr + 1; // Incrementa o ponteiro de escrita
            //count <= count + 1; // Incrementa o contador
        end 
        if (rd_en && !empty) begin
            data_out <= buffer[r_ptr]; // Lê o dado da posição r_ptr
            r_ptr <= r_ptr + 1; // Incrementa o ponteiro de leitura
            //count <= count - 1; // Decrementa o contador
        end  
        if (!rd_en && empty) begin
            data_out <= data_out; // Mantém o dado de saída
        end
    end
end

// Minha primeira tentativa tentou usar um contador para controlar o tamanho do buffer, mas não funcionou.

endmodule

