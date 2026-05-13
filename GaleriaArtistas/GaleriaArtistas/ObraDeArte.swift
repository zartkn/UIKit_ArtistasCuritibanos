//
//  ObraDeArte.swift
//  GaleriaArtistas
//
//  Created by user282135 on 5/13/26.
import Foundation

/// Modelo que representa uma obra de arte do acervo curitibano.
struct ObraDeArte {
    let titulo: String
    let artista: String
    let ano: Int
    let estilo: String
    let imagemNome: String
    let descricao: String
}

extension ObraDeArte {
    
    /// Acervo completo para a galeria (requisito do PDF)
    static let acervo: [ObraDeArte] = [
        ObraDeArte(
            titulo: "O povo brasileiro - Tingui",
            artista: "Wes Gama",
            ano: 2019,
            estilo: "Arte Urbana",
            imagemNome: "indios",
            descricao: "O artista coloriu as paredes com os índios após pesquisar e descobrir que Curitiba tem origem nos povos da tribo Tingui."
        ),
        ObraDeArte(
            titulo: "Casa Hoffman",
            artista: "Rimon Guimarães",
            ano: 2017,
            estilo: "Intervenção Urbana",
            imagemNome: "casa_hoffman",
            descricao: "Intervenção feita durante a Bienal de Curitiba que extrapola os espaços de museu e vai para a rua."
        ),
        ObraDeArte(
            titulo: "Praça Rio Iguaçu",
            artista: "Lycio Esmanhoto",
            ano: 2016,
            estilo: "Muralismo",
            imagemNome: "cataratas",
            descricao: "Painel de 50 metros que conta a história do descobrimento das Cataratas do Iguaçu e do Rio Iguaçu."
        ),
        ObraDeArte(
            titulo: "O mito da vida TECPUC",
            artista: "Neto Vetorello",
            ano: 2018,
            estilo: "Grafite",
            imagemNome: "tec_puc",
            descricao: "O maior mural vertical no estilo graffiti de Curitiba, trazendo cores para a paisagem universitária."
        ),
        ObraDeArte(
            titulo: "Homenagem a Paulo Leminski",
            artista: "João Marcos",
            ano: 2015,
            estilo: "Mural",
            imagemNome: "paulo_leminski",
            descricao: "Homenagem em forma de mural a um dos maiores poetas e autores curitibanos no Largo da Ordem."
        ),
        ObraDeArte(
            titulo: "Damasco na Síria",
            artista: "Cosmic Boys",
            ano: 2015,
            estilo: "Muralismo",
            imagemNome: "cwbsiria",
            descricao: "Mural produzido em solidariedade ao povo sírio para trazer sentimentos de liberdade e esperança."
        ),
        ObraDeArte(
            titulo: "Hospital Hélio Anjos Ortiz",
            artista: "Gardpam",
            ano: 2017,
            estilo: "Caricatura",
            imagemNome: "mafiosos",
            descricao: "Arte urbana com traços de caricatura, vinda de Colombo para as ruas de Curitiba."
        ),
        ObraDeArte(
            titulo: "Marechal Floriano",
            artista: "Michel Devis",
            ano: 2014,
            estilo: "Crítica Social",
            imagemNome: "povo_livre",
            descricao: "Obra que utiliza a arte urbana como forma de crítica social na região central de Curitiba."
        )
    ]
}
