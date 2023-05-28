//
//  SPIDIdentityProvider.swift
//  InPA
//
//  Created by Alex Sandri on 25/05/23.
//

import Foundation

enum SPIDIdentityProvider: String, CaseIterable, Identifiable {
    var id: Self {
        return self
    }

    case aruba = "https://loginspid.aruba.it"
    case etna = "https://id.eht.eu"
    case infocamere = "https://loginspid.infocamere.it"
    case infocert = "https://identity.infocert.it"
    case lepida = "https://id.lepida.it/idp/shibboleth"
    case namirial = "https://idp.namirialtsp.com/idp"
    case poste = "https://posteid.poste.it"
    case sielte = "https://identity.sieltecloud.it"
    case spiditalia = "https://spid.register.it"
    case teamsystem = "https://spid.teamsystem.com/idp"
    case tim = "https://login.id.tim.it/affwebservices/public/saml2sso"
    
    var displayName: String {
        switch self {
        case .aruba: return "Aruba"
        case .etna: return "Etna"
        case .infocamere: return "InfoCamere"
        case .infocert: return "InfoCert"
        case .lepida: return "Lepida"
        case .namirial: return "Namirial"
        case .poste: return "Poste"
        case .sielte: return "Sielte"
        case .spiditalia: return "SpidItalia"
        case .teamsystem: return "TeamSystem"
        case .tim: return "TIM"
        }
    }
}
