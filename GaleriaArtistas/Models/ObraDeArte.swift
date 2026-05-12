// ObraDeArte.swift
// GaleriaArtistas
//
// Modelo principal que representa uma obra do acervo curitibano.

import Foundation

/// Representa uma obra de arte catalogada no acervo da galeria.
struct ObraDeArte {
    let titulo: String
    let artista: String
    let ano: Int
    let estilo: String
    let imagemNome: String
    let descricao: String
}

// Acervo Inicial
extension ObraDeArte {

    /// Conjunto fixo de obras que compõe o catálogo inicial da galeria.
    /// As imagens referenciadas em `imagemNome` devem ser adicionadas ao Assets.xcassets.
    static var acervoInicial: [ObraDeArte] {
        [
            ObraDeArte(
                titulo: "O povo brasileiro - Tingui",
                artista: "Wes Gama",
                ano: 2019,
                estilo: "Arte Urbana",
                imagemNome: "indios",
                descricao: "O artista optou por colorir as paredes com os índios após pesquisar e descobrir que, em sua origem, Curitiba tem povos indígenas – a tribo Tingui."
            ),
            ObraDeArte(
                titulo: "Fundação Cultural de Curitiba",
                artista: "Rimon Guimarães",
                ano: 2017,
                estilo: "Intervenção Urbana",
                imagemNome: "casa_hoffman",
                descricao: "A obra foi feita durante a 6ª Bienal Internacional de Arte Contemporânea de Curitiba como uma intervenção urbana que extrapola os espaços pré-definidos para exposições e vai para a rua."
            ),
            ObraDeArte(
                titulo: "Praça Rio Iguaçu",
                artista: "Lycio Esmanhoto",
                ano: 2016,
                estilo: "Muralismo",
                imagemNome: "cataratas",
                descricao: "O painel de 50 metros conta toda a história de descobrimento das Cataratas do Iguaçu, representando o Rio Iguaçu desde a nascente até o ponto que desemboca no Rio Paraná."
            ),
            ObraDeArte(
                titulo: "O mito da vida TECPUC",
                artista: "Neto Vetorello",
                ano: 2018,
                estilo: "Grafite",
                imagemNome: "tec_puc",
                descricao: "O maior mural vertical no estilo graffiti de Curitiba, enchendo de cores a paisagem da universidade."
            ),
            ObraDeArte(
                titulo: "Galeria Julio Moreira",
                artista: "João Marcos",
                ano: 2015,
                estilo: "Mural",
                imagemNome: "paulo_leminski",
                descricao: "Homenagem a um dos principais poemas do autor, que também nasceu e residiu em Curitiba."
            ),
            ObraDeArte(
                titulo: "Damasco na Siria",
                artista: "Cosmic Boys",
                ano: 2015,
                estilo: "Muralismo",
                imagemNome: "cwbsiria",
                descricao: "Mural produzido em Curitiba pelos artistas Cosmic Boys para trazer inspiração e sentimentos de liberdade, esperança e justiça, em solidariedade ao povo sírio durante o conflito na Síria."
            ),
            ObraDeArte(
                titulo: "Hospital Hélio Anjos Ortiz",
                artista: "Gardpam",
                ano: 2017,
                estilo: "Caricatura",
                imagemNome: "mafiosos",
                descricao: "De Colombo pro mundo, todos sabem quem manda na rua."
            ),
            ObraDeArte(
                titulo: "Marechal Floriano",
                artista: "Michel Devis",
                ano: 2014,
                estilo: "Crítica Social",
                imagemNome: "povo_livre",
                descricao: "Não é só com estádios que se faz o legado da Copa no Brasil."
            ),
        ]
    }
}
