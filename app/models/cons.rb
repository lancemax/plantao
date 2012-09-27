# -*- coding: utf-8 -*-
class CONS

  REQUEST = {
    :AGUARDANDO_RESPOSTA => 1,
    :ACEITO => 2, 
    :NEGADO => 3,
    :CANCELADO => 4,
    :DESISTENTE => 5,

  }

  JOB = {
    :ABERTO => 'Plantão Disponível', 
    :ENCERRADO => 'Plantão Finalizado',
    :EXCLUIDO => 'Plantão Excluído',

  }

  SHIFT = {

    :MANHA => '1',
    :TARDE => '2',
    :MANHA_TARDE => '3',
    :NOITE => '4',

  }



end